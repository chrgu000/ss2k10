/* ictrans.i - INCLUDE FILE TO CREATE INVENTORY TRANSACTION                  */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*V8:ConvertMode=Maintenance                                                 */
/*V8:RunMode=Character,Windows                                               */
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
/* REVISION: 9.1      LAST MODIFIED: 05/28/99   BY: *J3D2* G.Latha      */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Robin McCarthy    */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* myb               */
/* REVISION: 9.1      LAST MODIFIED: 09/25/00   BY: *N0W6* Mudit Mehta       */
/* ADM                LAST MODIFIED: 03/25/04   BY: *ADM* He Shi Yu
                      Add trans record to temp table to print                */

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
/*!
*/
/*!
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
/*!
 NOTE: This include file does not handle updating
       of the fields in_qty_req, in_qty_all, in_qty_ord
       as the use of these fields is too specific at
       this time to attempt to include herein.

       Update of those fields should be performed
       just after invocation of this include file
       as in_mstr will be available for update.

     The following template can be used:

/*N014* ADDED &drsub AND &crsub REFERENCES BELOW */
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

/*N0W6*/  {cxcustom.i "ICTRANS.I"}
         &if defined(shipnbr) = 0 &then
         &scoped-define shipnbr ""
         &endif

         &if defined(shipdate) = 0 &then
         &scoped-define shipdate ?
         &endif

         &if defined(invmov) = 0 &then
         &scoped-define invmov ""
         &endif

/*ADM*/  v_ptdesc = "".
         create tr_hist.

         find pt_mstr where pt_part = {&part}
         no-lock
         no-error.

         if available pt_mstr then do:
/*ADM*/     v_ptdesc = pt_desc1.
            find pl_mstr where pl_prod_line = pt_prod_line no-lock.
            find si_mstr where si_site = {&site} no-lock.
            find pld_det where pld_prodline = pt_prod_line
            and pld_site = {&site}
            and pld_loc = {&location} no-lock no-error.
            if not available pld_det then do:
               find pld_det where pld_prodline = pt_prod_line
               and pld_site = {&site} and pld_loc = "" no-lock no-error.
               if not available pld_det then do:
                  find pld_det where pld_prodline = pt_prod_line
                  and pld_site = "" and pld_loc = "" no-lock no-error.
               end.
            end.

            if {&shiptype} = "" then do:

               find in_mstr exclusive-lock where in_part = {&part}
               and in_site = {&site} no-error.
               if not available in_mstr then do:
                  create in_mstr.
                  assign in_part = {&part}
                         in_site = {&site}.
                  in_level = 99999.

                  assign in_abc          = pt_abc
                         in_mrp          = yes
                         in_avg_int      = pt_avg_int
                         in_cyc_int      = pt_cyc_int
                         in_rctpo_status = pt_rctpo_status
                         in_rctpo_active = pt_rctpo_active
                         in_rctwo_status = pt_rctwo_status
                         in_rctwo_active = pt_rctwo_active.

                  find si_mstr where si_site = {&site} no-lock no-error.
                  if available si_mstr
                     then assign in_gl_set  = si_gl_set
                     in_cur_set = si_cur_set.

                  if recid(in_mstr) = -1 then .

               end. /*IF NOT AVAILABLE in_mstr */

               find loc_mstr where loc_site = {&site}
               and loc_loc = {&location} no-lock no-error.
               if not available loc_mstr then do:
                  create loc_mstr.
                  assign
                     loc_site = {&site}
                     loc_loc = {&location}
                     loc_date = today
                     loc_perm = no
                     loc_status = si_status.
                  if recid(loc_mstr) = -1 then .
               end.

               find ld_det where ld_site = {&site}
               and ld_loc = {&location}
               and ld_part = {&part}
               and ld_lot = {&lotserial}
               and ld_ref = {&lotref}
               exclusive-lock no-error.

               if not available ld_det then do:
                  create ld_det.
                  assign ld_site = {&site}
                         ld_loc = {&location}
                         ld_part = {&part}
                         ld_lot = {&lotserial}
                         ld_ref = {&lotref}
                         ld_status = loc_status.
                  if recid(ld_det) = -1 then .

                  if {&transtype} begins "R" then do:
                     ld_expire = {&effdate} + pt_shelflife.  /*06/30/90*/
                     if pt_shelflife = 0 then ld_expire = ?. /*06/20/90*/
                  end.
               end.

               find is_mstr where is_status = ld_status no-lock.

               if new in_mstr then assign
                  in_gl_set = si_gl_set
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

               if is_nettable then in_qty_oh = in_qty_oh + {&quantity}.
               else in_qty_nonet = in_qty_nonet + {&quantity}.

               if is_avail then in_qty_avail = in_qty_avail + {&quantity}.

               if {&transtype} begins "I"
               and {&transtype} <> "ISS-TR"  /*do not include transfers*/
               and {&transtype} <> "ISS-CHL" /*do not include status change*/
               and {&transtype} <> "ISS-GIT" /*do not include transit issue*/
               then do:
                  in_iss_chg = in_iss_chg - {&quantity}.

/*J3D2*/          /* TO UPDATE THE FIELDS in_iss_date AND in_rec_date      */
/*J3D2*/          /* CONSISTENTLY AMONG THE ISSUE AND RECEIPT TRANSACTIONS */
/*J3D2**          in_iss_date = today.                                     */

                  if in_avg_date = ? then in_avg_date =
                  min({&effdate}, today - 1).

/*N0W6*/          {&ICTRANS-I-TAG1}
                  if {&transtype} = "ISS-SO" then do:
/*N0W6*/          {&ICTRANS-I-TAG2}
                     in_sls_chg = in_sls_chg - {&quantity}.
                  end.
               end.

/*J3D2*/       /* BEGIN ADD SECTION */

               if {&transtype} begins "I"     and
                  {&transtype} <> "ISS-CHL"   and
                  not(({&site} = {&ref_site}) and
                     (index("ISS-TR ISS-GIT ISS-DO",{&transtype},1) <> 0 ))
               then do:
                  in_iss_date    = max(in_iss_date,{&effdate}).
                  if in_iss_date = ? then
                  do:
                     in_iss_date = {&effdate}.
                  end. /* IF in_iss_date = ? */
               end. /* IF {&transtype} BEGINS "I" AND <> "ISS-CHL" */

/*J3D2*/       /* END ADD SECTION */

               else
               if {&transtype} begins "R" then do:

/*J3D2**          in_rec_date = today. */
/*J3D2*/          /* BEGIN ADD SECTION */

                  if {&transtype} <> "RCT-CHL"   and
                     not(({&site} = {&ref_site}) and
                    (index("RCT-TR RCT-GIT RCT-DO",{&transtype},1) <> 0 ))
                  then do:
                     in_rec_date    = max(in_rec_date,{&effdate}).
                     if in_rec_date = ? then
                     do:
                        in_rec_date = {&effdate}.
                     end. /* IF in_rec_date = ? */
                  end. /* IF {&transtype} <> "RCT-CHL" */

/*J3D2*/          /* END ADD SECTION */

                  if {&transtype} = "RCT-SOR" then do:
                     in_sls_chg = in_sls_chg - {&quantity}.
                  end.
               end.
               else
               if {&transtype} = "TAG-CNT" or {&transtype} = "CYC-CNT" then do:

                  in_cnt_date = today.
               end.

               if not loc_perm then do:
                  if ld_qty_oh = 0
                  and ld_qty_all = 0
                  and ld_qty_frz = 0
                  and not can-find(first tag_mstr where tag_site = {&site}
                  and tag_loc = {&location}
                  and tag_part = {&part}
                  and tag_serial = {&lotserial}
                  and tag_ref = {&lotref})
                  then delete ld_det.
               end.
            end. /* if {&shiptype} = "" */
            else do:  /* shiptype <> "" pt_mstr avail */
               assign tr_um = pt_um
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

            if not available icc_ctrl then find first icc_ctrl no-lock.
            if not available in_mstr  then find in_mstr no-lock
            where in_part = {&part} and in_site = {&site} no-error.
            if {&tempid} + 0 <> 0 then do:
               find sct_det where recid(sct_det) = recno
               no-lock
               no-error.
            end.
            else if available in_mstr then do:
               if in_gl_set = "" then find sct_det
                  where sct_part = in_part and sct_sim = icc_gl_set
                  and sct_site = in_site no-lock no-error.
               else find sct_det
                  where sct_part = in_part and sct_sim = in_gl_set
                  and sct_site = in_site no-lock no-error.
            end.
         end.  /* if available pt_mstr*/

         gl_tmp_amt = {&glamt}.
         if (gl_tmp_amt <> 0) then do:

            /* ROUND GLAMT ACCORDING TO BASE CURRENCY ROUND MTHD */
/*J3BJ*/    run ip-curr-rnd in this-procedure
                (input-output gl_tmp_amt, input gl_rnd_mthd).
/*J3BJ**    {gprun.i ""gpcurrnd.p"" "(input-output gl_tmp_amt, */
/*J3BJ**       input gl_rnd_mthd)"}                            */

         end. /* IF (GL_TMP_AMT <> 0)*/

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
/*L034*/        tr_ex_rate2 = {&exrate2}
/*L034*/        tr_ex_ratetype = {&exratetype}
                tr_gl_amt = gl_tmp_amt
                tr_lot = {&lotnumber}
                tr_per_date = {&perfdate}
                tr_price = {&price}
                tr_qty_loc = {&quantity}
                tr_qty_chg = if
                          {&shiptype} = "" and
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

         tr_msg = {&msg} + 0.
         tr_ref_site = {&ref_site}.

/*L034*/ /* COPY TRIANGULATION USAGE RECORDS TO */
/*L034*/ /* CREATE NEW ONES FOR TR_HIST.        */
/*L034*/ {gprunp.i "mcpl" "p" "mc-copy-ex-rate-usage"
                   "(input  {&exruseq},
                     output tr_exru_seq)"}

         if not available icc_ctrl then find first icc_ctrl no-lock.
         if available sct_det then do:
            if icc_cogs then do:
               tr_mtl_std = sct_mtl_tl + sct_mtl_ll
                  + sct_lbr_ll + sct_bdn_ll + sct_ovh_ll + sct_sub_ll.
               tr_lbr_std = sct_lbr_tl.
               tr_bdn_std = sct_bdn_tl.
               tr_ovh_std = sct_ovh_tl.
               tr_sub_std = sct_sub_tl.
            end.
            else do:
               tr_mtl_std = sct_mtl_tl + sct_mtl_ll.
               tr_lbr_std = sct_lbr_tl + sct_lbr_ll.
               tr_bdn_std = sct_bdn_tl + sct_bdn_ll.
               tr_ovh_std = sct_ovh_tl + sct_ovh_ll.
               tr_sub_std = sct_sub_tl + sct_sub_ll.
            end.
         end.

         tr_mtl_std = tr_mtl_std + {&mtlstd}.
         tr_lbr_std = tr_lbr_std + {&lbrstd}.
         tr_bdn_std = tr_bdn_std + {&bdnstd}.
         tr_ovh_std = tr_ovh_std + {&ovhstd}.
         tr_sub_std = tr_sub_std + {&substd}.

         {mfntran.i}

/*ADM  if {&transtype} = "ISS-TR" then v_frloc = tr_loc.*/
/*ADM  if {&transtype} = "RCT-TR" then do:*/
/*ADM*/       create prttbl.
/*ADM*/       assign
                 p_nbr     = tr_trnbr 
                 p_part    = tr_part
                 p_desc    = v_ptdesc 
                 p_chg     = tr_qty_loc 
                 p_type    = tr_type
/*                 p_frloc   = v_frloc*/
                 p_toloc   = tr_loc
                 p_effdate = tr_effdate
                 p_lot     = tr_lot
                 p_um      = tr_um.  
/*ADM  end.*/

         create trgl_det.
         assign trgl_trnbr = tr_trnbr
                trgl_type = tr_type
                trgl_sequence = recid(trgl_det)
                trgl_dr_acct = {&dracct}
/*N014*/        trgl_dr_sub  = {&drsub}
                trgl_dr_cc   = {&drcc}
                trgl_dr_proj = {&drproj}
                trgl_cr_acct = {&cracct}
/*N014*/        trgl_cr_sub  = {&crsub}
                trgl_cr_cc   = {&crcc}
                trgl_cr_proj = {&crproj}
                trgl_gl_amt  = trgl_gl_amt + tr_gl_amt.

         /*NOTE: MFICGL02.I IS AVOIDED BY PASSING 0.00 TO TR_GL_AMT  */
         /*      THIS IS NECESSARY WHEN MULTIPLE GLT_DET RECORDS ARE */
         /*      REQUIRED FOR ONE TR_HIST SUCH AS POSTING COGS IN SO */
         /*      AND PPV IN PO'S.                                    */

         /* GL TRANSACTIONS */
/*N014*  ADDED &dr-sub AND &cr-sub REFERENCES BELOW */
         {mficgl02.i
         &gl-amount=tr_gl_amt   &tran-type=tr_type   &order-no=tr_nbr
         &dr-acct=trgl_dr_acct  &dr-cc=trgl_dr_cc    &drproj=trgl_dr_proj
         &dr-sub=trgl_dr_sub    &cr-sub=trgl_cr_sub
         &cr-acct=trgl_cr_acct  &cr-cc=trgl_cr_cc    &crproj=trgl_cr_proj
         &entity="if available pt_mstr then si_entity else glentity"
         &find="false" &same-ref="icc_gl_sum"
         }

         if recid(tr_hist) = -1 then .
         /* Make sure tr_hist is available in calling program */

/*J3BJ*/ &if defined(ip-curr-proc) = 0 &then
/*J3BJ*/     &global-define ip-curr-proc
/*J3BJ*/ procedure ip-curr-rnd:
/*J3BJ*/    define input-output parameter io_amt     as decimal no-undo.
/*J3BJ*/    define input        parameter i_rnd_mthd as character no-undo.

/*J3BJ*/    define variable               v_error    as integer no-undo.

/*J3BJ*/    {gprunp.i "mcpl" "p" "mc-curr-rnd"
               "(input-output io_amt,
                 input        i_rnd_mthd,
                 output       v_error)" }

/*J3BJ*/    if v_error <> 0 then do:
/*J3BJ*/       {mfmsg.i v_error 2}
/*J3BJ*/    end.

/*J3BJ*/ end procedure. /*ip-curr-rnd*/
/*J3BJ*/ &endif.
