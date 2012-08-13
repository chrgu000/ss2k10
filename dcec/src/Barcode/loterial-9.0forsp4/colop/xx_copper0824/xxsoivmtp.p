/* xxsoivmtp.p - INVOICE MAINTENANCE HEADER FRAME b                       */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.44 $                                                    */
/*V8:ConvertMode=Maintenance                                            */
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
/* REVISION: 9.1      LAST MODIFIED: 09/08/99   BY: *N02P* Robert Jensen  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 05/15/00   BY: *N0BC* Arul Victoria    */
/* REVISION: 9.1      LAST MODIFIED: 06/28/00   BY: *N0DM* Mudit Mehta      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb              */
/* REVISION: 9.1      LAST MODIFIED: 10/13/00   BY: *N0W8* Mudit Mehta      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.37     BY: Katie Hilbert  DATE: 04/01/01 ECO: *P002* */
/* Revision: 1.39     BY: Sandeep P.     DATE: 07/02/01 ECO: *M1CV* */
/* Revision: 1.41     BY: Rajiv Ramaiah  DATE: 08/31/01 ECO: *M1JT* */
/* Revision: 1.42     BY: Jeff Wootton   DATE: 09/21/01 ECO: *P01H* */
/* Revision: 1.43     BY: Hareesh V.     DATE: 03/18/02 ECO: *M1WS* */
/* $Revision: 1.44 $    BY: Ashish M.    DATE: 05/20/02 ECO: *P04J* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "SOIVMTP.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE soivmtp_p_1 "Perform Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivmtp_p_2 "Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivmtp_p_3 "Line Pricing"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivmtp_p_4 "Display Weights"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivmtp_p_5 "Calculate Freight"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define shared variable rndmthd like rnd_rnd_mthd.
define shared variable oldcurr like so_curr.
define shared variable so_recno as recid.
define shared variable undo_flag like mfc_logical.
define shared variable new_order like mfc_logical initial no.
define shared variable perform_date as date label "Perform Date".
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
define shared variable exch_rate2 like exr_rate2.
define shared variable exch_ratetype like exr_ratetype.
define shared variable exch_exru_seq like exru_seq.
define shared variable del-yn like mfc_logical.
define shared variable disp_fr  like mfc_logical
   label {&soivmtp_p_4}.
define shared variable socrt_int like sod_crt_int.
define shared variable impexp          like mfc_logical no-undo.
define shared variable reprice         like mfc_logical.
define shared variable picust          like cm_addr.
define shared variable line_pricing like pic_so_linpri
   label {&soivmtp_p_3}.

define        variable old_fr_terms like so_fr_terms.
define        variable soc_pt_req      like mfc_logical.
define        variable imp-okay        like mfc_logical no-undo.
define        variable old_slspsn as character format "x(8)" no-undo.
define        variable old_comm_pct  as decimal
              format ">>9.99" no-undo.
define        variable l_up_comm    like mfc_logical no-undo.
define        variable mc-error-number like msg_nbr no-undo.
define        variable o-error_flag like mfc_logical no-undo.

/* THESE HANDLE FIELDS ARE USED TO GIVE RMA'S DIFFERENT LABELS */
define        variable hdl-req-date     as   handle.
define        variable hdl-due-date     as   handle.
define        variable l_old_pricing_dt like so_pricing_dt no-undo.

define        variable l_old_channel like so_channel no-undo.
define        variable l_so_db       like global_db  no-undo.
define        variable l_err_flag    as   integer    no-undo.

define temp-table tmp_db no-undo
   field tmp_db_name like si_db.

define shared frame a.
/*V8+*/
define shared frame b.
define shared frame b1.

define buffer somstr for so_mstr.

/* Logistics Table definition */
{lgivdefs.i &type="lg"}

{pppivar.i}     /* SHARED PRICING VARIABLES */

{gptxcdec.i}    /* DECLARATIONS FOR gptxcval.i */

/* DEFINE VARIABLES USED IN GPGLEF1.P (GL CALENDAR VALIDATION) */
{gpglefv.i}

{xxsoivmt02.i}    /* Define shared frame b and b1 */

/*V8+*/

find so_mstr where recid(so_mstr) = so_recno.
find first soc_ctrl no-lock.
find first iec_ctrl no-lock no-error.
find first pic_ctrl no-lock no-error.

/* IF WE'RE DEALING WITH RMA'S, CHANGE THESE LABELS:       */
/* SO_REQ_DATE GOES FROM REQUIRED DATE TO DUE DATE         */
/* SO_DUE_DATE GOES FROM DUE DATE TO EXPECTED DATE         */
if  so_fsm_type = "RMA" then
assign
   hdl-req-date       = so_req_date:handle
   hdl-req-date:label = getTermLabel("DUE_DATE",14)
   hdl-due-date       = so_due_date:handle
   hdl-due-date:label = getTermLabel("EXPECTED_DATE",14).
else
   view frame b.

reprice = no.
display reprice with frame b.

if new_order then
   line_pricing = pic_so_linpri.
else
   line_pricing = no.
display line_pricing with frame b.

l_old_pricing_dt = so_pricing_dt.

setb:
/* FOR RMA'S, THE USER CANNOT UPDATE INVENTORY RELATED FIELDS HERE */
do on error undo, retry with frame b:
/*GUI*/ if global-beam-me-up then undo, leave.


   l_old_channel = so_channel.
   /* For Logistics Orders, read from table, not the screen */
   if not lgData then do:

      set so_ord_date
         so_req_date
         so_due_date
         perform_date
         so_pricing_dt
         so_po
         so_rmks
         line_pricing when (new_order)
         so_pr_list so_site so_channel so_project
         so_ship_date
         so_curr when (new_order)
         so_lang so_taxable so_taxc so_tax_date
         so_fix_pr
         so_cr_terms
         socrt_int
         reprice when (not new_order)
         go-on ("F5" "CTRL-D") with frame b
      editing:
         /* DISPLAY INTEREST AFTER ENTERING CREDIT TERMS */
         readkey.

         if frame-field   = "so_pricing_dt"
         then do:

            if (keyfunction(lastkey) = "TAB"
            or  keyfunction(lastkey) = "GO"
            or  keyfunction(lastkey) = "CURSOR-DOWN"
            or  keyfunction(lastkey) = "CURSOR-UP"
            or  keyfunction(lastkey) = "RETURN")
            then do:

               if  not new so_mstr
               and (so_fsm_type = "" or
                    so_fsm_type = "RMA")
               and input so_pricing_dt <> l_old_pricing_dt
               and (can-find(mfc_ctrl
                             where mfc_field   = "soc_pc_line"
                             and   mfc_logical = no))
               then do:

                  reprice = yes.

                  display
                     reprice
                  with frame b.

               end. /* IF NOT NEW so_mstr ... */
            end. /* IF (KEYFUNCTION(LASTKEY) = "TAB" ... */
         end. /* IF FRAME-FIELD = "so_pricing_dt" */

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

      /* UPDATE THE LINE ITEM PRICING DATE WITH THE HEADER PRICING DATE. */
      /* FOR RMA ORDERS, ONLY ISSUE LINE ARE UPDATED.                    */
      if  not new so_mstr
      and (so_fsm_type   =  "" or
           so_fsm_type   =  "RMA")
      and  so_pricing_dt <> l_old_pricing_dt
      and (can-find(mfc_ctrl
                    where mfc_field   = "soc_pc_line"
                    and   mfc_logical = no))
      then do:

         reprice = yes.

         display
            reprice
         with frame b.

         for each sod_det
            where sod_nbr      = so_nbr
            and  (sod_rma_type = "" or
                  sod_rma_type = "O")
         exclusive-lock:
            sod_pricing_dt = so_pricing_dt.
         end. /* FOR EACH sod_det */

      end. /* IF NOT NEW so_mstr ... */

   end. /* if not lgData */
   /* Let setLogHeader set the data */
   else run setLogHeader.

   /* ADDING LOGIC TO COMMUNICATE CHANNEL CHANGES TO THE */
   /* REMOTE DATABASES IN A MULTI-DB ENVIRONMENT.        */

   for each tmp_db
      exclusive-lock:
      delete tmp_db.
   end. /* FOR EACH tmp_db */

   if not new so_mstr
      and so_channel <> l_old_channel
   then do:

      l_so_db  = global_db.

      for each sod_det
         fields(sod_nbr sod_site)
         where sod_nbr = so_nbr
         no-lock:

         for first si_mstr
            fields(si_db si_site)
            where si_site =  sod_site
            and   si_db   <> l_so_db
            no-lock:
         end. /* FOR FIRST si_mstr */
         if available si_mstr
         then do:
            if not can-find(first tmp_db
               where tmp_db_name = si_db)
            then do:
               create tmp_db.
               tmp_db_name = si_db.
            end. /* IF NOT CAN-FIND FIRST tmp_db... */
         end. /* IF AVAILABLE si_mstr */
      end. /* FOR EACH sod_det */

      for each tmp_db
         no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


         {gprun.i ""gpalias3.p""
            "(input  tmp_db_name,
              output l_err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         /* SOSOMTP1.P CALLED TO PROPAGATE CHANNEL */
         /* DETAILS TO REMOTE DATABASE */
         if    l_err_flag = 0
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

   if input so_cr_terms <> ""
   then do:
      find first ct_mstr where ct_code = input so_cr_terms
         no-lock no-error.
      if not available ct_mstr then do:
         /* CREDIT TERM CODE MUST EXIST OR BE BLANK */
         {pxmsg.i &MSGNUM=840 &ERRORLEVEL=3}
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
         {pxmsg.i &MSGNUM=1277 &ERRORLEVEL=3}
         next-prompt line_pricing.
         undo setb, retry setb.
      end.
   end. /* IF NOT LINE_PRICING */

   so_recno = recid(so_mstr).

   /* Get the exchange rate from the so_mstr  */
   /* Value is passed to mfivtr.i             */
   assign
      exch_rate = so_ex_rate
      exch_rate2 = so_ex_rate2.

   /* DO NOT ALLOW THE USER TO DELETE RMA'S HERE */
   if so_fsm_type = " " then
   /* DELETE */
   if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
   then do:
      del-yn = yes.
      {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}

      if del-yn = no then
      undo setb,
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
   /* ALSO CHECK INVOICE HISTORY */
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
            {pxmsg.i &MSGNUM=624 &ERRORLEVEL=2}
            if not batchrun then pause.
         end.
      end.
      else do: /* so_po was left blank */

         if so_fsm_type = " " and (not so_sched) then do:
            /* SO_FSM_TYPE IS BLANK FOR NORMAL SALES ORDERS */
            find cm_mstr where cm_addr = so_cust no-lock no-error.
            if available cm_mstr then
               if cm_po_reqd then do:
                  {pxmsg.i &MSGNUM=631 &ERRORLEVEL=3}
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
                     {pxmsg.i &MSGNUM=322 &ERRORLEVEL=3}
                    /* P.O. NUMBER IS REQUIRED FOR THIS END USER */
                     next-prompt so_po.
                     undo, retry.
                  end.
            end.    /* if available rma_mstr */
         end.    /* else do */
      end.   /* else do */

      /* UPDATE ALL LINE ITEMS WITH THE SO HEADER P. O. NUMBER */

      if not new_order and so_fsm_type = " " and not so_sched then do:
         for each sod_det where sod_det.sod_nbr = so_mstr.so_nbr
               exclusive-lock:
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

      {gprun.i ""gpsiver.p""
         "(input so_site, input ?, output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

      if return_int = 0 then do:
         {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
         /* USER DOES NOT HAVE ACCESS TO THIS SITE */
         next-prompt so_site with frame b.
         undo, retry.
      end.

      /* EXCHANGE RATE CALCULATED FIRST TIME ONLY */
      if new so_mstr and so_curr <> base_curr then do:

         /* Validate currency */
         {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
            "(input  so_curr,
              output mc-error-number)" }
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
            next-prompt so_curr.
            undo setb, retry setb.
         end.

         /* Calculate exchange rate & create usage records */
         {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                  "(input  so_curr,
                    input  base_curr,
                    input  so_ex_ratetype,
                    input  so_ord_date,
                    output so_ex_rate,
                    output so_ex_rate2,
                    output so_exru_seq,
                    output mc-error-number)" }
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
            next-prompt so_curr.
            undo setb, retry setb.
         end.

      end.  /* if new so_mstr */

      if (oldcurr <> so_curr) or (oldcurr = "") then do:

         /** GET ROUNDING METHOD FROM CURRENCY MASTER **/
         {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
            "(input so_curr,
              output rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
            next-prompt so_curr.
            undo setb, retry setb.
         end. /* if mc-error-number <> 0 */
      end. /* IF (OLDCURR <> SO_CURR) */

      /* VALIDATE TAX CODE */
      {gptxcval.i &code=so_mstr.so_taxc  &frame="b"}

      /* SET EXCHANGE RATE */
      /* Allow change to exrate only when new because tr_hist created */
      if new so_mstr then do:
         {gprunp.i "mcui" "p" "mc-ex-rate-input"
               "(input        so_curr,
                 input        base_curr,
                 input        so_ord_date,
                 input        so_exru_seq,
                 input        true, /* update fixed-rate field */
                 input        frame-row(b) + 4,
                 input-output so_ex_rate,
                 input-output so_ex_rate2,
                 input-output so_fix_rate)"}
      end.  /* if new so_mstr */

      /* Use Order header exchange rate for bookings; use      */
      /* Tr_hist exchange rate for shipments unless fixed rate */

      if so_mstr.so_fix_rate = no then do:

         /* GET EXCHANGE RATE FOR BASE TO ACCOUNT CURRENCY */
         {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                "(input  so_curr,
                  input  base_curr,
                  input  so_ex_ratetype,
                  input  so_ship_date,
                  output exch_rate,
                  output exch_rate2,
                  output mc-error-number)" }
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            if new so_mstr then next-prompt so_curr.
            else next-prompt so_ship_date.
            undo setb, retry setb.
         end. /* mc-error-number <> 0 */

      end.  /* so_fix_rate = no */
      else
      assign
         exch_rate  = so_mstr.so_ex_rate
         exch_rate2 = so_mstr.so_ex_rate2.

      if not lgData then do:
         /* GET HEADER TAX DATA */
         undo_soivmtb = true.
         {&SOIVMTP-P-TAG1}
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
               {pxmsg.i &MSGNUM=6212 &ERRORLEVEL=2
                        &MSGARG1=socrt_int
                        &MSGARG2=ct_terms_int}
               /* Entered terms interest # does not match ct interest # */
               del-yn = yes.
               if not batchrun then do:
                  {pxmsg.i &MSGNUM=8500 &ERRORLEVEL=2 &CONFIRM=del-yn}
                  /* Do you wish to continue? */
                  if not del-yn then do:
                     next-prompt socrt_int.
                     undo, retry.
                  end.
               end.
            end.
         end.
      end.
      so__qad02 = socrt_int.
      undo_flag = false.

   end. /*setb*/
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
   {&SOIVMTP-P-TAG2}

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
         and fr_curr = base_curr
         no-lock no-error.
      if available fr_mstr then do:
         old_um = fr_um.
         if so_weight_um = "" then so_weight_um = fr_um.
      end.

      if not lgData then do:
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
            display so_comm_pct[1] with frame b1.
            pause 0.
         end.
         /* WHEN SALESPERSON IS CHANGED PROMPT THE USER TO DEFAULT THE NEW */
         /* SALESPERSON'S COMMISSION PERCENT.                              */
         if input so_slspsn[1] <> old_slspsn      and
            input so_comm_pct[1] =  old_comm_pct  and
            input so_slspsn[1]  <> ""             and
            not batchrun  then do:
            find sp_mstr where sp_addr = input so_slspsn[1] no-lock no-error.
            if input so_comm_pct[1] <> sp_comm_pct then do:
               {pxmsg.i &MSGNUM=1396 &ERRORLEVEL=1 &CONFIRM=l_up_comm}
               /* Salesperson changed. Update default commission? */
               if l_up_comm then do:
                  so_comm_pct[1] = sp_comm_pct.
                  display so_comm_pct[1] with frame b1.
                  pause 0.
               end.
            end.
         end.

         if mult_slspsn then do:
            {gprun.i ""soivsls.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

            if keyfunction(lastkey) = "end-error" then
               undo, retry setb1.
         end.

      end. /* if not lgData */

      /* Validate Freight list */
      if so_fr_list <> "" then do:
         find fr_mstr where fr_list = so_fr_list and
            fr_site = so_site and fr_curr = so_curr no-lock no-error.
         if not available fr_mstr then
            find fr_mstr where fr_list = so_fr_list and
            fr_site = so_site and fr_curr = base_curr no-lock no-error.
         if not available fr_mstr then do:
            /* FREIGHT LIST # NOT FOUND FOR SITE # CURRENCY */
            {pxmsg.i &MSGNUM=670 &ERRORLEVEL=4
                     &MSGARG1=so_fr_list
                     &MSGARG2=so_site
                     &MSGARG3=so_curr}
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
               and fr_curr = base_curr
               no-lock no-error.
            if not available fr_mstr then do:
               /* FREIGHT LIST # NOT FOUND FOR SITE # CURRENCY */
               {pxmsg.i &MSGNUM=670 &ERRORLEVEL=4
                        &MSGARG1=so_fr_list
                        &MSGARG2=so_site
                        &MSGARG3=so_curr}
               undo, retry.
            end.
            if old_um <> fr_um and not new_order then do:
               {pxmsg.i &MSGNUM=675 &ERRORLEVEL=2}
               /* UNIT OF MEASURE HAS CHANGED */
               if not batchrun then pause.
            end.
         end.

         if so_fr_terms <> ""
            or (so_fr_terms = "" and calc_fr) then do:
            find ft_mstr where ft_terms = so_fr_terms no-lock no-error.
            if not available ft_mstr then do:
               /* Invalid Freight Terms */
               {pxmsg.i &MSGNUM=671 &ERRORLEVEL=3 &MSGARG1=so_fr_terms}
               next-prompt so_fr_terms with frame b1.
               undo setb1, retry.
            end.
         end.

         if so_fr_terms <> old_fr_terms
            and not new_order and not calc_fr
         then do:
            /* CALCULATION REQUIRED WHEN FREIGHT TERMS CHANGE */
            {pxmsg.i &MSGNUM=681 &ERRORLEVEL=1}
            next-prompt calc_fr with frame b1.
            undo setb1, retry.
         end.

      end.  /* Freight Parameters */

      /* VALIDATION FOR FREIGHT TERMS WITH BLANK FREIGHT LIST       */

      /* VALIDATE so_fr_terms WHEN ENTERED */
      if so_fr_terms <> "" then do:
         find ft_mstr where ft_terms = so_fr_terms no-lock no-error.
         if not available ft_mstr then do:
            /* INVALID FREIGHT TERMS */
            {pxmsg.i &MSGNUM=671 &ERRORLEVEL=3 &MSGARG1=so_fr_terms}
            next-prompt so_fr_terms with frame b1.
            undo setb1, retry.
         end. /* END OF NOT AVAILABLE ft_mstr */
      end. /* END OF so_fr_terms <> "" */

      {&SOIVMTP-P-TAG3}
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
      {&SOIVMTP-P-TAG4}

      /* IF USING APM, THEN PROMPT USER FOR DIVISION AND CUSTOMER */
      /* RELATIONSHIP INFO */
      for first cm_mstr fields(cm_addr cm_promo)
            no-lock where cm_addr = so_cust:
      end.
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

      /* FOR RMA'S, SOME OF THE SO_MSTR FIELDS ARE REPLICATED ON RMA_MSTR */
      /* IF THE USER HAS CHANGED ANY OF THEM, WE NEED TO KEEP RMA_MSTR IN */
      /* SYNC.                                                            */
      if so_fsm_type = "RMA" then do:
         find rma_mstr exclusive-lock where rma_nbr = so_nbr and
            rma_prefix = "C".
         assign
            rma_req_date = so_req_date
            rma_ord_date = so_ord_date
            rma_exp_date = so_due_date
            rma_cmtindx  = so_cmtindx
            rma_stat     = so_stat
            rma_taxc     = so_taxc
            rma_taxable  = so_taxable.
      end.    /* if so_fsm_type = "RMA" */
   end. /*setb1*/

   if so_fr_terms <> old_fr_terms
   then
      so_manual_fr_terms = yes.

   hide frame b1 no-pause.
   undo_flag = false.

PROCEDURE setLogHeader:
/* Internal procedure to set Logistics data for the header */
   /* Get the info from the Logistics Table */
   for first lgi_lgmstr no-lock:
      if lgi_so_cr_terms <> "" then do:
         so_mstr.so_cr_terms = lgi_so_cr_terms.
         find first ct_mstr where ct_code = so_cr_terms
            no-lock no-error.
         if available ct_mstr then socrt_int = ct_terms_int.
         else do:
            /* CREDIT TERM CODE MUST EXIST OR BE BLANK */
            {pxmsg.i &MSGNUM=840 &ERRORLEVEL=4}
            undo, return.
         end.
      end.
      if lgi_so_due_date <> date("") then
         so_due_date = lgi_so_due_date.
      if lgi_so_pricing_dt <> date("") then
         so_pricing_dt = lgi_so_pricing_dt.
   end.
end.
