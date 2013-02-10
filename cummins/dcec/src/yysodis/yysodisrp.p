/* yysalesdiscrp.p - sales discount report */
/* ss - 121024.1 by: Steven */

/*-Revision end-------------*/

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "121024.1"}

/* ********** Begin Translatable Strings Definitions ********* */
define variable entity          as   char            no-undo.
define variable entity1         as   char            no-undo.
define variable effdate         as   date            no-undo.
define variable effdate1        as   date            no-undo initial today.
define variable yn              as   logical         no-undo.
define variable dte             as   date            no-undo.

define variable ym as character extent 12 no-undo.

define temp-table tt_temp
       field  tt_cust      like so_cust
       field  tt_part      like pt_part
       field  tt_desc      like pt_desc1
       field  tt_ym        as   char     extent 12
       field  tt_per_amt   as   deci     extent 12 format "->>,>>>,>>9.99"
       field  tt_qty       as   deci     extent 12 format "->>,>>>,>>9.99"
       field  tt_amt       as   deci     extent 12 format "->>,>>>,>>9.99"
       index  tt_idx
              tt_cust
              tt_part.

/* define Excel object handle */
 DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
 DEFINE VARIABLE chExcelWorkbook AS COM-HANDLE.
 DEFINE VARIABLE chWorkSheet AS COM-HANDLE.
 define variable excel_row as integer init 1.
 define variable excel_col as integer init 1.

 define variable totalamt as   deci.
 define variable i        as   int.
 define variable j        as   int.

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
assign effdate = date(1,1,2012)
			 EFFDATE1 = date(11,30,2012).
FORM
   skip(1)
   entity  colon 20 label "会计单位"  entity1  colon 50 label {t001.i} skip
   effdate colon 20 label "生效日期"  effdate1 colon 50 label {t001.i} skip
   skip(1)
with frame a side-labels width 80  THREE-D title "主营收入折扣计算" /*GUI*/.

setFrameLabels(frame a:handle).
/* REPORT BLOCK */

{wbrp01.i}

repeat:
    if effdate  = low_date then effdate = ?.
    if effdate1 = hi_date  then effdate1 = ?.
    if entity1 = hi_char then entity1 = "".
  assign ym = "".
    EMPTY TEMP-TABLE tt_temp NO-ERROR.
    update entity  entity1
           effdate effdate1
    with frame a.

       assign dte = effdate1.
   do i = 1 to 12:
      assign dte = date(month(dte),1,year(dte)).
        assign ym[13 - i] = string(year(dte),"9999") + "-" + string(month(dte),"99").
        ASSIGN dte = dte - 1.
   end.
   ASSIGN dte = dte + 1.

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      {mfquoter.i entity    }
      {mfquoter.i entity1   }
      {mfquoter.i effdate   }
      {mfquoter.i effdate1  }
      if effdate = ?  then effdate  = date('01/01/' + string(year(today))).
      if effdate1 = ? then effdate1 = date('01/01/' + string(year(today) + 1)) - 1.
      if entity1 = "" then entity1 = hi_char.
   end.
   {gpselout.i &printType = "printer"
               &printWidth = 132
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
               &defineVariables = "yes"
   }

   {mfphead.i}

    for each tr_hist no-lock where tr_domain = global_domain
       and tr_effdate >= dte and tr_effdate <= effdate1
       and (tr_type = 'ISS-SO' or tr_type = 'CN-USE') 
       		break by tr_part by month(tr_effdate):
        FIND FIRST tt_temp EXCLUSIVE-LOCK WHERE tt_cust = tr_addr
               AND tt_part = tr_part NO-ERROR.
        IF NOT AVAILABLE tt_temp THEN DO:
            CREATE tt_temp.
            ASSIGN tt_cust = tr_addr
                   tt_part = tr_part.
        END.
        find first pt_mstr no-lock where pt_domain = global_domain 
        		   and pt_part = tr_part no-error.
        if available pt_mstr then do:
        	 assign tt_desc = pt_desc1.
				end.
				tt_qty[month(tr_effdate)] = tt_qty[month(tr_effdate)] + (-1 * tr_qty_loc).
				if last-of(month(tr_effdate)) then do:
				   find first yp_mstr no-lock where yp_domain = global_domain and 
				   					 yp_part = tr_part and 
				   					 (yp_start <= tr_effdate or yp_start = ?) and 
				   					 (yp_expir >= tr_effdate or yp_expir = ?) no-error.
				   if available yp_mstr then do:
				   	  assign tt_per_amt[i] = yp_amt[1].
			     	  do i = 15 to 2:
			     	     if yp_min_qty[i] <= tt_qty[month(tr_effdate)] 
			     	     		and yp_min_qty[i] > 0 then 
			     	  	 assign tt_per_amt[i] = yp_amt[i].
			     	  	 leave.
			     	  end.
			     end.
			  end.
/***************** 
        assign j = 0.
        DO i = 1 TO 12:
            IF ym[i] = string(year(tr_effdate),"9999") + "-"
                     + string(month(tr_effdate),"99") THEN DO:
              ASSIGN tt_qty[i] = tt_qty[i] + tr_qty_loc.
              assign j = i.
              leave.
            END.
        END.

         find first yysales_disc where yysalesdisc_domain = global_domain
                and yysalesdisc_cust = tr_addr 
                and (yysalesdisc_prod_line = tr_part or yysalesdisc_prod_line = pt_prod_line
                     or yysalesdisc_prod_line = pt_draw or yysalesdisc_prod_line = pt_drwg_loc)
                and tr_effdate >= yysalesdisc_effdate and tr_effdate <= yysalesdisc_due_date  
          no-lock no-error.
         if available yysales_disc then do:
            if j <> 0 and (-1 * tr_qty_loc) >= yysalesdisc_min_qty[1] then do:
                assign tt_per_amt[j] = yysalesdisc_amt[1].
            end.
         end.
        end.
***************/        
    END.
/*		find first yp_mstr no-lock where yp_domain = global_domain and         */
/*									 yp_part = tr_part and                                   */
/*									 (yp_start <= tt_date or yp_start = ?) and               */
/*									 (yp_expir >= tt_date or yp_expir = ?) no-error.         */
/*				if available yp_mstr then do:                                      */
/*			  	                                                                 */
/*			  end.                                                               */
/*	  end.                                                                   */
    for each tt_temp exclusive-lock:
        do i = 1 to 12:
           assign tt_amt[i] = tt_per_amt[i] * tt_qty[i].
        end.
    end.

  for each tt_temp:
  	  display tt_temp with width 300 stream-io.
  end.
 
   CREATE "Excel.Application" chExcelApplication.
   chExcelWorkbook = chExcelApplication:Workbooks:add().
   chWorkSheet = chExcelApplication:Sheets:Item(1).
   excel_row = 1.
   excel_col = 1.
   chWorkSheet:cells(1,6) = " ".
   excel_row = 1.
   excel_col = 1.

   chWorkSheet:cells(excel_row,excel_col) = "客户代码".
   excel_col = excel_col + 1.
   chWorkSheet:cells(excel_row,excel_col) = "零件号".
   excel_col = excel_col + 1.
   chWorkSheet:cells(excel_row,excel_col) = "零件描述".
   do i = 1 to 12 :
      excel_col = excel_col + 1.
      chWorkSheet:cells(excel_row,excel_col)
      = "数量 " + ym[i].
      excel_col = excel_col + 1.
      chWorkSheet:cells(excel_row,excel_col)
      = "折扣/台 "  + ym[i].
      excel_col = excel_col + 1.
      chWorkSheet:cells(excel_row,excel_col)
      = "当月折扣 "  + ym[i].
   end.
   excel_col = excel_col + 1.
   chWorkSheet:cells(excel_row,excel_col) = "当年累计调整额".

   for each tt_temp no-lock:
      excel_row = excel_row + 1.
      excel_col = 1.
      chWorkSheet:cells(excel_row,excel_col) = "'" + tt_cust.
      excel_col = excel_col + 1.
      chWorkSheet:cells(excel_row,excel_col) = "'" + tt_part.
      excel_col = excel_col + 1.
      chWorkSheet:cells(excel_row,excel_col) = "'" + tt_desc.
      totalamt = 0.
      do i = 1 to 12 :
         excel_col = excel_col + 1.
         chWorkSheet:cells(excel_row,excel_col) = abs(tt_qty[i]).
         excel_col = excel_col + 1.
         chWorkSheet:cells(excel_row,excel_col) = tt_per_amt[i].
         excel_col = excel_col + 1.
         chWorkSheet:cells(excel_row,excel_col) = abs(tt_qty[i]) * tt_per_amt[i].
         totalamt = totalamt + abs(tt_qty[i]) * tt_per_amt[i].
      end.
      excel_col = excel_col + 1.
      chWorkSheet:cells(excel_row,excel_col) = totalamt.
   end.
   chExcelApplication:visible = true.
   RELEASE OBJECT chExcelWorkbook.
   RELEASE OBJECT chExcelApplication.
   RELEASE OBJECT chWorkSheet.
/******end tx01 ********/
   {mfrtrail.i}
   hide message no-pause.
   {pxmsg.i &MSGNUM=9 &ERRORLEVEL=1}
end.
