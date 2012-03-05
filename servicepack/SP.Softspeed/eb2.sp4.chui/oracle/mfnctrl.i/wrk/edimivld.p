/* edimivld.p - ECommerce Invoice Loader                                      */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.16 $                                                          */
/*V8:ConvertMode=NoConvert                                                    */
/* Revision: 1.9      BY: Paul Dreslinski     DATE: 07/09/01   ECO: *M195*  */
/* Revision: 1.10     BY: Jean Miller         DATE: 12/13/01   ECO: *P03Q*  */
/* Revision: 1.11     BY: Patrick Rowan       DATE: 04/17/02   ECO: *P043*  */
/* Revision: 1.12     BY: Patrick Rowan       DATE: 04/30/02   ECO: *P05Q*  */
/* Revision: 1.13     BY: Patrick Rowan       DATE: 05/15/02   ECO: *P06L*  */
/* Revision: 1.14     BY: Patrick Rowan       DATE: 05/17/02   ECO: *P06W*  */
/* Revision: 1.15     BY: Patrick Rowan       DATE: 06/18/02   ECO: *P090*  */
/* $Revision: 1.16 $    BY: Rajiv Ramaiah       DATE: 08/20/02   ECO: *N1RN*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* THIS LOGIC WAS COPIED FROM apersupa.p                               */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

&IF defined(from_ecom) = 0 &THEN
   &GLOBAL-DEFINE from_ecom
&ENDIF

define input parameter i_proc_sess like edmfsd_proc_sess no-undo.
define input parameter i_doc_seq   like edmfsdd_mfd_seq  no-undo.
define input parameter i_err_file  as   character        no-undo.

{gldydef.i}
{gldynrm.i}

{edimivdf.i}
{edimimp.i}
{edtmpdef.i}
{edecmsg.i}
{edimproc.i}

{txcalvar.i}
{apersupa.i "new"}
{apconsdf.i}

/* FOR USE WITH ERROR MESSAGES */
define variable x as integer no-undo.

/*FOR USE WITH GPGLEF01.I*/
define new shared variable gtmconv like  mfc_logical initial false no-undo.
define variable gl_trans_type as character no-undo.
define variable gl_trans_ent  as character no-undo.
define variable gl_effdt_date as date no-undo.
define variable gpglef        like msg_nbr no-undo.
define variable glvalid       as logical no-undo.

/*FOR USE WITH PRICE LIST LOOKUP*/
define variable price_list2 as character no-undo.
define variable new_pod     as logical initial yes no-undo.
define variable list_price  like prh_pur_cost.
define variable net_price   as decimal.
define variable minprice    as decimal.
define variable maxprice    as decimal.
define variable disc_pct    as decimal.
define variable pc_recno    as recid.

/*USED WHEN VALIDATING GST/VAT CLASS*/
define variable taxc        as character no-undo.

/*USED IF CURR_AMT = 0*/
define variable err_flag    as integer no-undo.

/*USED WHEN TEMP TABLE IS BUILT*/
define variable proc_rec  as logical.
define variable getref    as logical initial true.
define variable inbatch   as character.
define variable module    as character.
define variable doc_type  as character.
define variable bactrl    as integer.
define variable apref     as character.
define variable redu      as logical.
define variable disc_date as date.
define variable due_date  as date.

define new shared variable batch like ap_batch.

/*USED FOR SITE USER AUTHORIZATION (GPSIRVR.P) */
define variable authorized as integer no-undo.

define variable voucher_date as date no-undo.

define variable apentity like ap_entity no-undo.
define variable po_recid as recid.
define variable work_amt like ap_amt no-undo.
define variable effective_date as date no-undo.
define variable termvar like po_cr_terms no-undo.

/* FOR MCPL.P PROCEDURES */
define variable l_valid_rcvr    like mfc_logical no-undo.
define buffer phist   for prh_hist.
define buffer prhhist for prh_hist.

/* FOR PENDING VOUCHER PROCEDURES */
define variable vouchered_qty like pvo_vouchered_qty no-undo.
define variable last_voucher like pvo_last_voucher no-undo.
define variable ers_status like pvo_ers_status no-undo.
define buffer pvomstr for pvo_mstr.
define buffer pmstr   for pvo_mstr.

define variable extend_cost as decimal.

/*THE FOLLOWING ARE FOR APVOMTI.P*/
define new shared variable undo_txdist like mfc_logical.
define new shared variable base_det_amt like glt_amt.
define new shared variable base_amt like ap_amt.
define new shared variable curr_amt like vph_curr_amt.
define new shared variable vod_recno as recid.
define new shared variable undo_all like mfc_logical.
define new shared variable jrnl like glt_ref.
define new shared variable recalc_tax like mfc_logical initial true.
define new shared variable no_taxrecs like mfc_logical.
define new shared variable ap_recno as recid.
define new shared variable vo_recno as recid.
define new shared variable vd_recno as recid.
define new shared variable ba_recno as recid.
define new shared variable tax_tr_type like tx2d_tr_type initial "22".
define new shared variable aptotal  like ap_amt.
define new shared variable tax_flag like mfc_logical.
define new shared variable vod_amt_fmt as character.
define new shared frame c.
define new shared frame tax_dist.

/*SHARED VARIABLES FOR CURRENCY DEPENDENT ROUNDING*/
define new shared variable rndmthd like rnd_rnd_mthd.
{apcurvar.i "new"}

define variable l_ex_rate     like po_ex_rate     no-undo.
define variable l_ex_rate2    like po_ex_rate2    no-undo.
define variable l_exru_seq    like po_exru_seq    no-undo.
define variable l_ex_ratetype like po_ex_ratetype no-undo.

/*DEFINED FOR APVOMTA4.P*/
define new shared variable totinvdiff like ap_amt.
define new shared variable fill-all like mfc_logical.
define new shared variable new_vchr like mfc_logical.
define new shared variable rcvd_open like prh_rcvd.

/*DEFINE VARIABLES FOR ERROR REPORT*/
define variable po       like po_nbr no-undo.
define variable receiver like prh_receiver no-undo.
define variable line     like prh_line no-undo.
define variable msg1 as character format "x(75)" no-undo.
define new shared stream rport.
define variable prhline_err_stat as logical.

/*FOR GL COSTING*/
define variable glx_mthd like cs_method.
define variable cur_mthd like cs_method.

/* DEFINE VARIABLES FOR DATABASE SWITCHING FOR APERSUPB.P */
define variable old_db              like si_db no-undo.
define new shared variable new_site like si_site.
define new shared variable new_db   like si_db.

/* DEFINE 'BEFORE IMAGE' WORKFILES */
{apvobidf.i "new"}

/* DEFINE PRH_HIST UPDATE TEMP-TABLE */
{apvoprdf.i "new"}

{etvar.i &new="new" } /* COMMON EURO VARIABLES*/

/*DEFINE ERROR REPORT HEADER AND BODY*/

/*GET CONTROL RECORDS*/
find first apc_ctrl no-lock no-error.
find first gl_ctrl  no-lock no-error.
find first poc_ctrl no-lock no-error.

/* INITIALIZE SETTINGS */
{gprunp.i "gpglvpl" "p" "initialize"}

mainloop:
do transaction:

   for first prh_hist where
      (prh_hist.prh_nbr      = ed_vo_Po_no) and
      (prh_hist.prh_receiver = ed_vo_receiver)
   no-lock: end.

   /*IF A SITE CANNOT BE ACCESSED BY A USER AN ERROR IS GENERATED*/
   find si_mstr where si_site = prh_site no-lock no-error.
   if available si_mstr then do:
      {gprun.i ""gpsiver.p""
         "(input si_site, input recid(si_mstr), output authorized)"}
      if authorized = 0 then do:
         /* User not authorized for site */
         run cr_err_msg
            (input i_doc_seq,
             input i_proc_sess,
             input 2328,
             input 4,
             input msg1 + si_site).
         return_code = 3.
         leave mainloop.
      end.
   end. /* AVAILABLE SI_MSTR */

   if locked(prhhist) then do:
      /* Record locked by another user. Try later */
      run cr_err_msg
         (input i_doc_seq,
          input i_proc_sess,
          input 7422,
          input 4,
          input "").
      return_code = 3.
      leave mainloop.
   end.

   else do:

      assign
         l_valid_rcvr = yes
         proc_rec = true.  /*RESET PROCESS RECEIVER FLAG TO YES*/

      for each ed_vod_det no-lock:

         find first prhhist where
                    prhhist.prh_receiver = prh_hist.prh_receiver and
                    prhhist.prh_line = ed_vod_ln
         no-lock no-error.

         if not available prhhist then do:
            /* Invalid receiver */
            run cr_err_msg
               (input i_doc_seq,
                input i_proc_sess,
                input 2205,
                input 4,
                input "").
            return_code = 3.
            next.
         end.

         {gprunpdf.i "mcpl" "p"}

         loopc:

         /* PROCESS PENDING VOUCHERS */
         for each pvomstr where
                  pvomstr.pvo_lc_charge = "" and
                  pvomstr.pvo_internal_ref_type = {&TYPE_POReceiver} and
                  pvomstr.pvo_internal_ref = prh_hist.prh_receiver and
                  pvomstr.pvo_line = ed_vod_ln
         exclusive-lock break by pvomstr.pvo_internal_ref:

            for first prhhist where
                  prhhist.prh_receiver = prh_hist.prh_receiver  and
                  prhhist.prh_line = ed_vod_ln
            no-lock: end.

            if prhhist.prh_nbr = "" then do:
               /* Invalid receiver */
               run cr_err_msg
                  (input i_doc_seq,
                   input i_proc_sess,
                   input 2205,
                   input 4,
                   input "").
               return_code = 3.
               next loopc.
            end. /*INVALID PRH NBR*/

            else do:

               loopc1:
               do on error undo loopc1, retry loopc1:

                  assign
                     curr_amt         = 0
                     prhline_err_stat = false. /*INITIAL ERROR STAT FALSE*/

                  /*CHECK DATABASE*/
                  find pod_det where
                       pod_nbr  = prhhist.prh_nbr and
                       pod_line = prhhist.prh_line
                  no-lock no-error.

                  if available pod_det then do:
                     if pod_po_db <> global_db then do:
                        /* Order must be created in database for the site */
                        run cr_err_msg
                           (input i_doc_seq,
                            input i_proc_sess,
                            input 8182,
                            input 4,
                            input "").
                        return_code = 3.
                        {apnoers.i}
                     end.
                  end. /*AVAILABLE LINE ITEM*/

                  /* FIND MATCHING PO_MSTR */
                  find po_mstr where po_nbr = prhhist.prh_nbr
                  no-lock no-error.
                  if not available po_mstr then do:
                     if first-of(pvomstr.pvo_internal_ref) then do:
                        /* Purchase Order Number does not exist */
                        run cr_err_msg
                           (input i_doc_seq,
                            input i_proc_sess,
                            input 2330,
                            input 4,
                            input msg1 + prhhist.prh_nbr).
                        return_code = 3.
                     end.
                     {apnoers.i}
                  end. /*NOT AVAILABLE PO_MSTR*/

                  po_recid = recid(po_mstr).

                  /* CHECK ON LINE ITEM AVAILABILITY*/
                  /* NOTE: LINE ITEM WAS LOOKED FOR IN "CHECK DBASE"*/
                  /* THIS WAS PUT HERE SO MULTIPLE ERROR MESSAGES   */
                  /* WOULDN'T APPEAR IF THE PO WASN'T FOUND FIRST   */
                  if not available pod_det then do:
                     /* Purchase Order Line not found */
                     run cr_err_msg
                        (input i_doc_seq,
                         input i_proc_sess,
                         input 2329,
                         input 4,
                         input msg1 ).
                     return_code = 3.
                     {apnoers.i}
                  end. /*NOT AVAILABLE LINE ITEM*/

                  /* FIND PRE-EXISTING VOUCHER HISTORY */
                  /* ****  ONLY IF NOT CONSIGNED  **** */
                  if not pvomstr.pvo_consignment then do:
                     for first vph_hist
                        fields(vph_pvo_id vph_ref)
                        where
                        vph_ref = pvomstr.pvo_last_voucher and
                        vph_pvo_id = pvomstr.pvo_id and
                        vph_pvod_id_line = 0
                        no-lock:
                           /* VOUCHER ALREADY EXISTS FOR THIS */
                           /* RECEIVER AND PO LINE            */
                           {pxmsg.i &MSGNUM=2331 &ERRORLEVEL=4
                                    &MSGBUFFER=msg1}
                           run cr_err_msg
                              (input i_doc_seq,
                               input i_proc_sess,
                               input 2331,
                               input 4,
                               input msg1).
                           return_code = 3.
                           {apnoers.i}
                     end. /*FOR FIRST vph_hist*/
                  end.  /* NOT CONSIGNED */

                  run check_inv_database.

                  /*CHECK IF PACK SLIP REQUIRED*/
                  if apc_ers_ps_err = yes and prhhist.prh_ps_nbr = ""
                     and prhhist.prh_rcp_type <> "R"
                  then do:
                     /*PACKING SLIP REQUIRED*/
                     run cr_err_msg
                        (input i_doc_seq,
                         input i_proc_sess,
                         input 2344,
                         input 4,
                         input msg1).
                     assign
                        prhline_err_stat = true
                        return_code = 3.
                  end. /*PACK SLIP REQUIRED*/

                  /* IF THE TRANSACTION CURRENCY IS NOT BASE */
                  /* AND THE FIXED RATE FLAG IS NO, GET THE  */
                  /* CURRENT EXCHANGE RATE, ELSE USE THE PO  */
                  /* EXCHANGE RATE.                          */
                  if po_curr <> base_curr and not po_fix_rate
                  then do:
                     /* GET CURRENT EXCHANGE RATE, CREATE USAGE */
                     run p-get-rate.
                     assign
                        l_ex_ratetype = "".
                  end. /* IF po_curr <> base_curr ... */
                  else
                  assign
                     l_ex_rate     = po_ex_rate
                     l_ex_rate2    = po_ex_rate2
                     l_exru_seq    = po_exru_seq
                     l_ex_ratetype = po_ex_ratetype.

                  /*THIS INCLUDE RUNS ON THE FIRST RECEIVER RECORD*/
                  /*VALIDATION FOR SUPPLIER, GL EFF DATE, ACCTS, CC, ETC*/
                  if l_valid_rcvr then do:
                     assign
                        l_valid_rcvr = no.
                     {apersup1.i}
                  end. /* IF L_VALID_RCVR = YES*/

                  /*THIS INCLUDE VALIDATES DATES, PRICE AND CURRENCY*/
                  {edimivla.i}

                  /*BUILD TEMP FILE*/
                  if prhline_err_stat = true then do:
                     assign
                        proc_rec = no
                        pvomstr.pvo_ers_status = 1.

                     if last-of(pvomstr.pvo_internal_ref) then
                        leave loopc1.
                     else
                        next loopc.
                  end. /*ERRORS FOUND*/
                  else do:
                     create valid_prh.
                     run build_temp_table.

                     /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input prhhist.prh_curr,
                          input base_curr,
                          input pvomstr.pvo_ex_rate,
                          input pvomstr.pvo_ex_rate2,
                          input prhcurramt,
                          input false,
                          output unit_cost,
                          output mc-error-number)"}
                  end. /*BUILD TEMP FILE*/
               end. /*END LOOPC1*/

               if last-of(pvomstr.pvo_internal_ref) then do:
                  if not proc_rec then do:
                     run invalid_prh
                        (input recid(prhhist),
                         input i_doc_seq,
                         input i_proc_sess,
                         input-output return_code).

                     leave mainloop.
                  end. /*NOT PROC RECEIVER*/

                  if getref and ed_vo_vouch then do:
                     /*FIRST VOUCHER LOGIC: GET JOURNAL REF & BATCH ID*/

                     /*BATCH ID*/
                     assign
                        inbatch = ""
                        module = "AP"
                        doc_type = "VO"
                        bactrl = 0.

                     {gprun.i ""gpgetbat.p""
                        "(input inbatch,
                          input module,
                          input doc_type,
                          input bactrl,
                          output ba_recno,
                          output batch)"}

                     getref = false.
                  end. /*GETREF AND VOUCH*/

                  if ed_vo_vouch then do:
                     find first valid_prh no-lock no-error.
                     for each valid_prh
                           where prhreceiver = prhhist.prh_receiver
                     break by prhersopt:
                        if first-of (prhersopt) then do:

                           /*GET VOUCHER REFERENCE*/
                           if ed_vo_apref = "" then do:
                              {mfnctrl.i apc_ctrl apc_voucher vo_mstr
                                 vo_ref apref}
                              ed_vo_apref = apref.
                           end.
                           else
                              apref = ed_vo_apref.

                           loopd:
                           repeat:

                              redu = false.

                              for each bk_mstr where bk_code >= ""
                              no-lock:

                                 if bk_code = substring(apref,1,2)
                                 then do:

                                    /* A new voucher number must be found and
                                     * the first two digits cannot conflict with
                                     * a bank code.  Since mfnctrl.i only
                                     * increases the ref number by 1, the system
                                     * could be brought to a halt if the
                                     * apc_voucher number is six or more digits.
                                     * long.  Therefore, the first 2 digits will
                                     * be incremented by 1, then mfnctrl.i
                                     * will be run to find a useable number.
                                     */
                                    find first apc_ctrl exclusive-lock.
                                    if apc_voucher >= 99000000 then
                                       apc_voucher = 1.
                                    apc_voucher = integer(string(integer
                                       (substring(
                                       string(apc_voucher),1,2)) + 1)
                                       + substring(string(apc_voucher),3)).
                                    release apc_ctrl.
                                    {mfnctrl.i apc_ctrl apc_voucher vo_mstr
                                       vo_ref apref}
                                    redu = true.

                                 end. /*BANK CODE = APREF*/

                              end. /*FOR EACH BK_MSTR*/

                              /*VALIDATE Vchr REF DOESN'T EXIST FOR OTHER TYPES */
                              loopf:
                              repeat:
                                 find ap_mstr where ap_ref = apref
                                    and ap_type  = "RV"
                                 no-lock no-error.
                                 if available ap_mstr then do:
                                    find first apc_ctrl exclusive-lock.
                                    if apc_voucher >= 99000000 then
                                       apc_voucher = 1.
                                    apc_voucher = integer(string(integer(
                                       substring
                                       (string(apc_voucher),1,2)) + 1) +
                                       substring(string(apc_voucher),3)).
                                    release apc_ctrl.
                                    {mfnctrl.i apc_ctrl apc_voucher
                                       vo_mstr vo_ref apref}
                                    redu = true.
                                 end. /*MATCHING VOUCHER REF*/
                                 else do:
                                    redu = false.
                                    leave loopf.
                                 end.
                              end. /*LOOPF*/
                              if not redu then leave loopd.
                           end. /*LOOPD*/

                           find vd_mstr where recid(vd_mstr) = vd_recno
                           no-lock.
                           find po_mstr where recid(po_mstr) = po_recid
                           no-lock.

                           {gprun.i ""gldydft.p""
                              "(input ""AP"",
                                input ""VO"",
                                input apentity,
                                output dft-daybook,
                                output daybook-desc)"}

                           /*CREATE AP_MSTR*/
                           create ap_mstr.
                           run build_ap_mstr.

                           /* COPY EXCHANGE RATE USAGE */
                           {gprunp.i "mcpl" "p"
                              "mc-copy-ex-rate-usage"
                              "(input  l_exru_seq,
                                output ap_exru_seq)"}

                           /*CREATE VPO_DET*/
                           create vpo_det.
                           assign
                              vpo_po  = po_nbr
                              vpo_ref = ap_ref.

                           /*CALCULATE DISCOUNT AND DUE DATE*/
                           {&APERSUPA-P-TAG4}
                           assign
                              disc_date = ?
                              due_date  = ?.
                           {&APERSUPA-P-TAG5}
                           {&APERSUPA-P-TAG6}

                           /* CHECK WHETHER MULTIPLE DUE DATES   */
                           /* CREDIT TERMS                       */
                           for first ct_mstr
                           fields (ct_base_date ct_base_days ct_code
                                   ct_dating ct_disc_date ct_disc_days
                                   ct_disc_pct ct_due_date ct_due_days
                                   ct_due_inv ct_from_inv ct_min_days)
                              where ct_code = (if ed_vo_terms <> "" then
                                                  ed_vo_terms
                                               else
                                                  po_cr_terms)
                           no-lock: end.

                           if not available ct_mstr or ct_dating = no
                           then do:
                              termvar = if ed_vo_terms <> "" then
                                           ed_vo_terms
                                        else
                                           po_cr_terms.
                              {gprun.i ""adctrms.p""
                                 "(input  ap_date,
                                   input termvar,
                                   output disc_date,
                                   output due_date)"}
                           end. /* IF NOT AVAILABLE ct_mstr */
                           else do:
                              /* IF MULTIPLE DUE DATES CREDIT TERMS, */
                              /* CALCULATE DATES USING THE LAST      */
                              /* CREDIT TERMS RECORD                 */
                              for last ctd_det
                              fields (ctd_code ctd_date_cd)
                                 where ctd_code = (if ed_vo_terms <> "" then
                                                      ed_vo_terms
                                                   else po_cr_terms)
                              no-lock: end.
                              if available ctd_det then do:
                                 {gprun.i ""adctrms.p""
                                    "(input  ap_date,
                                      input  ctd_date_cd,
                                      output disc_date,
                                      output due_date)"}
                              end. /* IF AVAILABLE ctd_det */
                           end. /* IF AVAILABLE ct_mstr and ... */

                           /*CREATE VO_MSTR*/
                           create vo_mstr.
                           run build_vo_mstr.

                           /* CHANGED INPUT PARAMETER FROM */
                           /* po_exru_seq TO l_exru_seq    */
                           /* COPY EXCHANGE RATE USAGE */
                           {gprunp.i "mcpl" "p"
                              "mc-copy-ex-rate-usage"
                              "(input  l_exru_seq,
                                output vo_exru_seq)"}

                           assign
                              ap_recno = recid(ap_mstr)
                              vo_recno = recid(vo_mstr).

                           /* CHECK SUPPLIER BANK EXISTS AND POPULATE */
                           /* THE FIELD vo__qad02                     */
                           if ed_vo_sup_bank <> "" then
                              vo__qad02 = ed_vo_sup_bank.
                           else
                           for first csbd_det
                           fields (csbd_bank)
                              where csbd_addr = ap_vend
                                and csbd_beg_date <= ap_effdate
                                and csbd_end_date >= ap_effdate
                           no-lock:
                              assign
                                 vo__qad02 = csbd_bank.
                           end.

                           /* IF CHECK FORM IS 3 OR 4 AND NO SUPPLIER */
                           /* BANK EXISTS ISSUE WARNING MESSAGE       */
                           if vo__qad02 = " " and
                              (ap_ckfrm = "3" or ap_ckfrm = "4")
                           then do:
                              /*SUPPLIER BANK REQUIRED FOR CHECKFORM*/
                              run cr_err_msg
                                 (input i_doc_seq,
                                  input i_proc_sess,
                                  input 1841,
                                  input 2,
                                  input msg1 ).
                              return_code = 3.
                           end. /* IF vo__qad02 = " " */

                        end. /*FIRST-OF PRHERSOPT*/
                        else do:

                           find ap_mstr where recid(ap_mstr) = ap_recno
                           exclusive-lock.

                           find vo_mstr where recid(vo_mstr) = vo_recno
                           no-lock.

                        end. /*end else do*/

                        /*CREATE VPH HIST RECORDS*/
                        create vph_hist.
                        run build_vph_hist.
                        if recid(vph_hist) = -1 then .

                        run convert-and-round-proc.

                        /*ASSIGN AP REF NUMBER TO TEMP FILE RECORDS*/
                        prhref = vo_mstr.vo_ref.

                        run updatePendingVoucherQuantity
                           (input prhreceiver,
                            input prhline,
                            input prhconref,
                            input prhref,
                            input vph_inv_qty).

                        /* GET COSTING METHOD FROM INVTY DATABASE */
                        assign
                           old_db = global_db
                           new_site = prhsite.

                        {gprun.i ""gpalias.p""}

                        {gprun.i ""apersupb.p""
                           "(input prhpart,
                             input prhsite,
                             output glx_mthd,
                             output cur_mthd)"}

                        new_db = old_db.
                        {gprun.i ""gpaliasd.p""}

                        for first apc_ctrl
                        fields (apc_gl_avg_cst) no-lock:
                        end. /* FOR FIRST APC_CTRL ... */

                        if available apc_ctrl and
                           prhtype  = ""      and
                           glx_mthd = "avg"   and
                           vo_confirmed       and
                           apc_gl_avg_cst
                        then
                           vph_adj_inv = true.

                     end. /*FOR EACH VALID_PRH*/

                     /*SET OUTPUT TO NULL SO NOTHING IS DISPLAYED*/
                     if opsys = "unix" then
                     output to
                        "/dev/null".
                     else
                     if opsys = "msdos" or opsys = "win32"
                        then output to "nul".
                     else
                     if opsys = "vms"  then
                        output to "nl:".
                     else
                     if opsys = "btos" then
                        output  to "[nul]".

                     /*DEFINE SHARED FRAME FORMS FOR APVOMTI EVEN */
                     /*THOUGH THEY'RE NOT USED, THEY MUST BE DEFINED*/
                     {apvofmc.i}
                     {apvofmtx.i}

                     assign
                        vod_amt_fmt = vod_amt:format in frame tax_dist
                        ap_amt_fmt  = ap_amt:format in frame c.

                     find first apc_ctrl no-lock no-error.

                     /*CREATE VOD_DET LINES */
                     {gprun.i ""apvomta4.p"" "no-error"}

                     if error-status:error then do:
                        repeat x = 1 to error-status:num-messages:
                           /* Progress error has been encountered */
                           run cr_err_msg
                              (input i_doc_seq,
                               input i_proc_sess,
                               input 3575,
                               input 4,
                               input string(error-status:get-number(x))).
                           run cr_err_msg
                              (input i_doc_seq,
                               input i_proc_sess,
                               input 2685,
                               input 4,
                               input error-status:get-message(x) ).
                           return_code = 3.
                        end.
                     end.

                     /* ADDED TWO PARAMETERS TO TXCALC.P, INPUT PARAMETER    */
                     /* VQ-POST AND OUTPUT PARAMETER RESULT-STATUS. THE      */
                     /* POST FLAG IS SET TO 'NO' BECAUSE WE ARE NOT CREATING */
                     /* QUANTUM REGISTER */
                     /* RECORDS FROM THIS CALL TO TXCALC.P */
                     {gprun.i ""txcalc.p""
                        "(input  tax_tr_type,
                          input  vo_ref,
                          input  "" "",
                          input  0,
                          input no,
                          output result-status)"}
                     {gprun.i ""apvomti.p""}

                     output close.

                     {&APERSUPA-P-TAG9}
                     {gprun.i ""apvomtk.p"" "(1)"}
                     {&APERSUPA-P-TAG10}

                     /*ADD TAX*/
                     for each vod_det where
                              vod_det.vod_ref = vo_ref
                           and (vod_det.vod_tax <> ""
                           and vod_det.vod_tax <> "n"
                           and vod_det.vod_tax <> "no"
                           and vod_det.vod_tax <> "t")
                     no-lock:
                        ap_amt = ap_amt + vod_det.vod_amt.
                        ap_base_amt = ap_base_amt + vod_det.vod_base_amt.
                     end.
                     {&APERSUPA-P-TAG11}

                     /* UPDATE ba_mstr */
                     find ba_mstr where
                          ba_module = "AP"
                      and ba_batch  = batch
                     exclusive-lock no-error.
                     if available ba_mstr then
                     assign
                        ba_ctrl  = ba_ctrl  + ap_amt
                        ba_total = ba_total + ap_amt.

                     /*ADJUST VENDOR BALANCE*/
                     if vo_confirmed then do:
                        find vd_mstr where recid(vd_mstr) = vd_recno
                        exclusive-lock no-error.
                        vd_balance = vd_balance + ap_amt.
                     end.

                  end. /*IF CREATE VOUCH*/

               end. /*LAST OF  RECEIVER*/

            end. /*ELSE DO PROCESS RECEIVER*/

         end. /*FOR EACH PRHHIST*/

      end. /*FOR EACH ED_VOD_DET*/

   end. /*IF NOT LOCKED*/

end. /*MAINLOOP*/

run check_update_batch
   (input batch,
    input i_doc_seq,
    input i_proc_sess,
    input-output return_code).

{&APERSUPA-P-TAG7}

PROCEDURE convert-and-round-proc:

   /* CONVERT FROM FOREIGN  TO BASE CURRENCY */
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input valid_prh.prhcurr,
        input base_curr,
        input prhexrate,
        input prhexrate2,
        input prhcurramt,
        input false, /* DO NOT ROUND */
        output vph_hist.vph_inv_cost,
        output mc-error-number)"}

   /*ASSIGN AP_MSTR FIELD THAT RELYS ON VPH FIELDS*/
   /* GET AP CURRENCY ROUNDING METHOD */
   {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
      "(input ap_mstr.ap_curr,
        output rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      run cr_err_msg
         (input i_doc_seq,
          input i_proc_sess,
          input mc-error-number,
          input 2,
          input "").
   end.

   work_amt = vph_inv_qty * vph_curr_amt.

   /* ROUND THE AMOUNT */
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output work_amt,
        input rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      run cr_err_msg
         (input i_doc_seq,
          input i_proc_sess,
          input mc-error-number,
          input 2,
          input "").
   end.

   ap_amt = ap_amt + work_amt.

   /* CONVERT FROM FOREIGN TO BASE CURRENCY */
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input ap_curr,
        input base_curr,
        input ap_ex_rate,
        input ap_ex_rate2,
        input work_amt,
        input true,
        output work_amt,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      run cr_err_msg
         (input i_doc_seq,
          input i_proc_sess,
          input mc-error-number,
          input 2,
          input "").
      return_code = 3.
   end.

   ap_base_amt = ap_base_amt + work_amt.

END PROCEDURE.

PROCEDURE check_update_batch:

   define input parameter i_batch like batch no-undo.
   define input parameter ii_doc_seq like i_doc_seq no-undo.
   define input parameter ii_proc_sess like i_proc_sess no-undo.
   define input-output parameter io_return_code like return_code no-undo.

   /* CHECK & UPDATE BATCH STATUS */
   do transaction:

      find ba_mstr where ba_batch = i_batch and ba_module = "AP"
      exclusive-lock no-error.

      if available ba_mstr then do:

         if can-find(first ap_mstr where ap_batch = ba_batch)
         then do:
            if ba_ctrl <> ba_total then do:
               ba_status = "UB".       /* UNBALANCED */
               if ba_ctrl <> 0 then do:
                  /* Batch control total does not equal total */
                  run cr_err_msg
                     (input ii_doc_seq,
                      input ii_proc_sess,
                      input 1151,
                      input 2,
                      input "").
                  io_return_code = 3.
               end.
            end.
            else
               ba_status = "".         /* OPEN & BALANCED */
         end.  /* if can-find */

         else do:  /* EMPTY BATCH */
            ba_status = "NU".           /* NOT USED */
            ba_ctrl = 0.                /* RESET CONTROL VALUE */
         end.

         release ba_mstr.

      end. /* if available */

   end. /* transaction */

END PROCEDURE.

PROCEDURE p-get-rate:

   {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
      "(input po_mstr.po_curr,
        input base_curr,
        input po_mstr.po_ex_ratetype,
        input today,
        output l_ex_rate,
        output l_ex_rate2,
        output l_exru_seq,
        output mc-error-number)"}

   if mc-error-number <> 0 then do:
      /* EXCHANGE RATE NOT FOUND */
      run cr_err_msg
         (input i_doc_seq,
          input i_proc_sess,
          input mc-error-number,
          input 4,
          input msg1 ).
      return_code = 3.
      assign
         prhline_err_stat = true.
   end. /* IF mc-error-number  */

END PROCEDURE.

PROCEDURE invalid_prh:

   define input        parameter i_prh_recid    as   recid         no-undo.
   define input        parameter ii_doc_seq     like i_doc_seq     no-undo.
   define input        parameter ii_proc_sess   like i_proc_sess   no-undo.
   define input-output parameter io_return_code like return_code   no-undo.

   define buffer prhhist_buf for prh_hist.

   find prhhist_buf where recid(prhhist_buf) = i_prh_recid
   no-lock no-error.

   for each valid_prh where prhreceiver = prhhist_buf.prh_receiver
   exclusive-lock:
      delete valid_prh.
   end.

   /* No invoices/memos selected for processing */
   run cr_err_msg
      (input ii_doc_seq,
       input ii_proc_sess,
       input 1179,
       input 4,
       input "").

   io_return_code = 3.

END PROCEDURE.

PROCEDURE check_inv_database:
   define variable msg_indx as integer.

   /* CHECK IF INVENTORY DATABASE CONNECTED */
   if global_db <> "" then do:

      for first si_mstr
      fields(si_db)
         where si_site = pod_det.pod_site
      no-lock:

         if not connected(si_db) then do:
            /* DATABASE # NOT AVAILABLE */
            msg_indx = index(msg1,"#").
            if msg_indx <> 0 then
            msg1 = substring(msg1, 1, msg_indx - 1) + si_db +
                   substring(msg1, msg_indx + 1).
            run cr_err_msg
               (input i_doc_seq,
                input i_proc_sess,
                input 2510,
                input 4,
                input msg1).
            assign
               prhline_err_stat = true
               return_code = 3.
         end.

      end.

   end.

END PROCEDURE.

PROCEDURE build_temp_table:

   assign
      valid_prh.prhreceiver = prhhist.prh_receiver
      prhpart     = prhhist.prh_part
      prhsite     = prhhist.prh_site
      prhline     = prhhist.prh_line
      prhcurramt  = if ed_vod_det.ed_vod_amt <> 0 then
                       ed_vod_amt
                    else
                       curr_amt
      prhexrate   = pvomstr.pvo_ex_rate
      prhexrate2  = pvomstr.pvo_ex_rate2
      prhcurr     = prhhist.prh_curr
      prhrcvd     = prhhist.prh_rcvd
      prhinvqty   = if ed_vod_qty_inv <> 0 then
                       ed_vod_qty_inv
                    else
                       pvomstr.pvo_vouchered_qty
      prhnbr      = prhhist.prh_nbr
      prhacct     = pvomstr.pvo_accrual_acct
      prhsub      = pvomstr.pvo_accrual_sub
      prhcc       = pvomstr.pvo_accrual_cc
      prhelement  = prhhist.prh_element
      prhlstprice = list_price
      prhrecid    = recid(prhhist)
      prhcalcqty  = if ed_vod_qty_inv <> 0 then
                       ed_vod_qty_inv
                    else
                       prhhist.prh_rcvd - pvomstr.pvo_vouchered_qty
      prhtype     = prhhist.prh_type
      ext_cur_amt = prhcalcqty * prhcurramt
      prhconref   = pvomstr.pvo_external_ref
      prhproject  = pvomstr.pvo_project
                        .
END PROCEDURE.

PROCEDURE build_ap_mstr:

   assign
      ap_mstr.ap_acct  = if ed_vo_ap_acct <> ""
                         then
                            ed_vo_ap_acct
                         else
                            po_mstr.po_ap_acct
      ap_sub           = if ed_vo_ap_sub <> ""
                         then
                            ed_vo_ap_sub
                         else
                            po_mstr.po_ap_sub
      ap_bank          = if ed_vo_bank <> ""
                         then
                            ed_vo_bank
                         else
                            vd_mstr.vd_bank
      ap_batch         = batch
      ap_cc            = if ed_vo_ap_cc <> ""
                         then
                            ed_vo_ap_cc
                         else
                            po_ap_cc
      ap_ckfrm         = if ed_vo_ckfrm <> ""
                         then
                            ed_vo_ckfrm
                         else
                            vd_ckfrm
      ap_curr          = if ed_vo_curr <> ""
                         then
                            ed_vo_curr
                         else
                            po_curr
      ap_date          = if ed_vo_vouch_date <> ?
                         then
                            ed_vo_vouch_date
                         else
                            voucher_date
      ap_disc_acct     = if ed_vo_disc_acct <> ""
                         then
                            ed_vo_disc_acct
                         else
                            gl_ctrl.gl_apds_acct
      ap_disc_sub      = if ed_vo_disc_sub <> ""
                         then
                            ed_vo_disc_sub
                         else
                            gl_ctrl.gl_apds_sub
      ap_disc_cc       = if ed_vo_disc_cc <> ""
                         then
                            ed_vo_disc_cc
                         else
                            gl_apds_cc
      ap_effdate       = if ed_vo_eff_date <> ?
                         then
                            ed_vo_eff_date
                         else
                            today
      ap_entity        = if ed_vo_entity <> ""
                         then
                            ed_vo_entity
                         else
                            apentity
      ap_rmk           = ed_vo_remarks
      ap_ex_rate       = l_ex_rate
      ap_ex_rate2      = l_ex_rate2
      ap_ex_ratetype   = l_ex_ratetype
      ap_open          = yes
      ap_ref           = apref
      ap_type          = "VO"
      ap_vend          = po_vend
      ap_dy_code       = dft-daybook.

END PROCEDURE.

PROCEDURE build_vo_mstr:

   assign
      vo_mstr.vo_confirmed  = (if ed_vo_confirmed
                           then yes else no)
      vo_conf_by    = (if vo_confirmed then
                       "EDI" else "")
      vo_cr_terms   = if ed_vo_terms <> ""
                      then ed_vo_terms
                      else po_mstr.po_cr_terms
      vo_curr       = if ed_vo_curr <> ""
                      then ed_vo_curr
                      else po_curr
      vo_disc_date  = if ed_vo_disc_date
                      <> ? then
                      ed_vo_disc_date
                      else disc_date
      vo_due_date   = if ed_vo_due_date <>
                      ? then
                      ed_vo_due_date
                      else due_date
      vo_ex_rate    = l_ex_rate
      vo_ex_rate2   = l_ex_rate2
      vo_ex_ratetype = l_ex_ratetype
      vo_hold       = if ed_vo_hold then
                      yes else no
      vo_hold_amt = if ed_vo_hold_amt <>
                      0 then ed_vo_hold_amt
                      else 0
      vo_base_hold_amt = vo_hold_amt
      vo_invoice    = (if prhhist.prh_ps_nbr
                       <> "" then
                       prhhist.prh_ps_nbr else
                       prhhist.prh_receiver)
      vo_modok      = yes
      vo_po_rcvd    = yes
      vo_receiver   = prhhist.prh_receiver
      vo_ref        = ap_mstr.ap_ref
      vo_ship       = po_ship
      vo_tax_date   = (if po_tax_date <> ?
                      then po_tax_date else ap_effdate)
      vo_po         = prhhist.prh_nbr
      vo_taxable    = po_taxable
      vo_taxc       = po_taxc
      vo_tax_usage  = po_tax_usage
      vo_tax_env    = po_tax_env
      vo_tax_pct[1] = po_tax_pct[1]
      vo_tax_pct[2] = po_tax_pct[2]
      vo_tax_pct[3] = po_tax_pct[3]
      vo_type       = "VO".

   {&APERSUPA-P-TAG8}

END PROCEDURE.

PROCEDURE build_vph_hist:

   define buffer pvomstr2 for pvo_mstr.

   for first pvomstr2
       field (pvo_id)
       where pvomstr2.pvo_lc_charge = ""
         and pvomstr2.pvo_internal_ref_type = {&TYPE_POReceiver}
         and pvomstr2.pvo_internal_ref = valid_prh.prhreceiver
         and pvomstr2.pvo_line = prhline
         and pvomstr2.pvo_external_ref = prhconref
         no-lock: end.

   assign
      vph_hist.vph_acct = valid_prh.prhacct
      vph_cc            = prhcc
      vph_curr_amt      = prhcurramt
      vph_element       = prhelement
      vph_inv_date      = ap_mstr.ap_effdate
      vph_inv_qty       = if ed_vod_det.ed_vod_qty_inv <> 0
                          then ed_vod_qty_inv
                          else prhrcvd - prhinvqty
      vph_nbr           = prhnbr
      vph_pvo_id        = pvomstr2.pvo_id
      vph_pvod_id_line  = 0
      vph_ref           = vo_mstr.vo_ref
      vph_project       = prhproject
      vph_sub           = prhsub.

END PROCEDURE.


/*------------------------------------------------------------------*/
procedure updatePendingVoucherQuantity:
/*------------------------------------------------------------------*/
/* Purpose: This procedure updates the vouchered quantity in the    */
/*          pending voucher records.                                */
/*------------------------------------------------------------------*/
   define input  parameter ip_receiver  as character no-undo.
   define input  parameter ip_line      as integer no-undo.
   define input  parameter ip_ext_ref   as character no-undo.
   define input  parameter ip_vo        as character no-undo.
   define input  parameter ip_vouchered_qty   as decimal no-undo.

   define variable work_vouchered_qty as decimal no-undo.

   work_vouchered_qty = ip_vouchered_qty.

   for each pmstr
       where pmstr.pvo_lc_charge         = ""
         and pmstr.pvo_internal_ref_type = {&TYPE_POReceiver}
         and pmstr.pvo_internal_ref      = ip_receiver
         and pmstr.pvo_line              = ip_line
         and pmstr.pvo_external_ref      = ip_ext_ref
         and (pmstr.pvo_trans_qty - pmstr.pvo_vouchered_qty) <> 0
    exclusive-lock:

         assign
            pmstr.pvo_last_voucher = ip_vo.

         /* UPDATE ALL THE PENDING VOUCHER RECORDS BY           */
         /* READING EACH ONE, ADDING TO THE VOUCHERED QTY.      */
         /* THE WORK IS DONE WHEN THE "for each" IS COMPLETE    */
         /* OR THE WORKING VOUCHER QUANTITY = 0.                */

         if work_vouchered_qty >=
            (pmstr.pvo_trans_qty - pmstr.pvo_vouchered_qty) then

            /* TOTAL INVOICE QTY > PENDING QTY */
            assign
               work_vouchered_qty = work_vouchered_qty -
                                   (pmstr.pvo_trans_qty -
                                    pmstr.pvo_vouchered_qty)
               pmstr.pvo_vouchered_qty = pmstr.pvo_trans_qty.
         else

            /* TOTAL INVOICE QTY < PENDING QTY */
            assign
               pmstr.pvo_vouchered_qty = pmstr.pvo_vouchered_qty +
                                         work_vouchered_qty
               work_vouchered_qty = 0.

         if work_vouchered_qty = 0 then
         leave.

    end.  /* for each pmstr */
END PROCEDURE.  /* updatePendingVoucherQuantity */
