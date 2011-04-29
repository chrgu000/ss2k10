/* GUI CONVERTED from icccrp01.p (converter v1.76) Thu Jun 12 20:28:46 2003 */
/* icccrp01.p - CYCLE COUNT RESULTS REPORT                                   */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.16.3.1 $                                                              */
/*V8:ConvertMode=FullGUIReport                                               */
/* REVISION: 6.0      LAST MODIFIED: 04/20/90   BY: PML                      */
/* REVISION: 6.0      LAST MODIFIED: 05/22/90   BY: WUG *D022                */
/* REVISION: 6.0      LAST MODIFIED: 10/24/90   BY: pml *D134                */
/* REVISION: 6.0      LAST MODIFIED: 04/23/91   BY: WUG *D570                */
/* REVISION: 7.0      LAST MODIFIED: 09/25/91   BY: pma *F003*               */
/* REVISION: 6.0      LAST MODIFIED: 11/11/91   BY: WUG *D887*               */
/* REVISION: 7.0      LAST MODIFIED: 02/03/92   BY: pma *F139*               */
/* REVISION: 7.0      LAST MODIFIED: 03/28/94   BY: ais *FN09*               */
/* REVISION: 7.0      LAST MODIFIED: 05/03/94   BY: jxz *FN90*               */
/* REVISION: 7.0      LAST MODIFIED: 10/10/94   BY: qzl *FS28*               */
/* REVISION: 7.0      LAST MODIFIED: 11/02/94   BY: pxd *FT27*               */
/* REVISION: 7.3      LAST MODIFIED: 05/15/96   BY: rvw *G1S8*               */
/* REVISION: 8.6      LAST MODIFIED: 10/11/97   BY: mur *K0T0*               */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 09/05/00   BY: *N0RF* Mark Brown        */
/* REVISION: 9.1      LAST MODIFIED: 08/10/00   BY: *N0K2* Phil DeRogatis    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Old ECO marker removed, but no ECO header exists *B314*                   */
/* Revision: 1.15     BY:  Vivek Dsilva         DATE: 01/21/02  ECO: *N186*  */
/* Revision: 1.16     BY:  Dave Caveney         DATE: 08/13/02  ECO: *P0DY*  */
/* $Revision: 1.16.3.1 $     BY:  Orlando D'Abreo      DATE: 06/10/03  ECO: *N2GX* */

/* REVISION: 1.0         Last Modified: 2008/10/27   By: Roger   ECO:*xp001*  */ 
/* REVISION: 1.0         Last Modified: 2008/11/28   By: Roger   ECO:*xp002*  */
/*-Revision end------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/




/*xp001************
1.输出到excel
2.mainloop之内的,先屏蔽再新增,外围代码有删改,
***********xp001*/ 

/*xp002************
1.输入条件加:产品线
2.excel加页面设置
3.取消最后的汇总行 和 第"PQRS"列
***********xp002*/ 



/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}
define variable prodline            like pt_prod_line                no-undo. /*xp002*/
define variable prodline1           like pt_prod_line                no-undo. /*xp002*/
define variable loc                 like pt_loc                      no-undo.
define variable loc1                like pt_loc                      no-undo.
define variable part                like pt_part                     no-undo.
define variable part1               like pt_part                     no-undo.
define variable site                like pt_site                     no-undo.
define variable site1               like pt_site                     no-undo.
define variable cnt_date            like in_cnt_date initial today   no-undo.
define variable cnt_date1           like in_cnt_date initial today   no-undo.
define variable qty_oh_var          as   decimal format "->>>>>9.99%"
                                    label "QOH Var"                  no-undo.
define variable anl_avg_use         as   decimal format "->>,>>>,>>9.9"
                                    label "Annual Use"               no-undo.
define variable avg_iss_var         as   decimal format "->>>>>9.99%"
                                    label "Annual Use Var"           no-undo.
define variable pge_on_loc          like mfc_logical initial no      no-undo.
define variable first_pass          like mfc_logical                 no-undo.
define variable old_loc             like pt_loc                      no-undo.
define variable old_date            like tr_date                     no-undo.
define variable old_site            like tr_site                     no-undo.
define variable s_num               as   character extent 3          no-undo.
define variable d_num               as   decimal decimals 9 extent 3 no-undo.
define variable i                   as   integer                     no-undo.
define variable j                   as   integer                     no-undo.
define variable cerr                as   character format "x(4)"     no-undo.
define variable asterisk            as   character format "x(1)"     no-undo.
define variable print-footnote      like mfc_logical                 no-undo.
define variable total_count         as   integer                     no-undo.
define variable total_hits          as   integer                     no-undo.
define variable within_tol          as   decimal format ">>9%"       no-undo.
define variable show_count          like mfc_logical initial yes
                                    label "Show Initial"             no-undo.
define variable show_recount        like mfc_logical initial yes
                                    label "Show Recounts"            no-undo.
define variable show_errors         like mfc_logical initial yes
                                    label "Show Errors"              no-undo.
define variable total_recount       as integer                       no-undo.
define variable accum-total-count   as integer                       no-undo.
define variable accum-total-hits    as integer                       no-undo.
define variable accum-total-recount as integer                       no-undo.
define variable c-msg               like msg_desc                    no-undo.


define variable xapplication as com-handle. /*xp001*/  
define variable xworkbook as com-handle.    /*xp001*/  
define variable xworksheet as com-handle.   /*xp001*/  
define variable x_row as integer init 1.    /*xp001*/  
define variable x_col as integer init 1.    /*xp001*/  


/* SELECT FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
   cnt_date                                    colon 15
   cnt_date1      label {t001.i}               colon 49
   prodline                                    colon 15 /*xp002*/  
   prodline1      label {t001.i}               colon 49 /*xp002*/  
   part                                        colon 15
   part1          label {t001.i}               colon 49
   loc                                         colon 15
   loc1           label {t001.i}               colon 49
   site                                        colon 15
   site1          label {t001.i}               colon 49 skip (1)
   pge_on_loc     label "New Page on Location" colon 30
   show_count                                  colon 30
   show_recount                                colon 30
   show_errors                                 colon 30 skip
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " Selection Criteria "
  &ELSE {&SELECTION_CRITERIA}
  &ENDIF .
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

/* REPORT BLOCK */

{wbrp01.i}
repeat: 
    if cnt_date  = low_date then cnt_date  = ?.
    if cnt_date1 = hi_date  then cnt_date1 = ?.
    if loc1      = hi_char  then loc1      = "".
    if part1     = hi_char  then part1     = "".
    if site1     = hi_char  then site1     = "".
    if prodline1     = hi_char  then prodline1     = "". /*xp002*/  




    update 
        cnt_date cnt_date1 
        prodline prodline1 /*xp002*/  
        part part1 loc loc1 site site1 
        pge_on_loc show_count show_recount show_errors 
    with frame a. 


   if  (c-application-mode <> 'web')
   or  (c-application-mode  = 'web' and
       (c-web-request begins 'data'))
   then do:

      bcdparm = "".

      {mfquoter.i cnt_date    }
      {mfquoter.i cnt_date1   }
      {mfquoter.i prodline        } /*xp002*/  
      {mfquoter.i prodline1       } /*xp002*/  
      {mfquoter.i part        }
      {mfquoter.i part1       }
      {mfquoter.i loc         }
      {mfquoter.i loc1        }
      {mfquoter.i site        }
      {mfquoter.i site1       }
      {mfquoter.i pge_on_loc  }
      {mfquoter.i show_count  }
      {mfquoter.i show_recount}
      {mfquoter.i show_errors }

      if cnt_date  = ?  then cnt_date  = low_date.
      if cnt_date1 = ?  then cnt_date1 = hi_date.
      if part1     = "" then part1     = hi_char.
      if loc1      = "" then loc1      = hi_char.
      if site1     = "" then site1     = hi_char.
      if prodline1     = "" then prodline1     = hi_char. /*xp002*/  


   end. /* IF (c-application-mode <> 'web') */

mainloop: 
do on error undo, return error on endkey undo, return error:

    /*xp001*********begin*/
    create "excel.application" xapplication.
    xworkbook = xapplication:workbooks:add().
    xworksheet = xapplication:sheets:item(1).  
    x_row = 1.
    x_col = 1.
    xworksheet:range("a1:s1"):select.
    xworksheet:range("a1:s1"):merge.
    xworksheet:range("a1"):value = "周期盘点结果报表". 
    xworksheet:Cells(1, 1):HorizontalAlignment = 3 .
    xworksheet:range("a1"):Font:Bold = True .
    xworksheet:range("a1"):font:size=20 .
    xworksheet:Rows("1:1"):EntireRow:AutoFit . 
    
    x_row = 2.
    x_col = 1.
    xworksheet:cells(x_row,x_col) = "生效日期".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "地点".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "库位".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "零件号".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "说明1".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "说明2".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "批/序号".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "参考".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "UM".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "ABC".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "开始库存量".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "盘点量".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "库存变化量".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "变化金额".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "库存差异".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "年用量差异".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "年用量".

       /*{mfphead.i}*xp001*/  
    /*xp001***********end*/ 



   first_pass = yes.
   old_date   = ?.

   for each tr_hist
      where (tr_effdate >= cnt_date and
             tr_effdate <= cnt_date1)
      and ((show_count
            and tr_type    = "CYC-CNT" )
          or (show_recount
              and tr_type  = "CYC-RCNT")
          or  (tr_type     = "CYC-ERR" ))
      and (tr_loc         >= loc
          and tr_loc      <= loc1)
      and (tr_part        >= part
          and tr_part     <= part1)
      and (tr_site        >= site
          and tr_site     <= site1)
      use-index tr_eff_trnbr
      no-lock,
      each pt_mstr 
          fields ( pt_part pt_desc1 pt_desc2)
          where pt_part = tr_part 
          and pt_prod_line >= prodline and pt_prod_line <= prodline1  /*xp002*/  
      break by tr_effdate
            by tr_site
            by tr_loc
            by tr_part
            by tr_trnbr
      with frame b width 132:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      /*xp002************
      for first pt_mstr
         fields ( pt_part
                  pt_desc1 
                  /*xp001*/  pt_desc2)
         where pt_part = tr_part
         no-lock:
      end. /* FOR FIRST pt_mstr */
      ***********xp002*/ 

      for first in_mstr
         fields (in_part in_site in_avg_iss in_abc in_gl_set in_cur_set
                 in_gl_cost_site
                )
         where in_part = tr_part
           and in_site = tr_site
         no-lock:
      end. /* FOR FIRST in_mstr */

      if  /*available pt_mstr
      and  *xp002*/   available in_mstr
      then do:
         accumulate tr_gl_amt (total).
         accumulate tr_qty_loc (total).

         if tr_type = "CYC-RCNT"
         then
            accumulate total_recount (count).
         else
            accumulate total_count (count).

         accumulate tr_qty_chg (total).

         if tr_type = "CYC-CNT"
         then
            accumulate total_hits (count).

         qty_oh_var = 0.

         if  tr_loc_begin = 0
         and tr_qty_req <> tr_loc_begin
         then
            qty_oh_var   = 100.

         if tr_loc_begin <> 0
         then
            qty_oh_var = ((tr_qty_req - tr_loc_begin) / tr_loc_begin) * 100.

         if qty_oh_var < 0
         then
            qty_oh_var = - qty_oh_var.

         assign
            anl_avg_use = in_avg_iss * 365
            asterisk    = ""
            avg_iss_var = 0.

         if  anl_avg_use = 0
         and tr_qty_req - tr_loc_begin <> 0
         then
            assign
               print-footnote = yes
               asterisk = "*".

         if anl_avg_use <> 0
         then
            avg_iss_var = ((tr_qty_req - tr_loc_begin) / anl_avg_use) * 100.

         if   avg_iss_var < 0
         then
            avg_iss_var = - avg_iss_var.

         if (old_site  <> tr_site
            or (old_loc  <> tr_loc and pge_on_loc)
            or old_date  <> tr_effdate)
         and not first_pass
         then
            page.

         assign
            old_site   = tr_site
            old_loc    = tr_loc
            old_date   = tr_effdate
            first_pass = no.

         if tr_type <> "CYC-ERR"
         or (tr_type = "CYC-ERR"
            and show_errors)
         then do:

/*xp001*********begin*/
        x_row = x_row + 1.
        x_col = 1.
        xworksheet:cells(x_row,x_col) = string(year(tr_effdate)) + "-" + string(month(tr_effdate),'99') + "-" + string(day(tr_effdate),'99') .
        x_col = x_col + 1.
        xworksheet:cells(x_row,x_col) = "'" + tr_site.
        x_col = x_col + 1.
        xworksheet:cells(x_row,x_col) = "'" + tr_loc .
        x_col = x_col + 1.
        xworksheet:cells(x_row,x_col) = "'" + tr_part.
        x_col = x_col + 1.
        xworksheet:cells(x_row,x_col) = "'" + pt_desc1.
        x_col = x_col + 1.
        xworksheet:cells(x_row,x_col) = "'" + pt_desc2.
        x_col = x_col + 1.
        xworksheet:cells(x_row,x_col) = "'" + tr_serial.
        x_col = x_col + 1.
        xworksheet:cells(x_row,x_col) = "'" + tr_ref .
        x_col = x_col + 1.
        xworksheet:cells(x_row,x_col) = "'" + tr_um.
        x_col = x_col + 1.
        xworksheet:cells(x_row,x_col) = "'" + in_abc.
        x_col = x_col + 1.
        xworksheet:cells(x_row,x_col) = tr_loc_begin. /*开始库存量*/
        x_col = x_col + 1.
        xworksheet:cells(x_row,x_col) = tr_qty_req . /*盘点量*/
        x_col = x_col + 1.
        xworksheet:cells(x_row,x_col) = tr_qty_loc . /*库存变化量*/
        x_col = x_col + 1.
        xworksheet:cells(x_row,x_col) = tr_gl_amt . /*变化金额*/
        x_col = x_col + 1.
        xworksheet:cells(x_row,x_col) = qty_oh_var . /*库存差异*/
        x_col = x_col + 1.
        xworksheet:cells(x_row,x_col) = if asterisk = "" then string(avg_iss_var) else "" . /*年用量差异*/
        x_col = x_col + 1.
        xworksheet:cells(x_row,x_col) = anl_avg_use . /*年用量*/
        x_col = x_col + 1.
        xworksheet:cells(x_row,x_col) = asterisk . /*asterisk*/
        x_col = x_col + 1.
        xworksheet:cells(x_row,x_col) = if tr_type = "CYC-ERR" then caps(getTermLabel("ERROR",04)) else if tr_type = "CYC-RCNT" then caps(getTermLabel("RECOUNT",04)) else "" . /*error*/	

            

         /*xp001************
            display
               tr_effdate
               tr_site                 column-label "Site!Location"
               tr_part                 column-label "Item Number!Lot/Serial"
               pt_desc1                column-label "Description!Ref"
               tr_um
               in_abc
               tr_loc_begin            column-label "Begin Loc Bal!Qty Counted"
               tr_qty_loc @ tr_qty_chg column-label "Qty Change!Amount Change"
               qty_oh_var              column-label "QOH Var!Anl Use Var" WITH STREAM-IO  .
            down 1.

            display
               tr_loc     @ tr_site
               tr_serial  @ tr_part
               tr_ref     @ pt_desc1
               tr_qty_req @ tr_loc_begin
               tr_gl_amt  @ tr_qty_chg
               asterisk   no-label
               anl_avg_use WITH STREAM-IO  .

            if asterisk = ""
            then
               display
                  avg_iss_var @ qty_oh_var WITH STREAM-IO  .
            else
               display
                  "" @ qty_oh_var WITH STREAM-IO  .

            if tr_type = "CYC-ERR"
            then
               display
                  caps(getTermLabel("ERROR",04)) @ cerr no-label WITH STREAM-IO  .
            else
            if tr_type = "CYC-RCNT"
            then
               display
                  caps(getTermLabel("RECOUNT",04)) @ cerr WITH STREAM-IO  .
         ***********xp001*/ 
/*xp001***********end*/


         end.  /* IF tr_type <> "CYC-ERR" */
      end.     /* IF AVAILABLE pt_mstr... */

      if last(tr_effdate)
      then do:


/*xp001*********begin*/
            x_row = x_row + 1.
            x_col = 13 .
            xworksheet:cells(x_row,x_col) = "----------" .
            x_col = x_col + 1.
            xworksheet:cells(x_row,x_col) = "----------" .

            x_row = x_row + 1.
            x_col = 13 .
            xworksheet:cells(x_row,x_col) = (accum total tr_qty_loc ) .
            x_col = x_col + 1.
            xworksheet:cells(x_row,x_col) = (accum total tr_gl_amt  ) .

         /*xp001************
         underline  tr_qty_chg.
         display accum total tr_qty_loc  @ tr_qty_chg WITH STREAM-IO  .
         down 1.
         display accum total tr_gl_amt @ tr_qty_chg WITH STREAM-IO  .  
         ***********xp001*/ 
/*xp001***********end*/ 


      end. /* IF LAST(tr_effdate) */
      
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

   end. /* FOR EACH tr_hist */

   assign
      within_tol = (accum count total_hits) * 100
      within_tol = within_tol / accum count total_count.

   if within_tol = ?
   then
      within_tol = 0.

   do with frame c:

/*xp001*********begin*/
/*xp002************
            x_row = x_row + 1.
            x_row = x_row + 1.
            x_col = 1 .
            xworksheet:cells(x_row,x_col) = "已盘点零件数" .
            x_col = x_col + 1.
            xworksheet:cells(x_row,x_col) = "容差内数量" .
            x_col = x_col + 1.
            xworksheet:cells(x_row,x_col) = "容差内百分比" .
            x_col = x_col + 1.
            xworksheet:cells(x_row,x_col) = "已重盘零件数" .
            
            x_row = x_row + 1.
            x_col = 1 .
            xworksheet:cells(x_row,x_col) = accum count total_count  .
            x_col = x_col + 1.
            xworksheet:cells(x_row,x_col) = accum count total_hits .
            x_col = x_col + 1.
            xworksheet:cells(x_row,x_col) = within_tol .
            x_col = x_col + 1.
            xworksheet:cells(x_row,x_col) = accum count total_recount  .
***********xp002*/ 

                    
/*xp001***********end*/ 

      /*xp001************       
      setFrameLabels(frame c:handle).
      display
         accum count total_count   @ accum-total-count
                                   label "Items Counted"
         accum count total_hits    @ accum-total-hits
                                   label "In Tolerance Qty"
         within_tol                label "In Tolerance Pct"
         accum count total_recount @ accum-total-recount
                                   label "Items Recounted"
      with frame c width 132 no-attr-space STREAM-IO .
      ***********xp001*/
   end.   /* IF within_tol = ? */

   if print-footnote
   then do:
      /* Annual usage variance cannot be calculated */
      {pxmsg.i &MSGNUM=1292 &MSGBUFFER=c-msg}
      c-msg = getTermLabel("NOTE",8) + ": * = " + c-msg.
      /*  display
         c-msg format "x(80)" no-label
      with frame d width 132 no-attr-space STREAM-IO . *xp001*/
        /*xp001*********begin*/
        /*xp002************        
        x_row = x_row + 1.
        x_row = x_row + 1.
        xworksheet:Rows(x_row):select.
        xworksheet:Rows(x_row):merge.
        x_col = 1 .
        xworksheet:cells(x_row,x_col) = c-msg .
        ***********xp002*/ 
        /*xp001***********end*/ 
   end.    /* IF print-footnote     */


/*xp001*********begin*/
xworksheet:Columns:EntireColumn:AutoFit . 
xworksheet:cells(1,1):select.

/*xp002*********begin*/
xworksheet:Columns("P"):Hidden = True .
xworksheet:Columns("Q"):Hidden = True .
xworksheet:Columns("R"):Hidden = True .
xworksheet:Columns("S"):Hidden = True .
/*
xworksheet:pagesetup:
xworksheet:pagesetup:
xworksheet:pagesetup:
xworksheet:pagesetup:*/
xworksheet:pagesetup:Zoom = 70 . /*缩放比*/
xworksheet:pagesetup:CenterFooter = "第 &P 页，共 &N 页" . /*页脚*/
xworksheet:pagesetup:PrintGridlines = True . /*网格线*/
xworksheet:pagesetup:Orientation = 2 .  /*横向*/
xworksheet:pagesetup:PrintTitleRows = "$1:$2" . /*页面标题行*/
xworksheet:pagesetup:PrintTitleColumns = "" .  /*页面标题列*/
xworksheet:pagesetup:LeftMargin   = xapplication:InchesToPoints(0.551181102362205) .  /*左边距*/
xworksheet:pagesetup:RightMargin  = xapplication:InchesToPoints(0.354330708661417) .  /*右边距*/
xworksheet:pagesetup:TopMargin    = xapplication:InchesToPoints(0.590551181102362) .  /*上边距*/
xworksheet:pagesetup:BottomMargin = xapplication:InchesToPoints(0.393700787401575) .  /*下边距*/
xworksheet:pagesetup:HeaderMargin = xapplication:InchesToPoints(0.511811023622047) .  /*页眉*/
xworksheet:pagesetup:FooterMargin = xapplication:InchesToPoints(0.196850393700787) .  /*页脚*/
/*xp002***********end*/ 


xapplication:displayalerts = false.
xworkbook:SaveAs("C:\周期盘点差异报表.xls",,,,,,1).
xapplication:visible = true.  
xworkbook:printpreview.

release object xworksheet.
release object xworkbook.
release object xapplication.
/*xp001***********end*/ 

end. /*mainloop*/
end. /* REPEAT */
{wbrp04.i &frame-spec = a}
