/* porvrp01.p - PURCHASE ORDER RTV PRINT MAIN SUBROUTINE                */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.11.1.14.3.1 $                                                        */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 6.0     LAST MODIFIED: 08/10/90    BY: RAM *D030*          */
/* REVISION: 6.0     LAST MODIFIED: 11/02/90    BY: PML *D171*          */
/* REVISION: 6.0     LAST MODIFIED: 01/18/91    BY: RAM *D306*          */
/* REVISION: 6.0     LAST MODIFIED: 10/03/91    BY: RAM *D890*          */
/* REVISION: 6.0     LAST MODIFIED: 11/07/91    BY: RAM *D913*          */
/* REVISION: 6.0     LAST MODIFIED: 01/07/92    BY: RAM *D979*          */
/* REVISION: 7.0     LAST MODIFIED: 02/03/92    BY: RAM *F144*          */
/* REVISION: 7.3     LAST MODIFIED: 09/24/92    BY: tjs *G088*          */
/* REVISION: 7.3     LAST MODIFIED: 04/09/93    BY: afs *G926*          */
/* REVISION: 7.3     LAST MODIFIED: 07/06/94    BY: afs *FP27*          */
/*           7.3                    11/11/94    BY: bcm *GO37*          */
/* REVISION: 7.3     LAST MODIFIED: 03/14/95    By: DZN *G0G8*          */
/* REVISION: 7.4     LAST MODIFIED: 05/31/95    By: jym *G0NR*          */
/* REVISION: 8.5     LAST MODIFIED: 10/23/95    By: taf *J053*          */
/* REVISION: 8.5     LAST MODIFIED: 02/14/96    By: rxm *H0JJ*          */
/* REVISION: 8.5     LAST MODIFIED: 07/18/96    BY: taf *J0ZS*          */
/* REVISION: 8.5     LAST MODIFIED: 02/13/97    BY: *G2KZ* Aruna Patil  */
/* REVISION: 8.5     LAST MODIFIED: 04/29/97    BY: *H0YN* Ajit Deodhar */
/* REVISION: 8.5     LAST MODIFIED: 11/06/97    BY: *J25J* Mandar Kapshikar */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane    */
/* REVISION: 8.6E    LAST MODIFIED: 03/06/98    BY: *J2FM* Samir Bavkar */
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E    LAST MODIFIED: 06/11/98    BY: *L020* Charles Yen  */
/* REVISION: 9.1     LAST MODIFIED: 08/14/98    BY: *N01P* Steve Nugent */
/* REVISION: 9.1     LAST MODIFIED: 07/29/99    BY: *N01B* John Corda   */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1     LAST MODIFIED: 09/04/00    BY: *N0RC* Mark Brown   */
/* REVISION: 9.1     LAST MODIFIED: 08/17/00    BY: *N0KM* Mudit Mehta  */
/* REVISION: 9.1     LAST MODIFIED: 01/12/01    BY: *N0VL* Manish K.    */
/* Old ECO marker removed, but no ECO header exists *F0PN*              */
/* Revision: 1.11.1.9   BY: Katie Hilbert  DATE: 04/01/01 ECO: *P002*   */
/* Revision: 1.11.1.12  BY: Katie Hilbert  DATE: 04/17/01 ECO: *P00P*   */
/* Revision: 1.11.1.13  BY: Rajaneesh S.   DATE: 05/31/01 ECO: *N0ZC*   */
/* Revision: 1.11.1.14  BY: Steve Nugent   DATE: 04/17/02 ECO: *P043*   */
/* $Revision: 1.11.1.14.3.1 $         BY: Rajaneesh S.   DATE: 09/12/03 ECO: *N2KY*   */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:DontRefreshTitle=d */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */


/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE porvrp01_p_6 "Unit Cost"
/* MaxLen: Comment: */

&SCOPED-DEFINE porvrp01_p_7 "Return Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE porvrp01_p_19 "Print Receipt Trailer"
/* MaxLen: Comment: */

&SCOPED-DEFINE porvrp01_p_20 "Pack Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE porvrp01_p_24 "Extended Cost"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* PARAMETER TO FACILITATE DISPLAY OF "SIMULATION" */
/* TEXT IN REPORT HEADER                           */

define input parameter update_yn like mfc_logical no-undo.

/* NEW SHARED VARIABLES, BUFFERS AND FRAMES */
define new shared variable rndmthd     like rnd_rnd_mthd.
define new shared variable prh_recno   as recid.
define new shared variable addr        as character
   format "x(38)" extent 6.
define new shared variable tax_tr_type like tx2d_tr_type no-undo
   initial "25".
define new shared variable maint like  mfc_logical initial false
   no-undo.
define new shared variable po_recno as recid. /* USED FOR RCVR NBR */
define new shared variable receivernbr like prh_receiver.
define new shared variable eff_date    like glt_effdate.
define new shared variable fiscal_id   like prh_receiver.
define new shared variable fiscal_rec  as logical initial false.
define new shared variable convertmode as character no-undo.

/* SHARED VARIABLES, BUFFERS AND FRAMES */
define     shared variable nbr         like prh_nbr.
define     shared variable nbr1        like prh_nbr.
define     shared variable vend        like prh_vend.
define     shared variable vend1       like prh_vend.
define     shared variable buyer       like prh_buyer.
define     shared variable buyer1      like prh_buyer.
define     shared variable rcp_date    like prh_rcp_date.
define     shared variable rcp_date1   like prh_rcp_date.
define     shared variable new_only    like mfc_logical.
define     shared variable print_bill  like mfc_logical.
define     shared variable print_trlr  like mfc_logical initial no
   label {&porvrp01_p_19}.
define     shared variable msg         as character format "x(60)".
define     shared variable print_lotserials like mfc_logical.

/* LOCAL VARIABLES, BUFFERS AND FRAMES */
define            variable pages       as integer.
define            variable old_prh_nbr like prh_nbr.
define            variable location    like pt_loc.
define            variable i           as integer.
define            variable billto      as character
   format "x(38)" extent 6.
define            variable vendor      as character
   format "x(38)" extent 6.
define            variable shipto      as character
   format "x(38)" extent 6.
define            variable duplicate   as character
   format "x(11)" label "".
define            variable vend_phone  like ad_phone.
define            variable contact     like po_contact.
define            variable cr_terms    like po_cr_terms.
define            variable shipvia     like po_shipvia.
define            variable fob         like po_fob.
define            variable rmks        like po_rmks.
define            variable terms       like ct_desc.
define            variable dup-lbl     as character format "x(10)".
define            variable prepaid-lbl as character format "x(17)".
define            variable signature-lbl as character format "x(34)".
define            variable by-lbl      as character format "x(3)".
define            variable unit_cost   like prh_pur_cost
   format "->>>>>>9.99<<<".
define            variable ext_cost    like prh_pur_cost
   format "(z,zzz,zzz,zz9.99)".
define            variable desc1       as character format "x(49)".
define            variable desc2       as character format "x(49)".
define            variable qty_open    like prh_rcvd
   format "->>>>>>9.9<<<<<<".
define            variable det_lines   as integer.
define            variable mfgr        like vp_mfgr.
define            variable mfgr_part   like vp_mfgr_part.
define            variable y-lbl       as character format "x(1)".
define            variable n-lbl       as character format "x(1)".
define            variable rev-lbl     as character format "x(10)".
define            variable vpart-lbl   as character format "x(15)".
define            variable manuf-lbl   as character format "x(14)".
define            variable part-lbl    as character format "x(6)".
define            variable site-lbl    as character format "x(6)".
define            variable disc-lbl    as character format "x(5)".
define            variable type-lbl    as character format "x(6)".
define            variable typedesc    as character format "x(11)".
define            variable cont-lbl    as character format "x(12)".
define            variable vd-attn-lbl as character format "x(16)".
define            variable nullstring  as character
   format "x(1)"  initial "".
define            variable lot-lbl as  character format "X(43)".
define            variable lotserial_total like tr_qty_chg.
define            variable oldsite     like prh_site.
define            variable newsite     like mfc_logical.
define            variable oldcurr     like prh_curr.
define            variable oldsession  as character no-undo.
define            variable doc_cost    as decimal.
define            variable ext_cost_fmt as character.
define            variable ext_cost_old as character.
define            variable received_at_site like prh_site no-undo.
define            variable mc-error-number  like msg_nbr no-undo.
define            variable l_vend           like prh_vend   no-undo.

convertmode = "REPORT".

/* SET LABEL VARIABLES */
{po03b01.i}

find first gl_ctrl no-lock.

{pocurvar.i "NEW"}
{txcurvar.i "NEW"}
{apconsdf.i}

/* PREPAID FRAME */
form
   prepaid-lbl at 2
   po_prepaid
with frame prepd no-labels width 80.
/* ITEM FRAME */
form
   prh_line    at 1     /*column-label " Ln"*/
   prh_part             /*column-label "Item Number       "*/
   prh_ps_qty           column-label {&porvrp01_p_20}
   format "->>>>>>9.9<<<<<<"
   qty_open             column-label {&porvrp01_p_7}
   prh_um               /*column-label "UM"*/
   unit_cost            column-label {&porvrp01_p_6}
   ext_cost             column-label {&porvrp01_p_24}
with frame d width 80 no-box down.
ext_cost_old = ext_cost:format.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

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

assign
   oldsession = SESSION:numeric-format
   oldcurr = ""
   pages = 0
   old_prh_nbr = ?.

for each prh_hist
   no-lock
      where (prh_nbr >= nbr) and (prh_nbr <= nbr1)
      and (prh_vend >= vend) and (prh_vend <= vend1)
      and (prh_buyer >= buyer and prh_buyer <= buyer1)
      and (prh_rcp_date >= rcp_date) and (prh_rcp_date <= rcp_date1)
      and (prh_print or not new_only)
      and (prh_rcp_type <> ""),
   each pvo_mstr no-lock where
      pvo_order_type        = {&TYPE_PO}         and
      pvo_order             = prh_nbr            and
      pvo_internal_ref_type = {&TYPE_POReceiver} and
      pvo_internal_ref      = prh_receiver       and
      pvo_line              = prh_line
   break by prh_receiver
      by prh_site
      by prh_line with frame d width 80:

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

      /* DETERMINE CURRENCY DISPLAY AMERICAN OR EUROPEAN            */
      find rnd_mstr where rnd_rnd_mthd = rndmthd no-lock no-error.
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
      ext_cost_fmt = ext_cost_old.
      {gprun.i ""gpcurfmt.p"" "(input-output ext_cost_fmt,
                                input rndmthd)"}
      ext_cost:format = ext_cost_fmt.
      oldcurr = prh_curr.
   end.

   /* MOVED FRAME DEFINITION FROM BELOW FOR GUI STANDARDS */
   form
      header            skip(3)
      billto[1]         at 4
      getTermLabelRt("BANNER_RETURN_TO_SUPPLIER",35) to 80 format "x(35)"
      billto[2]         at 4

      /* DISPLAYS "SIMULATION" TEXT, IF REPORT IS RUN IN */
      /* SIMULATION MODE                                 */
      if not update_yn and prh_print then
         getTermLabelRt("BANNER_SIMULATION",28)
      else
         (if not prh_print then duplicate else "")  to 80 format "x(28)"
      billto[3]         at 4

      getTermLabelRtColon("RETURN_NUMBER",14)  to 56 format "x(14)"
      prh_receiver
      billto[4]         at 4

      getTermLabelRtColon("ORDER_NUMBER",14)  to 56 format "x(14)"
      prh_nbr
      billto[5]         at 4

      getTermLabelRtColon("RETURN_DATE",14)  to 56 format "x(14)"
      prh_rcp_date

      getTermLabelRtColon("PAGE_OF_REPORT",8)  to 76 format "x(8)"
      string(page-number - pages,">>9") format "x(3)"
      billto[6]         at 4

      getTermLabelRtColon("PRINT_DATE",14)  to 56 format "x(14)"
      today             skip(1)

      getTermLabel("RECEIVED_AT",20) + ": " +
      received_at_site at 8 format "x(30)"

      getTermLabel("RETURN_TO_SUPPLIER",30) + ": " + l_vend
      at 46 format "x(40)" skip(1)

      shipto[1]         at 8
      vendor[1]         at 46
      shipto[2]         at 8
      vendor[2]         at 46
      shipto[3]         at 8
      vendor[3]         at 46
      shipto[4]         at 8
      vendor[4]         at 46
      shipto[5]         at 8
      vendor[5]         at 46
      shipto[6]         at 8
      vendor[6]         at 46 skip(2)

      getTermLabelRtColon("BUYER",14)  to 14 format "x(14)"
      prh_buyer

      getTermLabelRtColon("SUPPLIER_TELEPHONE",25)  to 54 format "x(25)"
      vend_phone

      getTermLabelRtColon("VOUCHER",14)  to 14 format "x(14)"
      pvo_last_voucher

      getTermLabelRtColon("CONTACT",20)  to 54 format "x(20)"
      contact

      getTermLabelRtColon("CREDIT_TERMS",14)  to 14 format "x(14)"
      cr_terms

      getTermLabelRtColon("SHIP_VIA",20)  to 54 format "x(20)"
      shipvia
      " "               to 14
      terms

      getTermLabelRtColon("FOB",10)  to 54 format "x(10)"
      fob

      getTermLabelRtColon("REMARKS",14)  to 14 format "x(14)"
      rmks
   with frame phead1 page-top width 90.

   view frame phead1.
   if prh_shipto = "" or prh_shipto = ?
   then
      l_vend = prh_vend.
   else
      l_vend = prh_shipto.

   newsite = no.
   if oldsite <> prh_site and not first(prh_receiver)
      then newsite = yes.
   if newsite = yes then page.

   if first-of(prh_receiver) or newsite = yes then do:

      if old_prh_nbr <> ? and newsite <> yes then
         pages = page-number.

      find po_mstr where po_nbr = prh_nbr no-lock no-error.

      if available po_mstr then do:
         assign
            contact = po_contact
            cr_terms = po_cr_terms
            shipvia = po_shipvia
            fob = po_fob
            rmks = po_rmks.
         find ct_mstr where ct_code = po_cr_terms no-lock no-error.
         if available ct_mstr then terms = ct_desc.
      end.
      else
         assign
            contact = ""
            cr_terms = ""
            shipvia = ""
            fob = ""
            rmks = ""
            terms = "".

      if prh_print
         then duplicate = "".
      else duplicate = dup-lbl.

      if available po_mstr then do:
         find ad_mstr where ad_addr = po_bill
            no-lock no-wait no-error.
         if available ad_mstr and print_bill then do:
            assign
               addr[1] = ad_name
               addr[2] = ad_line1
               addr[3] = ad_line2
               addr[4] = ad_line3
               addr[6] = ad_country.
            {mfcsz.i addr[5] ad_city ad_state ad_zip}
            {gprun.i ""gpaddr.p""}
            assign
               billto[1] = addr[1]
               billto[2] = addr[2]
               billto[3] = addr[3]
               billto[4] = addr[4]
               billto[5] = addr[5]
               billto[6] = addr[6].
         end.
      end.
      else billto = "".

      /* WHEN SHIP-TO ADDRESS IS DIFFERENT FROM SUPPLIER ADDRESS */
      /* PRINT THE SHIP-TO ADDRESS DETAILS                       */
      if prh_shipto = "" or prh_shipto = ?
      then
         find ad_mstr where ad_addr = prh_vend
           no-lock no-wait no-error.
      else
      for first ad_mstr
         fields (ad_addr ad_city ad_country ad_format ad_line1
                 ad_line2 ad_line3 ad_name ad_phone ad_state ad_zip)
         where ad_addr = prh_shipto
         no-lock :
      end. /* FOR FIRST AD_MSTR */
      if available ad_mstr then do:
         assign
            addr[1] = ad_name
            addr[2] = ad_line1
            addr[3] = ad_line2
            addr[4] = ad_line3
            addr[6] = ad_country.
         {mfcsz.i addr[5] ad_city ad_state ad_zip}
         {gprun.i ""gpaddr.p""}
         assign
            vendor[1] = addr[1]
            vendor[2] = addr[2]
            vendor[3] = addr[3]
            vendor[4] = addr[4]
            vendor[5] = addr[5]
            vendor[6] = addr[6]
            vend_phone = ad_phone.
      end.
      else
      assign
         vendor = ""
         vend_phone = "".

      assign shipto = "".

      find ad_mstr where ad_addr = prh_site
         no-lock no-wait no-error.
      if available ad_mstr then do:
         assign
            received_at_site = prh_site
            addr[1] = ad_name
            addr[2] = ad_line1
            addr[3] = ad_line2
            addr[4] = ad_line3
            addr[6] = ad_country.
         {mfcsz.i addr[5] ad_city ad_state ad_zip}
         {gprun.i ""gpaddr.p""}
         assign
            shipto[1] = addr[1]
            shipto[2] = addr[2]
            shipto[3] = addr[3]
            shipto[4] = addr[4]
            shipto[5] = addr[5]
            shipto[6] = addr[6].
      end.  /* available ad_mstr for prh_site */
      else do:
         find ad_mstr where ad_addr = prh_ship
            no-lock no-wait no-error.
         if available ad_mstr then do:
            assign
               received_at_site = prh_ship
               addr[1] = ad_name
               addr[2] = ad_line1
               addr[3] = ad_line2
               addr[4] = ad_line3
               addr[6] = ad_country.
            {mfcsz.i addr[5] ad_city ad_state ad_zip}
            {gprun.i ""gpaddr.p""}
            assign
               shipto[1] = addr[1]
               shipto[2] = addr[2]
               shipto[3] = addr[3]
               shipto[4] = addr[4]
               shipto[5] = addr[5]
               shipto[6] = addr[6].
         end. /* available address for prh_ship */
      end. /* not available address for prh_site */

      /* FORM HEADER */

      old_prh_nbr = prh_nbr.

      /* ENSURE THAT HEADER COMMENTS START PRINTING ONLY AFTER
      PRINTING REPORT HEADER. */
      page.

      form
         skip with frame put1 width 90.

      /* CONSISTENTLY PRINT ONE BLANK LINE AFTER THE REPORT HEADER */

      if available po_mstr and po_cmtindx <> 0 then do:
         view frame put1.
         {gpcmtprt.i &type=RV &id=po_cmtindx &pos=3}
      end.
      view frame put1.

   end. /* if first-of(prh_receiver) */

   prh_recno = recid(prh_hist).

   /* PRINT ORDER DETAIL */
   find pod_det where pod_nbr = prh_nbr
      and pod_line = prh_line no-lock no-error.

   qty_open = - prh_rcvd.
   /* UNIT_COST IS IN BASE CURRENCY */
   unit_cost = prh_pur_cost * prh_um_conv.
   /* REGARDLESS OF CURRENCY CALCULATE IN DOC CURRENCY THEN CONVERT */
   ext_cost = qty_open * prh_curr_amt * prh_um_conv.
   /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output ext_cost,
        input rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.
   /* SAVE THE DOCUMENT COST FOR LATER CALCULATIONS */
   doc_cost = ext_cost.

   /* CONVERTING UNIT COST TO DOC CURRENCY           */
   if prh_curr <> base_curr then
   do:
      /* CONVERT FROM BASE TO FOREIGN CURRENCY */
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input base_curr,
           input prh_curr,
           input pvo_ex_rate2,
           input pvo_ex_rate,
           input unit_cost,
           input false, /* DO NOT ROUND */
           output unit_cost,
           output mc-error-number)"}.
   end.

   accumulate ext_cost (total by prh_receiver).

   if available pod_det then desc1 = pod_desc.
   else desc1 = "".
   desc2 = "".
   find pt_mstr where pt_part = prh_part
      no-lock no-wait no-error.
   if available pt_mstr then do:
      if desc1 = "" or desc1 = pt_desc1
      then desc1 = pt_desc1 + " " + pt_desc2.
      else desc2 = pt_desc1 + " " + pt_desc2.
   end.

   mfgr = "".
   mfgr_part = "".
   if available pod_det and pod_vpart <> "" then do:
      find first vp_mstr
         where vp_vend = prh_vend
         and vp_vend_part = pod_vpart
         and vp_part = prh_part no-lock no-error.
      if available vp_mstr then
      assign
         mfgr = vp_mfgr
         mfgr_part = vp_mfgr_part.
   end.

   /* DETERMINE NUMBER OF LINES NEEDED FOR DETAIL */
   det_lines = 1.
   if prh_rev <> "" then det_lines = det_lines + 1.
   if prh_site <> "" then det_lines = det_lines + 1.
   if pod_vpart <> "" then det_lines = det_lines + 1.
   if prh_type <> "" then det_lines = det_lines + 1.
   if mfgr <> "" or mfgr_part <> "" then det_lines = det_lines + 1.
   if desc1 <> "" then det_lines = det_lines + 1.
   if desc2 <> "" then det_lines = det_lines + 1.
   if page-size - det_lines - line-counter < 3
      then page.

   /* DISPLAY LINE ITEM */

   display
      prh_line
      prh_part
      prh_ps_qty
      qty_open
      prh_um
      unit_cost
      ext_cost
   with frame d.
   down 1 with frame d.
   if prh_rev <> "" then do:
      put rev-lbl at 5 prh_rev skip.
   end.
   if prh_site <> "" then do:
      put site-lbl at 5 prh_site skip.
   end.
   if available pod_det and pod_vpart <> "" then do:
      put vpart-lbl at 5 pod_vpart skip.
   end.
   if prh_type <> "" then do:
      if prh_type = "M" or prh_type = "m" then
         typedesc = getTermLabel("MEMO",11).
      else
      if prh_type = "S" or prh_type = "s" then
         typedesc = getTermLabel("SUBCONTRACT",11).
      else
         typedesc = prh_type.
      put type-lbl at 5 typedesc skip.
   end.
   if mfgr <> "" or mfgr_part <> "" then
   put
      manuf-lbl at 5 mfgr space(2)
      part-lbl mfgr_part skip.
   if desc1 <> "" then put desc1 at 5 skip.
   if desc2 <> "" then put desc2 at 5 skip.

   oldsite = prh_site.

   /* Print Lot/Serial Numbers */
   if print_lotserials then do:
      for each tr_hist no-lock where tr_type = "ISS-PRV"
            and tr_nbr = prh_nbr and tr_lot = prh_receiver
            and tr_line = prh_line
            and tr_serial <> "" use-index tr_nbr_eff break by tr_serial
            by tr_expire:
         if first(tr_expire) then do:
            if page-size - line-counter < 1 then page.
            put lot-lbl at 3 skip.
         end.
         if first-of(tr_expire) then lotserial_total = 0.
         lotserial_total = lotserial_total - tr_qty_loc.
         if last-of(tr_expire)  then do:
            if page-size - line-counter < 1 then page.
            put tr_serial at 5 lotserial_total at 25
               tr_expire at 40 skip.
         end.
      end.
   end.

   if available pod_det then do:
      {gpcmtprt.i &type=RV &id=pod_cmtindx &pos=5
         &command="display prh_line prh_part nullstring @ prh_ps_qty
           nullstring @ qty_open nullstring @ prh_um
           cont-lbl @ unit_cost nullstring @ ext_cost with frame d."}
   end.

   {mfrpexit.i}

   if last-of(prh_receiver) then do:

      if last-of(prh_receiver) and print_trlr then do:
         undo_trl2 = true.
         find po_mstr where po_nbr = prh_nbr no-lock.
         po_recno = recid(po_mstr).
         receivernbr = prh_receiver.
         {gprun.i ""porctrl2.p""}
         if undo_trl2 then undo, leave.
      end.
      else do:
         /* TOTALS */
         if page-size - line-counter < 8 then page.
         do while page-size - line-counter > 8:
            put skip(1).
         end.

         put msg skip.
         put "-----------------------------------------"
            + "-----------------------------------------" format "x(80)".

         display
            "" @ prh_line
            "" @ prh_part
            "" @ prh_ps_qty
            "       " + prh_curr format "x(10)" @ qty_open
            "" @ prh_um
            getTermLabel("TOTAL_CREDIT",12) @ unit_cost
            (accum total by prh_receiver ext_cost) @ ext_cost
         with frame d.

      end.

      po_prepaid:format in frame prepd = prepaid_fmt.
      if available po_mstr and po_prepaid <> 0
         then display prepaid-lbl po_prepaid with frame prepd.
      else put skip(1).

      put skip(1).
      put by-lbl to 47.
      put "______________________________" to 78 skip.
      put signature-lbl to 78 skip.

   end. /* if last-of(prh_receiver) */

   {gprun.i ""porcrpa.p""}

end. /* for each prh_hist */
SESSION:numeric-format = oldsession.
