/* xxpjac01.p  - Project Activity/Blance Report                              */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.     */
/* V1                 Developped: 16/06/02      BY: Rao Haobin          */
/* V2  modified by kangjian */
/* V3 modified by kangjian  (added a detail summary report in the end )*/
/* V4 modified by kangjian 17/09/02 (delete some disply information )*/
/* RHB 项目活动/余额明细报表 */

{mfdtitle.i } 

define variable entity like acd_entity.
define variable entity1 like acd_entity.
define variable acc like acd_acc.
define variable acc1 like acd_acc.
define variable project like acd_proj.
define variable project1 like acd_proj.
define variable effdate like gltr_eff_dt.
define variable effdate1 like gltr_eff_dt.

define variable acccode like acd_acc.
define variable accname like ac_desc.
define variable pjcode like pj_project.
define variable pjdesc like pj_desc.
define variable startbal like acd_amt label "期初余额".
define variable startcurrbal like acd_amt label "外币期初余额".
define variable endbal like acd_amt label "期末余额".
define variable endcurrbal like acd_amt label "外币期末余额".
define variable dramt like acd_amt label "借方金额".
define variable cramt like acd_amt label "贷方金额".
define variable sumstart like acd_amt label "帐户期初总计：".
define variable sumcurrstart like acd_amt label "帐户期初总计：".
define variable sumend like acd_amt label "帐户期末初总计：".
define variable sumcurrend like acd_amt label "帐户期末总计：".




 
define workfile accpj_sum field accpj_acc like acd_acc
			field accpj_project like pj_project
			field accpj_accname like ac_desc
			field accpj_pjdesc like pj_desc
			field accpj_amt as decimal label "期初余额" format "->,>>>,>>>,>>9.99"                    
			field accpj_curramt as decimal label "外币期初余额" format "->,>>>,>>>,>>9.99"
			field accpj_actamt as decimal label "活动金额" format "->,>>>,>>>,>>9.99" 
			field accpj_actcurramt as decimal label "活动外币金额" format "->,>>>,>>>,>>9.99" 
			field accpj_endamt as decimal label "期末余额" format "->,>>>,>>>,>>9.99"                    
			field accpj_endcurramt as decimal label "外币期末余额" format "->,>>>,>>>,>>9.99". 

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

 FORM /*GUI*/ 
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
	     entity           colon 18
	     entity1          label {t001.i} colon 49 skip
	     acc 	    colon 18
	     acc1          label {t001.i} colon 49 skip
	     project           colon 18
	     project1          label {t001.i} colon 49 skip
             effdate            colon 18
             effdate1           label {t001.i} colon 49 skip
  skip
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
/*judy 07/05/05*/  /* SET EXTERNAL LABELS */
/*judy 07/05/05*/  setFrameLabels(frame a:handle).

form header
"帐户:" at 1
acccode at 6
"帐户名称:" at 20
accname at 30
"项目:" at 60
pjcode at 66
"项目名称:" at 90
pjdesc at 100
skip
"期初余额:" at 1
startbal at 10
"外币期初余额:" at 50
startcurrbal at 65
skip
/*with  frame phead1 width 132.*/
with stream-io frame phead1 side-labels width 132.
/*judy 07/05/05*/  /* SET EXTERNAL LABELS */
/*judy 07/05/05*/  setFrameLabels(frame phead1:handle).
  /* REPORT BLOCK */

	  
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

	     if project1 = hi_char then project1 = "".
	     if effdate = low_date then effdate = ?.
	     if effdate1 = hi_date then effdate1 = ?.
	     if entity1 = hi_char then entity1 = "".
	     if acc1 = hi_char then acc1 = "".
	     
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


	     bcdparm = "".

	     {mfquoter.i project   }
	     {mfquoter.i project1   }
	     {mfquoter.i effdate   }
	     {mfquoter.i effdate1   }
	     {mfquoter.i entity   }
	     {mfquoter.i entity1   }
	     {mfquoter.i acc   }
	     {mfquoter.i acc1   }
	     
	     if  project1 = "" then project1 = hi_char.
	     if  entity1 = "" then entity1 = hi_char.
	     if  acc1 = "" then acc1 = hi_char.
	     if  effdate = ? then effdate = low_date.
	     if  effdate1 = ? then effdate1 = hi_date.
	     /* SELECT PRINTER */
	     
/*GUI*/ end procedure. /* p-report-quote */

/*GUI*/ procedure p-report:

/*GUI*/   {gpprtrpa.i  "printer" 132}
{mfphead.i}


for each acd_det no-lock where acd_entity <= entity1 and acd_entity>=entity and acd_acc>=acc and acd_acc<=acc1 and acd_project>=project and acd_project<=project1 
and (acd_year < year(effdate) or acd_year = year(effdate) and acd_per < month(effdate)) break by acd_acc by acd_project :

 accumulate acd_amt (total by acd_acc by acd_project).
 accumulate acd_curr_amt (total by acd_acc by acd_project).
 if last-of(acd_project) then do:
 create accpj_sum.
 accpj_acc = acd_acc.
 accpj_project = acd_project.
      find first pj_mstr where trim(pj_project) = trim(accpj_project) no-lock no-error.
      if available pj_mstr then
        accpj_pjdesc = pj_desc.
      else
        accpj_pjdesc="".
 accpj_amt = accum total  by acd_project  acd_amt.
 accpj_curramt = accum total by acd_project acd_curr_amt.
 end. 
end.

/**kangjian added record in work file accpj_sum for that activity account in activity terms  -start-*/
for each acd_det where acd_entity <= entity1 and acd_entity>=entity and acd_acc>=acc and acd_acc<=acc1 and acd_project>=project and acd_project<=project1 
and acd_per >= month(effdate) and acd_per <= month(effdate1) break by acd_acc by acd_project :
 if last-of(acd_project) then do:
   find first accpj_sum where accpj_acc=acd_acc and accpj_project=acd_project no-lock no-error.
   if not available accpj_sum then do:
      create accpj_sum.
      accpj_acc = acd_acc.
      accpj_project = acd_project.
      accpj_amt = 0.
      accpj_curramt = 0.
      find first pj_mstr where trim(pj_project) = trim(accpj_project) no-lock no-error.
      if available pj_mstr then
        accpj_pjdesc = pj_desc.
      else
        accpj_pjdesc="".
      find ac_mstr where ac_code = accpj_acc no-lock no-error.
      accpj_accname = ac_desc.
   end.
 end. 
end.
/**kangjian added record in work file accpj_sum for that activity account in activity terms  -end-*/

for each accpj_sum break by accpj_acc:
   accpj_endamt=accpj_amt.
   accpj_endcurramt=accpj_curramt.
   endbal=accpj_amt.
   endcurrbal=accpj_curramt.
   find first gltr_hist where gltr_acc = accpj_acc and gltr_project = accpj_project  and gltr_eff_dt >= effdate and gltr_eff_dt <= effdate1 /*cj*/ USE-INDEX gltr_project no-lock no-error.
   if available(gltr_hist) then do:
      find pj_mstr where pj_project = accpj_project no-lock no-error.
      if available pj_mstr then
         pjdesc = pj_desc.
      else
         pjdesc="".
      find ac_mstr no-lock where ac_code = accpj_acc no-error.
      accname = ac_desc.
      acccode = accpj_acc.
      pjcode = accpj_project.
      startbal = accpj_amt.
      startcurrbal = accpj_curramt.

/*kangjian v4      disp acccode accname pjcode pjdesc startbal startcurrbal with stream-io frame phead1 side-labels width 132. kangjian v4*/
      disp acccode accname pjcode pjdesc "期初余额：" startbal "外币期初余额：" startcurrbal with stream-io no-label width 180. 
      for each gltr_hist no-lock where gltr_acc = accpj_acc and gltr_project = accpj_project and gltr_eff_dt >= effdate and gltr_eff_dt <= effdate1 /*cj*/ USE-INDEX gltr_project by gltr_acc by gltr_project:
          endbal = endbal + gltr_amt.
          endcurrbal = endcurrbal + gltr_curramt.
          accpj_actamt=accpj_actamt + gltr_amt. 
          accpj_actcurramt=accpj_actcurramt + gltr_curramt. 
   
          /**kangjian   caculated for foreign currency sum of the account -start-*/
          sumend=sumend + gltr_amt.
          /**kangjian   caculated for foreign currency sum of the account -end-*/
   
          /**kangjian added display  for foreign currency filed  -start- */

          if gltr_curr<>"RMB" then do:

/*judy 07/05/05*/   /*display gltr_eff_dt gltr_ref gltr_desc gltr_amt gltr_curramt label "外币金额" endbal endcurrbal with width 150 */
/*judy 07/05/05*/   display gltr_eff_dt gltr_ref gltr_desc gltr_amt gltr_curramt label "外币金额" endbal endcurrbal with width 150 STREAM-IO.
             sumcurrend=sumcurrend + gltr_curramt.
          end.
          else do:
             display gltr_eff_dt gltr_ref gltr_desc gltr_amt 0 label "外币金额" endbal endcurrbal with width 150 STREAM-IO .
          end.
          if line-counter >= (page-size - 4) then page.
          /**kangjian added display  for foreign currency filed  -end- */   
   
      end.
      accpj_endamt=endbal.
      accpj_endcurramt=endcurrbal.
   end.  
   accumulate accpj_amt (total by accpj_acc ).
   accumulate accpj_curramt (total by accpj_acc ).

   /**kangjian   caculated and display for foreign currency sum of the account -start-*/
   if last-of(accpj_acc) then do:
      sumstart=(accumulate total by accpj_acc accpj_amt).
      sumcurrstart= (accumulate total by accpj_acc accpj_curramt).
/*kangjian v4      disp  accpj_acc sumstart COLUMN-LABEL "帐户期初合计"
      sumcurrstart COLUMN-LABEL "帐户期初外币合计" 
      sumend COLUMN-LABEL "帐户活动金额"
      sumcurrend COLUMN-LABEL "帐户外币活动金额" 
      (sumend + sumstart) format "->>>>>>>>>>>9.99" COLUMN-LABEL "帐户期末合计"
      (sumcurrend + sumcurrstart) format "->>>>>>>>>>>9.99" COLUMN-LABEL "帐户期末外币合计" with width 150.
      kangjian v4*/
      sumend=0.
      sumcurrend=0. 
   end.
   /** kangjian   caculated and display for foreign currency sum of the account -end-*/
   if line-counter >= (page-size - 4) then page.
end.

/*hide frame phead1.*/

/* V3 modified by kangjian  (added a detail summary report in the end )*/
for each accpj_sum:
  
  disp accpj_acc  accpj_pjdesc accpj_amt  accpj_curramt accpj_actamt  accpj_actcurramt accpj_endamt accpj_endcurramt with width 244 STREAM-IO . 
end.
/* V3 modified by kangjian  (added a detail summary report in the end )*/

for each accpj_sum:
delete accpj_sum.
end.

{mfguitrl.i}

/*judy 07/05/05*/  {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
end procedure.



/*GUI*/ {mfguirpb.i &flds=" entity entity1 acc acc1 project project1 effdate effdate1 "} /*Drive the Report*/

/*judy 07/05/05*/ /* {mfreset.i}*/
