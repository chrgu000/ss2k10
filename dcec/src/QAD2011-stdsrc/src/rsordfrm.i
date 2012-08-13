/* GUI CONVERTED from rsordfrm.i (converter v1.78) Fri Oct 29 15:38:32 2004 */
/* rsordfrm.i - Release Management Supplier Schedules                   */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.23 $                                                       */
/*F0PN*/ /*V8:ConvertMode=ReportAndMaintenance                          */
/* REVISION: 7.3    LAST MODIFIED: 09/30/92     BY: WUG *G462*          */
/* REVISION: 7.3    LAST MODIFIED: 05/24/93     BY: WUG *GB29*          */
/* REVISION: 7.3    LAST MODIFIED: 06/16/93     BY: WUG *GB74*          */
/* REVISION: 7.3    LAST MODIFIED: 06/24/93     BY: WUG *GC68*          */
/* REVISION: 7.3    LAST MODIFIED: 07/13/93     BY: WUG *GD42*          */
/* REVISION: 7.3    LAST MODIFIED: 07/13/93     BY: WUG *GD43*          */
/* REVISION: 7.3    LAST MODIFIED: 07/26/93     BY: WUG *GA72*          */
/* REVISION: 7.3    LAST MODIFIED: 07/28/93     BY: WUG *GD81*          */
/* REVISION: 7.4    LAST MODIFIED: 00/06/93     BY: bcm *H057*          */
/* REVISION: 7.4    LAST MODIFIED: 11/01/93     BY: WUG *H204*          */
/* REVISION: 7.4    LAST MODIFIED: 10/19/94     BY: ljm *GN40*          */
/* REVISION: 7.3    LAST MODIFIED: 10/31/94     BY: WUG *GN76*          */
/* REVISION: 7.4    LAST MODIFIED: 03/16/95     BY: dpm *J044*          */
/* REVISION: 7.4    LAST MODIFIED: 03/23/95     BY: bcm *G0J1*          */
/* REVISION: 7.4    LAST MODIFIED: 10/06/95     BY: dxk *G0YH*          */
/* REVISION: 7.4    LAST MODIFIED: 10/18/95     BY: vrn *G0ZX*          */
/* REVISION: 7.4    LAST MODIFIED: 10/22/95     BY: vrn *G0YF*          */
/* REVISION: 8.5    LAST MODIFIED: 06/06/96     BY: rxm *G1XN*          */
/* REVISION: 8.5    LAST MODIFIED: 03/20/97     BY: vrn *J1LT*          */
/* REVISION: 8.5    LAST MODIFIED: 02/05/98     BY: *J2DN* Seema Varma  */
/* REVISION: 8.6E   LAST MODIFIED: 02/23/98     BY: *L007* A. Rahane    */
/* REVISION: 8.6E   LAST MODIFIED: 08/17/98     BY: *L062* Steve Nugent */
/* REVISION: 8.6E   LAST MODIFIED: 10/04/98     BY: *J314* Alfred Tan   */
/* REVISION: 9.0    LAST MODIFIED: 02/06/99     BY: *M06R* Doug Norton  */
/* REVISION: 9.0    LAST MODIFIED: 03/13/99     BY: *M0BD* Alfred Tan   */
/* REVISION: 9.1    LAST MODIFIED: 10/01/99     BY: *N014* Patti Gaultney    */
/* REVISION: 9.1    LAST MODIFIED: 03/24/00     BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00     BY: *N0KP* myb               */
/* REVISION: 9.1    LAST MODIFIED: 12/22/00     BY: *N0V9* Jyoti Thatte      */
/* Revision: 1.17   BY: Dan Herman              DATE: 05/24/02  ECO: *P018*  */
/* Revision: 1.18   BY: R.Satya Narayan         DATE: 06/25/02  ECO: *P086*  */
/* Revision: 1.20   BY: Paul Donnelly (SB)      DATE: 06/28/03  ECO: *Q00L*  */
/* Revision: 1.21   BY: Gaurav Kerkar           DATE: 03/10/04  ECO: *P1SN*  */
/* Revision: 1.22   BY: Shivaraman V.           DATE: 09/21/04  ECO: *P2L5*  */
/* $Revision: 1.23 $   BY: Vinay Nayak-Sujir DATE: 10/22/04  ECO: *P2QV*  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/


/* SCHEDULED ORDER MAINT INCLUDE */

define variable pocmmts   like poc_hcmmts  label "Comments".
define variable podcmmts  like poc_lcmmts  label "Comments".
define variable print_sch like mfc_logical label "Print Schedules".
define variable edi_sch   like mfc_logical label "EDI Schedules".
define variable fax_sch   like mfc_logical label "Fax Schedules".

if no then find first scx_ref where scx_ref.scx_domain = global_domain .


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
{rsprmfrm.i}


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 SKIP(.4)  /*GUI*/
&ENDIF /*GUI*/
with frame a width 80 attr-space side-labels
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 NO-BOX THREE-D /*GUI*/
&ENDIF /*GUI*/
.


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
&ENDIF /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

FORM /*GUI*/ 
   

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
{rsprmfrm.i}
         skip(.4)   


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 SKIP(.4)  /*GUI*/
&ENDIF /*GUI*/
with frame prm width 80 attr-space side-labels
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 NO-BOX THREE-D /*GUI*/
&ENDIF /*GUI*/
.


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 DEFINE VARIABLE F-prm-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame prm = F-prm-title.
 RECT-FRAME-LABEL:HIDDEN in frame prm = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame prm =
  FRAME prm:HEIGHT-PIXELS - RECT-FRAME:Y in frame prm - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME prm = FRAME prm:WIDTH-CHARS - .5.  /*GUI*/
&ENDIF /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame prm:handle).

FORM /*GUI*/ 
   

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
space(1)
   po_nbr
   po_vend
   ad_name              no-label


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 SKIP(.4)  /*GUI*/
&ENDIF /*GUI*/
with frame po width 80 attr-space side-labels
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 NO-BOX THREE-D /*GUI*/
&ENDIF /*GUI*/
.


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 DEFINE VARIABLE F-po-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame po = F-po-title.
 RECT-FRAME-LABEL:HIDDEN in frame po = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame po =
  FRAME po:HEIGHT-PIXELS - RECT-FRAME:Y in frame po - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME po = FRAME po:WIDTH-CHARS - .5.  /*GUI*/
&ENDIF /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame po:handle).

FORM /*GUI*/ 
   

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
po_ap_acct           colon 17
   po_ap_sub                      no-label
   po_ap_cc                       no-label
   po_taxable           colon 17
   po_taxc                        no-label
   po_shipvia           colon 52
   po_cr_terms          colon 17
   po_fob               colon 52
   po_bill              colon 17  label "Bill-To Address"
   po_buyer             colon 52
   po_ship              colon 17  label "Ship-To Address"
   po_contact           colon 52
   print_sch            colon 17
   po_contract          colon 52
   edi_sch              colon 17
   po_curr              colon 52
   fax_sch              colon 17
   pocmmts              colon 52
   po_site              colon 17  label "A/P Site"
   po_consignment  colon 17
   impexp               colon 52  label "Imp/Exp"
         skip(.4)   


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 SKIP(.4)  /*GUI*/
&ENDIF /*GUI*/
with frame po1 width 80 attr-space side-labels
   
&IF (("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" <> "A")) &THEN
title color normal (getFrameTitle("ORDER_DATA",16))
&ENDIF /*GUI*/

&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 NO-BOX THREE-D /*GUI*/
&ENDIF /*GUI*/
.


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 DEFINE VARIABLE F-po1-title AS CHARACTER.
 F-po1-title = (getFrameTitle("ORDER_DATA",16)).
 RECT-FRAME-LABEL:SCREEN-VALUE in frame po1 = F-po1-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame po1 =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame po1 + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame po1 =
  FRAME po1:HEIGHT-PIXELS - RECT-FRAME:Y in frame po1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME po1 = FRAME po1:WIDTH-CHARS - .5. /*GUI*/
&ENDIF /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame po1:handle).

FORM /*GUI*/ 
   

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
scx_part             colon 16 label "Item"
   pod_vpart            at 42 no-label format "x(30)"
   pt_desc1             at 42 no-label format "x(25)"
   scx_shipto           colon 16 label "Ship-To Site"
   si_desc              no-label
   scx_line             colon 68


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 SKIP(.4)  /*GUI*/
&ENDIF /*GUI*/
with frame pod width 80 attr-space side-labels
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 NO-BOX THREE-D /*GUI*/
&ENDIF /*GUI*/
.


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 DEFINE VARIABLE F-pod-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame pod = F-pod-title.
 RECT-FRAME-LABEL:HIDDEN in frame pod = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame pod =
  FRAME pod:HEIGHT-PIXELS - RECT-FRAME:Y in frame pod - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME pod = FRAME pod:WIDTH-CHARS - .5.  /*GUI*/
&ENDIF /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame pod:handle).

FORM /*GUI*/ 
   

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
pod_pr_list            colon 15    label "Disc Table"
   pod_cst_up             colon 60
   pod_pur_cost           colon 15    label "Unit Cost" format ">>>,>>>,>>9.99<<<"
   pod_loc                colon 60
   pod_acct               colon 15
   pod_sub                            no-label
   pod_cc                             no-label
   pod_um                 colon 60
   pod_taxable            colon 15
   pod_taxc                           no-label
   pod_um_conv            colon 60
   pod_type               colon 15
   pod_wo_lot             colon 60
   pod_consignment        colon 15
   pod_op                 colon 60
   pod_rev                colon 15
   subtype                colon 60
         skip(.4)   


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 SKIP(.4)  /*GUI*/
&ENDIF /*GUI*/
with frame pod1 width 80 attr-space side-labels
   
&IF (("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" <> "A")) &THEN
title color normal (getFrameTitle("ORDER_LINE_ITEM_DATA",29))
&ENDIF /*GUI*/

&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 NO-BOX THREE-D /*GUI*/
&ENDIF /*GUI*/
.


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 DEFINE VARIABLE F-pod1-title AS CHARACTER.
 F-pod1-title = (getFrameTitle("ORDER_LINE_ITEM_DATA",29)).
 RECT-FRAME-LABEL:SCREEN-VALUE in frame pod1 = F-pod1-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame pod1 =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame pod1 + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame pod1 =
  FRAME pod1:HEIGHT-PIXELS - RECT-FRAME:Y in frame pod1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME pod1 = FRAME pod1:WIDTH-CHARS - .5. /*GUI*/
&ENDIF /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame pod1:handle).

FORM /*GUI*/ 
   

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
pod_firm_days        colon 20
   pod_sd_pat           colon 60
   pod_plan_days        colon 20 label "Schedule Days"
   pod_cum_qty[3]       colon 60 label "Max Order Qty"
   pod_plan_weeks       colon 20 label "Schedule Weeks"
   pod_ord_mult         colon 60
   pod_plan_mths        colon 20 label "Schedule Months"
   pod_cum_date[1]      colon 60 label "Cum Start" no-attr-space
   pod_fab_days         colon 20
   pod_raw_days         colon 20
   podcmmts             colon 60
   pod_translt_days     colon 20
   pod_start_eff[1]     colon 60 label "Start Effective"
   pod_sftylt_days      colon 20
   pod_end_eff[1]       colon 60 label "End Effective"
   pod_vpart            colon 20
   pod_pkg_code         colon 20 label "Container Item"


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 SKIP(.4)  /*GUI*/
&ENDIF /*GUI*/
with frame pod2 width 80 side-labels attr-space
   
&IF (("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" <> "A")) &THEN
title color normal (getFrameTitle("ORDER_LINE_ITEM_DATA",29))
&ENDIF /*GUI*/

&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 NO-BOX THREE-D /*GUI*/
&ENDIF /*GUI*/
.


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 DEFINE VARIABLE F-pod2-title AS CHARACTER.
 F-pod2-title = (getFrameTitle("ORDER_LINE_ITEM_DATA",29)).
 RECT-FRAME-LABEL:SCREEN-VALUE in frame pod2 = F-pod2-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame pod2 =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame pod2 + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame pod2 =
  FRAME pod2:HEIGHT-PIXELS - RECT-FRAME:Y in frame pod2 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME pod2 = FRAME pod2:WIDTH-CHARS - .5. /*GUI*/
&ENDIF /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame pod2:handle).
