/* mfpomtb.i - PURCHASE ORDER MAINTENANCE SINGLE LINE ITEMS                   */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*F0PN*/
/* $Revision: 1.14 $                                                               */
/*                                                                            */
/*              Include file for frame forms                                  */
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
/* Revision: 8.5     DATE:02/17/98    BY:Santhosh Nair  *J2FF*                */
/* Revision: 8.6E    DATE:10/04/98    BY:Alfred Tan     *J314*                */
/* Revision: 8.6E    DATE:02/23/98    BY:A. Rahane      *L007*                */
/* Revision: 9.1     DATE:10/01/99    BY:Patti Gaultney *N014*                */
/* Revision: 9.1     DATE:03/24/00    BY:Annasaheb Rahane   *N08T*            */
/* Revision: 1.13    BY:Mark B. Smith     DATE: 01/11/00   ECO: *N059*        */
/* $Revision: 1.14 $      BY:Falguni Dalal     DATE: 11/23/00   ECO: *M0WH*        */
/* REVISION: eb sp3 us  LAST MODIFIED: 07/26/07 BY: *SS-070726* Apple Tam     */
/*                                                                            */
/*V8:ConvertMode=Maintenance                                                  */

/******************************************************************************/
/* This file is for frame forms.                                              */
/******************************************************************************/


/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mfpomtb_i_1 "Perf Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfpomtb_i_2 "Extended Net Cost"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfpomtb_i_3 "Qty To Rel"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfpomtb_i_4 "Update Avg/Last Cost"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfpomtb_i_5 "Unit Cost"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfpomtb_i_6 "Stock UM Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfpomtb_i_7 "CRT Int"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfpomtb_i_8 "Acct"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfpomtb_i_9 "Cmmts"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

form
   space(1)
   po_nbr
   po_vend
   sngl_ln        colon 70
   with frame chead no-hide side-labels width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame chead:handle).

form
   line
   /*V8!space(.5) */
   pod_site
   /*V8!space(.5) */
   pod_req_nbr
   /*V8!space(.5) */
   pod_part
/*M0WH*/ /*V8!view-as fill-in size 18 by 1 */
   /*V8!space(.5) */
   pod_qty_ord
   /*V8!space(.5) */
   pod_um
   /*V8!space(.5) */
   pod_pur_cost   label {&mfpomtb_i_5} format "->>>>>>>>9.99<<<"
   /*V8!space(.5) */
   pod_disc_pct
   with frame c no-hide clines down width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).


form
   pod_qty_rcvd   colon 15
   pod_due_date   colon 40
   pod_crt_int    colon 62     label {&mfpomtb_i_7}
   pod_qty_chg    colon 15     label {&mfpomtb_i_3}
   pod_acct       colon 53     label {&mfpomtb_i_8}
   /*V8!view-as fill-in size 9 by 1 space(.1) */
   pod_sub                     no-labels
   /*V8!space(.2) */
   pod_cc                      no-labels
   /*V8!view-as fill-in size 5 by 1 */
   pod_lot_rcpt   colon 15
   pod_per_date   colon 40     label {&mfpomtb_i_1}
   pod_project    colon 62
   pod_loc        colon 15
   pod_need       colon 40
   pod_type       colon 62
   pod_rev        colon 15
   pod_so_job     colon 40
   pod_taxable    colon 62
   /*V8!view-as fill-in size 5 by 1 space(.2) */
   pod_taxc                    no-labels
   pod_status     colon 15
   pod_fix_pr     colon 40
   pod_insp_rqd   colon 62
   /*V8!view-as fill-in size 5 by 1 space(.2) */
   podcmmts       colon 73     label {&mfpomtb_i_9}
   /*V8!view-as fill-in size 5 by 1 space(.2) */
   pod_vpart      colon 15
   pod_um_conv    colon 62
   mfgr           colon 15
   mfgr_part                   no-labels
   st_qty         colon 62     label {&mfpomtb_i_6}
   format "->>>>>>>>9.9<<<"
   /*V8!space(.5) */
   st_um                       no-labels
   /*V8!space(2) */
   desc1          colon 15
   pod_cst_up     colon 62     label {&mfpomtb_i_4} skip space(16)
   desc2          no-labels
   ext_cost       colon 62     label {&mfpomtb_i_2}
   format "->>>,>>>,>>9.99"
   with frame d no-hide side-labels /*V8-*/ 1 down /*V8+*/ width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

form
   pod_due_date  colon 20
   space(2)
   pod_crt_int   colon 20
   space(2)
   with frame line_pop overlay side-labels row 12 column 25.
/* SET EXTERNAL LABELS */
setFrameLabels(frame line_pop:handle).



/*ss-070726 add**************************************************************/

   form
     pod__dec01  colon 20 label "Total Order Qty"
     re-price    colon 20 label "Reprice"
      space(2)
   with frame line_qty overlay side-labels row 10 column 25.

/* SET EXTERNAL LABELS */
setFrameLabels(frame line_qty:handle).

/*ss-070726 add**************************************************************/