/* giapimpd.p - DISTRIBUTED SITE INTER-PLANT REQUISITION UPDATE         */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 9.0         CREATED: 08/13/98     BY: *M004* Jim Williams  */
/* REVISION: 9.0   LAST MODIFIED: 03/13/99     BY: *M0BD* Alfred Tan    */
/* REVISION: 9.1   LAST MODIFIED: 09/02/99     BY: *N025* evan bishop   */
/* REVISION: 9.1   LAST MODIFIED: 10/01/99     BY: *N014* Murali Ayyagari */
/* REVISION: 9.1   LAST MODIFIED: 08/14/00     BY: *N0L1* Mark Brown      */
/* REVISION: 9.1   LAST MODIFIED: 11/06/00     BY: *N0TN* Jean Miller     */

         {mfdeclre.i}
/*N0TN*/ {gplabel.i}

/* ********** Begin Translatable Strings Definitions ********* */

/*N0TN* &SCOPED-DEFINE giapimpd_p_1 "Intersite Order"  */
/* MaxLen: Comment: */

&SCOPED-DEFINE giapimpd_p_2 "Comments"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         define input parameter iReqNbr like dsr_req_nbr no-undo.
         define input parameter iSite like dsr_site no-undo.
         define input parameter iShipSite like dsd_shipsite no-undo.
         define input parameter iQtyOpen like dsr_qty_req no-undo.
         define input parameter iDueDate like dsr_due_date no-undo.
/*N025*/ define input parameter iDueDateNoLoad as date no-undo.
         define input parameter iCancelOrd as integer no-undo.

         {inmrp1.i}

         define new shared variable dsd_recno as recid.
         define new shared variable dsd_db like dc_name.
         define new shared variable ds_db like dc_name.
         define new shared variable undo-all like mfc_logical.
         define new shared variable del-yn like mfc_logical initial no.
         define new shared variable cmtindx like dsr_cmtindx.
         define new shared variable req_nbr like dsr_req_nbr.
         define new shared variable dsrcmmts like woc_wcmmts
                         label {&giapimpd_p_2}.
         define new shared variable dsdcmmts like woc_wcmmts
                         label {&giapimpd_p_2}.
         define new shared variable undomain as logical.
         define new shared variable undomainretry as logical.

         define variable dsr-recid as recid no-undo.
         define variable i as integer no-undo.
         define variable yn like mfc_logical initial no no-undo.
         define variable eff_date like glt_effdate initial today no-undo.
         define variable leadtime like pt_mfg_lead no-undo.
         define variable open_qty like mrp_qty no-undo.
         define variable network like ssd_network no-undo.
         define variable prevstatus like dsr_status no-undo.
         define variable prev_dsd_status like dsd_status no-undo.
         define variable curr_dsd_status like dsd_status no-undo.
         define variable prev_dsd_qty like dsd_qty_conf no-undo.
         define variable git_acct like si_git_acct no-undo.
/*N014*/ define variable git_sub like si_git_sub no-undo.
         define variable git_cc like si_git_cc no-undo.
         define variable mrptype like mrp_type no-undo.
         define variable prev_qty_ord like dsd_qty_ord no-undo.

         {mfdatev.i}

         mainloop:
         do on error undo, retry:

            do transaction:

               /* ADD/MOD/DELETE */
               find dsr_mstr use-index dsr_req_nbr
               where dsr_req_nbr = iReqNbr
               and dsr_site = iSite no-error.
               if available dsr_mstr then req_nbr = dsr_req_nbr.
               else do:
                  if iReqNbr > "" then req_nbr = iReqNbr.
                  else do:
                     find first drp_ctrl no-lock no-error.
                     if available drp_ctrl then do:
                        if not drp_auto_req then undo mainloop, retry mainloop.
                        {mfnctrl.i drp_ctrl drp_req_nbr dsr_mstr
                         dsr_req_nbr req_nbr}
                     end.
                  end.

                  if req_nbr = "" then undo, retry.
               end.
            end. /* transaction */

            do transaction:
               find dsr_mstr
               exclusive-lock
               use-index dsr_req_nbr
               where dsr_req_nbr = iReqNbr
               and dsr_site = iSite no-error.

               if not available dsr_mstr then do:

                  undo, return error.

               end.
               else do:
                  if dsr_cmtindx <> 0 then dsrcmmts = true.
                  else dsrcmmts = false.
               end.

               assign
                  recno = recid(pt_mstr)
                  dsr-recid = recid(dsr_mstr)
                  prevstatus = dsr_status.

               del-yn = no.

               /* SET GLOBAL ITEM AND SITE VARIABLES */
               assign
                  global_part = dsr_part
                  global_site = dsr_site.

               find first dsd_det no-lock
               where dsd_req_nbr = dsr_req_nbr
               and dsd_site = dsr_site no-error.

               if available dsd_det then do:

                  if dsd_cmtindx = 0 then dsdcmmts = no. else dsdcmmts = yes.

               end.

               find pt_mstr no-lock where pt_part = dsr_part no-error.

               assign
                 network = pt_network
                 dsr_part = pt_part.

               find ptp_det no-lock where ptp_part = dsr_part
               and ptp_site = dsr_site no-error.
               if available ptp_det then network = ptp_network.

               do on error undo, retry:

                  del-yn = no.

                  /* DELETE */
                  if iCancelOrd = 1 then do:

                     del-yn = yes.
                     find first dsd_det where dsd_req_nbr = dsr_req_nbr
                     and dsd_site = dsr_site and dsd_nbr <> ""
                     no-lock no-error.
                     if available dsd_det then do:
                        /* DELETE NOT ALLOWED, REQUISITION ATTACHED TO D/O */
                        undo, return error.
                     end.
                     /* DELETE INTER-SITE REQUISITION */
                     for each dsd_det where dsd_req_nbr = dsr_req_nbr
                     and dsd_site = dsr_site:
                        assign
                        dsd_recno = recid(dsd_det)
                           dsd_db = global_db
                         undo-all = true.
                        {gprun.i ""dsdmmtu1.p""}
                        if undo-all then undo, retry.

                        for each cmt_det exclusive-lock
                        where cmt_indx = dsd_cmtindx:
                           delete cmt_det.
                        end.

                        {mfmrwdel.i "dsd_det" dsd_part dsd_req_nbr
                         dsd_site dsd_shipsite }

                        run inmrp (input dsd_part, input dsd_site).

                        prev_dsd_status = dsd_status.
                        if dsd_qty_ord >= 0 then
                        prev_dsd_qty = max(dsd_qty_conf -
                                       max(dsd_qty_rcvd,0),0).
                        else prev_dsd_qty = min(dsd_qty_conf -
                                            min(dsd_qty_rcvd,0),0).

                        {gprun.i ""dsinup.p"" "(
                             input prev_dsd_status,
                             input prev_dsd_qty,
                             input ""C"",
                             input 0,
                             input dsd_part,
                             input dsd_site)"}

                        delete dsd_det.
                     end.

                     for each cmt_det exclusive-lock
                     where cmt_indx = dsr_cmtindx:
                        delete cmt_det.
                     end.

                     delete dsr_mstr.

                     del-yn = no.
                     leave mainloop.
                  end.  /* end DELETE  */

                  if not del-yn then do:

                     if not can-do("P,F,E,A,R,C,B",dsr_status) then do:
                        /*    Invalid Status  */
                        undo, return error.
                     end.

                     if dsr_ord_date = ? then dsr_ord_date = today.
                     if dsr_due_date = ? then dsr_due_date = today.

/*N025*/             if dsr_status <> "P":U then
/*N025*/                dsr_due_date = iDueDate.
                  end.
               end.
            end.

            do transaction:

               assign git_acct = ""
/*N014*/                git_sub = ""
                        git_cc = "".

               if git_acct = "" then do:
                  find pld_det no-lock where pld_prodline = pt_prod_line
                  and pld_site = dsr_site and pld_loc = "" no-error.
                  if available pld_det and pld_inv_acct <> "" then
                  assign git_acct = pld_inv_acct
/*N014*/                   git_sub = pld_inv_sub
                           git_cc = pld_inv_cc.
                  else do:
                     find pl_mstr no-lock where pl_prod_line = pt_prod_line
                     no-error.
                     if available pl_mstr and pl_inv_acct <> "" then
                     assign git_acct = pl_inv_acct
/*N014*/                      git_sub = pl_inv_sub
                              git_cc = pl_inv_cc.
                     else do:
                        find first gl_ctrl no-lock no-error.
                        if available gl_ctrl then
                        assign git_acct = gl_inv_acct
/*N014*/                         git_sub = gl_inv_sub
                                 git_cc = gl_inv_cc.
                     end.
                  end.
               end.

               if index("PF",prevstatus) <> 0
               or index("PF",dsr_status) <> 0 then do:
/*N014*/          /* ADDED GIT_SUB PARAMETER BELOW */
                  {gprun.i ""dsdmmta.p""
                           "(dsr-recid,network,git_acct,git_sub,git_cc)" }
               end.
/*N025*
      *       /* IF SUPPLIER PERFORMANCE IS INSTALLED CALL A SEAPRATE PROGRAM TO
      *   POP-UP SUPPLIER PERFORMANCE WINDOW TO GATHER PERFORMANCE DATE
      *   AND SUBCONTRACT TYPE */
      *
      *     /* DETERMINE IF SUPPLIER PERFORMANCE IS INSTALLED */
      *       if can-find (mfc_ctrl where
      *          mfc_field = "enable_supplier_perf" and mfc_logical) and
      *           can-find (_File where _File-name = "vef_ctrl") then do:
      *             {gprunmo.i
      *              &program=""dsdmve.p""
      *              &module="ASP"
      *              &param="""(input recid(dsr_mstr))"""}
      *       end.  /* if enable supplier performance */
**N025*/
/*N025*/       /* Call an internal procedure to update supplier performance
                  data if supplier performance is active */

/*N025*/       if can-find (first mfc_ctrl where
/*N025*/       mfc_field = "enable_supplier_perf") then do:
/*N025*/          run update-supplier-performance in THIS-PROCEDURE
/*N025*/          (INPUT dsr_req_nbr,INPUT dsr_site,INPUT dsr_due_date).
/*N025*/       end.

               find first dsd_det no-lock
               where dsd_req_nbr = dsr_req_nbr
               and dsd_site = dsr_site no-error.

               if available dsd_det then do:

                  if dsd_cmtindx = 0 then dsdcmmts = no. else dsdcmmts = yes.

               end.
            end.

            do on error undo, retry:

               find dsd_det exclusive-lock where dsd_req_nbr = dsr_req_nbr
                  and dsd_site = dsr_site
                  and dsd_shipsite = iShipSite
                  no-error.

               if not available dsd_det then do:

                  undo, return error.

               end.
               else do:
                  dsdcmmts = if dsd_cmtindx = 0 then false else true.
                  prev_dsd_status = dsd_status.
                  if dsd_qty_ord >= 0
                  then prev_dsd_qty =
                       max(dsd_qty_conf - max(dsd_qty_rcvd,0),0).
                  else prev_dsd_qty =
                       min(dsd_qty_conf - min(dsd_qty_rcvd,0),0).

                  find pt_mstr where pt_part = dsd_part no-lock no-error.
                  if available pt_mstr then
                     find first pld_det where pld_prodline = pt_prod_line
                                          and pld_site = dsd_site
                                          and pld_loc = dsd_trans_id
                        no-lock no-error.
                        if not available pld_det then do:
                            find pl_mstr  where pl_prod_line = pt_prod_line
                            no-lock no-error.
                            if available pl_mstr then do:
/*N014*/                      assign
                               git_acct = pl_inv_acct
/*N014*/                       git_sub  = pl_inv_sub
                               git_cc   = pl_inv_cc.
                            end.
                  end.
                  else do:
/*N014*/           assign
                    git_acct = pld_inv_acct
/*N014*/            git_sub =  pld_inv_sub
                    git_cc   = pld_inv_cc.
                  end.
               end.

               do on error undo, retry:

                  if iCancelOrd <> 1 then do:

                     if iQtyOpen <>
                        max(0,dsd_qty_ord - max(0,dsd_qty_rcvd))
                     then do:

                        prev_qty_ord = dsd_qty_ord.
                        dsd_qty_ord = iQtyOpen + max(0,dsd_qty_rcvd).
                        dsr_qty_req = dsr_qty_req +
                          (dsd_qty_ord - prev_qty_ord).

                     end.

/*N025*              if iDueDate <> dsd_due_date then dsd_due_date = iDueDate.*/
/*N025*/             if iDueDate <> dsd_due_date then dsd_due_date = iDueDateNoLoad.

                  end.

                  if iCancelOrd = 1 then do:

                     del-yn = yes.

                     if dsd_nbr <> "" then do:
                        /* DELETE NOT ALLOWED, REQUISITION ATTACHED TO D/O */
                        undo, return error.
                     end.

                     assign
                        dsd_recno = recid(dsd_det)
                           dsd_db = global_db
                         undo-all = true.

                     {gprun.i ""dsdmmtu1.p""}

                     if undo-all then undo.

                     {mfmrwdel.i "dsd_det" dsd_part dsd_req_nbr
                       dsd_site dsd_shipsite }

                     {gprun.i ""dsinup.p"" "(
                          input prev_dsd_status,
                          input prev_dsd_qty,
                          input ""C"",
                          input 0,
                          input dsd_part,
                          input dsd_site)"}

                     for each cmt_det exclusive-lock
                     where cmt_indx = dsd_cmtindx:
                        delete cmt_det.
                     end.

                     {inmrp.i &part=dsd_part &site=dsd_site}

                     delete dsd_det.
                     del-yn = no.
                  end.
                  else do:

                     if index ("PFE",dsd_status) <> 0 then
                        dsd_qty_conf = dsd_qty_ord.

                     if dsd_status = "P" or dsd_status = "F"
                     or new (dsd_det)
                     then do:

                        /* calculate arrival date at destination */
                        /* (dsd_due_date @ dsd_site) */
                        {gprun.i ""dsdate01.p""
                         "(dsd_shipsite,dsd_site,dsd_trans_id,dsr_due_date,
                          input-output dsd_due_date)"}

                        /* calculate necessary shipment date from source */
                        /* (dsd_shipdate @ dsd_shipsite) */
                        {gprun.i ""dsdate02.p""
                        "(dsd_shipsite,dsd_site,dsd_trans_id,
                         network,dsd_due_date,
                         input-output dsd_shipdate)"}

                     end.

                     if dsd_updated then do:
                        if dsd_qty_ord >= 0 then
                           open_qty = max(dsd_qty_conf - max(dsd_qty_rcvd,0),0).
                        else
                           open_qty = min(dsd_qty_conf - min(dsd_qty_rcvd,0),0).
                     end.
                     else do:
                        if dsd_qty_ord >= 0 then
                           open_qty = max(dsd_qty_ord - max(dsd_qty_rcvd,0),0).
                        else
                           open_qty = min(dsd_qty_ord - min(dsd_qty_rcvd,0),0).
                     end.

                     if can-do ("B,P,F",dsr_status) then do:
                        dsr_status = "E".
                     end.
                     if can-do("P,F",dsd_status) then do:
                        dsd_status = "E".
                     end.

                     if dsd_status = "C" then open_qty = 0.

                     mrptype = "SUPPLY":U.
                     if index("FE",dsd_status) <> 0 then mrptype = "SUPPLYF":U.
                     if index("P",dsd_status) <> 0 then mrptype = "SUPPLYP":U.

/*N0TN*/             /* Changed preprocessor to Term */
                     {mfmrwnew.i "dsd_det" dsd_part dsd_req_nbr dsd_site
                      dsd_shipsite dsd_shipdate dsd_due_date open_qty mrptype
                      INTERSITE_ORDER dsd_site}

                     if dsr_status = "C" then curr_dsd_status = "C".
                     else curr_dsd_status = dsd_status.
                     {gprun.i ""dsinup.p"" "(
                          input prev_dsd_status,
                          input prev_dsd_qty,
                          input curr_dsd_status,
                          input open_qty,
                          input dsd_part,
                          input dsd_site)"}

                     /* CREATE ds_det RECORD FOR DEMAND ON SHIPPING SITE */
                     assign
                        dsd_recno = recid(dsd_det)
                           dsd_db = global_db
                         undo-all = true.

                     {gprun.i ""dsdmmtu1.p""}
                     if undo-all then undo.

                  end.
               end.

               if dsr_status = "C" then do:
                 if available dsd_det then dsd_status =  dsr_status.
                 find next ds_det where ds_req_nbr = dsr_req_nbr no-error.
                 if available ds_det then ds_status = dsr_status.
               end.
            end.
         end.

/*N025*/ PROCEDURE update-supplier-performance:
         /* from dsdmve.p - Supplier Performance Intersite Request Pop-up */

         define input parameter req-nbr as character no-undo.
         define input parameter site as character no-undo.
         define input parameter due-date as date no-undo.

         for first mfc_ctrl no-lock
         where mfc_field = "enable_supplier_perf"
         and mfc_module = "ADG"
         and mfc_logical = yes:

            /* FIND perf_date IN QAD_WKFL IF THERE */
            for first qad_wkfl exclusive-lock where qad_key1 = "dsr_mstr_ve"
            and qad_key2 = string(site,"x(8)") + string(req-nbr,"x(8)"):
               qad_datefld[1] = due-date.
            end.

            if not available (qad_wkfl) then do:
               create qad_wkfl.
               assign qad_key1 = "dsr_mstr_ve"
                      qad_key2 = string(site,"x(8)") + string(req-nbr,"x(8)")
                qad_datefld[1] = due-date.

               if recid(qad_wkfl) = -1 then.
            end. /* if not available (qad_wkfl) */
         end.

/*N025*/ END PROCEDURE.
