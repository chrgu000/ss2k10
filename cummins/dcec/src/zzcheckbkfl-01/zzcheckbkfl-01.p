/* Revision: QAD2011  BY: Jordan Lin         DATE: 10/25/12  ECO: *SS -20121025.1  */

{mfdtitle.i "20121025.1"}
DEFINE VAR site LIKE tr_site.
DEFINE VAR site1 LIKE tr_site.
DEFINE VAR effbdate LIKE tr_effdate.
DEFINE VAR effedate LIKE tr_effdate.
DEFINE VAR urid LIKE tr_userid.
DEFINE VAR urid1 LIKE tr_userid.
DEFINE VAR manual LIKE mfc_logic initial yes .
DEFINE VAR detail LIKE mfc_logic initial yes .
DEFINE VAR v_wo_part LIKE wo_part.



FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 site       colon 22   LABEL "事务号"      site1         colon 50 LABEL "TO"
 effbdate   colon 22   LABEL "开始时间"    effedate      colon 50 LABEL "结束时间"
 urid       colon 22   LABEL "用户ID"      urid1         colon 50 LABEL "TO"
 manual     colon 22   LABEL "人工调整"  
 detail      colon 22   LABEL "D-细节"
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
setframelabels(frame a:handle).



repeat with frame a:
      if site1 = hi_char then site1 = "" .
      if effedate = hi_date then effedate = ? .
      if effbdate = low_date then effbdate = ? .
      if urid1 = hi_char then urid1 = "" .

    update site site1 effbdate effedate urid urid1 manual detail with frame a.

      if site1 = "" then site1 = hi_char .
      if effedate = ? then effedate = hi_date .
      if effbdate = ? then effbdate = low_date.
      if urid1 = "" then urid1 = hi_char .

    {mfselbpr.i "terminal" 132}

      put "                    手动调整回冲报表" skip .
      put "零件号                  调整数量       地点        用户ID   生效日期      程序名称      工单号       工单零件       事务处理号 "skip.
      put "-------------------------------------------------------------------------------------------------------------------------------"skip.
      for each tr_hist where tr_hist.tr_domain = global_domain 
                         and tr_effdate > effbdate and tr_effdate < effbdate
			 and tr_type = "ISS-WO"
			 and tr_site > site and tr_site < site1
			 and tr_userid > urid and urid1 < urid1 
			 no-lock BREAK  by tr_trnbr:
         find first wo_mstr where wo_mstr.wo_domain = global_domain and wo_nbr = tr_lot no-lock no-error.
	 if available wo_mstr then v_wo_part = wo_part .
	 else v_wo_part = "".

         display tr_part tr_qty_req tr_site tr_userid tr_effdate  tr_program tr_lot v_wo_part tr_trnbr .

       end.  /*for each tr_hist*/
      
      put "-------------------------------------------------------------------------------------------------------------" skip .
      put "保管员               材料经理                  材料部长               财务部长" skip(2) .
      put "--------- 报表结束 --------" skip.

      /* REPORT TRAILER  */
   {mfrtrail.i}	
	
	{mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
end.
