/* apckrpa.p - AP CHECK REGISTER AUDIT REPORT SUBROUTINE by batch       */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.8.1.8 $                                              */
/* REVISION: 1.0      LAST MODIFIED: 10/20/86   BY: PML                 */
/* REVISION: 6.0      LAST MODIFIED: 02/22/91   BY: mlv *D361*          */
/*                                   04/03/91   BY: mlv *D494*          */
/* REVISION: 7.0      LAST MODIFIED: 01/27/92   BY: mlv *F098*          */
/*                                   05/19/92   BY: mlv *F509*          */
/*                                   05/21/92   BY: mlv *F461*          */
/* REVISION: 7.3      LAST MODIFIED: 09/27/93   By: jcd *G247*          */
/*                                   04/12/93   by: jms *G937*          */
/* REVISION: 7.4      LAST MODIFIED: 11/24/93   By: wep *H245*          */
/*                                   04/04/94   by: pcd *H321*          */
/*                                   09/26/94   by: str *FR77*          */
/*                                   02/11/95   by: ljm *G0DZ*          */
/*                                   05/09/95   by: jzw *F0R3*          */
/*                                   11/20/95   by: jzw *H0H8*          */
/*                                   04/10/96   by: jzw *G1LD*          */
/* REVISION: 8.5      LAST MODIFIED: 11/06/96   By: rxm *J17S*          */
/* REVISION: 8.6      LAST MODIFIED: 10/14/97   BY: ckm *K0QV*          */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 09/16/99   BY: *J3LF* Ranjit Jain       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00 BY: *N0KK* jyn                 */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.8.1.7  BY: Ed van de Gevel  DATE: 11/09/01  ECO: *N15N*  */
/* $Revision: 1.8.1.8 $  BY: Paul Donnelly  DATE: 01/04/02  ECO: *N16J*  */
/* $Revision: 1.8.1.8 $  BY: Bill Jiang  DATE: 02/15/06  ECO: *SS - 20060215*  */

/*V8:ConvertMode=Report                                        */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* REVISION: 9.1      LAST MODIFIED: 08/04/00 BY: *N0W0* Mudit Mehta      */
{mfdeclre.i}
{cxcustom.i "APCKRPA.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apckrpa_p_1 "Supplier Type"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrpa_p_2 "Summary/Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrpa_p_3 "Sort by Supplier"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrpa_p_4 "Print GL Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrpa_p_5 "Check"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{wbrp02.i}

define new shared variable tot-vtadj    as decimal.
define new shared variable tot_vtadj_disc as decimal.
define new shared variable ap_recno     as recid.
define new shared variable vo_recno     as recid.
define new shared variable ckd_recno    as recid.
define new shared variable ck_recno     as recid.
define new shared variable base_ckd_amt like ckd_amt.
define new shared variable base_disc    like ckd_disc.

define shared variable vend         like ap_vend.
define shared variable vend1        like ap_vend.
define shared variable batch        like ap_batch.
define shared variable batch1       like ap_batch.
define shared variable apdate       like ap_date.
define shared variable apdate1      like ap_date.
define shared variable effdate      like ap_effdate.
define shared variable effdate1     like ap_effdate.
define shared variable bank         like ck_bank.
define shared variable bank1        like ck_bank.
{&APCKRPA-P-TAG1}
/*V8-*/
define shared variable nbr          like ck_nbr.
define shared variable nbr1         like ck_nbr.
/*V8+*/ /*V8!
define shared variable nbr          as integer format ">999999"
label {&apckrpa_p_5}.
define shared variable nbr1         as integer format ">999999". */
{&APCKRPA-P-TAG2}
define shared variable entity       like ap_entity.
define shared variable entity1      like ap_entity.
define shared variable ckfrm        like ap_ckfrm.
define shared variable ckfrm1       like ap_ckfrm.
define shared variable summary      like mfc_logical
   format {&apckrpa_p_2} label {&apckrpa_p_2}.
define shared variable gltrans      like mfc_logical initial no
   label {&apckrpa_p_4}.
define shared variable base_rpt     like ap_curr.

define shared variable vdtype       like vd_type
   label {&apckrpa_p_1}.
define shared variable vdtype1      like vdtype.
define shared variable sort_by_vend like mfc_logical
   label {&apckrpa_p_3}.
define shared variable duedate      like vo_due_date.
define shared variable duedate1     like vo_due_date.

define variable batch_lines   as integer.
define variable detail_lines  as integer.
define variable name          like ad_name.
define variable type          like ap_type format "X(4)".
define variable invoice       like vo_invoice.

define variable order         like vpo_po.
define variable bank_curr     like bk_curr.
define variable base_amt      like ap_amt.
define variable gain_amt      like ckd_amt.
define variable rmks          like ap_rmk.
define variable apamt         like ap_amt.
define variable base_disp_amt like ap_amt.
define variable ckstatus      like ck_status.
define variable tot_gain_amt  like ckd_amt.
define variable vdfound       like mfc_logical.

/* VARIABLE TO DISPLAY THE BATCH HEADER                  */
define variable l_header_disp like mfc_logical initial yes no-undo.

/* VARIABLE TO DISPLAY THE REPORT TOTAL                  */
define variable l_rep_total   like mfc_logical no-undo.

define buffer apmstr for ap_mstr.

/*CHECK FOR VAT TAXES */
find first gl_ctrl no-lock.

form with frame c no-attr-space no-box width 132 down.

report_loop:
{&APCKRPA-P-TAG3}
for each ap_mstr where ap_type = "CK"
   no-lock,
      each ck_mstr no-lock where
      ck_ref = ap_ref
      and (ck_nbr >= nbr and ck_nbr <= nbr1)
      and (ck_bank >= bank and ck_bank <= bank1)
      and (ap_batch >= batch and ap_batch <= batch1)
      and (ap_vend >= vend and ap_vend <= vend1)
      and (ap_entity >= entity and ap_entity <= entity1)
      and (ap_ckfrm >= ckfrm and ap_ckfrm <= ckfrm1)

      and ((ap_curr = base_rpt) or (base_rpt = ""))
      and (   (ap_date >= apdate and ap_date <= apdate1 and
      ap_effdate >= effdate and ap_effdate <= effdate1)
      or (ck_voiddate >= apdate and ck_voiddate <= apdate1 and
      ck_voideff >= effdate and ck_voideff <= effdate1
      and ck_voiddate <> ? and ck_voideff <> ?)
      )
      break by ap_batch by ap_ref
   with frame d width 132 down:
   {&APCKRPA-P-TAG4}

   vdfound       = no.

   if ap_vend > "" then do:
      find vd_mstr where vd_addr = ap_vend and
         (vd_type >= vdtype and vd_type <= vdtype1) no-lock no-error.
      if available vd_mstr then vdfound = yes.

   end.
   else

   /* RECORDS SHOULD NOT BE SKIPPED BEFORE THE FIRST-OF AND LAST-OF    */
   /* CHECKS HENCE NEXT report_loop SHOULD BE REPLACED WITH LOGICAL    */
   /* VARIABLE vdfound                                                 */

   if vdtype = ""
      then
   assign
      vdfound = yes.

   /* SS - 20060215 - B */
   /*
   {apckrp.i &sort1="ap_mstr.ap_batch"}
       */
   {a6apckrp.i &sort1="ap_mstr.ap_batch"}
       /* SS - 20060215 - E */

end. /* report_loop */

{wbrp04.i}
