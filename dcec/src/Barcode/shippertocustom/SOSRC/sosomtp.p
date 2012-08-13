/* GUI CONVERTED from sosomtp.p (converter v1.75) Sun Jan 28 20:25:36 2001 */
/* sosomtp.p - SALES ORDER MAINTENANCE UPDATE HEADER FRAME b            */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 7.3      LAST MODIFIED: 05/23/93   BY: afs *GB31*          */
/* REVISION: 7.4      LAST MODIFIED: 06/21/93   BY: pcd *H008*          */
/* REVISION: 7.4      LAST MODIFIED: 07/30/93   BY: cdt *H048*          */
/* REVISION: 7.4      LAST MODIFIED: 08/23/93   BY: cdt *H049*          */
/* REVISION: 7.4      LAST MODIFIED: 09/22/93   BY: cdt *H086*          */
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: cdt *H184*          */
/* REVISION: 7.4      LAST MODIFIED: 01/28/94   BY: afs *GI55*          */
/* REVISION: 7.4      LAST MODIFIED: 06/29/94   BY: qzl *H419*          */
/* REVISION: 7.4      LAST MODIFIED: 07/29/94   BY: bcm *H465*          */
/*                                   09/10/94   BY: bcm *GM05*          */
/* REVISION: 7.4      LAST MODIFIED: 09/22/94   BY: jpm *GM78*          */
/* REVISION: 7.4      LAST MODIFIED: 09/29/94   BY: bcm *H541*          */
/* REVISION: 8.5      LAST MODIFIED: 10/18/94   BY: mwd *J034*          */
/* REVISION: 7.4      LAST MODIFIED: 10/19/94   BY: ljm *GN40*          */
/* REVISION: 7.4      LAST MODIFIED: 10/21/94   BY: rmh *FQ08*          */
/* REVISION: 7.4      LAST MODIFIED: 10/31/94   BY: mmp *H582*          */
/* REVISION: 7.4      LAST MODIFIED: 11/08/94   BY: ljm *GO33*          */
/* REVISION: 7.4      LAST MODIFIED: 03/28/95   BY: kjm *F0PC*          */
/* REVISION: 7.4      LAST MODIFIED: 04/10/95   BY: yep *G0KL*          */
/* REVISION: 8.5      LAST MODIFIED: 04/12/95   BY: dpm *J044*          */
/* REVISION: 8.5      LAST MODIFIED: 03/05/95   BY: DAH *J042*          */
/* REVISION: 8.5      LAST MODIFIED: 10/27/95   BY: dpm *J08Y*          */
/* REVISION: 7.4      LAST MODIFIED: 06/15/95   BY: rxm *G0Q5*          */
/* REVISION: 7.4      LAST MODIFIED: 09/13/95   BY: ais *H0FW*          */
/* REVISION: 8.5      LAST MODIFIED: 07/12/95   BY: taf *J053*          */
/* REVISION: 8.5      LAST MODIFIED: 03/14/96   BY: GWM *J0FQ*          */
/* REVISION: 8.5      LAST MODIFIED: 04/11/96   BY: *J04C* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 05/03/96   BY: DAH *J0KJ*          */
/* REVISION: 8.5      LAST MODIFIED: 07/04/96   BY: DAH *J0XR*          */
/* REVISION: 8.5      LAST MODIFIED: 07/19/96   BY: taf *J0ZZ**/
/* REVISION: 8.5      LAST MODIFIED: 08/27/96   BY: *G2D5* Suresh Nayak */
/* REVISION: 8.5      LAST MODIFIED: 09/16/96   BY: *G2F0* Ajit Deodhar */
/* REVISION: 8.5      LAST MODIFIED: 10/17/96   BY: *G2H5* Ajit Deodhar */
/* REVISION: 8.5      LAST MODIFIED: 11/07/96   BY: *G2HR* Aruna Patil  */
/* REVISION: 8.6      LAST MODIFIED: 04/02/97   BY: *K09J* Arul Victoria */
/* REVISION: 8.6      LAST MODIFIED: 04/04/97   BY: *K09L* Kieu Nguyen   */
/* REVISION: 8.6      LAST MODIFIED: 06/30/97   BY: *K0FL* Taek-Soo Chang */
/* REVISION: 8.6      LAST MODIFIED: 07/01/97   BY: *J1TQ* Irine D'mello */
/* REVISION: 8.6      LAST MODIFIED: 07/07/97   BY: *K0DH* Arul Victoria */
/* REVISION: 8.6      LAST MODIFIED: 07/21/97   BY: *K0GS* Kieu Nguyen   */
/* REVISION: 8.6      LAST MODIFIED: 10/06/97   BY: *K0KJ* Joe Gawel     */
/* REVISION: 8.6      LAST MODIFIED: 10/21/97   BY: *J23V* Nirav Parikh  */
/* REVISION: 8.6      LAST MODIFIED: 11/18/97   BY: *J25B* Aruna Patil  */
/* REVISION: 8.6      LAST MODIFIED: 01/15/98   BY: *K1FK* Jim Williams */
/* REVISION: 8.6      LAST MODIFIED: 01/16/98   BY: *K1BN* Val Portugal    */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan    */
/* REVISION: 8.6E     LAST MODIFIED: 07/09/98   BY: *J2Q9* Niranjan R.   */
/* REVISION: 8.6E     LAST MODIFIED: 07/13/98   BY: *L024* Sami Kureishy */
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *M017* David Morris  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan      */
/* REVISION: 9.0      LAST MODIFIED: 01/25/01   BY: *M109* Kaustubh K.     */

         {mfdeclre.i}

         /* ********** Begin Translatable Strings Definitions ********* */

         &SCOPED-DEFINE sosomtp_p_1 "已确认"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosomtp_p_2 " 销售至 "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosomtp_p_3 "承诺日期"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosomtp_p_4 "说明"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosomtp_p_5 " 货物发往 "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosomtp_p_6 "计算运费"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosomtp_p_7 "显示重量"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosomtp_p_8 "到期日期"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosomtp_p_9 "预计"
         /* MaxLen: Comment: */

         /* ********** End Translatable Strings Definitions ********* */


/*K1FK*/ define input parameter this-is-rma as logical.

/*J053*/ define shared variable rndmthd like rnd_rnd_mthd.
/*J053*/ define shared variable oldcurr like so_curr.
         define shared variable so_recno as recid.
         define shared variable undo_flag like mfc_logical.

         define shared variable new_order like mfc_logical initial no.
         define shared variable rebook_lines as logical initial no no-undo.

 /*K1BN*/ /* where a sales order line has been configured with concinity we*/
/*K1BN*/ /* want to delete the associated file held in sod__qadc01.*/
/*K1BN*/ /* however, we cannot delete the concinity file until we know that*/
/*K1BN*/ /* the whole sales order could be deleted as the undo command will*/
/*K1BN*/ /* not undo any os-delete commands*/

/*K1BN*/ define new shared workfile cf_sod_rm
/*K1BN*/    field cf_ccq_name as character.
/*K1BN*/ define shared variable cfexists    like mfc_logical.
/*K1BN*/ define shared variable cf_chr        as character.
/*K1BN*/ define shared variable cf_cfg_path like mfc_char.
/*L024*/ define variable mc-error-number like msg_nbr no-undo.

         define shared frame a.
/*GN40*/ /*V8+*/
         define shared frame b.

         define     shared variable mult_slspsn   like mfc_logical no-undo.
         define     shared variable promise_date  as   date
                          label {&sosomtp_p_3}.
         define     shared variable confirm       like mfc_logical
                          label {&sosomtp_p_1}
                          format "Y/N" initial yes.
/*H086*/ /* define            variable alloc      like mfc_logical
                          label "Allocations". *H086*/
         define     shared variable socmmts       like soc_hcmmts
                          label {&sosomtp_p_4}.
         define     shared variable consume       like sod_consume.
         define     shared variable all_days      like soc_all_days.
         define     shared variable so-detail-all like soc_det_all.
         define     shared variable del-yn        like mfc_logical.

         define new shared variable old_slspsn    like so_slspsn   no-undo.
         define            variable counter       as   integer     no-undo.
         define     shared variable freight_ok    like mfc_logical.
         define new shared variable old_ft_type   like ft_type.
/*H048*/ /*define            variable calc_fr     like mfc_logical */
/*H048*/ define       shared variable calc_fr     like mfc_logical
/*H048*/                                          label {&sosomtp_p_6}.
         define            variable old_fr_terms  like so_fr_terms.
         define            variable old_um        like fr_um.
         define new shared variable merror        like mfc_logical initial no.
         define            buffer   somstr        for so_mstr.
         define            variable tax_date      like so_tax_date.
         define new shared variable tax_recno     as recid.
         define     shared variable sotax_trl     like tax_trl.
         define new shared variable undo_sosomtb  like mfc_logical.
/*H049*/ define     shared variable disp_fr       like mfc_logical
                          label {&sosomtp_p_7}.
/*H184*/ define     shared variable socrt_int     like sod_crt_int.
/*H541*/ define            variable soc_pt_req    like mfc_logical.
/*J044*/ define     shared variable impexp        like mfc_logical no-undo.
/*J044*/ define            variable imp-okay      like mfc_logical no-undo.
/*J042*/ define     shared variable line_pricing  like pic_so_linpri.
/*J042*/ define     shared variable reprice       like mfc_logical.
/*J042*/ define     shared variable picust        like cm_addr.
/*G2F0*/ define            variable old_comm_pct  as decimal
/*G2F0*/                      format ">>9.99" no-undo.
/*G2F0*/ define            variable l_up_comm     like mfc_logical no-undo.
/*M017*/ define            variable o-error_flag like mfc_logical no-undo.

/*J042*/ {pppivar.i}   /* Shared pricing variables */

/*J04C*/ /* THESE HANDLE FIELDS ARE USED TO GIVE RMA'S DIFFERENT LABELS */
/*J04C*/ define        variable hdl-req-date    as  handle.
/*J04C*/ define        variable hdl-due-date    as  handle.

/*M109*/ define        variable l_old_channel   like so_channel  no-undo.
/*M109*/ define        variable l_so_db         like global_db   no-undo.
/*M109*/ define        variable l_err_flag      as   integer     no-undo.

/*M109*/ define temp-table tmp_db no-undo
/*M109*/    field tmp_db_name like si_db.

     {gptxcdec.i}  /* Define shared variables for gptxcval.i. */

     {sosomt02.i}  /* Form definitions for shared frames a & b */
/*GN40*/ /*V8+*/

     find so_mstr where recid(so_mstr) = so_recno.
     find first gl_ctrl no-lock.
/*H541*/ find first soc_ctrl no-lock.
/*J08Y*/ find first iec_ctrl no-lock no-error.

/*J0XR*/ reprice = no.
/*J0XR*/ display reprice with frame b.

/*J04C*  ADDED THE FOLLOWING */
         /* IF WE'RE DEALING WITH RMA'S, CHANGE THESE LABELS:       */
         /* SO_REQ_DATE GOES FROM REQUIRED DATE TO DUE DATE         */
         /* SO_DUE_DATE GOES FROM DUE DATE TO EXPECTED DATE         */
         if  so_fsm_type = "RMA" then
            assign
                hdl-req-date       = so_req_date:handle
                hdl-req-date:label = {&sosomtp_p_8}
                hdl-due-date       = so_due_date:handle
                hdl-due-date:label = {&sosomtp_p_9}.
/*J04C*  END ADDED CODE */

     setb:
     do on error undo, retry with frame b:
/*GUI*/ if global-beam-me-up then undo, leave.


/*M109*/ l_old_channel = so_channel.
/*H086*/    /* Move down into new frame b1 */


        set so_ord_date so_req_date promise_date so_due_date
/*J0KJ*/        so_pricing_dt
        so_po
/*H086*/        so_rmks

/*J042**        LIST TYPE PRICE LISTS NO LONGER ENTERED IN ORDER MAINTENANCE
** /*H086*/        so_pr_list2
**J042*/
/*J042*/        line_pricing when (new_order)
/*H086*/        /* so_slspsn[1]   */
/*H086*/        /* mult_slspsn    */
/*H086*/        /* so_comm_pct[1] */
/*H086*/        /* so_rmks        */
        so_pr_list so_site so_channel so_project
        confirm when (new so_mstr) so_curr when (new so_mstr)
/*H008*/        so_lang so_taxable
/*H008*/        so_taxc /* when (not {txnew.i}) */
/*H008*/        so_tax_date
/*H086*/        so_fix_pr
        so_cr_terms
/*H086*/        /* so_fr_list */
/*H086*/        /* alloc      */
/*H086*/        /* socmmts    */
/*H184*/        socrt_int
/*J042*/        reprice when (not new_order)
/*H582* **  go-on ("F5" "CTRL-D").   */
/*H582*/        go-on ("F5" "CTRL-D")  editing:

/*H582*  ADDED THIS SECTION - DISPLAY INTEREST AFTER ENTERING CREDIT TERMS */
        readkey.
           if frame-field = "so_cr_terms" then do:
              if (lastkey = keycode("RETURN") or
             lastkey = keycode("CTRL-X") or
             lastkey = keycode("F1"))
              then do:
              find first ct_mstr where ct_code = input so_cr_terms
                   no-lock no-error.
              if available ct_mstr then do:
                 display string(ct_terms_int,"->>>9.99")
                     @ socrt_int.
                 socrt_int = ct_terms_int.
              end.
             end.
           end.
/*K09J*/           if frame-field = "so_po" then do:
/*K09J*/          if (lastkey = keycode("RETURN") or
/*K09J*/         lastkey = keycode("CTRL-X") or
/*K09J*/         lastkey = keycode("F1"))
/*K09J*/          then do:
/*K1FK*/          if input so_po = "" and soc_use_btb and
/*K1FK*/             not this-is-rma then do:
/*K09J*/             {mfmsg.i 2897 2}
/*K09J*/             pause.
/*K09J*/                     next-prompt so_rmks with frame b.
/*K09J*/                     next.
/*K09J*/                  end.
/*K09J*/              end.
/*K09J*/       end.
           apply lastkey.
        end. /*editing*/

        /*H582*  END SECTION */

/*M109*/ /* BEGIN ADD SECTION */
         if not new so_mstr
                and so_channel <> l_old_channel
         then do:

            l_so_db  = global_db.

            for each sod_det
               fields(sod_btb_po sod_btb_type sod_contr_id
                      sod_nbr sod_site)
               where sod_nbr = so_nbr no-lock:

               for first si_mstr
                  fields(si_db si_site)
                  where si_site =  sod_site
                  and   si_db   <> l_so_db no-lock:
               end. /* FOR FIRST si_mstr */
               if available si_mstr
               then do:
                  if not (can-find (first tmp_db
                                    where tmp_db_name = si_db))
                  then do:
                      create tmp_db.
                      tmp_db_name = si_db.
                  end. /* IF NOT CAN-FIND FIRST tmp_db... */
               end. /* IF AVAILABLE si_mstr */

            end. /* FOR EACH sod_det */

            for each tmp_db:
/*GUI*/ if global-beam-me-up then undo, leave.


               {gprun.i ""gpalias3.p""
                   "(input  tmp_db_name,
                     output l_err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               /* SOSOMTP1.P CALLED TO PROPAGATE CHANNEL DETAILS */
               /* TO REMOTE DATABASE */
               if l_err_flag = 0
               or l_err_flag = 9
               then do:
                  {gprun.i ""sosomtp1.p""
                      "(input so_nbr,
                        input so_channel)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end. /* IF l_err_flag.. */

            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH tmp_db */

        if l_so_db <> global_db
            then do:
               {gprun.i ""gpalias3.p""
                   "(input  l_so_db,
                     output l_err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end. /* IF l_so_db <> global_db */
         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF NOT NEW so_mstr ... */
/*M109*/ /* END ADD SECTION */

/*H0FW*/       if so_cr_terms <> ""
/*H0FW*/       then do:
/*H0FW*/          find first ct_mstr where ct_code = so_cr_terms
/*H0FW*/             no-lock no-error.
/*H0FW*/          if not available ct_mstr then do:
/*H0FW*/             /* CREDIT TERM CODE MUST EXIST OR BE BLANK */
/*H0FW*/             {mfmsg.i 840 3}
/*H0FW*/             next-prompt so_cr_terms with frame b.
/*H0FW*/             undo setb, retry setb.
/*H0FW*/          end.
/*H0FW*/       end.

/*K0DH*/       if so_primary and not so_secondary then
/*K0DH*/         assign so_cust_po = so_po
/*K0DH*/                so_ship_po = so_po.

           /* VALIDATE LINE PRICING OPTION VALID */
/*J0FQ*/       if new_order and not line_pricing then do:

/*J0FQ*/          find first mfc_ctrl where mfc_field = "soc_pt_req"
/*J0FQ*/          no-lock no-error.

/*J0FQ*/          if available mfc_ctrl and mfc_logical then do:

/*J0FQ*/             /* PRICE LIST REQUIRED AND NO LINE PRICING NOT ALLOWED */
/*J0FQ*/             {mfmsg.i 1277 3}
/*J0FQ*/             next-prompt line_pricing.
/*J0FQ*/             undo setb, retry setb.
/*J0FQ*/          end.

/*J0FQ*/       end. /* IF NOT LINE_PRICING */

        so_recno = recid(so_mstr).

        /* DELETE */
        if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
        then do:
/*J04C*            ADDED THE FOLLOWING */
                   /* THE USER MAY HAVE LINKED RTS LINE(S) TO ONE OR MORE LINES */
                   /* ON THIS RMA.  CHECK FOR THAT, AND, IF IT EXISTS, GIVE THE */
                   /* USER A CHANCE TO CHANGE HIS MIND.                         */
                   if so_fsm_type = "RMA" then do:
                      if can-find (first rmd_det where rmd_rma_nbr = so_nbr) then do:
                {mfmsg.i 1120 2}
                /* THIS IS LINKED TO ONE OR MORE RTS LINES */
                      end.    /* if can-find... */
                   end.     /* if so_fsm_type = "RMA" then */
/*J04C*            END ADDED CODE */
           del-yn = yes.
           {mfmsg01.i 11 1 del-yn}
           if not del-yn then undo, retry.


        end.
        else
        if so_conf_date = ? and confirm = yes then so_conf_date = today.

        if del-yn then do:
/*G2HR** /*G0Q5*/ if can-find(first wo_mstr where wo_nbr begins so_nbr) then do: */
/*G2HR*/       if can-find(first wo_mstr where wo_nbr begins (so_nbr + ".")
/*G2HR*/          and wo_type = "F" ) then do:
/*G0Q5*/          {mfmsg.i 518 2}  /* Final assembly work order exists for S/O*/
/*G0Q5*/          pause.
/*G0Q5*/       end.

/*K0GS*/       if so_secondary then do:
/*K0GS*/             {mfmsg.i 2938 3}
/*K0GS*/             undo setb, retry setb.
/*K0GS*/          end.
           {gprun.i ""sosomtd.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

           if merror then undo setb, retry.
        /*K1BN         else leave setb.*/
/*K1BN*/       else do:
/*K1BN*/          if cfexists then do:
/*K1BN*/             /* work through the cf_sod_rm file removing any files*/
/*K1BN*/             for each cf_sod_rm:
/*K1BN*/                os-delete value(cf_cfg_path + cf_chr + cf_ccq_name).
/*K1BN*/             end.
/*K1BN*/          end.
/*K1BN*/          leave setb.
/*K1BN*/       end.

        end.

/*H086*/        /* Move down into new frame b1 */

/*K1FK* /*K09L*/ if so_po = "" and soc_use_btb then do: */
/*K1FK*/    if so_po = "" and soc_use_btb and not this-is-rma then do:
/*K09L*/       {mfmsg.i 2897 2}
/*K09L*/       pause.
/*K09L*/    end.

        /* CHECK FOR DUPLICATE P.O. NUMBER */
        if so_mstr.so_po <> "" then do for somstr:
           find first somstr where somstr.so_po = so_mstr.so_po
                   and somstr.so_cust = so_mstr.so_cust
                   and somstr.so_nbr <> so_mstr.so_nbr
                 no-lock no-error.
           if not available somstr then
        find first ih_hist where ih_po   =  so_mstr.so_po
                     and ih_cust =  so_mstr.so_cust
                     and ih_nbr  <> so_mstr.so_nbr
                   no-lock no-error.
           if available somstr or available ih_hist then do:
          {mfmsg.i 624 2}
/*FQ08*/          if not batchrun then pause.
           end.
        end.   /* if so_mstr.so_po <> "" */
/*J04C*     ADDED THE FOLLOWING TO SUPPORT CHECK ON CUSTOMERS FOR WHOM A PO IS REQUIRED */
/*J04C*/    else do: /* so_po was left blank */
/*J2Q9**        if so_fsm_type = " " then do: */
/*J2Q9*/        if so_fsm_type = " " and (not so_sched) then do:
                    /* SO_FSM_TYPE IS BLANK FOR NORMAL SALES ORDERS */
                    find cm_mstr where cm_addr = so_cust no-lock no-error.
                    if available cm_mstr then
                        if cm_po_reqd then do:
                            {mfmsg.i 631 3}
                            /* PURCHASE ORDER IS REQUIRED FOR THIS CUSTOMER */
                            next-prompt so_po.
                            undo, retry.
                        end.
                end.    /* if so_fsm_type = " " */
                else do:
                    /* IF SO_FSM_TYPE IS NON-BLANK, THIS MUST BE AN RMA */
                    find rma_mstr where rma_nbr = so_nbr and rma_prefix = "C"
                        no-lock no-error.
                    if available rma_mstr then do:
                        find eu_mstr where eu_addr = rma_enduser
                            no-lock no-error.
                        if available eu_mstr then
                            if eu_po_reqd then do:
                                {mfmsg.i 322 3}
                                /* P.O. NUMBER IS REQUIRED FOR THIS END USER */
                                next-prompt so_po.
                                undo, retry.
                            end.
                    end.    /* if available rma_mstr */
                end.    /* else do */
             end.   /* else do */
/*J04C*      END ADDED CODE */

/*J1TQ*/    /* UPDATE ALL LINE ITEMS WITH THE SO HEADER P. O. NUMBER */
/*J2Q9** /*J1TQ*/    if not new_order and so_fsm_type = " " then do: */
/*J2Q9*/    if not new_order and so_fsm_type = " " and not so_sched then do:
/*J1TQ*/    for each sod_det where sod_det.sod_nbr = so_mstr.so_nbr
/*J1TQ*/        exclusive-lock :
/*J1TQ*/         assign sod_contr_id = so_po.
/*J1TQ*/        end. /* FOR EACH sod_det */
/*J1TQ*/     end. /* IF NOT new_order AND so_fsm_type = " " */

/*J042*/    manual_list = so_pr_list.

/*L024*     ** BEGIN DELETE
*           /* EXCHANGE RATE CALCULATED FIRST TIME ONLY */
*           if new so_mstr and base_curr <> so_mstr.so_curr then do:
*              /*VALIDATE EXCHANGE RATE */
* /*GA60*/     next-prompt so_mstr.so_curr.  /* in case validate fails */
* /*GA60*/     {gpgtex5.i &ent_curr = base_curr
* /*GA60*/                &curr = so_mstr.so_curr
* /*GA60*/                &date = so_mstr.so_ord_date
* /*GA60*/                &exch_from = exd_ent_rate
* /*GA60*/                &exch_to = so_mstr.so_ent_ex
* /*GA60*/                &loop = setb}
*           end.
**L024*     ** END DELETE **/

/*J034*/    {gprun.i ""gpsiver.p""
               "(input so_site, input ?, output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/    if return_int = 0 then do:
/*J034*/       {mfmsg.i 725 3}  /* USER DOES NOT HAVE ACCESS TO THIS SITE */
/*J034*/       next-prompt so_site with frame b.
/*J034*/       undo, retry.
/*J034*/    end.

/*L024*/    /* EXCHANGE RATE CALCULATED FIRST TIME ONLY */
/*L024*/    if new so_mstr and base_curr <> so_mstr.so_curr then do:

/*L024*/       /* Validate currency */
/*L024*/       {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
                  "(input  so_mstr.so_curr,
                    output mc-error-number)" }
/*L024*/       if mc-error-number <> 0 then do:
/*L024*/          {mfmsg.i mc-error-number 3}
/*L024*/          next-prompt so_mstr.so_curr.
/*L024*/          undo setb, retry setb.
/*L024*/       end.

/*L024*/       /* Calculate exchange rate & create usage records */
/*L024*/       {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                  "(input  so_mstr.so_curr,
                    input  base_curr,
                    input  so_mstr.so_ex_ratetype,
                    input  so_mstr.so_ord_date,
                    output so_mstr.so_ex_rate,
                    output so_mstr.so_ex_rate2,
                    output so_mstr.so_exru_seq,
                    output mc-error-number)" }
/*L024*/       if mc-error-number <> 0 then do:
/*L024*/          {mfmsg.i mc-error-number 3}
/*L024*/          next-prompt so_mstr.so_curr.
/*L024*/          undo setb, retry setb.
/*L024*/       end.

/*L024*/    end.  /* if new so_mstr */

/*J0ZZ*/    if (oldcurr <> so_curr) or (oldcurr = "") then do:

/*L024**************************************
* /*J0ZZ*/       {gpcurmth.i
*            "so_curr"
*            "3"
*            "undo setb, retry"
*            "next-prompt so_mstr.so_curr" }
*L024***************************************/
/*L024*/       /** GET ROUNDING METHOD FROM CURRENCY MASTER **/
/*L024*/       {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                  "(input so_curr,
                    output rndmthd,
                    output mc-error-number)"}
/*L024*/       if mc-error-number <> 0 then do:
/*L024*/          {mfmsg.i mc-error-number 3}
/*L024*/          next-prompt so_mstr.so_curr.
/*L024*/          undo setb, retry setb.
/*L024*/       end. /* if mc-error-number <> 0 */

/*J053*/    end. /* if (oldcurr <> so_curr) or (oldcurr = "") */

        /* USE TAX DATE IF ENTERED TO GET TAX RATES, ELSE DUE DATE */
        if so_tax_date <> ? then tax_date = so_tax_date.
        else tax_date = so_due_date.
        if tax_date = ? then tax_date = so_ord_date.

        /* IF TAXABLE GET TAX RATES, USING "TAX DATE"  IF POSSIBLE */
        if not gl_vat and not {txnew.i} then do:
           find ad_mstr where ad_addr = so_ship no-lock.
           {gprun.i ""gptax.p"" "(input ad_state,
                      input ad_county,
                      input ad_city,
                      input tax_date)"}
/*GUI*/ if global-beam-me-up then undo, leave.

           find tax_mstr where recid(tax_mstr) = tax_recno no-lock no-error.
           sotax_trl = no.
           if available tax_mstr then do:
           if gl_can then so_pst_pct = tax_tax_pct[2].
          else do:  /*u.s. tax*/
             so_tax_pct[1] = tax_tax_pct[1].
             so_tax_pct[2] = tax_tax_pct[2].
             so_tax_pct[3] = tax_tax_pct[3].
             sotax_trl = tax_trl.
          end.
           end.
        end. /*if not gl_vat*/

        /* VALIDATE TAX CODE AND TAXABLE BY TAX DATE OR DUE DATE */
        {gptxcval.i &code=so_mstr.so_taxc &taxable=so_mstr.so_taxable
        &date=tax_date &frame="b"}

         /* SET EXCHANGE RATE */
         /* Allow change to exrate only when new because tr_hist created */
/*L024*/ if new so_mstr or so_conf_date = ? then do:
/*L024*/    {gprunp.i "mcui" "p" "mc-ex-rate-input"
               "(input        so_curr,
                 input        base_curr,
                 input        so_ord_date,
                 input        so_exru_seq,
                 input        true, /* update fixed-rate field */
                 input        frame-row(b) + 4,
                 input-output so_ex_rate,
                 input-output so_ex_rate2,
                 input-output so_fix_rate)"}
/*L024*/ end.  /* if new so_mstr */

/*L024*  ** THE FOLLOWING BLOCK REPLACED BY CALL TO mc-ex-rate-input **/
/*L024* /* SET EXCHANGE RATE */
*       /* Allow change to exrate only when new because tr_hist created */
*        if so_curr <> base_curr then
*        setb_sub:
*        do on error undo, retry:
*           form
*          so_ent_ex   colon 15
* /*GM78*/          space(2)
*          so_fix_rate colon 15
*           with frame setb_sub attr-space overlay side-labels
*           centered row frame-row(b) + 4.
* /*GM78*/ /*V8!
*       frame setb_sub:height-pixels = frame setb_sub:height-pixels + 8. */
*           display so_ent_ex with frame setb_sub.
*           update so_ent_ex when (new so_mstr or so_conf_date = ?)
*           so_fix_rate with frame setb_sub.
*           if so_ent_ex = 0  then do:
*          {mfmsg.i 317 3} /*ZERO NOT ALLOWED*/
*          undo setb_sub, retry.
*           end.
*           hide frame setb_sub.
*           /* SET THE EX_RATE FROM ENTER EXCHANGE RATE */
*           if new so_mstr or so_conf_date = ? then do:
* /*G484*/          {gpgtex7.i &ent_curr = base_curr
*                 &curr = so_curr
*                 &exch_from = so_ent_ex
*                 &exch_to = so_ex_rate}
*           end.
*        end. /*setb_sub*/
**L024*   ** END OF REMOVED BLOCK **/

        /*G415* - GET HEADER TAX DATA */
        if {txnew.i} then do:
           undo_sosomtb = true.
           {gprun.i ""sosomtb.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

           if undo_sosomtb then undo setb, retry.
        end.

/*H184*/    /* UPDATE ORDER HEADER TERMS INTEREST PERCENTAGE */
/*H184*/    if socrt_int <> 0  and so_cr_terms <> ""
/*H419*/    and (new_order or so__qad02 <> socrt_int)
/*H184*/    then do:
/*H184*/       find ct_mstr where ct_code = so_cr_terms no-lock no-error.
/*H184*/       if available ct_mstr and socrt_int <> 0 then do:
/*H184*/          if socrt_int <> ct_terms_int then do:
/*H184*/             {mfmsg03.i 6212 2 socrt_int ct_terms_int """" }
/*H184*/             /* Entered terms interest # does not match ct interest # */
/*H184*/             del-yn = yes.
/*G0KL* /*H184*/     {mfmsg01.i 9000 2 del-yn}   */
/*G0KL*/             {mfmsg01.i 8500 2 del-yn}  /* DO YOU WISH TO CONTINUE? */
/*H184*/             /* Do you wish to continue? */
/*H184*/             if not del-yn then do:
/*H184*/                next-prompt socrt_int.
/*H184*/                undo, retry.
/*H184*/             end.
/*H184*/          end.
/*H184*/       end.
/*H184*/    end.
/*H419*/    so__qad02 = socrt_int.

/*H086*/    undo_flag = false.

/*H086*/ end. /*setb*/
/*H086*/ hide frame b no-pause.

/*H086*/ /* Check for deleted order and if we made it through the          */
/*H086*/ /* first block, reset the flag to catch "F5" in the second block. */
/*H086*/ if undo_flag then return.
/*H086*/              else undo_flag = true.

/*H086*/ ststatus = stline[3].
/*H086*/ status input ststatus.
/*H086*/ view frame b1.

/*H086*/ calc_fr = no.
/*H086*/ disp_fr = yes.
/*H086*/ if new_order then calc_fr = yes.
/*H086*/ old_fr_terms = so_fr_terms.

/*J044*/ impexp = no.

/*J08Y*  if can-find( first ie_mstr  */
/*J044*     where ie_type = "1" and ie_nbr = so_nbr ) then impexp = yes. */
/*J08Y*/ /* SET THE DEFAULT VALUE BASED ON IEC_CTRL FILE */
/*J08Y*/ if available iec_ctrl and iec_impexp = yes then impexp = yes.

/*H086*/ display
/*H086*/     so_slspsn[1]
/*H086*/     mult_slspsn
/*H086*/     so_comm_pct[1]
/*H086*/     so_fr_list
/*H086*/     so_fr_min_wt
/*H086*/     so_fr_terms
/*H086*/     calc_fr
/*H086*/     disp_fr
/*H086*/     so_weight_um
/*H086*/     consume
/*H086*/     so-detail-all
/*G2D5*/     all_days
/*H086*/     socmmts
/*J044*/     impexp
/*H086*/  with frame b1.

/*H086*/ setb1:
     do on error undo, retry with frame b1:
/*GUI*/ if global-beam-me-up then undo, leave.


        do counter = 1 to 4:
        old_slspsn[counter] = so_slspsn[counter].
        end.
/*G2F0*/    old_comm_pct = so_comm_pct[1].

        /*G035* - Initialize Freight unit of measure */
        old_um = "".
        find fr_mstr where fr_list = so_fr_list
               and fr_site = so_site
               and fr_curr = so_curr
               no-lock no-error.
        if not available fr_mstr then
           find fr_mstr where fr_list = so_fr_list
                  and fr_site = so_site
/*L024*           and fr_curr = gl_base_curr */
/*L024*/          and fr_curr = base_curr
                  no-lock no-error.
           if available fr_mstr then do:
          old_um = fr_um.
          if so_weight_um = "" then so_weight_um = fr_um.
           end.

        set
        so_slspsn[1]
        mult_slspsn
        so_comm_pct[1]
        so_fr_list
        so_fr_min_wt
        so_fr_terms
        calc_fr
        disp_fr
        consume
        so-detail-all
/*G2D5*/        all_days
        socmmts
/*J044*/        impexp
        go-on ("F1" "CTRL-X").

        /* IF SHIPMENTS EXIST, DON'T ALLOW CHANGE TO SLSPSNS */
        if not new so_mstr and
/*F0PC*/     so_slspsn[1] entered then do:
/*F0PC*      not mult_slspsn and so_slspsn[1] entered then do: ***/
           /* SHIP DATE COULD HAVE BEEN RESET, SO LOOK FOR SHIP HISTORY */
           find first tr_hist where tr_nbr = so_nbr
                    and tr_type = "ISS-SO" no-lock no-error.
           if available tr_hist then do:
          {mfmsg.i 130 3}.
          /*Shipment exists, salesperson change not allowed.*/
          so_slspsn[1] = old_slspsn[1].
          display so_slspsn[1] with frame b1.
          next-prompt so_slspsn[1] with frame b1.
          undo, retry setb1.
           end.
           else rebook_lines = true.
        end.

/*G2H5*/    if input so_slspsn[1] = "" then do:
/*G2H5*/       assign so_comm_pct[1] = 0.
/*G2H5*/       display so_comm_pct[1] with frame b1. pause 0.
/*G2H5*/    end.
/*G2F0*/    /* WHEN SALESPERSON IS CHANGED PROMPT THE USER TO DEFAULT THE NEW */
/*G2F0*/    /* SALESPERSON'S COMMISSION PERCENT.                              */
/*G2F0*/    if input so_slspsn[1] <> old_slspsn[1]   and
/*G2F0*/       input so_comm_pct[1] =  old_comm_pct  and
/*G2H5*/       input so_slspsn[1]  <> ""             and
/*G2F0*/       not batchrun  then do:
/*G2F0*/       find sp_mstr where sp_addr = input so_slspsn[1] no-lock no-error.
/*G2F0*/       if input so_comm_pct[1] <> sp_comm_pct then do:
/*G2F0*/          {mfmsg01.i 1396 1 l_up_comm}
/*G2F0*/          /* Salesperson changed. Update default commission? */
/*G2F0*/          if l_up_comm then do:
/*G2F0*/             assign so_comm_pct[1] = sp_comm_pct.
/*G2F0*/             display so_comm_pct[1] with frame b1. pause 0.
/*G2F0*/          end.
/*G2F0*/       end.
/*G2F0*/    end.

        /* MUILTIPLE SLSPSN ENTRY WITH HISTORY CHECK ON MODIFIED ORDER */
        if mult_slspsn then do:
           {gprun.i ""sososls.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*GO33*        if lastkey = keycode("F4") or lastkey = 304 then */
/*GO33*/       if keyfunction(lastkey) = "end-error" then
          undo, retry setb1.
        end.

        /*G035* - Validate Freight list */
        if so_fr_list <> "" then do:
           find fr_mstr where fr_list = so_fr_list and
           fr_site = so_site and fr_curr = so_curr no-lock no-error.
           if not available fr_mstr then
           find fr_mstr where fr_list = so_fr_list and
/*L024*    fr_site = so_site and fr_curr = gl_base_curr no-lock no-error. */
/*L024*/   fr_site = so_site and fr_curr = base_curr no-lock no-error.

           if not available fr_mstr then do:
          /* FREIGHT LIST # NOT FOUND FOR SITE # CURRENCY */
          {mfmsg03.i 670 4 so_fr_list so_site so_curr}
          next-prompt so_fr_list with frame b1.
          undo, retry.
           end.
        end.

        /*G035 -  FREIGHT PARAMETERS */
        if so_fr_list <> "" then do:

           if so_fr_list <> "" or (so_fr_list = "" and calc_fr) then do:
          find fr_mstr where fr_list = so_fr_list
                 and fr_site = so_site
                 and fr_curr = so_curr
          no-lock no-error.
          if not available fr_mstr then
           find fr_mstr where fr_list = so_fr_list
                  and fr_site = so_site
/*L024*           and fr_curr = gl_base_curr */
/*L024*/          and fr_curr = base_curr
           no-lock no-error.
          if not available fr_mstr then do:
             /* FREIGHT LIST # NOT FOUND FOR SITE # CURRENCY */
             {mfmsg03.i 670 4 so_fr_list so_site so_curr}
             undo, retry.
          end.
          if old_um <> fr_um and not new_order then do:
             {mfmsg.i 675 2} /* UNIT OF MEASURE HAS CHANGED */
/*FQ08*/             if not batchrun then pause.
          end.
           end.

           if so_fr_terms <> ""
          or (so_fr_terms = "" and calc_fr) then do:
          find ft_mstr where ft_terms = so_fr_terms no-lock no-error.
          if not available ft_mstr then do:
             /* Invalid Freight Terms */
             {mfmsg03.i 671 3 so_fr_terms """" """"}
             next-prompt so_fr_terms with frame b1.
             undo setb1, retry.
          end.
           end.

           if so_fr_terms <> old_fr_terms
        and not new_order and not calc_fr
        then do:
          /* CALCULATION REQUIRED WHEN FREIGHT TERMS CHANGE */
          {mfmsg.i 681 1}
          next-prompt calc_fr with frame b1.
          undo setb1, retry.
           end.

        end.  /* Freight Parameters */

/*J23V*/ /* VALIDATION FOR FREIGHT TERMS WITH BLANK FREIGHT LIST */

/*J25B*/ /* VALIDATE so_fr_terms WHEN ENTERED */
/*J25B*/   if so_fr_terms <> "" then do:
/*J23V*/       find ft_mstr where ft_terms = so_fr_terms no-lock no-error.
/*J23V*/       if not available ft_mstr then do :
/*J23V*/          /* INVALID FREIGHT TERMS */
/*J23V*/          {mfmsg03.i 671 3 so_fr_terms """" """"}
/*J23V*/          next-prompt so_fr_terms with frame b1.
/*J23V*/          undo setb1, retry.
/*J23V*/       end. /* END OF NOT AVAILABLE ft_mstr */
/*J23V*/    end. /* END OF so_fr_terms <> "" */

/*H086*  end. /*setb*/ */

/*J044*/ /* IF IMPORT EXPORT FLAG IS SET TO YES CALL THE IMPORT EXPORT     */
/*J044*/ /* CREATE ROUTINE TO CREATE ie_mstr ied_det AND UPDATE  ie_mstr   */

/*J044*/ if impexp then do:
/*J044*/    hide frame b1 no-pause.
/*J044*/    imp-okay = no.
/*J044*/    {gprun.i ""iemstrcr.p"" "(input ""1"",
                      input so_nbr,
                      input recid(so_mstr),
                      input-output imp-okay )"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J044*/    if imp-okay = no then do:
/*J044*/       undo setb1, retry.
/*J044*/    end.
/*J044*/ end.

/*M017*/ for first cm_mstr fields(cm_addr cm_promo)
/*M017*/    no-lock where cm_addr = so_cust: end.
/*GUI*/ if global-beam-me-up then undo, leave.

/*M017*/ if available cm_mstr then do:
/*M017*/    if soc_apm
/*M017*/       and cm_promo <> "" then do:
/*M017*/       hide frame b1 no-pause.
/*M017*/       {gprun.i ""sosoapm1.p"" "(input cm_addr,
                         input so_nbr,
                         output o-error_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*M017*/       if o-error_flag then do:
/*M017*/          undo setb1, retry.
/*M017*/       end.
/*M017*/    end.  /* IF SOC_APM AND CM_PROMO <> "" */
/*M017*/ end.  /* IF AVAILABLE CM_MSTR */

/*H086*/ end. /*setb1*/

/*H086*/ hide frame b1 no-pause.
/*GI55*/ undo_flag = false.
