/* GUI CONVERTED from soivmta4.p (converter v1.75) Mon Oct 23 22:30:00 2000 */
/* soivmta4.p - PENDING INVOICE LINE ITEM MAINTENANCE                    */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.  */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                    */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                  */
/* REVISION: 7.4      LAST MODIFIED: 10/20/94   BY: dpm *FR95*           */
/* REVISION: 7.4      LAST MODIFIED: 11/01/94   BY: ame *GN90*           */
/* REVISION: 7.4      LAST MODIFIED: 01/28/95   BY: ljm *H09Z*           */
/* REVISION: 8.5      LAST MODIFIED  03/06/95   BY: dpm *J044*           */
/* REVISION: 8.5      LAST MODIFIED: 06/07/95   BY: DAH *J042*           */
/* REVISION: 8.5      LAST MODIFIED: 07/19/95   BY: DAH *J05N*           */
/* REVISION: 8.5      LAST MODIFIED: 04/29/96   BY: DAH *J0KJ*           */
/* REVISION: 8.5      LAST MODIFIED: 07/15/96   BY: ajw *J0Z6*           */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Kurt De Wit   */
/* REVISION: 8.6      LAST MODIFIED: 07/09/97   BY: *H0ZJ* Samir Bavkar  */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan    */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan    */
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *M017* Sandy Brown   */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan    */
/* REVISION: 9.0      LAST MODIFIED: 09/25/00   BY: *L121* Gurudev C     */
         {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE soivmta4_p_1 "计划总装加工单"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivmta4_p_2 "说明"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivmta4_p_3 "折扣"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivmta4_p_4 "重新定价"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivmta4_p_5 "客户订单"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         define shared variable line         like sod_line.
         define shared variable del-yn       like mfc_logical.
         define shared variable prev_due     like sod_due_date.
         define shared variable prev_consume like sod_consume.
         define shared variable prev_type    like sod_type.
         define shared variable delete_line  like mfc_logical.
         define shared variable prev_qty_ord like sod_qty_ord.
         define shared variable sod_recno    as recid.
         define shared variable so_recno     as recid.
         define shared variable pcqty        like sod_qty_ord.
         define shared frame c.
         define shared frame d.
         define shared variable ln_fmt       like soc_ln_fmt.
         define shared variable so_db        like dc_name.
         define variable err-flag            as integer.
         define shared variable err_stat     as integer.
         define shared variable sonbr        like sod_nbr.
         define shared variable soline       like sod_line.
         define shared variable continue     like mfc_logical.
         define shared variable clines as integer initial ?.
         define variable desc1 like pt_desc1.
         define shared variable mult_slspsn like mfc_logical no-undo.
         define shared variable sodcmmts like soc_lcmmts label {&soivmta4_p_2}.
/*J042*/ define shared variable save_parent_list like sod_list_pr.
/*J05N*/ define shared variable discount     as decimal label {&soivmta4_p_3}
/*J05N*/                                                format "->>>9.9<<<".
/*J05N*/ define shared variable reprice_dtl  like mfc_logical label {&soivmta4_p_4}.

         continue = no .

         find so_mstr where recid(so_mstr) = so_recno.
         find sod_det where recid(sod_det) = sod_recno.

         /*DEFINE FORMS C AND D*/
         {soivlnfm.i}
/*H09Z*/ /*V8:HiddenDownFrame=c */
          view frame c.
         if ln_fmt then view frame d.

         if sod_sched and
         (can-find (first sch_mstr where sch_type = 1
          and sch_nbr = sod_nbr and sch_line = sod_line) or
          can-find (first sch_mstr where sch_type = 2
          and sch_nbr = sod_nbr and sch_line = sod_line) or
          can-find (first sch_mstr where sch_type = 3
          and sch_nbr = sod_nbr and sch_line = sod_line)) then do:
            {mfmsg.i 6022 3}
            leave .
         end.

/*K004*/ if sod_btb_type = "02" or sod_btb_type = "03" then do:
/*K004*/    {mfmsg.i 1021 3}
/*K004*/    /* DELETE NOT ALLOWED */
/*K004*/    leave.
/*K004*/ end.

         /* Delete line information that might exist in other databases */
         find si_mstr where si_site = sod_site no-lock.
         if si_db <> so_db then do:
            {gprun.i ""gpalias3.p"" "(si_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

            assign
             sonbr  = so_nbr
             soline = sod_line .
/*L121**    {gprun.i ""solndel.p""} */
/*L121*/    /* ADDED INPUT PARAMETER no TO NOT EXEXUTE MFSOFC01.I */
/*L121*/    /* AND MFSOFC02.I WHEN CALLED FROM DETAIL LINE        */

/*L121*/    {gprun.i ""solndel.p""
                     "(input no)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            /* Reset the db alias to the sales order database */
            {gprun.i ""gpalias3.p"" "(so_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

            sod_recno = recid(sod_det).
         end.

/*J0KJ*/ /*IF RMA RECEIPT LINE, NO NEED TO UPDATE ACCUM QTY TABLE OR pih_hist*/

/*J042*/ /* UPDATE ACCUM QTY WORKFILE WITH REVERSAL.  save_parent_list
**          DETERMINED IN soivmtea.p */

/*J0KJ*/ if sod_fsm_type <> "RMA-RCT" then do:
/*J042*/    {gprun.i ""gppiqty2.p"" "(
                                      sod_line,
                                      sod_part,
                                    - sod_qty_ord,
                                    - (sod_qty_ord * save_parent_list),
                                      sod_um,
                                      yes,
/*J0Z6*/                              yes,
                                      yes
                                     )"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J042*/ /* DELETE SALES ORDER LINE RELATED PRICE LIST HISTORY */
/*J042*/    {gprun.i ""gppihdel.p"" "(
                                      1,
                                      sod_nbr,
                                      sod_line
                                     )"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J0KJ*/ end.

         if can-find (first sob_det where sob_nbr = sod_nbr
                                      and sob_line = sod_line) then do:
            if sod_type = "" then do:
               /* DELETE MRP PLANNED ORDER FOR PARENT */
               {mfmrw.i "sod_fas" sod_part sod_nbr string(sod_line) """"
               ? sod_due_date "0" "SUPPLYF" {&soivmta4_p_1} sod_site}
            end.

            delete_line = yes.
            /* DELETE SOB, MRP etc. FOR COMPONENTS */
            {gprun.i ""sosomtk.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

         end.

         /* MRP WORKFILE */
         {mfmrw.i "sod_det" sod_part sod_nbr string(sod_line) """" ?
          sod_due_date "0" "DEMAND" {&soivmta4_p_5} sod_site}

         /*DELETE COMMENTS*/
/*GN90* for each cmt_det where cmt_indx = sod_cmtindx:*/
/*GN90*/ for each cmt_det exclusive-lock where cmt_indx = sod_cmtindx:
            delete cmt_det.
         end.

         find qad_wkfl
              where qad_key1  = "sod_sv_code"
              and   qad_key2  = sod_nbr + "+" + string(sod_line)
              no-error.
         if available qad_wkfl then
            delete qad_wkfl.

         line = line - 1.

         if sod_sched then do:
            find scx_ref
            where scx_type = 1 and scx_order = sod_nbr and scx_line = sod_line
            exclusive-lock.

            delete scx_ref.
         end.

/*J044*/ /* DELETE IMPORT EXPORT RECORDS */
/*J044*/ for each ied_det exclusive-lock where
/*J044*/    ied_type = "1" and ied_nbr = sod_nbr  and ied_line = sod_line :
/*J044*/    delete ied_det.
/*J044*/ end.


/*H0ZJ*/ /* DELETE TAX DETAIL RECORDS FOR THE SO DETAIL LINE TO BE DELETED */
/*H0ZJ*/ if {txnew.i} then do:
/*H0ZJ*/    for each tx2d_det exclusive-lock
/*H0ZJ*/    where tx2d_ref = so_nbr    and
/*H0ZJ*/          tx2d_nbr = ""        and
/*H0ZJ*/          tx2d_line = sod_line and
/*H0ZJ*/          (tx2d_tr_type = "11" or
/*H0ZJ*/           tx2d_tr_type = "12" or
/*H0ZJ*/           tx2d_tr_type = "13"):

/*H0ZJ*/         delete tx2d_det.

/*H0ZJ*/    end. /* FOR EACH tx2d_det */

/*H0ZJ*/    for each tx2d_det exclusive-lock
/*H0ZJ*/    where tx2d_ref = so_inv_nbr and
/*H0ZJ*/          tx2d_nbr = so_nbr     and
/*H0ZJ*/          tx2d_line = sod_line  and
/*H0ZJ*/          tx2d_tr_type = "16" :

/*H0ZJ*/         delete tx2d_det.

/*H0ZJ*/    end. /* FOR EACH tx2d_det */

/*H0ZJ*/ end. /* IF {TXNEW.I}*/

/*M017*/ /*DELETE THE SALES ORDER DETAIL RELATIONSHIPS FOR APM */
/*M017*/ {gprun.i ""sosoapm4.p"" "(sod_nbr, sod_line)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         delete sod_det.

         del-yn = no.
         pause 0 .
         clear frame c.
         if ln_fmt then clear frame d.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame d = F-d-title.
         {mfmsg.i 6 1}

         continue = yes.
