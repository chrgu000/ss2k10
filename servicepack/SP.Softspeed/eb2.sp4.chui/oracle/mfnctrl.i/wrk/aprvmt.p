/* aprvmt.p - AP RECURRING VOUCHER MAINTENANCE                                */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.12.1.12 $                                      */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.3      LAST MODIFIED: 10/14/92   by: mlv *G042*                */
/*                                   09/28/92   by: mpp *G475*                */
/*                                   01/11/93   by: bcm *G418*                */
/*                                   03/17/93   by: jjs *G842*                */
/* REVISION: 7.4      LAST MODIFIED: 08/05/93   by: wep *H052*                */
/*                                   11/02/93   by: wep *H211*                */
/*                                   12/03/93   by: jjs *H262*                */
/*                                   01/03/94   by: jjs *H271*                */
/*                                   01/03/94   by: jjs *H272*                */
/*                                   02/25/94   by: pcd *H199*                */
/*                                   03/03/94   by: bcm *H290*                */
/*                                   06/14/94   by: bcm *H383*                */
/*                                   07/25/94   by: pmf *FP52*                */
/*                                   08/24/94   by: cpp *GL39*                */
/*                                   08/10/94   by: bcm *H496*                */
/*                                   09/12/94   by: slm *GM17*                */
/*                                   09/20/94   by: bcm *H531*                */
/*                                   11/06/94   by: ame *GO17*                */
/*                                   11/09/94   by: srk *GO05*                */
/*                                   01/23/95   by: str *H09Y*                */
/*                                   02/27/95   by: str *G0FW*                */
/*                                   02/28/95   by: pxe *G0G0*                */
/*                                   03/20/95   by: wjk *H0C3*                */
/*                                   04/10/95   by: srk *H0CG*                */
/*                                   04/23/95   by: aed *H0D6*                */
/* REVISION: 8.5      LAST MODIFIED: 07/11/95   by: cdt *J057*                */
/*                                   11/1/95    by: mwd *J053*                */
/* REVISION: 8.6      LAST MODIFIED: 07/15/96   BY: BJL *K001*                */
/*                                   07/27/96   by: *J12H* M. Deleeuw         */
/*                                   08/21/96   by: pmf *J148*                */
/*                                   01/28/97   by: rxm *J1FR*                */
/*                                   02/17/97   by: *K01R* E. Hughart         */
/*                                   03/25/97   by: *K084* Jeff Wootton       */
/* Pre-86E commented code removed, view in archive revision 1.9               */
/* Old ECO marker removed, but no ECO header exists *J0P7*                    */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 11/17/98   BY: *J34F* Vijaya Pakala      */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari    */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* REVISION: 9.1      LAST MODIFIED: 11/22/00   BY: *L15T* Veena Lad          */
/* REVISION: 9.1      LAST MODIFIED: 08/03/00   BY: *N0W0* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.12.1.7     BY: Katie Hilbert   DATE: 04/01/01  ECO: *P002*     */
/* Revision: 1.12.1.8     BY: Mamata Samant   DATE: 01/14/02  ECO: *M1Q5*     */
/* Revision: 1.12.1.9     BY: Jean Miller     DATE: 04/27/02  ECO: *P05V*     */
/* Revision: 1.12.1.11    BY: Samir Bavkar    DATE: 06/20/02  ECO: *P09D*     */
/* $Revision: 1.12.1.12 $ BY: Manjusha Inglay DATE: 07/29/02  ECO: *N1P4*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "2+ "}
{cxcustom.i "APRVMT.P"}

{gldydef.i new}
{gldynrm.i new}

define new shared variable vod_recno   as recid.
define new shared variable ba_recno    as recid.
define new shared variable ap_recno    as recid.
define new shared variable vo_recno    as recid.
define new shared variable vd_recno    as recid.
define new shared variable tax_recno   as recid.
define new shared variable yes_char    as character format "x(1)".
define new shared variable no_char     as character format "x(1)".
define new shared variable set_sub     as integer initial 0.
define new shared variable set_mtl     as integer initial 0.
define new shared variable new_vchr    like mfc_logical initial no.
define new shared variable del-yn      like mfc_logical initial no.
define new shared variable undo_all    like mfc_logical.
define new shared variable fill-all    like mfc_logical
   label "Voucher All" initial yes.
define new shared variable curr_amt    like glt_curr_amt.
define new shared variable ship-name   like ad_name.
define new shared variable bactrl      like ba_ctrl.
define new shared variable totinvdiff  like ap_amt.
define new shared variable old_vend    like ap_vend.
define new shared variable base_amt    like ar_amt.
define new shared variable desc1       like bk_desc format "x(30)".
define new shared variable jrnl        like glt_ref.
define new shared variable batch       like ap_batch label "Batch".
define new shared variable aptotal     like ap_amt   label "Control".
define new shared variable old_amt     like ap_amt.
define new shared variable ckdref      like ckd_ref.
define new shared variable old_vo_amt  like ap_amt.
define new shared variable zone_to     like txe_zone_to.
define new shared variable zone_from   like txe_zone_from.
define new shared variable tax_class   like ad_taxc no-undo.
define new shared variable tax_usage   like ad_tax_usage no-undo.
define new shared variable tax_taxable like ad_taxable no-undo.
define new shared variable tax_in      like ad_tax_in no-undo.
define new shared variable undo_tframe like mfc_logical.
define new shared variable rndmthd    like rnd_rnd_mthd.
define new shared variable old_curr   like ap_curr.
define new shared variable retval     as integer.
define new shared variable l_flag     like mfc_logical no-undo initial false.
define new shared variable vchr_logistics_chrgs like mfc_logical no-undo.

/* USED FOR SCROLLING WINDOW SWCSBD.P */
define new shared variable supp_bank   like ad_addr no-undo.
define new shared variable process_tax like mfc_logical.
define new shared variable tax_tr_type like tx2d_tr_type initial "32".
define new shared variable pmt_exists  like mfc_logical initial false.
define new shared variable tax_date    like ap_date.
define new shared variable taxchanged  as logical no-undo.

define variable apref             like ap_ref.
define variable first_vo_in_batch like mfc_logical.
define new shared variable valid_acct        like mfc_logical.
define variable inbatch           like ba_batch.
define variable ctrldiff          as decimal no-undo.
define variable action            as character format "x(1)" no-undo.
define variable mc-error-number like msg_nbr no-undo.

define new shared variable csbdtype as character format "x(5)" no-undo.
{&APRVMT-P-TAG1}

define buffer apmstr1 for ap_mstr.
define buffer vomstr1 for vo_mstr.

define new shared frame a.
define new shared frame b.

/* DEFINE CURRENCY-DEPENDENT FORMATTING VARIABLES */
{apcurvar.i "new"}

/* FORM DEFINITIONS FOR FRAMES A AND B */
{aprvfrm.i}

&if defined(gpfieldv) = 0 &then
   &global-define gpfieldv
   {gpfieldv.i}  /* INCLUDE VARIABLES NEEDED FOR GPFIELD.I */
&endif
{&APRVMT-P-TAG2}
find first gl_ctrl no-lock.

{gprun.i ""gldydft.p"" "(input ""AP"",
                         input ""RV"",
                         input gl_entity,
                         output dft-daybook,
                         output daybook-desc)"}

/*FIND FIRST CHARACTERS OF YES/NO IN mfc_logical*/
{gpfield.i &field_name='mfc_logical'}

assign
   yes_char = (substring(field_format,1,1))
   no_char = (substring(field_format,index(field_format,"/") + 1,1)).

assign
   ap_amt_old   = ap_amt:format
   vo_ndisc_old = vo_ndisc_amt:format.

mainloop:
repeat with frame a:

   do transaction:

      view frame a.
      view frame b.
      status input.

      assign
         bactrl = 0
         batch = "".

      set batch with frame a.

      if batch <> "" then do:

         find first ap_mstr where ap_batch = batch no-lock no-error.

         if available ap_mstr and ap_type <> "RV" then do:
            {pxmsg.i &MSGNUM=1170 &ERRORLEVEL=3}
            /*NOT A VALID BATCH*/
            pause.
            next-prompt batch with frame a.
            undo, retry.
         end.

         find ba_mstr where ba_batch = batch and ba_module = "AP"
         exclusive-lock no-error.

         if available ba_mstr then do:
            assign
               bactrl = ba_ctrl
               /*INSURE BATCH TOTAL = SUM OF VOUCHERS*/
               ba_total = 0.
            for each ap_mstr where ap_batch = ba_batch no-lock:
               ba_total = ba_total + ap_amt.
            end.
            display ba_total with frame a.
         end.
         else display 0 @ ba_total with frame a.

      end.

      else
         display
            0 @ bactrl
            0 @ ba_total
         with frame a.

      update bactrl with frame a.

      /*DON'T CHG BA_CTRL IF MODIFICATION AND LEFT AT 0*/
      if available ba_mstr and bactrl <> 0 then
         ba_ctrl = bactrl.

      assign
         first_vo_in_batch = yes
         desc1 = "".

   end. /* transaction */

   loopb:
   repeat with frame b:

      do transaction:

         find first apc_ctrl no-lock.

         view frame dtitle.

         assign
            fill-all = apc_vchr_all
            batch = input batch.

         if available ba_mstr then
            display ba_total with frame a.

         clear frame b no-pause.

         prompt-for ap_mstr.ap_ref
         editing:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp01.i ap_mstr ap_ref ap_ref batch ap_batch ap_batch}
            if recno <> ? then do:

               if ap_curr <> old_curr or old_curr = "" then do:

                  /* GET ROUNDING METHOD FROM CURRENCY MASTER */
                  {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                     "(input ap_curr,
                       output rndmthd,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                     pause 0.
                     undo loopb, retry loopb.
                  end.

                  /* GET FORMATTING STRINGS TO USE */
                  {apcurfmt.i}
                  old_curr = ap_curr.
               end.

               assign
                  ap_amt:format       in frame b = ap_amt_fmt
                  aptotal:format      in frame b = ap_amt_fmt
                  vo_ndisc_amt:format in frame b = vo_ndisc_fmt
                  aptotal = ap_amt.

               display
                  ap_ref aptotal ap_amt ap_vend
               with frame b.

               find vo_mstr where vo_ref = ap_ref no-lock no-error.

               if available vo_mstr then
               display
                  vo_rcycle
                  vo_rnbr_cyc
                  vo_rstart
                  vo_rexpire
                  vo_rel_date
                  vo_po
                  vo_invoice
                  ap_date
                  vo_cr_terms
                  vo_ndisc_amt
                  ap_acct
                  ap_sub
                  vo_ship
                  ap_cc
                  ap_disc_acct
                  ap_disc_sub
                  ap_disc_cc
                  vo_curr
                  vo__qad02
                  ap_entity
                  vo_separate
                  ap_ckfrm
                  vo_type
                  vo_confirmed
                  ap_bank
                  ap_rmk
               with frame b.

               find vd_mstr where vd_addr = ap_vend no-lock no-error.
               if available vd_mstr then
                  display vd_sort with frame b.
               else
                  display " " @ vd_sort with frame b.

               if available vd_mstr then
                  find first ad_mstr where ad_addr = vd_remit
                  no-lock no-error.

               if not available ad_mstr then
                  find ad_mstr where ad_addr = ap_vend
                  no-lock no-error.

               if available ad_mstr then
                  display ad_addr ad_name with frame b.
               else
                  display "" @ ad_addr "" @ ad_name with frame b.

               find first ad_mstr where ad_addr = vo_ship
               no-lock no-error.
               if available ad_mstr then
                  display ad_name @ ship-name with frame b.

               if ap_bank <> "" then
                  find bk_mstr where bk_code = ap_bank
                  no-lock no-error.

               if available bk_mstr then
                  display bk_desc @ desc1 with frame b.

            end.  /* IF RECNO <> "" */

         end.  /* PROMPT-FOR...EDITING */

         if input ap_ref = "" then do:
            {mfnctrl.i apc_ctrl apc_voucher vo_mstr vo_ref apref}
            display apref @ ap_ref with frame b.
         end.
         else
            apref = input ap_ref.

         find ap_mstr where ap_ref = input ap_ref and ap_type = "VO"
         no-lock no-error.
         if available ap_mstr then do:
            {pxmsg.i &MSGNUM=751 &ERRORLEVEL=3}
            /*REFERENCE EXISTS FOR ANOTHER TYPE*/
            undo loopb, retry.
         end.

         find ap_mstr where ap_ref = input ap_ref and ap_type = "RV"
         no-error.
         if available ap_mstr and ap_open = no then do:
            {pxmsg.i &MSGNUM=77 &ERRORLEVEL=3}
            /*RECUR VOUCHER EXPIRED - MODIFICATION NOT ALLOWED*/
            undo loopb, retry.
         end.

         if not available ap_mstr then do:
            {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1} /* ADDING NEW RECORD */
         end.
         else if batch = "" then batch = ap_batch.

         /* UPDATE-GENERATE BATCH RECORD, */
         /* SET TO "NU" (NOT USED) IF NEW */
         inbatch = batch.
         {gprun.i ""gpgetbat.p"" "(input  inbatch,  /*IN-BATCH #  */
                                   input  ""AP"",   /*MODULE      */
                                   input  ""RV"",   /*DOC TYPE    */
                                   input  bactrl,   /*CONTROL AMT */
                                   output ba_recno, /*NEW BAT RECID*/
                                   output batch)"}  /*NEW BATCH # */

      end. /*TRANSACTION*/

      loopc:
      do transaction while true:
         view frame dtitle.

         /* ADD/MOD/DELETE  */
         find first apc_ctrl no-lock.
         assign
            fill-all = apc_vchr_all
            new_vchr = no
            process_tax = no.

         find ap_mstr where ap_ref = input ap_ref and ap_type = "RV"
         no-error.
         if not available ap_mstr then do:

            find first apc_ctrl no-lock.

            create ap_mstr.
            assign
               ap_ref ap_type = "RV"
               ap_batch = batch
               ap_date = today
               ap_open = yes
               ap_entity = gl_entity
               ap_effdate = today
               ap_dy_code = dft-daybook
               ap_curr = gl_base_curr
               aptotal = 0.

            if recid(ap_mstr) = -1 then .

            create vo_mstr.
            assign
               vo_ref = ap_ref
               vo_recur = yes
               vo_rstart = today
               vo_rcycle = "M"
               vo_rnbr_cyc = 1
               vo_ship = apc_ship
               vo_curr = ap_curr
               vo_confirmed = apc_confirm.

            if recid(vo_mstr) = -1 then .

            assign
               new_vchr = yes
               process_tax = yes
               ap_disc_acct = gl_apds_acct
               ap_disc_sub = gl_apds_sub
               ap_disc_cc = gl_apds_cc.

            display
               vo_rstart
               vo_rcycle
               vo_rnbr_cyc
               ap_date
               ap_disc_acct
               ap_disc_sub
               ap_disc_cc
               ap_entity
               vo_ship
               vo_confirmed
            with frame b.

         end. /*ADD NEW*/

         else do:
            find vo_mstr where vo_ref = input ap_ref.
            assign
               aptotal = ap_amt
               old_vo_amt = aptotal.
         end.

         /* CHECK THAT VOUCHER IS IN BATCH */
         if batch <> "" and  batch <> ap_batch then do:
            {pxmsg.i &MSGNUM=1152 &ERRORLEVEL=3}
            pause.
            undo, retry.
         end.

         /* CREATE OR UPDATE BATCH MASTER IF VOUCHER */
         if first_vo_in_batch then do:
            if batch = "" then batch = ap_batch.
            find ba_mstr where ba_batch = batch and ba_module = "AP"
            exclusive-lock no-error.
            first_vo_in_batch = no.
         end.

         display
            ba_batch @ batch
            ba_ctrl @ bactrl
            ba_total
         with frame a.

         if ap_curr <> old_curr or old_curr = "" then do:
            /* GET ROUNDING METHOD FROM CURRENCY MASTER */
            {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
               "(input ap_curr,
                 output rndmthd,
                 output mc-error-number)"}
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
               pause 0.
               undo loopb, retry loopb.
            end.
            {apcurfmt.i}
            old_curr = ap_curr.
         end.

         assign
            ap_amt:format       in frame b = ap_amt_fmt
            aptotal:format      in frame b = ap_amt_fmt
            vo_ndisc_amt:format in frame b = vo_ndisc_fmt.

         display
            ap_ref
            aptotal
            ap_amt
            ap_vend
            vo_rcycle
            vo_rnbr_cyc
            vo_rstart
            vo_rexpire
            vo_rel_date
            vo_po
            vo_invoice
            ap_date
            vo_cr_terms
            vo_ndisc_amt
            ap_acct
            ap_sub
            vo_ship
            ap_cc
            ap_disc_acct
            ap_disc_sub
            ap_disc_cc
            vo_curr
            vo__qad02
            ap_entity
            vo_separate
            ap_ckfrm
            vo_type
            vo_confirmed
            ap_bank
            ap_rmk
         with frame b.

         if ap_bank <> "" then
            find bk_mstr where bk_code = ap_bank no-lock no-error.

         if available bk_mstr then
            display bk_desc @ desc1 with frame b.

         /* BACKOUT BATCH TOTALS*/
         assign
            ba_total = ba_total - ap_amt
            old_amt = ap_amt - vo_applied
            old_vend = ap_vend
            recno = recid(ap_mstr)
            del-yn = no
            ap_recno = recid(ap_mstr)
            vo_recno = recid(vo_mstr)
            undo_all = yes.

         /* UPDATE FIRST HEADER FRAME */
         {gprun.i ""aprvmta.p""}
         if undo_all then undo loopb, retry.

         if del-yn then do:
            undo_all = yes.
            /* DELETE RECURRING VOUCHER */
            {gprun.i ""aprvmtb.p""}

            if undo_all then undo loopb, retry loopb.
            clear frame b no-pause.
            del-yn = no.
            next loopb.
         end.

         ststatus = stline[3].
         status input ststatus.

         /* SUPP_BANK IS USED IN SCROLLING WINDOW SWCSBD.P */
         supp_bank = ap_vend.

         /* DEFAULT CUSTOMER/SUPPLIER BANK FROM */
         /* FIRST AVAILABLE C/S BANK DETAIL     */
         if vo__qad02 = "" then do:
            find first csbd_det where csbd_addr = ap_vend
               and csbd_beg_date <=  vo_rstart
               and csbd_end_date >= vo_rexpire no-lock no-error.
            if available csbd_det then vo__qad02 = csbd_bank.
         end.

         assign
            ap_recno = recid(ap_mstr)
            vo_recno = recid(vo_mstr).

         /* For field vo__qad02 in sub-program aprvmtc.p */
         {gpbrparm.i &browse=adlu031.p &parm=c-brparm1 &val=supp_bank}

         /* UPDATE SECOND HEADER FRAME, AND SPOT RATE FRAME */
         {gprun.i ""aprvmtc.p""}

         if keyfunction(lastkey) = "end-error" or
            keyfunction(lastkey) = "." then do:
            undo, retry.
         end.

         assign
            ap_ex_rate = vo_ex_rate
            ap_ex_rate2 = vo_ex_rate2
            ap_ex_ratetype = vo_ex_ratetype
            ap_curr = vo_curr.

         /* COPY VO RATE USAGE TO AP RATE USAGE */
         {gprunp.i "mcpl" "p" "mc-copy-ex-rate-usage"
            "(input vo_exru_seq,
              output ap_exru_seq)"}

         assign vo_invoice.
         if vo_invoice <> "" then do:
            invoice-loop:
            for each vomstr1
               where vomstr1.vo_invoice = vo_mstr.vo_invoice
                 and vomstr1.vo_ref <> vo_mstr.vo_ref
            no-lock:
               find first apmstr1
                  where apmstr1.ap_ref = vomstr1.vo_ref
                   and apmstr1.ap_type = "VO"
                   and apmstr1.ap_vend = ap_mstr.ap_vend
               no-lock no-error.
               if available apmstr1 then do:
                  {pxmsg.i &MSGNUM=2201 &ERRORLEVEL=2 &MSGARG1=apmstr1.ap_ref}
                  leave invoice-loop.
               end.
            end.
         end.

         assign
            ap_recno = recid(ap_mstr)
            vo_recno = recid(vo_mstr).

         undo_tframe = true.

         /* EDIT GTM TAX FIELDS */
         {gprun.i ""apvomte.p""}

         if undo_tframe then
            /* l_flag IS SET TO true IN BATCH MODE IN apvomte.p */
            /* FOR AN ERROR ENCOUNTERED.                        */
            if not l_flag
            then
               undo, retry.
            else
               undo mainloop, leave mainloop.

         hide frame a no-pause.
         hide frame b no-pause.

         /* INPUT DETAIL LINES */
         {gprun.i ""apvomtb.p"" "(input 1)"}

         /* l_flag IS SET TO true IN BATCH MODE IN apvomtb.p */
         /* FOR AN ERROR ENCOUNTERED.                        */
         if l_flag then
            undo mainloop, leave mainloop.

         /* FIND DEFAULT SUPPLIER BANK ACCOUNT */
         /* WHEN APRVMT.P IS BROUGHT IN LINE   */
         /* WITH APVOMT.P SUPPLIER BANK SHOULD */
         /* BECOME AN INPUT OPTION.            */
         if vo__qad02 = "" then do:
            find first csbd_det where csbd_addr = ap_vend
            no-lock no-error.
            if available csbd_det then
               vo__qad02 = csbd_bank.
         end.
         {&APRVMT-P-TAG3}

         repeat:
            /* TRAP UNDO */
            if not can-find(first vod_det
               where vod_det.vod_ref = vo_ref)
               and (ap_amt - vo_applied = 0) then do:
               {pxmsg.i &MSGNUM=1159 &ERRORLEVEL=2} /* DELETING REFERENCE */
               pause.
            end.
            leave.
         end.

         if not can-find(first vod_det
                         where vod_det.vod_ref = vo_ref)
                         and (ap_amt - vo_applied = 0)
         then do:

            /* DELETE AP RATE USAGE */
            {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
               "(input ap_exru_seq)"}

            delete ap_mstr.

            /* DELETE VO RATE USAGE */
            {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
               "(input vo_exru_seq)"}

            delete vo_mstr.

         end.

         else
         if (aptotal <> ap_amt and aptotal <> 0)
         then do on error undo, leave:

            view frame a.
            view frame b.

            display ap_amt with frame b.

            assign
               ctrldiff = ap_amt - aptotal
               action = "2".

            bell.

            action_block:
            do on endkey undo, retry:
               input clear.
               /* Control: #  Distribution: #  Difference: */
               {pxmsg.i &MSGNUM=1163 &ERRORLEVEL=1
                        &MSGARG1=aptotal
                        &MSGARG2=ap_amt
                        &MSGARG3=ctrldiff}
               /*V8-*/
               /* 1:Accept/2:Edit/3:Cancel */
               {pxmsg.i &MSGNUM=1721 &ERRORLEVEL=1 &CONFIRM=action
                        &CONFIRM-TYPE='NON-LOGICAL'}
               /*V8+*/
               /*V8!
               /* ADDED SECOND, THIRD, FOURTH AND FIFTH PARAMETER */
               {gprun.i ""gpaecupd.p"" "(input-output action,
                                         input 1721,
                                         input getTermLabel('&Accept', 9),
                                         input getTermLabel('&Edit', 9),
                                         input getTermLabel('&Cancel', 9))"}
               */
               if action = "2" then next loopc.
               else if action = "3" then undo loopb, retry.
               else if action <> "1" then undo action_block, retry.
            end. /*action_block*/

         end. /*APTOTAL <> AP_AMT AND APTOTAL <> 0*/

         leave. /*EXIT LOOPC*/

      end. /* transaction */

   end. /* LOOPB */

   if available ba_mstr then
   do transaction:
      if ba_ctrl <> ba_total then do:
         ba_status = "UB". /*unbalanced*/
         if ba_ctrl <> 0 then do:
            {pxmsg.i &MSGNUM=1151 &ERRORLEVEL=2}
            pause.
         end.
      end.
      else
      if can-find(first ap_mstr where ap_batch = ba_batch)
         then ba_status = "". /*open, balanced*/
      else ba_status = "NU".  /*not used*/
      release ba_mstr.
   end.
end. /* MAINLOOP */

status input.
{&APRVMT-P-TAG4}
