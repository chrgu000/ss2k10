/* apmcmte.p - AP MANUAL CHECK MAINTENANCE SUBROUTINE                        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.13.1.19 $                                    */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISI0N: 8.5      LAST MODIFIED: 05/14/96   by: bxw *J0MQ*               */
/* REVISION: 8.6      LAST MODIFIED: 06/11/96   BY: ejh *K001*               */
/*                    LAST MODIFIED: 07/27/96   BY: *J12H* M. Deleeuw        */
/*                                   12/20/96   BY: *J1C5* R. McCarthy       */
/*                                   12/20/96   BY: bjl *K01S*               */
/*                                   01/23/97   BY: *K052* E. Hughart        */
/*                                   02/13/97   BY: *K065* E. Kim            */
/*                                   02/17/97   BY: *K01R* E. Hughart        */
/*                                   03/18/97   BY: *J1KV* Robin McCarthy    */
/* REVISION: 8.6      LAST MODIFIED: 01/07/98   BY: *J298* Prashanth Narayan */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton      */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* Pre-86E commented code removed, view in archive revision 1.10             */
/* Old ECO marker removed, but no ECO header exists *F725*                   */
/* Old ECO marker removed, but no ECO header exists *FM91*                   */
/* Old ECO marker removed, but no ECO header exists *G004*                   */
/* Old ECO marker removed, but no ECO header exists *G475*                   */
/* Old ECO marker removed, but no ECO header exists *G814*                   */
/* Old ECO marker removed, but no ECO header exists *GJ16*                   */
/* Old ECO marker removed, but no ECO header exists *GL39*                   */
/* Old ECO marker removed, but no ECO header exists *H039*                   */
/* Old ECO marker removed, but no ECO header exists *H0CS*                   */
/* Old ECO marker removed, but no ECO header exists *H117*                   */
/* Old ECO marker removed, but no ECO header exists *H203*                   */
/* Old ECO marker removed, but no ECO header exists *J053*                   */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Paul Johnson      */
/* REVISION: 9.1      LAST MODIFIED: 10/28/99   BY: *L0KV* Ranjit Jain       */
/* REVISION: 9.1      LAST MODIFIED: 01/19/00   BY: *N077* Vijaya Pakala     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 06/20/00   BY: *L0ZL* Mark Christian    */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 09/13/00   BY: *N0W0* BalbeerS Rajput   */
/* Old ECO marker removed, but no ECO header exists *H0CH*                   */
/* Revision: 1.13.1.11   BY: Vinod Nair       DATE: 07/09/02  ECO: *N1LY*  */
/* Revision: 1.13.1.12   BY: Manjusha Inglay   DATE: 07/29/02  ECO: *N1P4*  */
/* Revision: 1.13.1.13   BY: Ed van de Gevel  DATE: 09/05/02 ECO: *P0HQ* */
/* Revision: 1.13.1.14   BY: Orawan S. DATE: 05/02/03 ECO: *P0R0* */
/* Revision: 1.13.1.16   BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/* Revision: 1.13.1.18   BY: Vivek Gogte        DATE: 08/27/03 ECO: *P0XS* */
/* $Revision: 1.13.1.19 $  BY: Shilpa Athalye     DATE: 11/04/03 ECO: *N2M6* */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110114.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*****************************************************************************/

{mfdeclre.i}
{cxcustom.i "APMCMTE.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apmcmte_p_1 "Draft"
/* MaxLen: Comment: */

&SCOPED-DEFINE apmcmte_p_2 "Due Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE apmcmte_p_3 "Check Ctrl"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{gldydef.i}
{gldynrm.i}
{pxpgmmgr.i}

/* DEFINE VARIABLES FOR GPGLEF.P (GL CALENDAR VALIDATION) */
{gpglefdf.i}

{xxgpdescm1.i }     /* SS - 110114.1 */


{&APMCMTE-P-TAG1}
define shared variable aptotal      like ap_amt label {&apmcmte_p_3}
   format ">>>>>,>>>,>>9.99".
{&APMCMTE-P-TAG2}
define shared variable del-yn       like mfc_logical initial no.
define shared variable newapmstr    like mfc_logical.
define shared variable draft_yn     like mfc_logical initial no
   label {&apmcmte_p_1}.
define shared variable bkrecid      as recid.
define shared variable ckrecid      as recid.
define shared variable ap_due_date  like ap_date label {&apmcmte_p_2}.
define shared variable use_draft    like mfc_logical.
define shared variable old_curr     like ap_curr.
define shared variable ap_amt_fmt   as character no-undo.
define shared variable ap_amt_old   as character no-undo.
define shared variable rndmthd      like rnd_rnd_mthd.
define shared variable ap1recid     as recid.
define shared variable retval       as integer.

define shared variable glvalid like mfc_logical.
define shared variable undo_all2    as logical no-undo.
define shared variable ref           as character format "X(14)".

define variable mc-error-number like msg_nbr no-undo.
define variable fixed_rate_not_used like mfc_logical no-undo.

{&APMCMTE-P-TAG7}

/* DEFINED TEMP TABLE FOR GETTING THE RECORDS ADDED IN apmcmta.p */
/* WITH INDEX SAME AS PRIMARY UNIQUE INDEX OF ard_det.           */
{apdydef.i &type="shared"}

define shared frame b.

/* DEFINE SELECTION FORM */
{apmcfmb.i}

do with frame b:

   for first ap_mstr
      fields( ap_domain ap_acct ap_amt ap_batch ap_cc ap_curr ap_date
      ap_disc_acct
              ap_disc_cc ap_disc_sub ap_dy_code ap_effdate ap_exru_seq
              ap_ex_rate ap_ex_rate2 ap_ex_ratetype ap_rmk ap_sub ap_vend)
      where recid(ap_mstr) = ap1recid
      no-lock:
   end. /* FOR FIRST ap_mstr */

   for first bk_mstr
      fields( bk_domain bk_curr bk_entity)
      where recid(bk_mstr) = bkrecid
      no-lock:
   end. /* FOR FIRST bk_mstr */

   for first ck_mstr
      fields( ck_domain ck_bank ck_curr ck_nbr ck_status)
      where recid(ck_mstr) = ckrecid
      no-lock:
   end. /* FOR FIRST ck_mstr */

   /* INITIAL READ TO OBTAIN DEFAULTS */
   for first gl_ctrl
       where gl_ctrl.gl_domain = global_domain no-lock:
   end. /* FOR FIRST gl_ctrl */

   seta:
   do on error undo, retry:

      set aptotal
         ap_curr     when (new ap_mstr
                           and bk_curr = base_curr)
         ap_vend     when (newapmstr)
         ap_date
         ap_effdate  when (newapmstr)
         ap_due_date when (newapmstr
                           and draft_yn)
         ap_dy_code  when (newapmstr
                           and daybooks-in-use)
         editing:

         ststatus = stline[2].
         status input ststatus.
         readkey.
         if keyfunction(lastkey) = "END-ERROR"
         then do:
            undo_all2 = yes.
            undo seta, leave.
         end. /* IF keyfunction(lastkey) = "END-ERROR" */
         /* DELETE */
         if lastkey    = keycode("F5")
            or lastkey = keycode("CTRL-D")
         then do:
            {&APMCMTE-P-TAG3}
            del-yn = yes.
            /*CONFIRM DELETE*/
            {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
            if del-yn
            then do:
               /* VERIFY OPEN GL PERIOD FOR BANK ENTITY */
               {gpglef.i ""AP"" bk_entity ap_effdate}
               leave seta.
            end. /* IF del-yn */
            {&APMCMTE-P-TAG4}
         end. /* IF lastkey = keycode("F5") */

         if frame-field = "ap_date"
            and keyfunction(lastkey) = "END-ERROR"
         then do:
            next-prompt ap_date.
            undo seta, retry seta.
         end. /* IF FRAME-FIELD = "ap_date" */

         /* F4 ON DAYBOOK PROCESSING */
         if frame-field = "ap_dy_code"
            and keyfunction(lastkey) = "END-ERROR"
         then do:
            next-prompt ap_effdate.
            undo seta, retry seta.
         end. /* IF FRAME-FIELD = "ap_dy_code" */

         else apply lastkey.

      end. /* SET WITH FRAME EDITING */

      {&APMCMTE-P-TAG8}
      /* VERIFY VENDOR NOT ON PAYMENT HOLD */
      for first vd_mstr
         fields( vd_domain vd_addr vd_hold vd_sort
                {&APMCMTE-P-TAG6}
                )
          where vd_mstr.vd_domain = global_domain and  vd_addr = ap_vend
         no-lock:
      end. /* FOR FIRST vd_mstr */

      if available vd_mstr
         and vd_hold
      then do:
         {pxmsg.i &MSGNUM=162 &ERRORLEVEL=2}
         /* SUPPLIER ON PAYMENT HOLD */
      end. /* IF AVAILABLE vd_mstr */

      {&APMCMTE-P-TAG5}
      /* VERIFY GL CALENDAR FOR BANK ENTITY */
      {gpglef02.i
         &module = ""AP""
         &entity = bk_entity
         &date   = ap_effdate
         &prompt = "ap_effdate"
         &frame  = "b"
         &loop   = "seta"}

      /* VERIFY DAYBOOK */
      if daybooks-in-use
         and newapmstr
      then do:
         if not can-find(dy_mstr
                          where dy_mstr.dy_domain = global_domain and
                          dy_dy_code = ap_dy_code)
         then do:
            /* ERROR: INVALID DAYBOOK */
            {pxmsg.i &MSGNUM=1299 &ERRORLEVEL=3}
            next-prompt ap_dy_code.
            undo, retry.
         end. /* IF NOT CAN-FIND(dy_mstr... */
         else do:
            /* Added trans, doc, & entity parameter */
            {gprun.i ""gldyver.p""
               "(input ""AP"",
                 input ""CK"",
                 input ap_dy_code,
                 input bk_entity,
                 output daybook-error)"}
            if daybook-error
            then do:
               {pxmsg.i &MSGNUM=1674 &ERRORLEVEL=2}
               /* WARNING: DAYBOOK DOES NOT MATCH ANY DEFAULT */
               pause.
            end. /* IF daybook-error */

            {gprunp.i "nrm" "p" "nr_can_dispense"
               "(input ap_dy_code,
                 input ap_effdate)"}

            {gprunp.i "nrm" "p" "nr_check_error"
               "(output daybook-error,
                 output return_int)"}

            if daybook-error
            then do:
               {pxmsg.i &MSGNUM=return_int &ERRORLEVEL=3}
               next-prompt ap_dy_code.
               undo, retry.
            end. /* IF daybook-error */

            for first dy_mstr
               fields( dy_domain dy_desc dy_dy_code)
                where dy_mstr.dy_domain = global_domain and  dy_dy_code =
                ap_dy_code
               no-lock:
            end. /* FOR FIRST dy_mstr */

            if available dy_mstr
            then
               assign
                  daybook-desc = dy_desc
                  dft-daybook  = ap_dy_code.
         end. /* ELSE DO */
      end. /* IF DBKS IN USE */

      if daybooks-in-use
      then do:

         /* NRM SEQUENCE GENERATED ONLY WHEN GL REF IS NEW */
         if l_new_gl = yes
         then do:

            {gprunp.i "nrm" "p" "nr_dispense"
               "(input  ap_dy_code,
                 input  ap_effdate,
                 output nrm-seq-num)"}

            l_new_gl = no.

         end. /* IF l_new_gl = yes */

         /* CALL assign_nrm_seq_number FOR ASSIGNING SEQUENCE  */
         /* ONLY TO glt_det FOR DELETED RECORDS.               */

         {pxrun.i
             &PROGRAM='apgl.p'
             &PROC='assign_nrm_seq_number'
             &PARAM= "(input nrm-seq-num,
                       input ap_dy_code,
                       input ref,
                       input-output table tt_ckd_manual)"
          }

      end. /* IF daybooks-in-use */


      /* REQUIRE DUE DATE FOR DRAFTS */
      if ap_due_date = ?
      then do:
         if use_draft
            and newapmstr
            and draft_yn
         then do:
            {pxmsg.i &MSGNUM=3544 &ERRORLEVEL=3}
            next-prompt ap_due_date.
            undo, retry.
         end. /* IF use_draft */
      end. /* IF ap_due_date = ? */

      /* VERIFY CURRENCY */
      if bk_curr <> ap_curr
         and newapmstr
      then do:
         /* WARNING: BANK CURR <> CK CURR */
         {pxmsg.i &MSGNUM=93 &ERRORLEVEL=2}
         ck_curr = ap_curr.
      end. /* IF bk_curr <> ap_curr */

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
            undo seta, retry seta.
         end. /* if mc-error-number <> 0 */
         assign
            old_curr   = ap_curr
            ap_amt_fmt = ap_amt_old.
         {gprun.i ""gpcurfmt.p""
            "(input-output ap_amt_fmt,
              input rndmthd)"}
      end. /* IF AP_CURR <> OLD_CURR */

      {&APMCMTE-P-TAG9}
      if aptotal <> 0
      then do:
         {gprun.i ""gpcurval.p""
            "(input aptotal,
              input rndmthd,
              output retval)"}
         if retval <> 0
         then do:
            next-prompt aptotal with frame b.
            undo seta, retry seta.
         end. /* IF retval <> 0 */
      end. /* IF aptotal <> 0 */

      if base_curr <> ap_curr
         and newapmstr
      then do:
         /* VALIDATE EXCHANGE RATE */

         /* GET EXCHANGE RATE, CREATE USAGE */
         {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
            "(input ap_curr,
              input base_curr,
              input ap_ex_ratetype,
              input ap_date,
              output ap_ex_rate,
              output ap_ex_rate2,
              output ap_exru_seq,
              output mc-error-number)"}
         if mc-error-number <> 0
         then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
            undo, retry.
         end. /* IF mc-error-number <> 0 */
      end. /* IF base_curr <> ap_curr */

      ststatus = stline[3].
      status input ststatus.

      setaa:
      do on error undo, retry:
/* SS - 110114.1 - B 
         {&APMCMTE-P-TAG10}
         set ap_disc_acct when (new ck_mstr)
             ap_disc_sub  when (new ck_mstr)
             ap_disc_cc   when (new ck_mstr) 
             ap_rmk.
   SS - 110114.1 - E */
/* SS - 110114.1 - B */
        {gprun.i ""xxgpdescm.p""
          "(input        frame-row(b) + 2,
            input-output ap_rmk)"}
        {xxgpdescm2.i &table=ap_mstr &desc=ap_rmk}
        disp ap_rmk with frame b.

         set ap_disc_acct when (new ck_mstr)
             ap_disc_sub  when (new ck_mstr)
             ap_disc_cc   when (new ck_mstr)             
             .
/* SS - 110114.1 - E */

         {&APMCMTE-P-TAG11}
         if new ck_mstr
         then do:

            /* INITIALIZE SETTINGS */
            {gprunp.i "gpglvpl" "p" "initialize"}
            /* SET PROJECT VERIFICATION TO NO */
            {gprunp.i "gpglvpl" "p" "set_proj_ver" "(input false)"}
            /* ACCT/SUB/CC/PROJ VALIDATION */
            {gprunp.i "gpglvpl" "p" "validate_fullcode"
               "(input ap_disc_acct,
                 input ap_disc_sub,
                 input ap_disc_cc,
                 input """",
                 output glvalid)"}

            if glvalid = no
            then do:
               next-prompt ap_disc_acct.
               undo setaa, retry.
            end. /* IF glvalid = NO */
         end. /* IF NEW ck_mstr */
      end. /* SETAA */

      /* SET EXCHANGE RATE */
      if newapmstr
         and ck_curr <> base_curr
      then do:

         {gprunp.i "mcui" "p" "mc-ex-rate-input"
            "(input ap_curr,
              input base_curr,
              input ap_date,
              input ap_exru_seq,
              input false,
              input frame-row(b) + 5,
              input-output ap_ex_rate,
              input-output ap_ex_rate2,
              input-output fixed_rate_not_used)"}

      end. /* IF NEWAPMSTR AND CK_CURR <> BASE_CURR */
   end. /* SETA */

end. /* DO WITH FRAME B */
