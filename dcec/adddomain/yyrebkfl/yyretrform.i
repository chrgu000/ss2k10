/* GUI CONVERTED from retrform.i (converter v1.78) Sun Jan 30 18:06:44 2005 */
/* retrform.i - REPETITIVE                                                    */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.16 $                                                         */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.3               LAST MODIFIED: 10/31/94   BY: WUG *GN77*       */
/*                                            02/28/95   by: srk *G0FZ*       */
/* REVISION: 7.3               LAST MODIFIED: 03/07/95   BY: WUG *G0GQ*       */
/* REVISION: 7.3               LAST MODIFIED: 03/08/95   BY: WUG *G0GR*       */
/* REVISION: 7.3               LAST MODIFIED: 03/17/95   BY: pcd *G0HN*       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb                */
/* REVISION: 9.1      LAST MODIFIED: 09/11/00   BY: *N0RS* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Revision: 1.10     BY: Kirti Desai    DATE: 11/01/01  ECO: *N151*          */
/* Revision: 1.13     BY: Narathip W.    DATE: 04/19/03  ECO: *P0Q7*          */
/* Revision: 1.15     BY: Max Iles       DATE: 09/09/04  ECO: *N2XQ*          */
/* $Revision: 1.16 $    BY: Matthew Lee  DATE: 01/26/05  ECO: *P356*          */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
{cxcustom.i "RETRFORM.I"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE retrform_i_1 "Op"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_2 "Conv"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_3 "Act Setup Time"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_4 "Cum Completed Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_5 "BOM"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_7 "Elapsed or Stop Time"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_8 "Move Next Op"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_9 "Input/Output"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_10 "Multi Entry"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_11 "Inv Discrep Acct"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_12 "Modify Backflush"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_13 "Modify Receipt"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_14 "From Queue"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_15 "Start Time"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_16 "To Operation"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_17 "To Queue"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_18 "Reject To Op"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_19 "Qty Reworked"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_20 "Reason Code"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_21 "Qty Scrapped"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_22 "Qty Rejected"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_23 "Qty Processed"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_24 "Qty To Move"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_25 "Routing"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* TRANSACTIONS INPUT FORM/FRAME DEFINITIONS                                  */

define {1} shared variable act_run_hrs        like op_act_run.
define {1} shared variable act_setup_hrs      like op_act_run
   label {&retrform_i_3}.
define {1} shared variable bom_code           like wo_bom_code
   label {&retrform_i_5}.
define {1} shared variable earn_code          like op_earn.
define {1} shared variable conv              like um_conv label {&retrform_i_2}.
define {1} shared variable cum_comp_qty       like wr_qty_comp
   label {&retrform_i_4}.
define {1} shared variable dept               like dpt_dept.
define {1} shared variable discr_acct         like glt_acct
   label {&retrform_i_11}.
define {1} shared variable discr_sub          like glt_sub.
define {1} shared variable discr_cc           like glt_cc.
define {1} shared variable down_rsn_code      like rsn_code.
define {1} shared variable eff_date           like tr_effdate.
define {1} shared variable emp                like op_emp.
define {1} shared variable from_que           like mfc_logical
   label {&retrform_i_14}
   format {&retrform_i_9}.
define {1} shared variable inque_rsn_code     like rsn_code.
define {1} shared variable inque_multi_entry  like mfc_logical
   label {&retrform_i_10}.
define {1} shared variable line               like ln_line.
define {1} shared variable mch                like wc_mch no-undo.
define {1} shared variable mod_issrc          like mfc_logical
   label {&retrform_i_12}.
define {1} shared variable move_next_op       like mfc_logical
   label {&retrform_i_8}.
define {1} shared variable op                 like ro_op no-undo.
define {1} shared variable outque_rsn_code    like rsn_code.
define {1} shared variable outque_multi_entry like mfc_logical
   label {&retrform_i_10}.
define {1} shared variable part               like pt_part.
define {1} shared variable qty_proc           like op_qty_comp
   label {&retrform_i_23}.
define {1} shared variable qty_move           like wr_qty_move
   label {&retrform_i_24}.
define {1} shared variable qty_inque          like wr_qty_inque.
define {1} shared variable qty_outque         like wr_qty_outque.
define {1} shared variable qty_rejque         like wr_qty_rejque.
define {1} shared variable qty_rjct           like op_qty_rjct
   label {&retrform_i_22}.
define {1} shared variable qty_rwrk           like op_qty_rjct
   label {&retrform_i_19}.
define {1} shared variable qty_scrap          like op_qty_rjct
   label {&retrform_i_21}.
define {1} shared variable rejque_rsn_code    like rsn_code.
define {1} shared variable rejque_multi_entry like mfc_logical
   label {&retrform_i_10}.
define {1} shared variable rwrk_rsn_code      like rsn_code.
define {1} shared variable rwrk_multi_entry   like mfc_logical
   label {&retrform_i_10}.
define {1} shared variable rjct_rsn_code      like rsn_code.
define {1} shared variable run_ea_desc        like ea_desc.
define {1} shared variable routing            like wo_routing
   label {&retrform_i_25}.
define {1} shared variable scrap_rsn_code     like rsn_code.
define {1} shared variable setup_ea_desc      like ea_desc.
define {1} shared variable shift              like op_shift.
define {1} shared variable site               like op_site.
define {1} shared variable start_run as character label {&retrform_i_15}
   format "99:XX:XX".
define {1} shared variable stop_run           like start_run
   label {&retrform_i_7}.
define {1} shared variable to_op          like op_wo_op label {&retrform_i_16}.
define {1} shared variable to_que             like mfc_logical
   label {&retrform_i_17}
   format {&retrform_i_9}.
define {1} shared variable um                 like pt_um.
define {1} shared variable wkctr              like wc_wkctr no-undo.
{&RETRFORM-I-TAG1}

define {1} shared frame a.
define {1} shared frame b.
define {1} shared frame bkfl1.
define {1} shared frame reject1.
define {1} shared frame scrap1.
define {1} shared frame lbr1.
define {1} shared frame set1.
define {1} shared frame dt1.
define {1} shared frame rework1.
define {1} shared frame move1.
define {1} shared frame adjust1.
define {1} shared frame cumadj1.

define variable valmsg as character.

{pxmsg.i &MSGNUM=4291 &ERRORLEVEL=3 &MSGBUFFER=valmsg}

/* Replaced all occurrences of {reval.i} with validate message */

{&RETRFORM-I-TAG2}

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
   emp          colon 13
   ad_name               no-label no-attr-space
   eff_date     colon 13 validate(eff_date <> ?,valmsg)
   shift                 validate(shift <> ?,valmsg)
   site
   part         colon 13
   pt_desc1     at 36    no-label no-attr-space
   op           colon 13
   wr_desc      at 36    no-label no-attr-space
   line         colon 13
   ln_desc      at 36    no-label no-attr-space
   routing      colon 13
   bom_code     colon 43
   wo_lot
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

/*
 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =  
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


{&RETRFORM-I-TAG3}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
space(1)
   site
   part
   op                    label {&retrform_i_1}
   line
 SKIP(.4)  /*GUI*/
with frame b side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.
/*
 DEFINE VARIABLE F-b-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:HIDDEN in frame b = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5.  /*GUI*/
*/

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
wkctr              colon 18
   mch                colon 43
   wc_desc                     no-label no-attr-space
   dept               colon 18
   dpt_desc           at 36    no-label no-attr-space
   qty_proc           colon 18 validate(qty_proc <> ?,valmsg)
   um                 colon 45 validate(um <> ?,valmsg)
   conv               colon 61 validate(conv <> ?,valmsg)
   qty_scrap          colon 18 validate(qty_scrap <> ?,valmsg)
   scrap_rsn_code     colon 45 label {&retrform_i_20}
   validate(scrap_rsn_code <> ?,valmsg)
   outque_multi_entry          validate(outque_multi_entry <> ?,valmsg)
   qty_rjct           colon 18 validate(qty_rjct <> ?,valmsg)
   rjct_rsn_code      colon 45 label {&retrform_i_20}
   validate(rjct_rsn_code <> ?,valmsg)
   rejque_multi_entry          validate(rejque_multi_entry <> ?,valmsg)
   to_op              colon 18 label {&retrform_i_18}
   mod_issrc          colon 45 validate(mod_issrc <> ?,valmsg)
   move_next_op       colon 68 validate(move_next_op <> ?,valmsg)
   act_run_hrs        colon 18 validate(act_run_hrs <> ?,valmsg)
   start_run          colon 68 validate(start_run <> ?,valmsg)
   earn_code          colon 18
   ea_desc                     no-label no-attr-space format "x(22)"
   stop_run           colon 68 validate(stop_run <> ?,valmsg)
 SKIP(.4)  /*GUI*/
with frame bkfl1 side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.
/*
 DEFINE VARIABLE F-bkfl1-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame bkfl1 = F-bkfl1-title.
 RECT-FRAME-LABEL:HIDDEN in frame bkfl1 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame bkfl1 =
  FRAME bkfl1:HEIGHT-PIXELS - RECT-FRAME:Y in frame bkfl1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME bkfl1 = FRAME bkfl1:WIDTH-CHARS - .5.  /*GUI*/
*/

if {gpiswrap.i} then
   assign
   start_run:format = "9XXXXX"
   stop_run:format  = "9XXXXX".

/* SET EXTERNAL LABELS */
setFrameLabels(frame bkfl1:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
wkctr              colon 18
   mch                colon 43
   wc_desc                     no-label no-attr-space
   dept               colon 18
   dpt_desc           at 36    no-label no-attr-space
   um                 colon 18 validate(um <> ?,valmsg)
   conv               colon 45 validate(conv <> ?,valmsg)
   from_que           colon 18 validate(from_que <> ?,valmsg)
   qty_rjct           colon 18 validate(qty_rjct <> ?,valmsg)
   rjct_rsn_code      colon 45 label {&retrform_i_20}
   validate(rjct_rsn_code <> ?,valmsg)
   rejque_multi_entry          validate(rejque_multi_entry <> ?,valmsg)
   to_op              colon 18
   wr_desc                     no-label
 SKIP(.4)  /*GUI*/
with frame reject1 side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.
/*
 DEFINE VARIABLE F-reject1-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame reject1 = F-reject1-title.
 RECT-FRAME-LABEL:HIDDEN in frame reject1 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame reject1 =
  FRAME reject1:HEIGHT-PIXELS - RECT-FRAME:Y in frame reject1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME reject1 = FRAME reject1:WIDTH-CHARS - .5.  /*GUI*/
*/

/* SET EXTERNAL LABELS */
setFrameLabels(frame reject1:handle).

to_op:label in frame reject1 = getTermLabel("TO_OPERATION",16).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
wkctr              colon 18
   mch                colon 43
   wc_desc                     no-label no-attr-space
   dept               colon 18
   dpt_desc           at 36    no-label no-attr-space
   um                 colon 18 validate(um <> ?,valmsg)
   conv               colon 45 validate(conv <> ?,valmsg)
   qty_inque          colon 18 validate(qty_inque <> ?,valmsg)
   inque_rsn_code     colon 45 validate(inque_rsn_code <> ?,valmsg)
   inque_multi_entry           validate(inque_multi_entry <> ?,valmsg)
   qty_outque         colon 18 validate(qty_outque <> ?,valmsg)
   outque_rsn_code    colon 45 validate(outque_rsn_code <> ?,valmsg)
   outque_multi_entry          validate(outque_multi_entry <> ?,valmsg)
   qty_rejque         colon 18 validate(qty_rejque <> ?,valmsg)
   rejque_rsn_code    colon 45 validate(rejque_rsn_code <> ?,valmsg)
   rejque_multi_entry          validate( rejque_multi_entry <> ?,valmsg)
 SKIP(.4)  /*GUI*/
with frame scrap1 side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.
/*
 DEFINE VARIABLE F-scrap1-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame scrap1 = F-scrap1-title.
 RECT-FRAME-LABEL:HIDDEN in frame scrap1 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame scrap1 =
  FRAME scrap1:HEIGHT-PIXELS - RECT-FRAME:Y in frame scrap1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME scrap1 = FRAME scrap1:WIDTH-CHARS - .5.  /*GUI*/
*/

/* SET EXTERNAL LABELS */
setFrameLabels(frame scrap1:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
wkctr        colon 16
   mch          colon 43
   wc_desc               no-label no-attr-space
   dept         colon 16
   dpt_desc     at 36    no-label no-attr-space
   skip(1)
   act_run_hrs  colon 16 validate(act_run_hrs <> ?,valmsg)
   start_run    colon 68 validate(start_run <> ?,valmsg)
   earn_code    colon 16
   ea_desc      no-label no-attr-space format "x(22)"
   stop_run     colon 68 validate(stop_run <> ?,valmsg)
 SKIP(.4)  /*GUI*/
with frame lbr1 side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.
/*
 DEFINE VARIABLE F-lbr1-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame lbr1 = F-lbr1-title.
 RECT-FRAME-LABEL:HIDDEN in frame lbr1 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame lbr1 =
  FRAME lbr1:HEIGHT-PIXELS - RECT-FRAME:Y in frame lbr1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME lbr1 = FRAME lbr1:WIDTH-CHARS - .5.  /*GUI*/
*/
if {gpiswrap.i} then
   assign
   start_run:format = "9XXXXX"
   stop_run:format  = "9XXXXX".

/* SET EXTERNAL LABELS */
setFrameLabels(frame lbr1:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
wkctr         colon 16
   mch           colon 43
   wc_desc                no-label no-attr-space
   dept          colon 16
   dpt_desc      at 36    no-label no-attr-space
   skip(1)
   act_setup_hrs colon 16 validate(act_setup_hrs <> ?,valmsg)
   start_run     colon 68 validate(start_run <> ?,valmsg)
   earn_code     colon 16
   ea_desc                no-label no-attr-space format "x(22)"
   stop_run      colon 68 validate(stop_run <> ?,valmsg)
 SKIP(.4)  /*GUI*/
with frame set1 side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.
/*
 DEFINE VARIABLE F-set1-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame set1 = F-set1-title.
 RECT-FRAME-LABEL:HIDDEN in frame set1 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame set1 =
  FRAME set1:HEIGHT-PIXELS - RECT-FRAME:Y in frame set1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME set1 = FRAME set1:WIDTH-CHARS - .5.  /*GUI*/
*/
if {gpiswrap.i} then
   assign
   start_run:format = "9XXXXX"
   stop_run:format  = "9XXXXX".

/* SET EXTERNAL LABELS */
setFrameLabels(frame set1:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
wkctr          colon 18
   mch            colon 43
   wc_desc                 no-label no-attr-space
   dept           colon 18
   dpt_desc       at 36    no-label no-attr-space
   start_run      colon 68 validate(start_run <> ?,valmsg)
   act_run_hrs    colon 18 validate(act_run_hrs <> ?,valmsg)
   stop_run       colon 68 validate(stop_run <> ?,valmsg)
   down_rsn_code  colon 18 validate(down_rsn_code <> ?,valmsg)
   earn_code      colon 18
   ea_desc        no-label no-attr-space format "x(22)"
 SKIP(.4)  /*GUI*/
with frame dt1 side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.
/*
 DEFINE VARIABLE F-dt1-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame dt1 = F-dt1-title.
 RECT-FRAME-LABEL:HIDDEN in frame dt1 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame dt1 =
  FRAME dt1:HEIGHT-PIXELS - RECT-FRAME:Y in frame dt1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME dt1 = FRAME dt1:WIDTH-CHARS - .5.  /*GUI*/
*/
if {gpiswrap.i} then
   assign
   start_run:format = "9XXXXX"
   stop_run:format  = "9XXXXX".

/* SET EXTERNAL LABELS */
setFrameLabels(frame dt1:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
wkctr            colon 18
   mch              colon 43
   wc_desc                   no-label no-attr-space
   dept             colon 18
   dpt_desc         at 36    no-label no-attr-space
   um               colon 18 validate(um <> ?,valmsg)
   conv             colon 45 validate(conv <> ?,valmsg)
   qty_rwrk         colon 18 validate(qty_rwrk <> ?,valmsg)
   rwrk_rsn_code    colon 45 label {&retrform_i_20}
   validate(rwrk_rsn_code <> ?,valmsg)
   rwrk_multi_entry          validate(rwrk_multi_entry <> ?,valmsg)
   mod_issrc        colon 18 validate(mod_issrc <> ?,valmsg)
   act_run_hrs      colon 18 validate(act_run_hrs <> ?,valmsg)
   start_run        colon 68 validate(start_run <> ?,valmsg)
   earn_code        colon 18
   ea_desc                   no-label no-attr-space format "x(22)"
   stop_run         colon 68 validate(stop_run <> ?,valmsg)
   to_op            colon 18
   wr_desc                   no-label
   to_que           colon 68
 SKIP(.4)  /*GUI*/
with frame rework1 side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.
/*
 DEFINE VARIABLE F-rework1-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame rework1 = F-rework1-title.
 RECT-FRAME-LABEL:HIDDEN in frame rework1 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame rework1 =
  FRAME rework1:HEIGHT-PIXELS - RECT-FRAME:Y in frame rework1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME rework1 = FRAME rework1:WIDTH-CHARS - .5.  /*GUI*/
*/
if {gpiswrap.i} then
   assign
   start_run:format = "9XXXXX"
   stop_run:format  = "9XXXXX".

/* SET EXTERNAL LABELS */
setFrameLabels(frame rework1:handle).

to_op:label in frame rework1 = getTermLabel("TO_OPERATION",16).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
wkctr        colon 18
   mch          colon 43
   wc_desc               no-label no-attr-space
   dept         colon 18
   dpt_desc     at 36    no-label no-attr-space
   um           colon 18 validate(um <> ?,valmsg)
   conv         colon 45 validate(conv <> ?,valmsg)
   qty_move     colon 18 validate(qty_move <> ?,valmsg)
   mod_issrc    colon 18 label {&retrform_i_13}
   validate(mod_issrc <> ?,valmsg)
 SKIP(.4)  /*GUI*/
with frame move1 side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.
/*
 DEFINE VARIABLE F-move1-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame move1 = F-move1-title.
 RECT-FRAME-LABEL:HIDDEN in frame move1 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame move1 =
  FRAME move1:HEIGHT-PIXELS - RECT-FRAME:Y in frame move1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME move1 = FRAME move1:WIDTH-CHARS - .5.  /*GUI*/
*/

/* SET EXTERNAL LABELS */
setFrameLabels(frame move1:handle).

mod_issrc:label in frame move1 = getTermLabel("MODIFY_RECEIPT",16).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
wkctr            colon 18
   mch              colon 43
   wc_desc                   no-label no-attr-space
   dept             colon 18
   dpt_desc         at 36    no-label no-attr-space
   um               colon 18 validate(um <> ?,valmsg)
   qty_inque        colon 18 validate(qty_inque <> ?,valmsg)
   inque_rsn_code   colon 45 validate(inque_rsn_code <> ?,valmsg)
   qty_outque       colon 18 validate(qty_outque <> ?,valmsg)
   outque_rsn_code  colon 45 validate(outque_rsn_code <> ?,valmsg)
   qty_rejque       colon 18 validate(qty_rejque <> ?,valmsg)
   rejque_rsn_code  colon 45 validate(rejque_rsn_code <> ?,valmsg)
   skip(1)
   discr_acct       colon 18
   discr_sub                 no-label
   discr_cc                  no-label
 SKIP(.4)  /*GUI*/
with frame adjust1 side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.
/*
 DEFINE VARIABLE F-adjust1-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame adjust1 = F-adjust1-title.
 RECT-FRAME-LABEL:HIDDEN in frame adjust1 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame adjust1 =
  FRAME adjust1:HEIGHT-PIXELS - RECT-FRAME:Y in frame adjust1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME adjust1 = FRAME adjust1:WIDTH-CHARS - .5.  /*GUI*/
*/

/* SET EXTERNAL LABELS */
setFrameLabels(frame adjust1:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
cum_comp_qty     colon 20 validate(cum_comp_qty <> ?,valmsg)
 SKIP(.4)  /*GUI*/
with frame cumadj1 side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.
/*
 DEFINE VARIABLE F-cumadj1-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame cumadj1 = F-cumadj1-title.
 RECT-FRAME-LABEL:HIDDEN in frame cumadj1 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame cumadj1 =
  FRAME cumadj1:HEIGHT-PIXELS - RECT-FRAME:Y in frame cumadj1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME cumadj1 = FRAME cumadj1:WIDTH-CHARS - .5.  /*GUI*/
*/

/* SET EXTERNAL LABELS */
setFrameLabels(frame cumadj1:handle).
