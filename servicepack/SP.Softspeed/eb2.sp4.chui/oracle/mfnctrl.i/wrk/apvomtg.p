/* apvomtg.p - AP VOUCHER MAINTENANCE SUBPROGRAM                            */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.12.2.11 $                                                         */
/*V8:ConvertMode=Maintenance                                                */
/* REVISION: 7.3            CREATED: 03/29/93   BY: JMS  *G698*             */
/*                    LAST MODIFIED: 04/23/93   BY: JJS  *GA30*             */
/*                    LAST MODIFIED: 06/28/93   BY: wep  *GC75*             */
/* REVISION: 7.4      LAST MODIFIED: 08/20/93   BY: pcd  *H079*             */
/*                                   10/29/93   BY: pcd  *H199*             */
/*                                   02/07/94   BY: srk  *GI33*             */
/*                                   02/25/94   BY: jjs  *H283*             */
/*                                   07/25/94   by: pmf  *FP52*             */
/*                                   10/10/94   by: str  *FS24*             */
/*                                   04/24/95   by: pmf  *H0D7*             */
/*                                   06/13/95   by: jzw  *G0Q3*             */
/* REVISION: 8.5      LAST MODIFIED: 09/26/95   BY: MWD  *J053*             */
/* REVISION: 8.5      LAST MODIFIED: 02/27/96   BY: *J0CV* Brandy J Ewing   */
/* REVISION: 8.6      LAST MODIFIED: 06/17/96   BY: bjl  *K001*             */
/*                                   07/27/96   by: *J12H* M. Deleeuw       */
/*                                   10/01/96   by: svs  *K007*             */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton     */
/* REVISION: 8.6E     LAST MODIFIED: 09/15/98   BY: *J2ZR* Abbas Hirkani    */
/* REVISION: 8.6E     LAST MODIFIED: 11/11/98   BY: *J345* Prashanth Narayan*/
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas*/
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari  */
/* Pre-86E commented code removed, view in archive revision 1.8             */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00 BY: *N0KK* jyn                */
/* REVISION: 9.1      LAST MODIFIED: 08/21/00 BY: *N0MG* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F238*                  */
/* Old ECO marker removed, but no ECO header exists *F303*                  */
/* Old ECO marker removed, but no ECO header exists *F807*                  */
/* Old ECO marker removed, but no ECO header exists *G418*                  */
/* Old ECO marker removed, but no ECO header exists *G537*                  */
/* REVISION: 9.1      LAST MODIFIED: 08/03/00   BY: *N0W0* BalbeerS Rajput  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.12.2.8 BY: Mamata Samant         DATE: 03/20/02  ECO: *P04F*  */
/* Revision: 1.12.2.9   BY: Ed van de Gevel DATE: 05/08/02 ECO: *P069* */
/* Revision: 1.12.2.10     BY: Samir Bavkar          DATE: 02/14/02  ECO: *P04G*  */
/* $Revision: 1.12.2.11 $    BY: Luke Pokic     DATE: 07/01/02 ECO: *P09Z* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "APVOMTG.P"}
/* EXTERNAL LABEL INCLUDE */
{gplabel.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apvomtg_p_1 "Batch"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvomtg_p_2 "Control"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvomtg_p_4 "Voucher All"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{gldydef.i}
{gldynrm.i}

define shared variable apref           like ap_ref.
define shared variable batch           like ap_batch       label {&apvomtg_p_1}.
define shared variable bactrl          like ba_ctrl.
define shared variable aptotal         like ap_amt         label {&apvomtg_p_2}.
define shared variable fill-all        like mfc_logical initial yes
                                                           label {&apvomtg_p_4}.
define shared variable desc1           like bk_desc format "x(30)".
define shared variable ship-name       like ad_name.
define shared variable ba_recno        as   recid.
define shared variable auto-select     like mfc_logical.
define shared variable rndmthd         like rnd_rnd_mthd.
define shared variable old_curr        like vo_curr.
define shared variable vchr_logistics_chrgs  like mfc_logical
   label "Voucher Logistics Charges" no-undo.
define shared variable incl_blank_suppliers  like mfc_logical no-undo.

define        variable apc_ext_ref     like mfc_logical.
define        variable inbatch         like ba_batch.
define        variable retval          as integer no-undo.
define        variable mc-error-number like msg_nbr no-undo.

define shared frame voucher.
define shared frame order.
define shared frame vohdr1.
define shared frame vohdr2.
define shared frame vohdr2a.
define shared frame vohdr3.
define shared frame a.

{&APVOMTG-P-TAG1}
/* DEFINE VARIABLES FOR DISPLAY OF VAT REG NUMBER AND COUNTRY CODE */
{apvtedef.i &var="shared"}

/* DEFINE CURRENCY FORMATTING VARIABLES */
{apcurvar.i}

for first gl_ctrl
   fields (gl_base_curr gl_rnd_mthd)
no-lock:
end. /* FOR FIRST gl_ctrl */
/* DEFINE FORM A */
{apvofma.i}

/*DEFINE FORM B*/
{apvofmb.i}

do transaction:
   for first apc_ctrl
      fields (apc_vchr_all apc_voucher)
   no-lock:
   end. /* FOR FIRST apc_ctrl */
   assign
      fill-all = apc_vchr_all
      batch    = batch.
   if available ba_mstr
   then
      display ba_total with frame a.

   clear frame voucher   no-pause.
   clear frame order all no-pause.
   clear frame vohdr1    no-pause.
   clear frame vohdr2    no-pause.
   clear frame vohdr2a   no-pause.
   clear frame vohdr3    no-pause.
   auto-select = no.

   loopg:
   do on error undo, retry:
      prompt-for ap_ref with frame voucher
      editing:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp01.i ap_mstr ap_ref ap_ref batch ap_batch ap_batch}
         if recno <> ?
         then do:

            /*** GET RNDMTHD AND FORMATTING FOR NEW CURRENCY ***/
            if ap_curr <> old_curr
            or old_curr = ""
            then do:

               /* GET ROUNDING METHOD FROM CURRENCY MASTER */
               {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                  "(input ap_curr,
                    output rndmthd,
                    output mc-error-number)"}
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                  pause 0.
                  undo loopg, retry loopg.
               end. /* IF mc-error-number <> 0 */

               /* DETERMINE CURRENCY DEPENDENT FORMATS */
               {apcurfmt.i}
               old_curr = ap_curr.
            end.  /* IF ap_curr <> old_curr */

            aptotal = ap_amt.
            display ap_ref with frame voucher.

            /* SET CURRENCY DEPENDENT FORMAT FOR DISPLAY FRAME */
            assign
               ap_amt:format  in frame vohdr1 = ap_amt_fmt
               aptotal:format in frame vohdr1 = ap_amt_fmt.

            display aptotal ap_amt ap_effdate ap_vend
            with frame vohdr1.
            for first vo_mstr
               fields (vo_cr_terms vo_curr vo_disc_date vo_due_date vo_hold_amt
                       vo_invoice vo_is_ers vo_ndisc_amt vo_prepay vo_ref
                       {&APVOMTG-P-TAG3}
                       vo_separate vo_ship vo_tax_date vo_type vo__qad02)
               where vo_ref = ap_ref
            no-lock:
            end. /* FOR FIRST vo_mstr */

            if available vo_mstr
            then do:

               for first vd_mstr
                  fields (vd_addr vd_remit vd_sort)
                  where vd_addr = ap_vend
               no-lock:
               end. /* FOR FIRST vd_mstr */
               if available vd_mstr
               then
                  display vd_sort with frame vohdr1.
               else
                  display " " @ vd_sort with frame vohdr1.

               display
                  aptotal
                  vo_tax_date
                  vo_ship
                  vo_is_ers          /* DISPLAY BUT NEVER UPDATE!! */
               with frame vohdr1.

               /* SET CURRENCY DEPENDENT FORMAT FOR DISPLAY FRAME */
               assign
                  vo_hold_amt:format in frame vohdr2a  = vo_holdamt_fmt
                  vo_ndisc_amt:format in frame vohdr2a = vo_ndisc_fmt
                  vo_prepay:format in frame vohdr2a    = vo_prepay_fmt.

               display
                  vo_invoice
                  ap_date
                  vo_cr_terms
                  vo_disc_date
                  vo_due_date
                  ap_acct
                  ap_sub
                  ap_cc
                  ap_disc_acct
                  ap_disc_sub
                  ap_disc_cc
                  vo_curr
                  ap_entity
                  vo_separate
                  ap_ckfrm
                  vo_type
                  ap_bank
                  ap_rmk
                  vo__qad02
                  ap_expt_date
               with frame vohdr2.
               {&APVOMTG-P-TAG2}

            end. /* IF AVAILABLE VO_MSTR... */

            if available vd_mstr
            then
               for first ad_mstr
                  fields (ad_addr ad_city ad_country ad_county ad_format
                          ad_line1 ad_line2 ad_line3 ad_name ad_pst_id
                          ad_state ad_zip)
                  where ad_addr = vd_remit
               no-lock:
               end. /* for first ad_mstr */

            if not available ad_mstr
            then
               for first ad_mstr
                  fields (ad_addr ad_city ad_country ad_county ad_format
                          ad_line1 ad_line2 ad_line3 ad_name ad_pst_id
                          ad_state ad_zip)
                  where ad_addr = ap_vend
               no-lock:
               end. /* for first ad_mstr */
            if available ad_mstr
            then
               display ad_addr ad_name with frame vohdr1.
            else
               display "" @ ad_addr "" @ ad_name with frame vohdr1.

            /* DISPLAY VAT REGISTRATION NUMBER AND COUNTRY CODE */
            {apvtedsp.i &addr=ap_vend}

            for first ad_mstr
               fields (ad_addr ad_city ad_country ad_county ad_format
                       ad_line1 ad_line2 ad_line3 ad_name ad_pst_id
                       ad_state ad_zip)
               where ad_addr = vo_ship
            no-lock:
               display ad_name @ ship-name with frame vohdr1.
            end. /* FOR FIRST ad_mstr */
         end. /* IF RECNO <> "" */
      end. /* PROMPT-FOR...EDITING */

      if input ap_ref = ""
      then do:
         {mfnctrl.i apc_ctrl apc_voucher vo_mstr vo_ref apref}
         display apref @ ap_ref with frame voucher.
         release apc_ctrl.
      end. /* IF input ap_ref = "" */
      else
         apref = input ap_ref.

      for first ap_mstr
         fields (ap_acct ap_amt ap_bank ap_batch ap_cc ap_ckfrm ap_curr ap_date
                 ap_disc_acct ap_disc_cc ap_disc_sub ap_dy_code ap_effdate
                 ap_entity ap_expt_date ap_open ap_ref ap_rmk ap_sub ap_type
                 ap_vend)
         where ap_ref  = input ap_ref
           and ap_type = "RV"
      no-lock:
      end. /* FOR FIRST ap_mstr */
      if available ap_mstr
      then do:
         /*REFERENCE EXISTS FOR ANOTHER TYPE*/
         {pxmsg.i &MSGNUM=751 &ERRORLEVEL=3}
         undo loopg, retry.
      end. /* IF available ap_mstr */

      for first ap_mstr
         fields (ap_acct ap_amt ap_bank ap_batch ap_cc ap_ckfrm ap_curr ap_date
                 ap_disc_acct ap_disc_cc ap_disc_sub ap_dy_code ap_effdate
                 ap_entity ap_expt_date ap_open ap_ref ap_rmk ap_sub ap_type
                 ap_vend)
         where ap_ref  = input ap_ref
           and ap_type = "VO"
      no-lock:
      end. /* FOR FIRST ap_mstr */
      if  available ap_mstr
      and ap_amt <> 0
      and ap_open = no
      then do:
         /*WARNING VOUCHER PAID IN FULL*/
         {pxmsg.i &MSGNUM=1246 &ERRORLEVEL=3}
         undo loopg, retry.
      end. /* IF AVAILABLE ap_mstr AND ... */

      if not available ap_mstr
      then do:

         /* IF EXTERNAL REFERENCE NOT ALLOWED, REQUIRE THAT NEW
            VOUCHER NUMBER BE SYSTEM GENERATED */

         /* ADD MFC_CTRL FIELD apc_ext_ref IF NECESSARY */
         for first mfc_ctrl
            fields (mfc_field mfc_label mfc_logical mfc_module mfc_seq mfc_type)
            where mfc_field = "apc_ext_ref"
         no-lock:
         end. /* FOR FIRST mfc_ctrl */
         if not available mfc_ctrl
         then do:
            create mfc_ctrl.

            assign
               mfc_label   = getTermLabel("EXTERNAL_REFERENCES_ALLOWED",24)
               mfc_field   = "apc_ext_ref"
               mfc_type    = "L"
               mfc_module  = "AP"
               mfc_seq     = 30
               mfc_logical = yes.
         end. /* IF NOT AVAILABLE mfc_ctrl */
         apc_ext_ref = mfc_logical.

         if  apc_ext_ref = no
         and ap_ref entered
         then do:
            /* INVALID VOUCHER REFERENCE */
            {pxmsg.i &MSGNUM=2211 &ERRORLEVEL=3}
            display "" @ ap_ref with frame voucher.
            undo loopg, retry.
         end. /* IF apc_ext_ref = no AND... */

         /* NEW VOUCHER CANNOT HAVE SAME FIRST 2 CHARACTERS AS A BANK */
         /* BUT VOUCHERS CREATED BEFORE THE BANK ARE STILL ACCESSIBLE */
         if can-find(bk_mstr
                       where bk_code = substring(apref,1,2))
         then do:
            /* VOUCHER REFERENCE CANNOT BEGIN WITH BANK CODE */
            {pxmsg.i &MSGNUM=1213 &ERRORLEVEL=3}
            undo loopg, retry.
         end. /* IF CAN-FIND(bk_mstr... */

         /* ADDING NEW RECORD */
         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}

         /* DETERMINE CURRENCY DEPENDENT FORMATS */
         assign
            rndmthd        = gl_rnd_mthd
            old_curr       = gl_base_curr.
         {apcurfmt.i}
         assign
            ap_amt_fmt    = "->,>>>,>>>,>>9.999"
            vo_prepay_fmt = "->,>>>,>>>,>>9.999"
            vo_ndisc_fmt  = "->,>>>,>>>,>>9.999".

      end. /* IF NOT AVAILABLE ap_mstr */
      else do:
         /** NOT A NEW VOUCHER ***/
         if batch = ""
         then
            batch = ap_batch.

         if ap_curr <> old_curr
         or old_curr = ""
         then do:

            /* GET ROUNDING METHOD FROM CURRENCY MASTER */
            {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
               "(input ap_curr,
                 output rndmthd,
                 output mc-error-number)"}
            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
               pause 0.
               undo loopg, retry loopg.
            end. /* IF mc-error-number <> 0 */
         end. /* IF ap_curr <> old_curr OR */

         /* GET DISPLAY FORMAT (_FMT) */
         {apcurfmt.i}
         old_curr = ap_curr.
      end.  /* IF NOT AVAILABLE ap_mstr ELSE */

      /* SET CURRENCY DEPENDENT FORMAT FOR DISPLAY FRAMES*/
      assign
         ap_amt:format       in frame vohdr1  = ap_amt_fmt
         aptotal:format      in frame vohdr1  = ap_amt_fmt
         vo_hold_amt:format  in frame vohdr2a = vo_holdamt_fmt
         vo_ndisc_amt:format in frame vohdr2a = vo_ndisc_fmt
         vo_prepay:format    in frame vohdr2a = vo_prepay_fmt.

      if batch <> ""
      then do:
         for first ba_mstr
            fields (ba_batch ba_ctrl ba_module ba_total)
            where ba_batch  = batch
              and ba_module = "AP"
         no-lock:
           bactrl = ba_ctrl.
         end. /* FOR FIRST ba_mstr */
      end. /* IF batch <> "" */

      /*ADDED PROCEDURE TO GET THE NEXT BATCH NUMBER AND CREATE   */
      /*THE BATCH MASTER(BA_MSTR).  IF THE BA_MSTR ALREADY EXISTS */
      /*THE RECORD WILL BE UPDATED.                               */
      inbatch = batch.
      {gprun.i ""gpgetbat.p""
         "(input inbatch,   /*IN-BATCH       */
           input ""AP"",    /*MODULE         */
           input ""VO"",    /*DOC TYPE       */
           input bactrl,    /*CONTROL AMT    */
           output ba_recno, /*NEW BATCH RECID*/
           output batch)"}  /*NEW BATCH #    */
      display batch bactrl with frame a.

   end. /*LOOPG: DO...*/
end. /* TRANSACTION */
