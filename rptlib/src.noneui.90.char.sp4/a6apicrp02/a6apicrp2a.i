/* apicrp2a.i - INVOICE/PURCHASE COST VARIANCE REPORT CONTINUATION            */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.       */
/*F0PN*/ /*V8:ConvertMode=Report                                              */
/* REVISION: 6.0    LAST MODIFIED: 07/30/91    BY: MLV *F001*                 */
/* REVISION: 7.0    LAST MODIFIED: 01/27/92    BY: MLV *F096*                 */
/* REVISION: 7.0    LAST MODIFIED: 08/14/92    BY: MLV *F847*                 */
/* REVISION: 7.3    LAST MODIFIED: 11/19/92    BY: jcd *G349*                 */
/*                                 05/17/93    BY: JJS *GB03*                 */
/*                                 06/21/93    BY: JMS *GC52*                 */
/*                                 04/10/96    BY: jzw *G1LD*                 */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 04/10/98   BY: *L00K* RVSL               */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton       */
/* Pre-86E commented code removed, view in archive revision 1.6               */
/* REVISION: 8.6E     LAST MODIFIED: 10/06/98   BY: *L09C* Santhosh Nair      */
/* REVISION: 9.0      LAST MODIFIED: 03/06/00   BY: *M0KG* Jose Alex          */
/* REVISION: 9.0      LAST MODIFIED: 04/18/01   BY: *M15K* Vihang Talwalkar   */
/* REVISION: 9.0      LAST MODIFIED: 08/15/05   BY: *SS - 20050815* Bill Jiang   */
/******************************************************************************/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apicrp2a_i_1 "     报表合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE apicrp2a_i_2 "零件: "
/* MaxLen: Comment: */

&SCOPED-DEFINE apicrp2a_i_3 "采购单!凭证"
/* MaxLen: Comment: */

&SCOPED-DEFINE apicrp2a_i_4 "  采购员合计: "
/* MaxLen: Comment: */

&SCOPED-DEFINE apicrp2a_i_5 " 零件合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE apicrp2a_i_6 "采购员:"
/* MaxLen: Comment: */

/*L09C*/ /* REPLACED LITERAL STRING "Base" WITH PRE-PROCESSOR */
&SCOPED-DEFINE apicrp2a_i_7 "基本"
/* MaxLen: 4 Comment: */

/* ********** End Translatable Strings Definitions ********* */

         for each prh_hist
         where (prh_nbr >= order and prh_nbr <= order1)
         and (prh_vend >= vendor and prh_vend <= vendor1)
         and (prh_buyer >= buyer and prh_buyer <= buyer1)

         and (prh_part >= part and prh_part <= part1)
         and (prh_site >= site and prh_site <= site1)
         and ((prh_type = "" and sel_inv = yes)
          or  (prh_type = "S" and sel_sub = yes)
          or  (prh_type <> "" and prh_type <> "S" and sel_mem = yes))
/*L00K*****
 *       and (prh_curr = base_rpt
 *        or base_rpt = "")
 *
 *       use-index {&index} no-lock,
 */
         use-index {&index} no-lock,
         each vph_hist where vph_receiver = prh_receiver
         and vph_line = prh_line
         and vph_nbr = prh_nbr
         and ((vph_inv_date >= idate and vph_inv_date <= idate1)
         or  (vph_inv_date = ? and idate = low_date))
         and (vph_inv_qty >= 0 or sel_neg = yes)
         use-index vph_nbr no-lock,
/*L00K   start adding */
         each vo_mstr where vo_ref = vph_ref
/*M0KG** and (vo_curr = base_rpt or base_rpt = "base") */
/*M0KG*/ and (vo_curr = base_rpt or base_rpt = "")
         no-lock
         /* SS - 20050815 - B */
         ,EACH ap_mstr 
         WHERE ap_type = "VO"
         AND ap_ref = vo_ref
         AND ((ap_effdate >= edate AND ap_effdate <= edate1) OR (ap_effdate = ? AND edate = low_date))
         NO-LOCK
         /* SS - 20050815 - E */
/*L00K   end adding */

         break by {&break}
         with frame {&frame} down width 132 no-box:
            {mfrpchk.i}

/*L03K*/    assign
               base_pur_cost = prh_pur_cost
                             * prh_um_conv
            base_inv_cost = vph_inv_cost
            disp_curr = "".

/*M15K**    if prh_curr <> base_curr then do: */
/*M15K*/    if prh_curr    <> base_curr
/*M15K*/       or base_rpt <> base_curr
/*M15K*/    then do:
               if base_rpt <> "" then do:
/*L00K*           find vo_mstr where vo_ref = vph_ref no-lock.*/
/*L03K*           BEGIN DELETE
 *L00K*           if et_tk_active then
 *L00K*              assign base_pur_cost = base_pur_cost * vo_ex_rate.
 *L03K*           END DELETE */
/*L03K*/          /* CONVERT FROM BASE TO FOREIGN CURRENCY */
/*L03K*/          {gprunp.i "mcpl" "p" "mc-curr-conv"
                   "(input base_curr,
                     input vo_curr,
                     input vo_ex_rate2,
                     input vo_ex_rate,
                     input base_pur_cost,
                     input false, /* DO NOT ROUND */
                     output base_pur_cost,
                     output mc-error-number)"}.
/*L03K*           BEGIN DELETE
 *L00K*           else
 *                   assign
 *                      base_pur_cost = base_pur_cost * prh_ex_rate.
 *                base_inv_cost = base_inv_cost * vo_ex_rate.
 *L03K*           END DELETE */
/*L03K*/          /* CONVERT FROM BASE TO FOREIGN CURRENCY */
/*L03K*/          {gprunp.i "mcpl" "p" "mc-curr-conv"
                   "(input base_curr,
                     input vo_curr,
                     input vo_ex_rate2,
                     input vo_ex_rate,
                     input base_inv_cost,
                     input false, /* DO NOT ROUND */
                     output base_inv_cost,
                     output mc-error-number)"}.
               end.
               else disp_curr = "Y".
            end. /* IF PRH_CURR <> BASE_CURR */

            /* IF SORTBY BUYER PAGE WHEN FIRST-OF prh_buyer */
            /* SS - 20050815 - B */
            /*
            if {&index} = prh_buyer and
            not first({&index}) and first-of({&index}) then page.

            form
               header         skip (1)
               {&apicrp2a_i_6}
               prh_buyer      skip (1)
            with frame {&frame-1} page-top no-labels width 132 no-box.
            if {&index} = prh_buyer then view frame {&frame-1}.
            */
            /* SS - 20050815 - E */

            /* VOUCHER THAT CLOSED THIS PRH_HIST GETS VARIENCE DUE TO QTY    */
            /* WHICH IS THE QTY RECEIVED LESS QTY INVOICED ON OTHER VOUCHERS */
            if prh_last_vo = vph_ref then rcvd_open =
            prh_rcvd - (prh_inv_qty - vph_inv_qty).
            else rcvd_open = vph_inv_qty.
/*L03K*/    assign
               inv_qty = vph_inv_qty * prh_um_conv
               inv_ext = base_inv_cost * vph_inv_qty
               pur_ext = base_pur_cost * rcvd_open

               pvar_unit = (base_inv_cost - base_pur_cost) / prh_um_conv
               pvar_ext = inv_ext - pur_ext.

            find pt_mstr where pt_part = prh_part no-lock no-error.
            if available pt_mstr then desc1 = pt_desc1 + " " + pt_desc2.
            else desc1 = "".

                 /* SS - 20050815 - B */
                 CREATE tta6apicrp02.
                 ASSIGN
                     tta6apicrp02_part = prh_part
                     tta6apicrp02_vend = prh_vend
                     tta6apicrp02_nbr = prh_nbr
                     tta6apicrp02_type = prh_type
                     tta6apicrp02_disp_curr = DISP_curr
                     tta6apicrp02_pur_cost = base_pur_cost / prh_um_conv
                     tta6apicrp02_inv_cost = base_inv_cost / prh_um_conv
                     tta6apicrp02_qty = inv_qty
                     tta6apicrp02_pur_ext = pur_ext
                     tta6apicrp02_inv_ext = inv_ext
                     tta6apicrp02_pvar_unit = pvar_unit
                     tta6apicrp02_pvar_ext = pvar_ext
                     tta6apicrp02_ref = vph_ref
                     .
                 /*
            form
               header
               {&apicrp2a_i_2}
               prh_part
               desc1          skip (1)
            with frame {&frame-2} page-top no-labels width 132 no-box.
            if not first-of (prh_part) then view frame {&frame-2}.

            if first-of (prh_part) then do:
               if page-size - line-counter < 6 then page.
               display skip(1) {&apicrp2a_i_2} prh_part desc1
               with frame {&frame-3} no-labels.
            end.

            display
               prh_vend
               prh_nbr  column-label {&apicrp2a_i_3}
               prh_type
               disp_curr
               base_pur_cost / prh_um_conv @ prh_pur_cost
                  format "->>>>>>>>>9.99<<<"
               base_inv_cost / prh_um_conv @ vph_inv_cost
                  format "->>>>>>>>>9.99<<<"
               inv_qty
               pur_ext
               inv_ext
               pvar_unit
               pvar_ext.
            down 1.
            display vph_ref @ prh_nbr.

            accumulate inv_qty (total by {&accum}).
            accumulate inv_ext (total by {&accum}).
            accumulate pur_ext (total by {&accum}).
            accumulate pvar_ext (total by {&accum}).
            if last-of (prh_part) then do:
               if page-size - line-counter < 2 then page.
               underline inv_qty pur_ext inv_ext pvar_ext.
               display
/*L09C**          (if base_rpt = "" then "Base" else base_rpt)   */
/*L09C*/          (if base_rpt = "" then {&apicrp2a_i_7} else base_rpt)
                   + {&apicrp2a_i_5} format "x(16)" @ vph_inv_cost
                  accum total by prh_part inv_qty
                     format "->>>>>>>>>9.99<<<" @ inv_qty
                  accum total by prh_part pur_ext
                     format "->>>>>>>>>9.99<<<" @ pur_ext
                  accum total by prh_part inv_ext
                     format "->>>>>>>>>9.99<<<" @ inv_ext
                  accum total by prh_part pvar_ext
                     format "->>>>>>>>>9.99<<<" @ pvar_ext.
            end.
            if {&index} = prh_buyer and last-of ({&index}) then do:
               if page-size - line-counter < 2 then page.
               underline pvar_ext.
               display
/*L09C**          (if base_rpt = "" then "Base" else base_rpt)   */
/*L09C*/          (if base_rpt = "" then {&apicrp2a_i_7} else base_rpt)
                   + {&apicrp2a_i_4} format "x(19)" @ vph_inv_cost
                  accum total by {&index} pvar_ext
                     format "->>>>>>>>>9.99<<" @ pvar_ext.
            end.
            */
            /* SS - 20050815 - E */
         end. /* FOR EACH PRH_HIST */

         /* SS - 20050815 - B */
         /*
         if page-size - line-counter < 2 then page.
         display
            "--------------" at 118
/*L09C**    (if base_rpt = "" then "Base" else base_rpt)   */
/*L09C*/    (if base_rpt = "" then {&apicrp2a_i_7} else base_rpt)
             + {&apicrp2a_i_1} to 115 format "x(20)"
            accum total pvar_ext
               format "->>>>>>>>>9.99<<<" at 118 skip(1)
         with frame f width 132 down no-box no-labels.
         */
         /* SS - 20050815 - E */
