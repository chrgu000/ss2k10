/* GUI CONVERTED from apvorpa.p (converter v1.71) Fri Aug 14 09:15:26 1998 */
/* apvorpa.p - AP VOUCHER REGISTER SORT BY VEND                               */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.       */
/* web convert apvorpa.p (converter v1.00) Mon Oct 06 14:21:43 1997 */
/* web tag in apvorpa.p (converter v1.00) Mon Oct 06 14:17:57 1997 */
/*F0PN*/ /*K0MX*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=Report                                              */
/* REVISION: 7.0      LAST MODIFIED: 03/02/92             BY: MLV *F461*      */
/* Revision: 7.3          Last edit: 09/27/93             By: jcd *G247*      */
/* 7.4 08/05/93 bcm *H054* added print capability for Tax Management          */
/* Revision: 7.4          Last edit: 04/04/94             By: pcd *H318*      */
/* REVISION: 8.5      LAST MODIFIED: 02/29/96       BY: *J0CV* Brandy J Ewing */
/*                                   04/05/96             BY: jzw *G1T9*      */
/*                                   09/12/96             BY: jzw *H0MS*      */
/* REVISION: 8.6      LAST MODIFIED: 10/09/97             By: ckm *K0MX*      */
/* REVISION: 8.6      LAST MODIFIED: 01/23/98   BY: *J2B6* Prashanth Narayan  */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 04/10/98   BY: *L00K* RVSL               */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton       */
/* Pre-86E commented code removed, view in archive revision 1.12              */
/******************************************************************************/


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

         {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apvorpa_p_1 "仅为未结"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorpa_p_2 "打印已确认的凭证"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorpa_p_3 "打印采购收货"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorpa_p_4 "打印未确认的"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorpa_p_5 "打印总帐明细"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorpa_p_6 "采购单号"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorpa_p_7 "供应商类型"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorpa_p_8 "S-汇总/D-明细"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorpa_p_9 "按供应商排序"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         {wbrp02.i}

         /*DEFINE WORKFILE FOR CURRENCY TOTALS*/
         {gpacctp.i}

         define shared variable vend like ap_vend.
         define shared variable vend1 like ap_vend.
         define shared variable ref like ap_ref.
         define shared variable ref1 like ap_ref.
         define shared variable batch like ap_batch.
         define shared variable batch1 like ap_batch.
         define shared variable apdate like ap_date.
         define shared variable apdate1 like ap_date.
         define shared variable effdate like ap_effdate.
         define shared variable effdate1 like ap_effdate.
         define shared variable only_ers like mfc_logical.
         define shared variable summary
            like mfc_logical format {&apvorpa_p_8} label {&apvorpa_p_8}.
         define shared
            variable open_only like ap_open label {&apvorpa_p_1} initial no.
         define shared variable gltrans like mfc_logical initial no label
            {&apvorpa_p_5}.
         define shared variable base_rpt like ap_curr.
         define shared variable mixed_rpt like mfc_logical.
         define shared variable entity like ap_entity.
         define shared variable entity1 like ap_entity.
         define shared variable show_vph like mfc_logical
            label {&apvorpa_p_3}.
         define shared
            variable show_unconf like mfc_logical label {&apvorpa_p_4}.
         define shared
            variable show_conf like mfc_logical
            label {&apvorpa_p_2} initial yes.
         define shared variable votype like vo_type.
         define shared variable votype1 like votype.
         define shared
            variable sort_by_vend like mfc_logical label {&apvorpa_p_9}.

         define variable name like ad_name.
         define variable batch_title as character format "x(30)".
         define variable base_amt like ap_amt.
         define variable base_applied like vo_applied.
         define variable base_hold_amt like vo_hold_amt.
         define variable base_ndamt like vo_ndisc_amt.
         define variable base_damt like vod_amt.
         define variable flag as character format "x(1)" initial "".
         define variable disp_curr as character format "x(1)" label "C".
         define variable inv_amt like vph_inv_cost
            no-undo.
         define variable pur_amt like prh_pur_cost
            no-undo.
         define shared variable vdtype like vd_type label {&apvorpa_p_7}.
         define shared variable vdtype1 like vd_type.
         define new shared variable undo_txdetrp like mfc_logical.
         define variable tax_tr_type   like tx2d_tr_type initial "22".
         define variable tax_nbr       like tx2d_nbr initial "".
         define variable page_break as integer initial 0.
         define variable col-80 like mfc_logical initial false.
         define variable vopo          as character format "x(9)"
                                       label {&apvorpa_p_6} no-undo.
/*L03K*/ define variable curr_disp_line1 as character format "x(40)" no-undo.
/*L03K*/ define variable curr_disp_line2 as character format "x(40)" no-undo.

/*L00K*/ {etvar.i}

         find first gl_ctrl no-lock.
         find first apc_ctrl no-lock.


         {xxapvorp-2.i &sort1="vd_sort"
                   &frame1="c"
                   &frame2="d"
                   &frame3 ="e"
                   &frame4="f"
                   &frame5="g"
                   &frame6="h"
                   &frame7="p" }

         {wbrp04.i}
