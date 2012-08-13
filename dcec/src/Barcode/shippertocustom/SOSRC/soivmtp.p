/* GUI CONVERTED from soivmtp.p (converter v1.71) Thu Aug 26 15:08:13 1999 */
/* soivmtp.p - INVOICE MAINTENANCE HEADER FRAME b                       */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*J3KZ*//*V8*WebEnabled=No*/
/*J3KZ*//*V8:RunMode=Character,Windows */
/* REVISION: 7.3      LAST MODIFIED: 05/28/93   BY: kgs *GB31*          */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   BY: pcd *H039*          */
/* REVISION: 7.4      LAST MODIFIED: 08/23/93   BY: cdt *H049*          */
/* REVISION: 7.4      LAST MODIFIED: 09/27/93   BY: cdt *H086*          */
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: cdt *H184*          */
/* REVISION: 7.4      LAST MODIFIED: 01/28/94   BY: afs *GI55*          */
/* REVISION: 7.4      LAST MODIFIED: 06/16/94   BY: dpm *FO94*          */
/* REVISION: 7.4      LAST MODIFIED: 07/29/94   BY: bcm *H465*          */
/* REVISION: 7.4      LAST MODIFIED: 09/10/94   BY: bcm *GM05*          */
/* Oracle changes (share-locks)      09/13/94   BY: rwl *FR31*          */
/* REVISION: 7.4      LAST MODIFIED: 09/29/94   BY: bcm *H541*          */
/* REVISION: 7.4      LAST MODIFIED: 10/05/94   BY: dpm *GN07*          */
/* REVISION: 7.4      LAST MODIFIED: 10/19/94   BY: ljm *GN40*          */
/* REVISION: 7.4      LAST MODIFIED: 10/21/94   BY: rmh *FQ08*          */
/* REVISION: 7.4      LAST MODIFIED: 11/08/94   BY: ljm *GO33*          */
/* REVISION: 8.5      LAST MODIFIED: 12/04/94   BY: mwd *J034*          */
/* REVISION: 8.5      LAST MODIFIED: 02/20/95   BY: dpm *J044*          */
/* REVISION: 7.4      LAST MODIFIED: 04/10/95   BY: yep *G0KL*          */
/* REVISION: 8.5      LAST MODIFIED: 04/07/95   BY: dah *J042*          */
/* REVISION: 7.4      LAST MODIFIED: 10/09/95   BY: dpm *H0GB*          */
/* REVISION: 8.5      LAST MODIFIED: 10/27/95   BY: dpm *J08Y*          */
/* REVISION: 8.5      LAST MODIFIED: 07/18/95   BY: taf *J053*          */
/* REVISION: 8.5      LAST MODIFIED: 03/11/96   BY: wjk *J0DV*          */
/* REVISION: 8.5      LAST MODIFIED: 04/11/96   BY: ais *G1GJ*          */
/* REVISION: 8.5      LAST MODIFIED: 04/12/96   BY: ais *H0JF*          */
/* REVISION: 8.5      LAST MODIFIED: 04/15/96   BY: *J04C* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 04/15/96   BY: *J04C* Markus Barone*/
/* REVISION: 8.5      LAST MODIFIED: 07/04/96   BY: *J0XR* Dennis Henson*/
/* REVISION: 8.5      LAST MODIFIED: 07/10/96   BY: *G1ZF* Tony Patel   */
/* REVISION: 8.5      LAST MODIFIED: 07/19/96   BY: taf *J0ZZ*          */
/* REVISION: 8.5      LAST MODIFIED: 09/16/96   BY: *G2F0* Ajit Deodhar */
/* REVISION: 8.5      LAST MODIFIED: 10/17/96   BY: *G2H5* Ajit Deodhar */
/* REVISION: 8.6      LAST MODIFIED: 06/30/97   BY: *K0FL* Taek-Soo Chang */
/* REVISION: 8.6      LAST MODIFIED: 07/01/97   BY: *J1TQ* Irine D'mello  */
/* REVISION: 8.6      LAST MODIFIED: 09/28/97   BY: *J21W* Ajit Deodhar   */
/* REVISION: 8.6      LAST MODIFIED: 10/06/97   BY: *K0KJ* Joe Gawel      */
/* REVISION: 8.6      LAST MODIFIED: 10/21/97   BY: *J23V* Nirav Parikh   */
/* REVISION: 8.6      LAST MODIFIED: 11/18/97   BY: *J25B* Aruna Patil    */
/* REVISION: 8.6      LAST MODIFIED: 01/16/98   BY: *J25N* Aruna Patil    */
/* REVISION: 8.6      LAST MODIFIED: 01/29/98   BY: *J2BC* Aruna Patil    */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane      */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton   */
/* REVISION: 8.6E     LAST MODIFIED: 07/09/98   BY: *J2Q9* Niranjan R.    */
/* REVISION: 8.6E     LAST MODIFIED: 07/08/98   BY: *L024* Bill Reckard */
/* Old ECO marker removed, but no ECO header exists *F038*              */
/* Old ECO marker removed, but no ECO header exists *F338*              */
/* Old ECO marker removed, but no ECO header exists *G035*              */
/* Old ECO marker removed, but no ECO header exists *G416*              */
/* Old ECO marker removed, but no ECO header exists *G484*              */
/* Old ECO marker removed, but no ECO header exists *G501*              */
/* Old ECO marker removed, but no ECO header exists *GA60*              */
/* Old ECO marker removed, but no ECO header exists *GA92*              */
/* REVISION: 9.0      LAST MODIFIED: 10/30/98   BY: *M00Q* Markus Barone  */
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *M017* Sandy Brown    */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan     */
/* REVISION: 9.0      LAST MODIFIED: 08/27/99   BY: *J3KZ* Robert Jensen  */

     {mfdeclre.i}

         /* ********** Begin Translatable Strings Definitions ********* */

         &SCOPED-DEFINE soivmtp_p_1 "承诺日期"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivmtp_p_2 "说明"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivmtp_p_3 "项目定价"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivmtp_p_4 "显示重量"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivmtp_p_5 "计算运费"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivmtp_p_6 "到期日期"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivmtp_p_7 "预计"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivmtp_p_8 " 货物发往 "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivmtp_p_9 " 销售至 "
         /* MaxLen: Comment: */

         /* ********** End Translatable Strings Definitions ********* */

         define shared variable rndmthd like rnd_rnd_mthd.
         define shared variable oldcurr like so_curr.
         define shared variable so_recno as recid.
         define shared variable undo_flag like mfc_logical.

         define shared variable new_order like mfc_logical initial no.
         define shared variable promise_date as date label {&soivmtp_p_1}.
         define shared variable mult_slspsn like mfc_logical no-undo.
         define shared variable socmmts like soc_hcmmts label {&soivmtp_p_2}.
         define shared variable calc_fr like mfc_logical
                    label {&soivmtp_p_5}.
         define shared variable old_um like fr_um.
         define shared variable tax_recno as recid.
         define shared variable sotax_trl like tax_trl.
         define shared variable undo_taxc like mfc_logical.
         define shared variable undo_soivmtb like mfc_logical.
         define shared variable exch_rate like exr_rate.
/*L00Y*/ define shared variable exch_rate2 like exr_rate2.
/*L00Y*/ define shared variable exch_ratetype like exr_ratetype.
/*L00Y*/ define shared variable exch_exru_seq like exru_seq.

         define shared variable del-yn like mfc_logical.
         define variable old_fr_terms like so_fr_terms.
         define variable tax_date like tax_effdate.
         define shared variable disp_fr  like mfc_logical
                     label {&soivmtp_p_4}.

         define shared variable socrt_int like sod_crt_int.

         define        variable soc_pt_req      like mfc_logical.
         define shared variable impexp          like mfc_logical no-undo.
         define        variable imp-okay        like mfc_logical no-undo.

         define shared variable reprice         like mfc_logical.
         define shared variable picust          like cm_addr.
         define variable old_slspsn as character format "x(8)" no-undo.
         define            variable old_comm_pct  as decimal
                              format ">>9.99" no-undo.
         define            variable l_up_comm    like mfc_logical no-undo.
/*L024*/ define variable mc-error-number like msg_nbr no-undo.
/*M017*/ define            variable o-error_flag like mfc_logical no-undo.

         /* THESE HANDLE FIELDS ARE USED TO GIVE RMA'S DIFFERENT LABELS */
         define        variable hdl-req-date    as  handle.
         define        variable hdl-due-date    as  handle.
         define shared variable line_pricing like pic_so_linpri
                     label {&soivmtp_p_3}.

         define shared frame a.
         /*V8+*/
         define shared frame b.
         define shared frame b1.

         define buffer somstr for so_mstr.

         {pppivar.i}     /* SHARED PRICING VARIABLES */

         {gptxcdec.i}    /* DECLARATIONS FOR gptxcval.i */

         /* DEFINE VARIABLES USED IN GPGLEF1.P (GL CALENDAR VALIDATION) */
         {gpglefv.i}

         {soivmt02.i}    /* Define shared frame b and b1 */

         /*V8+*/

         find so_mstr where recid(so_mstr) = so_recno.
         find first gl_ctrl no-lock.
         find first soc_ctrl no-lock.
         find first iec_ctrl no-lock no-error.
         find first pic_ctrl no-lock no-error.

         /* IF WE'RE DEALING WITH RMA'S, CHANGE THESE LABELS:       */
         /* SO_REQ_DATE GOES FROM REQUIRED DATE TO DUE DATE         */
         /* SO_DUE_DATE GOES FROM DUE DATE TO EXPECTED DATE         */
         if  so_fsm_type = "RMA" then
            assign
                hdl-req-date       = so_req_date:handle
                hdl-req-date:label = {&soivmtp_p_6}
                hdl-due-date       = so_due_date:handle
                hdl-due-date:label = {&soivmtp_p_7}.
         else
            view frame b.

         reprice = no.
         display reprice with frame b.

         if new_order then
            line_pricing = pic_so_linpri.
         else
            line_pricing = no.
         display line_pricing with frame b.

         setb:
         /* FOR RMA'S, THE USER CANNOT UPDATE INVENTORY RELATED FIELDS HERE */
         do on error undo, retry with frame b:
/*GUI*/ if global-beam-me-up then undo, leave.


        set so_ord_date so_req_date promise_date so_due_date
             so_pricing_dt
         so_po
             so_rmks
         line_pricing when (new_order)
         so_pr_list so_site so_channel so_project
         so_ship_date
/*J3KZ* Allow access to so_ship_date for RMAs. */
/*J3KZ**J04C*             when (so_fsm_type = " ") */
         so_curr when (new_order)
         so_lang so_taxable so_taxc so_tax_date
             so_fix_pr
         so_cr_terms
             socrt_int
             reprice when (not new_order)
         go-on ("F5" "CTRL-D") with frame b editing:
               /* DISPLAY INTEREST AFTER ENTERING CREDIT TERMS */
               readkey.
               if frame-field = "so_cr_terms" then do:
                  if (lastkey = keycode("RETURN") or
                      lastkey = keycode("CTRL-X") or
                      lastkey = keycode("F1"))
                      then do:
                         find first ct_mstr where ct_code = input so_cr_terms
                         no-lock no-error.
                         if available ct_mstr then do:
                            display
                               string(ct_terms_int,"->>>9.99") @ socrt_int.
                            socrt_int = ct_terms_int.
                         end. /* IF AVAILABLE CT_MSTR */
                      end. /* LASTKEY = RETURN, F1 OR CTRL-X */
               end. /* FRAME-FIELD = SO_CR_TERMS */
               apply lastkey.
         end. /* EDITING */

            if input so_cr_terms <> ""
            then do:
               find first ct_mstr where ct_code = input so_cr_terms
                  no-lock no-error.
               if not available ct_mstr then do:
                  /* CREDIT TERM CODE MUST EXIST OR BE BLANK */
                  {mfmsg.i 840 3}
                  next-prompt so_cr_terms with frame b.
                  undo setb, retry setb.
               end.
            end.

            /* VALIDATE LINE PRICING OPTION VALID */
            if new_order and not line_pricing then do:
               find first mfc_ctrl where mfc_field = "soc_pt_req"
               no-lock no-error.
               if available mfc_ctrl and mfc_logical then do:
                  /* PRICE LIST REQUIRED AND NO LINE PRICING NOT ALLOWED */
                  {mfmsg.i 1277 3}
                  next-prompt line_pricing.
                  undo setb, retry setb.
               end.
            end. /* IF NOT LINE_PRICING */

            so_recno = recid(so_mstr).

            /* Get the exchange rate from the so_mstr  */
            /* Value is passed to mfivtr.i             */
/*L024*/    assign
               exch_rate = so_ex_rate
/*L024*/       exch_rate2 = so_ex_rate2.

            /* DO NOT ALLOW THE USER TO DELETE RMA'S HERE */
            if so_fsm_type = " " then
           /* DELETE */
           if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
           then do:
              del-yn = yes.
              {mfmsg01.i 11 1 del-yn}
              if del-yn = no then undo setb,
                                      retry.

              {gprun.i ""soivmtd.p""}
/*GUI*/ if global-beam-me-up then undo, leave.
  /* Delete invoice */
              /* Soivmtd now does validation before deleting; if      */
              /* Del-yn has been reset then the order was not deleted */

              if del-yn = no then undo setb, retry setb.
                         else leave setb.
           end. /*delete*/

        /* CHECK FOR DUPLICATE P.O. NUMBER */
    /* ALSO CHECH INVOICE HISTORY */
        if so_mstr.so_po <> "" then do for somstr:
           find first somstr where somstr.so_po   =  so_mstr.so_po
                   and somstr.so_cust =  so_mstr.so_cust
                   and somstr.so_nbr  <> so_mstr.so_nbr
                 no-lock no-error.
           if not available somstr then
        find first ih_hist where ih_po   =  so_mstr.so_po
                     and ih_cust =  so_mstr.so_cust
                     and ih_nbr  <> so_mstr.so_nbr
                   no-lock no-error.
           if available somstr or available ih_hist then do:
          {mfmsg.i 624 2}
                  if not batchrun then pause.
           end.
        end.
            else do: /* so_po was left blank */
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

            /* UPDATE ALL LINE ITEMS WITH THE SO HEADER P. O. NUMBER */
/*J2Q9**    if not new_order and so_fsm_type = " " then do: */
/*J2Q9*/    if not new_order and so_fsm_type = " " and not so_sched then do:
            for each sod_det where sod_det.sod_nbr = so_mstr.so_nbr
                exclusive-lock :
                 assign sod_contr_id = so_po.
                end. /* FOR EACH sod_det */
             end. /* IF NOT new_order AND so_fsm_type = " " */

            manual_list = so_pr_list.

        /*CHECK SHIP DATE FOR VALID EFFECTIVE DATE */

            /* VALIDATE GL PERIOD FOR SPECIFIED ENTITY/DATABASE */
            find si_mstr where si_site = so_site no-lock no-error.
            if available si_mstr then do:
               {gpglef3.i &module  = ""IC""
                          &from_db = global_db
                          &to_db   = si_db
                          &entity  = si_entity
                          &date    = so_ship_date
                          &prompt  = "so_ship_date"
                          &frame   = "b"
                          &loop    = "setb"}
            end.

/*L024*     /* EXCHANGE RATE CALCULATED FIRST TIME ONLY */      */
/*L024*     if new so_mstr and so_curr <> base_curr then do:    */
/*L024*        /*VALIDATE EXCHANGE RATE */                      */
/*L024*            next-prompt so_mstr.so_curr.  /* in case validate fails */ */
/*L024*            {gpgtex5.i &ent_curr = base_curr             */
/*L024*                       &curr = so_mstr.so_curr           */
/*L024*                       &date = so_mstr.so_ord_date       */
/*L024*                       &exch_from = exd_ent_rate         */
/*L024*                       &exch_to = so_mstr.so_ent_ex      */
/*L024*                       &loop = setb}                     */
/*L024*        next-prompt so_mstr.so_ord_date. /* disable prev next-prompt*/ */
/*L024*     end.                                                */

            {gprun.i ""gpsiver.p""
               "(input so_site, input ?, output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            if return_int = 0 then do:
               {mfmsg.i 725 3}  /* USER DOES NOT HAVE ACCESS TO THIS SITE */
               next-prompt so_site with frame b.
               undo, retry.
            end.

/*L024*/    /* EXCHANGE RATE CALCULATED FIRST TIME ONLY */
/*L024*/    if new so_mstr and so_curr <> base_curr then do:

/*L024*/       /* Validate currency */
/*L024*/       {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
                  "(input  so_curr,
                    output mc-error-number)" }
/*L024*/       if mc-error-number <> 0 then do:
/*L024*/          {mfmsg.i mc-error-number 3}
/*L024*/          next-prompt so_curr.
/*L024*/          undo setb, retry setb.
/*L024*/       end.

/*L024*/       /* Calculate exchange rate & create usage records */
/*L024*/       {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                  "(input  so_curr,
                    input  base_curr,
                    input  so_ex_ratetype,
                    input  so_ord_date,
                    output so_ex_rate,
                    output so_ex_rate2,
                    output so_exru_seq,
                    output mc-error-number)" }
/*L024*/       if mc-error-number <> 0 then do:
/*L024*/          {mfmsg.i mc-error-number 3}
/*L024*/          next-prompt so_curr.
/*L024*/          undo setb, retry setb.
/*L024*/       end.

/*L024*/    end.  /* if new so_mstr */

            if (oldcurr <> so_curr) or (oldcurr = "") then do:
/*L024*        {gpcurmth.i                        */
/*L024*           "so_curr"                       */
/*L024*           "3"                             */
/*L024*           "undo, retry setb"              */
/*L024*           "next-prompt so_mstr.so_curr" } */

/*L024*/       /** GET ROUNDING METHOD FROM CURRENCY MASTER **/
/*L024*/       {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                  "(input so_curr,
                    output rndmthd,
                    output mc-error-number)"}
/*L024*/       if mc-error-number <> 0 then do:
/*L024*/          {mfmsg.i mc-error-number 3}
/*L024*/          next-prompt so_curr.
/*L024*/          undo setb, retry setb.
/*L024*/       end. /* if mc-error-number <> 0 */
            end. /* IF (OLDCURR <> SO_CURR) */

         /* USE TAX DATE IF ENTERED TO GET TAX RATES, ELSE SHIP DATE     */
         /* IF SHIP DATE = ? THEN USE TODAY (soivmtc.p display tax date) */
            if so_tax_date = ? then tax_date = so_mstr.so_ship_date.
            else tax_date = so_mstr.so_tax_date.

            if tax_date = ? then tax_date = today.

         /* IF TAXABLE GET TAX RATES, USING TAX_EFFDATE IF POSSIBLE */
         if not gl_vat then do:
            find ad_mstr where ad_addr = so_ship no-lock.
            {gprun.i ""gptax.p"" "(input ad_state,
                       input ad_county,
                       input ad_city,
                       input tax_date)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            find tax_mstr where recid(tax_mstr) = tax_recno no-lock no-error.
            sotax_trl = no.
            if available tax_mstr then do:
               if gl_can then
                  so_mstr.so_pst_pct = tax_tax_pct[2].
               else assign  /*u.s. tax*/
                  so_mstr.so_tax_pct[1] = tax_tax_pct[1]
                  so_mstr.so_tax_pct[2] = tax_tax_pct[2]
                  so_mstr.so_tax_pct[3] = tax_tax_pct[3]
                  sotax_trl     = tax_trl .
            end.
         end. /*if not gl_vat*/

         /* VALIDATE TAX CODE AND TAXABLE BY TAX DATE OR DUE DATE */
         {gptxcval.i &code=so_mstr.so_taxc &taxable=so_mstr.so_taxable
            &date=tax_date &frame="b"}

         /* SET EXCHANGE RATE */
         /* Allow change to exrate only when new because tr_hist created */
/*L024*/ if new so_mstr then do:
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

/*L024*  /* ALLOW CHANGE TO EXRATE ONLY WHEN NEW*/  */
/*L024*  /* BECAUSE TR_HIST CREATED*/           */
/*L024*  if so_mstr.so_curr <> base_curr then   */
/*L024*  setb_sub:                              */
/*L024*  do on error undo, retry:               */
/*L024*    form                                 */
/*L024*   so_mstr.so_ent_ex   colon 15 space(2) */
/*L024*   so_mstr.so_fix_rate colon 15          */
/*L024*    with frame setb_sub attr-space overlay side-labels */
/*L024*    centered row frame-row(b) + 4.       */
/*L024*  removed code and replaced with mc-ex-rate-input ***
.          display so_mstr.so_ent_ex with frame setb_sub.
.          update so_mstr.so_ent_ex when (new so_mstr)
.       so_mstr.so_fix_rate
.       with frame setb_sub.
.          if so_mstr.so_ent_ex = 0  then do:
.         {mfmsg.i 317 3} /*ZERO NOT ALLOWED*/
.         undo setb_sub, retry.
.          end.
.          hide frame setb_sub.
.          /* SET THE EX_RATE FROM THE ENTERED EXCHANGE RATE */
.          if new so_mstr then do:
.                 {gpgtex4.i &ent_curr = base_curr
.                 &curr = so_mstr.so_curr
.                 &exch_from = so_mstr.so_ent_ex
.                 &exch_to = so_mstr.so_ex_rate}
.          end.
.       end. /*setb_sub*/
*L024*  code removed */

/*L024* end. /* new so_mstr */  */

        /* Use Order header exchange rate for bookings; use      */
        /* Tr_hist exchange rate for shipments unless fixed rate */

/*L024* if base_curr <> so_mstr.so_curr then do:        */

        if so_mstr.so_fix_rate = no then do:

/*L024*   find last exd_det             */
/*L024*    where exd_curr = so_mstr.so_curr             */
/*L024*    and exd_eff_date <= so_mstr.so_ship_date     */
/*L024*      and exd_end_date >= so_mstr.so_ship_date   */
/*L024*    no-lock no-error.                            */
/*L024*   if not available exd_det then do:             */
/*L024*      {mfmsg.i 81 3}                             */
/*L024*      next-prompt so_mstr.so_curr.               */
/*L024*      undo, retry.                               */
/*L024*   end.                                          */
/*L024*   else                                          */
/*L024*         exch_rate = exd_rate.                   */

/*L024*/     /* GET EXCHANGE RATE FOR BASE TO ACCOUNT CURRENCY */
/*L024*/     {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                "(input  so_curr,
                  input  base_curr,
                  input  so_ex_ratetype,
                  input  so_ship_date,
                  output exch_rate,
                  output exch_rate2,
                  output mc-error-number)" }
/*L024*/     if mc-error-number <> 0 then do:
/*L024*/        {mfmsg.i mc-error-number 2}
/*L024*/        if new so_mstr then next-prompt so_curr.
/*L024*/        else next-prompt so_ship_date.
/*L024*/        undo setb, retry setb.
/*L024*/     end. /* mc-error-number <> 0 */

/*L024*/
        end.  /* so_fix_rate = no */
        else
/*L024*/   assign
              exch_rate  = so_mstr.so_ex_rate
/*L024*/      exch_rate2 = so_mstr.so_ex_rate2.

/*L024*   end.                   */
/*L024*   else exch_rate = 1.0.  */

            /* GET HEADER TAX DATA */
            if {txnew.i} then do:
               undo_soivmtb = true.
               {gprun.i ""soivmtb.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

               if undo_soivmtb then undo setb, retry.
            end.

            /* UPDATE ORDER HEADER TERMS INTEREST PERCENTAGE */
            if socrt_int <> 0  and so_cr_terms <> ""
               and (new_order or so__qad02 <> socrt_int) then do:
               find ct_mstr where ct_code = so_cr_terms no-lock no-error.
               if available ct_mstr and socrt_int <> 0 then do:
                  if socrt_int <> ct_terms_int then do:
                     {mfmsg03.i 6212 2 socrt_int ct_terms_int """" }
                     /* Entered terms interest # does not match ct interest # */
                     del-yn = yes.
                     {mfmsg01.i 8500 2 del-yn}
                     /* Do you wish to continue? */
                     if not del-yn then do:
                        next-prompt socrt_int.
                        undo, retry.
                     end.
                  end.
               end.
            end.
            so__qad02 = socrt_int.
            undo_flag = false.

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*setb*/
         hide frame b no-pause.

         /* Check for deleted order and if we made it through the          */
         /* First block, reset the flag to catch "F5" in the second block. */
         if undo_flag then return.
                      else undo_flag = true.

         ststatus = stline[3].
         status input ststatus.
         view frame b1.

         calc_fr = no.
         disp_fr = yes.
         if new_order then calc_fr = yes.
         old_fr_terms = so_fr_terms.

         /* Check if the order is Import/Export */
         /* Type "1" indicates a Sales Order Type "2" Indicates */
         /* Purchase Order */

         impexp = no.
         /* SET THE DEFAULT VALUE BASED ON IEC_CTRL FILE */
         if available iec_ctrl and iec_impexp = yes then impexp = yes.

         display
             so_slspsn[1]
             mult_slspsn
             so_comm_pct[1]
             so_shipvia
             so_bol
             so_fr_list
             so_fr_min_wt
             so_fr_terms
             calc_fr
             disp_fr
             so_weight_um
             impexp
             socmmts
         with frame b1.

         setb1:
     do on error undo, retry with frame b1:
/*GUI*/ if global-beam-me-up then undo, leave.


            old_slspsn = so_slspsn[1].
            old_comm_pct = so_comm_pct[1].

        /* Initialize Freight unit of measure */
        old_um = "".
        find fr_mstr where fr_list = so_fr_list
               and fr_site = so_site
               and fr_curr = so_curr
               no-lock no-error.
        if not available fr_mstr then
           find fr_mstr where fr_list = so_fr_list
                  and fr_site = so_site
/*L024*           and fr_curr = gl_base_curr        */
/*L024*/          and fr_curr = base_curr
                  no-lock no-error.
           if available fr_mstr then do:
          old_um = fr_um.
          if so_weight_um = "" then so_weight_um = fr_um.
           end.

        set
        so_slspsn[1] when (new_order)
        mult_slspsn
        so_comm_pct[1]
        so_shipvia
        so_bol
        so_fr_list
        so_fr_min_wt
        so_fr_terms
        calc_fr
        disp_fr
                impexp
        socmmts
        go-on ("F1" "CTRL-X").

            if input so_slspsn[1] = "" then do:
               assign so_comm_pct[1] = 0.
               display so_comm_pct[1] with frame b1. pause 0.
            end.
            /* WHEN SALESPERSON IS CHANGED PROMPT THE USER TO DEFAULT THE NEW */
            /* SALESPERSON'S COMMISSION PERCENT.                              */
            if input so_slspsn[1] <> old_slspsn      and
               input so_comm_pct[1] =  old_comm_pct  and
               input so_slspsn[1]  <> ""             and
               not batchrun  then do:
               find sp_mstr where sp_addr = input so_slspsn[1] no-lock no-error.
               if input so_comm_pct[1] <> sp_comm_pct then do:
                  {mfmsg01.i 1396 1 l_up_comm}
                  /* Salesperson changed. Update default commission? */
                  if l_up_comm then do:
                     so_comm_pct[1] = sp_comm_pct.
                     display so_comm_pct[1] with frame b1. pause 0.
                  end.
               end.
            end.

        if mult_slspsn then do:
           {gprun.i ""soivsls.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

               if keyfunction(lastkey) = "end-error" then
          undo, retry setb1.
        end.

        /* Validate Freight list */
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

        /* FREIGHT PARAMETERS */
        if so_fr_list <> "" then do:

           if so_fr_list <> "" or (so_fr_list = "" and calc_fr) then do:
          find fr_mstr where fr_list = so_fr_list
                 and fr_site = so_site
                 and fr_curr = so_curr
          no-lock no-error.
          if not available fr_mstr then
           find fr_mstr where fr_list = so_fr_list
                  and fr_site = so_site
/*L024*           and fr_curr = gl_base_curr  */
/*L024*/          and fr_curr = base_curr
           no-lock no-error.
          if not available fr_mstr then do:
             /* FREIGHT LIST # NOT FOUND FOR SITE # CURRENCY */
             {mfmsg03.i 670 4 so_fr_list so_site so_curr}
             undo, retry.
          end.
          if old_um <> fr_um and not new_order then do:
             {mfmsg.i 675 2} /* UNIT OF MEASURE HAS CHANGED */
                     if not batchrun then pause.
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

         /* VALIDATION FOR FREIGHT TERMS WITH BLANK FREIGHT LIST       */

            /* VALIDATE so_fr_terms WHEN ENTERED */
            if so_fr_terms <> "" then do:
               find ft_mstr where ft_terms = so_fr_terms no-lock no-error.
               if not available ft_mstr then do :
                  /* INVALID FREIGHT TERMS */
                  {mfmsg03.i 671 3 so_fr_terms """" """"}
                  next-prompt so_fr_terms with frame b1.
                  undo setb1, retry.
               end. /* END OF NOT AVAILABLE ft_mstr */
            end. /* END OF so_fr_terms <> "" */

            /* IF IMPORT EXPORT FLAG IS SET TO YES CALL THE IMPORT EXPORT     */
            /* CREATE ROUTINE TO CREATE ie_mstr ied_det AND UPDATE  ie_mstr   */

            if  impexp then do:
               imp-okay = no.
               hide frame b1.
               {gprun.i ""iemstrcr.p"" "( input ""1"",
                      input so_nbr,
                      input recid(so_mstr),
                      input-output imp-okay )"}
/*GUI*/ if global-beam-me-up then undo, leave.

               if imp-okay = no then do:
                  undo setb1, retry.
               end.
            end.

/*M017*/ /****BEGIN ADDED SECTION******/
            /* IF USING APM, THEN PROMPT USER FOR DIVISION AND CUSTOMER */
            /* RELATIONSHIP INFO */
            for first cm_mstr fields(cm_addr cm_promo)
               no-lock where cm_addr = so_cust: end.
/*GUI*/ if global-beam-me-up then undo, leave.

            if available cm_mstr then do:
               if soc_apm and cm_promo <> "" then do:
                  hide frame b1 no-pause.
                  {gprun.i ""sosoapm1.p"" "(input cm_addr,
                     input so_nbr, output o-error_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  if o-error_flag then do:
                     undo setb1, retry.
                  end.
               end.  /* SOC_APM AND CM_PROMO <> "" */
            end.  /* AVAILABLE CM_MSTR */
/*M017*/ /****END ADDED SECTION***********/

            /* FOR RMA'S, SOME OF THE SO_MSTR FIELDS ARE REPLICATED ON RMA_MSTR */
            /* IF THE USER HAS CHANGED ANY OF THEM, WE NEED TO KEEP RMA_MSTR IN */
            /* SYNC.                                                            */
            if so_fsm_type = "RMA" then do:
                find rma_mstr exclusive-lock where rma_nbr = so_nbr and
                    rma_prefix = "C".
                assign rma_req_date = so_req_date
                    rma_ord_date = so_ord_date
                    rma_exp_date = so_due_date
                    rma_cmtindx  = so_cmtindx
/*M00Q*             rma_curr     = so_curr     */
/*M00Q*             rma_ex_rate  = so_ex_rate  */
                    rma_stat     = so_stat
                    rma_taxc     = so_taxc
                    rma_taxable  = so_taxable.
            end.    /* if so_fsm_type = "RMA" */
         end. /*setb1*/

         hide frame b1 no-pause.
         undo_flag = false.
