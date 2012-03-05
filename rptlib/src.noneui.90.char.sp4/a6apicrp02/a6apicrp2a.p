/* apicrp2a.p - INVOICE/PURCHASE COST VARIANCE REPORT CONTINUATION            */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.       */
/*F0PN*/ /*K0SY*/
/*V8:ConvertMode=Report                                              */
/* REVISION: 4.0           LAST EDIT: 01/14/87         MODIFIED BY: FLM       */
/* REVISION: 6.0    LAST MODIFIED: 06/28/91    BY: MLV *D733*         */
/* REVISION: 7.0    LAST MODIFIED: 08/10/91    BY; MLV *F001*         */
/* REVISION: 7.0    LAST MODIFIED: 08/14/92    BY: MLV *F847*         */
/* REVISION: 7.3    LAST MODIFIED: 04/10/96    BY: jzw *G1LD*         */
/* REVISION: 8.6    LAST MODIFIED: 10/11/97    BY: ckm *K0SY*         */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 04/10/98   BY: *L00K* RVSL               */
/* REVISION: 8.6E     LAST MODIFIED: 05/18/98   BY: *L00Z* D. Sidel           */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton       */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 08/15/05   BY: *SS - 20050815* Bill Jiang         */
/* Pre-86E commented code removed, view in archive revision 1.8               */
/******************************************************************************/
/* SS - 20050815 - B */
{a6apicrp02.i}

define input parameter edate like ap_effdate.
define input parameter edate1 like ap_effdate.
define input parameter idate like vph_inv_date.
define input parameter idate1 like vph_inv_date.
define input parameter vendor like prh_vend.
define input parameter vendor1 like prh_vend.
define input parameter buyer like prh_buyer.
define input parameter buyer1 like prh_buyer.
define input parameter order like prh_nbr.
define input parameter order1 like prh_nbr.
define input parameter part like prh_part.
define input parameter part1 like prh_part.
define input parameter site like prh_site.
define input parameter site1 like prh_site.

define input parameter sel_inv like mfc_logical.
define input parameter sel_sub like mfc_logical.
define input parameter sel_mem like mfc_logical.
define input parameter sel_neg like mfc_logical.

define input parameter sortby like mfc_logical.
define input parameter base_rpt like ap_curr.
/* SS - 20050815 - E */


         {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apicrp2a_p_1 "包括退货零件"
/* MaxLen: Comment: */

&SCOPED-DEFINE apicrp2a_p_2 "I-零件/B-采购员"
/* MaxLen: Comment: */

&SCOPED-DEFINE apicrp2a_p_3 "发票与采购单!单位成本差异"
/* MaxLen: Comment: */

&SCOPED-DEFINE apicrp2a_p_4 "发票与采购单!成本差异合计"
/* MaxLen: Comment: */

&SCOPED-DEFINE apicrp2a_p_5 "包括库存零件"
/* MaxLen: Comment: */

&SCOPED-DEFINE apicrp2a_p_6 "包括非库存零件"
/* MaxLen: Comment: */

&SCOPED-DEFINE apicrp2a_p_7 "发票成本!合计"
/* MaxLen: Comment: */

&SCOPED-DEFINE apicrp2a_p_8 "采购成本!合计"
/* MaxLen: Comment: */

&SCOPED-DEFINE apicrp2a_p_9 "包括转包零件"
/* MaxLen: Comment: */

&SCOPED-DEFINE apicrp2a_p_10 "按 I-零件/B-采购员"
/* MaxLen: Comment: */

&SCOPED-DEFINE apicrp2a_p_11 "使用标准成本合计"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         {wbrp02.i}
/*L00Z*  /*L00K*/ {etvar.i "new"} */
/*L00Z*/ {etvar.i &new = "new"}
/*L00Z*  {etrpvar.i "new"} */
/*L00Z*/ {etrpvar.i &new = "new"}
         {eteuro.i}

    /* SS - 20050815 - B */
    /*
         define shared variable idate like vph_inv_date.
         define shared variable idate1 like vph_inv_date.
         define shared variable vendor like prh_vend.
         define shared variable vendor1 like prh_vend.
         define shared variable buyer like prh_buyer.
         define shared variable buyer1 like prh_buyer.
         define shared variable order like prh_nbr.
         define shared variable order1 like prh_nbr.
         define shared variable part like prh_part.
         define shared variable part1 like prh_part.
         define shared variable sel_inv like mfc_logical
            label {&apicrp2a_p_5} initial yes.
         define shared variable sel_sub like mfc_logical
            label {&apicrp2a_p_9} initial yes.
         define shared variable sel_mem like mfc_logical
            label {&apicrp2a_p_6} initial no.
         define shared variable sel_neg like mfc_logical
            label {&apicrp2a_p_1} initial no.
         define shared variable use_tot like mfc_logical
            label {&apicrp2a_p_11} initial no.
         define shared variable sortby like mfc_logical
            format {&apicrp2a_p_2} label {&apicrp2a_p_10} initial yes.
         */
         define shared variable use_tot like mfc_logical
            label {&apicrp2a_p_11} initial no.
         /* SS - 20050815 - E */
         define variable vend_name like ad_name.
         define variable inv_qty like prh_inv_qty.
         define variable inv_ext as decimal format "->>>>>>>>>9.99<<<"
            column-label {&apicrp2a_p_7}.
         define variable pur_ext as decimal format "->>>>>>>>>9.99<<<"
            column-label {&apicrp2a_p_8}.
         define variable pvar_unit like prh_pur_std format "->>>>>>>>>9.99<<<"
            column-label {&apicrp2a_p_3}.
         define variable pvar_ext as decimal format "->>>>>>>>>9.99<<<"
            column-label {&apicrp2a_p_4}.
         define variable desc1 like pt_desc1 format "x(49)".
         define variable base_pur_cost like prh_pur_cost.
         define variable base_inv_cost like vph_inv_cost.
         /* SS - 20050815 - B */
         /*
         define shared variable base_rpt like ap_curr.
         define variable disp_curr as character format "x(1)" label "C".
         define shared variable site like prh_site.
         define shared variable site1 like prh_site.
         */
         define variable disp_curr as character format "x(1)" label "C".
         /* SS - 20050815 - E */
         define variable rcvd_open like prh_rcvd.

         loopb:
         do on error undo, leave:

             /* SS - 20050815 - B */
             /*
            if sortby = no /* BY "BUYER" */
            then do on error undo, leave loopb:
               {apicrp2a.i &index = "prh_buyer"
                           &break = "prh_buyer by prh_part"
                           &frame = "b"
                           &accum = "prh_buyer by prh_part"
                           &frame-1 = "phead1"
                           &frame-2 = "phead3"
                           &frame-3 = "c"}
            end.

            if sortby = yes /* BY "ITEM" */
            then do on error undo, leave loopb:
               {apicrp2a.i &index = "prh_part"
                           &break = "prh_part"
                           &frame = "g"
                           &accum = "prh_part"
                           &frame-1 = "phead2"
                           &frame-2 = "phead4"
                           &frame-3 = "d"}
            end.
               */
               if sortby = no /* BY "BUYER" */
               then do on error undo, leave loopb:
                  {a6apicrp2a.i &index = "prh_buyer"
                              &break = "prh_buyer by prh_part"
                              &frame = "b"
                              &accum = "prh_buyer by prh_part"
                              &frame-1 = "phead1"
                              &frame-2 = "phead3"
                              &frame-3 = "c"}
               end.

               if sortby = yes /* BY "ITEM" */
               then do on error undo, leave loopb:
                  {a6apicrp2a.i &index = "prh_part"
                              &break = "prh_part"
                              &frame = "g"
                              &accum = "prh_part"
                              &frame-1 = "phead2"
                              &frame-2 = "phead4"
                              &frame-3 = "d"}
               end.
               /* SS - 20050815 - E */

         end.
         {wbrp04.i}
