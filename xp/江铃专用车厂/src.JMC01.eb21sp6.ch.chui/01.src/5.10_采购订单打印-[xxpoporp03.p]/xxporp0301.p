/* porp0301.p - PURCHASE ORDER PRINT MAIN SUBROUTINE                    */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.11.2.14 $                                                */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 5.0     LAST MODIFIED: 03/28/90    BY: MLB *B615**/
/* REVISION: 6.0     LAST MODIFIED: 05/24/90    BY: WUG *D002**/
/* REVISION: 6.0     LAST MODIFIED: 06/14/90    BY: RAM *D030**/
/* REVISION: 6.0     LAST MODIFIED: 07/05/90    BY: WUG *D043**/
/* REVISION: 6.0     LAST MODIFIED: 08/17/90    BY: SVG *D058**/
/* REVISION: 6.0     LAST MODIFIED: 01/03/91    BY: MLB *D238**/
/* REVISION: 6.0     LAST MODIFIED: 01/18/91    BY: RAM *D306**/
/* REVISION: 6.0     LAST MODIFIED: 08/14/91    BY: RAM *D828**/
/* REVISION: 6.0     LAST MODIFIED: 11/05/91    BY: RAM *D913**/
/* REVISION: 7.3     LAST MODIFIED: 02/22/93    by: jms *G712**/
/* REVISION: 7.3     LAST MODIFIED: 04/09/93    BY: afs *G926**/
/* REVISION: 7.4     LAST MODIFIED: 07/20/93    BY: bcm *H033**/
/* REVISION: 7.4     LAST MODIFIED: 01/28/94    BY: dpm *FL36**/
/* REVISION: 7.4     LAST MODIFIED: 04/11/94    BY: bcm *H334**/
/* REVISION: 7.4     LAST MODIFIED: 06/17/94    BY: bcm *H382**/
/* REVISION: 7.4     LAST MODIFIED: 07/25/94    BY: dpm *FP50**/
/* REVISION: 7.4     LAST MODIFIED: 09/20/94    BY: jpm *GM74**/
/* REVISION: 7.4     LAST MODIFIED: 10/11/95    BY: jym *G0Z4**/
/* REVISION: 8.5     LAST MODIFIED: 10/03/95    BY: taf *J053**/
/* REVISION: 8.5     LAST MODIFIED: 02/14/96    BY: rxm *H0JJ**/
/* REVISION: 8.5     LAST MODIFIED: 07/18/96    BY: taf *J0ZS**/
/* REVISION: 8.6     LAST MODIFIED: 10/22/96    BY: *K004* Nadine Catry */
/* REVISION: 8.6     LAST MODIFIED: 11/21/96    BY: *K022* Tejas Modi   */
/* REVISION: 8.6     LAST MODIFIED: 04/02/97    BY: *K073* Kieu Nguyen  */
/* REVISION: 8.6     LAST MODIFIED: 04/08/97    BY: *J1MJ* Ajit Deodhar */
/* REVISION: 8.6     LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E    LAST MODIFIED: 06/16/98    BY: *L020* Charles Yen  */
/* REVISION: 9.1     LAST MODIFIED: 07/28/99    BY: *N01B* John Corda   */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00    BY: *N0KQ* myb              */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Old ECO marker removed, but no ECO header exists *U.S.*                  */
/* Revision: 1.11.2.7       BY: Katie Hilbert      DATE: 04/01/01 ECO: *P002* */
/* Revision: 1.11.2.9       BY: Rajiv Ramaiah      DATE: 10/23/02 ECO: *N1XW* */
/* Revision: 1.11.2.10      BY: Narathip W.        DATE: 05/06/03 ECO: *P0R9* */
/* Revision: 1.11.2.12      BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00J* */
/* Revision: 1.11.2.13      BY: Laxmikant B        DATE: 07/22/04 ECO: *P2BX* */
/* $Revision: 1.11.2.14 $   BY: Jignesh Rachh      DATE: 05/18/05 ECO: *P3LS* */

/* SS - 101020.1  By: Roger Xiao */  /*有设定权限通用代码,才显示价格等*/
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{cxcustom.i "PORP0301.P"}

/* PARAMETER TO FACILITATE DISPLAY OF "SIMULATION" */
/* TEXT IN REPORT HEADER                           */

define input parameter update_yn like mfc_logical no-undo.

define variable mc-error-number like msg_nbr no-undo.

define new shared variable convertmode as character no-undo.
define new shared variable rndmthd like rnd_rnd_mthd.
define new shared frame c.
define new shared frame phead1.
define new shared frame d.
define shared variable ord_date like po_ord_date.
define shared variable ord_date1 like po_ord_date.
define shared variable nbr like po_nbr.
define shared variable nbr1 like po_nbr.
define shared variable vend like po_vend.
define shared variable vend1 like po_vend.
define shared variable buyer like po_buyer.
define shared variable buyer1 like po_buyer.
define shared variable msg as character format "X(60)".
define shared variable print_bill like mfc_logical.
define shared variable lang like so_lang.
define shared variable lang1 like lang.
define shared variable open_only like mfc_logical.
define shared variable sort_by_site like poc_sort_by.
define new shared variable po_recno as recid.
define shared variable new_only like mfc_logical.
define new shared variable pages as integer.
define variable old_po_nbr like po_nbr.
define variable location like pt_loc.
define variable i as integer.
define new shared variable billto as character
   format "x(38)" extent 6.
define new shared variable vendor as character
   format "x(38)" extent 6.
define new shared variable shipto as character
   format "x(38)" extent 6.
define new shared variable poship like po_ship.
define new shared variable duplicate as character
   format "x(11)" label "".
define new shared variable vend_phone like ad_phone.
define new shared variable terms like ct_desc.
define new shared variable addr as character format "x(38)" extent 6.
define variable dup-lbl as character format "x(10)".
define variable prepaid-lbl as character format "x(17)".
define variable signature-lbl as character format "x(34)".
define variable by-lbl as character format "x(3)".
define variable ext_cost like pod_pur_cost
   format "(z,zzz,zzz,zz9.99)".
define variable desc1 like pod_desc.
define variable desc2 like pt_desc2.
define variable qty_open like pod_qty_ord format "->>>>>>9.9<<<<<<".
define variable det_lines as integer.
define variable tax_flag as character format "x(1)".
define variable mfgr like vp_mfgr.
define variable mfgr_part like vp_mfgr_part.
define variable y-lbl as character format "x(1)".
define variable n-lbl as character format "x(1)".
define variable rev-lbl as character format "x(10)".
define variable vpart-lbl as character format "x(15)".
define variable manuf-lbl as character format "x(14)".
define variable part-lbl as character format "x(6)".
define variable site-lbl as character format "x(6)".
define variable disc-lbl as character format "x(5)".
define variable discdesc as character format "x(14)".
define variable type-lbl as character format "x(6)".
define variable typedesc as character format "x(11)".
define variable cont-lbl as character format "x(12)".
define variable vd-attn-lbl as character format "x(16)".
define new shared variable vdattnlbl like vd-attn-lbl.
define new shared variable vdattn like ad_attn.
define variable nullstring as character initial "" format "x(1)".
define variable new_po like mfc_logical initial no.
define variable lot-lbl as character format "X(43)".
define new shared variable maint     like mfc_logical.
define shared variable include_sched like mfc_logical.
define variable oldcurr like po_curr no-undo.
define variable oldsession as character no-undo.
define variable ext_cost_fmt as character no-undo.
define variable ext_cost_old as character no-undo.
define variable prepaiddesc as character format "x(40)" no-undo.
define variable signatureline as character format "x(30)" no-undo.
define variable disp_trail like mfc_logical.
define shared variable incl_b2b_po like mfc_logical.
define shared variable print_options like mfc_logical.

define variable l_tx_misc1    like ad_misc1_id  no-undo.
define variable l_tx_misc2    like ad_misc2_id  no-undo.
define variable l_tx_misc3    like ad_misc3_id  no-undo.
define variable l_print_taxid like mfc_logical  no-undo.
define variable l_po_locked   like mfc_logical  no-undo.
define variable l_rndmthd     like rnd_rnd_mthd no-undo.

{&PORP0301-P-TAG1}
signatureline = fill("_",30).

form
   prepaiddesc
   /*V8-*/ skip(1) /*V8+*/
   /*V8! skip */
   by-lbl to 47
   signatureline to 78
   signature-lbl to 78
with frame potrail1 no-labels no-box width 80.

/* DEFINE VARIABLES FOR CURRENCY DEPENDENT FORMATS */
{pocurvar.i "NEW"}
{txcurvar.i "NEW"}
/* DEFINE SHARED PO TRAILER VARIABLES */
{potrldef.i "new"}

/* POTOTFRM.I IS NOW INCLUDED BY POTRLDEF.I */

{&PORP0301-P-TAG2}
{po03d01.i}   /* DEFINE FRAME C*/
{&PORP0301-P-TAG3}

/* DEFINE TRAILER VARS AS NEW, SO THAT CORRECT _OLD FORMATS */
assign
   nontax_old         = nontaxable_amt:format
   taxable_old        = taxable_amt:format
   lines_tot_old      = lines_total:format
   tax_tot_old        = tax_total:format
   order_amt_old      = order_amt:format
   ext_cost_old       = ext_cost:format
   prepaid_old        = "->,>>>,>>>,>>9.99".
oldcurr = "".

/* SET LABEL VARIABLES */
{po03b01.i}

/* DEFINE VARIABLES FOR DISPLAY OF VAT REG NO & COUNTRY CODE */
{gpvtepdf.i &var="new shared"}

convertmode = "REPORT".

disp_trail = true.

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.

for first qad_wkfl
   fields( qad_domain qad_key1 qad_key2 qad_logfld)
    where qad_wkfl.qad_domain = global_domain and  qad_key1 = "popopm.p"
   and   qad_key2 = "l_gst_pst"
   no-lock:
   l_print_taxid = qad_logfld[1].
end. /* FOR FIRST qad_wkfl */

pages = 0.
old_po_nbr = ?.

oldsession = SESSION:numeric-format.

for each po_mstr  where po_mstr.po_domain = global_domain and (  (po_nbr >=
nbr) and (po_nbr <= nbr1)
      and (po_vend >= vend) and (po_vend <= vend1)
      and (po_buyer >= buyer and po_buyer <= buyer1)
      and (po_print or not new_only)
      and (po_ord_date >= ord_date) and (po_ord_date <= ord_date1)
      and (po_lang >= lang and po_lang <= lang1)
      and (po_stat = "" or not open_only)
      and (not po_sched or include_sched)
      and (not po_is_btb or incl_b2b_po)
      and po_type <> "B"      ) no-lock by po_nbr:

   if old_po_nbr <> ? then
      pages = page-number.

   old_po_nbr = po_nbr.

   if po_is_btb then do:
      find vd_mstr  where vd_mstr.vd_domain = global_domain and  vd_addr =
      po_vend no-lock no-error.
      if available vd_mstr and not vd_rcv_held_so and po_so_hold
         then next.
   end.

   run check_locked(output l_po_locked).
   if l_po_locked
   then
      next.

   mainloop:
   do transaction on error undo, leave on endkey undo, leave:

      if not update_yn
      then
         rndmthd = l_rndmthd.

      if (oldcurr <> po_curr) or (oldcurr = "") then do:

         if po_curr = gl_base_curr then
            rndmthd = gl_rnd_mthd.
         else do:
            /* GET ROUNDING METHOD FROM CURRENCY MASTER */
            {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
               "(input po_curr,
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
         find rnd_mstr  where rnd_mstr.rnd_domain = global_domain and
         rnd_rnd_mthd = rndmthd no-lock no-error.
         if not available rnd_mstr then do:
            /* ROUND METHOD RECORD NOT FOUND */
            {pxmsg.i &MSGNUM=863 &ERRORLEVEL=4}
            next.
         end.

         /* IF RND_DEC_PT = COMMA FOR DECIMAL POINT */
         /* THIS IS A EUROPEAN STYLE CURRENCY */
         if (rnd_dec_pt = "," )
            then SESSION:numeric-format = "European".
            else SESSION:numeric-format = "American".

         /* SET THE CURRENCY DEPENDENT FORMAT FOR EXT_COST */
         ext_cost_fmt = ext_cost_old.
         {gprun.i ""gpcurfmt.p"" "(input-output ext_cost_fmt,
                                   input rndmthd)"}
         ext_cost:format = ext_cost_fmt.
         {pocurfmt.i}

         assign
            oldcurr   = po_curr
            l_rndmthd = rndmthd.

      end.

      terms = "".
      find ct_mstr  where ct_mstr.ct_domain = global_domain and  ct_code =
      po_cr_terms no-lock no-error.
      if available ct_mstr then terms = ct_desc.

      duplicate = "".
      if po_print = no then duplicate = dup-lbl.

      find ad_mstr
         where ad_mstr.ad_domain = global_domain
         and   ad_addr           = po_bill
         no-lock no-wait no-error.

      update billto = "".
      if available ad_mstr and print_bill then do:
         {&PORP0301-P-TAG4}
         assign
            addr[1] = ad_name
            addr[2] = ad_line1
            addr[3] = ad_line2
            addr[4] = ad_line3
            addr[6] = ad_country.
         {mfcsz.i addr[5] ad_city ad_state ad_zip}
         {&PORP0301-P-TAG5}
         {gprun.i ""gpaddr.p"" }
         assign
            billto[1] = addr[1]
            billto[2] = addr[2]
            billto[3] = addr[3]
            billto[4] = addr[4]
            billto[5] = addr[5]
            billto[6] = addr[6].

         if l_print_taxid
         then
            assign
               l_tx_misc1 = ad_misc1_id
               l_tx_misc2 = ad_misc2_id
               l_tx_misc3 = ad_misc3_id.
      end.

      assign
         vendor = ""
         vdattnlbl = ""
         vdattn = "".

      find ad_mstr
         where ad_mstr.ad_domain = global_domain
         and   ad_addr           = po_vend
         no-lock no-wait no-error.

      if available ad_mstr then do:
         {&PORP0301-P-TAG6}
         assign
            addr[1] = ad_name
            addr[2] = ad_line1
            addr[3] = ad_line2
            addr[4] = ad_line3
            addr[6] = ad_country
            vend_phone = ad_phone.
         {mfcsz.i   addr[5] ad_city ad_state ad_zip}
         {&PORP0301-P-TAG7}
         {gprun.i ""gpaddr.p"" }
         assign
            vendor[1] = addr[1]
            vendor[2] = addr[2]
            vendor[3] = addr[3]
            vendor[4] = addr[4]
            vendor[5] = addr[5]
            vendor[6] = addr[6].

         if ad_attn <> "" then
         assign
            vdattnlbl = vd-attn-lbl
         vdattn = ad_attn.
      end.

      {&PORP0301-P-TAG8}
      {po03a01.i}
      {&PORP0301-P-TAG9}

      po_recno = recid(po_mstr).
      /* Print Order Detail */

/* SS - 101020.1 - B 
      if sort_by_site then do:
         {gprun.i ""porp3a01.p"" "(input update_yn)"}
      end.
      else do:
         {gprun.i ""porp3b01.p"" "(input update_yn)"}
      end.
   SS - 101020.1 - E */
/* SS - 101020.1 - B */
      if sort_by_site then do:
         {gprun.i ""xxporp3a01.p"" "(input update_yn)"}
      end.
      else do:
         {gprun.i ""xxporp3b01.p"" "(input update_yn)"}
      end.
/* SS - 101020.1 - E */

      /* TRAILER */
      maint = no.
      undo_trl2 = true.
/* SS - 101020.1 - B 
      {gprun.i ""pomttrl2.p""}
   SS - 101020.1 - E */
/* SS - 101020.1 - B */
      {gprun.i ""xxpomttrl2.p""}
/* SS - 101020.1 - E */

      if undo_trl2 then undo, leave.

      /* ADDED THE ASSIGN PREPAID DISPLAY FIELD            */
      if po_prepaid <> 0 then
      assign
         prepaiddesc = prepaid-lbl + " " + string(po_prepaid, prepaid_fmt).
      else prepaiddesc = "".

      {&PORP0301-P-TAG10}
      display
         prepaiddesc
         by-lbl
         signatureline
         signature-lbl
      with frame potrail1.
      {&PORP0301-P-TAG11}

      {gprun.i ""poporp3a.p""}

      if not update_yn
      then
         undo mainloop, leave mainloop.
   end. /* DO TRANSACTION */
end.

{&PORP0301-P-TAG12}
/* SET SESSION PARAMETER BACK BEFORE ENDING */
SESSION:numeric-format = oldsession.

PROCEDURE check_locked:
   /* PROCEDURE TO CHECK IF po_mstr OR pod_det IS LOCKED. */

   define output parameter p_po_locked as logical no-undo init no.

   define variable l_po_recid as recid no-undo.
   define variable l_first    as logical no-undo.

   l_po_recid = recid(po_mstr).
   do transaction on error undo, leave on endkey undo, leave:
      find first po_mstr
         where recid(po_mstr) = l_po_recid
         exclusive-lock no-wait no-error.

      if locked po_mstr
      then
         p_po_locked = yes.
      else do:
         l_first = yes.
         repeat:
            if l_first = yes
            then do:
               find first pod_det
                  where pod_domain = global_domain
                  and   pod_nbr    = po_nbr
                  exclusive-lock no-wait no-error.
               l_first = no.
            end. /* IF l_first */
            else
               find next pod_det
                  where pod_domain = global_domain
                  and   pod_nbr    = po_nbr
                  exclusive-lock no-wait no-error.

            if not available pod_det
            and not locked pod_det
            then
               leave.
            else
               if locked pod_det
               then do:
                   p_po_locked = yes.
                   leave.
               end. /* IF LOCKED pod_det */
               else
                  if available pod_det
                  then
                     release pod_det.
         end. /* REPEAT */
      end. /* ELSE DO */
      release po_mstr.
   end. /* DO TRANSACTION */

   for first po_mstr
      fields(po_ap_acct po_ap_cc po_ap_sub po_bill po_buyer po_cls_date
             po_confirm po_contact po_cr_terms po_curr po_del_to po_fob
             po_is_btb po_lang po_nbr po_ord_date po_prepaid po_print po_rev
             po_rmks po_sched po_shipvia po_so_hold po_stat po_type po_vend)
      where recid(po_mstr) = l_po_recid
      no-lock:
   end. /* FOR FIRST po_mstr */
END PROCEDURE. /* procedure check_locked */
