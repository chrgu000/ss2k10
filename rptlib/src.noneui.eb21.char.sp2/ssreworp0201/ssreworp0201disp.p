/* rewodisp.p - REPETITIVE                                                    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.6.1.5 $                                                           */
/*                                                                            */
/* SUBPROGRAM TO DISPLAY INFO FROM THE CUM WORKORDER wo_mstr RECORD           */
/*                                                                            */
/* REVISION: 7.3        LAST MODIFIED: 10/31/94   BY: WUG *GN77*              */
/* REVISION: 7.3        LAST MODIFIED: 03/29/95   BY: WUG *F0PN*              */
/* REVISION: 8.6        LAST MODIFIED: 10/14/97   BY: mzv *K0YF*              */
/* REVISION: 8.6E       LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E       LAST MODIFIED: 05/29/98   BY: *K1R8* A. Shobha        */
/* REVISION: 8.6E       LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan       */
/* REVISION: 9.1        LAST MODIFIED: 08/12/00   BY: *N0KP* Mark Brown       */
/* REVISION: 9.1        LAST MODIFIED: 09/11/00   BY: *N0RQ* Mudit Mehta      */
/* Revision: 1.6.1.3  BY: Robin McCarthy DATE: 10/01/01 ECO: *P025* */
/* $Revision: 1.6.1.5 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/* $Revision: 1.6.1.5 $ BY: Bill Jiang DATE: 07/20/08 ECO: *SS - 20080720.1* */
/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Report                                                       */

/* SS - 20080720.1 - B */
{ssreworp0201.i}

DEFINE SHARED VARIABLE ttssreworp0201_recid AS RECID.
/* SS - 20080720.1 - E */

{mfdeclre.i}
{gplabel.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE rewodisp_p_1 "Start Eff"
/* MaxLen: Comment: */

&SCOPED-DEFINE rewodisp_p_2 "Status"
/* MaxLen: Comment: */

&SCOPED-DEFINE rewodisp_p_3 "Order Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE rewodisp_p_4 "End Eff"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define input parameter cumwo_lot as character.

define variable wostatus as character format "x(20)"
   label {&rewodisp_p_2}.
define variable active_wolot as character.
define variable i as integer.

find wo_mstr  where wo_mstr.wo_domain = global_domain and  wo_lot = cumwo_lot
no-lock.

find si_mstr  where si_mstr.si_domain = global_domain and  si_site = wo_site
no-lock no-error.
find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = wo_part
no-lock no-error.
find ln_mstr  where ln_mstr.ln_domain = global_domain and  ln_site = wo_site
and ln_line = wo_line
no-lock no-error.

form
   wo_lot       colon 20
   wo_routing   colon 95
   wo_site      colon 20
   si_desc      at 42 no-label
   wo_bom_code  colon 95
   wo_part      colon 20
   pt_desc1     at 42 no-label
   wo_rel_date  colon 95 label {&rewodisp_p_1}
   wo_line      colon 20
   ln_desc      at 42 no-label
   wo_due_date  colon 95 label {&rewodisp_p_4}
   wo_qty_ord   colon 95 label {&rewodisp_p_3}
   wostatus     colon 95
   skip(1)
with frame f-a width 132 side-labels.

/* SS - 20080720.1 - B */
/*
/* SET EXTERNAL LABELS */
setFrameLabels(frame f-a:handle).
*/
/* SS - 20080720.1 - E */

if wo_status = "C" then
   wostatus = getTermLabel("CLOSED",20).
else do:

   if wo_due_date < today then
      wostatus = getTermLabel("EXPIRED",20).
   else
      wostatus = getTermLabel("ACTIVE",20).
end.

/* SS - 20080720.1 - B */
/*
display
   wo_site
   wo_part
   wo_line
   wo_routing
   wo_bom_code
   wo_rel_date
   wo_due_date
   wo_lot
   wostatus
   pt_desc1        when (available pt_mstr)
   si_desc         when (available si_mstr)
   ln_desc         when (available ln_mstr)
   wo_qty_ord
with frame f-a.
*/
CREATE ttssreworp0201.
ASSIGN
   ttssreworp0201_wo_lot = wo_lot
   ttssreworp0201_wo_routing = wo_routing
   ttssreworp0201_wo_site = wo_site
   ttssreworp0201_si_desc = si_desc WHEN (AVAILABLE si_mstr)
   ttssreworp0201_wo_bom_code = wo_bom_code
   ttssreworp0201_wo_part = wo_part
   ttssreworp0201_pt_desc1 = pt_desc1 WHEN (AVAILABLE pt_mstr)
   ttssreworp0201_wo_rel_date = wo_rel_date
   ttssreworp0201_wo_line = wo_line
   ttssreworp0201_ln_desc = ln_desc WHEN (AVAILABLE in_mstr)
   ttssreworp0201_wo_due_date = wo_due_date
   ttssreworp0201_wo_qty_ord = wo_qty_ord
   ttssreworp0201_wostatus = wostatus
   .

ASSIGN
   ttssreworp0201_recid = RECID(ttssreworp0201)
   .
/* SS - 20080720.1 - E */

{gpcmtprt.i &id=wo_cmtindx &pos=14}
