/* poporpa.p - PURCHASE ORDER REPORT BY ORDER                           */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*K0M3*/
/*V8:ConvertMode=Report                                                 */
/* REVISION: 6.0     LAST MODIFIED: 10/25/90    BY: pml *D157*          */
/* REVISION: 6.0     LAST MODIFIED: 03/19/91    BY: bjb *D461*          */
/* REVISION: 7.0     LAST MODIFIED: 03/18/92    BY: TMD *F261*          */
/* REVISION: 7.3     LAST MODIFIED: 04/30/93    BY: WUG *GA61*          */
/* REVISION: 7.3     LAST MODIFIED: 09/14/95    BY: dxk *F0V5*          */
/* REVISION: 8.5     LAST MODIFIED: 10/11/95    BY: TAF *J053*          */
/* REVISION: 8.5     LAST MODIFIED: 04/08/96    BY: jzw *G1LD*          */
/* REVISION: 8.6     LAST MODIFIED: 12/07/96    BY: tzm *K022*          */
/* REVISION: 8.6     LAST MODIFIED: 10/11/97    BY: mur *K0M3*          */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane    */
/* REVISION: 8.6E    LAST MODIFIED: 06/16/98    BY: *L020* Charles Yen  */
/* REVISION: 9.1     LAST MODIFIED: 07/07/99    BY: *N00X* Anup Pereira */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KQ* myb              */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE poporpa_p_1 "Open PO's Only"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporpa_p_2 "Ext Cost"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporpa_p_3 "Sort by Buyer"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporpa_p_4 "Qty Open"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         /* DISPLAY TITLE */
         {mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
         {wbrp02.i}

         define shared variable rndmthd like rnd_rnd_mthd.
         define shared variable oldcurr like po_curr.
         define shared variable disp_curr as character format "x(1)" label "C".
         define shared variable base_tot like pod_std_cost.
         define  shared variable vend like po_vend.
         define  shared variable vend1 like po_vend.
         define  shared variable nbr like po_nbr.
         define  shared variable nbr1 like po_nbr.
         define  shared variable so_job like pod_so_job.
         define  shared variable so_job1 like pod_so_job.
         define  shared variable due like pod_due_date.
         define  shared variable due1 like pod_due_date.
         define  shared variable ord like po_ord_date.
         define  shared variable ord1 like po_ord_date.
         define shared variable ext_cost like pod_pur_cost label {&poporpa_p_2}
                  format "->,>>>,>>>,>>9.99".
         define shared variable qty_open like pod_qty_ord label {&poporpa_p_4}.
         define shared variable desc1 like pt_desc1.
         define shared variable desc2 like pt_desc2.
         define shared variable open_only like mfc_logical initial yes
         label {&poporpa_p_1}.
         define shared variable cdate like po_cls_date.
         define shared variable cdate1 like po_cls_date.
         define shared variable perform like pod_per_date.
         define shared variable perform1 like pod_per_date.
         define shared variable buyer like po_buyer.
         define shared variable buyer1 like po_buyer.
         define shared variable req   like pod_req_nbr.
         define shared variable req1   like pod_req_nbr.
         define shared variable blanket   like po_blanket.
         define shared variable blanket1   like po_blanket.
         define shared variable sortby like mfc_logical label {&poporpa_p_3}.
         define variable base_cost like pod_pur_cost.
         define buffer ship-to for ad_mstr.
         define shared variable  base_rpt like po_curr.
         define shared variable mixed_rpt like mfc_logical.
         define shared variable site like pod_site.
         define shared variable site1 like pod_site.

/*N00X*/ define new shared variable l_currdisp1 as character format "X(20)"
/*N00X*/                                                     no-undo.
/*N00X*/ define new shared variable l_currdisp2 as character format "X(20)"
/*N00X*/                                                     no-undo.

         define variable old_db as character no-undo.
         define variable error-flag as integer no-undo.
         define shared variable incl_b2b_po like mfc_logical.
/*L020*/ define variable mc-error-number like msg_nbr no-undo.

         {gpfieldv.i}

         {porpfrm.i "new" }

{gppopp.i}

         find first gl_ctrl no-lock no-error.

         if sortby = no then do:
            {xxinvporp.i &sort1 = "po_nbr" &sort2 = "pod_line" &sort3 = "pod_line"
                      &frame1 = "b" &frame2 = "c"}
         end. /* if not sorted by buyer */

         if sortby = yes then do:
            {xxinvporp.i &sort1 = "po_buyer" &sort2 = "po_nbr" &sort3 = "pod_line"
                            &frame1 = "d" &frame2 = "e"}
         end. /* if sorted by buyer */
         {wbrp04.i}
