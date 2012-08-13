/* xxfsbudrp01.p  - Finance budget report - Difference of budget and actual occurs                              */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.     */
/*                  Developped: 02/17/03      BY: kang jian          */
/*Last modified: 10/12/03, For select the cost center by user discretely, By: Kevin                        */
/*  比较预算和实际发生金额 */

{mfdtitle.i } 

define workfile comtwo field entity like glt_entity
                         field gltacct like glt_acct  
                         field gltyear like bgd_year
                         field gltper like bgd_per
                         field gltcc like glt_cc
                         field gltamt like glt_amt
                         field bgdacct like bgd_acc  
                         field bgdyear like bgd_year
                         field bgdper like bgd_per
                         field bgdcc like bgd_cc
                         field bgdamt like bgd_amt
                         field different like bgd_amt
                         field logn as integer.

def var lineno as integer.
define variable detail like mfc_logical label "输出明细" initial yes.
define variable ddetail like mfc_logical label "输出分部门汇总" initial no.
define var sumgltamt like glt_amt.
define var sumbgdamt like glt_amt.
define var sumdifferent like glt_amt.
define var ssumgltamt like glt_amt.
define var ssumbgdamt like glt_amt.
define var ssumdifferent like glt_amt.

def var kk as integer.
def var gltsumamt like glt_amt.
define var entity_from like bgd_entity initial "DCEC".
define var entity_to like bgd_entity initial "DCEC".
define variable account_from like glt_acct .
define variable account_to like glt_acct.
define variable date_from like glt_effdate label "起止日期".
define variable date_to like glt_effdate .
define variable center_from like glt_cc .
define variable center_to like glt_cc .

/*added by kevin,10/14/2003*/
def workfile sel    
                 field id as char init ""
                 field ctr like cc_ctr
                 field desc1 like cc_desc format "x(10)".
def var sel_recno as recid format "->>>>>>9".
define variable first_sw_call as logical initial true.

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

 FORM /*GUI*/ 
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
 	     entity_from           colon 18
	     entity_to          label {t001.i} colon 49
	     account_from           colon 18
	     account_to          label {t001.i} colon 49
	     date_from           colon 18
	     date_to          label {t001.i} colon 49
	     center_from           colon 18
	     center_to          label {t001.i} colon 49 skip
	     detail           colon 18    
	     ddetail           colon 18 


  skip
with frame a side-labels width 120 attr-space NO-BOX THREE-D /*GUI*/.


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

/*added by kevin,10/14/2003*/
form
 SKIP(.1)  /*GUI*/
   sel.id format "x(2)" label "选择"
   sel.ctr
   sel.desc1
   skip(.1)
   with frame c center column 5 row 12 overlay 
   width 80 title "成本中心选择" THREE-D stream-io /*GUI*/.


/*added by kevin,10/14/2003*/
repeat:
      if entity_to = hi_char then entity_to = "".
      if account_to = hi_char then account_to = "".
      if center_to = hi_char then center_to = "".
      if date_from = low_date then date_from = ?.
      if date_to = hi_date then date_to = ?.  
      
      update entity_from entity_to account_from account_to date_from date_to center_from center_to detail ddetail
      with frame a.

      bcdparm = "".
      {mfquoter.i entity_from   }
      {mfquoter.i entity_to   }
      {mfquoter.i account_from   }
      {mfquoter.i account_to   }
      {mfquoter.i date_from   }
      {mfquoter.i date_to   }
      {mfquoter.i center_from   }
      {mfquoter.i center_to   }
      {mfquoter.i detail   }
      {mfquoter.i ddetail   }

      if  entity_to = "" then entity_to = hi_char.	     	     
      if  account_to = "" then account_to = hi_char.
      if  center_to = "" then center_to = hi_char.
      if  date_from = ? then date_from = low_date.
      if  date_to = ? then date_to = hi_date.
      /* SELECT PRINTER */
      
      /*For select the cost center discretely*/
      for each sel:
            delete sel.
      end.
      for each cc_mstr where cc_ctr >= center_from and cc_ctr <= center_to no-lock:
         create sel.
         assign sel.ctr = cc_ctr
                sel.desc1 = cc_desc.
      end.

       sw_block:
         do on endkey undo, leave:
              message "请按 'enter' or 'space', 键去选择成本中心代码.".               
         /* INCLUDE SCROLLING WINDOW TO ALLOW THE USER TO SCROLL      */
               /* THROUGH (AND SELECT FROM) EXISTING PAYMENTS APPLICATIONS  */
               {swselect.i
                  &detfile      = sel
                  &scroll-field = sel.ctr
                  &framename    = "c"
                  &framesize    = 15
                  &sel_on       = ""*""
                  &sel_off      = """"
                  &display1     = sel.id
                  &display2     = sel.ctr
                  &display3     = sel.desc1
                  &display4     = """"
                  &display5     = """"
                  &display6     = """"
                  &display7     = """"
                  &display8     = """"
                  &exitlabel    = sw_block
                  &exit-flag    = first_sw_call
                  &record-id    = sel_recno
                   }
           if keyfunction(lastkey) = "end-error"
            or lastkey = keycode("F4")
            or keyfunction(lastkey) = "."
            or lastkey = keycode("CTRL-E") then do:
               undo sw_block, leave.
            end.        
       end.
       
       hide message no-pause.
              
      {mfselbpr.i "printer" 132}
        
{mfphead.i}


/*将有预算中有的项目加入临时表中，并计算期间实际发生*/
for each bgd_det no-lock where bgd_entity >= entity_from and bgd_entity <= entity_to 
                 and bgd_cc>= center_from and bgd_cc<=center_to                 
                  and bgd_acc >= account_from and bgd_acc<=account_to
                    and ((((bgd_year > year(date_from) and bgd_year< year(date_to)) or 
                         (bgd_year = year(date_from) and bgd_per >= month(date_from)) or
                         (bgd_year = year(date_to) and bgd_per <= month(date_to))) and year(date_from)<>year(date_to))
                         or 
                         (bgd_year = year(date_from) and bgd_per >= month(date_from) and bgd_per <= month(date_to) and year(date_from)=year(date_to)))
                    and (substring(bgd_acc,1,4)="5141" or substring(bgd_acc,1,4)="5131" or substring(bgd_acc,1,4)="4201"),
/*kevin*/ each sel where sel.ctr = bgd_cc and sel.id = "*" no-lock                          
                    by bgd_cc by bgd_year by bgd_per by bgd_acc :
                    
            gltsumamt=0.
            kk=0.
            create comtwo.   
            assign entity = bgd_entity                 
                   gltacct = bgd_acc
                    gltcc = bgd_cc
                   gltyear = bgd_year
                   gltper = bgd_per
                    bgdacct = bgd_acc
                   bgdcc = bgd_cc
                   bgdyear = bgd_year
                    bgdper = bgd_per
                    bgdamt = bgd_amt
                   different = bgdamt - gltamt
                    logn = 1.
            for each gltr_hist no-lock where gltr_entity=bgd_entity and gltr_acc = bgd_acc
                  and year(gltr_eff_dt) = bgd_year and month(gltr_eff_dt)= bgd_per
                   and gltr_eff_dt>= date_from and gltr_eff_dt<=date_TO
                   and gltr_ctr = bgd_cc
                   by gltr_ctr  by gltr_eff_dt by gltr_acc:
                   kk=kk + 1.
                   GltSumAmt= gltsumamt + gltr_amt.
            end.
            for each glt_det no-lock where glt_entity=bgd_entity and glt_cc = bgd_cc
                   and year(glt_effdate) = bgd_year and month(glt_effdate)= bgd_per
                   and glt_effdate>= date_from and glt_effdate<=date_TO
                   and glt_acct = bgd_acc
                   by glt_cc   by glt_effdate by glt_acct:
                   kk=kk + 1.
                   GltSumAmt= gltsumamt + glt_amt.
            end.
            if kk<>0 then do:
                gltamt=gltsumamt.
                different=bgdamt - gltamt.
            end.
end.
/*将计算期间有实际发生，但无预算项目加入临时表中*/
for each gltr_hist no-lock where gltr_entity >= entity_from and gltr_entity <= entity_to
                   and gltr_ctr>= center_from and gltr_ctr<=center_to
                   and gltr_eff_dt>= date_from and gltr_eff_dt<=date_to
                   and gltr_acc >= account_from and gltr_acc<=account_to
                   and (substring(gltr_acc,1,4)="5141" or substring(gltr_acc,1,4)="5131" or substring(gltr_acc,1,4)="4201"),
/*kevin*/ each sel where sel.ctr = gltr_ctr and sel.id = "*" no-lock
                   by gltr_ctr   by gltr_eff_dt by gltr_acc:
            find first comtwo where gltcc = gltr_ctr
                            and gltyear = year(gltr_eff_dt)
                            and gltper = month(gltr_eff_dt)
                            and  gltacct=gltr_acc no-lock no-error.
            if not available comtwo then do:       
               create comtwo.
               assign logn = 0 
                       entity = gltr_entity                   
                       gltacct = gltr_acc
                       gltcc = gltr_ctr
                       gltyear = year(gltr_eff_dt)
                       gltper = month(gltr_eff_dt)
                       gltamt = gltr_amt + gltamt 
                      bgdacct = gltr_acc
                      bgdcc = gltr_ctr
                      bgdyear = year(gltr_eff_dt)
                       bgdper = month(gltr_eff_dt)
                       bgdamt = 0.
            end.
            else 
               if logn=0 then gltamt=gltr_amt + gltamt.
            different=bgdamt - gltamt.
end.

for each glt_det no-lock where glt_entity >= entity_from and glt_entity <= entity_to
                   and glt_cc>= center_from and glt_cc<=center_to
                   and glt_effdate>= date_from and glt_effdate<=date_to
                   and glt_acct >= account_from and glt_acct<=account_to
                   and (substring(glt_acct,1,4)="5141" or substring(glt_acct,1,4)="5131" or substring(glt_acct,1,4)="4201"),
/*kevin*/ each sel where sel.ctr = glt_cc and sel.id = "*" no-lock
                    by glt_cc  by glt_effdate by glt_acct:
            find first comtwo where gltacct=glt_acct 
                            and gltyear = year(glt_effdate)
                            and gltper = month(glt_effdate)
                            and gltcc = glt_cc no-lock no-error.
            if not available comtwo then do:       
               create comtwo.
               assign logn = 0 
                      entity=glt_entity                   
                       gltacct = glt_acct
                       gltcc=glt_cc
                      gltyear= year(glt_effdate)
                       gltper=month(glt_effdate)
                      gltamt=glt_amt + gltamt 
                       bgdacct = glt_acc
                       bgdcc=glt_cc
                       bgdyear= year(glt_effdate)
                      bgdper=month(glt_effdate)
                      bgdamt=0.
            end.
            else 
               if logn=0 then gltamt=glt_amt + gltamt.
            different=bgdamt - gltamt.
end.
/*显示明细记录*/
if detail then
for each comtwo by entity by gltcc by gltacct  by gltyear by gltper:
     
           disp entity column-label "地点" gltacct column-label "帐号" gltyear column-label "年份"
            gltper column-label "月份" gltcc column-label "成本中心" bgdamt column-label "预算"
             gltamt column-label "实际发生"  different column-label "差异" with width 240 STREAM-IO .                 
end.
page.

/*显示按照成本中心帐户年份统计合计*/
ssumgltamt=0.
ssumbgdamt=0.
ssumdifferent=0.
display "按照成本中心帐户年份统计合计金额" at 30 with frame ff1 width 240  .
for each comtwo break by entity by gltcc by gltacct by gltyear :
   accumulate gltamt (total by gltyear ).
   accumulate bgdamt (total  by gltyear).
   accumulate different (total  by gltyear ). 
      ssumgltamt= gltamt + ssumgltamt.
   ssumbgdamt= bgdamt + ssumbgdamt.
   ssumdifferent = different + ssumdifferent.
   if last-of(gltyear) then do:
         sumgltamt=(accumulate total  by gltyear gltamt).
         sumbgdamt=(accumulate total  by gltyear bgdamt).
         sumdifferent=(accumulate total  by gltyear different).
            disp entity column-label "地点" gltcc column-label "成本中心" gltacct column-label "帐号" gltyear column-label "年份合计"
             sumbgdamt column-label "预算"
             sumgltamt column-label "实际发生"  sumdifferent column-label "差异" with width 240 STREAM-IO .
   end.

end.
disp "总合计" ssumbgdamt column-label "部门预算总金额"
             ssumgltamt column-label "实际发生总金额"  ssumdifferent column-label "余额" with frame ff3 width 240 STREAM-IO  .

/*显示按照成本中心计算总金额合计*/
if ddetail=yes then do:
page.
display "按照成本中心计算总金额合计表" at 30 with frame ff2 width 240  .
for each comtwo break by entity by gltcc  :
   accumulate gltamt (total by gltcc  ).
   accumulate bgdamt (total by gltcc ).
   accumulate different (total by gltcc  ). 

   if last-of(gltcc) then do:
         ssumgltamt=(accumulate total  by gltcc gltamt).
         ssumbgdamt=(accumulate total  by gltcc bgdamt).
         ssumdifferent=(accumulate total  by gltcc different).
         disp gltcc column-label "成本中心合计" 
             ssumbgdamt column-label "部门预算总金额"
             ssumgltamt column-label "实际发生总金额"  ssumdifferent column-label "余额" with width 240 STREAM-IO  .
   end.
end.

end.

/*清空临时表*/
for each comtwo:
  delete comtwo.
end.
/*{mfguitrl.i}*/

        {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
      
      	           
end. /*repeat*/

