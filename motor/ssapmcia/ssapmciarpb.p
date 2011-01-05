/* apckrpb.p -  AP CHECK REGISTER AUDIT REPORT SUBROUTINE by vend       */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*HOCH*/ /*K0QV*/
/*V8:ConvertMode=Report                                        */
/* REVISION: 1.0      LAST MODIFIED: 10/20/86   BY: PML                 */
/* REVISION: 6.0      LAST MODIFIED: 02/22/91   BY: mlv *D361*          */
/*                                   04/03/91   BY: mlv *D494*          */
/* REVISION: 7.0      LAST MODIFIED: 01/27/92   BY: mlv *F098*          */
/*                                              BY: mlv *F509*          */
/*                                              BY: mlv *F461*          */
/* REVISION: 7.3      LAST MODIFIED: 09/27/93   By: jcd *G247*          */
/*                                   04/12/93   BY: jms *G937*          */
/* REVISION: 7.4      LAST MODIFIED: 11/24/93   By: wep *H245*          */
/*                                   04/04/94   by: pcd *H321*          */
/*                                   09/26/94   BY: str *FR77*          */
/*                                   02/11/95   BY: ljm *G0DZ*          */
/*                                   04/10/95   BY: jpm *H0CH*          */
/*                                   05/09/95   BY: jzw *F0R3*          */
/*                                   11/20/95   BY: jzw *H0H8*          */
/*                                   04/10/96   BY: jzw *G1LD*          */
/* REVISION: 8.6      LAST MODIFIED: 10/14/97   BY: ckm *K0QV*          */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 09/16/99   BY: *J3LF* Ranjit Jain       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00 BY: *N0KK* jyn                 */
/* REVISION: 9.1      LAST MODIFIED: 09/13/00 BY: *N0W0* BalbeerS Rajput  */
/* $Revision: 1.11.1.8 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/* $Revision: 1.11.1.8 $ BY: Bill Jiang DATE: 08/26/07 ECO: *SS - 20070826.1* */
/*-Revision end---------------------------------------------------------------*/

/* SS - 20070826.1 - B */
{ssapckrp01.i}
/* SS - 20070826.1 - E */

      {mfdeclre.i}
/*N0W0*/ {cxcustom.i "APCKRPB.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apckrpb_p_1 "Check"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrpb_p_2 "Print GL Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrpb_p_3 "Sort by Supplier"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrpb_p_4 "Summary/Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrpb_p_5 "Supplier Type"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*K0QV*/ {wbrp02.i}


     define new shared variable tot-vtadj    as decimal.
/*F0R3*/ define new shared variable tot_vtadj_disc as decimal.
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
/*N0W0*/ {&APCKRPB-P-TAG1}
/*G0DZ*/ /*V8-*/
     define shared variable nbr          like ck_nbr.
     define shared variable nbr1         like ck_nbr.
/*G0DZ*/ /*V8+*/ /*V8!
     define shared variable nbr          as integer format ">999999"
/*H0CH*/ label {&apckrpb_p_1}.
     define shared variable nbr1         as integer format ">999999". */
/*N0W0*/ {&APCKRPB-P-TAG2}
     define shared variable entity       like ap_entity.
     define shared variable entity1      like ap_entity.
     define shared variable ckfrm        like ap_ckfrm.
     define shared variable ckfrm1       like ap_ckfrm.
     define shared variable summary      like mfc_logical
        format {&apckrpb_p_4} label {&apckrpb_p_4}.
     define shared variable gltrans      like mfc_logical initial no
        label {&apckrpb_p_2}.
     define shared variable base_rpt     like ap_curr.
/*G1LD*     initial "Base" format "x(04)". */
     define shared variable vdtype       like vd_type
        label {&apckrpb_p_5}.
     define shared variable vdtype1      like vdtype.
/*F461*/ define shared variable sort_by_vend like mfc_logical
        label {&apckrpb_p_3}.
/*H245*/ define shared variable duedate      like vo_due_date.
/*H245*/ define shared variable duedate1     like vo_due_date.
/*G247*  define shared variable mfguser as character.     */

     define variable batch_lines   as integer.
     define variable detail_lines  as integer.
     define variable name          like ad_name.
     define variable type          like ap_type format "X(4)".
     define variable invoice       like vo_invoice.
/*H321*  define variable order         like vo_po. */
/*H321*/ define variable order         like vpo_po.
     define variable bank_curr     like bk_curr.
     define variable base_amt      like ap_amt.
     define variable gain_amt      like ckd_amt.
     define variable rmks          like ap_rmk.
     define variable apamt         like ap_amt.
     define variable base_disp_amt like ap_amt.
     define variable ckstatus      like ck_status.
/*G937*/ define variable tot_gain_amt  like ckd_amt.
/*FR77*/ define variable vdfound       like mfc_logical.

/*J3LF*/ /* VARIABLE TO DISPLAY THE BATCH HEADER                  */
/*J3LF*/ define variable l_header_disp like mfc_logical init yes no-undo.

/*J3LF*/ /* VARIABLE TO DISPLAY THE REPORT TOTAL                  */
/*J3LF*/ define variable l_rep_total like mfc_logical no-undo.


     define buffer apmstr for ap_mstr.


     /*CHECK FOR VAT TAXES */
/*H0CH*/ find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock
no-error.

/*H0H8*  /*FR77*/ do with frame c down width 132: */

/*H0H8*/ form with frame c no-attr-space no-box width 132 down.

/*FR77*/ report_loop:
/*N0W0*/ {&APCKRPB-P-TAG3}
/*FR77*/ for each ap_mstr  where ap_mstr.ap_domain = global_domain and (
ap_type = "CK"
    ) no-lock,
/*FR77*/    each ck_mstr no-lock  where ck_mstr.ck_domain = global_domain and (
/*FR77*/    ck_ref = ap_ref
/*FR77*/    and (ck_nbr >= nbr and ck_nbr <= nbr1)
/*FR77*/    and (ck_bank >= bank and ck_bank <= bank1)
/*FR77*/    and (ap_batch >= batch and ap_batch <= batch1)
/*FR77*/    and (ap_vend >= vend and ap_vend <= vend1)
/*FR77*/    and (ap_entity >= entity and ap_entity <= entity1)
/*FR77*/    and (ap_ckfrm >= ckfrm and ap_ckfrm <= ckfrm1)
/*G1LD*     *FR77* and ((ap_curr = base_rpt) or (base_rpt = "Base" )) */
/*G1LD*/    and ((ap_curr = base_rpt) or (base_rpt = ""))
/*FR77*/    and (   (ap_date >= apdate and ap_date <= apdate1 and
/*FR77*/             ap_effdate >= effdate and ap_effdate <= effdate1)
/*FR77*/         or (ck_voiddate >= apdate and ck_voiddate <= apdate1 and
/*FR77*/             ck_voideff >= effdate and ck_voideff <= effdate1
/*FR77*/             and ck_voiddate <> ? and ck_voideff <> ?)
        ) ),
/*FR77*/    each vd_mstr  where vd_mstr.vd_domain = global_domain and  vd_addr
= ap_vend and
/*FR77*/    (vd_type >= vdtype and vd_type <= vdtype1)
/*FR77*/    no-lock 
   /* SS - 20070826.1 - B */
   ,FIRST ttssapckrp01 NO-LOCK
   WHERE ttssapckrp01_ck_ref = ap_ref
   /* SS - 20070826.1 - E */
   break by vd_sort by ap_ref
/*FR77*/    with frame d width 132 down:

/*N0W0*/    {&APCKRPB-P-TAG4}
/*J3LF** /*FR77*/    vdfound = no.  */
/*J3LF*/    assign
/*J3LF*/       vdfound = yes.


/*H0H8*     /*F461*/ {apckrp.i &sort1="vd_sort" &frame1="c" &frame2="d" */
/*H0H8*        &frame3="e"  &frame4="f" &frame5="g" &frame6="h" }       */

/* SS - 20070826.1 - B */
/*
/*H0H8*/    {apckrp.i &sort1="vd_sort"}
*/
/*H0H8*/    {ssapmciarp.i &sort1="vd_sort"}
/* SS - 20070826.1 - E */

/*H0H8*/ end. /* report_loop */

/*H0H8*  end. /* do with frame c */ */

/*F461*  MOVED REST OF PROGRAM TO APCKRP.I */
/*K0QV*/ {wbrp04.i}
