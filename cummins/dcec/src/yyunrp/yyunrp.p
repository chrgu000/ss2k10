 /*yyunrp.p  - UNPLANNED RECEIPTS PRINT                               */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* V1                 Developped: 07/14/01      BY: Kang Jian          */
/* V4  Date:08/09/02 By:KangJian  *Print serial number* */
 /*Revision: Eb2 + sp7       Last modified: 08/05/2005             By: Judy Liu   */

	  {mfdtitle.i "121114.1"} 
	  define variable cur_nbr like tr_nbr.
	  define variable nbr like tr_nbr.
	  define variable part like tr_part.
	  define variable eff_date like tr_effdate.
	  define variable so_job like tr_so_job.
	  define variable nbr1 like tr_nbr.
	  define variable part1 like tr_part.
	  define variable eff_date1 like tr_effdate.
	  define variable so_job1 like tr_so_job. 
/*Jch*/  define variable site1 like tr_site initial "DCEC-B".
/*Jch*/  define variable site2 like tr_site initial "DCEC-C".
	  define variable so_rmks1 like tr_rmks.
	  define variable so_rmks like tr_rmks.
        define variable duplicate as char.
        define variable pageno as integer.
/*      define variable page_start as integer.
        define variable page_end as integer.*/
        define variable i as integer.
        define variable QTY as integer.
        def var flag1 as logical label "只打印未打印过的出入库单".
/*judy 05/08/05*/ DEFINE VARIABLE keeper AS CHAR.
/*judy 05/08/05*/ DEFINE VARIABLE keeper1 AS CHAR.

QTY=0.    
flag1 = yes.                   
form  "计划外出库单" at 33 
     duplicate   no-labels at 1
     pageno        label "页号: "   at 1 
     tr_nbr        label "出库单号:  "    at 40
     tr_so_job      label "原因代码:   " at 1 skip(1)
     "零件号           零件名称               出库数量    日期    库位       保管员  流水号            地点      备注 "
     skip "-------------------------------------------------------------------------------------------------------------------------"
     with no-box side-labels width 180 frame b.

form   "计划外入库单" at 33 
     duplicate   no-labels at 1
     pageno        label "页号: "   at 1 
     tr_nbr        label "入库单号:  "    at 40
     tr_so_job     label "原因代码:   " at 1 skip(1)
     "零件号           零件名称               入库数量    日期    库位       保管员  流水号            地点       备注 "
     skip "-------------------------------------------------------------------------------------------------------------------------"
     with no-box side-labels width 180 frame b2.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

	  FORM /*GUI*/ 
	     
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
nbr       colon 18 label "从订单号"
NBR1      label "到订单号" COLON  48  skip 
eff_date  label "从生效日期"     colon 18
EFF_DATE1  LABEL "到生效日期"  COLON 48 SKIP
so_job    LABEL "从原因代码"    colon 18
SO_JOB1  LABEL "到原因代码" COLON 48  skip
so_rmks label "从备注"  colon 18
so_rmks1 label "到备注" colon 48 skip
site1    label "从地点" colon 18
site2    label "到地点" colon 48 skip
/*judy 05/08/05*/ keeper COLON 18 keeper1 COLON 48 LABEL {t001.i} SKIP

flag1   colon 36 label "只打印未打印过的计划外出入库单"
/*judy 05/08/05*/ SKIP (.4)

with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.
 

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = " 选择条件 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

           /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).
/*K0ZX*/ {wbrp01.i}
	  /* REPORT BLOCK */

	  
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

/*j034*/ if nbr1  = hi_char then nbr1  = "".
/*J034*/ if eff_date1 = hi_date then eff_date1 = ?.
/*J034*/ if so_job1  = hi_char then so_job1 = "".
				 if site2 = hi_char then site2 = "".
/*J034*/ if eff_date = low_date then eff_date = ?.
/*J034*/ if so_rmks1 = hi_char then so_rmks1 = "".	     
/*judy 05/08/05*/ IF keeper1 = hi_char THEN keeper1 = "".
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:

	     bcdparm = "".

	     {mfquoter.i nbr}
    	     {mfquoter.i nbr1}
	     {mfquoter.i eff_date}
	     {mfquoter.i eff_date1}
	     {mfquoter.i so_job}
	     {mfquoter.i so_job1}
	     {mfquoter.i so_rmks}
	     {mfquoter.i so_rmks1}
/*judy 05/08/05*/ {mfquoter.i keeper}
/*judy 05/08/05*/ {mfquoter.i keeper1}
        {mfquoter.i flag1}
	     




/*J0VG *** MOVED TO BELOW QUOTER CALLS - CAUSED PROBLEMS HERE ***************/
/*J034* ** MOVED HI_ VALUES SETTINGS + SITE RANGE CHECK ABOVE QUOTER CALLS */

/*J034*/ if nbr1  = "" then nbr1  = hi_char.
/*J034*/ if eff_date1 = ? then eff_date1 = hi_date.
/*J034*/ if so_job1  = "" then so_job1 = hi_char.
/*J034*/ /*if nbr  = "" then nbr  = low_char.*/
/*J034*/ if eff_date = ? then eff_date = low_date.
/*J034*/ /*if so_job  = "" then so_job = low_char.*/
/*j034*/ if so_rmks1=""  then so_rmks1=hi_char.
/*judy 05/08/05*/  IF keeper1 = "" THEN keeper1 = hi_char.
				 if site2 = "" then site2 = hi_char.
/*         if so_rmks=""  then so_rmks=low_char.*/


/* SELECT PRINTER */
	     
/*GUI*/ end procedure. /* p-report-quote */

/*GUI*/ procedure p-report:

/*GUI*/   {gpprtrpa.i  "window" 132} 
/*{MFSELPRT.I "terminal" 80} */

i = 1.
pageno=1.

for each  tr_hist no-lock where tr_domain = global_domain 
								 and    (tr_nbr >= nbr) and (tr_nbr <= nbr1)
                 and    (tr_effdate >= eff_date)  and  (tr_effdate <= eff_date1)
                 and    (tr_so_job >= so_job) and (tr_so_job <= so_job1)
                 and    ((tr_type = "ISS-UNP") or (tr_type = "RCT-UNP"))
                 and    (tr_rmks >= so_rmks) and (tr_rmks <= so_rmks1)
                 and    (tr_site >= site1 and tr_site <= site2)            /*Jch*/
                 and (tr__log01 = no or not flag1) 
                 /* USE-INDEX tr_nbr_eff,
/*judy 05/08/05*/     EACH IN_mstr WHERE in_domain = global_domain and IN_part = tr_part AND IN_site = tr_site 
/*judy 05/08/05*/           AND  in__qadc01 >= keeper AND in__qadc01 <= keeper1 USE-INDEX IN_part */
     break by tr_nbr  by tr_effdate by tr_part: 

    IF NOT (keeper =  " " AND  keeper1 =  hi_char) THEN DO:
         FIND FIRST IN_mstr WHERE in_domain = global_domain and IN_part = tr_part AND IN_site = tr_site 
         AND  in__qadc01 >= keeper AND in__qadc01 <= keeper1  NO-LOCK NO-ERROR.
       IF NOT AVAIL IN_mstr THEN NEXT.
    END.

     find first pt_mstr where pt_domain = global_domain and pt_part = tr_part no-lock no-error.
     if available pt_mstr then do:
        if i=1 then do: 
            if tr__log02 = no then do:
               duplicate ="**原本".
             end.
             if tr__log02 = yes then do:
               duplicate ="**副本".
             end.  
             if tr_type="ISS-UNP" then disp duplicate pageno tr_nbr  tr_so_job with frame b.
               else disp duplicate pageno tr_nbr tr_so_job with frame b2.
        end.
        if tr_type="ISS-UNP" THEN  QTY = 0 - tr_qty_loc.
             ELSE  QTY = TR_QTY_loc.
          FIND FIRST IN_mstr WHERE in_domain = global_domain and IN_part = tr_part AND IN_site = tr_site  NO-LOCK NO-ERROR.   
        display tr_part format "x(18)" pt_desc2 format "x(22)"  " "
            QTY  " "   tr_effdate FORMAT "99/99/99" "  " tr_loc format "x(8)"  
  /*judy 05/08/0 5*/          /*pt_article*/
  /*judy 05/08/0 5*/   in__qadc01  WHEN AVAIL IN_mstr             
             format "x(8)" tr_serial FORMAT "x(1)"   tr_site   /*no-label*/  tr_rmks with no-box no-labels width 250 frame c down.
        disp "------------------------------------------------------------------------------------------------------------------------"
               with width 241 no-box frame f.
        i = i + 1.
        if (line-counter  >= (page-size - 7)) or last-of(tr_nbr) then do:
           
            i = 1.      
            disp  "库房主管:              质检员:                保管员:              接收人:" at 1 skip(4) with width 241 no-box frame d. 
            pageno = pageno + 1. 
            page.
/*          if pageno>page_end then leave.*/
         end.
     end.
end.

 

/*{mfphead.i}*/
for each  tr_hist where tr_domain = global_domain 
								 and    (tr_nbr >= nbr) and (tr_nbr <= nbr1)
                 and    (tr_effdate >= eff_date)  and  (tr_effdate <= eff_date1)
                 and    (tr_so_job >= so_job) and (tr_so_job <= so_job1)
                 and    ((tr_type = "ISS-UNP") or (tr_type = "RCT-UNP"))
                 and    (tr_rmks >= so_rmks) and (tr_rmks <= so_rmks1)
                 and    (tr_site >= site1 and tr_site <= site2)            /*Jch*/
                 and (tr__log01 = no or not flag1)                 
                  use-index tr_nbr:
                      
 /*judy 05/08/05*/
 IF NOT (keeper =  " " AND  keeper1 =  hi_char) THEN DO:
      FIND FIRST IN_mstr WHERE in_domain = global_domain and IN_part = tr_part AND IN_site = tr_site 
           AND  in__qadc01 >= keeper AND in__qadc01 <= keeper1 USE-INDEX IN_part NO-LOCK NO-ERROR.
      IF NOT AVAIL IN_mstr THEN  NEXT.
 END.
/*judy 05/08/05*/
                 if dev = "printer" or dev="print-sm" or dev="PRNT88" or dev="PRNT80" then do:
                      tr__log02 = yes.
                 end.
                 tr__log01 = yes.
end.
{mfreset.i}
/* /*GUI*/ {mfguitrl.i}  */
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

end procedure.  
/*K0ZX*/ {wbrp04.i &frame-spec = a} 
/*judy 05/08/05*/ /*/*GUI*/ {mfguirpb.i &flds="nbr  nbr1 eff_date eff_date1 so_job so_job1 so_rmks so_rmks1 site1 site2 flag1"} /*Drive the Report*/*/
/*judy 05/08/05*/  {mfguirpb.i &flds="nbr  nbr1 eff_date eff_date1 so_job so_job1 so_rmks so_rmks1 site1 site2 keeper keeper1 flag1"} /*Drive the Report*/ 

