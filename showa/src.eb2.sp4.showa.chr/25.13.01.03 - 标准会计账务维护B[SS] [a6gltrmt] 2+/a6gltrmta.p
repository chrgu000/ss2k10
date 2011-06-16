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
/* $Revision: 1.60.1.1 $    BY: K Paneesh           DATE: 08/08/03  ECO: *N2JT*    */
/* $Revision: eb2sp4        BY: Micho Yang          DATE: 06/06/06  ECO: *SS - Micho - 20060606*    */
/* $Revision: eb2sp4        BY: Micho Yang          DATE: 07/09/06  ECO: *SS - Micho - 20060709*    */
/* BY: Micho Yang          DATE: 04/24/08  ECO: *SS - 20080424.1* */
/***************************************************************************/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20080424.1 - B */
/*
1. 每Line指定DR/CR  (金额为正数时默认DR,负数时默认CR)
2. 添加多项目录入数据界面，采用并列式和多级式并存的方式．相关的资料存放在usrw_wkfl
*/                                                                        
/* SS - 20080424.1 - E */                                                                    

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

define shared variable ref               like glt_ref.
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

/****************************** Add by SS - Micho - 20060709 B ******************************/
DEF SHARED VAR v_annex LIKE glt_user2 .
/****************************** Add by SS - Micho - 20060709 B ******************************/

define shared frame a.
define shared frame ya.

define        variable glt-hand         as handle                  no-undo.
/****************************** Add by SS - Micho - 20060709 B ******************************/
/*
define        variable descx          like glt_desc format "x(13)" no-undo.
*/
define        variable descx          LIKE glt_desc format "x(8)" no-undo.
/****************************** Add by SS - Micho - 20060709 B ******************************/
define        variable amt            like glt_amt.
define        variable xamt           like glt_amt .
define        variable acct             as character format "x(22)".
define        variable curr           like glt_curr.
define        variable allocation       as logical.
define        variable memoflag         as logical.
define        variable del-yn           as logical initial no.
define        variable valid_acct     like mfc_logical.
/* SS - 20080424.1 - B */
/*
define        variable account          as character format "x(22)"
                                                  label "Account".
*/
define        variable account          as character format "x(18)"
                                                  label "Account".
/* SS - 20080424.1 - E */
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

define buffer g1 for glt_det.

/* SS - 20080424.1 - B */
define variable first_sw_call as logical initial true.
define variable apwork-recno  as recid.
DEF VAR v_tt1_flag AS LOGICAL.
DEF VAR v_tt2_flag AS LOGICAL.

DEF TEMP-TABLE tt1 NO-UNDO
    FIELD tt1_stat AS CHAR FORMAT "x(1)"
    FIELD tt1_nbr AS CHAR
    FIELD tt1_nbr_desc AS CHAR FORMAT "x(24)" 
    INDEX tt1nbr tt1_nbr
    .
DEF TEMP-TABLE tt2 NO-UNDO
    FIELD tt2_nbr AS CHAR
    FIELD tt2_nbr_desc AS CHAR FORMAT "x(24)" 
    FIELD tt2_nbr1 AS CHAR
    FIELD tt2_nbr1_desc AS CHAR FORMAT "x(24)" 
    FIELD tt2_amt LIKE glt_amt
    FIELD tt2_ref LIKE glt_ref
    FIELD tt2_line LIKE glt_line
    INDEX tt2nbr1 tt2_nbr1 
    INDEX tt2amt tt2_amt
    .
DEF TEMP-TABLE tt3 NO-UNDO
    FIELD tt3_nbr AS CHAR.


DEF BUFFER usrw FOR usrw_wkfl .

DEF VAR jj AS INTEGER .
DEF VAR jj_to AS INTEGER INIT 100 .
DEF VAR vflag AS LOGICAL INIT NO .
DEF VAR vflag1 AS LOGICAL .
DEF QUERY q_tt2 FOR tt2 FIELDS(tt2_nbr tt2_nbr_desc
                               tt2_nbr1 tt2_nbr1_desc tt2_amt) SCROLLING.
/* SS - 20080424.1 - E */

/* MODULE CLOSING ENGINE INCLUDE. */
{glcabmeg.i}

form
   glt_line      /*V8! space(.5) */
   account       /*V8! view-as text size 22 by 1 space(.5) */
   /* SS - 20080424.1 - B */
                 /*V8-*/ format "x(18)" /*V8+*/
   /* SS - 20080424.1 - B */
   glt_project   /*V8! space(.5) */
   glt_entity    /*V8! space(.5) */
   /* SS - 20080424.1 - B */
   glt_correction
   /* SS - 20080424.1 - E */
   descx         /*V8! space(.5) */
   glt_curr      /*V8! space(.5) */
   xamt
   with frame b down width 80 no-hide.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).
{&GLTRMTA-P-TAG1}

/****************************** Add by SS - Micho - 20060606 B ******************************/
/*
form
   descx colon 13 /*V8! space(5) */
   with frame descx_frm side-labels overlay
   row 10 column 25.
   */
form
   /* SS - 20080424.1 - B */
    /*
   descx colon 13 /*V8! space(5) */
      */
   descx COLON 13 FORMAT "x(40)"
   /* SS - 20080424.1 - E */
   with frame descx_frm width 60 side-labels overlay
   row 15 column 8.
/****************************** Add by SS - Micho - 20060606 E ******************************/

/* SET EXTERNAL LABELS */
setFrameLabels(frame descx_frm:handle).

for first gl_ctrl
   fields(gl_rnd_mthd gl_verify)
   no-lock:
end.  /* FOR FIRST gl_ctrl */

/* CURRENCY DEPENDENT ROUNDING NEEDS TO RETAIN GL_CTRL.  SET    */
/* XAMT_BASE_FMT FOR BASE_CURR USAGE (WHEN XAMT IS GLT_AMT) ONE */
/* TIME.  CAPTURE ORIGINAL FORMAT OF XAMT INTO XAMT_OLD.        */
assign
   xamt_old      = xamt:format
   xamt_base_fmt = xamt_old.

{gprun.i ""gpcurfmt.p"" "(input-output xamt_base_fmt,
                          input gl_rnd_mthd)"}

/* GET ENTITY SECURITY INFORMATION */
{glsec.i}
/****************************** Add by SS - Micho - 20060709 B ******************************/
/* {gltrfm.i} */
{a6gltrfm.i}
/****************************** Add by SS - Micho - 20060709 B ******************************/

loopc:
repeat with frame b width 80:

   form
/****************************** Add by SS - Micho - 20060424 B ******************************/ 
      glt_acc   colon 12               glta_acct1  COLON 42
      glt_sub   colon 12               glta_amt    COLON 42
      glt_cc    colon 12               /* glta_acct1 COLON 35 */
      glt_project colon 12             /* glta_usr01 COLON 35 */
      glt__qadc01 COLON 12             /* glta_usr02 COLON 35 */
/****************************** Add by SS - Micho - 20060424 E ******************************/ 

      with frame d WIDTH 60 side-labels overlay
      title color normal (getFrameTitle("ACCOUNT_INFORMATION",28))
      row 12 column 8.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame d:handle).

   /* UPDATE INDIVIDUAL TRANSACTIONS */
   linenum = 1.
   find last glt_det
      where glt_ref     = ref
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
            where g1.glt_ref   = ref
            and g1.glt_line    = 0
            and g1.glt_tr_type <> "**":

            {gprunp.i "gpaudpl" "p" "set_search_key"
               "(input g1.glt_ref + ""."" +
                       string(g1.glt_line))"}
            {gprunp.i "gpaudpl" "p" "save_before_image"
               "(input rowid(g1))"}

            assign
               g1.glt_line = linenum
               linenum     = linenum + 1.
            {gprunp.i "gpaudpl" "p" "audit_record_change"}
         end. /* FOR EACH g1 */
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
      entity  @ glt_entity
      /* SS - 20080424.1 - B */
      corr-flag @ glt_correction
      /* SS - 20080424.1 - E */ 
       .

   prompt-for
      glt_line
   EDITING  :

      if {gpiswrap.i}
      then
         recno = ?.

      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp01.i glt_det glt_line glt_line ref glt_ref glt_ref}
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
            /* SS - 20080424.1 - B */
            glt_correction
            /* SS - 20080424.1 - B */
            glt_desc @ descx
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
            end. /* IF glt_curr <> old_gltcurr */
            xamt:format = xamt_gltc_fmt.
            display
               glt_curr_amt @ xamt.
         end.  /* ELSE DO */

      end.  /* IF recno <> ? AND glt_tr_type <> "**" */

   end.  /* PROMPT-FOR glt_line EDITING */
   {&GLTRMTA-P-TAG3}

   find glt_det
      where glt_ref = ref
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
      
      /****************************** Add by SS - Micho - 20060424 B ******************************/ 
         CREATE glta_det .
         ASSIGN
             glta_ref  = caps(ref)
             glta_line = linenum
             .
      /****************************** Add by SS - Micho - 20060424 E ******************************/ 

         create glt_det.
         assign
            glt_ref         = caps(ref)
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
            /****************************** Add by SS - Micho - 20060709 B ******************************/
            glt_user2       = v_annex 
            /****************************** Add by SS - Micho - 20060709 B ******************************/
            /* SS - 20080424.1 - B */
             /*
            glt_correction  = corr-flag
            */
            /* SS - 20080424.1 - E */
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
         end. /* OLD_GLTCURR <> GLT_CURR */

         xamt:format = xamt_gltc_fmt.

      end. /* ELSE DO: */

      assign
         oldamt     = xamt
         oldexrate  = glt_ex_rate
         oldexrate2 = glt_ex_rate2
         descx      = glt_desc.

   end. /* ELSE-DO */

   recno = recid(glt_det).

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
      /* SS - 20080424.1 - B */
      glt_correction
      /* SS - 20080424.1 - E */
      descx
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

   /****************************** Add by SS - Micho - 20060424 B ******************************/ 
   FIND glta_det WHERE glta_ref = glt_ref AND glta_line = glt_line NO-ERROR .
   IF AVAIL glta_det THEN DO:
       DISPLAY 
          glta_acct1
          glta_amt
          /* glta_acct1
          glta_usr01
          glta_usr02 */
       WITH FRAME d.
   END.
   /****************************** Add by SS - Micho - 20060424 B ******************************/ 


   loopd:
   do on error undo, retry:
      FIND glta_det WHERE glta_ref = glt_ref AND glta_line = glt_line NO-ERROR .
      IF NOT AVAIL glta_det THEN DO:
          CREATE glta_det .
          ASSIGN
             glta_ref  = caps(glt_ref)
             glta_line = glt_line
             .
      END.

      if new glt_det then do:
         DISP "N" @ glt__qadc01 WITH FRAME d .
      end.
      else disp upper(glt__qadc01) @ glt__qadc01 with frame d. 

      set
         glt_acct
         glt_sub when (use_sub)
         glt_cc when (use_cc)
         glt_project
         /******************** SS - 20060928.1 - B ********************/
         glt__qadc01 FORMAT "x(1)" 
         /******************** SS - 20060928.1 - E ********************/
         go-on("F5" "CTRL-D") with frame d.

         /****************************** Add by SS - Micho - 20060424 B ******************************/ 
      SET
         /*
         glta_acct1 WHEN (SUBSTRING(glt_acct,1,4) = '1001' OR SUBSTRING(glt_acct,1,4) = '1002' OR SUBSTRING(glt_acct,1,4) = '1009')
         */
         glta_acct1 WHEN (SUBSTRING(glt_acct,1,2) = '10')
          /*
         glta_amt  FORMAT "->>,>>>,>>9.99" WHEN (SUBSTRING(glt_acct,1,4) = '1243' OR SUBSTRING(glt_acct,1,4) = '5101')
         */
         glta_amt  FORMAT "->>,>>>,>>9.99" WHEN (SUBSTRING(glt_acct,1,6) = '140501' OR SUBSTRING(glt_acct,1,4) = '6001')
         go-on("F5" "CTRL-D") with frame d.
         /* glta_acct1
         glta_usr01
         glta_usr02 */
         /****************************** Add by SS - Micho - 20060424 E ******************************/ 

      /******************** SS - 20060928.1 - B ********************/
      ASSIGN glt__qadc01 = CAPS(glt__qadc01) 
             glta_acct1 = CAPS(glta_acct1) 
             .

      IF not(caps(glt__qadc01) = "Y" OR caps(glt__qadc01) = "N") THEN DO:
         MESSAGE "请输入Y或者N" .
         UNDO loopd, RETRY .
      END.
      /*
      IF (SUBSTRING(glt_acct,1,4) = '1001' OR SUBSTRING(glt_acct,1,4) = '1002' OR SUBSTRING(glt_acct,1,4) = '1009') AND glta_acct1 = "" THEN DO:
      */
      IF (SUBSTRING(glt_acct,1,2) = '10' ) AND glta_acct1 = "" THEN DO:
          MESSAGE "10打头的科目,资金帐不能为空.请重新输入" .
          UNDO loopd, RETRY.
      END.
      /******************** SS - 20060928.1 - E ********************/

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
                               where g1.glt_ref  =  glt_det.glt_ref
                               and   g1.glt_line <> glt_det.glt_line))
         then do:

            /* SEQUENCE DOES NOT ALLOW GAPS */
            {pxmsg.i &MSGNUM     = 1349
                     &ERRORLEVEL = 3}
            undo loopd.

         end. /* IF NOT allow-gaps */

         for first ac_mstr
            fields(ac_code ac_curr ac_desc ac_modl_only ac_type)
            where ac_code = glt_acc
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
         /* SS - 20080424.1 - B */
         FOR EACH usrw_wkfl WHERE usrw_key1 = 'glsum1' AND usrw_key3 = glt_ref
         AND usrw_key4 = STRING(glt_line) :
             DELETE usrw_wkfl .
         END.
         /* SS - 20080424.1 - E */

         delete glt_det.

         /****************************** Add by SS - Micho - 20060606 B ******************************/
         DELETE glta_det .                                                                             
         /****************************** Add by SS - Micho - 20060606 E ******************************/

         for each glt_det
            no-lock
            where glt_ref = ref:
            {gprunp.i "gpaudpl" "p" "set_search_key"
               "(input glt_det.glt_ref + "".""
                        + string(glt_det.glt_line))"}
            {gprunp.i "gpaudpl" "p" "save_before_image"
               "(input rowid(glt_det))"}
         end. /* FOR EACH glt_det  */

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

      end. /* IF DEL-YN */

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
         fields(al_code al_desc)
         where al_code = glt_acc
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
         fields(ac_code ac_curr ac_desc ac_modl_only ac_type)
         where ac_code = glt_acc
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

      /****************************** Add by SS - Micho - 20060424 B ******************************/ 
      FIND FIRST CODE_mstr WHERE CODE_fldname = 'glta_acct1' AND CODE_value = glta_acct1 NO-LOCK NO-ERROR.
      IF NOT AVAIL CODE_mstr THEN DO:
         /* {pxmsg.i &MSGNUM=3068 &ERRORLEVEL=3}. */
         MESSAGE "输入的acct1不存在,请重新输入".
         next-prompt
            glta_acct1
         with frame d.
         undo loopd, retry.
      END.
      
      /*
      FIND FIRST CODE_mstr WHERE CODE_fldname = 'glta_sub1' AND CODE_value = glta_sub1 NO-LOCK NO-ERROR.
      IF NOT AVAIL CODE_mstr THEN DO:
         /* {pxmsg.i &MSGNUM=3068 &ERRORLEVEL=3}. */
         MESSAGE "输入的sub1不存在,请重新输入".
         next-prompt
            glta_sub1
         with frame d.
         undo loopd, retry.
      END.
      */
      /****************************** Add by SS - Micho - 20060424 E ******************************/ 

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
            fields(bk_acct bk_cc bk_code bk_sub)
            where bk_code = bank_bank
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

         /****************************** Add by SS - Micho - 20060606 B ******************************/
          /*
         set
            glt_entity when (not cash_book)
         with frame b.
         */
         /* SS - 20080424.1 - B */
          /*
         DISP
            glt_entity when (not cash_book)
         with frame b.
         */
         IF NEW_trans = YES THEN DISP corr-flag @ glt_correction WITH FRAME b .
         SET 
             glt_entity
             glt_correction
             WITH FRAME b.
         /* SS - 20080424.1 - E */
         /****************************** Add by SS - Micho - 20060606 B ******************************/

         /* TO DISPLAY THE SAME DESCRIPTION IN FRAME descx_frm */
         /* AS THAT DISPLAYED IN FRAME b                       */
         pause 0.

         /*V8-*/
         if cash_book
         then do:
            /* ACCOUNT DESCRIPTION */
            {pxmsg.i
               &MSGTEXT    = ac_desc
               &ERRORLEVEL = 1}
         end. /* IF cash_book */
         /*V8+*/

         display
            descx
         with frame descx_frm.

         set
            /****************************** Add by SS - Micho - 20060606 B ******************************/
            /*
              descx format "x(21)"
            */
              descx 
            /****************************** Add by SS - Micho - 20060606 B ******************************/
         with frame descx_frm.

         /****************************** Add by SS - Micho - 20060606 B ******************************/
          IF descx = '' THEN DO:
              /*{pxmsg.i &MSGNUM=9001 &ERRORLEVEL=3} */
                  
             MESSAGE "错误: 说明不能为空.请重新输入" . 
             PAUSE .
             NEXT-PROMPT descx WITH FRAME descx_frm .
             UNDO loope, RETRY loope.
          END.
         /****************************** Add by SS - Micho - 20060606 E ******************************/

         hide frame descx_frm.

         /* TO DISPLAY THE DESCRIPTION IN FRAME b    */
         /* AFTER ENTERING IT IN FRAME descx_frm     */
         display
            descx
         with frame b.

         /* Validate Transaction for Daybook */
         if daybooks-in-use
         then do:
            {gprun.i ""gldyver.p"" "(input type_parm,
                                     input """",
                                     input dft-daybook,
                                     input glt_entity,
                                     output daybook-error)"}
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
            fields(en_curr en_entity)
            where en_entity = glt_entity
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
               fields(glcd_entity glcd_gl_clsd glcd_per
                      glcd_year glcd_yr_clsd)
               where glcd_year = glc_year
               and glcd_entity = glt_entity
               no-lock break by glcd_per:

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
            end. /* FOR EACH glcd_det */
         end. /* IF type_parm = "YA" */

         loopcurr:
         do on error undo, retry:

            /****************************** Add by SS - Micho - 20060606 B ******************************/
             FIND FIRST ac_mstr WHERE ac_code = glt_acct NO-LOCK NO-ERROR.
             IF AVAIL ac_mstr THEN DO:
                 glt_curr = ac_curr .
             END.                    
            /****************************** Add by SS - Micho - 20060606 E ******************************/

            /* DOES NOT ALLOW BLANK CURR IF ENTITY CURR IS NOT BLANK */
            display
               glt_curr
            with frame b.

            /****************************** Add by SS - Micho - 20061019 B ******************************/
            /****************************** Add by SS - Micho - 20060606 B ******************************/
             /*
            /* FOR CASH BOOK, glt_curr = bk_curr */
            set
               glt_curr when (not cash_book)
            with frame b.

            if glt_curr = ""
            then
               glt_curr = en_curr.
               */
            set
               glt_curr when (not cash_book)
            with frame b.
            /****************************** Add by SS - Micho - 20060606 E ******************************/
            /****************************** Add by SS - Micho - 20061019 E ******************************/

              /*
            /* DOES NOT ALLOW BLANK CURR IF ENTITY CURR IS NOT BLANK */
            display
               glt_curr
            with frame b.  */

            /* VALIDATE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
               "(input glt_curr,
                 output mc-error-number)"}

            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}

               /****************************** Add by SS - Micho - 20060606 B ******************************/
                   /*
               next-prompt
                  glt_curr
               with frame b.
               */
              /****************************** Add by SS - Micho - 20060606 E ******************************/
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
               /****************************** Add by SS - Micho - 20060606 B ******************************/
                   /*
               next-prompt
                  glt_curr
               with frame b.
               */
               /****************************** Add by SS - Micho - 20060606 E ******************************/
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
                     /****************************** Add by SS - Micho - 20060606 B ******************************/
                     /*
                     next-prompt
                        glt_curr
                     with frame b.
                     */
                     /****************************** Add by SS - Micho - 20060606 E ******************************/
                     undo loopcurr, retry.
                  end. /* if mc-error-number <> 0 */

               end. /* ELSE DO: */

               assign
                  old_gltcurr = glt_curr
                  /* SET XAMT FORMAT BASED ON NEW GLTCURR_RNDMTHD */
                  xamt_gltc_fmt = xamt_old.

               {gprun.i ""gpcurfmt.p"" "(input-output xamt_gltc_fmt,
                                         input gltcurr_rndmthd)"}

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
                  if not valid_al
                  then do:
                     /* ALLOCATIONS MUST BE IN TRANSACTION CURRENCY */
                     {pxmsg.i &MSGNUM=3087 &ERRORLEVEL=3}

                     /****************************** Add by SS - Micho - 20060606 B ******************************/
                         /*
                     next-prompt
                        glt_curr
                     with frame b.
                     */
                     /****************************** Add by SS - Micho - 20060606 E ******************************/
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
                  /****************************** Add by SS - Micho - 20060606 B ******************************/
                      /*
                  next-prompt
                     glt_curr
                  with frame b.
                  */
                  /****************************** Add by SS - Micho - 20060606 E ******************************/
                  undo loopcurr, retry.
               end. /* IF glt_curr <> ac_curr and ... */

               assign
                  acct_curr = ac_curr
                  acct_code = ac_code.
            end. /* ELSE DO: */
         end. /* LOOPCURR */

         /* SET XAMT AND VALIDATE TO CURRENCY ROUNDING METHOD */
         updt_xamt:
         do on error undo, retry:
            set
               xamt
            with frame b.

            /****************************** Add by SS - Micho - 20060606 B ******************************/
             IF xamt = 0 THEN DO:
                 
                /*
                 MESSAGE "警告: 金额为0.是否继续?" VIEW-AS ALERT-BOX
                         QUESTION BUTTONS YES-NO UPDATE choice AS LOGICAL .
                 CASE choice :
                    WHEN FALSE THEN DO:
                         UNDO updt_xamt, RETRY .
                    END.
                 END CASE. */
                 MESSAGE "错误: 金额不允许为0.请重新输入" .
                 UNDO updt_xamt, RETRY .
             END.
            /****************************** Add by SS - Micho - 20060606 E ******************************/

            if (xamt <> 0)
            then do:
               {gprun.i ""gpcurval.p"" "(input xamt,
                                         input gltcurr_rndmthd,
                                         output retval)"}
               if retval <> 0
               then do:
                  next-prompt
                     xamt
                  with frame b.
                  undo updt_xamt, retry.
               end. /* IF retval <> 0 */
            end.  /* IF (xamt <> 0) */

            /* SS - 20080424.1 - B */
            FORM
                tt1_stat        LABEL "选定" FORMAT "x(4)"
                tt1_nbr         LABEL "大类" 
                tt1_nbr_desc        LABEL "说明"
                WITH FRAME sel_so WIDTH 80 TITLE COLOR normal (getframetitle("大类选择画面",42)) .

            EMPTY TEMP-TABLE tt1 .
            EMPTY TEMP-TABLE tt2 .
            FOR EACH usrw_wkfl NO-LOCK WHERE usrw_key1 = 'glsum' 
                AND usrw_key3 = "" :
                
                FOR EACH usrw NO-LOCK WHERE usrw.usrw_key1 = 'glsum' 
                    AND usrw.usrw_key4 = "D"
                    AND SUBSTRING(usrw.usrw_key2,1,1) = SUBSTRING(usrw_wkfl.usrw_key2,1,1) :

                    FOR EACH cr_mstr WHERE cr_code = usrw.usrw_key2 
                        AND cr_type = 'glsum_acct' NO-LOCK :
                    IF (glt_acct >= cr_code_beg AND glt_acct <= cr_code_end /*AND cr_code_beg <> "" AND cr_code_end <> ""*/ ) THEN DO:
                        FIND FIRST tt1 WHERE tt1_nbr = usrw_wkfl.usrw_key2 NO-LOCK NO-ERROR.
                        IF NOT AVAIL tt1 THEN DO:
                            CREATE tt1 .
                            ASSIGN
                                tt1_stat = "*" 
                                tt1_nbr  = usrw_wkfl.usrw_key2
                                tt1_nbr_desc = usrw_wkfl.usrw_charfld[1] 
                                .
                        END. /* IF NOT AVAIL tt1 THEN DO: */
                        CREATE tt2 .
                        ASSIGN
                            tt2_nbr = usrw_wkfl.usrw_key2
                            tt2_nbr_desc = usrw_wkfl.usrw_charfld[1] 
                            tt2_nbr1 = usrw.usrw_key2
                            tt2_nbr1_desc = usrw.usrw_charfld[1] 
                            tt2_ref = glt_ref
                            tt2_line = glt_line
                            .
                    END. /* IF (NOT AVAIL cr_mstr) */
                END. /* FOR EACH usrw */
            END.    

            v_tt1_flag = NO .
            FOR FIRST tt1 NO-LOCK:
            END.
            IF AVAIL tt1 THEN v_tt1_flag = YES .
                               
            IF v_tt1_flag = YES THEN DO:
                sw_block:
                DO ON ENDKEY UNDO,LEAVE :
                    HIDE FRAME b .
                    PUT SKIP(1) .
            
                    {swselect.i
                           &detfile      = tt1
                           &scroll-field = tt1_nbr
                           &framename    = "sel_so"
                           &framesize    = 15
                           &sel_on       = ""*""
                           &sel_off      = """"
                           &display1     = tt1_stat
                           &display2     = tt1_nbr
                           &display3     = tt1_nbr_desc
                           &exitlabel    = sw_block
                           &exit-flag    = first_sw_call
                           &record-id    = apwork-recno
                           }
    
                        HIDE FRAME sel_so .
                        LEAVE sw_block .
                END. /* sw_block */
    
                if keyfunction(lastkey) = "end-error" OR keyfunction(lastkey) = "endkey" THEN DO :
                    VIEW FRAME a.
                    UNDO ,RETRY  .
                END. 
    
                FOR EACH tt1 ,
                    EACH tt2 WHERE tt2_nbr = tt1_nbr :
                    FIND FIRST usrw_wkfl WHERE usrw_key1 = "glsum1"
                        AND usrw_key2 = glt_ref + STRING(glt_line) + tt2_nbr + tt2_nbr1 NO-LOCK NO-ERROR.
                    IF NOT AVAIL usrw_wkfl AND tt1_stat = "" THEN DO:
                        DELETE tt2 .
                    END.
                    ELSE IF AVAIL usrw_wkfl THEN DO:
                        ASSIGN
                            tt2_amt = usrw_decfld[1] 
                            .
                    END.
                END.
    
                v_tt2_flag = NO .
                FOR FIRST tt2 NO-LOCK :
                END.
                IF AVAIL tt2 THEN v_tt2_flag = YES .

                IF v_tt2_flag = YES THEN DO:
                    DO ON ERROR UNDO,RETRY :
                        FORM
                            tt2_nbr1        LABEL "明细项"
                            tt2_nbr1_desc   LABEL "明细项说明" 
                            tt2_amt         LABEL "金额"
                        with frame w scroll 10 down NO-VALIDATE NO-ATTR-SPACE TITLE "明细项金额维护画面" WIDTH 80 three-d. 
            
                        PAUSE 0.
                        VIEW FRAME w .
                        PAUSE BEFORE-HIDE.
            
                        {xxsjsoiswindo1u.i
                            tt2
                            "tt2_nbr1
                             tt2_nbr1_desc
                             tt2_amt
                             "
                             "tt2_nbr1"
                             "use-index tt2nbr1" 
                             yes
                             " "
                             " "
                             "
                             find tt2 where recid(tt2) = recidarray[frame-line(w)].
                             "
                             }
            
                        IF keyfunction(lastkey) = "RETURN" then do:
                           find tt2 where recid(tt2) = recidarray[frame-line(w)].
                           UPDATE tt2_amt WITH FRAME w .
                        END. /*IF keyfunction(lastkey) = "RETURN" then do:*/
            
                        {windo1u1.i tt2_nbr1}
            
                        vflag = NO.
                        MESSAGE "所有信息是否正确?" UPDATE vflag .
                        IF NOT vflag THEN DO:
                            UNDO ,RETRY .
                        END.
                        ELSE DO:
                            vflag1 = NO.
                            EMPTY TEMP-TABLE tt3 .
                            FOR EACH tt2 BREAK BY SUBSTRING(tt2_nbr1,1,1) :
                                ACCUMULATE tt2_amt (TOTAL BY SUBSTRING(tt2_nbr1,1,1)) .
                                IF LAST-OF(SUBSTRING(tt2_nbr1,1,1)) THEN DO:
                                    IF (ACCUMULATE TOTAL BY SUBSTRING(tt2_nbr1,1,1) tt2_amt) <> 0 THEN DO:
                                        IF (ACCUMULATE TOTAL BY SUBSTRING(tt2_nbr1,1,1) tt2_amt) <> xamt THEN DO:
                                            vflag1 = YES .
                                            MESSAGE "大类" + tt2_nbr + "的合计金额不等于: " + STRING(xamt) VIEW-AS ALERT-BOX ERROR TITLE "错误信息".
                                            LEAVE .
                                        END.
                                        ELSE DO:
                                            CREATE tt3 .
                                            ASSIGN
                                                tt3_nbr = SUBSTRING(tt2_nbr1,1,1)
                                                .
                                        END.
                                    END.
                                END.         
                            END.
                            IF vflag1 = YES THEN do:
                                UNDO,RETRY.
                            END. 
                        END.
                    END.
        
                    CLEAR FRAME w ALL NO-PAUSE.
                    HIDE FRAME w.
                END.
            END.
            /* SS - 20080424.1 - E */

         end. /* UPDT_XAMT */
                                       
         /* SS - 20080424.1 - B */
         FIND FIRST tt1 NO-LOCK NO-ERROR.
         IF AVAIL tt1 THEN DO:
             FOR EACH tt2,
                 EACH tt3 WHERE SUBSTRING(tt2_nbr,1,1) = tt3_nbr :
                 FIND FIRST usrw_wkfl WHERE usrw_key1 = 'glsum1' 
                     AND usrw_key2 = glt_ref + STRING(glt_line) + tt2_nbr + tt2_nbr1 NO-ERROR.
                 IF NOT AVAIL usrw_wkfl AND tt2_amt <> 0 THEN DO:
                     CREATE usrw_wkfl .
                     ASSIGN
                         usrw_key1 = 'glsum1'
                         usrw_key2 = glt_ref + STRING(glt_line) + tt2_nbr + tt2_nbr1
                         usrw_key3 = glt_ref
                         usrw_key4 = string(glt_line)
                         usrw_key5 = tt2_nbr
                         usrw_key6 = tt2_nbr1
                         usrw_decfld[1] = tt2_amt
                         .
                 END.
                 ELSE IF tt2_amt <> 0 THEN DO:
                     ASSIGN
                         usrw_decfld[1] = tt2_amt.
                 END.
             END.
         END.
         /* SS - 20080424.1 - E */

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

               /* EXCHANGE RATE ENTRY LOOP */

               loopf:
               do on error undo, retry:

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

               end.  /* LOOPF */

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
            fields(en_curr en_entity)
            where en_entity = glt_entity
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
