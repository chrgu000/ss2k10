/* apvomtc.p  - AP VOUCHER MAINTENANCE EDIT CHECKS                            */
/* Copyright 1986-2007 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 1.0      LAST MODIFIED: 12/18/86   BY: PML *A3*                  */
/* REVISION: 6.0      LAST MODIFIED: 06/04/91   BY; MLV *D671*                */
/*                                   06/18/91   BY; MLV *D711*                */
/* REVISION: 7.0      LAST MODIFIED: 08/12/91   BY: MLV *F002*                */
/*                                   09/13/91   BY: MLV *F013*                */
/*                                   11/18/91   BY: MLV *D937*                */
/*                                   11/18/91   BY: MLV *F037*                */
/*                                   01/11/92   BY: MLV *F083*                */
/*                                   02/05/92   BY: TMD *F169*                */
/*                                   02/26/92   BY: MLV *F238*                */
/*                                   05/15/92   BY: MLV *F499*                */
/*                                   06/19/92   BY: tmd *F458*                */
/*                                   07/10/92   by: MLV *F458*                */
/*                                   08/13/92   BY: MLV *F844*                */
/* REVISION: 7.3      LAST MODIFIED: 10/14/92   BY: MLV *G053*                */
/*                                   12/11/92   BY: bcm *G418*                */
/*                                   01/12/93   by: jms *G537*                */
/*                                   03/01/93   by: jms *G762*                */
/*                                   04/15/93   by: bcm *G954*                */
/*                                   06/28/93   by: jms *GD32*                */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   BY: pcd *H039*                */
/*                                   08/20/93   BY: pcd *H079*                */
/*                                   10/29/93   BY: pcd *H199*                */
/*                                   05/13/94   by: pmf *FO17*                */
/*                                   07/22/94   by: srk *FP53*                */
/*                                   07/27/94   by: bcm *H460*                */
/*                                   09/08/94   by: bcm *H497*                */
/*                                   12/06/94   by: bcm *H615*                */
/*                                   01/20/95   by: str *H09W*                */
/*                                   04/19/95   by: wjk *H0CS*                */
/*                                   11/22/95   by: mys *H0HC*                */
/*                                   01/02/96   by: jzs *H0J0*                */
/*                                   01/24/96   by: mys *H0JC*                */
/* REVISION: 8.5                     09/29/95   BY: mwd *J053*                */
/*                                   02/21/96   BY: tjs *J0D2*                */
/* REVISION: 8.5      LAST MODIFIED: 02/27/96   BY: *J0CV* Brandy J Ewing     */
/*                                   04/03/96   BY: mzh *J0H2*                */
/*                                   04/22/96   BY: jzw *H0KC*                */
/*                                   07/05/96   BY: jwk *H0LZ*                */
/*                                   07/27/96   by: *J12H* M. Deleeuw         */
/*                                   01/24/97   by: bkm *J1FY*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/*                                   04/10/98   by: rvsl *L00K*               */
/*                                   05/11/98   BY: *J2K6* A. Licha           */
/*                                   05/20/98   BY: *K1Q4* Alfred Tan         */
/*                                   07/07/98   BY: *L03C* Oskar Pen          */
/*                                   07/10/98   BY: *J2QH* Niranjan R.        */
/*                                   07/23/98   BY: *L03K* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 09/15/98   BY: *J2ZR* Abbas Hirkani      */
/* REVISION: 8.6E     LAST MODIFIED: 10/28/98   BY: *J32Y* Abbas Hirkani      */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari    */
/* REVISION: 9.1      LAST MODIFIED: 02/15/00   BY: *M0JT* Ranjit Jain        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 06/22/00   BY: *L101* Shilpa Athalye     */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* REVISION: 9.1      LAST MODIFIED: 08/05/00   BY: *N0W0* BalbeerS Rajput    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.16.2.9       BY: Katie Hilbert     DATE: 04/01/01  ECO: *P002* */
/* Revision: 1.16.2.10      BY: Ed van de Gevel   DATE: 06/29/01  ECO: *N0ZX* */
/* Revision: 1.16.2.11      BY: Jean Miller       DATE: 05/22/02  ECO: *P074* */
/* Revision: 1.16.2.12      BY: Samir Bavkar      DATE: 02/14/02  ECO: *P04G* */
/* Revision: 1.16.2.13      BY: Luke Pokic        DATE: 07/01/02  ECO: *P09Z* */
/* Revision: 1.16.2.14      BY: Gnanasekar        DATE: 09/11/02  ECO: *N1PG* */
/* Revision: 1.16.2.17      BY: Deepali K.        DATE: 10/07/02  ECO: *N1WM* */
/* Revision: 1.16.2.18      BY: Nishit V.         DATE: 03/20/03  ECO: *N2B0* */
/* Revision: 1.16.2.19      BY: Orawan S.         DATE: 04/21/03  ECO: *P0Q8* */
/* Revision: 1.16.2.21      BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/* Revision: 1.16.2.22      BY: Dorota Hohol       DATE: 09/01/03 ECO: *P0VF* */
/* Revision: 1.16.2.23      BY: Vandna Rohira      DATE: 05/19/04 ECO: *P228* */
/* Revision: 1.16.2.24      BY: Shivanand H        DATE: 09/02/04 ECO: *P2HP* */
/* Revision: 1.16.2.25      BY: Vivek Gogte        DATE: 10/25/04 ECO: *P2QQ* */
/* Revision: 1.16.2.26      BY: Manish Dani        DATE: 11/15/04 ECO: *P2SC* */
/* $Revision: 1.16.2.26.2.1 $ BY: Amandeep Saini        DATE:  11/27/07 ECO: *P6FN* */

/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Maintenance                                                  */
{mfdeclre.i}
{cxcustom.i "APVOMTC.P"}

/* EXTERNAL LABEL INCLUDE */
{gplabel.i}

define shared variable del-yn                like mfc_logical initial no.
define shared variable batch                 like ap_batch.
define shared variable aptotal               like ap_amt.
define shared variable old_amt               like ap_amt.
define shared variable ckdref                like ckd_ref.
define shared variable old_effdate           like ap_effdate.
define shared variable set_sub               as   integer initial 0.
define shared variable set_mtl               as   integer initial 0.
define shared variable fill-all              like mfc_logical initial yes.
define shared variable new_vchr              like mfc_logical.

define shared variable ap_recno              as   recid.
define shared variable vo_recno              as   recid.
define shared variable vd_recno              as   recid.
define shared variable old_vend              like ap_vend.
define shared variable base_amt              like ar_amt.
define shared variable auto-select           like mfc_logical.
define shared variable po-attached           like mfc_logical.
define shared variable desc1                 like bk_desc format "x(30)".
define shared variable undo_all              like mfc_logical.
define shared variable ship-name             like ad_name.
define shared variable old_vo_amt            like ap_amt.
define shared variable first_pass            like mfc_logical.
define shared variable rndmthd               like rnd_rnd_mthd.
define shared variable old_curr              like ap_curr.
define shared variable vchr_logistics_chrgs  like mfc_logical
          label "Voucher Logistics Charges" no-undo.
define shared variable incl_blank_suppliers  like mfc_logical no-undo.
define shared variable l_flag                like mfc_logical no-undo.

{&APVOMTC-P-TAG1}

define new shared variable tax_recno as recid.

define variable i              as   integer.
define variable po-vendor      like po_vend.
define variable msg-arg        as   character format "x(16)" no-undo.

define variable l_sup_choice   like mfc_logical              no-undo.
define variable l_old_voship   like vo_ship                  no-undo.
define variable l_label        as   character                no-undo.
define variable l_mod_supp     like mfc_logical              no-undo.

{&APVOMTC-P-TAG6}
define shared frame vohdr1.
define shared frame vohdr2.
define shared frame vohdr2a.

/* DEFINE VARIABLES FOR VAT REGISTRATION NO. AND COUNTRY CODE */
{apvtedef.i &var=shared}
{gpvtegl.i}

/* DEFINE VARIABLES FOR GPGLEF.P (GL CALENDAR VALIDATION) */
{gpglefdf.i}

define buffer vdmstr for vd_mstr.

/* DEFINE SHARED CURRENCY FORMATTING VARIABLES. */
/* NO NEED TO SET ANYTHING ELSE,                */
/* DISPLAY FORMATS HAVE ALREADY BEEN SET        */
/* VIA THE CALLING PROGRAM APVOMT.P             */
{apcurvar.i}

/*DEFINE SHARED FORMS*/
{apvofmb.i}

/* COMMON EURO VARIABLES */
{etvar.i}

view frame vohdr1.

/* FIELD LIST NOT REQUIRED */
for first ap_mstr
   where recid(ap_mstr) = ap_recno
   exclusive-lock:
end. /* FOR FIRST ap_mstr */

/* FIELD LIST NOT REQUIRED */
for first vo_mstr
   where recid(vo_mstr) = vo_recno
   exclusive-lock:
end. /* FOR FIRST vo_mstr */

for first apc_ctrl
   fields(apc_domain apc_confirm apc_ship apc_multi_entity_pay)
    where apc_ctrl.apc_domain = global_domain no-lock:
end. /* FOR FIRST apc_ctrl */

/* ADD MFC_CTRL FIELD l_mod_supp */
for first mfc_ctrl
   fields (mfc_domain mfc_field mfc_logical)
   where mfc_domain = global_domain
   and   mfc_field  = "l_mod_supp"
   no-lock:
end. /* FOR FIRST mfc_ctrl */

if not available mfc_ctrl
then do transaction:

   l_label = getTermLabel("ALLOW_MODIFICATION_TO_SUPPLIER", 45).

   create mfc_ctrl.
   assign
      mfc_domain  = global_domain
      mfc_field   = "l_mod_supp"
      mfc_type    = "L"
      mfc_label   = l_label
      mfc_module  = "AP"
      mfc_seq     = 32
      mfc_logical = yes.

   if recid(mfc_ctrl) = -1
   then.

end. /* IF NOT AVAILABLE mfc_ctrl */

l_mod_supp = mfc_logical.

display
   ap_vend
   vo_ship
   aptotal
   ap_effdate
   vo_tax_date
   vo_is_ers       /* DISPLAY BUT NEVER UPDATE!! */
with frame vohdr1.


{&APVOMTC-P-TAG5}
do transaction:
   /* INPUT / EDIT ATTACHED PURCHASE ORDER LIST */
   {gprun.i ""xxapvomtc1.p""
      "(input  ap_recno,
        input  vo_recno,
        output po-attached,
        output po-vendor)"}

   /* RETURN TO THE CALLING PROGRAM WITHOUT PROCEEDING */
   /* FURTHER IF l_flag IS SET TO true IN apvomtc1.p   */
   if l_flag = true
   then
      return.

end.  /* TRANSACTION */

vchloop:
do on error undo, leave:

   if new_vchr
      and first_pass
   then
      if po-attached
      then
         ap_vend = po-vendor.

   if vo_curr <> old_curr
      or old_curr = ""
   then do:

      /* GET ROUNDING METHOD FROM CURRENCY MASTER */
      {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
         "(input vo_curr,
           output rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0
      then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
         pause 0.
         undo vchloop, leave vchloop.
      end. /* IF mc-error-number <> 0 */

      old_curr = vo_curr.
   end. /* IF vo_curr <> old_curr OR old_curr = "" */

   /* DETERMINE CURRENCY DEPENDENT FORMATS TO USE */
   if not new_vchr
   then do:
      {apcurfmt.i}
   end. /* IF NOT NEW_VCHR */
   else
   assign
      ap_amt_fmt    = "->,>>>,>>>,>>9.999"
      vo_prepay_fmt = "->,>>>,>>>,>>9.999"
      vo_ndisc_fmt  = "->,>>>,>>>,>>9.999".

   /* SET CURRENCY FORMATS FOR DISPLAY FRAMES */
   assign
      ap_amt:format in frame vohdr1        = ap_amt_fmt
      aptotal:format in frame vohdr1       = ap_amt_fmt
      vo_prepay:format in frame vohdr2a    = vo_prepay_fmt
      vo_hold_amt:format in frame vohdr2a  = vo_holdamt_fmt
      vo_ndisc_amt:format in frame vohdr2a = vo_ndisc_fmt.

   if vo_curr = ""
   then
      aptotal:format in frame vohdr1 = "->,>>>,>>>,>>9.99<".

   display
      ap_vend
      aptotal
      ap_effdate
      vo_ship
      vo_is_ers     /* DISPLAY BUT NEVER UPDATE!! */
   with frame vohdr1.

   display
      vo_curr
      ap_bank
      vo_separate
      vo_invoice
      ap_date
      ap_ckfrm
      ap_expt_date
      vo_cr_terms
      vo_disc_date
      ap_acct
      ap_sub
      ap_cc
      vo_due_date
      vo_disc_date
      ap_disc_acct
      ap_disc_sub
      ap_disc_cc
      ap_rmk
      ap_entity
      {&APVOMTC-P-TAG7}
   with frame vohdr2.
   {&APVOMTC-P-TAG8}

   if (apc_confirm   = no
      and vo_confirm = yes
      and not new_vchr)
   then do:
      /* VOUCHER CONFIRMED. */
      /* NO MODIFICATIONS WITH GL IMPACT ALLOWED */
      {pxmsg.i &MSGNUM=2214 &ERRORLEVEL=2}
   end. /* IF (apc_confirm = no AND vo_confirm = yes AND not new_vchr) */

   if new_vchr
      and first_pass
      and not po-attached
   then do:
      vo_ship = apc_ship.

      display
         vo_ship
      with frame vohdr1.
   end. /* IF new_vchr AND first_pass AND not po-attached */

   if new_vchr
      and first_pass
      and po-attached
   then do:
      for first vpo_det
         fields( vpo_domain vpo_po vpo_ref)
          where vpo_det.vpo_domain = global_domain and  vpo_ref = vo_ref
         no-lock:
      end. /*FOR FIRST vpo_det */

      for first po_mstr
         fields( po_domain po_nbr po_tax_pct po_ship po_cr_terms po_curr)
          where po_mstr.po_domain = global_domain and  po_nbr = vpo_po
         no-lock:

         vo_ship = po_ship.
         do i = 1 to 3:
            vo_tax_pct[i] = po_tax_pct[i].
         end. /*  DO i = 1 TO 3: */
         vo_cr_terms = po_cr_terms.
         vo_curr     = po_curr.

      end. /* FOR FIRST po_mstr */

      display
         vo_ship
      with frame vohdr1.
   end. /* IF new_vchr AND first_pass AND po-attached */

   setb-2:
   do with frame vohdr1 on error undo, retry:
      old_vo_amt = aptotal.
      if not new_vchr
      then
         l_old_voship = vo_ship.

      set
         aptotal
         when (not (apc_confirm = no and vo_confirm = yes and not new_vchr))
         ap_vend
         when (not (apc_confirm = no and vo_confirm = yes and not new_vchr))
         ap_effdate
         when (not (apc_confirm = no and vo_confirm = yes and not new_vchr))
         vo_tax_date
         when (not (apc_confirm = no and vo_confirm = yes and not new_vchr))
         vo_ship
      editing:

         if frame-field = "ap_vend"
         then do on endkey undo setb-2, return:
            {mfnp.i vd_mstr ap_vend  " vd_mstr.vd_domain = global_domain and
            vd_addr "  ap_vend vd_addr vd_addr}
            if recno <> ?
            then do:
               display
                  vd_addr @ ap_vend
                  vd_sort.

               find ad_mstr  where ad_mstr.ad_domain = global_domain and
               ad_addr = vd_addr no-lock no-error.
               if available ad_mstr then
               display ad_line1 ad_city
                  ad_state.

               if new_vchr
                  and first_pass
                  and not po-attached
               then do:
                  vo_curr = vd_curr.

                  if aptotal >= 0
                  then
                     vo_cr_terms = vd_cr_terms.

                  display
                     vo_curr
                     vo_cr_terms
                  with frame vohdr2.
               end. /* IF new_vchr AND first_pass */

               find first ad_mstr  where ad_mstr.ad_domain = global_domain and
               ad_addr = vd_remit
                  no-lock no-error.

               if not available ad_mstr then
               find ad_mstr  where ad_mstr.ad_domain = global_domain and
               ad_addr = vd_addr
                  no-lock no-error.

               if available ad_mstr then
                  display ad_addr ad_name with frame vohdr1.
               else
               display
                  "" @ ad_addr
                  "" @ ad_name
               with frame vohdr1.

               /* DISPLAY VAT REGISTRATION NUMBER AND COUNTRY CODE */
               {apvtedsp.i &addr=vd_addr}

               find ad_mstr  where ad_mstr.ad_domain = global_domain and
               ad_addr = vo_ship no-lock no-error.

               if available ad_mstr then
               display ad_name @ ship-name
               with frame vohdr1.

            end. /* IF RECNO <> ? */
         end.  /* IF FRAME-FIELD = AP_VEND */
         else do:

            if aptotal <> ap_amt
               and not new_vchr
            then
               /* DISPLAY STATUS LINE WITHOUT DELETE OPTION */
               ststatus = stline[3].

            if aptotal <> ap_amt
               and new_vchr
            then
               ststatus = stline[3].
            if aptotal = ap_amt
            then
               ststatus = stline[2].

            status input ststatus.
            readkey.
            /* ENDKEY */
            if keyfunction(lastkey) = "END-ERROR"
            then do:
               undo setb-2, return.
            end.
            /* DELETE */

            /* DISALLOWS DELETION OF A VOUCHER AFTER THE USER    */
            /* SELECTS EDIT ON THE DISPLAY OF MESSAGE            */

            if (lastkey = keycode("F5")
               or  lastkey  = keycode("CTRL-D"))
               and ststatus = stline[2]
            then do:
               del-yn = yes.

               /* PLEASE CONFIRM DELETE */
               run p_msg_confirm
                  (input 11,
                   input 1,
                   input-output del-yn).
               if keyfunction(lastkey) = "END-ERROR"
               then do:
                  undo setb-2, retry.
               end.
               if del-yn
               then
                  leave setb-2.
            end. /* IF (LASTKEY = KEYCODE("F5") ... */
            else
               apply lastkey.
         end. /* ELSE DO (FRAME-FIELD <> AP_VEND */

      end. /* SET... EDITING */

      if vo_ship <> l_old_voship
         and not new_vchr
         and not po-attached
         and not (    not apc_confirm
                  and vo_confirm)
      then do:
         vo_tax_env = "".
         if vo_confirm
         then do:
            /* SHIP-TO CHANGED ON CONFIRMED VOUCHER, CHECK TAX ENVIRONMENT */
            {pxmsg.i &MSGNUM=6683 &ERRORLEVEL=2}
         end. /* IF vo_confirm */
         else do:
            /* SHIP-TO CHANGED ON UNCONFIRMED VOUCHER, CHECK TAX ENVIRONMENT */
            {pxmsg.i &MSGNUM=6684 &ERRORLEVEL=2}
         end. /* ELSE DO IF vo_confirm */
      end. /* IF vo_ship <> l_old_ship ... */

      if vo_tax_date = ?
      then
         vo_tax_date = ap_effdate.

      if ap_vend <> old_vend
         and apc_confirm = no
         and vo_confirm  = yes
         and not first_pass
      then do:
         /*VOUCHER CONFIRMED, CANNOT CHANGE SUPPLIER*/
         {pxmsg.i &MSGNUM=83 &ERRORLEVEL=3}

         /* IF AN ERROR IS ENCOUNTERED IN BATCH MODE l_flag IS SET TO true */
         if batchrun
         then
            l_flag = true.

         next-prompt
            ap_vend
         with frame vohdr1.

         undo setb-2, retry.
      end. /* IF ap_vend <> old_vend AND apc_confirm = no... */

      if aptotal <> old_vo_amt
         and apc_confirm = no
         and vo_confirm  = yes
         and not new_vchr
      then do:
         /*VOUCHER CONFIRMED, CANNOT CHANGE AMOUNT*/
         {pxmsg.i &MSGNUM=80 &ERRORLEVEL=3}

         if batchrun
         then
            l_flag = true.

         next-prompt
            aptotal
         with frame vohdr1.
         undo setb-2, retry.
      end. /* IF aptotal <> old_vo_amt ... */

      if ap_vend <> old_vend
         and vo_applied <> 0
      then do:
         /* PAYMENT APPLIED. MODIFICATION TO SUPPLIER NOT ALLOWED */
         {pxmsg.i &MSGNUM=1171 &ERRORLEVEL=3}

         ap_vend = old_vend.
         display
            ap_vend
         with frame vohdr1.

         if batchrun
         then
            l_flag = true.

         next-prompt
            ap_vend
         with frame vohdr1.

         undo setb-2, retry.
      end. /* IF ap_vend <> old_vend AND vo_applied <> 0 */

      /* ISSUE WARNING WHEN CHANGING SUPPLIER ADDRESS CODE FOR   */
      /* CONFIRMED VOUCHER                                       */
      if ap_vend <> old_vend
         and not new vo_mstr
         and vo_confirmed
      then do:

         if l_mod_supp
         then do:

            for first glt_det
               fields( glt_domain glt_batch glt_doc glt_addr)
                where glt_det.glt_domain = global_domain and  glt_batch = ap_batch
               and   glt_doc   = ap_ref
               no-lock:

               hide message no-pause.
               /* GL TRANSACTION ALREADY EXISTS WITH SUPPLIER #. */
               run p_msg_arg
                  (input 5774,
                   input 1,
                   input glt_addr).

               /* DO YOU WISH TO CONTINUE?              */
               run p_msg_confirm
                  (input 2316,
                   input 1,
                   input-output l_sup_choice).
            end. /* FOR FIRST glt_det */

            if not available glt_det
            then do:
               for first gltr_hist
                  fields( gltr_domain gltr_batch gltr_doc gltr_addr)
                   where gltr_hist.gltr_domain = global_domain and  gltr_batch =
                   ap_batch
                  and   gltr_doc   = ap_ref
                  no-lock:

                  hide message no-pause.
                  /* GL TRANSACTION ALREADY EXISTS WITH SUPPLIER #. */
                  run p_msg_arg
                     (input 5774,
                      input 1,
                      input gltr_addr).

                  /* DO YOU WISH TO CONTINUE?              */
                  run p_msg_confirm
                     (input 2316,
                      input 1,
                      input-output l_sup_choice).
               end. /* FOR FIRST gltr_hist */
            end. /* IF NOT AVAILABLE glt_det */

            if l_sup_choice
            then
               ap_vend = ap_vend:screen-value.
            else do:
               if batchrun
               then
                  l_flag = true.
               undo vchloop, retry vchloop.
            end. /* ELSE DO */

         end. /* IF l_mod_supp */
         else do:

            /* MODIFICATION TO SUPPLIER ON CONFIRMED VOUCHER IS NOT ALLOWED  */
            {pxmsg.i &MSGNUM=8738 &ERRORLEVEL=3}
            if batchrun
            then
               l_flag = true.

            undo vchloop, retry vchloop.

         end. /* ELSE */

      end. /* IF ap_vend <> old_vend AND ... */

      /* CHECK FOR CORRECT VENDOR FOR P.O. */
      if po-attached
      then do:

         if l_mod_supp
         or ap_vend = po-vendor
         then do:

            for first vd_mstr
               fields( vd_domain vd_addr     vd_ap_acct vd_ap_cc
                       vd_ap_sub   vd_bank    vd_ckfrm
                       vd_cr_terms vd_curr    vd_hold
                       vd_prepay   vd_remit   vd_sort)
                where vd_mstr.vd_domain = global_domain and  vd_addr = ap_vend
               no-lock:
            end. /* FOR FIRST vd_mstr */

            do for vdmstr:

               for first vdmstr
                  fields( vd_domain vdmstr.vd_addr)
                   where vdmstr.vd_domain = global_domain and  vdmstr.vd_addr =
                   vd_mstr.vd_addr
                  no-lock:
               end. /* FOR FIRST vdmstr */


               if ap_vend <> po-vendor
               then do:
                  {&APVOMTC-P-TAG2}
                  if vo_curr = vd_curr
                  then do:
                     /* PO PLACED WITH SUPPLIER */
                     run p_msg_arg
                        (input 344,
                         input 2,
                         input po-vendor).
                  end. /* IF vo_curr = vd_curr */
                  else do:
                     /*SUPPLIER CURRENCY MUST BE CONSISTENT WITH PO*/
                     {pxmsg.i &MSGNUM=6225 &ERRORLEVEL=3}

                     if batchrun
                     then
                        l_flag = true.

                     next-prompt
                        ap_vend
                     with frame vohdr1.

                     undo setb-2, retry.
                  end. /* ELSE DO */
               end.  /* IF AP_VEND <> PO-VENDOR */

            end.  /* DO FOR VD_MSTR */

         end. /* IF l_mod_supp */
         else do:

            /* MODIFICATION TO SUPPLIER WITH A PO ATTACHED IS NOT ALLOWED */
            {pxmsg.i &MSGNUM=8739 &ERRORLEVEL=3}
            if batchrun
            then
               l_flag = true.

            undo vchloop, retry vchloop.

         end. /* ELSE */

      end.  /* IF PO-ATTACHED */

      for first vd_mstr
         fields( vd_domain vd_addr     vd_ap_acct vd_ap_cc
                 vd_ap_sub   vd_bank    vd_ckfrm
                 vd_cr_terms vd_curr    vd_hold
                 vd_prepay   vd_remit   vd_sort)
          where vd_mstr.vd_domain = global_domain and  vd_addr = ap_vend
         no-lock:
      end. /* FOR FIRST vd_mstr */

      if available vd_mstr
         and vd_hold
      then do:
         /* SUPPLIER ON PAYMENT HOLD */
         {pxmsg.i &MSGNUM=162 &ERRORLEVEL=2}
      end. /* IF AVAILABLE vd_mstr AND vd_hold */

      if not available vd_mstr
      then do:
         /* NOT A VALID SUPPLIER */
         {pxmsg.i &MSGNUM=2 &ERRORLEVEL=3}

         if batchrun
         then
            l_flag = true.

         next-prompt
            ap_vend
         with frame vohdr1.

         undo setb-2, retry.
      end. /*  IF NOT AVAILABLE vd_mstr */

      else do:
         {&APVOMTC-P-TAG3}

         for first vpo_det
            fields( vpo_domain vpo_ref vpo_po)
             where vpo_det.vpo_domain = global_domain and  vpo_ref = vo_ref
            no-lock:
         end. /* FOR FIRST vpo_det */

         for first po_mstr
            fields( po_domain po_nbr po_tax_pct po_ship po_cr_terms po_curr)
             where po_mstr.po_domain = global_domain and  po_nbr = vpo_po
            no-lock:
         end. /* FOR FIRST po_mstr */

         {&APVOMTC-P-TAG4}

         if available po_mstr
            and new_vchr
            and first_pass
         then
            vo_curr = po_curr.
         else
         if new_vchr
            and not po-attached
            and first_pass
         then
            vo_curr = vd_curr.

         if new_vchr
            and first_pass
         then
            assign
               ap_ckfrm = vd_ckfrm
               ap_bank  = vd_bank.

      end.  /* IF VD_MSTR WAS AVAILABLE... */

      /* NOTE: IF THE VOUCHER IS NEW THE VO_CURR WILL BE SET */
      /* TO THE VENDOR CURRENCY.  IF THIS IS THE CASE, RESET */
      /* THE ROUNDING VALUES AND FORMATS                     */
      if vo_curr <> old_curr
         or old_curr = ""
      then do:

         /* GET ROUNDING METHOD FROM CURRENCY MASTER */
         {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
            "(input vo_curr,
              output rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0
         then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}

            if batchrun
            then
               l_flag = true.

            pause 0.
            undo setb-2, retry setb-2.
         end. /* IF mc-error-number <> 0 */

         /* DETERMINE CURRENCY DEPENDENT FORMATS TO USE */
         if not new_vchr
         then do:
            {apcurfmt.i}
         end. /* IF NOT NEW_VCHR */
         else
            assign
               ap_amt_fmt    = "->,>>>,>>>,>>9.999"
               vo_prepay_fmt = "->,>>>,>>>,>>9.999"
               vo_ndisc_fmt  = "->,>>>,>>>,>>9.999".

         /* SET CURRENCY FORMATS FOR DISPLAY FRAMES */
         assign
            ap_amt:format in frame vohdr1        = ap_amt_fmt
            aptotal:format in frame vohdr1       = ap_amt_fmt
            vo_prepay:format in frame vohdr2a    = vo_prepay_fmt
            vo_hold_amt:format in frame vohdr2a  = vo_holdamt_fmt
            vo_ndisc_amt:format in frame vohdr2a = vo_ndisc_fmt
            old_curr                             = vo_curr.

      end.  /* IF OLD_CURR <> VO_CURR */

      /* VALIDATE SHIP-TO */
      if vo_ship <> ""
      then do:
         find first ad_mstr
              where ad_mstr.ad_domain = global_domain and  ad_addr = vo_ship
              no-lock no-error.

         if not available ad_mstr
         then do:
            /* NOT A VALID SHIP-TO */
            {pxmsg.i &MSGNUM=13 &ERRORLEVEL=3}

            if batchrun
            then
               l_flag = true.

            next-prompt
               vo_ship
            with frame vohdr1.

            undo setb-2, retry.
         end. /* IF NOT AVAILABLE ad_mstr */
      end. /* IF vo_ship <> "" */

      if  not apc_confirm
      and vo_confirm
      and not new_vchr
      and l_old_voship <> vo_ship
      then do:
         /* CONFIRMED VOUCHER. CHANGE OF SHIP-TO WILL HAVE NO IMPACT ON TAX */
         {pxmsg.i &MSGNUM=6042 &ERRORLEVEL=2}.
      end. /* IF apc_confirm ... */

      if not new_vchr
         and first_pass
         and (ap_vend   <> old_vend)
         and (base_curr <> vd_curr)
      then do:
         /*FOREIGN CURRENCY VENDOR CAN'T BE CHANGED */
         {pxmsg.i &MSGNUM=86 &ERRORLEVEL=3}

         if batchrun
         then
            l_flag = true.

         next-prompt
            ap_vend
         with frame vohdr1.
         undo setb-2, retry.
      end. /* IF NOT new_vchr AND first_pass and ... */

      /* DISPLAY VENDOR NAME & REMIT TO VENDOR */
      if available vd_mstr
      then do:

         display
            vd_sort
         with frame vohdr1.

         find first ad_mstr  where ad_mstr.ad_domain = global_domain and
         ad_addr = vd_addr no-lock no-error.

         if available ad_mstr
         then
            display
               ad_line1
               ad_city
               ad_state .

         if new_vchr
            and first_pass
            and not po-attached
         then do:
            if aptotal >= 0
            then
               vo_cr_terms = vd_cr_terms.

            vo_curr = vd_curr.
         end. /* IF new_vchr AND first_pass AND NOT po-attached */

         if ap_bank <> ""
            and (ap_entity = gl_entity)
            and not(apc_multi_entity_pay = yes
                    and new_vchr         = no)
         then do:
            for first bk_mstr
               fields( bk_domain bk_code bk_entity)
                where bk_mstr.bk_domain = global_domain and  bk_code = ap_bank
               no-lock:
               ap_entity = bk_entity.
            end. /* FOR FIRST bk_mstr */

         end. /* IF ap_bank <> "" AND (ap_entity = gl_entity) AND .. */

         display
            vo_ship
         with frame vohdr1.

         display
            vo_curr
            ap_bank
            ap_entity
            vo_cr_terms
         with frame vohdr2.

         find first ad_mstr  where ad_mstr.ad_domain = global_domain and
         ad_addr = vd_remit no-lock no-error.

         if not available ad_mstr
         then
            find first ad_mstr  where ad_mstr.ad_domain = global_domain and
            ad_addr = input ap_vend no-lock no-error.

         if available ad_mstr
         then
            display
               ad_addr
               ad_name
            with frame vohdr1.
         else
            display
               "" @ ad_addr
               "" @ ad_name
            with frame vohdr1.

         /* DISPLAY VAT REGISTRATION NUMBER AND COUNTRY CODE */
         {apvtedsp.i &addr="input ap_vend"}

         find first ad_mstr  where ad_mstr.ad_domain = global_domain and
         ad_addr = vo_ship no-lock no-error.

         if available ad_mstr
         then
            display
               ad_name @ ship-name
            with frame vohdr1.

         /* GIVE MESSAGE IF VENDOR PREPAYMENT BALANCE EXISTS */
         if vd_prepay <> 0
         then do:
            msg-arg = string(vd_prepay) + " " + base_curr.

            /* SUPPLIER HAS PREPAYMENT BALANCE OF # */
            run p_msg_arg
               (input 43,
                input 1,
                input msg-arg).
            bell.
         end. /* IF vd_prepay <> 0 */

      end. /* IF AVAILABLE vd_mstr */

      if new_vchr
         and first_pass
      then
         assign
            old_vend = ap_vend
            ap_acct  = vd_ap_acct
            ap_sub   = vd_ap_sub
            ap_cc    = vd_ap_cc
            ap_curr  = vo_curr.
      {&APVOMTC-P-TAG9}
      /* DO NOT ALLOW CHANGE TO EFFECTIVE DATE ON EXISTING          */
      /* CONFIRMED VOUCHER,                                         */
      /* BECAUSE EXISTING LINES HAVE BEEN CREATED (MAYBE POSTED)    */
      /* TO GL ON THE ORIGINAL DATE AND FURTHER LINES ADDED WILL    */
      /* BE POSTED TO A NEW DATE, MAKING RECONCILING BETWEEN AP     */
      /* AND GL DIFFICULT.                                          */
      if not new_vchr
         and vo_confirm  =  yes
         and old_effdate <> ap_effdate
      then do:
         /* DATE CHANGE NOT ALLOWED */
         {pxmsg.i &MSGNUM=47 &ERRORLEVEL=2}
         ap_effdate = old_effdate.

         display
            ap_effdate
         with frame vohdr1.
      end. /* IF NOT new_vchr... */

      /* VERIFY GL EFFECTIVE DATE FOR PRIMARY ENTITY     */
      /* (USE PRIMARY SINCE THEY CAN EDIT ENITY FIELD IN */
      /* THE NEXT FRAME - USE WARNING IF POSSIBLE)       */
      {gpglef01.i ""AP"" glentity ap_effdate}

      if gpglef > 0
      then do:
         /* IF PERIOD CLOSED THEN WARNING ONLY */
         if gpglef = 3036
         then do:
            /* OTHERWISE REGULAR ERROR MESSAGE */
            {pxmsg.i &MSGNUM=3005 &ERRORLEVEL=2}
         end. /* IF gpglef = 3036 */
         else
         if gpglef <> 3036
         then do:
            {pxmsg.i &MSGNUM=gpglef &ERRORLEVEL=3}

            if batchrun
            then
               l_flag = true.

            next-prompt
               ap_effdate
            with frame vohdr1.

            undo setb-2, retry.
         end. /*  ELSE IF gpglef <> 3036 */
      end. /* IF gpglef > 0 */

      /* RESET INVOICE DATE WHEN EFFECTIVE DATE IS MODIFIED FOR A VOUCHER */
      if not new_vchr
         and ap_effdate entered
      then do:
         for each vph_hist
            where vph_domain = global_domain
            and   vph_ref    = vo_ref
            exclusive-lock:
            vph_inv_date = ap_effdate.
         end. /* FOR EACH vph_hist */
      end. /* IF NOT new_vchr */

   end. /* END SECTION OF SETB-2 */

   if available vd_mstr
   then
      vd_recno = recid(vd_mstr).

   else
      if batchrun
      then
         l_flag = true.

   undo_all = no.

end.  /* VCHLOOP */

/* ADDED PROCEDURE TO REMOVE REDUNDANCY */
PROCEDURE p_msg_arg:
   define input parameter i_err_msg like msg_nbr  no-undo.
   define input parameter i_err_lvl like msg_nbr  no-undo.
   define input parameter i_arg1    like glt_addr no-undo.

   {pxmsg.i &MSGNUM=i_err_msg &ERRORLEVEL=i_err_lvl &MSGARG1=i_arg1}

END PROCEDURE. /* p_msg_arg */

PROCEDURE p_msg_confirm:
   define input        parameter i_err_msg  like msg_nbr     no-undo.
   define input        parameter i_err_lvl  like msg_nbr     no-undo.
   define input-output parameter io_confirm like mfc_logical no-undo.

   {pxmsg.i &MSGNUM=i_err_msg &ERRORLEVEL=i_err_lvl &CONFIRM=io_confirm}

END PROCEDURE. /* p_msg_confirm */
