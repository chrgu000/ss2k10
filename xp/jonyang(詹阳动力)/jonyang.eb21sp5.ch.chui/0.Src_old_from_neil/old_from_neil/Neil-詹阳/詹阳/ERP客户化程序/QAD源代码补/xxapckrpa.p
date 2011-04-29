/* GUI CONVERTED from apckrpa.p (converter v1.71) Tue Oct  6 14:16:06 1998 */
/* apckrpa.p - AP CHECK REGISTER AUDIT REPORT SUBROUTINE by batch       */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert apckrpa.p (converter v1.00) Fri Oct 10 13:57:25 1997 */
/* web tag in apckrpa.p (converter v1.00) Mon Oct 06 14:17:55 1997 */
/*F0PN*/ /*K0QV*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=Report                                        */
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

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

     {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apckrpa_p_1 "供应商类型"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrpa_p_2 "S-汇总/D-明细"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrpa_p_3 "按供应商排序"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrpa_p_4 "打印总帐明细"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrpa_p_5 "支票"
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
/*G0DZ*/ /*V8+*/      
     define shared variable nbr          as integer format ">999999"
     label {&apckrpa_p_5}.
     define shared variable nbr1         as integer format ">999999".   
     define shared variable entity       like ap_entity.
     define shared variable entity1      like ap_entity.
     define shared variable ckfrm        like ap_ckfrm.
     define shared variable ckfrm1       like ap_ckfrm.
     define shared variable summary      like mfc_logical
        format {&apckrpa_p_2} label {&apckrpa_p_2}.
     define shared variable gltrans      like mfc_logical initial no
        label {&apckrpa_p_4}.
     define shared variable base_rpt     like ap_curr.
/*G1LD*     initial "Base" format "x(04)". */
     define shared variable vdtype       like vd_type
        label {&apckrpa_p_1}.
     define shared variable vdtype1      like vdtype.
/*F461*/ define shared variable sort_by_vend like mfc_logical
        label {&apckrpa_p_3}.
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

     define buffer apmstr for ap_mstr.

     /*CHECK FOR VAT TAXES */
     find first gl_ctrl no-lock.

/*H0H8*  /*FR77*/ do with frame c down width 132: */

/*H0H8*/ FORM /*GUI*/  with STREAM-IO /*GUI*/  frame c no-attr-space no-box width 132 down.

/*FR77*/ report_loop:
/*FR77*/ for each ap_mstr where ap_type = "CK"
/*FR77*/    no-lock,
/*FR77*/    each ck_mstr no-lock where
/*FR77*/    ck_ref = ap_ref
/*FR77*/    and (ck_nbr >= nbr and ck_nbr <= nbr1)
/*FR77*/    and (ck_bank >= bank and ck_bank <= bank1)
/*FR77*/    and (ap_batch >= batch and ap_batch <= batch1)
/*FR77*/    and (ap_vend >= vend and ap_vend <= vend1)
/*FR77*/    and (ap_entity >= entity and ap_entity <= entity1)
/*FR77*/    and (ap_ckfrm >= ckfrm and ap_ckfrm <= ckfrm1)
/*G1LD*     *FR77* and ((ap_curr = base_rpt) or (base_rpt = "Base")) */
/*G1LD*/    and ((ap_curr = base_rpt) or (base_rpt = ""))
/*FR77*/    and (   (ap_date >= apdate and ap_date <= apdate1 and
/*FR77*/             ap_effdate >= effdate and ap_effdate <= effdate1)
/*FR77*/         or (ck_voiddate >= apdate and ck_voiddate <= apdate1 and
/*FR77*/             ck_voideff >= effdate and ck_voideff <= effdate1
/*FR77*/             and ck_voiddate <> ? and ck_voideff <> ?)
/*FR77*/        )
/*FR77*/    break by ap_batch by ap_ref
/*FR77*/    with frame d width 132 down:

/*FR77*/    vdfound = no.
            /* ap_vend IS BLANK FOR TEST CHECKS */
/*J17S*/    if ap_vend > "" then do:
/*FR77*/       find vd_mstr where vd_addr = ap_vend and
/*FR77*/       (vd_type >= vdtype and vd_type <= vdtype1) no-lock no-error.
/*FR77*/       if available vd_mstr then vdfound = yes.
/*J17S*/       else next report_loop.
/*J17S*/    end.
/*J17S*/    else
/*J17S*/       if vdtype > "" then
/*J17S*/          next report_loop.

/*H0H8*     /*F461*/ {apckrp.i &sort1="ap_batch" &frame1="c" &frame2="d" */
/*H0H8*        &frame3="e"  &frame4="f" &frame5="g" &frame6="h" }        */

/*H0H8*/    {apckrp-1.i &sort1="ap_batch"}

/*H0H8*/ end. /* report_loop */

/*H0H8*  end. /* do with frame c */ */

/*F461*  MOVED REST OF PROGRAM TO APCKRP.I */
/*K0QV*/ {wbrp04.i}
