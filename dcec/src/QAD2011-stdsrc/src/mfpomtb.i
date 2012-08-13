/* GUI CONVERTED from mfpomtb.i (converter v1.78) Fri Oct 29 14:37:20 2004 */
/* mfpomtb.i - PURCHASE ORDER MAINTENANCE SINGLE LINE ITEMS                   */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.24 $                                                               */
/*                                                                            */
/* Revision: 4.0     DATE:03/28/88    BY:FLM *A189*                           */
/* Revision: 4.0     DATE:06/15/88    BY:FLM *A268*                           */
/* Revision: 4.0     DATE:02/13/89    BY:PML *B004*                           */
/* Revision: 4.0     DATE:12/21/89    BY:FTB *Bftb*                           */
/* Revision: 6.0     DATE:05/15/90    BY:WUG *D002*                           */
/* Revision: 6.0     DATE:08/14/90    BY:SVG *D058*                           */
/* Revision: 6.0     DATE:08/31/90    BY:RAM *D030*                           */
/* Revision: 7.0     DATE:09/12/91    BY:RAM *F033*                           */
/* Revision: 7.0     DATE:03/02/92    BY:pma *F085*                           */
/* Revision: 7.4     DATE:06/09/93    BY:jjs *H006*                           */
/* Revision: 7.4     DATE:09/07/93    BY:tjs *H082*                           */
/* Revision: 7.4     DATE:10/10/93    BY:cdt *H086*                           */
/* Revision: 7.4     DATE:10/23/93    BY:cdt *H184*                           */
/* Revision: 7.4     DATE:09/15/94    BY:ljm *FR42*                           */
/* Revision: 7.4     DATE:10/07/94    BY:afs *H555*                           */
/* Revision: 8.5     DATE:12/01/94    BY:taf *J038*                           */
/* Revision: 7.4     DATE:03/13/95    BY:jpm *G0FB*                           */
/* Revision: 8.5     DATE:12/18/95    BY:taf *J053*                           */
/* Revision: 8.5     DATE:06/11/96    BY:ajw *J0S6*                           */
/* Revision: 8.5     DATE:02/17/98    BY: Santhosh Nair     *J2FF*            */
/* Revision: 8.6E    DATE:10/04/98    BY: Alfred Tan        *J314*            */
/* Revision: 8.6E    DATE:02/23/98    BY: A. Rahane         *L007*            */
/* Revision: 9.1     DATE:10/01/99    BY: Patti Gaultney    *N014*            */
/* Revision: 9.1     DATE:03/24/00    BY: Annasaheb Rahane  *N08T*            */
/* Revision: 1.13       BY: Mark B. Smith        DATE: 01/11/00  ECO: *N059*  */
/* Revision: 1.14       BY: Falguni Dalal        DATE: 11/23/00  ECO: *M0WH*  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.16       BY: Jean Miller          DATE: 05/25/02  ECO: *P076*  */
/* Revision: 1.21       BY: Kedar Deherkar       DATE: 12/16/02  ECO: *M200*  */
/* Revision: 1.22       BY: Ashish Maheshwari    DATE: 11/26/03  ECO: *N2LQ*  */
/* Revision: 1.23       BY: Gaurav Kerkar        DATE: 03/10/04  ECO: *P1SN*  */
/* $Revision: 1.24 $         BY: Sukhad Kulkarni      DATE: 04/28/04  ECO: *P1Z8*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */

/******************************************************************************/
/* This file is for frame forms.                                              */
/******************************************************************************/

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
space(1)
   po_nbr
   po_vend
   sngl_ln        colon 70
 SKIP(.4)  /*GUI*/
with frame chead no-hide side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-chead-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame chead = F-chead-title.
 RECT-FRAME-LABEL:HIDDEN in frame chead = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame chead =
  FRAME chead:HEIGHT-PIXELS - RECT-FRAME:Y in frame chead - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME chead = FRAME chead:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame chead:handle).

FORM /*GUI*/ 
   line
        space(.5)   
   pod_site
        space(.5)   
   pod_req_nbr
        space(.9)   
   pod_part
        view-as fill-in size 17 by 1   
        space(.5)   
   pod_qty_ord
        space(.7)   
   pod_um
        space(.7)   
   pod_pur_cost   label "Unit Cost" format ">>>>>>>>9.99<<<"
        space(.5)   
   pod_disc_pct
with frame c no-hide clines down width 80       font 22    THREE-D /*GUI*/.


/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
pod_qty_rcvd   colon 15
   pod_due_date   colon 40
   pod_crt_int    colon 62  label "CRT Int"
   pod_qty_chg    colon 15  label "Qty To Rel"
   pod_acct       colon 53  label "Acct"
        view-as fill-in size 9 by 1 space(.1)   
   pod_sub                  no-label
        space(.2)   
   pod_cc                   no-label
        view-as fill-in size 5 by 1   
   pod_lot_rcpt   colon 15
   pod_per_date   colon 40  label "Perf Date"
   pod_project    colon 62
   pod_loc        colon 15
   pod_need       colon 40
   pod_type       colon 62
   pod_rev        colon 15
   pod_so_job     colon 40
   pod_taxable    colon 62
        view-as fill-in size 5 by 1 space(.2)   
   pod_taxc                 no-label
   pod_status     colon 15
   pod_fix_pr     colon 40
   pod_insp_rqd   colon 62
        view-as fill-in size 5 by 1 space(.2)   
   podcmmts       colon 73  label "Cmmts"
        view-as fill-in size 5 by 1 space(.2)   
   pod_vpart      colon 15
   pod_um_conv    colon 62
   mfgr           colon 15
   mfgr_part                no-label
   st_qty         colon 62  label "Stock UM Qty" format "->>>>>>>>9.9<<<"
        space(.5)   
   st_um                    no-label
        space(2)   
   desc1          colon 15
   pod_cst_up     colon 62  label "Update Avg/Last Cost" skip space(16)
   desc2                    no-label
   ext_cost       colon 62  label "Extended Net Cost" format "->>>,>>>,>>9.99"
 SKIP(.4)  /*GUI*/
with frame d no-hide side-labels /*V8+*/ width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-d-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame d = F-d-title.
 RECT-FRAME-LABEL:HIDDEN in frame d = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame d =
  FRAME d:HEIGHT-PIXELS - RECT-FRAME:Y in frame d - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME d = FRAME d:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
pod_due_date  colon 20
   space(2)
   pod_crt_int   colon 20
   space(2)
 SKIP(.4)  /*GUI*/
with frame line_pop overlay side-labels row 12 column 25 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-line_pop-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame line_pop = F-line_pop-title.
 RECT-FRAME-LABEL:HIDDEN in frame line_pop = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame line_pop =
  FRAME line_pop:HEIGHT-PIXELS - RECT-FRAME:Y in frame line_pop - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME line_pop = FRAME line_pop:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame line_pop:handle).
