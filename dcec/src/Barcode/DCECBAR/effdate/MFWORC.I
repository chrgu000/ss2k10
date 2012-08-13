/* GUI CONVERTED from mfworc.i (converter v1.77) Tue Apr 24 09:58:21 2007 */
/* mfworc.i - WORK ORDER RECEIPT FRAME DEFINITION                       */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:WebEnabled=No                                             */
/* REVISION: 7.5     LAST MODIFIED: 10/05/94    BY: taf *J035*          */
/* REVISION: 7.5     LAST MODIFIED: 10/05/94    BY: pma *J040*          */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mfworc_i_1 "L/S"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworc_i_2 "²Î¿¼"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
wo_nbr         colon 15
            wo_lot         colon 40
            wo_batch       colon 56
            wo_rmks        colon 15
            wo_part        colon 15
            pt_lot_ser     label {&mfworc_i_1} colon 56
            pt_um          colon 63
            pt_desc1       colon 15
            wo_status      colon 56
            open_ref       colon 15
            pt_auto_lot    colon 56
            skip(1)
            lotserial_qty  colon 15
            site           colon 54
            um             colon 15
            location       colon 54
            conv           colon 15
            lotserial      colon 54
            reject_qty     colon 15
            lotref         colon 54 label {&mfworc_i_2}
            reject_um      colon 15
            multi_entry    colon 54
            reject_conv    colon 15
            chg_attr       colon 54
            tot_units      colon 54
            skip(1)
            rmks           colon 15
            eff_date       colon 15
            close_wo       colon 15
           SKIP(.4)  /*GUI*/
with frame a THREE-D side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


