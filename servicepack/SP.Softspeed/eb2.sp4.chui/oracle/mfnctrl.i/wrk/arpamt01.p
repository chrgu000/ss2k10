/* arpamt01.p - AR APPLY UNAPPLIED PAYMENT MAINTENANCE                   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* $Revision: 1.43 $                                               */
/*V8:ConvertMode=Maintenance                                             */
/* REVISION: 5.0   LAST MODIFIED: 04/11/89   by: MLB *B099*              */
/* REVISION: 6.0   LAST MODIFIED: 08/28/90   by: mlb *D055*              */
/*                                09/20/90   by: afs *D059*              */
/*                                10/11/90   by: afs *D088*              */
/*                                12/04/90   by: afs *D241*   (rev only) */
/*                                12/13/90   by: afs *D258*              */
/*                                02/28/91   by: afs *D387*              */
/*                                03/12/91   by: mlb *D360*              */
/*                                04/03/91   by: bjb *D507*              */
/*                                05/06/91   by: mlv *D595*              */
/*                                06/17/91   by: afs *D709*   (rev only) */
/*                                08/08/91   by: afs *D817*   (rev only) */
/*                                09/03/91   by: mlv *D848*   (Rev only) */
/* REVISION: 7.0   LAST MODIFIED: 09/17/91   by: mlv *F015*              */
/*                                11/07/91   by: mlv *F031*              */
/*                                03/30/92   by: jms *F332*              */
/* REVISION: 7.3   LAST MODIFIED: 01/12/93   by: mpp *G856*              */
/*                                03/22/93   by: jjs *G856*   (Rev only) */
/*                                04/23/93   by: jms *GA27*              */
/* REVISION: 7.4   LAST MODIFIED: 07/22/93   by: pcd *H039*              */
/*                                08/11/93   by: wep *H076*              */
/*                                02/07/94   by: srk *GI33*              */
/*                                07/25/94   by: pmf *FP52*              */
/*                                11/30/94   by: jzw *FU38*              */
/*                                01/28/95   by: ljm *G0D7*              */
/*                                02/21/95   by: wjk *FOJQ*              */
/*                                02/24/95   by: str *F0J4*              */
/*                                03/29/95   by: srk *F0PL*              */
/*                                04/27/95   by: wjk *H0CS*              */
/*                                05/05/95   by: jzw *F0RD*              */
/* REVISION: 8.5   LAST MODIFIED: 01/02/96   by: ccc *J053*              */
/*                                05/28/96   by: jxz *J0NL*              */
/*                                06/08/96   by: wjk *G1XC*              */
/* REVISION: 8.6   LAST MODIFIED: 06/11/96   BY: ejh *K001*              */
/*                                07/15/96   by: *J0VY* M. Deleeuw       */
/* REVISION: 8.5   LAST MODIFIED: 07/29/96   by: taf *J101*              */
/* REVISION: 8.6   LAST MODIFIED: 02/17/97   by: *K01R* E. Hughart       */
/* REVISION: 8.6   LAST MODIFIED: 09/30/97   by: *J21K* Samir Bavkar     */
/* REVISION: 8.6E  LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E  LAST MODIFIED: 04/07/98   by: rup *L00K*              */
/* REVISION: 8.6E  LAST MODIFIED: 05/07/98   BY: *L00T* E. v.d.Gevel     */
/* REVISION: 8.6E  LAST MODIFIED: 05/08/98   by: *K1NN* B. Gates         */
/* REVISION: 8.6E  LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton     */
/* Old ECO marker removed, but no ECO header exists *F0JQ*               */
/* Old ECO marker removed, but no ECO header exists *ONLY*               */
/* REVISION: 8.6E  LAST MODIFIED: 06/23/98   BY: *L01G* Robin McCarthy    */
/* REVISION: 8.6E  LAST MODIFIED: 06/30/98   BY: *J2MQ* Samir Bavkar      */
/* REVISION: 8.6E  LAST MODIFIED: 07/07/98   BY: *L01K* Jaydeep Parikh    */
/* REVISION: 8.6E  LAST MODIFIED: 08/24/98   BY: *J2WQ* Prashanth Narayan */
/* REVISION: 9.0   LAST MODIFIED: 12/15/98   BY: *J34F* Vijaya Pakala     */
/* REVISION: 9.0   LAST MODIFIED: 01/13/99   BY: *J359* Hemali Desai      */
/* REVISION: 9.0   LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0   LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1   LAST MODIFIED: 10/01/99   BY: *N014* Paul Johnson      */
/* REVISION: 9.1   LAST MODIFIED: 02/21/00   BY: *L0RX* Irine D'mello     */
/* REVISION: 9.1   LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1   LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* Old ECO marker removed, but no ECO header exists *F0PN*                */
/* REVISION: 9.1   LAST MODIFIED: 09/21/00   BY: *N0VV* BalbeerS Rajput   */
/* Revision: 1.40       BY: Alok Thacker   DATE: 07/19/01 ECO: *M169*     */
/* Revision: 1.41       BY: Ashish M.      DATE: 12/03/01 ECO: *M1R4*     */
/* Revision: 1.42       BY: Rajesh Kini    DATE: 01/30/02 ECO: *N18K*     */
/* $Revision: 1.43 $    BY: Manjusha Inglay   DATE: 07/29/02 ECO: *N1P4*     */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
{cxcustom.i "ARPAMT01.P"}

{&ARPAMT01-P-TAG1}
{mfdtitle.i "2+ "}
{&ARPAMT01-P-TAG2}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE arpamt01_p_1 "Amt of Check"
/* MaxLen: Comment: */

&SCOPED-DEFINE arpamt01_p_2 "Amt to Apply"
/* MaxLen: Comment: */

&SCOPED-DEFINE arpamt01_p_3 "Control"
/* MaxLen: Comment: */

&SCOPED-DEFINE arpamt01_p_4 "Unapplied Ref"
/* MaxLen: Comment: */

&SCOPED-DEFINE arpamt01_p_5 "Unapplied Amt"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{gldydef.i new}
{gldynrm.i new}

define new shared variable pmt_rndmthd      like rnd_rnd_mthd.
define new shared variable aply2_rndmthd    like rnd_rnd_mthd.
define new shared variable ar_recno         as recid.
define new shared variable ba_recno         as recid.
define new shared variable arnbr            like ar_nbr.
define new shared variable batch            like ar_batch.
define new shared variable unappamt         like ar_amt.
define new shared variable jrnl             like glt_ref.
define new shared variable base_amt         like ar_amt.
define new shared variable curr_amt         like ar_amt.
define new shared variable gain_amt         like ar_amt.
define new shared variable gltline          like glt_line.
define new shared variable undo_all         like mfc_logical.
define new shared variable undo_loopb       like mfc_logical    no-undo.
define new shared variable base_det_amt     like glt_amt.
define new shared variable det_ex_rate      like glt_ex_rate.
define new shared variable det_ex_rate2     like glt_ex_rate2.
define new shared variable bill_to          like ar_bill        no-undo.
define new shared variable check_nbr        like ar_check       no-undo.

define new shared variable tot_amt_to_apply like ar_amt
   label {&arpamt01_p_2}.
define new shared variable tot_amt_open     like ar_amt
   label {&arpamt01_p_5}.
define new shared variable ref_nu           like ard_ref
   label {&arpamt01_p_4}.
define new shared variable check_amt        like ar_amt
   label {&arpamt01_p_1}.
define new shared variable bactrl           like ba_ctrl.

define variable retval           as   integer.
define variable oldcurr          like ar_curr.
define variable ar_amt_fmt       as   character.
define variable ar_amt_old       as   character.
define variable base_amt_fmt     as   character.
define variable del-yn           like mfc_logical initial no.
define variable old_effdate      like ar_effdate.
define variable artype           like ar_type.
define variable original_amt     like ar_amt.
define variable first_in_batch   like mfc_logical.
define variable inbatch          like ap_batch.

/*VARS. inv_to_base_rate, rate2 REPLACES ar__dec01 INTRODUCED IN ETK*/
define variable armstr_inv_to_base_rate  like ar_ex_rate  no-undo.
define variable armstr_inv_to_base_rate2 like ar_ex_rate2 no-undo.
{&ARPAMT01-P-TAG3}
define variable amount                   like ard_amt     no-undo.
{&ARPAMT01-P-TAG4}
define variable is_transparent           like mfc_logical no-undo.

define new shared frame b.

define buffer armstr  for ar_mstr.
define buffer armstr1 for ar_mstr.
define buffer armstr3 for ar_mstr.  /* FOR OTHER LOOKUPS  */
define buffer payment for ar_mstr.  /* FOR PAYMENT UPDATE */
define buffer arddet2 for ard_det.  /* FOR OTHER LOOKUPS  */

/* DEFINE VARIABLES FOR GPGLEF.P (GL CALENDAR VALIDATION) */
{gpglefdf.i}
{etvar.i &new="new"}

/* NOTE:  FOR VERSION 7.1 THE FIELD ar_xslspsn1 CONTAINS THE
   UNAPPLIED REFERENCE FOR A PAYMENT APPLICATION.  THIS FIELD
   WILL BE RENAMED ON 7.2 */

/* DISPLAY FORM */
/* ADD FORMAT TO ACCOUNT FOR UP TO 3 DECIMAL DIGITS, THIS IS THE */
/* LARGEST POSSIBLE VALUE FOR CURRENCY DEPENDENT FORMATTING      */
/* CORRECTION ALLOW FOR LARGEST DIGITS TOO NOT JUST DECIMALS     */
form
   batch          colon 8 deblank
   bactrl         label {&arpamt01_p_3}
                  format "->>>>>>>,>>>,>>9.999"
   ba_total
                  format "->>>>>>>,>>>,>>9.999"
with side-labels frame a width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DEFINE SHARED FRAME B FOR APPLICATION HEADER INFORMATION */
{arpa01fm.i}

/* ASSIGN FORMATS TO _OLD VARIABLES */
assign
   base_amt_fmt = ard_amt:format
   ar_amt_old   = ard_amt:format.

find first gl_ctrl no-lock.

run update-jrnl (input-output jrnl).

mainloop:
repeat with frame a:
   do transaction:
      view frame a.
      status input.

      assign
         bactrl = 0
         batch  = "".

      set
         batch
      with frame a.

      if batch <> ""
      then do:
         find first ar_mstr
            where ar_batch = batch
            no-lock no-error.
         if available ar_mstr and ar_type <> "A"
         then do:
            /* MSG: BATCH ALREADY ASSIGNED */
            run call-msg (1182, 3).
            pause.
            next-prompt
               batch
            with frame a.
            undo, retry.
         end.

         find ba_mstr
            where ba_batch   = batch
            and   ba_module  = "AR"
            exclusive-lock no-error.
         if available ba_mstr
         then do:
            assign
               ba_recno = recid(bk_mstr)
               bactrl   = ba_ctrl
               /*INSURE BATCH TOTAL = SUM OF MEMOS*/
               ba_total = 0.
            for each ar_mstr
               where ar_batch = batch
               no-lock:
               ba_total = ba_total + ar_amt.
            end.
            display
               ba_total
            with frame a.
         end.
         else
            display
               0 @ ba_total
            with frame a.
      end.
      else
         display
            0 @ bactrl
            0 @ ba_total
         with frame a.

      update
         bactrl
      with frame a.

      if available ba_mstr
      then
         ba_ctrl = bactrl.
      first_in_batch  = yes.
   end. /* transaction */

   loopb:
   repeat with frame b:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).
      do transaction:
         if available ba_mstr
         then
            display
               ba_total
            with frame a.

         clear frame b.

         /*IN THE MAIN FRAME OF THIS COMMAND (FRAME B, DEFINED IN THE
           INCLUDED FILE ABOVE AND SHARED WITH THE SUBROUTINE), THE
           "Original Amount" FIELD IS THE INITIAL AMOUNT OF THE
           ASSOCIATED UNAPPLIED PAYMENT, "Open Amount" IS THE AMOUNT
           REMAINING ON THIS PAYMENT AND "Amount to Apply" IS A
           USER-ENTERABLE CONTROL FIELD FOR THE APPLICATION,
           WHICH DEFAULTS TO THE OPEN AMOUNT PLUS ANY AMOUNT
           PREVIOUSLY APPLIED IN THE REFERENCED TRANSACTION. */

         prompt-for ar_nbr
         editing:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp01.i ar_mstr ar_nbr ar_nbr batch ar_batch ar_batch}
            if recno <> ?
            then do:

               /* DETERMINE ROUND METHOD FROM PMT CURRENCY OR BASE*/
               if (oldcurr <> ar_curr) or (oldcurr = "")
               then do:
                  {gprun.i ""arpamt1c.p"" "(input  ar_curr,
                                            output pmt_rndmthd)"}

                  /* SET AR_AMT_FMT */
                  ar_amt_fmt = ar_amt_old.
                  {gprun.i ""gpcurfmt.p"" "(input-output ar_amt_fmt,
                                            input        pmt_rndmthd)"}
                  assign
                     ard_amt:format          = ar_amt_fmt
                     tot_amt_open:format     = ar_amt_fmt
                     check_amt:format        = ar_amt_fmt
                     tot_amt_to_apply:format = ar_amt_fmt
                     unappamt:format         = ar_amt_fmt
                     oldcurr                 = ar_curr.
               end.

               display
                  ar_nbr
                  ar_bill
                  ar_check
                  ar_xslspsn1
                  ar_batch
                  ar_date
                  ar_type
                  ar_effdate
                  ar_curr
                  ar_dy_code
                  ar_acct
                  ar_sub
                  ar_cc
                  ar_entity
                  ar_po.

               find cm_mstr
                  where cm_addr = ar_bill
                  no-lock no-error.
               if available cm_mstr
               then
                  display
                     cm_sort.
               else
                  display
                     " " @ cm_sort.

               do for armstr:
                  {&ARPAMT01-P-TAG5}
                  find first armstr
                     where armstr.ar_check = ar_mstr.ar_check
                     and   armstr.ar_type  = "P"
                     and   armstr.ar_bill  = ar_mstr.ar_bill
                     no-lock no-error.
                  {&ARPAMT01-P-TAG6}
                  if available armstr
                  then do:
                     find first ard_det
                        where ard_nbr  = armstr.ar_nbr
                        and   ard_tax  = ar_mstr.ar_xslspsn1
                        and   ard_type = "U"
                        no-lock no-error.
                     if available ard_det
                     then do:
                        {&ARPAMT01-P-TAG7}
                        tot_amt_open = ard_amt + ard_disc.

                        run find_tot_amt_open (input ar_mstr.ar_check).

                        assign
                           tot_amt_to_apply = tot_amt_open
                           amount           = ard_amt + ard_disc.

                        display
                           amount @ ard_amt.
                        {&ARPAMT01-P-TAG8}
                     end.  /* IF AVAIL ARD_DET */
                     display
                        - armstr.ar_amt @ check_amt
                        tot_amt_open
                        ar_mstr.ar_amt @ tot_amt_to_apply.
                  end.  /* IF AVAIL ARMSTR */
               end.  /* DO FOR ARMSTR */
            end.  /* IF RECNO */
         end.  /* PROMPT BLOCK */

         if input ar_nbr = ""
         then do:
            {mfnctrl.i arc_ctrl arc_memo ar_mstr ar_nbr arnbr}
            display
               arnbr @ ar_nbr.
         end.
         else do:
            arnbr = input ar_nbr.
            find first ar_mstr
               where ar_nbr   = arnbr
               and   ar_batch = batch
               no-lock no-error.

            if available ar_mstr
            then do:
               /* DETERMINE ROUND METHOD FROM PMT CURRENCY */
               if (oldcurr <> ar_curr) or (oldcurr = "")
               then do:
                  {gprun.i ""arpamt1c.p"" "(input  ar_curr,
                                            output pmt_rndmthd)"}

                  /* SET AR_AMT_FMT */
                  ar_amt_fmt = ar_amt_old.
                  {gprun.i ""gpcurfmt.p"" "(input-output ar_amt_fmt,
                                            input        pmt_rndmthd)"}
                  assign
                     ard_amt:format          = ar_amt_fmt
                     tot_amt_open:format     = ar_amt_fmt
                     check_amt:format        = ar_amt_fmt
                     tot_amt_to_apply:format = ar_amt_fmt
                     unappamt:format         = ar_amt_fmt
                     oldcurr                 = ar_curr.
               end.

               display
                  ar_nbr
                  ar_bill
                  ar_check
                  ar_batch
                  ar_date
                  ar_type
                  ar_effdate
                  ar_curr
                  ar_dy_code
                  ar_acct
                  ar_sub
                  ar_cc
                  ar_entity
                  ar_po.

               find cm_mstr
                  where cm_addr = ar_bill
                  no-lock no-error.
               if available cm_mstr
               then
                  display
                     cm_sort.
               else
                  display
                     " " @ cm_sort.

               do for armstr:
                  /* FIND ORIGINAL PAYMENT RECORD */
                  {&ARPAMT01-P-TAG9}
                  find first armstr
                     where armstr.ar_check = ar_mstr.ar_check
                     and   armstr.ar_bill  = ar_mstr.ar_bill
                     and   armstr.ar_type  = "P"
                     no-lock no-error.
                  {&ARPAMT01-P-TAG10}
                  if available armstr
                  then do:
                     /* FIND ORIGINAL 'UNAPPLIED AMT' RECORD */
                     find first ard_det
                        where ard_nbr  = armstr.ar_nbr
                        and ard_tax    = ar_mstr.ar_xslspsn1
                        and ard_type   = "U"
                        no-lock no-error.

                     if available ard_det
                     then do:
                        {&ARPAMT01-P-TAG11}
                        tot_amt_open = ard_amt + ard_disc.
                        /*  GET ALL 'PAYMENT APPLICATION' RECORDS */
                        run find_tot_amt_open (input ar_mstr.ar_check).
                        amount = ard_amt + ard_disc.
                        display
                         amount @ ard_amt.
                     end.
                     display
                        - armstr.ar_amt @ check_amt
                        tot_amt_open
                        ar_mstr.ar_amt @ tot_amt_to_apply.
                     {&ARPAMT01-P-TAG12}
                  end.
                  else do:
                     run call-msg (750,3).
                     /*Check not available-modific */
                     undo, retry.
                  end.
               end.
            end.
         end.

         find ar_mstr
            where ar_nbr = string(arnbr)
            no-error.

         /* ADD */
         if not available ar_mstr
         then
            run call-msg (1,1). /* ADDING NEW RECORD */

         /* BATCH NUMBER IS ASSIGNED ONLY FOR APPLIED REFERENCE */

         else
         if batch = "" and ar_type = "A"
         then
            batch = ar_batch.

         if batch <> ""
         then do:
            find first ba_mstr
               where ba_batch  = batch
               and   ba_module = "AR"
               no-lock no-error.
            if available ba_mstr
            then
               bactrl = ba_ctrl.
         end.

         inbatch = batch.
         {gprun.i ""gpgetbat.p"" "(input  inbatch,   /*IN-BATCH       */
                                   input  ""AR"",    /*MODULE         */
                                   input  ""A"",     /*DOC TYPE       */
                                   input  bactrl,    /*CONTROL AMT    */
                                   output ba_recno,  /*NEW BATCH RECID*/
                                   output batch)"}   /*NEW BATCH #    */
         display
            batch
            bactrl
            with frame a.

      end. /*transaction*/

      do transaction:
         find ar_mstr
            where ar_nbr = string(arnbr)
            no-error.
         /*ADD*/
         if not available ar_mstr
         then do:
            prompt-for
               ar_bill
            editing:
               {mfnp.i cm_mstr ar_bill cm_addr ar_bill cm_addr cm_addr}
               if recno <> ?
               then
                  display
                     cm_addr @ ar_bill
                     cm_sort.
            end.

            bill_to = input ar_bill.
            find cm_mstr
               where cm_addr = input ar_bill
               no-lock no-error.
            if available cm_mstr
               then
                  display
                     cm_sort.

            create ar_mstr.
            assign
               ar_nbr     = string(arnbr)
               ar_bill
               ar_batch   = batch
               ar_date    = today
               ar_effdate = today
               ar_cust    = input ar_bill
               ar_type    = "A".
            {&ARPAMT01-P-TAG13}
            display
               ar_batch.
         end.
         else do: /*MODIFY*/
            old_effdate = ar_effdate.

            /* DETERMINE ROUND METHOD FROM PMT CURRENCY */
            if (oldcurr <> ar_curr) or (oldcurr = "")
            then do:
               {gprun.i ""arpamt1c.p"" "(input  ar_curr,
                                         output pmt_rndmthd)"}

               /* SET AR_AMT_FMT */
               ar_amt_fmt = ar_amt_old.
               {gprun.i ""gpcurfmt.p"" "(input-output ar_amt_fmt,
                                         input        pmt_rndmthd)"}
               assign
                  ard_amt:format          = ar_amt_fmt
                  tot_amt_open:format     = ar_amt_fmt
                  check_amt:format        = ar_amt_fmt
                  tot_amt_to_apply:format = ar_amt_fmt
                  unappamt:format         = ar_amt_fmt
                  oldcurr                 = ar_curr.
            end.

            do for armstr:
               /* FIND THE ORIGINAL PAYMENT RECORD */
               {&ARPAMT01-P-TAG14}
               find first armstr
                  where armstr.ar_check = ar_mstr.ar_check
                  and   armstr.ar_bill  = ar_mstr.ar_bill
                  and   armstr.ar_type  = "P"
                  no-lock no-error.
               if available armstr
               then do:
                  original_amt = - armstr.ar_amt.
                  /* FIND ORIGINAL 'UNAPPLIED AMT' RECORD */
                  find first ard_det
                     where ard_nbr  = armstr.ar_nbr
                     and ard_tax    = ar_mstr.ar_xslspsn1
                     and ard_type   = "U" no-lock no-error.

                  if available ard_det
                  then do:
                     tot_amt_open = ard_amt + ard_disc.
                     /* GET ALL 'PMT APPLICATION' RECORDS */
                     run find_tot_amt_open (input ar_mstr.ar_check).
                     amount = ard_amt + ard_disc.
                     display
                        amount @ ard_amt.
                     {&ARPAMT01-P-TAG15}
                  end.
                  tot_amt_to_apply = ar_mstr.ar_amt.
               end.
               else
                  assign
                     original_amt     = 0
                     tot_amt_open     = 0
                     tot_amt_to_apply = ar_mstr.ar_amt.
            end.

            /* MOVED EDIT CHECKS FROM AFTER DISPLAY */
            /* CHECK THAT RECORD IS AN APPLY UNAPPLIED TYPE */
            if ar_type <> "A"
            then do:
               run call-msg (751,3).
               undo,retry.
            end.

            /* CHECK THAT PAYMENT IS IN BATCH */
            if batch <> "" and batch <> ar_batch
            then do:
               run call-msg (1152,3).
               undo, retry.
            end.

            display
               ar_bill
               ar_check
               ar_xslspsn1
               ar_batch
               ar_date
               ar_type
               ar_effdate
               ar_curr
               ar_acct
               ar_sub
               ar_cc
               ar_entity
               ar_po
               ar_dy_code
               original_amt @ check_amt
               tot_amt_to_apply
               tot_amt_open.

            find cm_mstr
               where cm_addr = ar_bill
               no-lock no-error.
            if available cm_mstr
            then
               display
                  cm_sort.
         end.

         /*PLACE EXCLUSIVE LOCK ON BA_MSTR FOR UPDATE*/
         /*OF CONTROL TOTALS.                        */
         find ba_mstr
            where ba_batch = batch
            and ba_module  = "AR"
            exclusive-lock no-error.

         display
            ba_batch @ batch
            ba_ctrl  @ bactrl
            ba_total
         with frame a.

         /* BACKOUT BATCH TOTALS */
         ba_total = ba_total - ar_amt.

         display
            ar_batch.

         assign
            recno  = recid(ar_mstr)
            del-yn = no.

         display
            ar_type.

         ststatus = stline[2].
         status input ststatus.

         display
            ar_date
            ar_effdate.

         setdet:
         do on error undo, retry:
            /* ADD (part 2) */
            if new ar_mstr
            then do:
               {&ARPAMT01-P-TAG16}
               artype = "P".
               do for armstr:
                  prompt-for
                     ar_mstr.ar_check
                     ar_mstr.ar_xslspsn1
                     editing:
                     {&ARPAMT01-P-TAG17}
                     if frame-field = "ar_check"
                     then do:
                        {mfnp07.i armstr ar_mstr.ar_check
                                         armstr.ar_check
                                         armstr.ar_bill
                                         ar_mstr.ar_bill
                                         artype
                                         armstr.ar_type
                                         yes
                                         armstr.ar_open
                                         ar_bill_open}.

                        if recno <> ?
                        then do:
                           /* SET ROUND METHOD FROM PMT CURR OR BASE*/
                           if (oldcurr <> armstr.ar_curr)
                              or (oldcurr = "")
                           then do:

                              {gprun.i ""arpamt1c.p"" "(input  ar_curr,
                                                        output pmt_rndmthd)"}

                              /* SET AR_AMT_FMT */
                              ar_amt_fmt = ar_amt_old.
                              {gprun.i ""gpcurfmt.p""
                                       "(input-output ar_amt_fmt,
                                         input        pmt_rndmthd)"}
                              assign
                                 check_amt:format        = ar_amt_fmt
                                 ard_amt:format          = ar_amt_fmt
                                 tot_amt_open:format     = ar_amt_fmt
                                 tot_amt_to_apply:format = ar_amt_fmt
                                 unappamt:format         = ar_amt_fmt
                                 oldcurr                 = armstr.ar_curr.
                           end.

                           display
                              armstr.ar_check @ ar_mstr.ar_check
                              - armstr.ar_amt @ check_amt
                              armstr.ar_curr  @ ar_mstr.ar_curr.
                        end.
                     end.

                     else
                     if frame-field = "ar_xslspsn1"
                     then do:
                        check_nbr = input frame b ar_mstr.ar_check.
                        {mfnp05.i ard_det
                                  ard_nbr
                                  "ard_nbr = string(ar_mstr.ar_bill, ""x(8)"" )
                                             + input ar_mstr.ar_check
                                   and ard_type = ""U"" "
                                   ard_tax
                                  "input ar_mstr.ar_xslspsn1"}
                        if recno <> ?
                        then do:
                           display
                              ard_tax    @ ar_mstr.ar_xslspsn1
                              ard_acct   @ ar_mstr.ar_acct
                              ard_sub    @ ar_mstr.ar_sub
                              ard_cc     @ ar_mstr.ar_cc
                              ard_entity @ ar_mstr.ar_entity.

                           {&ARPAMT01-P-TAG18}
                              tot_amt_open = ard_amt + ard_disc.
                           run find_tot_amt_open (input input ar_mstr.ar_check).
                           amount = ard_amt + ard_disc.

                           display
                              amount @ ard_amt
                              tot_amt_open
                              tot_amt_open @ tot_amt_to_apply.
                           {&ARPAMT01-P-TAG19}
                        end.
                     end.
                     else do:
                        status input.
                        readkey.
                        apply lastkey.
                     end.
                  end.

                  /* GET CHECK MASTER RECORD AND UNAPPLIED DETAIL */
                  {&ARPAMT01-P-TAG20}
                  find first armstr
                     where armstr.ar_check = input ar_mstr.ar_check
                     and armstr.ar_bill  = ar_mstr.ar_bill
                     and armstr.ar_type  = "P"
                     and armstr.ar_open  = yes
                     no-lock no-error.
                  {&ARPAMT01-P-TAG21}
                  if available armstr
                  then do:
                     /*THE CURR AND DR ACCT MUST BE SAME AS PAYMENT*/
                     assign
                        ar_mstr.ar_curr     = armstr.ar_curr
                        ar_mstr.ar_ex_rate  = armstr.ar_ex_rate
                        ar_mstr.ar_ex_rate2 = armstr.ar_ex_rate2
                        ar_mstr.ar_var_acct = armstr.ar_var_acct
                        ar_mstr.ar_var_sub  = armstr.ar_var_sub
                        ar_mstr.ar_var_cc   = armstr.ar_var_cc.

                     run is_euro_transparent
                        (input ar_mstr.ar_curr,
                         input armstr.ar_curr,
                         input base_curr,
                         input ar_mstr.ar_effdate,
                         output is_transparent).

                     if not is_transparent
                     then
                        run update_inv_to_base_rate
                           (input ar_mstr.ar_nbr,
                            input armstr.ar_nbr).

                     {gprunp.i "mcpl" "p" "mc-copy-ex-rate-usage"
                                          "(input  armstr.ar_exru_seq,
                                            output ar_mstr.ar_exru_seq)"}.

                     find first ard_det
                        where ard_nbr  = armstr.ar_nbr
                        and   ard_tax  = input ar_mstr.ar_xslspsn1
                        and   ard_type = "U" no-lock no-error.

                     if available ard_det
                     then do:
                        assign
                           ar_mstr.ar_acct   = ard_acct
                           ar_mstr.ar_sub    = ard_sub
                           ar_mstr.ar_cc     = ard_cc
                           ar_mstr.ar_entity = ard_entity
                           {&ARPAMT01-P-TAG22}
                           amount            = ard_amt + ard_disc
                           tot_amt_open      = ard_amt + ard_disc.
                        /* GET ALL 'PMT APPLICATION' RECORDS */
                        run find_tot_amt_open (input input ar_mstr.ar_check).

                        {&ARPAMT01-P-TAG23}

                        tot_amt_to_apply = tot_amt_open.
                     end.
                     else do:
                        /*NOT VALID UNAPP PMT*/
                        run call-msg (752,3).
                        next-prompt ar_mstr.ar_check.
                        undo setdet.
                     end.

                     /* SET ROUND METHOD FROM PAYMENT CURRENCY */
                     if (oldcurr <> ar_curr)
                        or (oldcurr = "")
                     then do:
                        {gprun.i ""arpamt1c.p"" "(input  ar_curr,
                                                  output pmt_rndmthd)"}

                        /* SET AR_AMT_FMT */
                        ar_amt_fmt = ar_amt_old.
                        {gprun.i ""gpcurfmt.p"" "(input-output ar_amt_fmt,
                                                  input        pmt_rndmthd)"}
                        assign
                           ard_amt:format          = ar_amt_fmt
                           tot_amt_open:format     = ar_amt_fmt
                           check_amt:format        = ar_amt_fmt
                           tot_amt_to_apply:format = ar_amt_fmt
                           unappamt:format         = ar_amt_fmt
                           oldcurr                 = ar_curr.
                     end.

                     {&ARPAMT01-P-TAG24}
                     display
                        ar_mstr.ar_curr
                        ar_mstr.ar_acct
                        ar_mstr.ar_sub
                        ar_mstr.ar_cc
                        ar_mstr.ar_entity
                        ar_mstr.ar_po
                        ar_mstr.ar_dy_code
                        (- armstr.ar_amt) @ check_amt
                        amount @ ard_amt
                        tot_amt_to_apply
                        tot_amt_open.
                     {&ARPAMT01-P-TAG25}
                  end.
                  else do:

                     {&ARPAMT01-P-TAG26}
                     run call-msg (752,3).
                     next-prompt ar_mstr.ar_check.
                     undo setdet.
                  end.
                  assign
                     ar_mstr.ar_check    = input ar_mstr.ar_check
                     ar_mstr.ar_xslspsn1 = input ar_mstr.ar_xslspsn1.
               end. /*do for armstr*/

               set
                  ar_date
                  ar_effdate
                  ar_po
                  go-on ("F5" "CTRL-D" ).

               /* VAT REPORT RUNS OFF TAX DATE WHICH IS NOT SET ON */
               /* PAYMENT SO MAKE TAX DATE EQUAL TO EFFECTIVE DATE */
               ar_tax_date = ar_effdate.
            end.

            else  /*not new ar_mstr*/
            do:

               /* SET ROUND METHOD FROM PAYMENT CURRENCY */
               if (oldcurr <> ar_curr)
                  or (oldcurr = "")
               then do:
                  {gprun.i ""arpamt1c.p"" "(input  ar_curr,
                                            output pmt_rndmthd)"}

                  /* SET AR_AMT_FMT */
                  ar_amt_fmt = ar_amt_old.
                  {gprun.i ""gpcurfmt.p""
                           "(input-output ar_amt_fmt,
                             input        pmt_rndmthd)"}
                  assign
                     ard_amt:format          = ar_amt_fmt
                     tot_amt_open:format     = ar_amt_fmt
                     check_amt:format        = ar_amt_fmt
                     tot_amt_to_apply:format = ar_amt_fmt
                     unappamt:format         = ar_amt_fmt
                     oldcurr                 = ar_curr.
               end.

               set
                  ar_date
                  ar_effdate
                  ar_po
                  go-on ("F5" "CTRL-D" ).
            end.

            /* DELETE */
            if lastkey = keycode("F5") or
               lastkey = keycode("CTRL-D")
            then do:
               del-yn = yes.
               /*CONFIRM DELETE*/
               run call-msg01
                   (input  11,
                    input  1,
                    output del-yn).
               if not del-yn
               then undo.
            end.
            if not new ar_mstr
               and old_effdate <> ar_effdate
            then do:
               run call-msg (47,2).
               ar_effdate = old_effdate.
               display
                  ar_effdate
               with frame b.
               pause.
            end.

            /* VALIDATING GL CALENDAR */

            {gpglef.i ""AR"" ar_mstr.ar_entity ar_mstr.ar_effdate "loopb"}

            if not del-yn
            then do:

               /* SET AND VALIDATE TOT_AMT_TO_APPLY IN PMT CURRENCY */
               set_amt:
               do on error undo, retry:

                  if new ar_mstr
                     and daybooks-in-use
                  then do:
                     {gprun.i ""gldydft.p"" "(input  ""AR"",
                                              input  ar_type,
                                              input  ar_entity,
                                              output dft-daybook,
                                              output daybook-desc)"}

                     ar_dy_code = dft-daybook.
                     display
                        ar_dy_code
                     with frame b.

                  end. /* IF new ar_mstr AND ..... */

                  /* TRAP THE DELETE KEY FROM tot_amt_to_apply FIELD */
                  set
                     tot_amt_to_apply
                     ar_dy_code
                        when (new ar_mstr and daybooks-in-use)
                     go-on ("F5" "CTRL-D" )
                  with frame b.

                  /* DELETE */
                  if lastkey = keycode("F5")     or
                     lastkey = keycode("CTRL-D")
                  then do:
                     del-yn  = yes.
                     /*CONFIRM DELETE*/
                     run call-msg01
                        (input  11,
                         input  1,
                         output del-yn).
                     if not del-yn then undo set_amt.
                  end. /* IF LASTKEY = KEYCODE("F5") .. */

                  if not del-yn
                  then do:
                     if (tot_amt_to_apply <> 0)
                     then do:
                        {gprun.i ""gpcurval.p"" "(input  tot_amt_to_apply,
                                                  input  pmt_rndmthd,
                                                  output retval)"}
                        if (retval <> 0)
                        then do:
                           next-prompt tot_amt_to_apply.
                           undo set_amt, retry set_amt.
                        end.
                     end.

                     if new ar_mstr
                        and daybooks-in-use
                     then do:

                        if not can-find(dy_mstr
                                        where dy_dy_code = input ar_dy_code)
                        then do:
                           /* ERROR: INVALID DAYBOOK */
                           run call-msg (1299,3).
                           next-prompt ar_dy_code.
                           undo set_amt, retry set_amt.

                        end. /* IF NOT CAN-FIND (dy_mstr.. */
                        else do:
                           {gprun.i ""gldyver.p"" "(input  ""AR"",
                                                    input  ""A"",
                                                    input  input ar_dy_code,
                                                    input  ar_entity,
                                                    output daybook-error)"}

                           if daybook-error
                           then do:
                              /* WARNING: DAYBOOK DOES NOT MATCH */
                              /* ANY DEFAULT */
                              run call-msg (1674,2).
                              pause.
                           end. /* IF daybook-error ... */

                        end. /* ELSE DO */

                        {gprunp.i "nrm" "p" "nr_can_dispense"
                           "(input ar_dy_code,
                             input ar_effdate)"}

                        {gprunp.i "nrm" "p" "nr_check_error"
                           "(output daybook-error,
                             output return_int)"}

                        if daybook-error
                           then do:
                              run call-msg (return_int,3).
                           next-prompt ar_dy_code.
                           undo set_amt, retry set_amt.

                        end. /* IF daybook-error */

                        find dy_mstr
                           where dy_dy_code = input ar_dy_code
                           no-lock no-error.

                        if available dy_mstr
                        then
                           assign
                              daybook-desc = dy_desc
                              dft-daybook  = input ar_dy_code.

                     end. /* IF new ar_mstr and...... */

                  end.  /* IF NOT del-yn THEN DO */

               end.  /* SET_AMT */
            end.  /* IF NOT DEL-YN THEN DO */
         end. /* SETDET */

         if del-yn
         then do:

            /* VALIDATING DAYBOOK FOR THE FLAG ALLOW VOIDING */

            allow-gaps = no.

            if  daybooks-in-use
            and ar_dy_code > ""
            then do:

               {gprunp.i "nrm" "p" "nr_can_void"
                  "(input  ar_dy_code,
                    output allow-gaps)"}

               if not allow-gaps
               then do:

                 /* SEQUENCE DOES NOT ALLOW GAPS */

                 {pxmsg.i &MSGNUM     = 1349
                          &ERRORLEVEL = 4}
                 undo loopb, retry.

               end. /* IF NOT allow-gaps */

            end. /* IF daybooks-in-use ... */

            assign
               ar_recno   = recid(ar_mstr)
               undo_all   = yes
               undo_loopb = yes.

            {gprun.i ""arpamt1b.p""}
            if undo_loopb then undo loopb, next loopb.
            if undo_all then undo mainloop, leave.

            del-yn = no.
            clear frame b.
            next loopb.
         end. /* IF DEL-YN */

         /*ADD LINE ITEMS*/
         ar_recno = recid(ar_mstr).
         {gprun.i ""arpamt1a.p""}

         display
            tot_amt_open.

         display
            ar_mstr.ar_amt @ ba_total
         with frame a.

         repeat:
            if tot_amt_to_apply     <> ar_mstr.ar_amt
               and tot_amt_to_apply <> 0
            then do:
               run call-msg (233,2).
               /* CHECK TOTAL NOT EQUAL DISTRIBUTION */
               pause.
            end.
            leave.
         end.

         if not can-find(first ard_det
                         where ard_nbr = ar_mstr.ar_nbr
                         use-index ard_tax)
         then do:
            /* DELETING REFERENCE */
            run call-msg (1159,2).

            /* IF EXCHANGE RATE USAGE (exru_usage) RECORD WAS ALSO */
            /* CREATED THEN DELETE IT AS WELL                      */

            run delete_auxiliary_records.
            delete ar_mstr.
            pause.
         end.
         else
            if available ar_mstr and ar_mstr.ar_batch = batch
            then
               ba_total = ba_total + ar_mstr.ar_amt.

      end. /* transaction */

      clear frame b no-pause.
   end. /*loop b*/

   /* UPDATE BATCH STATUS */
   do transaction:
      run p-set-batch.

   end. /* DO TRANSACTION */

end. /* mainloop */
status input.

PROCEDURE p-set-batch:
   find ba_mstr
      where ba_batch  = batch
      and   ba_module = "AR"
      exclusive-lock no-error.
   if available ba_mstr
   then do:
      if can-find(first ar_mstr
                  where ar_batch = ba_batch)
      then do:
         if ba_ctrl   <> ba_total
         then do:
            ba_status = "UB".   /*UNBALANCED*/
            if ba_ctrl <> 0
            then do:
               /*BATCH CONTROL TOTAL DOES NOT EQUAL TOTAL*/
               run call-msg (1151,2).
               do on endkey undo, leave:
                  pause.
               end.
            end.
         end.
         else
         ba_status = "".   /*OPEN,BALANCED*/
      end.
      else do:
         assign
            ba_status = "NU"    /*NOT USED*/
            ba_ctrl   = 0.
      end.
      release ba_mstr.
   end. /* IF AVAILABLE BA_MSTR */
END PROCEDURE.

PROCEDURE delete_auxiliary_records:
   /*BEING CALLED UPON CTRL-D (DELETE) AND WHEN NO LINE DETAIL ENTERED */
   /* IF EXCHANGE RATE USAGE (exru_usage) RECORD WAS ALSO              */
   /* CREATED THEN DELETE IT AS WELL                                   */
   if ar_mstr.ar_exru_seq <> 0 then
   do:
      {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                           "(input ar_mstr.ar_exru_seq)"}
   end.
   if ar_mstr.ar_dd_exru_seq <> 0
   then do:
      {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                           "(input ar_mstr.ar_dd_exru_seq)"}
   end.

   for first qad_wkfl
         fields (qad_decfld[1] qad_decfld[2])
         where qad_key1 = "AR_MSTR"
         and   qad_key2 = ar_mstr.ar_nbr:
   end.
   if available qad_wkfl
   then
      delete
         qad_wkfl.
END PROCEDURE.

PROCEDURE update_inv_to_base_rate:
   /* COPY RATES FROM INV (OF QAD_WKFL) TO PMT RECORD (IN QAD_WKFL)*/
   define input parameter ar_mstr_ar_nbr like ar_mstr.ar_nbr. /* PMT */
   define input parameter armstr_ar_nbr  like armstr.ar_nbr.  /* INV */

   {argetwfl.i
      armstr_ar_nbr
      armstr_inv_to_base_rate
      armstr_inv_to_base_rate2}

   {arupdwfl.i  ar_mstr_ar_nbr
      armstr_inv_to_base_rate
      armstr_inv_to_base_rate2}

END PROCEDURE.

PROCEDURE call-msg:
   define input parameter message_number like msg_nbr.
   define input parameter message_type   like msg_nbr.

   {pxmsg.i &MSGNUM=message_number &ERRORLEVEL=message_type}

END PROCEDURE.

PROCEDURE call-msg01:
   define input  parameter message_number like msg_nbr     no-undo.
   define input  parameter message_type   like msg_nbr     no-undo.
   define output parameter message_yn     like mfc_logical no-undo.

   {pxmsg.i &MSGNUM=message_number &ERRORLEVEL=message_type
            &CONFIRM=message_yn    &CONFIRM-TYPE='LOGICAL'}

END PROCEDURE. /* End call-msg01 */

/** ADDED INTERNAL PROCEDURE TO AVOID ACTION SEGMENT ERROR **/
PROCEDURE update-jrnl:
   define input-output parameter jrnl like glt_ref no-undo.

   do transaction:
      /* GET NEXT JOURNAL REFERENCE NUMBER */
      {mfnctrl.i arc_ctrl arc_jrnl glt_det glt_ref jrnl}
   end.
END PROCEDURE.

/** ADDED INTERNAL PROCEDURE TO AVOID ACTION SEGMENT ERROR **/
PROCEDURE find_tot_amt_open:

   define input parameter p_check like ar_check no-undo.
   {&ARPAMT01-P-TAG27}

   for each armstr1
      where armstr1.ar_check  = p_check
      and armstr1.ar_bill     = ar_mstr.ar_bill
      and armstr1.ar_xslspsn1 = ard_det.ard_tax
      and armstr1.ar_type     = "A"
      and armstr1.ar_nbr      <> ar_mstr.ar_nbr
      no-lock:
      assign
         {&ARPAMT01-P-TAG28}
         tot_amt_open = tot_amt_open - armstr1.ar_amt.
      {&ARPAMT01-P-TAG29}
   end.
END PROCEDURE.

/* DEFINATION FOR PROCEDURE is_euro_transparent */
{gpacctet.i}
