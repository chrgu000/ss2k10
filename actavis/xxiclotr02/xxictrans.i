/* GUI CONVERTED from ictrans.i (converter v1.78) Fri Oct 29 14:37:08 2004 */
/* ictrans.i - INCLUDE FILE TO CREATE INVENTORY TRANSACTION                  */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */

/* REVISION: 6.0      LAST MODIFIED: 06/20/90   BY: WUG *D002*               */
/* REVISION: 6.0      LAST MODIFIED: 10/12/90   BY: emb *D098*               */
/* REVISION: 6.0      LAST MODIFIED: 10/25/90   BY: pml *D143*               */
/* REVISION: 6.0      LAST MODIFIED: 03/13/91   BY: WUG *D472*               */
/* REVISION: 6.0      LAST MODIFIED: 08/01/91   BY: emb *D800*               */
/* REVISION: 6.0      LAST MODIFIED: 08/09/91   BY: WUG *D819*               */
/* REVISION: 7.0      LAST MODIFIED: 09/04/91   BY: pma *F003*               */
/* REVISION: 7.0      LAST MODIFIED: 10/10/91   BY: dgh *D892*               */
/* REVISION: 7.0      LAST MODIFIED: 11/11/91   BY: WUG *D887*               */
/* REVISION: 7.0      LAST MODIFIED: 02/04/92   BY: pma *F148*               */
/* REVISION: 7.0      LAST MODIFIED: 02/06/92   BY: pma *F175*               */
/* REVISION: 7.0      LAST MODIFIED: 02/27/92   BY: pma *F243*               */
/* REVISION: 7.0      LAST MODIFIED: 03/20/92   BY: dld *F297*               */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: dld *F358*               */
/* REVISION: 7.0      LAST MODIFIED: 07/09/92   BY: pma *F745*               */
/* REVISION: 7.0      LAST MODIFIED: 07/31/92   BY: pma *F821*               */
/* REVISION: 7.0      LAST MODIFIED: 09/25/92   BY: pma *G096*               */
/* REVISION: 7.3      LAST MODIFIED: 03/16/93   BY: emb *G977*               */
/* REVISION: 7.3      LAST MODIFIED: 01/13/94   BY: pxd *FL38*               */
/* REVISION: 7.3      LAST MODIFIED: 02/15/94   BY: pxd *FL60*               */
/* REVISION: 7.3      LAST MODIFIED: 08/30/94   BY: pxd *FQ62*               */
/* REVISION: 7.3      LAST MODIFIED: 09/11/94   BY: pxd *FR08*               */
/* REVISION: 7.3      LAST MODIFIED: 10/04/94   BY: pxd *FR90*               */
/* REVISION: 7.3      LAST MODIFIED: 10/29/94   BY: bcm *GN73*               */
/* REVISION: 7.3      LAST MODIFIED: 01/18/95   BY: jxz *FT13*               */
/* REVISION: 7.3      LAST MODIFIED: 01/16/96   BY: ame *G1K4*               */
/* REVISION: 8.5      LAST MODIFIED: 08/08/95   BY: taf *J053*               */
/* REVISION: 8.6      LAST MODIFIED: 10/18/96   BY: *K003* Vinay Nayak-Sujir */
/* REVISION: 8.6      LAST MODIFIED: 11/18/97   BY: *J1PS* Felcy D'Souza     */
/* REVISION: 8.6      LAST MODIFIED: 12/03/97   BY: *J27G* Viswanathan       */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* REVISION: 8.6E     LAST MODIFIED: 06/26/98   BY: *L034* Markus Barone     */
/* REVISION: 9.0      LAST MODIFIED: 03/25/99   BY: *J3BJ* Sanjeev Assudani  */
/* REVISION: 9.1      LAST MODIFIED: 05/28/99   BY: *J3D2* G.Latha           */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Robin McCarthy    */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* myb               */
/* REVISION: 9.1      LAST MODIFIED: 09/25/00   BY: *N0W6* Mudit Mehta       */
/* Revision:          BY: Katie Hilbert         DATE: 04/01/01 ECO: *P008*   */
/* Revision: 1.19     BY: Russ Witt             DATE: 09/21/01 ECO: *P01H*   */
/* Revision: 1.20     BY: Robin McCarthy        DATE: 01/29/02 ECO: *P000*   */
/* Revision: 1.21     BY: Russ Witt             DATE: 05/14/02 ECO: *P03G*   */
/* Revision: 1.22     BY: Russ Witt             DATE: 05/29/02 ECO: *P079*   */
/* Revision: 1.23     BY: Ashish Maheshwari     DATE: 01/06/03 ECO: *N21Y*   */
/* Revision: 1.24     BY: Dorota Hohol          DATE: 02/26/03 ECO: *P0N6*   */
/* Revision: 1.25     BY: Russ Witt DATE:       DATE: 04/09/03 ECO: *P0M4*   */
/* Revision: 1.27     BY: Paul Donnelly (SB)    DATE: 06/28/03 ECO: *Q00G*   */
/* Revision: 1.28     BY: Vinay Soman           DATE: 01/05/04 ECO: *P1FF*   */
/* $Revision: 1.29 $   BY: Shivaraman V.         DATE: 06/28/04 ECO: *P27H*   */
/* $Revision: eb21sp6  BY: Apple Tam        DATE:  05/10/10 ECO: *ss-20100510.1* */
/* ss - 100701.1 by: jack */ /* ld_qty_all < 0 Ôò= 0*/
/*-Revision end---------------------------------------------------------------*/


/*V8:ConvertMode=Maintenance                                                 */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* ROUND GLAMT ACCORDING TO GL_RND_MTHD.  THE CALLING PROGRAM MUST*/
/* PERFORM A FIND ON THE GL_CTRL FILE.                            */

     /*********************************************************/
     /* NOTES:   1. Patch FL60 sets in_level to a value       */
     /*             of 99999 when in_mstr is created or       */
     /*             when any structure or network changes are */
     /*             made that affect the low level codes.     */
     /*          2. The in_levels are recalculated when MRP   */
     /*             is run or can be resolved by running the  */
     /*             mrllup.p utility program.                 */
     /*********************************************************/

/**************************************************************/
/*
 NOTE: As of F003 tr_mtl_std, tr_lbr_std, etc are found and added
       from within this include file rather than being passed by
       the calling program.

       Any changes to these values are passed as &mtlstd, &lbrstd etc.
     e.g. to add sobmtl to the standard tr_mtl_std, pass
          &mtlstd=sobmtl
     e.g. to make tr_mtl_std = 0, pass
          &mtlstd="- tr_mtl_std"

       To access a specific cost record pass the argument {&tempid} with
       a value > 0 and set the mfdeclre.i variable recno to record id
       of the cost record to be accessed.
*/
/*
 NOTE: This include file does not handle updating
       of the fields in_qty_req, in_qty_all, in_qty_ord
       as the use of these fields is too specific at
       this time to attempt to include herein.

       Update of those fields should be performed
       just after invocation of this include file
       as in_mstr will be available for update.

     The following template can be used:
     {ictrans.i
        &addrid=""""
        &bdnstd=0
        &cracct=""""
        &crsub=""""
        &crcc=""""
        &crproj=""""
        &curr=""""
        &dracct=""""
        &drsub=""""
        &drcc=""""
        &drproj=""""
        &effdate=?
        &exrate=0
        &exrate2=0
        &exratetype=""""
        &exruseq=0
        &glamt=0
        &kbtrans=0
        &lbrstd=0
        &line=0
        &location=""""
        &lotnumber=""""
        &lotref=""""
        &lotserial=""""
        &mtlstd=0
        &ordernbr=""""
        &ovhstd=0
        &part=""""
        &perfdate=?
        &price=0
        &promisedate=?
        &quantityreq=0
        &quantityshort=0
        &quantity=0
        &revision=""""
        &rmks=""""
        &trordrev=""""
        &shiptype=""M""
        &shipnbr=""""
        &shipdate=?
        &invmov=""""
        &site=""""
        &slspsn1=""""
        &slspsn2=""""
        &slspsn3=""""
        &slspsn4=""""
        &sojob=""""
        &substd=0
        &transtype=""""
        &msg=0
        &ref_site=""""
        }

        As of patch F297, if a value is to be passed to the 3rd and 4th
        salespersons in tr_hist, the entire statement will need to be
        placed in quotation marks.  This method allowed the addition of
        the salesperson parameters without altering all programs which
        call ictrans.i.  Therefore, if no values are required for the
        3rd and 4th salespersons, the parameters are not required in the
        calling program. Following is an example which was used in mfivtr.i:

            &slspsn3="{1} tr_slspsn[3] = sod_slspsn[3]"
            &slspsn4="{1} tr_slspsn[4] = sod_slspsn[4]"

        As of patch F358, if a value is to be passed to tr_ord_rev,
        the entire statement should be placed in quotation marks and
        set equal to &trordrev.
*/
/**************************************************************/

         {cxcustom.i "ICTRANS.I"}
         &if defined(shipnbr) = 0 &then
         &scoped-define shipnbr ""
         &endif

         &if defined(shipdate) = 0 &then
         &scoped-define shipdate ?
         &endif

         &if defined(promisedate) = 0 &then
         &scoped-define promisedate ?
         &endif

         &if defined(kbtrans) = 0 &then
         &scoped-define kbtrans 0
         &endif

         &if defined(invmov) = 0 &then
         &scoped-define invmov ""
         &endif

         create tr_hist. tr_hist.tr_domain = global_domain.

         find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
         {&part}
         no-lock
         no-error.

         if available pt_mstr then do:
            find pl_mstr  where pl_mstr.pl_domain = global_domain and
            pl_prod_line = pt_prod_line no-lock.
            find si_mstr  where si_mstr.si_domain = global_domain and  si_site
            = {&site} no-lock.
            find pld_det  where pld_det.pld_domain = global_domain and
            pld_prodline = pt_prod_line
            and pld_site = {&site}
            and pld_loc = {&location} no-lock no-error.
            if not available pld_det then do:
               find pld_det  where pld_det.pld_domain = global_domain and
               pld_prodline = pt_prod_line
               and pld_site = {&site} and pld_loc = "" no-lock no-error.
               if not available pld_det then do:
                  find pld_det  where pld_det.pld_domain = global_domain and
                  pld_prodline = pt_prod_line
                  and pld_site = "" and pld_loc = "" no-lock no-error.
               end.
            end.

            if {&shiptype} = "" then do:

               find in_mstr exclusive-lock  where in_mstr.in_domain =
               global_domain and  in_part = {&part}
               and in_site = {&site} no-error.
               if not available in_mstr then do:
                  create in_mstr. in_mstr.in_domain = global_domain.
                  assign in_part = {&part}
                         in_gl_cost_site = {&site}
                         in_site         = {&site}
                         in_level        = 99999
                         in_abc          = pt_abc
                         in_mrp          = yes
                         in_avg_int      = pt_avg_int
                         in_cyc_int      = pt_cyc_int
                         in_rctpo_status = pt_rctpo_status
                         in_rctpo_active = pt_rctpo_active
                         in_rctwo_status = pt_rctwo_status
                         in_rctwo_active = pt_rctwo_active.

                  find si_mstr  where si_mstr.si_domain = global_domain and
                  si_site = {&site} no-lock no-error.
                  if available si_mstr
                  then assign
                     in_gl_set  = si_gl_set
                     in_cur_set = si_cur_set.

                  if recid(in_mstr) = -1 then .

                  /* GET GL COST SITE AND COST SET NAME */
                  {gprun.i ""gpingl.p""
                           "(input  in_site,
                             input  in_part,
                             output in_gl_cost_site,
                             output in_gl_set)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               end. /*IF NOT AVAILABLE in_mstr */

               find loc_mstr  where loc_mstr.loc_domain = global_domain and
               loc_site = {&site}
               and loc_loc = {&location} no-lock no-error.
               if not available loc_mstr then do:
                  create loc_mstr. loc_mstr.loc_domain = global_domain.
                  assign
                     loc_site = {&site}
                     loc_loc = {&location}
                     loc_date = today
                     loc_perm = no
                     loc_status = si_status.
                  if recid(loc_mstr) = -1 then .
               end.

               find ld_det  where ld_det.ld_domain = global_domain and  ld_site
               = {&site}
               and ld_loc = {&location}
               and ld_part = {&part}
               and ld_lot = {&lotserial}
               and ld_ref = {&lotref}
               exclusive-lock no-error.

               if not available ld_det then do:
                  create ld_det. ld_det.ld_domain = global_domain.
                  assign ld_site = {&site}
                         ld_loc = {&location}
                         ld_part = {&part}
                         ld_lot = {&lotserial}
                         ld_ref = {&lotref}
                         ld_status = loc_status.
                  if recid(ld_det) = -1 then .

                  if {&transtype} begins "R" then do:
                     ld_expire = {&effdate} + pt_shelflife.
                     if pt_shelflife = 0 then ld_expire = ?.
                  end.
               end.

               find is_mstr  where is_mstr.is_domain = global_domain and
               is_status = ld_status no-lock.

               if new in_mstr then assign
                  in_cur_set = si_cur_set
                  in_abc = pt_abc
                  in_avg_int = pt_avg_int
                  in_cyc_int = pt_cyc_int.

               /*START UPDATING*/
               if is_nettable then in_mrp = yes.

               assign
                  tr_begin_qoh = in_qty_oh + in_qty_nonet
                  tr_um        = pt_um
                  tr_prod_line = pt_prod_line
                  tr_loc_begin = ld_qty_oh
                  tr_assay     = ld_assay
                  tr_grade     = ld_grade
                  tr_status    = ld_status
                  tr_expire    = ld_expire.

               tr_last_date = max(max(if in_rec_date = ? then low_date
                              else in_rec_date,
                              if in_iss_date = ? then low_date
                              else in_iss_date),
                              if in_cnt_date = ? then low_date
                              else in_cnt_date).

               if tr_last_date = low_date then
                  tr_last_date = ?.

               ld_qty_oh = ld_qty_oh + {&quantity}.
                  /* ss - 100701.1 -b
/*ss-20100510.1*/ ld_qty_all = ld_qty_all + {&quantity2}.
                 ss - 100701.1 -e */
               /* ss - 100701.1 -b */
               ld_qty_all = ld_qty_all + {&quantity2}.
               IF ld_qty_all < 0  THEN
                   ld_qty_all = 0 .
               /* ss - 100701.1 -e */

               if is_nettable then in_qty_oh = in_qty_oh + {&quantity}.
               else in_qty_nonet = in_qty_nonet + {&quantity}.

               if is_avail then in_qty_avail = in_qty_avail + {&quantity}.

               if {&transtype} begins "I"
               and {&transtype} <> "ISS-TR"  /*do not include transfers*/
               and {&transtype} <> "ISS-CHL" /*do not include status change*/
               and {&transtype} <> "ISS-GIT" /*do not include transit issue*/
               then do:
                  in_iss_chg = in_iss_chg - {&quantity}.

                  /* TO UPDATE THE FIELDS in_iss_date AND in_rec_date      */
                  /* CONSISTENTLY AMONG THE ISSUE AND RECEIPT TRANSACTIONS */

                  if in_avg_date = ? then
                     in_avg_date = min({&effdate}, today - 1).

                  {&ICTRANS-I-TAG1}
                  if {&transtype} = "ISS-SO" then do:
                  {&ICTRANS-I-TAG2}
                     in_sls_chg = in_sls_chg - {&quantity}.
                  end.
               end.

               if {&transtype} begins "I"     and
                  {&transtype} <> "ISS-CHL"   and
                  not(({&site} = {&ref_site}) and
                     (index("ISS-TR ISS-GIT ISS-DO",{&transtype},1) <> 0 ))
               then do:
                  in_iss_date    = max(in_iss_date,{&effdate}).
                  if in_iss_date = ? then
                     in_iss_date = {&effdate}.
               end. /* IF {&transtype} BEGINS "I" AND <> "ISS-CHL" */

               else
               if {&transtype} begins "R" then do:

                  if {&transtype} <> "RCT-CHL"   and
                     not(({&site} = {&ref_site}) and
                    (index("RCT-TR RCT-GIT RCT-DO",{&transtype},1) <> 0 ))
                  then do:
                     in_rec_date    = max(in_rec_date,{&effdate}).
                     if in_rec_date = ? then
                        in_rec_date = {&effdate}.
                  end. /* IF {&transtype} <> "RCT-CHL" */

                  if {&transtype} = "RCT-SOR" then
                     in_sls_chg = in_sls_chg - {&quantity}.
               end.
               else
               if {&transtype} = "TAG-CNT" or {&transtype} = "CYC-CNT" then
                  in_cnt_date = today.

               if not loc_perm
               then do:

                  if {&transtype}   = "TAG-CNT"
                     and ld_qty_oh  = 0
                     and ld_qty_all = 0
                  then
                     delete ld_det.

                  if {&transtype}  <> "TAG-CNT"
                     and ld_qty_oh  = 0
                     and ld_qty_all = 0
                     and ld_qty_frz = 0
                     and not can-find(first tag_mstr  where tag_mstr.tag_domain
                     = global_domain and  tag_site = {&site}
                                      and tag_loc    = {&location}
                                      and tag_part   = {&part}
                                      and tag_serial = {&lotserial}
                                      and tag_ref    = {&lotref})
                  then do:

                     /* ld_det SHOULD NOT BE DELETED WHEN SUPPLIER */
                     /* CONSIGNMENT FUNCTIONALITY IS ACTIVE AND    */
                     /* SUPPLIER CONSIGNED QUANTITY IS NOT ZERO    */

                     for first cns_ctrl
                        fields (cns_domain cns_active)
                        where cns_domain = global_domain
                     no-lock:
                     end. /* FOR FIRST cns_ctrl */

                     if not available cns_ctrl
                     or (available cns_ctrl
                         and (cns_active          = no
                              or (cns_active              = yes
                                  and ld_supp_consign_qty = 0)))
                     then
                        delete ld_det.

                  end. /* IF {&transtype} <> "TAG-CNT" */

               end. /* IF NOT loc_perm */

            end. /* if {&shiptype} = "" */
            else do:  /* shiptype <> "" pt_mstr avail */
               assign
                  tr_um = pt_um
                  tr_prod_line = pt_prod_line.
               if available in_mstr then do:
                  assign
                     tr_begin_qoh = in_qty_oh + in_qty_nonet

                     tr_last_date = max(max(if in_rec_date = ? then low_date
                                    else in_rec_date,
                                    if in_iss_date = ? then low_date
                                    else in_iss_date),
                                    if in_cnt_date = ? then low_date
                                    else in_cnt_date).

                   if tr_last_date = low_date then
                      tr_last_date = ?.

               end.
            end.  /* shiptype <> "" pt_mstr avail */

            if not available icc_ctrl then find first icc_ctrl  where
            icc_ctrl.icc_domain = global_domain no-lock.
            if not available in_mstr  then
               find in_mstr no-lock
                where in_mstr.in_domain = global_domain and  in_part = {&part}
                and in_site = {&site} no-error.
            if {&tempid} + 0 <> 0 then
               find sct_det where recid(sct_det) = recno no-lock no-error.
            else if available in_mstr then do:
               if in_gl_set = "" then
                  find sct_det
                   where sct_det.sct_domain = global_domain and  sct_part =
                   in_part and sct_sim = icc_gl_set
                    and sct_site = in_gl_cost_site no-lock no-error.
               else
                  find sct_det
                   where sct_det.sct_domain = global_domain and  sct_part =
                   in_part and sct_sim = in_gl_set
                    and sct_site = in_gl_cost_site no-lock no-error.
            end.
         end.  /* if available pt_mstr*/

         gl_tmp_amt = {&glamt}.
         if (gl_tmp_amt <> 0) then
            /* ROUND GLAMT ACCORDING TO BASE CURRENCY ROUND MTHD */
            run ip-curr-rnd in this-procedure
                (input-output gl_tmp_amt, input gl_rnd_mthd).

         /* The revision of the order is stored as of the last order print. */

         assign tr_date = today
                tr_time = time
                tr_userid = global_userid
                tr_part = {&part}
                tr_so_job = {&sojob}
                tr_type = {&transtype}
                tr_addr = {&addrid}
                tr_site = {&site}
                tr_serial = {&lotserial}
                tr_ref = {&lotref}
                tr_loc = {&location}
                tr_effdate = {&effdate}
                tr_line = {&line}
                tr_nbr = {&ordernbr}
                tr_rmks = {&rmks}
                tr_curr = {&curr}
                tr_ex_rate = {&exrate}
                tr_ex_rate2 = {&exrate2}
                tr_ex_ratetype = {&exratetype}
                tr_gl_amt = gl_tmp_amt
                tr_lot = {&lotnumber}
                tr_per_date = {&perfdate}
                tr_price = {&price}
                tr_promise_date = {&promisedate}
                tr_qty_loc = {&quantity}
                tr_qty_chg = if {&shiptype} = "" and
                   available pt_mstr and available is_mstr and is_nettable
                   then {&quantity} else 0
                tr_qty_req = {&quantityreq}
                tr_qty_short = {&quantityshort}
                tr_rev = {&revision}
                {&trordrev}
                tr_ship_type = {&shiptype}
                tr_ship_id = {&shipnbr}
                tr_ship_date = {&shipdate}
                tr_ship_inv_mov = {&invmov}
                tr_slspsn[1] = {&slspsn1}
                tr_slspsn[2] = {&slspsn2}
                {&slspsn3}
                {&slspsn4}.
         assign
            tr_msg = {&msg} + 0
            tr_ref_site = {&ref_site}.

         /* COPY TRIANGULATION USAGE RECORDS TO */
         /* CREATE NEW ONES FOR TR_HIST.        */
         {gprunp.i "mcpl" "p" "mc-copy-ex-rate-usage"
                   "(input  {&exruseq},
                     output tr_exru_seq)"}

         if not available icc_ctrl then find first icc_ctrl  where
         icc_ctrl.icc_domain = global_domain no-lock.
         if available sct_det then do:
            if icc_cogs then
            assign
               tr_mtl_std = sct_mtl_tl + sct_mtl_ll
                  + sct_lbr_ll + sct_bdn_ll + sct_ovh_ll + sct_sub_ll
               tr_lbr_std = sct_lbr_tl
               tr_bdn_std = sct_bdn_tl
               tr_ovh_std = sct_ovh_tl
               tr_sub_std = sct_sub_tl.
            else
            assign
               tr_mtl_std = sct_mtl_tl + sct_mtl_ll
               tr_lbr_std = sct_lbr_tl + sct_lbr_ll
               tr_bdn_std = sct_bdn_tl + sct_bdn_ll
               tr_ovh_std = sct_ovh_tl + sct_ovh_ll
               tr_sub_std = sct_sub_tl + sct_sub_ll.
         end.

         assign
            tr_mtl_std = tr_mtl_std + {&mtlstd}
            tr_lbr_std = tr_lbr_std + {&lbrstd}
            tr_bdn_std = tr_bdn_std + {&bdnstd}
            tr_ovh_std = tr_ovh_std + {&ovhstd}
            tr_sub_std = tr_sub_std + {&substd}.

         {mfntran.i}

         create trgl_det. trgl_det.trgl_domain = global_domain.
         assign trgl_trnbr = tr_trnbr
                trgl_type = tr_type
                trgl_sequence = recid(trgl_det)
                trgl_dr_acct = {&dracct}
                trgl_dr_sub  = {&drsub}
                trgl_dr_cc   = {&drcc}
                trgl_dr_proj = {&drproj}
                trgl_cr_acct = {&cracct}
                trgl_cr_sub  = {&crsub}
                trgl_cr_cc   = {&crcc}
                trgl_cr_proj = {&crproj}
                trgl_gl_amt  = trgl_gl_amt + tr_gl_amt.

         /*NOTE: MFICGL02.I IS AVOIDED BY PASSING 0.00 TO TR_GL_AMT  */
         /*      THIS IS NECESSARY WHEN MULTIPLE GLT_DET RECORDS ARE */
         /*      REQUIRED FOR ONE TR_HIST SUCH AS POSTING COGS IN SO */
         /*      AND PPV IN PO'S.                                    */

         /* GL TRANSACTIONS */
         {mficgl02.i
         &gl-amount=tr_gl_amt   &tran-type=tr_type   &order-no=tr_nbr
         &dr-acct=trgl_dr_acct  &dr-cc=trgl_dr_cc    &drproj=trgl_dr_proj
         &dr-sub=trgl_dr_sub    &cr-sub=trgl_cr_sub
         &cr-acct=trgl_cr_acct  &cr-cc=trgl_cr_cc    &crproj=trgl_cr_proj
         &entity="if available pt_mstr then si_entity else glentity"
         &find="false" &same-ref="icc_gl_sum"
         }

         /* SEE IF KANBAN TRANSACTION NUMBER PASSED */
         /* IF SO CREATE kbtrd_DET RECORD */
         if {&kbtrans} <> 0
         then do:
            if not can-find(first kbtrd_det
                            where kbtrd_det.kbtrd_domain = global_domain
                            and   kbtrd_dataset          = "tr_hist"
                            and   kbtrd_tr_trnbr         = tr_trnbr)
            then do:
               create kbtrd_det.
               kbtrd_det.kbtrd_domain = global_domain.
               assign
                  kbtrd_dataset        = "tr_hist"
                  kbtrd_tr_trnbr       = tr_trnbr
                  kbtrd_kbtr_trans_nbr = {&kbtrans}
                  kbtrd_mod_userid     = global_userid
                  kbtrd_mod_date       = today.
               if recid(kbtrd_det) = -1 then .
            end. /* IF NOT CAN-FIND(FIRST kbtrd_det */
         end. /* IF {&kbtrans} <> 0 */

         if recid(tr_hist) = -1 then .
         /* Make sure tr_hist is available in calling program */

         &if defined(ip-curr-proc) = 0 &then
             &global-define ip-curr-proc
         procedure ip-curr-rnd:
            define input-output parameter io_amt     as decimal no-undo.
            define input        parameter i_rnd_mthd as character no-undo.

            define variable               v_error    as integer no-undo.

            {gprunp.i "mcpl" "p" "mc-curr-rnd"
               "(input-output io_amt,
                 input        i_rnd_mthd,
                 output       v_error)" }

            if v_error <> 0 then do:
               {pxmsg.i &MSGNUM=v_error &ERRORLEVEL=2}
            end.

         end procedure. /*ip-curr-rnd*/
         &endif.

{&ICTRANS-I-TAG3}
