/* apvcmt.p - AP VOID CHECK MAINTENANCE                                    */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* $Revision: 1.16.1.20 $                                          */
/*V8:ConvertMode=Maintenance                                               */
/* REVISION: 1.0      LAST MODIFIED: 09/13/86   by: PML                    */
/* REVISION: 6.0      LAST MODIFIED: 09/03/91   by: mlv *D845*             */
/*                                   12/16/91   by: mlv *F074*             */
/*                                   02/03/92   by: mlv *F147*             */
/* REVISION: 7.0      LAST MODIFIED: 02/21/92   by: mlv *F224*             */
/*                                   03/06/92   by: mlv *F257*             */
/*                                   05/14/92   by: mlv *F493*             */
/* REVISION: 7.3      LAST MODIFIED: 04/23/93   by: jms *GA21* (rev only)  */
/*                                   06/07/93   by: jms *G934*             */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   by: pcd *H039*             */
/*                                   09/16/93   by: bcm *H110*             */
/*                                   11/20/93   by: wep *H241*             */
/*                                   12/07/93   by: wep *H264*             */
/*                                   07/01/94   by: bcm *H425*             */
/*                                   08/24/94   by: cpp *GL39*             */
/*                                   08/30/94   by: pmf *FQ59*             */
/*                                   09/12/94   by: slm *GM17*             */
/*                                   11/06/94   by: ame *GO17*             */
/*                                   02/21/95   by: wjk *F0JQ*             */
/*                                   04/24/95   by: wjk *H0CS*             */
/*                                   06/22/95   by: jzw *F0SV*             */
/* REVISION: 8.5      LAST MODIFIED: 11/01/95   by: mwd *J053*             */
/*                                   07/15/96   by: jwk *G1ZW*             */
/*                                   07/15/96   by: *J0VY* Marianna Deleeuw */
/*                                   07/27/96   by: *J12H* Marianna Deleeuw */
/* REVISION: 8.6      LAST MODIFIED: 06/11/96   BY: BJL *K001*              */
/*                                   11/18/96   BY: jpm *K020*              */
/*                                   02/17/97   BY: *K01R* E. Hughart       */
/*                                   03/12/97   BY: *K07F* E. Hughart       */
/*                                   04/09/97   BY: *J1NH* Robin McCarthy   */
/*                                   05/05/97   BY: *H0X5* Robin McCarthy   */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 03/31/98   by: *J2D8* Kawal Batra      */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton     */
/* Pre-86E commented code removed, view in archive revision 1.13            */
/* Old ECO marker removed, but no ECO header exists *H246*                  */
/* REVISION: 8.6E     LAST MODIFIED: 09/18/98   BY: *J30B* Santhosh Nair    */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Paul Johnson      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 08/21/00   BY: *N0MG* Mudit Mehta       */
/* REVISION: 9.1      LAST MODIFIED: 08/02/00   BY: *N0VQ* Mudit Mehta       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.16.1.9     BY: Katie Hilbert     DATE: 05/03/01  ECO: *N0Y7*  */
/* Revision: 1.16.1.10    BY: Ed van de Gevel   DATE: 11/09/01  ECO: *N15N*  */
/* Revision: 1.16.1.12    BY: Rajaneesh S.      DATE: 03/18/02  ECO: *N1DK*  */
/* Revision: 1.16.1.17    BY: Veena Lad         DATE: 04/08/02  ECO: *M1X4*  */
/* Revision: 1.16.1.18    BY: Ed van de Gevel   DATE: 05/08/02 ECO: *P069* */
/* Revision: 1.16.1.19    BY: Manjusha Inglay   DATE: 07/29/02 ECO: *N1P4* */
/* $Revision: 1.16.1.20 $  BY: Ed van de Gevel    DATE: 08/21/02 ECO: *P0G2*    */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}
{cxcustom.i "APVCMT.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apvcmt_p_1 "Eff Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvcmt_p_2 "Cur"
/* MaxLen: 3 Comment: */

&SCOPED-DEFINE apvcmt_p_3 "Batch Ctrl"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvcmt_p_7 "Total"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvcmt_p_8 "Type"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{gldydef.i new}
{gldynrm.i new}

define new shared variable trtype       as character.
define new shared variable apbuffrecid  as recid.
define new shared variable ckrecid      as recid.
define new shared variable aprecid      as recid.
define new shared variable ckdrecid     as recid.
define new shared variable bkrecid      as recid.
define new shared variable vorecid      as recid.
define new shared variable jrnl         like glt_ref.
define new shared variable base_amt     like ap_amt.
define new shared variable base_disc    like ap_amt.
define new shared variable gain_amt     like ap_amt.
define new shared variable undo_all     like mfc_logical.
define new shared variable curr_amt     like glt_curr_amt.
define new shared variable curr_disc    like glt_curr_amt.
define new shared variable base_det_amt like glt_amt.
define new shared variable ref          like ap_ref
   format "X(14)".
define new shared variable gen_desc     like glt_desc.
define new shared variable bank         like ck_bank.
define new shared variable for_curr_amt like ckd_cur_amt.
define new shared variable tot-vtadj    as decimal.
define new shared variable rndmthd      like rnd_rnd_mthd.
define new shared variable old_curr     like ap_curr.
define new shared variable batch        like ap_batch initial "".

define variable barecid      as recid.
define variable del-yn       like mfc_logical initial no.
define variable batch_ctrl   like ap_amt label {&apvcmt_p_3}.
define variable batch_total  like ap_amt label {&apvcmt_p_7}.
define variable gltline      like glt_line.
define variable yn           like mfc_logical.
define variable new_ck       like mfc_logical.
define variable amt_to_apply like ap_amt.
define variable inbatch      like ba_batch.
define variable new_batch    like mfc_logical.
define variable set_bank     like mfc_logical initial no.
define variable rndamt       like ap_amt.
define variable ap_amt_fmt   as character no-undo.
define variable ap_amt_old   as character no-undo.
define variable remit-name   like ad_mstr.ad_name no-undo.
define variable mc-error-number like msg_nbr no-undo.
define variable l_ap_rmk     as character format "x(24)" no-undo.
define variable l_daybook    like dy_dy_code             no-undo.
{&APVCMT-P-TAG15}
define new shared buffer apmstr for ap_mstr.

/* DEFINE VARIABLES FOR GPGLEF.P (GL CALENDAR VALIDATION) */
{gpglefdf.i}
assign
   l_ap_rmk = getTermLabel("SEE_NEXT_CHECK",24)
   trtype = "void".

/* DEFINE FORM A FOR CONTROL INFO. - FORM A */
form
   space(1)
   batch         colon 8
   ba_bank       colon 25
   bk_curr       colon 35 label {&apvcmt_p_2}
   batch_ctrl    colon 57 format "->>>>>>>,>>>,>>9.999"
   dft-daybook   colon 8
   ba_date       colon 35 label {&apvcmt_p_1}
   batch_total   colon 57 format "->>>>>>>,>>>,>>9.999"
with side-labels frame a width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DEFINE SELECTION FORM B*/
{&APVCMT-P-TAG1}
form
   ck_nbr format "999999"
   ap_amt
   ap_date        at 26
   ck_type        at 36 label {&apvcmt_p_8}
   ap_vend        at 40
   ad_name
with frame b down width 80 no-attr-space.
{&APVCMT-P-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

/* INITIALIZATION READS */
find first gl_ctrl no-lock.

do transaction:
   /* GET NEXT JOURNAL REFERENCE NUMBER  */
   {mfnctrl.i apc_ctrl apc_jrnl glt_det glt_ref jrnl}
end.

ap_amt_old = ap_amt:format.

mainloop:
repeat with frame a:
   /********************************************************************/
   view frame a.
   status input.

   /* INITIALIZE CONTROL VARS */
   assign
      set_bank    = no
      new_batch   = no
      ckrecid     = ?
      batch_ctrl  = 0
      batch_total = 0
      l_daybook   = ""
      batch       = "".

   prompt-for batch with frame a
      editing:
      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp01.i ba_mstr batch ba_batch ""CV"" ba_doc_type
         ba_modbatch}
      if recno <> ? then do:

         if daybooks-in-use
         then
            run p_get_daybook(input  ba_batch,
                              output l_daybook).

         display
            ba_batch @ batch
            ba_bank
            l_daybook @ dft-daybook
            ba_date
            ba_ctrl @ batch_ctrl
            ba_total @ batch_total
         with frame a.

         find first bk_mstr where bk_code = ba_bank no-lock no-error.
         if available bk_mstr then display bk_curr with frame a.

      end.
   end.

   assign batch.
   if batch <> "" then do:
      find ba_mstr where ba_batch = batch and ba_module = "AP"
      no-lock no-error.
      if not available ba_mstr then do:
         assign
            new_batch = yes
            batch_ctrl  = 0
            batch_total = 0.
         display
            batch_total
            "" @ ba_bank
            "" @ dft-daybook
            "" @ bk_curr
            batch_ctrl
         with frame a.
      end.
      else do:
         if available ba_mstr and ba_doc_type <> "CV" /*check void*/
         then do:
            /* MSG: BATCH ALREADY ASSIGNED */
            {pxmsg.i &MSGNUM=1182 &ERRORLEVEL=3}
            pause.
            next-prompt batch with frame a.
            undo, retry.
         end.
         else do:     /*AVAILABLE AND "CV"*/
            assign
               bank      = ba_bank
               new_batch = no
               set_bank  = no.

            /* DO NOT ALLOW UPDATE OF BANK OR EFFECTIVE DATE IF */
            /* STATUS IS ANYTHING OTHER THAN "NU" (NOT USED)    */
            if ba_status <> "NU" then
               set_bank   = yes.

            if daybooks-in-use
            then
               run p_get_daybook(input  ba_batch,
                                 output dft-daybook).

            assign
               batch_ctrl  = ba_ctrl
               batch_total = ba_total.
            display
               batch
               batch_ctrl
               ba_bank
               dft-daybook when (set_bank)
               ba_date
               batch_total
            with frame a.
         end.
      end.
   end.
   else new_batch = yes.

   /* GET THE NEXT BATCH NUMBER AND CREATE */
   /* THE BATCH MASTER (BA_MSTR).  IF THE BA_MSTR ALREADY EXISTS */
   /* THE RECORD WILL BE UPDATED                                 */
   do transaction:
      inbatch = batch.
      {gprun.i ""gpgetbat.p"" "(input  inbatch,  /*IN-BATCH #     */
           input  ""AP"",   /*MODULE         */
           input  ""CV"",   /*DOC TYPE       */
           input  batch_ctrl, /*CONTROL AMT  */
           output barecid,  /*NEW BATCH RECID*/
           output batch)"}  /*NEW BATCH #    */

      if new_batch then
      display
         batch
         "" @ ba_bank
         "" @ dft-daybook
         0 @ batch_ctrl
         0 @ batch_total
      with frame a.
      else
         display batch with frame a.
   end.

   do transaction on error undo mainloop, retry mainloop:

      find ba_mstr where ba_batch = batch and ba_module = "AP"
      exclusive-lock no-error.

      /* CHECK "NEW" FLAG TO SEE IF THE RECORD EXISTS*/
      /* CHANGED REFERENCES FOR NEW RECORD           */
      /* FROM "NEW BA_MSTR" to "NEW_BATCH"           */
      if new_batch and not set_bank then do:
         {&APVCMT-P-TAG12}
         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}  /*ADDING RECORD*/
      end.
      else do:
         /* TO RE-INITIALIZE DAYBOOK VALUE */
         if ba_bank = ""
         then
            display
               "" @ dft-daybook
            with frame a.
         {pxmsg.i &MSGNUM=10 &ERRORLEVEL=1} /*MODIFY RECORD*/
      end.

      update
         ba_bank when (not set_bank)
         batch_ctrl
      with frame a.

      ba_ctrl = batch_ctrl.

      find first bk_mstr where bk_code = ba_bank no-lock no-error.
      if not available bk_mstr then do:
         /* Not a valid bank */
         {pxmsg.i &MSGNUM=1200 &ERRORLEVEL=3}
         undo, retry.
      end.
      else display bk_curr with frame a.

      if not set_bank
      then do:
         if daybooks-in-use
         then do:
            {gprun.i ""gldydft.p"" "(input ""AP"",
                                     input ""CV"",
                                     input bk_entity,
                                     output dft-daybook,
                                     output daybook-desc)"}
            l_daybook = dft-daybook.

            display
               l_daybook @ dft-daybook
            with frame a.
         end. /* IF daybooks-in-use */

         do on error undo, retry:
            update
               dft-daybook when (daybooks-in-use)
               ba_date
            with frame a.

            /* VALIDATE EFFECTIVE DATE */
            {gpglef.i ""AP"" bk_entity ba_date}

            /* VALIDATE DAYBOOK */
            if daybooks-in-use
            then do:
               if not can-find(dy_mstr
                               where dy_dy_code = dft-daybook)
               then do:
                  /* INVALID DAYBOOK */
                  {pxmsg.i &MSGNUM=1299 &ERRORLEVEL=3}
                  next-prompt dft-daybook with frame a.
                  undo, retry.
               end. /* IF NOT CAN-FIND(dy_mstr ...) */
               else do:
                  {gprun.i ""gldyver.p"" "(input ""AP"",
                                           input ""CV"",
                                           input dft-daybook,
                                           input bk_entity,
                                           output daybook-error)"}
                  if daybook-error
                  then do:
                     /* DAYBOOK DOES NOT MATCH ANY DEFAULT */
                     {pxmsg.i &MSGNUM=1674 &ERRORLEVEL=2 &PAUSEAFTER=TRUE}
                  end. /* IF daybook-error */

                  {gprunp.i "nrm" "p" "nr_can_dispense"
                     "(input dft-daybook,
                       input ba_date)"}

                  {gprunp.i "nrm" "p" "nr_check_error"
                     "(output daybook-error,
                       output return_int)"}

                  if daybook-error
                  then do:
                     {pxmsg.i &MSGNUM=return_int &ERRORLEVEL=3}
                     next-prompt dft-daybook with frame a.
                     undo, retry.
                  end. /* IF daybook-error */

                  for first dy_mstr
                     fields (dy_desc dy_dy_code)
                     where dy_dy_code = dft-daybook
                     no-lock:
                     daybook-desc = dy_desc.
                  end. /* FOR FIRST dy_mstr */
               end. /* ELSE DO */

            end. /* IF daybooks-in-use */

         end. /* DO ON ERROR ... */

      end. /* IF NOT set_bank */

      /* DO NOT ALLOW UPDATE OF BANK BEYOND THIS POINT IF NEW BATCH */
      assign
         set_bank = true
         bank     = ba_bank.

   end. /*transaction*/

   clear frame b all no-pause.

   loopb:
   repeat with frame b down:

      do transaction:
         display batch_total with frame a.
         new_ck = no.
         prompt-for ck_mstr.ck_nbr
            editing:

            {mfnp01.i cksd_det ck_nbr cksd_nbr batch cksd_batch
               cksd_batch}

            {&APVCMT-P-TAG3}
            if recno <> ? then do:
               {&APVCMT-P-TAG4}
               find ck_mstr where ck_nbr = cksd_nbr and
                  ck_bank = bank no-lock no-error.

               find ap_mstr where ap_ref = ck_ref
                  and ap_type = "CK" no-lock.

               find ad_mstr where ad_addr = ap_vend no-lock no-error.

               remit-name = "".
               {gprun.i ""apmisccr.p"" "(input ck_mstr.ck_ref,
                    output remit-name)"}

               if ap_curr <> old_curr or old_curr = "" then do:

                  /* GET ROUNDING METHOD FROM CURRENCY MASTER */
                  {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                     "(input ck_curr,
                       output rndmthd,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                     pause 0.
                     undo loopb, retry loopb.
                  end.
                  ap_amt_fmt = ap_amt_old.
                  {gprun.i ""gpcurfmt.p"" "(input-output ap_amt_fmt,
                       input rndmthd)"}
                  assign
                     old_curr = ck_curr
                     ap_amt:format in frame b = ap_amt_fmt.
               end.

               display
                  ck_nbr
                  (- ap_amt) @ ap_amt
                  ap_date
                  ck_type
                  ap_vend
               with frame b.

               if remit-name <> "" then
                  display remit-name @ ad_name with frame b.
               else
                  if available ad_mstr then display ad_name with frame b.
            end.
         end.  /*END PROMPT-FOR*/

         /* FIND CK_MSTR. */
         find first ck_mstr where ck_nbr = input ck_nbr and
            ck_bank = bank no-error.

         if not available ck_mstr then do:
            {&APVCMT-P-TAG5}

            {pxmsg.i &MSGNUM=4021 &ERRORLEVEL=2}
            /*WARNING: CHECK NUMBER NOT FOUND*/
            yn = no.
            do on endkey undo loopb, retry:
               /*DO YOU WISH TO VOID*/
               {pxmsg.i &MSGNUM=38 &ERRORLEVEL=1 &CONFIRM=yn
                  &CONFIRM-TYPE='LOGICAL'}
               if yn then do:
                  new_ck = yes.

                  /*CREATE CHECK NOT IN SYSTEM*/
                  create ck_mstr.
                  assign
                     ck_bank     = string(bk_code, "X(2)")
                     ck_nbr      = input ck_nbr
                     ck_ref      = string(ck_bank, "X(2)" )
                     {&APVCMT-P-TAG13}
                     + string(ck_nbr)
                     {&APVCMT-P-TAG14}
                     ck_type     = "MN"
                     ck_status   = "VOID"
                     ck_voiddate = today
                     ck_voideff  = ba_date
                     ck_curr     = bk_curr.
                  if recid(ck_mstr) = -1 then .

                  create ap_mstr.

                  assign
                     ap_rmk     = getTermLabel("VOID_CHECK_NOT_IN_SYSTEM",24)
                     ap_type    = "CK"
                     ap_batch   = ba_batch
                     ap_ref     = ck_ref
                     ap_curr    = bk_curr
                     ap_acct    = bk_acct
                     ap_sub     = bk_sub
                     ap_cc      = bk_cc
                     ap_date    = today
                     ap_effdate = ba_date
                     ap_dy_code = dft-daybook.
                  if recid(ap_mstr) = -1 then .

               end. /* IF YN THEN DO */
               else undo loopb, retry.
            end. /* DO ON ENDKEY UNDO RETRY LOOPB */
            {&APVCMT-P-TAG6}
         end. /* IF NOT AVAIL CK_MSTR */

         if ck_curr <> old_curr or old_curr = "" then do:

            /* GET ROUNDING METHOD FROM CURRENCY MASTER */
            {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
               "(input ck_curr,
                 output rndmthd,
                 output mc-error-number)"}
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
               pause 0.
               undo loopb, retry loopb.
            end.
            ap_amt_fmt = ap_amt_old.
            {gprun.i ""gpcurfmt.p"" "(input-output ap_amt_fmt,
                 input rndmthd)"}
            assign
               old_curr = ck_curr
               ap_amt:format in frame b = ap_amt_fmt.
         end. /* IF CK_CURR <> OLD_CURR */

         /* LOCATE AP_MSTR */
         find ap_mstr where ap_ref = ck_ref and ap_type = "CK"
            no-error.

         if ck_status <> "VOID" then
         assign
            ck_voideff = ba_date
            ck_voiddate = ba_date.

         if available ap_mstr then
         display
            ck_nbr
            (- ap_amt) @ ap_amt
            ap_date
            ck_type
            ap_vend
         with frame b.

         find ad_mstr where ad_addr = ap_vend no-lock no-error.

         remit-name = "".
         {gprun.i ""apmisccr.p"" "(input ck_mstr.ck_ref,
              output remit-name)"}

         if remit-name <> "" then
            display remit-name @ ad_name with frame b.
         else
            if available ad_mstr then display ad_name with frame b.

         if (ck_status = "VOID" and new_ck = no)
            or ck_status = "CANCEL" then do:
            {pxmsg.i &MSGNUM=1203 &ERRORLEVEL=3} /*CHECK IS VOID OR CANCELED*/
            pause.
            clear frame b.
            undo, retry.
         end.
         {&APVCMT-P-TAG7}

         if new_ck = no then do:
            del-yn = no.
            /* IS ALL INFORMATION CORRECT */
            {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=del-yn
               &CONFIRM-TYPE='LOGICAL'}

         end.

         if del-yn = yes or new_ck then do:
            /* BACKOUT BATCH TOTALS */
            batch_total = batch_total - ap_amt.

            /* APVCMT.I IS A COMMON INCLUDE USED BY */
            /* VOID CK MAINT AND VOID A RANGE AT AUTO CHECK PRINT */

            gen_desc = getTermLabel("AP_VOID_PAYMENT",24).
            {apvcmt.i}
            down 1.

            /* CREATE CKSD_DET */
            {&APVCMT-P-TAG8}
            find first cksd_det where cksd_batch = ba_batch and
               cksd_nbr = ck_nbr no-lock no-error.
            {&APVCMT-P-TAG9}
            if not available cksd_det then do:
               create cksd_det.
               assign
                  cksd_nbr   = ck_nbr
                  cksd_batch = ba_batch
                  cksd_acct  = ap_acct
                  cksd_sub   = ap_sub
                  cksd_cc    = ap_cc.
               if recid(cksd_det) = -1 then .
            end.

            other-forms:
            repeat on error undo, leave:
               find prev ck_mstr no-lock no-error.
               if not available ck_mstr then leave.
               if ck_status <> "VOID" then leave.
               if available ck_mstr then
               find ap_mstr
                  where ap_ref = ck_ref and ap_type = "CK" and
                  ap_rmk = l_ap_rmk no-lock no-error.
               if not available ap_mstr then leave.
               if available ap_mstr then do:
                  /* Also reference voided check form number: */
                  {pxmsg.i &MSGNUM=1206 &ERRORLEVEL=1 &MSGARG1=ck_nbr}
               end.
            end.
         end. /* IF DEL-YN = YES */
         else do:
            /* DO NOT VOID */
            assign
               ck_voiddate = ?
               ck_voideff = ?.
            clear frame b.
         end.

         if ref <> ""
            and daybooks-in-use
         then do:
            /* NOW GET THE SEQUENCE NUMBER FROM THE nr_mstr */
            /* AND UPDATE THE glt_det                       */
            for first ap_mstr
               fields(ap_acct ap_amt ap_base_amt ap_batch ap_cc
                      ap_curr ap_date ap_disc_acct ap_disc_cc
                      ap_disc_sub ap_dy_code ap_effdate
                      ap_exru_seq ap_ex_rate ap_ex_rate2
                      ap_ex_ratetype ap_open ap_ref ap_rmk ap_sub
                      ap_type ap_vend ap__qad01)
               where recid(ap_mstr) = aprecid
               no-lock:

               if nrm-seq-num = " "
               then do:
                  {gprunp.i "nrm" "p" "nr_dispense"
                     "(input  ap_dy_code,
                       input  ap_effdate,
                       output nrm-seq-num)"}
               end. /* IF nrm-seq-num = " " */

               for each glt_det
                  where glt_ref = ref
                  exclusive-lock:
                  glt_dy_num = nrm-seq-num.
               end. /* FOR EACH glt_det */
            end. /* FOR FIRST ap_mstr */

         end. /* IF ref <> "" */

      end. /* DO TRANSACTION */
   end. /* LOOPB: REPEAT */

   do transaction:
      find ba_mstr where ba_batch = batch and ba_module = "AP"
      exclusive-lock no-error.
      ba_total = batch_total.
      if batch_ctrl <> batch_total then do:
         ba_status = "UB".
         if batch_ctrl <> 0 then do:
            /* Batch control total does not equal total */
            {pxmsg.i &MSGNUM=1151 &ERRORLEVEL=2}
            pause.
         end.
      end.
      else do:
         {&APVCMT-P-TAG10}
         if batch_ctrl = 0 and not can-find(first cksd_det where
            cksd_batch = ba_batch)
            then
         {&APVCMT-P-TAG11}
         ba_status = "NU".   /*0 & NO RECS FOUND*/
         else
            ba_status = "".
      end.
   end. /* DO TRANSACTION */

end. /* MAINLOOP */

/* PROCEDURE TO GET DAYBOOK VALUE FOR A BATCH ONCE THE CHECK */
/* HAS BEEN VOIDED AND/OR TRANSACTION HAS BEEN POSTED.       */

PROCEDURE p_get_daybook:

   define input  parameter p_batch   like ba_batch   no-undo.
   define output parameter p_daybook like dy_dy_code no-undo.

   for first glt_det
      fields(glt_batch glt_doc_type glt_dy_code glt_dy_num glt_ref
             glt_tr_type)
      where glt_batch    = p_batch
        and glt_tr_type  = "AP"
        and glt_doc_type = "CV"
      no-lock:
      p_daybook = glt_dy_code.
   end. /* FOR FIRST glt_det */
   if not available glt_det
   then do:
      for first gltr_hist
         fields(gltr_batch gltr_doc_typ gltr_dy_code
                gltr_tr_type)
         where gltr_batch    = p_batch
           and gltr_tr_type  = "AP"
           and gltr_doc_typ  = "CV"
         no-lock:
         p_daybook = gltr_dy_code.
      end. /* FOR FIRST gltr_hist */
      if not available gltr_hist
      then
         p_daybook = "".
   end. /* IF NOT AVAILABLE glt_det */

END PROCEDURE. /* p_get_daybook */
