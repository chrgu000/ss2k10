/* apvorpb.p - AP VOUCHER REGISTER SORT BY BATCH                        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.12.2.8 $                                          */
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
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* Pre-86E commented code removed, view in archive revision 1.11              */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00 BY: *N0KK* jyn                  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.12.2.5   BY: Mercy C.             DATE: 03/27/02  ECO: *M1WF*  */
/* Revision: 1.12.2.6  BY: Paul Donnelly DATE: 05/17/02 ECO: *M1YP* */
/* $Revision: 1.12.2.8 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/* $Revision: 1.12.2.8 $ BY: Bill Jiang DATE: 08/26/07 ECO: *SS - 20070826.1* */
/*-Revision end---------------------------------------------------------------*/


/*V8:ConvertMode=Report                                        */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
/* EXTERNAL LABEL INCLUDE */
{gplabel.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apvorpb_p_1 "Sort by Supplier"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorpb_p_2 "Summary/Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorpb_p_3 "Supplier Type"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorpb_p_4 "Print Unconfirmed"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorpb_p_5 "PO Number"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorpb_p_6 "Print GL Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorpb_p_7 "Print Purchase Receipts"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorpb_p_8 "Print Confirmed"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorpb_p_9 "Open Only"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{wbrp02.i}

/*DEFINE WORKFILE FOR CURRENCY TOTALS*/
{gpacctp.i}

define new shared variable undo_txdetrp like mfc_logical.

define shared variable vend     like ap_vend.
define shared variable vend1    like ap_vend.
define shared variable ref      like ap_ref.
define shared variable ref1     like ap_ref.
define shared variable batch    like ap_batch.
define shared variable batch1   like ap_batch.
define shared variable apdate   like ap_date.
define shared variable apdate1  like ap_date.
define shared variable effdate  like ap_effdate.
define shared variable effdate1 like ap_effdate.
define shared variable only_ers like mfc_logical.
define shared variable summary  like mfc_logical format {&apvorpb_p_2}
                               label {&apvorpb_p_2}.
define shared variable open_only   like ap_open initial no label {&apvorpb_p_9}.
define shared variable gltrans     like mfc_logical        label {&apvorpb_p_6}.
define shared variable base_rpt    like ap_curr     no-undo.
define shared variable mixed_rpt   like mfc_logical.
define shared variable entity      like ap_entity.
define shared variable entity1     like ap_entity.
define shared variable vdtype1     like vd_type.
define shared variable show_vph    like mfc_logical        label {&apvorpb_p_7}.
define shared variable vdtype      like vd_type            label {&apvorpb_p_3}.
define shared variable show_unconf like mfc_logical        label {&apvorpb_p_4}.
define shared variable show_conf   like mfc_logical        label {&apvorpb_p_8}    initial yes.
define shared variable votype      like vo_type.
define shared variable votype1     like votype.
define shared variable sort_by_vend like mfc_logical       label {&apvorpb_p_1}.

define variable name          like ad_name                            no-undo.
define variable batch_title   as   character format "x(30)"           no-undo.
define variable base_amt      like ap_amt                             no-undo.
define variable base_applied  like vo_applied                         no-undo.
define variable base_hold_amt like vo_hold_amt                        no-undo.
define variable base_ndamt    like vo_ndisc_amt                       no-undo.
define variable base_damt     like vod_amt                            no-undo.
define variable flag          as   character format "x(1)" initial "" no-undo.
define variable disp_curr     as   character format "x(1)" label "C"  no-undo.
define variable inv_amt       like vph_inv_cost                       no-undo.
define variable pur_amt       like prh_pur_cost                       no-undo.
define variable tax_tr_type   like tx2d_tr_type initial "22"          no-undo.
define variable tax_nbr       like tx2d_nbr initial ""                no-undo.
define variable page_break    as   integer  initial 0                 no-undo.
define variable col-80        like mfc_logical                        no-undo.
define variable vopo          as   character format "x(9)"  label {&apvorpb_p_5}                                                                      no-undo.
define variable curr_disp_line1 as character format "x(40)"           no-undo.
define variable curr_disp_line2 as character format "x(40)"           no-undo.

{etvar.i}

for first gl_ctrl
   fields( gl_domain gl_rnd_mthd)
 where gl_ctrl.gl_domain = global_domain no-lock:
end. /* FOR FIRST gl_ctrl */

/* SS - 20070826.1 - B */
/*
{apvorp.i &sort1="ap_batch"
   &frame1="i"
   &frame2="j"
   &frame3="k"
   &frame4="l"
   &frame5="m"
   &frame6="n"
   &frame7="o" }
*/
{ssapvorp0002i.i &sort1="ap_batch"
   &frame1="i"
   &frame2="j"
   &frame3="k"
   &frame4="l"
   &frame5="m"
   &frame6="n"
   &frame7="o" }
/* SS - 20070826.1 - E */

{wbrp04.i}