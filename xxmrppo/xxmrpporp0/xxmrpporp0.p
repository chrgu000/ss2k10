/* xxmrpporp0.i - vender mrp po report                                       */
/* revision: 110826.1   created on: 20110826   by: zhang yun                 */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "110826.1"}

define variable site like si_site.
define variable site1 like si_site.
define variable part like pt_part.
define variable part1 like pt_part.
define variable due as date.
define variable vend like vd_addr.
define variable buyer like pt_buyer.
define variable type as character format "x(1)" initial "W".
define variable typedesc as character format "x(20)".
define variable date1 as date.
define variable sendDate as date.

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
   buyer colon 25 skip(1)
   
with frame a side-labels width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
assign typeDesc = getTermLabel("XVP_TYPE_DESC",24).
display typeDesc with frame a.
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
      update site site1 part part1 type due vend buyer with frame a.
	 
	 if index("W,M",type) = 0 then do:
	 	  {pxmsg.i &MSGNUM=4211 &ERRORLEVEL=3}
	 	  next-prompt type with frame a.
	 	  undo,retry.
	 end.	

		
   {wbrp06.i &command = update
      &fields = " site site1 part part1 type due vend buyer " &frm = "a"}

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
   {mfphead.i}

   FOR EACH pt_mstr no-lock where
            pt_part >= part and pt_part <= part1 and 
            substring(pt_part,1,1) <> "X"
            and (pt_buyer = buyer or buyer = "")
            and pt_site >= site and (pt_site <= site1 or site1 = ""),
       EACH xvp_ctrl where xvp_part = pt_part and
       		  substring(xvp_rule,1,1) = type and 
       		 (xvp_vend = vend or vend = ""),
       EACH mrp_det WHERE mrp_part = pt_part and 
       	    mrp_due_date <= (Due + 30) and
            mrp_detail = "�ƻ���" USE-INDEX mrp_part
    with frame b width 240:
      setFrameLabels(frame b:handle).
			run getOrdDay(input pt_site, input xvp_rule, 
									  input mrp_due_date,input xvp_week,
									  output date1,output sendDate).
      /* SET EXTERNAL LABELS */
      display pt_part xvp_vend mrp_qty mrp_due_date sendDate xvp_rule.

      {mfrpchk.i}

    END. /* FOR EACH PT_MSTR,XVP_CTRL,MRP_DET */

   /* REPORT TRAILER  */
   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}

procedure getOrdDay:
/*------------------------------------------------------------------------------
    Purpose: ��ȡ�ͻ�����
      Notes: ��������������Ϊ�ǹ���������ǰ����һ���ǹ�����.
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
      /* ����ͻ�����Ϊ�ڼ������Ƶ���һ�������� */
  REPEAT: /*����*/
     IF CAN-FIND(FIRST hd_mstr NO-LOCK WHERE
                       hd_site = isite AND hd_date = odate) THEN DO:
        ASSIGN odate = odate - 1.
     END.
     ELSE DO:
         LEAVE.
     END.
  END. /* REPEAT: ����*/
	if odate < today then do:
		 assign odate = today.
  end.
end procedure.
