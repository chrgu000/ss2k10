/* xxsfoprp13.p - OPERATIONS BY GROUP BY EMPLOYEE REPORT                    */
/* GUI CONVERTED from sfoprp13.p (converter v1.71) Tue Oct  6 14:48:28 1998 */
/* sfoprp13.p - OPERATIONS BY EMPLOYEE REPORT                           */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert sfoprp13.p (converter v1.00) Fri Oct 10 13:57:21 1997 */
/* web tag in sfoprp13.p (converter v1.00) Mon Oct 06 14:17:47 1997 */
/*F0PN*/ /*K0Y9*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.0      LAST MODIFIED: 07/17/86   BY: PML */
/* REVISION: 2.0      LAST MODIFIED: 05/20/87   BY: EMB */
/* REVISION: 2.1      LAST MODIFIED: 10/20/87   BY: WUG *A94**/
/* REVISION: 4.0      LAST MODIFIED: 02/17/88   BY: RL  *A171**/
/* REVISION: 4.0      LAST MODIFIED: 02/24/88   BY: WUG *A175**/
/* REVISION: 4.0      LAST MODIFIED: 08/26/88   BY: flm *A411**/
/* REVISION: 5.0      LAST MODIFIED: 07/17/89   BY: MLB *B189**/
/* REVISION: 5.0      LAST MODIFIED: 02/09/90   BY: MLB *B560**/
/* REVISION: 5.0      LAST MODIFIED: 05/21/90   BY: pml *B689**/
/* REVISION: 6.0      LAST MODIFIED: 01/18/91   BY: bjb *D248**/
/* REVISION: 7.2      LAST MODIFIED: 12/30/94   BY: cpp *FT95**/
/* REVISION: 8.6      LAST MODIFIED: 10/14/97   BY: ckm *K0Y9**/

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/21/2000  BY: *JY000* *Frankie Xu*/

/*K0Y9*/ /* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*K0Y9*/ {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sfoprp13_p_1 "合计: "
/* MaxLen: Comment: */

&SCOPED-DEFINE sfoprp13_p_2 " 雇员: "
/* MaxLen: Comment: */

&SCOPED-DEFINE sfoprp13_p_3 "完成量"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfoprp13_p_4 "班组"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


define variable wkctr like wc_wkctr.
define variable wkctr1 like wc_wkctr.
define variable nbr like wr_nbr.
define variable nbr1 like wr_nbr.
define variable emp like op_emp.
define variable emp1 like op_emp.
define variable opdate like op_date.
define variable opdate1 like op_date.
define variable desc1 like pt_desc1.
/*D248
define variable s_num as character extent 6.
define variable d_num as decimal decimals 9 extent 6.
define variable i as integer.
define variable j as integer.                           */

/*B189define variable s_tot as character.*/
define variable lot like op_wo_lot.
define variable lot1 like op_wo_lot.

define variable gup  like emp_user1 label {&sfoprp13_p_4}.
define variable gup1 like emp_user1 label {&sfoprp13_p_4}.


/*K0Y9* /* DISPLAY TITLE */
 *K0Y9* {mfdtitle.i "e+ "}
 *K0Y9*/


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
   gup            colon 15
   gup1           label {t001.i} colon 49 skip
   emp            colon 15
   emp1           label {t001.i} colon 49 skip
   opdate         colon 15
   opdate1        label {t001.i} colon 49
   nbr            colon 15
   nbr1           label {t001.i} colon 49
   lot            colon 15
   lot1           label {t001.i} colon 49
   wkctr          colon 15
   wkctr1         label {t001.i} colon 49 skip (1)
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " 选择条件 "
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




/*K0Y9*/ {wbrp01.i}

/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


   if gup1 = hi_char then emp1 = "".
   if emp1 = hi_char then emp1 = "".
   if opdate = low_date then opdate = ?.
   if opdate1 = hi_date then opdate1 = ?.
   if nbr1 = hi_char then nbr1 = "".
   if wkctr1 = hi_char then wkctr1 = "".
   if lot1 = hi_char then lot1 = "".


/*K0Y9*/ if c-application-mode <> 'web':u then
   
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


/*K0Y9*/ {wbrp06.i &command = update &fields = " gup gup1 emp emp1 opdate opdate1 nbr nbr1
lot lot1 wkctr wkctr1" &frm = "a"}

/*K0Y9*/ if (c-application-mode <> 'web':u) or
/*K0Y9*/ (c-application-mode = 'web':u and
/*K0Y9*/ (c-web-request begins 'data':u)) then do:


   bcdparm = "".
   {mfquoter.i gup    }
   {mfquoter.i gup1   }
   {mfquoter.i emp    }
   {mfquoter.i emp1   }
   {mfquoter.i opdate }
   {mfquoter.i opdate1}
   {mfquoter.i nbr    }
   {mfquoter.i nbr1   }
   {mfquoter.i lot    }
   {mfquoter.i lot1   }
   {mfquoter.i wkctr  }
   {mfquoter.i wkctr1 }

   if gup1 = "" then gup1 = hi_char.
   if emp1 = "" then emp1 = hi_char.
   if opdate = ? then opdate = low_date.
   if opdate1 = ? then opdate1 = hi_date.
   if nbr1 = "" then nbr1 = hi_char.
   if wkctr1 = "" then wkctr1 = hi_char.
   if lot1 = "" then lot1 = hi_char.

/*K0Y9*/ end.

   /* SELECT PRINTER */
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:



   {mfphead.i}

   for each op_hist where (op_emp >= emp and op_emp <= emp1)
   and (op_date >= opdate and op_date <= opdate1)
   and (op_wo_nbr >= nbr and op_wo_nbr <= nbr1)
   and (op_wo_lot >= lot and op_wo_lot <= lot1)
   and (op_wkctr >= wkctr and op_wkctr <= wkctr1)
/*B689*/
   and (substring(op_type,1,4)  <>  "down"),
   each emp_mstr where (emp_addr = op_emp ) 
   and (emp_user1 >= gup and op_emp <= gup1) 
/*FT95*
   no-lock break by op_emp by op_date with frame b width 332 no-attr-space: */
/*FT95*/  no-lock break by emp_user1 by op_emp by op_date
/*FT95*/  with frame b width 333 no-attr-space no-box:

/*B689
/*B560*/ if op_type begins "down" then next.  */
   find wo_mstr where wo_lot = op_wo_lot no-lock no-error.
   find pt_mstr where pt_part = wo_part no-lock no-error.
      if first-of(emp_user1) then do:
         if page-size - line-counter < 4 then page.
         display WITH STREAM-IO /*GUI*/ .
         put {&sfoprp13_p_4} emp_user1 .
/***     space(5)  {&sfoprp13_p_2} op_emp.  **/
/**      find emp_mstr where emp_addr = op_emp no-lock no-error. **/
/***     if available emp_mstr then put space(1) emp_lname.  ***/     
         put skip(1).
      end.

/*D248
      d_num[1] = op_qty_wip.
      d_num[2] = op_qty_comp.
      d_num[3] = op_qty_rjct.
      d_num[4] = op_qty_rwrk.
      d_num[5] = op_act_setup.
      d_num[6] = op_act_run.
      do i = 1 to 6:
         if i <= 4 then j = 10.
         else if i = 5 then j = 13.
     else j = 11.
     {mffloat.i d_num[i] " " s_num[i] j}
      end.                                                    */

/*B189      s_tot = "".*/
/*D248 display op_trnbr label "Tran" op_date label "Date"
 *    op_wo_nbr op_wo_lot op_wo_op label "Op" op_wkctr
 *    s_num[1] format "x(10)" @ op_qty_wip format "-999,999.9"
 *    s_num[2] format "x(10)" @ op_qty_comp format "-999,999.9"
 *    label " Qty Comp"
 *    s_num[3] format "x(10)" @ op_qty_rjct format "-999,999.9"
 *    s_num[4] format "x(10)" @ op_qty_rwrk format "-999,999.9"
 *    s_num[5] format "x(13)" @ op_act_setup format "-99,999,999.9"
 *    s_num[6] format "x(11)" @ op_act_run format "-9,999,999.9".   */

/*D248*/
/*FT95*  display op_trnbr op_date */
/*FT95*/ display op_emp op_trnbr format ">>>>>>>9" op_date
     pt_part pt_desc1 pt_desc2 op_wo_nbr op_wo_lot  op_wo_op op_wkctr wo_qty_ord
     op_qty_wip
     op_qty_comp
     label {&sfoprp13_p_3}
/*FT95*  op_qty_rjct */
/*FT95*/ op_qty_rjct format "->>>>,>>9.9<<<<<<<"
/*FT95*  op_qty_rwrk */
/*FT95*/ op_qty_rwrk format "->>>>,>>9.9<<<<<<<"
     op_act_setup
     op_act_run WITH STREAM-IO width 330 /*GUI*/ .
/*B189      s_tot no-label format "x(5)".*/
      accumulate op_qty_comp (total by emp_user1).
      accumulate op_qty_rjct (total by emp_user1).
      accumulate op_act_setup (total by emp_user1).
      accumulate op_act_run (total by emp_user1).
      if last-of (emp_user1) then do:
/*D248   d_num[1] = accum total by emp_user1 op_qty_comp.
     d_num[2] = accum total by emp_user1 op_qty_rjct.
     d_num[3] = accum total by emp_user1 op_act_setup.
     d_num[4] = accum total by emp_user1 op_act_run.
     do i = 1 to 4:
        if i = 3 then j = 13.
        else if i = 4 then j = 11.
        else j = 10.
        {mffloat.i d_num[i] " " s_num[i] j}
     end.                                               */

     down 1.
/*D248*/ display "------------" @ op_qty_comp "------------" @ op_qty_rjct
/*D248*/ "---------" @ op_act_setup "--------" @ op_act_run WITH STREAM-IO /*GUI*/ .
     down 1.
     display
     {&sfoprp13_p_1} @ op_qty_wip
/*D248*/ (accum total by emp_user1 op_qty_comp) @ op_qty_comp
     (accum total by emp_user1 op_qty_rjct) @ op_qty_rjct
     (accum total by emp_user1 op_act_setup) @ op_act_setup
     (accum total by emp_user1 op_act_run) @ op_act_run WITH STREAM-IO /*GUI*/ .

/*D248   s_num[1] format "x(10)" @ op_qty_comp
     s_num[2] format "x(10)" @ op_qty_rjct
     s_num[3] format "x(13)" @ op_act_setup
     s_num[4] format "x(11)" @ op_act_run.              */
/*D248*/
     /*B189"TOTAL" @ s_tot.*/
      end.
      if last (emp_user1) then do:
/*D248   d_num[1] = accum total op_qty_comp.
     d_num[2] = accum total op_qty_rjct.
     d_num[3] = accum total op_act_setup.
     d_num[4] = accum total op_act_run.
     do i = 1 to 4:
        if i = 3 then j = 13.
        else if i = 4 then j = 11.
        else j = 10.
        {mffloat.i d_num[i] " " s_num[i] j}
     end.                                           */
     down 2.
     display "------------" @ op_qty_comp "------------" @ op_qty_rjct
     "---------" @ op_act_setup "--------" @ op_act_run WITH STREAM-IO /*GUI*/ .
     down 1.
     display
     {&sfoprp13_p_1} @ op_qty_wip
/*D248*/ (accum total op_qty_comp) @ op_qty_comp
/*D248*/ (accum total op_qty_rjct) @ op_qty_rjct
/*D248*/ (accum total op_act_setup) @ op_act_setup
/*D248*/ (accum total op_act_run) @ op_act_run WITH STREAM-IO /*GUI*/ .

/*D248   s_num[1] format "x(10)" @ op_qty_comp
     s_num[2] format "x(10)" @ op_qty_rjct
     s_num[3] format "x(13)" @ op_act_setup
     s_num[4] format "x(11)" @ op_act_run.              */
     /*B189"TOTAL" @ s_tot.*/
      end.
      /* END SECTION */

      
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

   end.

   /* REPORT TRAILER */
   
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


end.

/*K0Y9*/ {wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" gup gup1 emp emp1 opdate opdate1 nbr nbr1 lot lot1 wkctr wkctr1 "} /*Drive the Report*/
