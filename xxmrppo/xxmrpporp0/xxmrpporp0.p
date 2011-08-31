/* xxmrpporp0.i - vender mrp po report                                       */
/* revision: 110830.1   created on: 20110830   by: zhang yun                 */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "110830.1"}

define variable site like si_site.
define variable site1 like si_site.
define variable part like pt_part.
define variable part1 like pt_part.
define variable due as date.
define variable vend like vd_addr.
define variable buyer like pt_buyer.
define variable area as character format "x(1)".
define variable type as character format "x(1)" initial "W".
define variable typedesc as character format "x(40)".
define variable areaDesc as character format "x(40)".
define variable date1 as date.
define variable sendDate as date.
define variable qty_nextMth like pod_qty_ord.

define temp-table tmp_po
    fields tpo_nbr like po_nbr
    fields tpo_vend like vd_addr
    fields tpo_part like pt_part
    fields tpo_due  like po_due_date
    fields tpo_qty like pod_qty_ord
    fields tpo_qty_req like pod_qty_ord
    fields tpo_qty_mth1 like pod_qty_ord
    fields tpo_qty_mth2 like pod_qty_ord
    index tpo_part_vend is primary tpo_part tpo_vend tpo_due.

DEFINE TEMP-TABLE tmp_int
    FIELDS ti_bk AS CHARACTER
    FIELDS ti_int AS INTEGER
    INDEX ti_bi ti_bk ti_int.

DEFINE TEMP-TABLE tmp_date
    FIELDS td_start AS DATE
    FIELDS td_end AS DATE
    INDEX td_start td_start.
/* SELECT FORM */
form
   site  colon 15
   site1 label {t001.i} colon 49 skip
   part  colon 15
   part1 label {t001.i} colon 49 skip(1)
   type  colon 25 typeDesc no-label
   due   colon 25
   vend  colon 25
   area  colon 25 areaDesc no-label
   buyer colon 25 skip(1)

with frame a side-labels width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
assign typeDesc = getTermLabel("XVP_TYPE_DESC",40).
assign areaDesc = getTermLabel("XVP_AREA_DESC",40).
display typeDesc areaDesc with frame a.
assign due = date(month(today),28,year(today)).
assign due = date(month(due + 5),1,year(due + 5)) - 1.
find first si_mstr no-lock no-error.
if available si_mstr then do:
   assign site = si_site
          site1 = si_site.
end.
assign buyer = "4RSA".
/* REPORT BLOCK */

{wbrp01.i}
repeat:

   if site1 = hi_char then site1 = "".
   if part1 = hi_char then part1 = "".

   if c-application-mode <> 'web' then
      update site site1 part part1 type due vend area buyer with frame a.

   if index("W,M",type) = 0 then do:
      {pxmsg.i &MSGNUM=4211 &ERRORLEVEL=3}
      next-prompt type with frame a.
      undo,retry.
   end.


   {wbrp06.i &command = update
      &fields = " site site1 part part1 type due vend area buyer " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      {mfquoter.i site }
      {mfquoter.i site1}
      {mfquoter.i part }
      {mfquoter.i part1}
      {mfquoter.i type }
      {mfquoter.i due  }
      {mfquoter.i vend }
      {mfquoter.i buyer}

      if site1 = "" then site1 = hi_char.
      if part1 = "" then part1 = hi_char.

   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 240
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
  /* {mfphead.i} */
  empty temp-table tmp_po no-error.

   FOR EACH pt_mstr no-lock where
            pt_part >= part and pt_part <= part1 and
            substring(pt_part,1,1) <> "X"
            and (pt_buyer = buyer or buyer = "")
            and pt_site >= site and (pt_site <= site1 or site1 = ""),
       EACH xvp_ctrl where xvp_part = pt_part and
            substring(xvp_rule,1,1) = type and
           (xvp_vend = vend or vend = "" ) and
           (substring(xvp_vend,1,1) = area or area = ""),
       EACH mrp_det WHERE mrp_part = pt_part and
            mrp_due_date <= (Due + 30) and
            mrp_detail = "计划单" USE-INDEX mrp_part:
      run getOrdDay(input pt_site, input xvp_rule,
                    input mrp_due_date,input xvp_week,
                    output date1,output sendDate).
      /* SET EXTERNAL LABELS */
      find first tmp_po exclusive-lock where tpo_part = mrp_part
             and tpo_vend = xvp_vend and tpo_due = sendDate no-error.
      if available tmp_po then do:
         assign tpo_qty = tpo_qty + mrp_qty.
      end.
      else do:
        create tmp_po.
        assign tpo_vend = xvp_vend
               tpo_part = pt_part
               tpo_due = sendDate
               tpo_qty = mrp_qty.
      end.
  /*    {mfrpchk.i} */
    END. /* FOR EACH PT_MSTR,XVP_CTRL,MRP_DET */

/*计算最小包装量*/
for each tmp_po exclusive-lock:
    find first xvp_ctrl no-lock where tpo_vend = xvp_vend and
               tpo_part = xvp_part no-error.
    if available xvp_ctrl then do:
       IF tpo_qty MODULO xvp_ord_min = 0 then do:
            assign tpo_qty_req =
                  (truncate(tpo_qty / xvp_ord_min,0)) * xvp_ord_min.
       end.
       else do:
            assign tpo_qty_req =
                  (truncate(tpo_qty / xvp_ord_min,0) + 1) * xvp_ord_min.
       end.
    end.
end.

/*计算下月预示*/
assign sendDate = date(month(today),28,year(today)) + 5.
FOR EACH pt_mstr no-lock where
         pt_part >= part and pt_part <= part1 and
         substring(pt_part,1,1) <> "X"
         and (pt_buyer = buyer or buyer = "")
         and pt_site >= site and (pt_site <= site1 or site1 = ""),
    EACH xvp_ctrl where xvp_part = pt_part and
          substring(xvp_rule,1,1) = type and
         (xvp_vend = vend or vend = "" ) and
         (substring(xvp_vend,1,1) = area or area = ""),
    EACH mrp_det WHERE mrp_part = pt_part and
         mrp_due_date <= (Due + 120) and
         month(mrp_due_date) = month(sendDate) and
         mrp_detail = "计划单" USE-INDEX mrp_part
    break by xvp_vend by mrp_part:
    if first-of(mrp_part) then do:
       assign qty_nextMth = 0.
    end.
       assign qty_nextMth = qty_nextMth + mrp_qty.
    if last-of(mrp_part) then do:
       if qty_nextMth > 0 then do:
          if can-find(first tmp_po where tpo_vend = xvp_vend
                       and tpo_part = mrp_part) then do:
             for each tmp_po exclusive-lock where tpo_vend = xvp_vend
                       and tpo_part = mrp_part:
                 assign tpo_qty_mth1 = qty_nextMth.
             end.
          end.
          else do:
             create tmp_po.
             assign tpo_vend = xvp_vend
                    tpo_part = pt_part
                    tpo_due = date(month(sendDate),1,year(sendDate))
                    tpo_qty = 0
                    tpo_qty_mth1 = qty_nextMth.
          end.
       end.
    end.
END.

/*计算下下月预示*/
assign sendDate = sendDate + 31.
FOR EACH pt_mstr no-lock where
         pt_part >= part and pt_part <= part1 and
         substring(pt_part,1,1) <> "X"
         and (pt_buyer = buyer or buyer = "")
         and pt_site >= site and (pt_site <= site1 or site1 = ""),
    EACH xvp_ctrl where xvp_part = pt_part and
          substring(xvp_rule,1,1) = type and
         (xvp_vend = vend or vend = "" ) and
         (substring(xvp_vend,1,1) = area or area = ""),
    EACH mrp_det WHERE mrp_part = pt_part and
         mrp_due_date <= (Due + 120) and
         month(mrp_due_date) = month(sendDate) and
         mrp_detail = "计划单" USE-INDEX mrp_part
    break by xvp_vend by mrp_part:
    if first-of(mrp_part) then do:
       assign qty_nextMth = 0.
    end.
       assign qty_nextMth = qty_nextMth + mrp_qty.
    if last-of(mrp_part) then do:
       if qty_nextMth > 0 then do:
          if can-find(first tmp_po where tpo_vend = xvp_vend
                       and tpo_part = mrp_part) then do:
             for each tmp_po exclusive-lock where tpo_vend = xvp_vend
                       and tpo_part = mrp_part:
                 assign tpo_qty_mth2 = qty_nextMth.
             end.
          end.
          else do:
             create tmp_po.
             assign tpo_vend = xvp_vend
                    tpo_part = pt_part
                    tpo_due = date(month(sendDate),1,year(sendDate))
                    tpo_qty = 0
                    tpo_qty_mth2 = qty_nextMth.
          end.
       end.
    end.
END.
export delimiter "~011" getTermLabel("PO_NUMBER",12)
                        getTermLabel("SUPPLIER",12)
                        getTermLabel("ITEM_NUMBER",12)
                        getTermLabel("DUE_DATE",12)
                        getTermLabel("QUANTITY_RECEIVED",12)
                        getTermLabel("QUANTITY",12)
                        getTermLabel("STANDARD_PACK",12)
                        getTermLabel("MONTH_GUIDE1",12)
                        getTermLabel("MONTH_GUIDE2",12)
                        skip.
for each tmp_po no-lock,
    each xvp_ctrl no-lock where tpo_vend = xvp_vend and tpo_part = xvp_part:
    export delimiter "~011" tpo_nbr tpo_vend tpo_part tpo_due tpo_qty_req
                            tpo_qty xvp_ord_min tpo_qty_mth1 tpo_qty_mth2.
end.

/* REPORT TRAILER  */
/*   {mfrtrail.i} */
  {mfreset.i}

end.

{wbrp04.i &frame-spec = a}

procedure getOrdDay:
/*------------------------------------------------------------------------------
    Purpose: 获取送货日期
      Notes: 如果计算出的日期为非工作日则提前到第一个非工作日.
------------------------------------------------------------------------------*/
  define input parameter isite like si_site.
  define input parameter iRule as character.
  define input parameter iDate as date.
  define input parameter iWeek as integer.
  define output parameter oDateStart as date.
  define output parameter oDate as Date.

  define variable startday as date.
  define variable vrule as character.
  DEFINE VARIABLE i AS INTEGER.
  DEFINE VARIABLE j AS INTEGER.
/*   define variable i as integer. */
/*   DEFINE VARIABLE j AS INTEGER. */

  ASSIGN vrule = substring(iRule,2).

  if substring(iRule,1,1) = "W" then do:
     IF WEEKDAY(TODAY) = 2 THEN DO:
         ASSIGN startDay = TODAY + 7.
     END.
     ELSE DO:
         startDay = TODAY.
         REPEAT:
             IF weekday(startDay) = 2 THEN DO:
                 LEAVE .
             END.
             startDay = startDay + 1.
         END.
     END.
     startDay = startDay + integer(ENTRY(1 , vrule , ",")) - 1.
     oDateStart = startDay.
     IF idate <= startDay THEN DO:
         ASSIGN odate = idate.
     END.
     ELSE DO:
        odate = idate.
        repeat-label01:
        REPEAT:
            ASSIGN vrule = substring(iRule,2).
            REPEAT:
                IF INTEGER(substring(vrule,1,INDEX(vrule,",") - 1)) =
                   weekday(odate) - 1 THEN DO:
                   LEAVE repeat-label01.
                END.
                ASSIGN vrule = SUBSTRING(vrule,INDEX(vrule,",") + 1).
                IF INDEX(vrule,",") = 0 THEN LEAVE.
            END.
            IF INTEGER(vRule) = WEEKDAY(odate) - 1 THEN LEAVE.
            odate = odate - 1.
        END.
     END.
  end.  /* if substring(iRule,1,1) = "W" then do: */
  else if substring(iRule,1,1) = "M" then do:
      if month(idate) = month(today) then do:
         assign odate = idate.
         assign oDateStart = date(month(today),28,year(today)).
         assign oDateStart = date(month(oDateStart + 5),1,year(oDateStart + 5)).
      end.
      else do:
      EMPTY TEMP-TABLE tmp_int NO-ERROR.
      EMPTY TEMP-TABLE tmp_date NO-ERROR.
      REPEAT:
          ASSIGN i = integer(SUBSTRING(vrule,1,INDEX(vrule,",") - 1)).
          CREATE tmp_int.
          ASSIGN ti_bk = "A"
                 ti_int = i.

          vrule = SUBSTRING(vrule,INDEX(vrule,",") + 1).
          IF INDEX(vrule,",") = 0 THEN DO:
              ASSIGN i = integer(SUBSTRING(vrule,1,INDEX(vrule,",") - 1)) .
              CREATE tmp_int.
              ASSIGN ti_bk = "A"
                     ti_int = i.
              LEAVE.
          END.
      END.

      FOR EACH tmp_int BREAK BY ti_bk BY ti_int:
          IF FIRST-OF(ti_bk) THEN DO:
              CREATE tmp_date.
              ASSIGN td_end = DATE(MONTH(idate), ti_int,YEAR(idate)).
          END.
          CREATE tmp_date.
          ASSIGN td_start = DATE(MONTH(idate), ti_int,YEAR(idate)).

      END.
      FOR EACH tmp_date EXCLUSIVE-LOCK:
          FIND FIRST tmp_int WHERE ti_int > DAY(td_start) NO-ERROR.
          IF AVAILABLE(tmp_int) THEN DO:
              ASSIGN td_end = DATE(MONTH(td_start),ti_int,YEAR(td_start)).
          END.
      END.
      FOR EACH tmp_date EXCLUSIVE-LOCK WHERE td_start = ?:
          FIND LAST tmp_int NO-ERROR.
          IF AVAILABLE tmp_int THEN DO:
             ASSIGN td_start = date(month(td_end - DAY(td_end)), ti_int,
                               YEAR(td_end - DAY(td_end))).
          END.
      END.
      FOR EACH tmp_date EXCLUSIVE-LOCK WHERE td_end = ?:
          FIND FIRST tmp_int NO-ERROR.
          IF AVAILABLE tmp_int THEN DO:
             ASSIGN td_end = date(MONTH(td_start),28,YEAR(td_start)).
             ASSIGN td_end = DATE(MONTH(td_end + 5),ti_int,YEAR(td_end + 5)).
          END.
      END.
      FOR EACH tmp_date EXCLUSIVE-LOCK:
          ASSIGN td_end = td_end - 1.
      END.
      FIND FIRST tmp_date WHERE idate >= td_start AND idate <= td_end NO-ERROR.
      IF AVAILABLE tmp_date THEN DO:
          ASSIGN odate = td_start.
      END.
      end. /*if month(idate) = month(today) else do:*/
  end.  /* if substring(iRule,1,1) = "M" then do: */
      /* 如果送货日期为节假日则提前到上一个工作日 */
  REPEAT: /*假日*/
     IF CAN-FIND(FIRST hd_mstr NO-LOCK WHERE
                       hd_site = isite AND hd_date = odate) THEN DO:
        ASSIGN odate = odate - 1.
     END.
     ELSE DO:
         LEAVE.
     END.
  END. /* REPEAT: 假日*/
  if odate < today then do:
     assign odate = today.
  end.
end procedure.
