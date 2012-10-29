/* GUI CONVERTED from chgltrma.p (converter v1.71) Sun Oct 21 21:39:26 2007 */
/* chgltrma.p -- GENERAL LEDGER JOURNAL ENTRY TRANSACTION MAINT - CAS    */
/* gltrmta.p - -- GENERAL LEDGER JOURNAL ENTRY TRANSACTION MAINTENANCE   */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* $Revision: 1.45.1.2 $                                                          */
/*V8:ConvertMode=Maintenance                                             */
/* REVISION: 6.0     LAST MODIFIED:  05/30/90  by: jms  *D029*           */
/*                                   10/11/90  by: jms  *D034*           */
/*                                   (program split)                     */
/*                                   02/22/91  by: jms  *D371*           */
/*                                   03/13/91  by: jms  *D434*           */
/*                                   03/18/91  by: jms  *D442*           */
/*                                   04/24/91  by: jms  *D582*           */
/*                                   05/09/91  by: jms  *D604*           */
/*                                   08/13/91  by: jms  *D826*           */
/* REVISION: 7.0     LAST MODIFIED:  10/03/91  by: jjs  *F058*           */
/*                                   10/10/91  by: dgh  *D892*           */
/*                                   01/03/92  by: mlv  *F081*           */
/*                                   02/12/92  by: jms  *F193*           */
/*                                   05/29/92  by: jms  *F540*           */
/*                                   05/29/92  by: mlv  *F513*           */
/*                                   07/08/92  by: jms  *F734*           */
/* REVISION: 7.3     LAST MODIFIED:  07/31/92  by: mpp  *G016*           */
/*                                   12/03/92  by: mpp  *G387*           */
/*                                   02/23/93  by: mpp  *G479*           */
/*                                   05/11/93  by: wep  *GA85*           */
/*                                   06/10/93  by: wep  *GC16*           */
/*                                   04/04/94  by: srk  *FN22*           */
/*                                   09/03/94  by: srk  *FQ80*           */
/* Oracle changes (share-locks)      09/11/94  by: rwl  *FR18*           */
/*                                   09/27/94  by: srk  *FR86*           */
/*                                   10/17/94  by: ljm  *GN36*           */
/*                                   12/12/94  by: str  *GO86*           */
/*                                   12/19/94  by: str  *FU14*           */
/*                                   12/28/94  by: srk  *G0B2*           */
/*                                   03/14/95  by: jzw  *G0H9*           */
/*                                   10/27/95  by: mys  *G1BF*           */
/*                                   11/06/95  by: mys  *G1CF*           */
/*                                   03/13/96  by: wjk  *G1QC*           */
/* REVISION: 8.6      LAST MODIFIED: 06/12/96  by: ejh  *K001*           */
/* REVISION: 8.5      LAST MODIFIED: 06/18/96  by: taf  *J0V5*           */
/*                                   06/24/96  *J0W5* by: M. Deleeuw     */
/*                                   06/20/96  by: wjk  *G1S9*           */
/* REVISION: 8.5      LAST MODIFIED: 07/24/96  by: taf  *J115*           */
/* REVISION: 8.6      LAST MODIFIED: 02/17/97  BY: *K01R* E. Hughart     */
/* REVISION: 8.6      LAST MODIFIED: 05/02/97  BY: *G2MP* R. McCarthy    */
/* REVISION: 8.6      LAST MODIFIED: 07/19/97  BY: *J1X4* Irine D'mello  */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98  BY: *L007* A. Rahane      */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98  BY: *L00Y* Jeff Wootton   */
/* REVISION: 8.6E     LAST MODIFIED: 06/01/98  BY: *L01J* Mansour Kazemi */
/* REVISION: 8.6E     LAST MODIFIED: 07/30/98  BY: *L05B* Brenda Milton  */
/* REVISION: 8.6E     LAST MODIFIED: 08/21/98  BY: *H1L8* Dana Tunstall  */
/* REVISION: 9.0      LAST MODIFIED: 12/21/98  BY: *J35Y* Prashanth Narayan*/
/* REVISION: 9.0      LAST MODIFIED: 02/02/99  BY: *J395* Abbas Hirkani    */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99  BY: *M0BD* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 06/29/99  BY: *N00D* Adam Harris      */
/* REVISION: 9.1      LAST MODIFIED: 08/30/99  BY: *N014* Jeff Wootton     */
/* REVISION: 9.1      LAST MODIFIED: 10/06/99  BY: *L0JR* Hemali Desai     */
/* REVISION: 9.1      LAST MODIFIED: 02/14/00  BY: *N05F* Atul Dhatrak     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00  BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 06/05/00  BY: *L0YX* Veena Lad        */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00  BY: *N0L1* Mark Brown       */
/* REVISION: 9.1      LAST MODIFIED: 08/18/00  BY: *M0RD* Veena Lad        */
/* REVISION: 9.1      LAST MODIFIED: 08/31/00  BY: *N0QJ* Mudit Mehta      */
/* REVISION: 9.1      LAST MODIFIED: 11/03/00  BY: *N0TH* Manish K.        */
/* REVISION: 9.1      LAST MODIFIED: 01/10/01  BY: *M0ZR* Veena Lad        */
/* REVISION: 9.1      LAST MODIFIED: 10/05/00  BY: *N0W6* Mudit Mehta      */
/* REVISION: 9.1CH    LAST MODIFIED: 04/19/01  BY: *XXCH911* Charles Yen   */
/* Old ECO marker removed, but no ECO header exists *F0PN*                 */
/* Revision: 1.37     BY: Katie Hilbert      DATE: 08/03/01  ECO: *P01C*   */
/* Revision: 1.38     BY: Mercy C.           DATE: 09/20/01  ECO: *N12K*   */
/* Revision: 1.40     BY: Anitha Gopal       DATE: 09/20/01  ECO: *N19M*   */
/* Revision: 1.40     BY: Ed van de Gevel    DATE: 04/16/02  ECO: *N1GP*   */
/* Revision: 1.41     BY: K Paneesh          DATE: 05/24/02  ECO: *N1JX*   */
/* Revision: 1.42     BY: Subramanian Iyer   DATE: 10/04/02  ECO: *N1TQ*   */
/* Revision: 1.43     BY: Manjusha Inglay    DATE: 01/21/03  ECO: *N24T*   */
/* Revision: 1.44     BY: Narathip W.        DATE: 04/30/03  ECO: *P0QX*   */
/* Revision: 1.45     BY: Deepak Rao         DATE: 05/26/03  ECO: *N2G3*   */
/* Revision: 1.45.1.1 BY: Rajaneesh S.       DATE: 06/23/03  ECO: *P0W0*   */
/* $Revision: 1.45.1.2 $     BY: K Paneesh          DATE: 08/08/03  ECO: *N2JT*   */
/***************************************************************************/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/


{mfdeclre.i}
{cxcustom.i "GLTRMTA.P"}

{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{gldydef.i}
{gldynrm.i}

define input parameter type_parm as character.

define new shared variable linenum       like glt_line.
define new shared variable new_trans       as logical.
define new shared variable chg_trans       as logical.
define new shared variable old_acct      like glt_acc.
define new shared variable old_entity    like glt_entity.
define new shared variable old_curr      like glt_curr.
define new shared variable currency        as character format "x(3)".
/*XXCH911*/ def var dr_cr as logical format "Dr/Cr" initial yes.

define shared variable ref               like glt_ref no-undo.
define shared variable tot_amt           like glt_amt label "Total".
define shared variable enter_dt          like glt_date.
define shared variable eff_dt            like glt_effdate initial today
                                                     label "Effective".
define shared variable dr_tot            like glt_amt.
define shared variable pl                like co_pl.
define shared variable tr_type           like glt_tr_type label "Type".
define shared variable entities_balanced like co_enty_bal.
define shared variable allow_mod         like co_allow_mod.
define shared variable entity            like en_entity.
define shared variable glname            like en_name.
define shared variable ctrl_amt          like glt_amt label "Control".
define shared variable ctrl_curr         like glt_curr.
define shared variable per_yr              as character format "x(7)"
                                                      label "Period".
define shared variable desc1             like glt_desc format "x(22)".
define shared variable use_cc            like co_use_cc.
define shared variable use_sub           like co_use_sub.
define shared variable cash_book         like mfc_logical.
define shared variable bank_bank         like ck_bank.
define shared variable bank_curr         like bk_curr.
define shared variable bank_batch        like ba_batch.
define shared variable bank_ex_rate      like cb_ex_rate.
define shared variable bank_ex_rate2     like cb_ex_rate2.
define shared variable disp_curr         like glt_curr format "x(4)".
define shared variable corr-flag         like glt_correction.
define shared variable ctrl_rndmthd      like rnd_rnd_mthd no-undo.
define input parameter l_doc_type        like glt_doc_type no-undo.

define shared frame a.
define shared frame ya.

define        variable glt-hand         as handle                  no-undo.
/*XXCH911*  define variable descx like glt_desc format "x(13)" no-undo. */
/*XXCH911*/ define var descx like glt_desc format "x(16)" no-undo.
define        variable amt            like glt_amt.
/*XXCH911* define variable xamt like glt_amt.*/
/*XXCH911*/ def var xamt like glt_amt format "->,>>>,>>>,>>9.99".
define        variable acct             as character format "x(22)".
define        variable curr           like glt_curr.
define        variable allocation       as logical.
define        variable memoflag         as logical.
define        variable del-yn           as logical initial no.
define        variable valid_acct     like mfc_logical.
define        variable account          as character format "x(22)"
                                                  label "Account".
define        variable entity_ok      like mfc_logical.
define        variable base_amt       like gltr_amt.
define        variable transdate1     like glt_date.
define        variable transbatch1    like glt_batch.
define        variable oldamt         like glt_amt.
define        variable oldexrate      like glt_ex_rate.
define        variable oldexrate2     like glt_ex_rate2.
define        variable valid_al       like mfc_logical.
define        variable acct_curr      like ac_curr.
define        variable acct_code      like ac_code.
define        variable xamt_old          as character        no-undo.
define        variable xamt_base_fmt     as character        no-undo.
define        variable xamt_gltc_fmt     as character        no-undo.
define        variable gltcurr_rndmthd like rnd_rnd_mthd     no-undo.
define        variable old_gltcurr     like glt_curr         no-undo.
define        variable retval            as integer          no-undo.
define        variable acc_rndmthd     like rnd_rnd_mthd     no-undo.
define        variable old_acccurr     like ac_curr          no-undo.
define        variable glt_curramt_fmt   as character        no-undo.
define        variable rndmthd         like rnd_rnd_mthd     no-undo.
define        variable fixed-rate      like so_fix_rate      no-undo.
define        variable mc-error-number like msg_nbr          no-undo.
/*CF*/ define new shared variable w-recid as recid.
define        variable first-is-cons   as logical.
define        variable will-be-first   as logical.

define buffer g1 for glt_det.

/* MODULE CLOSING ENGINE INCLUDE. */
{glcabmeg.i}

FORM /*GUI*/ 
   glt_line            space(.5)   
   account             view-as text size 22 by 1 space(.5)   
                 /*V8+*/
   glt_project         space(.5)   
   glt_entity          space(.5)   
   descx               space(.5)   
/*XXCH911*/ dr_cr               space(.5)   
   glt_curr            space(.5)   
   xamt
   with frame b down width 80 no-hide THREE-D /*GUI*/.


/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).
{&GLTRMTA-P-TAG1}

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
descx colon 13       space(5)   
    SKIP(.4)  /*GUI*/
with frame descx_frm side-labels overlay
   row 10 column 25 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-descx_frm-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame descx_frm = F-descx_frm-title.
 RECT-FRAME-LABEL:HIDDEN in frame descx_frm = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame descx_frm =
  FRAME descx_frm:HEIGHT-PIXELS - RECT-FRAME:Y in frame descx_frm - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME descx_frm = FRAME descx_frm:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame descx_frm:handle).

for first gl_ctrl
   fields( gl_domain gl_rnd_mthd gl_verify)
    where gl_ctrl.gl_domain = global_domain no-lock:
end.  /* FOR FIRST gl_ctrl */

/* CURRENCY DEPENDENT ROUNDING NEEDS TO RETAIN GL_CTRL.  SET    */
/* XAMT_BASE_FMT FOR BASE_CURR USAGE (WHEN XAMT IS GLT_AMT) ONE */
/* TIME.  CAPTURE ORIGINAL FORMAT OF XAMT INTO XAMT_OLD.        */
assign
   xamt_old      = xamt:format
   xamt_base_fmt = xamt_old.

{gprun.i ""gpcurfmt.p"" "(input-output xamt_base_fmt,
                          input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/* GET ENTITY SECURITY INFORMATION */
{glsec.i}
{gltrfm.i}

loopc:
repeat with frame b width 80:
/*GUI*/ if global-beam-me-up then undo, leave.


   FORM /*GUI*/ 
      
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
glt_acc   colon 13  space(5)
      glt_sub   colon 13
      glt_cc    colon 13
      glt_project colon 13
       SKIP(.4)  /*GUI*/
with frame d side-labels overlay
     /* getFrameTitle("ACCOUNT_INFORMATION",28) */
      row 10 column 5 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-d-title AS CHARACTER.
 F-d-title = getFrameTitle("ACCOUNT_INFORMATION",28) .
 RECT-FRAME-LABEL:SCREEN-VALUE in frame d = F-d-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame d =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame d + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame d =
  FRAME d:HEIGHT-PIXELS - RECT-FRAME:Y in frame d - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME d = FRAME d:WIDTH-CHARS - .5. /*GUI*/


   /* SET EXTERNAL LABELS */
   setFrameLabels(frame d:handle).

   /* UPDATE INDIVIDUAL TRANSACTIONS */
   linenum = 1.
   find last glt_det
       where glt_det.glt_domain = global_domain and  glt_ref  = ref
      and   glt_tr_type <> "**"
      no-lock use-index glt_ref
      no-error.

   if available glt_det
   and (allow_mod
        or substring(ref,1,2) = "JL"
        or type_parm          = "YA")
   then do:

      if glt_line = 0
      then do:
         for each g1
            exclusive-lock
             where g1.glt_domain = global_domain and  g1.glt_ref   = ref
            and g1.glt_line    = 0
            and g1.glt_tr_type <> "**":
/*GUI*/ if global-beam-me-up then undo, leave.


            {gprunp.i "gpaudpl" "p" "set_search_key"
               "(input g1.glt_ref + ""."" +
                       string(g1.glt_line))"}
            {gprunp.i "gpaudpl" "p" "save_before_image"
               "(input rowid(g1))"}

            assign
               g1.glt_line = linenum
               linenum     = linenum + 1.
            {gprunp.i "gpaudpl" "p" "audit_record_change"}
         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH g1 */
      end. /* IF glt_line = 0 */
      else
         linenum = glt_line + 1.

      assign
         desc1       = glt_desc
         transdate1  = glt_date
         transbatch1 = glt_batch.

   end. /* IF AVAILABLE glt_det ... */
   else
      assign
         transdate1  = today
         transbatch1 = "".

   display
      linenum @ glt_line
      entity  @ glt_entity.

   if available glt_det then do:
      for first en_mstr
       fields(en_domain en_entity en_consolidation)
       where en_domain = global_domain and en_entity = glt_entity
      no-lock:
      end.
      assign
       will-be-first = false
       first-is-cons = available en_mstr and en_consolidation.
   end.
   else assign
    will-be-first = true
    first-is-cons = false.
   prompt-for
      glt_line
   editing:

      if {gpiswrap.i}
      then
         recno = ?.

      /* FIND NEXT/PREVIOUS RECORD */
      /* Skip the "HOLDING" transaction of line 0 during scrolling */
      {mfnp01.i glt_det glt_line glt_line ref  " glt_det.glt_domain =
       global_domain and glt_det.glt_tr_type <> '**' and glt_ref " glt_ref}
      if  recno       <> ?
      and glt_tr_type <> "**"
      then do:
         /* EAS CHANGED ACCOUNT FROM 14 TO 22, BUT DISPLAY 14 HERE */
         {glacct.i &acc=glt_acc &sub=glt_sub &cc=glt_cc &acct=account}

         display
            glt_line
            account
            glt_project
            glt_entity
            glt_desc @ descx
/*XXCH911*/ dr_cr
            glt_curr.

         if glt_curr = base_curr
         then do:
            xamt:format = xamt_base_fmt.
            display glt_amt @ xamt.
         end. /* IF glt_curr = base_curr */
         else do:
            if glt_curr    <> old_gltcurr
            or (old_gltcurr = "")
            then do:

               /* GET ROUNDING METHOD FROM CURRENCY MASTER */
               {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                  "(input glt_curr,
                    output gltcurr_rndmthd,
                    output mc-error-number)"}
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                  pause 0.
                  next.
               end. /* IF mc-error-number <> 0 */

               assign
                  old_gltcurr   = glt_curr
                  /* SET XAMT FORMAT BASED ON GLTCURR_RNDMTHD */
                  xamt_gltc_fmt = xamt_old.

               {gprun.i ""gpcurfmt.p"" "(input-output xamt_gltc_fmt,
                                         input gltcurr_rndmthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end. /* IF glt_curr <> old_gltcurr */
            xamt:format = xamt_gltc_fmt.
            display
               glt_curr_amt @ xamt.
         end.  /* ELSE DO */
/*XXCH911*/        /* GENERATE DR_CR FLAG AND XAMT */
/*XXCH911*/        {chtramt1.i &glamt=glt_amt
                               &glcurramt=glt_curr_amt
                               &coa=glt_correction
                               &glcurr=glt_curr
                               &basecurr=base_curr
                               &usecurramt=yes
                               &drcr=dr_cr
                               &dispamt=xamt}
/*XXCH911*/        display glt_line account glt_project
/*XXCH911*/                glt_entity glt_desc @ descx
/*XXCH911*/                dr_cr xamt glt_curr.

      end.  /* IF recno <> ? AND glt_tr_type <> "**" */

   end.  /* PROMPT-FOR glt_line EDITING */
   {&GLTRMTA-P-TAG3}

   find glt_det
       where glt_det.glt_domain = global_domain and  glt_ref = ref
      and glt_rflag = false
      and glt_line  = input glt_line
      no-error.

   if not available glt_det
   then do:

      if (type_parm = "YA")
      or allow_mod
      or substring(ref,1,2) = "JL"
      then do:

         /* ADD TRANSACTION LINE */
         /* ADDING NEW RECORD */
         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
         create glt_det. glt_det.glt_domain = global_domain.
         assign
            glt_ref         = ref
            glt_rflag       = false
            glt_line        = linenum
            glt_entity      = entity
            glt_tr_type     = tr_type
            glt_date        = transdate1
            {&GLTRMTA-P-TAG4}
            glt_batch       = transbatch1
            glt_effdate     = eff_dt
            glt_userid      = global_userid
            glt_doc         = ref
            glt_curr        = ctrl_curr
            glt_ex_rate     = 1
            glt_ex_rate2    = 1
            glt_ex_ratetype = ""
            glt_exru_seq    = 0
            glt_correction  = corr-flag
            glt_doc_type    = l_doc_type
            glt_dy_code     = dft-daybook
            glt_dy_num      = nrm-seq-num
            glt_unb         = no.
         {&GLTRMTA-P-TAG2}

         if cash_book
         then
            glt_batch = bank_batch.

         if recid(glt_det) = -1
         then .

         assign
            descx      = desc1
            new_trans  = yes
            chg_trans  = no
            oldamt     = 0
            oldexrate  = 1
            oldexrate2 = 1
            xamt       = 0
/*XXCH911*/ dr_cr = yes
            gltcurr_rndmthd= ctrl_rndmthd.

         /* SET XAMT FORMAT ACCORDING TO BASE OR CTRL CURRENCY */
         if ctrl_curr = base_curr
         then
            assign
               xamt:format = xamt_base_fmt
               old_gltcurr = glt_curr.
         else do:
            /* IF CRTL_CURR = OLD_GLTCURR, WE'VE ALREADY GOT FORMAT */
            if ctrl_curr   <> old_gltcurr
            or (old_gltcurr = "")
            then do:
               xamt_gltc_fmt = "->>>>,>>>,>>9.99".
               {gprun.i ""gpcurfmt.p""
                  "(input-output xamt_gltc_fmt,
                    input ctrl_rndmthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               old_gltcurr = ctrl_curr.
            end.   /* CTRL_CURR <> OLD_GLTCURR */
            xamt:format = xamt_gltc_fmt.
         end. /* ELSE DO: */

      end. /* ALLOW_MOD OR 'JL' */
      else do:
         /* NO NEW LINE ITEMS MAY BE ADDED TO THIS TRANSACTION */
         {pxmsg.i &MSGNUM=3130 &ERRORLEVEL=3}
         undo loopc, retry.
      end. /* ELSE DO: */

   end. /* IF NOT AVAIL GLT_DET */

   else do:    /* GLT_DET IS AVAILABLE */
      {gprunp.i "gpaudpl" "p" "set_search_key"
         "(input glt_det.glt_ref + ""."" +
                 string(glt_det.glt_line))"}
      {gprunp.i "gpaudpl" "p" "save_before_image"
         "(input rowid(glt_det))"}

      assign
         new_trans  = no
         chg_trans  = no
         old_acct   = glt_acc
         old_entity = glt_entity
         old_curr   = glt_curr.

      if glt_curr       = base_curr
      then
         assign
            xamt        = glt_amt
            xamt:format = xamt_base_fmt.
      else do:

         xamt = glt_curr_amt.

         if glt_curr    <> old_gltcurr
         or (old_gltcurr = "")
         then do:

            /* GET ROUNDING METHOD FROM CURRENCY MASTER */
            {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
               "(input glt_curr,
                 output gltcurr_rndmthd,
                 output mc-error-number)"}
            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
               pause 0.
               next.
            end. /* IF mc-error-number <> 0  */

            assign
               old_gltcurr = glt_curr
               /* GET XAMT FORMAT BASED ON GLTCURR_RNDMTHD */
               xamt_gltc_fmt = xamt_old.

            {gprun.i ""gpcurfmt.p""
               "(input-output xamt_gltc_fmt,
                 input gltcurr_rndmthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end. /* OLD_GLTCURR <> GLT_CURR */

         xamt:format = xamt_gltc_fmt.

      end. /* ELSE DO: */

      assign
         oldamt     = xamt
         oldexrate  = glt_ex_rate
         oldexrate2 = glt_ex_rate2
         descx      = glt_desc.
/*XXCH911*/     /* GENERATE DR_CR FLAG AND XAMT */
/*XXCH911*/     {chtramt1.i &glamt=glt_amt
                            &glcurramt=glt_curr_amt
                            &coa=glt_correction
                            &glcurr=glt_curr
                            &basecurr=base_curr
                            &usecurramt=yes
                            &drcr=dr_cr
                            &dispamt=xamt}

   end. /* ELSE-DO */

   recno = recid(glt_det).
/*XXCH911*/  /* MAINTAIN VOUCHER EXTENSION */
/*XXCH911*/  {chxgltcr.i &entity=glt_det.glt_entity
                         &ref=glt_det.glt_ref
                         &rflag=glt_det.glt_rflag
                         &trtype=glt_det.glt_tr_type
                         &userid=glt_det.glt_userid
                         &refresh=yes}


   ststatus = stline[2].
   status input ststatus.
   del-yn = no.

   /* CREATE FULL ACCOUNT NUMBER STRING */
   /* EAS CHANGED ACCOUNT FROM 14 TO 22, BUT DISPLAY 14 HERE */
   {glacct.i &acc=glt_acc &sub=glt_sub &cc=glt_cc &acct=account}

   display
      account
      glt_project
      glt_entity
      descx
/*XXCH911*/    dr_cr
      glt_curr
      xamt
   with frame b.

   if ctrl_curr = base_curr
   then
      amt = glt_amt.
   else
      amt = glt_curr_amt.

   base_amt = glt_amt.

   /* VALIDATE ACC/SUB/CC/PROJ COMBO */

   /* INITIALIZE SETTINGS */
   {gprunp.i "gpglvpl" "p" "initialize"}

   /* MESSAGE DISPLAY FROM VALIDATION PROCEDURE */
   {gprunp.i "gpglvpl" "p" "set_disp_msgs" "(input false)"}

   /* ACCT/SUB/CC/PROJ VALIDATION OF COMBINATION ONLY */
   {gprunp.i "gpglvpl" "p" "validate_combo"
      "(input glt_acc,
        input glt_sub,
        input glt_cc,
        input glt_project,
        output valid_acct)"}

   if  not allow_mod
   and valid_acct
   and glt_tr_type <> "JL"
   and type_parm   <> "YA"
   then do:
      /* MODIFICATION TO TRANSACTION NOT ALLOWED */
      {pxmsg.i &MSGNUM=3134 &ERRORLEVEL=3}
      undo loopc, retry.
   end. /* IF  NOT allow_mod */

   pause 0.
   display
      glt_acc
      glt_sub
      glt_cc
      glt_project
   with frame d.

   loopd:
   do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


      set
         glt_acct
         glt_sub when (use_sub)
         glt_cc when (use_cc)
         glt_project
         go-on("F5" "CTRL-D") with frame d.

      /* DELETE */
      if lastkey = keycode("F5")
      or lastkey = keycode("CTRL-D")
      then do:
         if (type_parm   <> "YA")
         and not allow_mod
         and glt_tr_type <> "JL"
         then do:
            /* DELETION OF NON-JL TYPE TRANSACTION NOT ALLOWED */
            {pxmsg.i &MSGNUM=3135 &ERRORLEVEL=3}
            undo loopd.
         end. /* IF (type_parm <> "YA")... */

         del-yn = yes.
         /* CONFIRM DELETE */
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         if del-yn = no
         then
            undo loopd.
      end. /* IF lastkey = keycode("F5") */

      if del-yn
      then do:

         if  not allow-gaps
         and daybooks-in-use
         and not (can-find (first g1
                                where g1.glt_domain = global_domain and
                                g1.glt_ref  =  glt_det.glt_ref
                               and   g1.glt_line <> glt_det.glt_line))
         then do:

            /* SEQUENCE DOES NOT ALLOW GAPS */
            {pxmsg.i &MSGNUM     = 1349
                     &ERRORLEVEL = 3}
            undo loopd.

         end. /* IF NOT allow-gaps */

         for first ac_mstr
            fields( ac_domain ac_code ac_curr ac_desc ac_modl_only ac_type)
             where ac_mstr.ac_domain = global_domain and  ac_code = glt_acc
            no-lock:
         end. /* FOR FIRST ac_mstr */

         if available ac_mstr
         and ac_type <> "M"
         and ac_type <> "S"
         then do:
            if not cash_book
            then
               tot_amt = tot_amt - glt_amt.
            else do:   /*CASHBOOK - ALL LINES SAME CURR*/
               if ctrl_curr = base_curr
               then
                  tot_amt = tot_amt - glt_amt.
               else
                  tot_amt = tot_amt - glt_curr_amt.
            end. /* ELSE DO: */
         end. /* IF AVAILABLE ac_mstr */

         if glt_amt > 0
         then do:
            if ctrl_curr = base_curr
            then
               dr_tot = dr_tot - glt_amt.
            else
            if glt_curr = ctrl_curr
            or ac_curr  = ctrl_curr
            then
               dr_tot = dr_tot - glt_curr_amt.
         end. /* IF glt_amt > 0 */

         /* DELETE ANY RELATED EXCHANGE RATE USAGE RECORDS */
         {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
            "(input glt_det.glt_exru_seq)"}
         {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
            "(input glt_det.glt_en_exru_seq)"}

         if glt_tr_type <> "**"
         and (glt_rflag = no
         or can-do("RV,RA",glt_tr_type) = no)
         then do:

            {gprunp.i "gpaudpl" "p" "set_delete_message"
               "(input getTermLabel(""ACCOUNT"",3) + "":"" +
                       glt_det.glt_acc +
                       (if glt_det.glt_sub <> """" then
                           "" "" + getTermLabel(""SUB-ACCOUNT"",3) +
                           "":"" + glt_det.glt_sub
                        else """") +
                       (if glt_det.glt_cc <> """" then
                           "" "" + getTermLabel(""COST_CENTER"",3) +
                           "":"" + glt_det.glt_cc
                        else """") +
                       (if glt_det.glt_project <> """" then
                           "" "" + getTermLabel(""PROJECT"",8) +
                           "":"" + glt_det.glt_project
                        else """") +
                       (if glt_det.glt_doc <> """" then
                           "" "" + getTermLabel(""DOCUMENT"",3) +
                           "":"" + glt_det.glt_doc
                        else """") +
                       (if glt_det.glt_desc <> """" then
                           "" "" + getTermLabel(""DESCRIPTION"",4) +
                           "":"" + glt_det.glt_desc
                        else """"))"}
            {gprunp.i "gpaudpl" "p" "audit_record_deletion"}

         end. /* IF glt_tr_type <> "**"... */
/*XXCH911*/        /* DELETE UNPOSTED VOUCHER EXTENSION */
/*XXCH911*/        {chxgltde.i &ref=glt_det.glt_ref &rflag=glt_det.glt_rflag}

         delete glt_det.

         for each glt_det
            no-lock
             where glt_det.glt_domain = global_domain and  glt_ref = ref:
/*GUI*/ if global-beam-me-up then undo, leave.

            {gprunp.i "gpaudpl" "p" "set_search_key"
               "(input glt_det.glt_ref + "".""
                        + string(glt_det.glt_line))"}
            {gprunp.i "gpaudpl" "p" "save_before_image"
               "(input rowid(glt_det))"}
         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH glt_det  */

         hide frame d.
         clear frame b.
         del-yn = no.

         if type_parm <> "YA"
         then
            display
               tot_amt
            with frame a.
         else
            display
               tot_amt
            with frame ya.

         next loopc.

      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF DEL-YN */

      /* INITIALIZE SETTINGS */
      {gprunp.i "gpglvpl" "p" "initialize"}

      /* VALIDATE UNCONDITIONALLY, REGARDLESS OF 36.1 */
      {gprunp.i "gpglvpl" "p" "set_always_ver" "(input true)"}

      /* ACCT/SUB/CC/PROJ VALIDATION */
      {gprunp.i "gpglvpl" "p" "validate_fullcode"
         "(input glt_acc,
           input glt_sub,
           input glt_cc,
           input glt_project,
           output valid_acct)"}

      if valid_acct = no
      then do:
         next-prompt
            glt_acc
            with frame d.
         undo loopd, retry.
      end. /* IF valid_acct = no  */

      for first al_mstr
         fields( al_domain al_code al_desc)
          where al_mstr.al_domain = global_domain and  al_code = glt_acc
         no-lock:
      end. /* FOR FIRST al_mstr  */

      if available al_mstr
      then do:
         allocation = yes.
         message al_desc.
      end. /*  IF AVAILABLE al_mstr */
      else
         allocation = no.

      /* CHECK WHETHER ENTRIES ARE ALLOWED */
      for first ac_mstr
         fields( ac_domain ac_code ac_curr ac_desc ac_modl_only ac_type)
          where ac_mstr.ac_domain = global_domain and  ac_code = glt_acc
         no-lock:
      end. /* FOR FIRST ac_mstr */

      if available ac_mstr
      and ac_modl_only
      then do:
         /* GL ENTRIES NOT ALLOWED TO THIS ACCT */
         {pxmsg.i &MSGNUM=3068 &ERRORLEVEL=3}.
         next-prompt
            glt_acc
         with frame d.
         undo loopd, retry.
      end. /* IF AVAILABLE ac_mstr */

      if allocation = no
      then do:
         memoflag = no.

         if ac_type = "M"
         then do:
            memoflag = yes.
            /* MEMO ACCOUNT */
            {pxmsg.i &MSGNUM=3086 &ERRORLEVEL=2}
         end. /* IF ac_type = "M"  */

         if ac_type = "S"
         then do:
            memoflag = yes.
            /* STATISTICAL ACCOUNT */
            {pxmsg.i &MSGNUM=3085 &ERRORLEVEL=2}
         end. /* IF ac_type = "S" */
         message ac_desc.

         if glt_acc = pl
         then do:
            /* TRANSACTION TO P/L ACCOUNT */
            {pxmsg.i &MSGNUM=3034 &ERRORLEVEL=3}
            undo loopd, retry.
         end. /* IF glt_acc = pl */
      end. /* IF ALLOCATION = NO */

      /* CASH ACCOUNT LINE WILL BE CREATED AUTOMATICALLY */
      if cash_book
      then do:
         for first bk_mstr
            fields( bk_domain bk_acct bk_cc bk_code bk_sub)
             where bk_mstr.bk_domain = global_domain and  bk_code = bank_bank
            no-lock:
         end. /* FOR FIRST bk_mstr */

         if  bk_acct = glt_acct
         and bk_sub  = glt_sub
         and bk_cc   = glt_cc
         then do:
            {pxmsg.i &MSGNUM=166 &ERRORLEVEL=3}
            /*BANK CASH ACCT NOT ALLOWED*/
            next-prompt
               account
               with frame b.
            undo loopd, retry.
         end. /* IF  bk_acct = glt_acct ... */
      end. /* IF cash_book */

      /* EAS CHANGED ACCOUNT FROM 14 TO 22, BUT DISPLAY 14 HERE */
      {glacct.i &acc=glt_acc &sub=glt_sub &cc=glt_cc &acct=account}
      display account with frame b.

   end. /* LOOPD */
   hide frame d.

   /* ENTER REMAINING FIELDS */
   if (type_parm = "YA")
   or allow_mod
   or glt_tr_type = "JL"
   then do:
      ststatus = stline[3].
      status input ststatus.

      /* DISPLAY PROJECT ON MAIN LINE AFTER ENTRY ON POPUP  */
      display
         glt_project
      with frame b.

      loope:
      do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

/*XXCH911*/     /* GENERATE DR_CR FLAG AND XAMT */
/*XXCH911*/     {chtramt1.i &glamt=glt_amt
                            &glcurramt=glt_curr_amt
                            &coa=glt_correction
                            &glcurr=glt_curr
                            &basecurr=base_curr
                            &usecurramt=yes
                            &drcr=dr_cr
                            &dispamt=xamt}
/*XXCH911*/        display dr_cr xamt with frame b.
         if not cash_book and not first-is-cons then
         set
               glt_entity
/*XXCH911*/          dr_cr
         with frame b.
         for first en_mstr
            fields(en_domain en_entity en_consolidation)
            where en_domain = glt_domain and en_entity = glt_entity
         no-lock:
         end.
/*GUI*/ if global-beam-me-up then undo, leave.

         if will-be-first then assign
          first-is-cons = (available en_mstr and en_consolidation)
          will-be-first = false.
         else if available en_mstr and en_consolidation and not first-is-cons
         then do:
            {pxmsg.i &MSGNUM=6183 &ERRORLEVEL=3}
            undo loope, retry.
         end.

         /* TO DISPLAY THE SAME DESCRIPTION IN FRAME descx_frm */
         /* AS THAT DISPLAYED IN FRAME b                       */
         pause 0.

         /*V8+*/

         display
            descx
         with frame descx_frm.

         set
            descx format "x(21)"
         with frame descx_frm.

         hide frame descx_frm.

         /* TO DISPLAY THE DESCRIPTION IN FRAME b    */
         /* AFTER ENTERING IT IN FRAME descx_frm     */
         display
            descx
         with frame b.

         /* Validate Transaction for Daybook */
         if daybooks-in-use
         then do:
            {gprun.i ""gldyver.p"" "(input tr_type,
                                     input l_doc_type,
                                     input dft-daybook,
                                     input glt_entity,
                                     output daybook-error)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            if daybook-error
            then do:
               /* WARNING: DAYBOOK DOES NOT MATCH ANY DEFAULT */
               {pxmsg.i &MSGNUM=1674 &ERRORLEVEL=2}
               if not batchrun
               then
                  pause.
            end. /* IF daybook-error */
         end. /* IF daybooks-in-use */

         /* VALIDATE PROJECT */
         if glt_project <> ""
         then do:

            if allocation
            then do:
               /* PROJECT WILL OVERIDE ANY PROJECTS SPECIFIED IN ALLOCATION */
               {pxmsg.i &MSGNUM=3114 &ERRORLEVEL=2}
            end. /* IF allocation */
         end. /* IF glt_project <> "" */

         /* VALIDATE ENTITY */
         for first en_mstr
            fields( en_domain en_curr en_entity)
             where en_mstr.en_domain = global_domain and  en_entity = glt_entity
            no-lock:
         end. /* FOR FIRST en_mstr */

         if not available en_mstr
         then do:
            /* INVALID ENTITY */
            {pxmsg.i &MSGNUM=3061 &ERRORLEVEL=3}
            next-prompt
               glt_entity
            with frame b.
            undo loope, retry.
         end. /* IF NOT AVAILABLE en_mstr */

         /* CHECK ENTITY SECURITY */
         {glenchk.i &entity=en_entity &entity_ok=entity_ok}
         if not entity_ok
         then do:
            next-prompt
               glt_entity
            with frame b.
            undo loope, retry.
         end. /* IF NOT entity_ok */

         /* CHECK FOR CLOSED PERIODS */
         {glper.i eff_dt per_yr glt_entity}
         if glcd_yr_clsd = yes
         then do:
            /* YEAR HAS BEEN CLOSED */
            {pxmsg.i &MSGNUM=3022 &ERRORLEVEL=3}
            next-prompt
               glt_entity
            with frame b.
            undo loope, retry.
         end. /* IF glcd_yr_clsd = yes */

         if glcd_gl_clsd = yes
         then do:
            /* PERIOD HAS BEEN CLOSED */
            {pxmsg.i &MSGNUM=3023 &ERRORLEVEL=3}
            next-prompt
               glt_entity
               with frame b.
            undo loope, retry.
         end. /* IF glcd_gl_clsd = yes */

         if type_parm = "YA"
         then do:
            for each glcd_det
               fields( glcd_domain glcd_entity glcd_gl_clsd glcd_per
                      glcd_year glcd_yr_clsd)
                where glcd_det.glcd_domain = global_domain and  glcd_year = 
                glc_year
               and glcd_entity = glt_entity
               no-lock break by glcd_per:
/*GUI*/ if global-beam-me-up then undo, leave.


               {glcabmsv.i
                  &service = FIND_MODULE_DETAIL
                  &fyear   = glc_year
                  &fper    = glcd_per
                  &entity  = glcd_entity}

               if glcd_ap_clsd   = no
               or glcd_ar_clsd   = no
               or glcd_fa_clsd   = no
               or glcd_ic_clsd   = no
               or glcd_so_clsd   = no
               or last(glcd_per) = no
               and glcd_gl_clsd  = no
               or last(glcd_per) = yes
               and glcd_gl_clsd  = yes
               then do:
                  /* INVALID YEAR */
                  {pxmsg.i &MSGNUM=3019 &ERRORLEVEL=3}
                  next-prompt
                     glt_entity
                  with frame b.
                  undo loope, retry.
               end. /* IF glcd_ap_clsd = no */
            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH glcd_det */
         end. /* IF type_parm = "YA" */

         loopcurr:
         do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


            /* FOR CASH BOOK, glt_curr = bk_curr */
            set
               glt_curr when (not cash_book)
            with frame b.

            if glt_curr = ""
            then
               glt_curr = en_curr.

            /* DOES NOT ALLOW BLANK CURR IF ENTITY CURR IS NOT BLANK */
            display
               glt_curr
            with frame b.

            /* VALIDATE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
               "(input glt_curr,
                 output mc-error-number)"}

            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
               next-prompt
                  glt_curr
               with frame b.
               undo loopcurr, retry.
            end. /* IF mc-error-number <> 0 */

            if base_curr <> ctrl_curr
            and glt_curr <> base_curr
            and glt_curr <> ctrl_curr
            then do:
               /* CURRENCY MUST BE (BASE) OR (CONTROL CURRENCY) */
               {pxmsg.i &MSGNUM=3100 &ERRORLEVEL=3
                        &MSGARG1=base_curr
                        &MSGARG2=ctrl_curr}
               next-prompt
                  glt_curr
               with frame b.
               undo loopcurr, retry.
            end. /* IF base_curr <> ctrl_curr */

            /* THE ABOVE VALIDATION WILL NOT BE PERFORMED   */
            /* IF BASE = CTRL SO . . . . LET'S ENSURE WE'VE */
            /* GOT A CORRECT ROUND METHOD  */
            if glt_curr     <> old_gltcurr
            or (old_gltcurr = "")
            then do:
               if glt_curr = base_curr
               then
                  gltcurr_rndmthd = gl_rnd_mthd.
               else if glt_curr = ctrl_curr
               then
                  gltcurr_rndmthd = ctrl_rndmthd.
               else do:

                  /* GET ROUNDING METHOD FROM CURRENCY MASTER */
                  {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                     "(input glt_curr,
                       output gltcurr_rndmthd,
                       output mc-error-number)"}
                  if mc-error-number <> 0
                  then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                     next-prompt
                        glt_curr
                     with frame b.
                     undo loopcurr, retry.
                  end. /* if mc-error-number <> 0 */

               end. /* ELSE DO: */

               assign
                  old_gltcurr = glt_curr
                  /* SET XAMT FORMAT BASED ON NEW GLTCURR_RNDMTHD */
                  xamt_gltc_fmt = xamt_old.

               {gprun.i ""gpcurfmt.p"" "(input-output xamt_gltc_fmt,
                                         input gltcurr_rndmthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               xamt:format = xamt_gltc_fmt.

               display
                  xamt
               with frame b.
            end. /* IF glt_curr <> old_gltcurr ... */

            /* FOREIGN TRANSACTION CURRENCY ALLOWED WITH */
            /* ALLOCATION CODE ONLY IF EVERY ALLOCATED   */
            /* ACCOUNT HAS SAME CURRENCY                 */
            if allocation
            then do:
               assign
                  acct_curr = glt_curr
                  acct_code = glt_acc.

               if glt_curr <> base_curr
               then do:
                  {gprun.i ""gpalcur.p"" "(input glt_acc,
                                           input glt_curr,
                                           output valid_al)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  if not valid_al
                  then do:
                     /* ALLOCATIONS MUST BE IN TRANSACTION CURRENCY */
                     {pxmsg.i &MSGNUM=3087 &ERRORLEVEL=3}
                     next-prompt
                        glt_curr
                     with frame b.
                     undo loopcurr, retry.
                  end. /* IF NOT valid_al */
               end. /* IF glt_curr <> base_curr */

               assign
                  acct_curr = glt_curr
                  acct_code = glt_acc.
            end. /* IF allocation */
            else do: /* NOT ALLOCATION */
               if  glt_curr <> ac_curr
               and glt_curr <> base_curr
               and ac_curr  <> base_curr
               then do:
                  /* CURRENCY MUST BE (BASE) OR (ACCT CURRENCY) */
                  {pxmsg.i &MSGNUM=3100 &ERRORLEVEL=3 &MSGARG1=base_curr
                           &MSGARG2=ac_curr}
                  next-prompt
                     glt_curr
                  with frame b.
                  undo loopcurr, retry.
               end. /* IF glt_curr <> ac_curr and ... */

               assign
                  acct_curr = ac_curr
                  acct_code = ac_code.
            end. /* ELSE DO: */
         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* LOOPCURR */

         /* SET XAMT AND VALIDATE TO CURRENCY ROUNDING METHOD */
         updt_xamt:
         do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

/*CF*            set xamt with frame b. */
/*CF*/           set xamt
/*CF*/              go-on("F12" "CTRL-A") with frame b.

/*CF*/      /* Active Cash Flow Maintenance Program */
/*CF*/      if lastkey = keycode("F12") or lastkey = keycode("CTRL-A")
/*CF*/      then do:
/*CF*/        find xcf_mstr where xcf_ac_code = glt_det.glt_acct
                            and xcf_sub = glt_det.glt_sub
                            and xcf_cc = glt_det.glt_cc
                            and xcf_pro = glt_det.glt_project
/*CF*/                      and xcf_active = yes and xcf_domain = global_domain
/*CF*/                          no-lock no-error.
/*CF*/         if available xcf_mstr then do:
/*CF*/            w-recid = recid(glt_det).
/*CF*/            {gprun.i ""chcftrma.p""}
/*GUI*/ if global-beam-me-up then undo, leave.
  
/*CF*/         end.
/*CF*/      end. /* if lastkey */
   
            if (xamt <> 0)
            then do:
               {gprun.i ""gpcurval.p"" "(input xamt,
                                         input gltcurr_rndmthd,
                                         output retval)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               if retval <> 0
               then do:
                  next-prompt
                     xamt
                  with frame b.
                  undo updt_xamt, retry.
               end. /* IF retval <> 0 */
            end.  /* IF (xamt <> 0) */

/*XXCH911*/           /* VALIDATE xamt entered is more than zero */
/*XXCH911*/           if (xamt < 0 and not corr-flag) or
/*XXCH911*/              (xamt > 0 and corr-flag) then do:
/*XXCH911*/              {mfmsg.i 9802 3}
/*XXCH911*/              next-prompt xamt with frame b.
/*XXCH911*/              undo updt_xamt, retry.
/*XXCH911*/           end.

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* UPDT_XAMT */

/*XXCH911*/        /* GENERATE INTERNAL TRANS AMOUNT */
/*XXCH911*/        {chtramt2.i &dispamt=xamt
                               &drcr=dr_cr
                               &glamt=xamt}


         assign
            glt_desc = descx
            desc1    = glt_desc
            entity   = glt_entity.

         /* THE FOLLOWING SECTION SETS GLT_AMT AND GLT_CURR_AMT  */
         /* AND PROMPTS FOR GLT_EX_RATE IF NECESSARY. THERE ARE  */
         /* THREE POSSIBLE SCENARIOS INVOLVING FOREIGN CURRENCY: */
         /* (VARIABLES ACCT_CURR AND ACCT_CODE ARE USED SO THAT  */
         /* ALLOCATION CODES CAN USE SAME PROCESSING LOGIC)      */
         if xamt     <> oldamt
         or glt_curr <> old_curr
         then do:
            glt_amt = xamt.

            if  glt_curr  = base_curr
            and acct_curr = base_curr
            then
               glt_curr_amt = 0.
         end. /* IF xamt <> oldamt ...*/

         /* (1) TRANSACTION CURRENCY IS FOREIGN */
         /* AND ACCOUNT CURRENCY IS FOREIGN     */
         if  glt_curr <> base_curr
         and acct_curr = glt_curr
         then do:

            if cash_book
            then
               assign
                  glt_ex_rate  = bank_ex_rate
                  glt_ex_rate2 = bank_ex_rate2.
            else do:
               currency = "glt".

               if not new glt_det
               then do:
                  if oldamt     <> xamt
                  or glt_entity <> old_entity
                  or glt_acc    <> old_acct
                  or glt_curr   <> old_curr
                  then
                     chg_trans = yes.
               end. /*IF NOT NEW glt_det */

               /* ADDED SECOND EXCHANGE RATE, TYPE, SEQUENCE */
               {gprun.i ""gltrmtb.p"" "(input base_curr,
                                        input  glt_curr,
                                        input  acct_curr,
                                        input  glt_acc,
                                        input  glt_entity,
                                        input  glt_ex_rate,
                                        input  glt_ex_rate2,
                                        input  glt_ex_ratetype,
                                        input  glt_exru_seq,
                                        output glt_ex_rate,
                                        output glt_ex_rate2,
                                        output glt_ex_ratetype,
                                        output glt_exru_seq
                                       )"}
/*GUI*/ if global-beam-me-up then undo, leave.


               {gprunp.i "mcui" "p" "mc-ex-rate-input"
                  "(input glt_curr,
                    input base_curr,
                    input eff_dt,
                    input glt_exru_seq,
                    input false,
                    input 12,
                    input-output glt_ex_rate,
                    input-output glt_ex_rate2,
                    input-output fixed-rate)"}
            end. /* ELSE DO */

            if xamt         <> oldamt
            or glt_ex_rate  <> oldexrate
            or glt_ex_rate2 <> oldexrate2
            or glt_curr     <> old_curr
            then
               glt_curr_amt = xamt.

            if glt_ex_rate   <> 0
            and glt_ex_rate2 <> 0
            then do:

               if xamt         <> oldamt
               or glt_ex_rate  <> oldexrate
               or glt_ex_rate2 <> oldexrate2
               or glt_curr     <> old_curr
               then do:

                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input glt_curr,
                       input base_curr,
                       input glt_ex_rate,
                       input glt_ex_rate2,
                       input xamt,
                       input true, /* ROUND */
                       output glt_amt,
                       output mc-error-number)"}
                  if mc-error-number <> 0
                  then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end. /* IF mc-error-number <> 0 ... */

               end. /* IF xamt <> oldamt */

            end.  /* IF GLT_EX_RATE <> 0 */
            else if xamt    <> oldamt
            or glt_ex_rate  <> oldexrate
            or glt_ex_rate2 <> oldexrate2
            or glt_curr     <> old_curr
            then
               glt_amt = 0.

            /* AMOUNT IN BASE CURRENCY IS (AMOUNT) (CURRENCY) */
            {pxmsg.i &MSGNUM=3080 &ERRORLEVEL=2
                     &MSGARG1="glt_amt, "xamt_base_fmt" " &MSGARG2=base_curr}

         end. /* (1) */

         /* (2) TRANSACTION CURRENCY IS BASE */
         /* AND ACCOUNT CURRENCY IS FOREIGN  */
         if  glt_curr  = base_curr
         and acct_curr <> base_curr
         then do:

            /* AMOUNT WILL BE CONVERTED IN ACCT # TO CURRENCY # */
            {pxmsg.i &MSGNUM=94 &ERRORLEVEL=2 &MSGARG1=ac_code
                     &MSGARG2=acct_curr}

            /* CREATE USAGE WHEN NEW OR CHANGED GLT TRANSACTION */
            currency = "acc".

            if not new glt_det
            then do:
               if oldamt     <> xamt
               or glt_entity <> old_entity
               or glt_acc    <> old_acct
               or glt_curr   <> old_curr
               then
                  chg_trans = yes.
            end. /* IF NOT NEW glt_det */

            /* ADDED SECOND EXCHANGE RATE, TYPE, SEQUENCE */
            {gprun.i ""gltrmtb.p"" "(input  base_curr,
                                     input  glt_curr,
                                     input  acct_curr,
                                     input  glt_acc,
                                     input  glt_entity,
                                     input  glt_ex_rate,
                                     input  glt_ex_rate2,
                                     input  glt_ex_ratetype,
                                     input  glt_exru_seq,
                                     output glt_ex_rate,
                                     output glt_ex_rate2,
                                     output glt_ex_ratetype,
                                     output glt_exru_seq
                                    )"}
/*GUI*/ if global-beam-me-up then undo, leave.


            {gprunp.i "mcui" "p" "mc-ex-rate-input"
               "(input acct_curr,
                 input glt_curr,
                 input eff_dt,
                 input glt_exru_seq,
                 input false,
                 input 12,
                 input-output glt_ex_rate,
                 input-output glt_ex_rate2,
                 input-output fixed-rate)"}

            if  glt_ex_rate  <> 0
            and glt_ex_rate2 <> 0
            then do:

               if xamt         <> oldamt
               or glt_ex_rate  <> oldexrate
               or glt_ex_rate2 <> oldexrate2
               or glt_curr     <> old_curr
               then do:

                  /* CONVERT FROM BASE TO FOREIGN CURRENCY */
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input glt_curr,
                       input acct_curr,
                       input glt_ex_rate2,
                       input glt_ex_rate,
                       input xamt,
                       input true,   /* ROUND */
                       output glt_curr_amt,
                       output mc-error-number)"}
                  if mc-error-number <> 0
                  then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end. /* IF mc-error-number <> 0 */

               end. /* IF xamt <> oldamt */

               if acct_curr   <> old_acccurr
               or (old_acccurr = "")
               then do:

                  /* GET ROUNDING METHOD FROM CURRENCY MASTER */
                  {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                     "(input acct_curr,
                       output acc_rndmthd,
                       output mc-error-number)"}
                  if mc-error-number <> 0
                  then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                     pause 0.
                     leave.
                  end. /* IF mc-error-number <> 0 */

                  assign
                     old_acccurr     = acct_curr
                     glt_curramt_fmt = "->,>>>,>>>,>>9.99".

                  {gprun.i ""gpcurfmt.p""
                     "(input-output glt_curramt_fmt,
                       input acc_rndmthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end. /* IF acct_curr <> old_acccurr or ... */

               acct = glt_acc.
               if glt_sub <> ""
               then
                  acct = acct + "/" + glt_sub.

               if glt_cc <> ""
               then
                  acct = acct + "/" + glt_cc.

               /* AMOUNT IN CURRENCY OF ACCOUNT (acct/sub/cc) IS */
               /* (Amount) (Currency) */
               {pxmsg.i &MSGNUM=3081 &ERRORLEVEL=2 &MSGARG1=acct
                        &MSGARG2="glt_curr_amt,"glt_curramt_fmt" "
                        &MSGARG3=acct_curr}

            end. /* IF glt_ex_rate <> 0 */

         end. /* (2) */

         /* (3) TRANSACTION CURRENCY IS FOREIGN */
         /* AND ACCOUNT CURRENCY IS BASE        */
         if  glt_curr <> base_curr
         and acct_curr = base_curr
         then do:

            if cash_book
            then
               assign
                  glt_ex_rate  = bank_ex_rate
                  glt_ex_rate2 = bank_ex_rate2.
            else do: /* NOT CASH BOOK */

               currency = "glt".
               /* CREATE USAGE RECORDS WHEN NEW OR CHANGED */
               /* GLT TRANSACTION */
               if not new glt_det
               then do:
                  if oldamt     <> xamt
                  or glt_entity <> old_entity
                  or glt_acc    <> old_acct
                  or glt_curr   <> old_curr
                  then
                     chg_trans = yes.
               end. /* IF NOT NEW glt_det */

               /* ADDED SECOND EXCHANGE RATE, TYPE, SEQUENCE */
               {gprun.i ""gltrmtb.p"" "(input base_curr,
                                        input  glt_curr,
                                        input  acct_curr,
                                        input  glt_acc,
                                        input  glt_entity,
                                        input  glt_ex_rate,
                                        input  glt_ex_rate2,
                                        input  glt_ex_ratetype,
                                        input  glt_exru_seq,
                                        output glt_ex_rate,
                                        output glt_ex_rate2,
                                        output glt_ex_ratetype,
                                        output glt_exru_seq)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               /* EXCHANGE RATE ENTRY LOOP */

               loopf:
               do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


                  {gprunp.i "mcui" "p" "mc-ex-rate-input"
                     "(input glt_curr,
                       input base_curr,
                       input eff_dt,
                       input glt_exru_seq,
                       input false,
                       input 12,
                       input-output glt_ex_rate,
                       input-output glt_ex_rate2,
                       input-output fixed-rate)"}

               end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* LOOPF */

            end. /* NOT CASH BOOK */

            if  glt_ex_rate   <> 0
            and glt_ex_rate2  <> 0
            then do:

               if xamt         <> oldamt
               or glt_ex_rate  <> oldexrate
               or glt_ex_rate2 <> oldexrate2
               or glt_curr     <> old_curr
               then do:
                  /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input glt_curr,
                       input base_curr,
                       input glt_ex_rate,
                       input glt_ex_rate2,
                       input xamt,
                       input true,   /* ROUND */
                       output glt_amt,
                       output mc-error-number)"}
                  if mc-error-number <> 0
                  then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end. /* IF mc-error-number <> 0 */
               end. /* IF xamt <> oldamt */

            end. /* IF GLT_EX_RATE <> 0 */

            /* ROUND USING BASE CURRENCY ROUNDING METHOD */

            if xamt         <> oldamt
            or glt_ex_rate  <> oldexrate
            or glt_ex_rate2 <> oldexrate2
            or glt_curr     <> old_curr
            then
                  glt_curr_amt = xamt.

            /* AMOUNT IN BASE CURRENCY IS (Amount) (Currency) */
            {pxmsg.i &MSGNUM=3080 &ERRORLEVEL=2
                     &MSGARG1="glt_amt, "xamt_base_fmt" "
                     &MSGARG2=base_curr}

         end. /* (3) */

         for first en_mstr
            fields( en_domain en_curr en_entity)
             where en_mstr.en_domain = global_domain and  en_entity = glt_entity
            no-lock:
         end. /* FOR FIRST en_mstr */

         if available en_mstr
         then
            if en_curr = base_curr
            then
               assign
                  glt_ecur_amt    = glt_amt
                  glt_en_exrate   = glt_ex_rate
                  glt_en_exrate2  = glt_ex_rate2
                  glt_en_exru_seq = glt_exru_seq.
            else if en_curr = glt_curr
            then
               assign
                  glt_ecur_amt   = glt_curr_amt
                  glt_en_exrate  = 1
                  glt_en_exrate2 = 1.

      end. /* LOOPE */

      if  glt_amt          =  0
      and glt_curr_amt     <> 0
      then do:
         /* BASE CUR AMOUNT CANNOT BE ZERO FOR FOREIGN CUR AMOUNT */
         {pxmsg.i &MSGNUM=4575 &ERRORLEVEL=3}
         undo loopc, retry.
      end. /* IF glt_amt = 0 AND ... */

      /* CURRENCY OF AMOUNT IN AMT IS DETERMINED BY THE CTRL_CURR. */
      /* AMT IS ASSIGNED A VALUE AT THE BEGINNING OF THIS PROGRAM. */
      if amt > 0
      and (ctrl_curr    = base_curr
           or ctrl_curr = glt_curr
           or ctrl_curr = acct_curr)
      then
         dr_tot = dr_tot - amt.

      if  ctrl_curr = base_curr
      and glt_amt   > 0
      then
         dr_tot = dr_tot + glt_amt.

         else if (glt_curr        = ctrl_curr
                  or acct_curr    = ctrl_curr)
         and glt_curr_amt > 0
         then
            dr_tot = dr_tot + glt_curr_amt.

         if not memoflag
         then do:
            if not cash_book
            then
               assign
                  tot_amt = tot_amt - base_amt
                  tot_amt = tot_amt + glt_amt.
            else do:   /*CASHBOOK - ALL LINES SAME CURR*/
               if ctrl_curr = base_curr
               or ctrl_curr = glt_curr
               or ctrl_curr = ac_curr
               then
                  tot_amt = tot_amt - amt.

               if ctrl_curr = base_curr
               then
                  tot_amt = tot_amt + glt_amt.
               else
                  tot_amt = tot_amt + glt_curr_amt.
            end. /* ELSE DO: */

         end. /* IF NOT MEMOFLAG */

         /* CHECK FOR OUT OF BALANCE OF 0.01 AND DISPLAY 0     */
         /* (PROBLEM FROM ROUNDING)                            */

         /* DISPLAY TOTAL AMOUNT IRRESPECTIVE OF IT'S VALUE    */
        if type_parm <> "YA"
        then
           display
              tot_amt
           with frame a.
        else
           display
              tot_amt
           with frame ya.

         glt_unb = no.

      end. /* IF ALLOW_MOD OR GL_TR_TYPE = "JL" (ENTER REMAINING) */

   down 1 with frame b.

   {gprunp.i "gpaudpl" "p" "set_search_key"
      "(input glt_det.glt_ref + "".""
              + string(glt_det.glt_line))"}
   {gprunp.i "gpaudpl" "p" "audit_record_addition"
      "(input rowid(glt_det))"}
   {gprunp.i "gpaudpl" "p" "audit_record_change"}

end. /* LOOPC */
