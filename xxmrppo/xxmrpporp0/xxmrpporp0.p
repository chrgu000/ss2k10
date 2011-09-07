/* xxmrpporp0.i - vender mrp po report                                       */
/* revision: 110901.1   created on: 20110901   by: zhang yun                 */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "110901.1"}
{xxmrpporpa.i}
define variable site like si_site.
define variable site1 like si_site.
define variable part like pt_part /*INITIAL "MHTA03-NE0-10-CK"*/.
define variable part1 like pt_part /*INITIAL "MHTA03-NE0-10-CK"*/.
define variable due as date.
define variable vend like vd_addr.
define variable buyer like pt_buyer INITIAL "4RSA".
define variable area as character format "x(1)".
define variable type as character format "x(1)" initial "W".
define variable typedesc as character format "x(40)".
define variable areaDesc as character format "x(40)".
define variable date1 as date.
define variable sendDate as date.
define variable qty_nextMth like pod_qty_ord.
define variable act as logical initial yes.
define variable qtytemp as decimal.
define variable qtytemp1 as decimal.
define variable crule as character.

define temp-table tmp_po
    fields tpo_nbr like po_nbr
    fields tpo_vend like vd_addr
    fields tpo_part like pt_part
    fields tpo_due  like po_due_date
    fields tpo_dte  as date
    fields tpo_flag as character
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
   act   colon 25 skip(1)

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
/* REPORT BLOCK */

{wbrp01.i}
repeat:

   if site1 = hi_char then site1 = "".
   if part1 = hi_char then part1 = "".

   if c-application-mode <> 'web' then
      update site site1 part part1 type due vend area buyer act with frame a.

   if index("W,M",type) = 0 then do:
      {pxmsg.i &MSGNUM=4211 &ERRORLEVEL=3}
      next-prompt type with frame a.
      undo,retry.
   end.


   {wbrp06.i &command = update
      &fields = " site site1 part part1 type due vend area buyer act"
      &frm = "a"}

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
               &pagedFlag = "nopage"
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
      find first vd_mstr no-lock where vd_addr = pt_vend no-error.
      /*如果有设定供应商送货方式,则优先使用供应商送货方式*/
      if available vd_mstr and vd__chr03 <> "" then do:
      	 assign crule = vd__chr03.
    	end.
    	else do:
    		 assign crule = xvp_rule.
      end.
      run getOrdDay(input pt_site, input crule,
                    input mrp_due_date,input xvp_week,
                    output date1,output sendDate).
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
               tpo_dte = date1
               tpo_qty = mrp_qty.
        if tpo_due < tpo_dte then assign tpo_flag = "0".
        else do: 
        if substring(crule,1,1) = "W" then do:
           if tpo_due >= tpo_dte and tpo_due <= tpo_dte + 6
            then assign tpo_flag = "1".
        end.
        else if substring(crule,1,1) = "M" then do:
        	 if tpo_due >= tpo_dte and tpo_due <= tpo_dte + 7
              then assign tpo_flag = "1".
           else if tpo_due >  tpo_dte + 7 and tpo_due <= tpo_dte + 15
              then assign tpo_flag = "2".
        end.
        else if substring(crule,1,1) = "O" then do:
        	 if month(tpo_due) = month(tpo_dte) then do:
        	 	  assign tpo_flag = "1".
        	 end.
        end.
        end.        
      end.
  /*    {mfrpchk.i} */
    END. /* FOR EACH PT_MSTR,XVP_CTRL,MRP_DET */

/*计算最小包装量*/
for each tmp_po exclusive-lock break by tpo_vend by tpo_part by tpo_due:
    if first-of(tpo_part) then do:
       assign qtytemp = 0
       				qtytemp1 = 1.
       find first xvp_ctrl no-lock where tpo_vend = xvp_vend and
                  tpo_part = xvp_part no-error.
       if available xvp_ctrl then do:
       		assign qtytemp1 = xvp_ord_min.
       end.
    end. 
    run MinPackQty(input tpo_qty , input qtytemp1,
                   input-output qtytemp, 
                   output tpo_qty_req). 
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

/*产生单号*/
assign areaDesc = "".
for each tmp_po exclusive-lock where tpo_qty > 0 and tpo_flag <> ""
    break by tpo_vend by tpo_flag by tpo_due:
    if first-of(tpo_flag) then do:
       run getPoNumber(input today,input tpo_vend,output areaDesc).
    end.
    assign tpo_nbr = areaDesc.
end.
assign areaDesc = "".

export delimiter "~011" getTermLabel("PO_NUMBER",12)
                        getTermLabel("SUPPLIER",12)
                        getTermLabel("ITEM_NUMBER",12)
                        getTermLabel("DUE_DATE",12)
                        getTermLabel("RECEIVED_QTY",12)
                        getTermLabel("MRP_QUANTITY",12)
                        getTermLabel("STANDARD_PACK",12)
                        getTermLabel("MONTH_GUIDE1",12)
                        getTermLabel("MONTH_GUIDE2",12)
                        getTermLabel("WEEK",12).
for each tmp_po no-lock where tpo_nbr <> "" or not act,
    each xvp_ctrl no-lock where tpo_vend = xvp_vend and tpo_part = xvp_part:
    export delimiter "~011" tpo_nbr tpo_vend tpo_part tpo_due tpo_qty_req
                            tpo_qty xvp_ord_min tpo_qty_mth1 tpo_qty_mth2
                            weekday(tpo_due) - 1.
end.

/* REPORT TRAILER  */
/*   {mfrtrail.i} */
  {mfreset.i}

end.

{wbrp04.i &frame-spec = a}

FUNCTION i2c RETURNS CHARACTER (iNumber AS INTEGER):
/*------------------------------------------------------------------------------
    Purpose: 将数字转换为0~9,a~z.
      Notes: 输入的数字在0-36之间MOUELO.
------------------------------------------------------------------------------*/
    assign iNumber = iNumber MODULO 36.
    IF iNumber < 10 THEN
       RETURN CHR(48 + iNumber).
    ELSE
       RETURN CHR(87 + iNumber).
END FUNCTION.

PROCEDURE getPoNumber:
/*------------------------------------------------------------------------------
    Purpose: 计算PO单号
      Notes:
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER iDate AS DATE.
  DEFINE INPUT PARAMETER iVendor LIKE VD_ADDR.
  DEFINE OUTPUT PARAMETER oNbr as character.

  DEFINE Variable intI as integer.

  find first vd_mstr no-lock where vd_addr = ivendor no-error.
  if available vd_mstr then do:
     assign oNbr = substring(vd_sort,1,2).
  end.
  else do:
     assign oNbr = substring(iVendor,1,2).
  end.
  assign oNbr = "P" + i2c(YEAR(iDate) - 2010) + i2c(month(iDate)) + oNbr.
 /*******************
  find last po_mstr no-lock where po_nbr begins oNbr no-error.
  if available po_mstr then do:
      find first qad_wkfl exclusive-lock where qad_key1 = "xxmrpporp0.p" and
                  qad_key2 = oNbr no-error.
      if available qad_wkfl then do:
         assign qad_intfld[1] = integer(substring(po_nbr,6))
                qad_key3 = substring(po_nbr,6).
      end.
  end.
  else do:
        find first qad_wkfl exclusive-lock where qad_key1 = "xxmrpporp0.p" and
                  qad_key2 = oNbr no-error.
        if not available qad_wkfl then do:
            create qad_wkfl.
            assign qad_key1 = "xxmrpporp0.p"
                   qad_key2 = oNbr.
        end.
        assign qad_intfld[1] = 0
               qad_key3 = "0".
  end.
  **********/
  find first qad_wkfl exclusive-lock where qad_key1 = "xxmrpporp0.p" and
       qad_key2 = oNbr no-error.
  if available qad_wkfl then do:
     assign intI = qad_intfld[1] + 1
            qad_intfld[1] = qad_intfld[1] + 1
            qad_key3 = string(qad_intfld[1] + 1).
  end.
  else do:
      create qad_wkfl.
      assign qad_key1 = "xxmrpporp0.p"
             qad_key2 = oNbr
             qad_intfld[1] = 0
             qad_key3 = "0".
  end.
  release qad_wkfl.
  assign oNbr = oNbr + substring("0000" + string(inti),
                       length("0000" + string(inti)) - 2).
END PROCEDURE.

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
  define variable vdate1 as date.
  define variable vdate2 as date.
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
     startDay = startDay + integer(ENTRY(1 , vrule , ",")) - 1
              + (iWeek - 1) * 7.
     oDateStart = startDay.
     IF idate <= startDay THEN DO:
         ASSIGN odate = idate.
     END.
     ELSE DO:
        odate = idate.
        REPEAT:
            if index(irule,string(weekday(odate) - 1,"9")) > 0 then leave.
            odate = odate - 1.
        END.
     END.
  end.  /* if substring(iRule,1,1) = "W" then do: */
  else if substring(iRule,1,1) = "M" then do:
		 	 assign vdate1 = date(month(idate),1,year(idate)).
		 	 REPEAT:
     	      if index(entry(2,irule,";"),string(weekday(vdate1) - 1,"9")) > 0
     	      then leave.
     	      vdate1 = vdate1 + 1.
     	 END.
     	 assign odatestart = vdate1.
     	 assign vdate2 = date(month(vdate1),28,year(vdate1)) + 5.
     	 assign vdate2 = date(month(vdate2),1,year(vdate2)).
		 	 REPEAT:
     	      if index(entry(2,irule,";"),string(weekday(vdate2) - 1,"9")) > 0
     	      then leave.
     	      vdate2 = vdate2 + 1.
     	 END. 
     	 
     	 if substring(entry(1,irule,","),2,1) = "1" then do:
     	    if idate >= vdate1 and idate < vdate2 then do:
     	    	 assign odate = date1.
     	    end.     
       end.  
       else if substring(entry(1,irule,","),2,1) = "2" then do:
       		if idate >= vdate1 and idate <= vdate1 + 13 then do:
       			 assign odate = vdate1.
       		end.
       		else if idate > vdate1 + 13 and idate < vdate2 then do:
       			 assign odate = vdate1 + 14.
       		end.
       end.
  end.  /* if substring(iRule,1,1) = "M" then do: */
  else if substring(irule,1,1) = "O" then do:
  		assign odatestart = date(month(today),28,year(today)) + 5.
  		assign odatestart = date(month(odatestart),1,year(odatestart)).
  		assign odate = idate.
  end.
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
