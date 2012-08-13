/* GUI CONVERTED from worcat02.p (converter v1.71) Tue May 25 23:03:37 1999 */
/* worcat02.p - CHANGE ATTRIBUTES SETUP PROGRAM                         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 7.5      LAST MODIFIED: 01/05/95   BY: pma *J040*          */
/* REVISION: 8.5      LAST MODIFIED: 06/18/96   BY: ajw *J0TX*          */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 01/27/99   BY: *J38V* Viswanathan M*/
/* REVISION: 9.0      LAST MODIFIED: 02/22/99   BY: *M08Y* Niranjan R.      */
/* REVISION: 9.0      LAST MODIFIED: 03/30/99   BY: *J39K* Sanjeev Assudani */

         {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE worcat02_p_1 " 收货属性 "
/* MaxLen: Comment: */

&SCOPED-DEFINE worcat02_p_2 "作为保省值"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


         define input parameter wo_recid as recid.
         define input parameter chg_attr as logical.
/*J39K*/ define input parameter effect_date like glt_effdate no-undo.
         define input-output parameter chg_assay  like tr_assay no-undo.
         define input-output parameter chg_grade  like tr_grade no-undo.
         define input-output parameter chg_expire like tr_expire no-undo.
         define input-output parameter chg_status like tr_status no-undo.
         define input-output parameter assay_actv like pt_rctwo_active no-undo.
         define input-output parameter grade_actv like pt_rctwo_active no-undo.
         define input-output parameter expire_actv like pt_rctwo_active no-undo.
         define input-output parameter status_actv like pt_rctwo_active no-undo.

/*J38V** define variable resetattr like mfc_logical */
/*J38V*/ define shared variable resetattr like mfc_logical
            label {&worcat02_p_2} no-undo.

/*J0TX*  CHANGED SPACE(2) TO SPACE(3), CHANGED COLUMN 35 TO COLUMN 30  */
         FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
chg_assay    colon 20 assay_actv   colon 38 space(3) skip
            chg_grade    colon 20 grade_actv   colon 38 space(3) skip
            chg_expire   colon 20 expire_actv  colon 38 space(3) skip
            chg_status   colon 20 status_actv  colon 38 space(3) skip(1)
            resetattr    colon 20 space(3)
          SKIP(.4)  /*GUI*/
with frame attr-scr side-labels overlay row 13 column 30
          NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-attr-scr-title AS CHARACTER.
 F-attr-scr-title = {&worcat02_p_1}.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame attr-scr = F-attr-scr-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame attr-scr =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame attr-scr + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame attr-scr =
  FRAME attr-scr:HEIGHT-PIXELS - RECT-FRAME:Y in frame attr-scr - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME attr-scr = FRAME attr-scr:WIDTH-CHARS - .5. /*GUI*/


/*J0TX*  find wo_mstr exclusive where recid(wo_mstr) = wo_recid.        */
/*J0TX*/ find wo_mstr exclusive-lock where recid(wo_mstr) = wo_recid.
         find pt_mstr no-lock where pt_part = wo_part no-error.

         if chg_expire = ? and available pt_mstr and pt_shelflife <> 0
/*J39K**    then chg_expire = today + pt_shelflife. */
/*J39K*/    then chg_expire = effect_date + pt_shelflife.

         /*CHANGE ATTRIBUTES*/
         if chg_attr then
         chg-block:
         do on error undo chg-block, retry with frame attr-scr:
/*GUI*/ if global-beam-me-up then undo, leave.

            update
               chg_assay when ({gppswd3.i &field=""wo_assay""})
               assay_actv when ({gppswd3.i &field=""wo_assay""})
               chg_grade when ({gppswd3.i &field=""wo_grade""})
               grade_actv when ({gppswd3.i &field=""wo_grade""})
               chg_expire when ({gppswd3.i &field=""wo_expire""})
               expire_actv when ({gppswd3.i &field=""wo_expire""})
               chg_status when ({gppswd3.i &field=""wo_rctstat""})
               status_actv when ({gppswd3.i &field=""wo_rctstat""})
               resetattr.

/*M08Y**       if not can-find(is_mstr where is_status = chg_status) then do: */
/*M08Y*/       if (status_actv or chg_status <> "") and
/*M08Y*/           not can-find (is_mstr where is_status = chg_status)
/*M08Y*/       then do:
/*M08Y**          {mfmsg.i 362 3} /*STATUS DOES NOT EXIST*/ */
/*M08Y*/          /* INVENTORY STATUS IS NOT DEFINED */
/*M08Y*/          {mfmsg.i 361 3}
                  next-prompt chg_status.
                  undo chg-block, retry.
               end. /* IF (STATUS_ACTV ... */
         end.
/*GUI*/ if global-beam-me-up then undo, leave.


         hide frame attr-scr no-pause.

         /*RESET WORK ORDER ATTRIBUTES*/
         if resetattr then do:
            if assay_actv  then wo_assay = chg_assay.
                           else wo_assay = 0.
            if grade_actv  then wo_grade = chg_grade.
                           else wo_grade = "".
            if expire_actv then wo_expire = chg_expire.
                           else wo_expire = ?.
            if status_actv then wo_rctstat = chg_status.
                           else wo_rctstat = "".
            wo_rctstat_active = status_actv.
         end.
