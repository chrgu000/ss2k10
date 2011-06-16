/* mfpomtb.i - PURCHASE ORDER MAINTENANCE SINGLE LINE ITEMS                   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.16 $                                                          */
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
/* Revision: 8.5     DATE:02/17/98    BY: Santhosh Nair  *J2FF*               */
/* Revision: 8.6E    DATE:10/04/98    BY: Alfred Tan     *J314*               */
/* Revision: 8.6E    DATE:02/23/98    BY: A. Rahane      *L007*               */
/* Revision: 9.1     DATE:10/01/99    BY: Patti Gaultney *N014*               */
/* Revision: 9.1     DATE:03/24/00    BY: Annasaheb Rahane   *N08T*           */
/* Revision: 1.13       BY: Mark B. Smith        DATE: 01/11/00  ECO: *N059*  */
/* Revision: 1.14       BY: Falguni Dalal        DATE: 11/23/00  ECO: *M0WH*  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.16 $    BY: Jean Miller          DATE: 05/25/02  ECO: *P076*  */
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
/* ss - 090803.1 by: jack */
form
   space(1)
   po_nbr
   po_vend
   sngl_ln        colon 70
with frame chead no-hide side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame chead:handle).

/* ss - 090803.1 -b
form
   line
   /*V8!space(.5) */
   pod_site
   /*V8!space(.5) */
   pod_req_nbr
   /*V8!space(.5) */
   pod_part
   /*V8!view-as fill-in size 18 by 1 */
   /*V8!space(.5) */
   pod_qty_ord
   /*V8!space(.5) */
   pod_um
   /*V8!space(.5) */
   pod_pur_cost   label "Unit Cost" format "->>>>>>>>9.99<<<"
   /*V8!space(.5) */
   pod_disc_pct
with frame c no-hide clines down width 80.
ss - 090803.1 -e */
/* ss - 090803.1 -b */
form
   line
   /*V8!space(.5) */
   pod_site
   /*V8!space(.5) */
   pod_req_nbr
   /*V8!space(.5) */
   pod_part
   /*V8!view-as fill-in size 18 by 1 */
   /*V8!space(.5) */
   pod_qty_ord
   /*V8!space(.5) */
   pod_um
   /*V8!space(.5) */
   pod_pur_cost blank  label "Unit Cost" format "->>>>>>>>9.99<<<"
   /*V8!space(.5) */
   pod_disc_pct
with frame c no-hide clines down width 80.

/* ss - 090803.1 -e */

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

form
   pod_qty_rcvd   colon 15
   pod_due_date   colon 40
   pod_crt_int    colon 62  label "CRT Int"
   pod_qty_chg    colon 15  label "Qty To Rel"
   pod_acct       colon 53  label "Acct"
   /*V8!view-as fill-in size 9 by 1 space(.1) */
   pod_sub                  no-label
   /*V8!space(.2) */
   pod_cc                   no-label
   /*V8!view-as fill-in size 5 by 1 */
   pod_lot_rcpt   colon 15
   pod_per_date   colon 40  label "Perf Date"
   pod_project    colon 62
   pod_loc        colon 15
   pod_need       colon 40
   pod_type       colon 62
   pod_rev        colon 15
   pod_so_job     colon 40
   pod_taxable    colon 62
   /*V8!view-as fill-in size 5 by 1 space(.2) */
   pod_taxc                 no-label
   pod_status     colon 15
   pod_fix_pr     colon 40
   pod_insp_rqd   colon 62
   /*V8!view-as fill-in size 5 by 1 space(.2) */
   podcmmts       colon 73  label "Cmmts"
   /*V8!view-as fill-in size 5 by 1 space(.2) */
   pod_vpart      colon 15
   pod_um_conv    colon 62
   mfgr           colon 15
   mfgr_part                no-label
   st_qty         colon 62  label "Stock UM Qty" format "->>>>>>>>9.9<<<"
   /*V8!space(.5) */
   st_um                    no-label
   /*V8!space(2) */
   desc1          colon 15
   pod_cst_up     colon 62  label "Update Avg/Last Cost" skip space(16)
   desc2                    no-label
   ext_cost       colon 62  label "Extended Net Cost" format "->>>,>>>,>>9.99"
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
