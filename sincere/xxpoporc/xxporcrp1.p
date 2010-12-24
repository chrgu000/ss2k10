/* xxporcrp.p - RECEIVER PRINT AND UPDATE                                    */
/*            - copy forom xxporcrp.p                                        */
/* REVISION: 0BYP LAST MODIFIED: 12/01/10   BY: zy                           */
/* Environment: Progress:10.1B   QAD:eb21sp6    Interface:Character          */
/* REVISION END                                                              */

/* DISPLAY TITLE */
{mfdtitle.i "101201.1"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE porcrp_p_6 "Unprinted Receivers Only"
/* MaxLen: Comment: */

&SCOPED-DEFINE porcrp_p_8 "Print Receipt Trailer"
/* MaxLen: Comment: */

&SCOPED-DEFINE porcrp_p_9 "List All Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE porcrp_p_11 "List Work Order Shortages"
/* MaxLen: Comment: */

&SCOPED-DEFINE porcrp_p_12 "Print Approvals"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define new shared variable convertmode as character no-undo.
define new shared variable rndmthd like rnd_rnd_mthd.
define new shared variable oldcurr like po_curr.
/* CORRECT INITIAL TAX TYPE TO INDICATE RECEIPT (21) NOT RETURN (25)*/
define new shared variable tax_tr_type     like tx2d_tr_type no-undo
   initial '21'.
define shared variable nbr like prh_nbr.
define shared variable nbr1 like prh_nbr.
define variable vend like prh_vend.
define variable vend1 like prh_vend.
define variable rcvr like prh_receiver.
define variable rcvr1 like prh_receiver.
define variable rcv_date like prh_rcp_date.
define variable rcv_date1 like prh_rcp_date.
define variable new_only like mfc_logical initial yes.
define variable revision like po_rev.
define variable buyer like po_buyer.
define variable tranqty like tr_qty_chg.
define variable pdate like prh_rcp_date.
define variable pages as integer.
define variable old_receiver like prh_receiver.
define variable location like pt_loc.
define variable det_lines as integer.
define variable vendor as character format "x(38)" extent 6.
define variable vend_phone like ad_phone.
define variable duplicate as character format "x(11)" label "".
define variable newline like mfc_logical initial yes.
define variable continue_yn like mfc_logical initial no.
define variable mc-error-number like msg_nbr no-undo.

define new shared variable prh_recno as recid.

define variable printwo like mfc_logical initial yes.
define variable rmks like po_rmks.
define new shared variable printcmts like mfc_logical initial no.
define variable i as integer.
define variable cont_lbl as character format "x(12)".
define new shared variable tr_count as integer.
define new shared variable print_approval like mfc_logical initial yes
   label {&porcrp_p_12}.
define new shared variable print_trlr like mfc_logical initial no
   label {&porcrp_p_8}.
define new shared variable maint like mfc_logical initial false no-undo.
define new shared variable po_recno as recid. /* USED FOR RCVR NBR */
define new shared variable receivernbr like prh_receiver.
define new shared variable eff_date like glt_effdate.
define buffer prhhist for prh_hist.
define new shared variable fiscal_id      like prh_receiver.
define new shared variable fiscal_rec     as logical initial false.
define new shared variable msg            as character format "x(60)".

define variable oldsession as character no-undo.
define variable l_prh_recno as recid no-undo.

define variable err-flag as integer no-undo.
define variable old_db like si_db no-undo.

assign cont_lbl = "*** " + getTermLabel("CONTINUE",4) + " ***".
find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock no-error.

{pocurvar.i "NEW"}
{txcurvar.i "NEW"}
/* DEFINE TRAILER VARS AS NEW, SO THAT CORRECT _OLD FORMATS */
/* CAN BE ASSIGNED BASED ON INITIAL DEFINE                  */
{potrldef.i "NEW"}
assign
   nontax_old         = nontaxable_amt:format
   taxable_old        = taxable_amt:format
   lines_tot_old      = lines_total:format
   tax_tot_old        = tax_total:format
   order_amt_old      = order_amt:format
   prepaid_old        = po_prepaid:format.

form
   nbr            colon 15
   nbr1           label {t001.i} colon 49
   rcvr           colon 15
   rcvr1          label {t001.i} colon 49
   vend           colon 15
   vend1          label {t001.i} colon 49
   rcv_date       colon 15
   rcv_date1      label {t001.i} colon 49
   skip(1)
   new_only       colon 30 label {&porcrp_p_6}
   printcmts      colon 30 label {&porcrp_p_9}
   print_approval colon 30
   printwo        colon 30 label {&porcrp_p_11}
   print_trlr     colon 30
with frame a attr-space side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

convertmode = "REPORT".

view frame a.
find first poc_ctrl  where poc_ctrl.poc_domain = global_domain no-lock no-error.
if available poc_ctrl and poc_rcv_typ = 0 then do:
   continue_yn = no.
   bell.
   {mfmsg01.i 353 2 continue_yn}
   if continue_yn = no then leave.
end.

assign
   rcv_date   = today
   rcv_date1  = today
   oldcurr    = ""
   oldsession = SESSION:numeric-format.

repeat:
   if nbr1 = hi_char then nbr1 = "".
   if rcvr1 = hi_char then rcvr1 = "".
   if vend1 = hi_char then vend1 = "".
   if rcv_date = low_date then rcv_date = ?.
   if rcv_date1 = hi_date then rcv_date1 = ?.

   update
      nbr nbr1 rcvr rcvr1 vend vend1 rcv_date rcv_date1 new_only
      printcmts print_approval printwo
      print_trlr
   with frame a.

   bcdparm = "".
   {mfquoter.i nbr}
   {mfquoter.i nbr1}
   {mfquoter.i rcvr}
   {mfquoter.i rcvr1}
   {mfquoter.i vend}
   {mfquoter.i vend1}
   {mfquoter.i rcv_date}
   {mfquoter.i rcv_date1}
   {mfquoter.i new_only}
   {mfquoter.i printcmts}
   {mfquoter.i print_approval}
   {mfquoter.i printwo}
   {mfquoter.i print_trlr}

   if nbr1 = "" then nbr1 = hi_char.
   if rcvr1 = "" then rcvr1 = hi_char.
   if vend1 = "" then vend1 = hi_char.
   if rcv_date = ? then rcv_date = low_date.
   if rcv_date1 = ? then rcv_date1 = hi_date.

   /* SELECT PRINTER */
   {mfselbpr.i "printer" 80}

   assign
      pages = 0
      pdate = today
      old_receiver = ?.

   for each prh_hist no-lock
      where prh_hist.prh_domain = global_domain
      and   ((prh_nbr          >= nbr)
      and   (prh_nbr           <= nbr1)
      and   (prh_receiver      >= rcvr)
      and   (prh_receiver      <= rcvr1)
      and   (prh_vend          >= vend)
      and   (prh_vend          <= vend1)
      and   (prh_rcp_date      >= rcv_date)
      and   (prh_rcp_date      <= rcv_date1)
      and   (prh_print = yes   or not new_only))
   use-index prh_rcp_date
   break by prh_receiver by prh_nbr by prh_line:

      if (oldcurr <> prh_curr) or (oldcurr = "") then do:

         if prh_curr = gl_base_curr then
            rndmthd = gl_rnd_mthd.
         else do:
            /* GET ROUNDING METHOD FROM CURRENCY MASTER */
            {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
               "(input prh_curr,
                        output rndmthd,
                        output mc-error-number)"}
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}
               if c-application-mode <> "WEB" then
                  pause.
               next.
            end.
         end.

         /* DETERMINE CURRENCY DISPLAY AMERICAN OR EUROPEAN        */
         find rnd_mstr  where rnd_mstr.rnd_domain = global_domain and
         rnd_rnd_mthd = rndmthd no-lock no-error.
         if not available rnd_mstr then do:
            {pxmsg.i &MSGNUM=863 &ERRORLEVEL=4}  /* ROUND METHOD RECORD NOT FOUND */
            next.
         end.
         /* IF RND_DEC_PT = COMMA FOR DECIMAL POINT */
         /* THIS IS A EUROPEAN STYLE CURRENCY */
         if (rnd_dec_pt = "," )
            then SESSION:numeric-format = "European".
         else SESSION:numeric-format = "American".
         {pocurfmt.i}
         oldcurr = prh_curr.
      end.

      assign
         prh_recno = recid(prh_hist)
         duplicate = ""
         revision  = 0
         buyer     = ""
         rmks      = "".

      if prh_print = no then
      duplicate = "*" + caps(getTermLabel("DUPLICATE",9)) + "*".

      find po_mstr  where po_mstr.po_domain = global_domain and  po_nbr =
      prh_nbr no-lock no-error.
      if available po_mstr then
      assign
         revision = po_rev
         buyer    = po_buyer
         rmks     = po_rmks.

      assign vendor = "".
      find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr =
      prh_vend
         no-lock no-wait no-error.
      if available ad_mstr then do:
         assign
            vendor[1]  = ad_name
            vendor[2]  = ad_line1
            vendor[3]  = ad_line2
            vendor[4]  = ad_line3
            vendor[6]  = ad_country
            vend_phone = ad_phone.
         {mfcsz.i vendor[5] ad_city ad_state ad_zip}
         {mfaddr.i
            vendor[1]
            vendor[2]
            vendor[3]
            vendor[4]
            vendor[5]
            vendor[6]}.
      end.

      form header

         getTermLabel("R_E_C_E_I_V_E_R",20)   at 33 format "x(20)"
         getTermLabelRtColon("PAGE_OF_REPORT",8) to 62
         string(page-number - pages)
         duplicate           at 68

         getTermLabel("SUPPLIER",15) + ": " +
         prh_vend at 11 format "x(25)"
         getTermLabelRtColon("RECEIVER",20) to 68 format "x(20)"
         prh_receiver
         vendor[1]           at 11

         getTermLabelRtColon("RECEIPT_DATE",18) to 68 format "x(18)"
         prh_rcp_date
         vendor[2]           at 11

         getTermLabelRtColon("PRINT_DATE",18) to 68 format "x(18)"
         pdate
         vendor[3]           at 11

         getTermLabelRtColon("PURCHASE_ORDER",18) to 68 format "x(18)"
         prh_nbr
         vendor[4]           at 11

         getTermLabelRtColon("PURCHASE_ORDER_REVISION",18) to 68 format "x(18)"
         revision
         vendor[5]           at 11
         vendor[6]           at 11
         vend_phone          at 11

         getTermLabelRtColon("SHIP_DATE",18) to 68 format "x(18)"
         prh_ship_date
         skip

         getTermLabel("PACKING_SLIP",25) + ": " +
         prh_ps_nbr  at 11 format "x(39)"
         getTermLabel("REMARKS",25) + ": " +
         rmks at 11 format "x(67)"
         skip(1)
      with frame phead1 page-top width 80.
      view frame phead1.

      if first-of (prh_receiver) then do:
         assign
            pages        = page-number - 1
            old_receiver = prh_receiver.

         old_db = global_db.
         find first pod_det  where pod_det.pod_domain = global_domain and
         pod_nbr = po_nbr no-lock no-error.
         if available pod_det then do:
            if global_db <> pod_po_db then do:
               {gprun.i ""gpalias3.p"" "(pod_po_db, output err-flag)" }
            end.
         end. /* IF AVAILABLE POD_DET */

         if available po_mstr then do:
            /* PRINT ALL COMMENTS */
            if printcmts then do:
               {gprun.i ""pohdcmt.p"" "(input po_nbr, input 'RP' )"}
            end. /* IF PRINTCMTS */
            /* PRINT RECEIVER COMMENTS ONLY */
            else do:
               {gprun.i ""pohdcmt.p"" "(input po_nbr, input 'RC' )"}
            end. /* ELSE */
         end. /* IF AVAILABLE PO_MSTR */

         if old_db <> global_db then do:
            {gprun.i ""gpalias3.p"" "(old_db, output err-flag)" }
         end. /* IF OLD_DB <> GLOBAL_DB */

      end. /* IF FIRST-OF (PRH_RECEIVER) */

      /* DISPLAY PO RECEIPT LINE INFORMATION */
      {gprun.i ""porcrpb.p""}

      /* DISPLAY TRANSACTION HISTORY DETAIL FOR LOT/SERIAL NBRS */
      if tr_count > 1 then do:
         prh_recno = recid(prh_hist).
         {gprun.i ""porcrpc.p""}

      end.  /* (IF TR_COUNT > 1) */

      if printwo then do:
         l_prh_recno = recid(prh_hist).
         {gprun.i ""porcrpwo.p"" "(prh_part,l_prh_recno)"}

      end.

      {mfrpexit.i}

      /* TRAILER */
      if last-of(prh_receiver) and print_trlr then do:
         find po_mstr  where po_mstr.po_domain = global_domain and  po_nbr =
         prh_nbr no-lock.
         assign
            undo_trl2   = true
            po_recno    = recid(po_mstr)
            receivernbr = prh_receiver.

         {gprun.i ""porctrl2.p""}
         if undo_trl2 then undo, leave.
      end.
      else
         if page-size - line-counter < 4 then page.
      put skip (1).
      /*V8-*/
      /*H0J4
      * /*H090*/       if last-of (prh_receiver) then
      * /*H090*/          display skip(1) "End of Report" at 33
      * /*H090*/          with frame rfoot width 132.
      *H0J4*/
      /*V8+*/
      if not last(prh_receiver) and
         last-of (prh_receiver) then do:
         page.
         assign
            pdate        = today
            old_receiver = ?.
      end.

      find prhhist where recid(prhhist) = prh_recno exclusive-lock.
      /* CHANGE PRINT FLAG TO "NO" */
      if available prhhist then
         prhhist.prh_print = no.

   end.
   /* End Processing prh_hist */
   {mfreset.i}

end.
SESSION:numeric-format = oldsession.
