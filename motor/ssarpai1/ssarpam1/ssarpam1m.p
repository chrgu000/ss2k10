/* arpamtm.p - AR PAYMENT MAINTENANCE                                       */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.71.1.23 $                                                            */
/*V8:ConvertMode=Maintenance                                                */
/* REVISION: 6.0      LAST MODIFIED: 08/23/90   by: MLB *D055*              */
/*                                   05/02/91   by: MLV *D595*              */
/*                                   06/06/91   by: MLV *D674*              */
/*                                   06/17/91   by: afs *D709*   (rev only) */
/*                                   08/11/91   by: afs *D817*   (rev only) */
/*                                   09/19/91   by: MLV *D861*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 09/17/91   by: MLV *F015*              */
/*                                   11/07/91   by: MLV *F031*              */
/*                                   01/02/92   by: MLV *F081*              */
/*                                   01/21/92   by: MLV *F090*              */
/*                                   01/29/92   by: MLV *F113*              */
/*                                   03/17/92   by: JJS *F294*              */
/*                                   03/25/92   by: jms *F332*   (rev only) */
/*                                   05/26/92   by: MLV *F513*              */
/*                                   06/24/92   by: JJS *F681*              */
/* REVISION: 7.3      LAST MODIFIED: 07/23/92   by: mpp *G003*              */
/*                                   10/20/92   by: jms *G210*              */
/*                                   11/10/92   by: mpp *G308*              */
/*                                   11/11/92   by: mpp *G310*              */
/*                                   11/18/92   by: jjs *G332*   (rev only) */
/*                                   12/02/92   by: mpp *G385*              */
/*                                   12/29/92   by: mpp *G487*              */
/*                                   12/04/92   by: mpp *G476*              */
/*                                   01/20/93   by: mpp *G571*              */
/*                                   03/10/93   by: jms *G797*   (rev only) */
/*                                   03/10/93   by: bcm *G796*   (rev only) */
/*                                   03/10/93   by: jms *G800*              */
/*                                   03/23/93   by: jjs *G862*              */
/*                                   04/19/93   by: jms *G974*              */
/*                                   04/20/93   by: bcm *G997*              */
/*                                   04/21/93   by: bcm *GA00*              */
/*                                   04/23/93   by: jms *GA27*   (rev only) */
/*                                   06/07/93   by: jms *GB80*              */
/* REVISION: 7.3      LAST MODIFIED: 06/29/93   by: pcd *GC86*   (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 07/10/93   by: pcd *H027*              */
/*                                   08/08/93   by: pcd *H039*              */
/*                                   08/08/93   by: wep *H105*              */
/*                                   09/15/93   by: pcd *H115*              */
/*                                   09/22/93   by: bcm *H133*   (rev only) */
/*                                   10/22/93   by: jms *H191*   (rev only) */
/*                                   02/10/94   by: srk *GI33*              */
/*                                   07/25/94   by: bcm *H458*              */
/*                                   09/11/94   by: slm *GM15*              */
/*                                   09/15/94   by: pmf *FR41*              */
/*                                   09/30/94   by: ljm *H544*              */
/*                                   10/18/94   by: str *FS46*              */
/*                                   11/06/94   by: ame *GO18*              */
/*                                   01/12/95   by: srk *G0B8*              */
/*                                   01/18/95   by: str *H09S*              */
/*                                   02/21/95   by: wjk *F0JQ*              */
/*                                   03/01/95   by: str *F0L1*              */
/*                                   04/24/95   by: wjk *H0CS*              */
/*                                   06/22/95   by: wjk *H0F1*              */
/*                                   08/30/95   by: wjk *F0TX*              */
/*                                   11/29/95   by: mys *G1DZ*              */
/*                                   12/12/95   by: mys *G1G7*              */
/* REVISION: 8.5      LAST MODIFIED: 01/13/96   by: ccc *J053*              */
/*                                   06/08/96   by: wjk *G1XC*              */
/* REVISION: 8.5      LAST MODIFIED: 07/15/96   by: taf *J0Z5*              */
/* REVISION: 8.6      LAST MODIFIED: 07/15/96   by: BJL *K001*              */
/* REVISION: 8.6      LAST MODIFIED: 07/29/96   by: taf *J101*              */
/* REVISION: 8.6      LAST MODIFIED: 11/08/96   by: rxm *H0P0*              */
/*       ORACLE PERFORMANCE FIX      11/18/96   by: rxm *H0P7*              */
/* REVISION: 8.6      LAST MODIFIED: 01/07/97   by: rxm *H0Q2*              */
/* REVISION: 8.6      LAST MODIFIED: 01/07/97   by: bjl *K01S*              */
/* REVISION: 8.6      LAST MODIFIED: 01/23/97   by: bkm *H0R1*              */
/* REVISION: 8.6      LAST MODIFIED: 01/28/97   by: rxm *J1FR*              */
/*                                   02/17/97   by: *K01R* E. Hughart       */
/* REVISION: 8.6      LAST MODIFIED: 09/10/97   BY: *J20H* Samir Bavkar     */
/* REVISION: 8.6      LAST MODIFIED: 12/15/97   BY: *H1HG* Samir Bavkar     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     MODIFIED AT:   04/07/98   BY: rap  *L00K*             */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton     */
/* Old ECO marker removed, but no ECO header exists *F001*                  */
/* Old ECO marker removed, but no ECO header exists *H09T*                  */
/* REVISION: 8.6E     LAST MODIFIED: 06/08/98   BY: *L01K* Jaydeep Parikh   */
/* REVISION: 8.6E     LAST MODIFIED: 10/09/98   BY: *J31C* Abbas Hirkani    */
/* REVISION: 8.6E     LAST MODIFIED: 11/27/98   BY: *J35P* Sandesh Mahagaokar */
/* REVISION: 9.0      LAST MODIFIED: 01/19/99   BY: *J38N* Mugdha Tambe       */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/24/99   BY: *K1ZV* Narender Singh     */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Paul Johnson       */
/* REVISION: 9.0      LAST MODIFIED: 07/28/99   BY: *M0CX* Paul Dreslinski    */
/* REVISION: 9.0      LAST MODIFIED: 08/11/99   BY: *J3KD* Ranjit Jain        */
/* REVISION: 9.1      LAST MODIFIED: 08/14/99   BY: *N01N* Brenda Milton      */
/* REVISION: 9.1      LAST MODIFIED: 10/07/99   BY: *J3M2* Ranjit Jain        */
/* REVISION: 9.1      LAST MODIFIED: 01/19/00   BY: *N077* Vijaya Pakala      */
/* REVISION: 9.1      LAST MODIFIED: 02/28/00   BY: *J3P6* Vihang Talwalkar   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 04/11/00   BY: *L0V6* Rajesh Lokre       */
/* REVISION: 9.1      LAST MODIFIED: 04/17/00   BY: *L0T6* Abbas Hirkani      */
/* REVISION: 9.1      LAST MODIFIED: 06/12/00   BY: *L0Z0* Vihang Talwalkar   */
/* REVISION: 9.1      LAST MODIFIED: 06/23/00   BY: *L0ZQ* Veena Lad          */
/* REVISION: 9.1      LAST MODIFIED: 08/08/00   BY: *M0QT* Rajesh Lokre       */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* REVISION: 9.1      LAST MODIFIED: 09/27/00   BY: *L14P* Veena Lad          */
/* REVISION: 9.1      LAST MODIFIED: 11/11/00   BY: *M0W2* Rajesh Lokre       */
/* REVISION: 9.1      LAST MODIFIED: 12/06/00   BY: *M0X6* Vinod Nair         */
/* REVISION: 9.1      LAST MODIFIED: 01/03/01   BY: *M0Y4* Jose Alex          */
/* REVISION: 9.1      LAST MODIFIED: 01/29/01   BY: *M108* Rajesh Lokre       */
/* REVISION: 9.1      LAST MODIFIED: 10/19/00   BY: *N0WW* BalbeerS Rajput    */
/* REVISION: 9.1      LAST MODIFIED: 02/23/01   BY: *L189* Seema Tyagi        */
/* REVISION: 9.0      LAST MODIFIED: 02/20/01   BY: *N0X7* Ed van de Gevel    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.59      BY: Alok Thacker        DATE: 06/12/01 ECO: *M18Y*      */
/* Revision: 1.60      BY: Vinod Nair          DATE: 06/20/01 ECO: *M1BG*     */
/* Revision: 1.61      BY: Ed van de Gevel     DATE: 06/29/01 ECO: *N0ZX*     */
/* Revision: 1.62      BY: Alok Thacker        DATE: 07/19/01 ECO: *M169*     */
/* Revision: 1.63      BY: Seema Tyagi         DATE: 08/10/01 ECO: *M1H7*     */
/* Revision: 1.66      BY: Mamata Samant       DATE: 01/14/02 ECO: *M1Q5*     */
/* Revision: 1.67      BY: Manjusha Inglay     DATE: 07/29/02 ECO: *N1P4*     */
/* Revision: 1.68      BY: Hareesh V           DATE: 09/12/02 ECO: *M209*     */
/* Revision: 1.69      BY: Hareesh V           DATE: 11/27/02 ECO: *M21F*     */
/* Revision: 1.70      BY: Orawan S.           DATE: 05/20/03 ECO: *P0RX*     */
/* Revision: 1.71.1.1  BY: Dipesh Bector      DATE: 05/23/03 ECO: *N2FQ*      */
/* Revision: 1.71.1.3  BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B*      */
/* Revision: 1.71.1.4  BY: Rajinder Kamra     DATE: 07/11/03 ECO: *Q00Q*      */
/* Revision: 1.71.1.5  BY: Dipesh Bector      DATE: 07/31/03 ECO: *P0YW*      */
/* Revision: 1.71.1.6  BY: Rajiv Ramaiah      DATE: 08/02/03 ECO: *P0TQ*      */
/* Revision: 1.71.1.7  BY: K Paneesh          DATE: 08/08/03 ECO: *N2JT*      */
/* Revision: 1.71.1.8  BY: Marcin Serwata     DATE: 11/17/03 ECO: *P18V*      */
/* Revision: 1.71.1.9  BY: Preeti Sattur      DATE: 01/15/04 ECO: *N2P6*      */
/* Revision: 1.71.1.10 BY: Swati Sharma       DATE: 01/15/04 ECO: *P21H*     */
/* Revision: 1.71.1.13 BY: Orawan S.          DATE: 05/17/04 ECO: *P21R*     */
/* Revision: 1.71.1.14  BY: Ed van de Gevel DATE: 10/13/04 ECO: *P207*       */
/* Revision: 1.71.1.15  BY: Pankaj Goswami   DATE: 10/13/04 ECO: *P2BJ*      */
/* Revision: 1.71.1.16  BY: Pankaj Goswami   DATE: 01/25/05 ECO: *P358*      */
/* Revision: 1.71.1.18  BY: Anitha Gopal     DATE: 02/25/05 ECO: *P3B0*      */
/* Revision: 1.71.1.20  BY: Hitendra P V     DATE: 07/12/05 ECO: *P3SP*      */
/* Revision: 1.71.1.21  BY: Sachin Deshmukh  DATE: 08/08/05 ECO: *P3X5*      */
/* Revision: 1.71.1.22  BY: Nishit V         DATE: 09/21/05 ECO: *P420*      */
/* $Revision: 1.71.1.23 $        BY: Shivaraman V.    DATE: 10/28/05 ECO: *P46T* */
/* $Revision: 1.71.1.23 $        BY: Bill Jiang    DATE: 08/17/07 ECO: *SS - 20070817.1* */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdeclre.i}
{cxcustom.i "ARPAMTM.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{pxpgmmgr.i}
/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE arpamtm_p_1 "Check Control"
/* MaxLen: Comment: */

&SCOPED-DEFINE arpamtm_p_2 "From"
/* MaxLen: Comment: */

&SCOPED-DEFINE arpamtm_p_3 "Total"
/* MaxLen: Comment: */

&SCOPED-DEFINE arpamtm_p_4 "Unapplied"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{gldydef.i}
{gldynrm.i}

{etvar.i}

define new shared variable rndmthd        like rnd_rnd_mthd.
define new shared variable oldcurr        like ar_curr.
define new shared variable ar_amt_old     as character.
define new shared variable ar_amt_fmt     as character.
define new shared variable apply2_rndmthd like rnd_rnd_mthd.
define new shared variable old_doccurr    like ar_curr.

define new shared variable ard_recno    as recid.
define new shared variable ar_recno     as recid.
define new shared variable cm_recno     as recid.
define new shared variable undo_mtg     like mfc_logical.
define new shared variable jrnl         like glt_ref.
define new shared variable batch        like ar_batch.
define new shared variable old_amt      like ar_amt.
define new shared variable base_amt     like ar_amt.
define new shared variable disc_amt     like ar_amt.
define new shared variable curr_amt     like ar_amt.
define new shared variable gain_amt     like ar_amt.
define new shared variable bactrl       like ba_ctrl.
define new shared variable cash_curr    like gl_base_curr.
define new shared variable desc1        like bk_desc.
define new shared variable gltline      like glt_line.
define new shared variable gl_use_curr  like glt_curr.
define new shared variable curr_disc    like glt_curr_amt.
define new shared variable batch_total  like ar_amt
   label {&arpamtm_p_3}.
define new shared variable unappamt     like ar_amt
   label {&arpamtm_p_4}.
define new shared variable artotal      like ar_amt
   label {&arpamtm_p_1}.
define new shared variable auto_doc_start like ar_nbr format "X(8)"
   label {&arpamtm_p_2}.
define new shared variable auto_doc_end like ar_nbr format "X(8)".
define new shared variable base_det_amt like glt_amt.
define new shared variable autocpl_code like mfc_logical.
define new shared variable no_open_doc  like mfc_logical initial false.
define new shared variable ba_recno     as recid.
define new shared variable ref          as character format "X(14)".

define shared variable cash_book    like mfc_logical.
define shared variable bank_ctrl    like ap_amt.
define shared variable bank_total   like ap_amt.
define shared variable bank_batch   like ba_batch.
define shared variable bank_bank    like ck_bank.
define shared variable b_batch      like ba_batch.
define shared variable arjrnl       like glt_ref.
define shared variable arbatch      like ar_batch.
define shared variable arnbr        like ar_nbr.
define shared variable bank_ex_rate like ar_ex_rate.
define shared variable bank_ex_rate2    like ar_ex_rate2.
define shared variable bank_ex_ratetype like cb_ex_ratetype.
define shared variable bank_exru_seq    like cb_exru_seq.
define shared variable bank_curr    like bk_curr.
define shared variable undo_all     like mfc_logical.
define shared variable new_line     like mfc_logical.
{&ARPAMTM-P-TAG53}
define shared variable del_cb       like mfc_logical.
{&ARPAMTM-P-TAG54}
define shared variable l_batch_err  like mfc_logical no-undo.

define variable del-yn         like mfc_logical initial no.
{&ARPAMTM-P-TAG1}
define variable bank           like bk_code.
{&ARPAMTM-P-TAG2}
define variable old_effdate    like ar_effdate.
define variable first_in_batch like mfc_logical.
define variable auto_apply     like mfc_logical initial no.
define variable yn             like mfc_logical.
define variable valid_acct     like mfc_logical.
{&ARPAMTM-P-TAG3}
define variable action         as character
   initial "2" format "x(1)".
{&ARPAMTM-P-TAG4}
define variable aramt          like ar_amt.
define variable ctrldiff       like ar_amt.
define variable firstpass      like mfc_logical.
define variable retval         as integer.
define variable tempdate       like ar_date.
define variable l_daybook      like ar_dy_code  no-undo.
define variable l_effdate      like ar_effdate  no-undo.
define variable l_ar_nbr       like ar_nbr      no-undo.
define variable fixed_rate     like mfc_logical no-undo.
define variable is_transparent like mfc_logical no-undo.

/* VAR bank_updated KEEPS TRACK OF WHETHER THE BANK WAS CHANGED WHEN */
/* THE USER IS RE-PROMPTED FOR BANK CODE (SEE update bank STATEMENT) */
define variable bank_updated   like mfc_logical no-undo.

/* REMOVED NO-UNDO SO THAT cust_bal IS UNDONE AUTOMATICALLY WHEN */
/* USER TRIES BUT DOES NOT MODIFY THE PAYMENT WITHOUT COMING OUT OF */
/* PAYMENT APPLICATION MAINTENANCE FRAME */
define new shared variable cust_bal    like cm_balance.

/* VARIABLE L_BANK_ENTERED IS SET TO TRUE WHENEVER BANK IS CHANGED */
/* VARIABLE L_BANK_ACCT IS SET TO TRUE WHENEVER ACCOUNT IS CHANGED */
define variable l_bank_entered like mfc_logical no-undo.
define variable l_acct_entered like mfc_logical no-undo.
define variable l_new_armstr   like mfc_logical no-undo.
define variable l_entity_ok    like mfc_logical no-undo.
{&ARPAMTM-P-TAG65}

{&ARPAMTM-P-TAG45}
define buffer armstr2     for ar_mstr.
define buffer armstr_temp for ar_mstr.

define new shared frame a.
define new shared frame b.

define input parameter p_line like cb_line.

define variable l_ex_rate  like ar_ex_rate  no-undo.
define variable l_ex_rate2 like ar_ex_rate2 no-undo.

/* DEFINED TEMP TABLE FOR GETTING THE RECORDS ADDED IN ARPAMTC.P WITH INDEX */
/* SAME AS PRIMARY UNIQUE INDEX OF ard_det.                                 */
{ardydef.i &type="new shared"}

/* GET ENTITY SECURITY INFORMATION */
{glsec.i}

/* DEFINE VARIABLES FOR GPGLEF.P (GL PERIOD VALIDATION) */
{gpglefdf.i}

/* FRAME A DEFINITION */
{arpafma.i}

/* FRAME B DEFINITION */
/* SS - 20070817.1 - B */
/*
{arpafmb.i}
*/
{ssarpam1fmb.i}
/* SS - 20070817.1 - E */

{&ARPAMTM-P-TAG5}

if cash_book
then
   jrnl = arjrnl.

{&ARPAMTM-P-TAG6}

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock no-error.
{&ARPAMTM-P-TAG40}

{gprun.i ""gldydft.p"" "(input  ""AR"",
                         input  ""P"",
                         input  gl_entity,
                         output dft-daybook,
                         output daybook-desc)"}
{&ARPAMTM-P-TAG41}

/* INITIALIZE _OLD FORMAT VARIABLES */
ar_amt_old  = ar_amt:format.

mainloop:
repeat with frame a:
   do transaction:
      view frame a.
      status input.

      if not cash_book {&ARPAMTM-P-TAG55} then do:
         assign
            bactrl = 0
            batch = "".
         set
            batch
         with frame a.
         if batch <> "" then do:
         /* MODIFIED CONDITION TO INCLUDE CHECK FOR   */
         /* MULTIPLE ar_type IN SAME BATCH            */
            if not can-find(first ar_mstr
                             where ar_mstr.ar_domain = global_domain and
                             ar_batch = batch
                            and   ar_type  = "P")
            then
               {&ARPAMTM-P-TAG59}
               if can-find(first ar_mstr
                            where ar_mstr.ar_domain = global_domain and
                            ar_batch = batch
                           and   ar_type  <> "P")
               then do:

                  /* MSG: BATCH ALREADY ASSIGNED */
                  {pxmsg.i &MSGNUM=1182 &ERRORLEVEL=3}
                  if not batchrun then
                     do on endkey undo, leave:
                        pause.
                     end.
                  next-prompt batch with frame a.
                  undo, retry.
               end. /* IF CAN-FIND (FIRST ar_mstr ... */
               {&ARPAMTM-P-TAG60}

            if can-find(first ba_mstr
               where ba_mstr.ba_domain = global_domain
               and   ba_batch          = batch
               and   ba_module         = "SO")
            then do:
               /* Batch Number Already Assigned. Please re-enter */
               {pxmsg.i &MSGNUM=1182 &ERRORLEVEL=3}
               pause.
               next-prompt batch with frame a.
               undo, retry.
            end. /* IF CAN-FIND (FIRST ba_mstr ... */


            find ba_mstr  where ba_mstr.ba_domain = global_domain and  ba_batch
            = batch and ba_module = "AR"
               exclusive-lock no-error.
            if available ba_mstr then do:
               assign
                  ba_recno = recid(ba_mstr)
                  bactrl = ba_ctrl
                  /* INSURE BATCH TOTAL = SUM OF MEMOS
                     (should be unnecessary) */
                  ba_total = 0.
               for each ar_mstr  where ar_mstr.ar_domain = global_domain and
               ar_batch = batch no-lock:
                  ba_total = ba_total - ar_amt.
               end.
               display
                  ba_total @ batch_total
               with frame a.
               batch_total = ba_total.
            end.
            else
               display
                  0 @ batch_total
               with frame a.
         end.
         else
            display
               0 @ bactrl
               0 @ batch_total
            with frame a.

         update
            bactrl
         with frame a.

         if available ba_mstr
         then ba_ctrl = bactrl.
         first_in_batch = yes.
      end. /*not cash_book*/
      else do:
         batch = bank_batch.
         bactrl = bank_ctrl.
         for each ar_mstr  where ar_mstr.ar_domain = global_domain and
         ar_batch = batch and
               ar_check = arnbr no-lock:
            batch_total = batch_total - ar_amt.
         end.
         display
            batch
            bactrl
            batch_total
         with frame a.
      end.
   end.
   /* TRANSACTION */

   {&ARPAMTM-P-TAG46}
   {&ARPAMTM-P-TAG7}
   loopb:
   repeat with frame b:

      clear frame b.
      firstpass = true.

      assign
         {&ARPAMTM-P-TAG66}
         l_bank_entered = no
         bank_updated   = no
         l_acct_entered = no.

      /* GET PAYMENT KEY DATA */
      undo_mtg = true.
      /* SS - 20070817.1 - B */
      /*
      {gprun.i ""arpamtg.p""}
      */
      {gprun.i ""ssarpam1g.p""}
      /* SS - 20070817.1 - E */
      {&ARPAMTM-P-TAG8}
      if undo_mtg then undo, leave.
      {&ARPAMTM-P-TAG9}

      if not cash_book
      and (jrnl = "" or
           can-find(first arc_ctrl
                       where arc_ctrl.arc_domain = global_domain
                       and   arc_sum_lvl         = 3))
      then do transaction:

         /* GET NEXT JOURNAL REFERENCE NUMBER */
         {mfnctrl.i "arc_ctrl.arc_domain = global_domain" "arc_ctrl.arc_domain"
          "glt_det.glt_domain = global_domain" arc_ctrl arc_jrnl glt_det glt_ref
          jrnl}
      end. /* TRANSACTION */

      if not cash_book then
         find cm_mstr where recid (cm_mstr) = cm_recno no-lock no-error.

      /* REVERTING ALL LOGIC OF LOT6. JOINING THE TRANSACTION BLOCKS BACK */
      /* TO SINGLE BLOCK.                                                 */
      do transaction:
         loopc:
         do while true:
            /*ADD/MODIFY/DELETE*/
            find ar_mstr  where ar_mstr.ar_domain = global_domain and  ar_nbr =
            string(input ar_bill, "X(8)" )
                                      + string(arnbr)
               exclusive-lock no-error.
            {&ARPAMTM-P-TAG10}
            if not available ar_mstr then do: /* abc */
               create ar_mstr. ar_mstr.ar_domain = global_domain.
               assign
                  ar_nbr      = string(input ar_bill, "X(8)" )
                              + string(arnbr) ar_bill
                  ar_batch    = batch
                  ar_date     = today
                  ar_effdate  = today
                  ar_dy_code  = dft-daybook
                  ar_type     = "P"
                  ar_cust     = input ar_bill
                  ar_check    = arnbr
                  ar_ex_rate2 = 1
                  ar_ex_rate  = 1.
               {&ARPAMTM-P-TAG11}
               if recid(ar_mstr) = -1 then .

               if cash_book then
                  ar_curr    = bank_curr.
               else
                  ar_curr    = cm_curr.
               {&ARPAMTM-P-TAG12}

               if (oldcurr <> ar_curr) or (oldcurr = "") then do:

                  /* GET ROUNDING METHOD FROM CURRENCY MASTER */
                  {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                     "(input ar_curr,
                       output rndmthd,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                     next.
                  end.

                  ar_amt_fmt = ar_amt_old.
                  {gprun.i ""gpcurfmt.p""
                     "(input-output ar_amt_fmt,
                       input rndmthd)"}
                  assign
                     ar_amt:format = ar_amt_fmt
                     artotal:format = ar_amt_fmt
                     oldcurr = ar_curr.
               end.

               if not cash_book then
                  artotal    = 0.
               else
                  artotal = bank_ctrl.

               assign
                  ar_ex_rate = 1
                  ar_ex_rate2 = 1.

               if available gl_ctrl then
                  assign
                     ar_acct      = gl_cs_acct
                     ar_sub       = gl_cs_sub
                     ar_cc        = gl_cs_cc
                     ar_disc_acct = gl_term_acct
                     ar_disc_sub  = gl_term_sub
                     ar_disc_cc   = gl_term_cc
                     ar_entity    = gl_entity.
               if cash_book then bank = bank_bank.
               {&ARPAMTM-P-TAG13}
               else bank = "".

               if can-find(first cu_mstr where cu_curr >= "")
                  and not cash_book then
                  find first bk_mstr  where bk_mstr.bk_domain = global_domain
                  and  bk_curr = ar_curr
                  no-lock no-error.
               else
               if cash_book then
                  find bk_mstr  where bk_mstr.bk_domain = global_domain and
                  bk_code = bank
                  no-lock no-error.
               {&ARPAMTM-P-TAG14}
               if available bk_mstr then do:
                  assign
                     bank        = bk_code
                     /* VARIANCE ACCOUNT AND CC TO BE RETRIEVED FROM */
                     /* CU_MSTR (SEE BELOW)*/
                     ar_acct     = bk_acct
                     ar_sub      = bk_sub
                     ar_cc       = bk_cc
                     ar_entity   = bk_entity
                     desc1       = bk_desc.
                  display
                     desc1
                  with frame b.
               end.
               {&ARPAMTM-P-TAG15}
               /* VARIANCE ACCOUNT AND CC FROM ACDF_MSTR */
               /* GAIN ACCT AND CC ASSIGNED TEMPORARILY */
               /* ACTUAL ACCT AND CC ASSIGNED IN ARARGL2.P */

               {gprunp.i "mcpl" "p" "get-gain-loss-accounts"
                  " (input true,
                     input ar_curr,
                     input true,
                     input false,
                     output ar_var_acct,
                     output ar_var_sub,
                     output ar_var_cc)"}

               display
                  ar_amt
                  ar_type
                  ar_batch.
            end.
            else if firstpass then do: /* MODIFY EXISTING PAYMENT */
               if ar_ex_rate = 0 then ar_ex_rate = 1.
               if ar_ex_rate2 = 0 then ar_ex_rate2 = 1.
               assign
                  artotal = - ar_amt
                  old_effdate = ar_effdate
                  bank = ar_bank.
               {&ARPAMTM-P-TAG16}
               if bank = "" and ar_curr <> base_curr then
                  find first bk_mstr  where bk_mstr.bk_domain = global_domain
                  and  bk_acct = ar_acct
                  and bk_sub = ar_sub
                  and bk_cc = ar_cc no-lock no-error.
               else
                  find first bk_mstr  where bk_mstr.bk_domain = global_domain
                  and  bk_code = ar_bank
                  no-lock no-error.
               {&ARPAMTM-P-TAG17}
               if available bk_mstr then
                  assign
                     bank = bk_code
                     desc1 = bk_desc.
               else desc1 = "  ".

               if (oldcurr <> ar_curr) or (oldcurr = "") then do:

                  /* GET ROUNDING METHOD FROM CURRENCY MASTER */
                  {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                     "(input ar_curr,
                       output rndmthd,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                     next.
                  end.
                  ar_amt_fmt = ar_amt_old.
                  {gprun.i ""gpcurfmt.p""
                     "(input-output ar_amt_fmt,
                       input rndmthd)"}
                  assign
                     ar_amt:format = ar_amt_fmt
                     artotal:format = ar_amt_fmt
                     oldcurr = ar_curr.
               end.

               /*SET AUTO APPLY TO FALSE IF ALREADY USED (UPDATE MODE)*/
               auto_apply = false.

               {&ARPAMTM-P-TAG47}
               display
                  artotal
                  (- ar_amt) @ ar_amt
                  ar_bill
                  ar_date
                  ar_effdate
                  ar_dy_code
                  ar_type
                  ar_acct
                  ar_sub
                  ar_cc
                  ar_entity
                  ar_curr
                  bank
                  desc1
                  ar_po
                  ar_batch
                  {&ARPAMTM-P-TAG48}
                  auto_apply
                  /* SS - 20070817.1 - B */
                  ar_user2
                  /* SS - 20070817.1 - E */
                  .

               {&ARPAMTM-P-TAG49}
               /* CHECK THAT RECORD IS A PAYMENT */
               if ar_type <> "P" then do:
                  {pxmsg.i &MSGNUM=1155 &ERRORLEVEL=3}
                  undo, retry.
               end.
               /* CHECK THAT PAYMENT IS IN BATCH */
               if batch <> "" and batch <> ar_batch then do:
                  /* Not in this batch*/
                  {pxmsg.i &MSGNUM=1152 &ERRORLEVEL=3}
                  undo, retry.
               end.
               /*CHECK PAYMENT NOT CREATED WITH CASH BOOK*/
               if not cash_book then do:
                  find ba_mstr  where ba_mstr.ba_domain = global_domain and
                  ba_batch = ar_batch
                     and ba_module = "CM" no-lock no-error.
                  if available ba_mstr then do:
                     find cb_mstr  where cb_mstr.cb_domain = global_domain and
                     cb_batch = ba_batch
                        and cb_ref = ar_check no-lock no-error.
                     if available cb_mstr then do:
                        {pxmsg.i &MSGNUM=58 &ERRORLEVEL=3}
                        /*Created with cash_book - mod not allowed*/
                        undo, retry.
                     end.
                  end.
               end.
               {&ARPAMTM-P-TAG18}
            end.  /* else-abc */
            l_new_armstr = if new ar_mstr
                           then
                              yes
                           else
                              no.

            if not cash_book then do:

               /*PLACE EXCLUSIVE LOCK ON BA_MSTR FOR*/
               /*UPDATE OF CONTROL TOTALS           */
               find ba_mstr  where ba_mstr.ba_domain = global_domain and
               ba_batch = batch and ba_module = "AR"
               exclusive-lock no-error.

               if available ba_mstr then
                  display
                     ba_batch @ batch
                     ba_ctrl @ bactrl
                     batch_total
                  with frame a.
            end. /*not cash_book*/

            {&ARPAMTM-P-TAG50}
            /* BACKOUT BATCH TOTALS */
            assign
               ar_amt          = - ar_amt
               ar_applied      = - ar_applied
               ar_base_amt     = - ar_base_amt
               ar_base_applied = - ar_base_applied.
            if not cash_book and firstpass then
               artotal     = ar_amt.
            batch_total = batch_total - ar_amt.
            display
               artotal
               ar_batch
               ar_dy_code.
            /* SAVE CURRENT OPEN AMOUNT */
            old_amt = ar_amt.
            for each ard_det  where ard_det.ard_domain = global_domain and
            ard_nbr = ar_nbr and ard_type <> "N":
               old_amt = old_amt + ard_disc.
            end.
            find first ard_det  where ard_det.ard_domain = global_domain and
            ard_nbr = ar_nbr
               and ard_ref = ""
               and ard_type = "N" no-lock no-error.
            if available ard_det then old_amt = old_amt - ard_amt.
            recno = recid(ar_mstr).
            del-yn = no.
            display
               ar_type.
            ststatus = stline[2].
            status input ststatus.
            display
               artotal
               ar_date
               ar_effdate
               ar_dy_code
               ar_curr
               bank
               ar_po
               ar_acct
               ar_sub
               ar_cc
               ar_disc_acct
               ar_disc_sub
               ar_disc_cc
               ar_entity
               {&ARPAMTM-P-TAG51}
               {&ARPAMTM-P-TAG69}
               .

            setdet:
            do on error undo, retry:
               /* SET CURRENCY *BEFORE* ENTERING CHECK CONTROL AMT */
               if (new ar_mstr) and (not cash_book) then do:
                  set_curr:
                  do on error undo, retry:
                     set
                        ar_curr
                     with frame b.
                     /* SET ROUND METHOD AND DISPLAY FORMATS */

                     /* GET ROUNDING METHOD FROM CURRENCY MASTER */
                     {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                        "(input ar_curr,
                          output rndmthd,
                          output mc-error-number)"}
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                        next-prompt ar_curr.
                        undo set_curr, retry set_curr.
                     end.

                     {&ARPAMTM-P-TAG62}
                     ar_amt_fmt = ar_amt_old.
                     {gprun.i ""gpcurfmt.p""
                        "(input-output ar_amt_fmt,
                          input rndmthd)"}
                     assign
                        ar_amt:format = ar_amt_fmt
                        artotal:format = ar_amt_fmt
                        oldcurr = ar_curr.

                  end. /* SET_CURR */
               end. /* NEW AR_MSTR & NOT CASH_BOOK */

               {&ARPAMTM-P-TAG67}
               allow-gaps = no.
               if daybooks-in-use
                  and ar_dy_code > ""
               then do:

                  {gprunp.i "nrm" "p" "nr_can_void"
                     "(input  ar_dy_code,
                       output allow-gaps)"}
               end. /* IF daybooks-in-use AND ... */

               setamt:
               do on error undo, retry:
                  {&ARPAMTM-P-TAG19}

                  set
                     artotal    when (not cash_book)
                     ar_date
                     ar_effdate when (new ar_mstr)
                     ar_dy_code when (daybooks-in-use and
                                      not cash_book and
                                     (new ar_mstr or allow-gaps))
                     bank       when (new ar_mstr and not cash_book)
                     ar_po
                  go-on ("F5" "CTRL-D" ).
                  {&ARPAMTM-P-TAG20}

                  if bank entered
                  then
                     assign
                        l_bank_entered = yes
                        l_acct_entered = no.

                  /* VAT REPORT RUNS OFF TAX DATE WHICH IS NOT SET ON */
                  /* PAYMENT SO MAKE TAX DATE EQUAL TO EFFECTIVE DATE */
                  ar_tax_date = ar_effdate.

                  /* DELETE */
                  if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
                  then do:
                     del-yn = yes.
                     /*CONFIRM DELETE*/
                     {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn
                              &CONFIRM-TYPE='LOGICAL'}
                     if not del-yn then undo.
                     /* Disallow deletion of unapplied
                        Payment applications */
                     if not new ar_mstr then do for armstr2:

                        /* SUCCESSFUL AND DELETION WAS ALWAYS ALLOWED.     */
                        /* ar_mstr WITH TYPE "A" HAS ar_cust AS BLANK AND  */
                        /* ar_nbr IS NOT EQUAL TO ar_nbr OF PAYMENT RECORD */
                        /* (TYPE "P"). THEREFORE find armstr2 BELOW WAS NOT*/

                        find first armstr2  where armstr2.ar_domain =
                        global_domain and
                            ar_check = ar_mstr.ar_check
                           and ar_bill = ar_mstr.ar_bill
                           and ar_type = "A" no-lock no-error.
                        if available armstr2 then do:
                           /* "Cannot delete -  */
                           {pxmsg.i &MSGNUM=1174 &ERRORLEVEL=4
                                    &MSGARG1=ar_nbr}
                           /* Must reverse unapplied
                              cash application" ar_nbr */
                           if not batchrun then
                           do on endkey undo, leave:
                              pause.
                           end.

                           undo.
                        end.
                     end.
                  end. /* DEL-YN CONFIRMATION */

                  /* VERIFY ENTITY*/
                  if del-yn then do:

                     /* CHECK FOR DAYBOOK */
                     if daybooks-in-use
                        and ar_dy_code > ""
                        and not allow-gaps
                     then do:
                        /* SEQUENCE DOES NOT ALLOW GAPS */
                        {pxmsg.i &MSGNUM=1349
                                 &ERRORLEVEL=4}
                        undo loopb, retry.
                     end. /* IF daybooks-in-use ... */

                     /* VERIFY GL CALENDAR FOR SPECIFIED ENTITY */
                     {gpglef02.i &module = ""AR""
                           &entity = ar_entity
                           &date   = ar_effdate
                           &prompt = "ar_entity"
                           &frame  = "b"
                           &loop   = "setamt"}

                     /* ASSIGINIG l_ar_nbr, l_daybook and l_effdate   */
                     /* TO LOCAL VARIABLES FOR PASSING AS A PARAMETER */
                     assign
                        l_ar_nbr  = ar_nbr
                        l_daybook = ar_dy_code
                        l_effdate = ar_effdate
                        ar_recno  = recid(ar_mstr)
                        undo_all  = yes.

                     {gprun.i ""arpamtd.p""}

                     clear frame b.

                     /* CONDITION ref <> "" REMOVED BECAUSE ref IS BLANK */
                     /* WHEN LAST RECORD of ard_det HAS A ZERO ard_amt,  */
                     /* THEN ard_det IS NOT UPDATED WITH NRM-SEQ-NUM     */

                     if daybooks-in-use
                     then do:

                        /* NRM SEQUENCE GENERATED ONLY WHEN GL REF IS NEW */

                        if l_new_gl = yes
                        then do:
                           /* PASSED LOCAL VARIABLES BECAUSE ard_det RECORDS */
                           /* ARE ALREADY DELETED.                           */

                           {gprunp.i "nrm" "p" "nr_dispense"
                              "(input  l_daybook,
                                input  l_effdate,
                                output nrm-seq-num)"}

                           l_new_gl = no.

                        end. /* IF l_new_gl = yes */

                        /* CALL assign_nrm_seq_number FOR ASSIGNING SEQUENCE  */
                        /* ONLY TO GLT_DET FOR DELETED RECORDS.               */
                        /* auto_apply WILL BE 'NO' AND tt_ard_manual WILL BE  */
                        /* EMPTY.                                             */
                        {pxrun.i
                           &PROGRAM='arpamtpl.p'
                           &PROC='assign_nrm_seq_number'
                           &PARAM= "(input l_ar_nbr,
                                     input nrm-seq-num,
                                     input l_daybook,
                                     input ref,
                                     input no,
                                     input-output table tt_ard_manual)"
                          }

                        assign
                           l_ar_nbr  = ""
                           l_daybook = ""
                           l_effdate  = ?.

                     end. /* IF daybooks-in-use */

                     if undo_all then undo mainloop, leave.
                     del-yn = no.
                     if cash_book then do:
                        del_cb = yes.
                        leave mainloop.
                     end.
                     else next loopb.
                  end.

                  /* VALIDATE ARTOTAL IF NEW ARMSTR & NOT CASH_BOOK */
                  if ((new ar_mstr) and (not cash_book)) and artotal <> 0
                  then do:
                     {gprun.i ""gpcurval.p"" "(input artotal,
                                               input rndmthd,
                                               output retval)"}
                     if retval <> 0 then do:
                        next-prompt artotal.
                        undo setamt, retry.
                     end.
                  end. /* IF NEW AR_MSTR & NOT CASH_BOOK... */

                  if ar_curr = base_curr
                     and new ar_mstr
                     and ar_ex_rate <> 1
                     and ar_ex_rate2 <> 1 then
                     assign
                        ar_ex_rate = 1
                        ar_ex_rate2 = 1.

                  /* VERIFY DAYBOOK */
                  if daybooks-in-use
                     and (new ar_mstr or allow-gaps)
                  then do:
                     if not can-find(dy_mstr  where dy_mstr.dy_domain =
                     global_domain and  dy_dy_code = ar_dy_code)
                     then do:
                        {pxmsg.i &MSGNUM=1299 &ERRORLEVEL=3}
                        /* ERROR: INVALID DAYBOOK */
                        next-prompt ar_dy_code with frame b.
                        undo, retry.
                     end.
                     else do:
                        {gprunp.i "nrm" "p" "nr_can_dispense"
                           "(input ar_dy_code,
                             input ar_effdate)"}

                        {gprunp.i "nrm" "p" "nr_check_error"
                           "(output daybook-error,
                             output return_int)"}

                        if daybook-error then do:
                           {pxmsg.i &MSGNUM=return_int &ERRORLEVEL=3}
                           next-prompt ar_dy_code with frame b.
                           undo, retry.
                        end.

                        find dy_mstr  where dy_mstr.dy_domain = global_domain
                        and  dy_dy_code = ar_dy_code
                           no-lock no-error.
                        if available dy_mstr then
                           daybook-desc = dy_desc.

                        dft-daybook  = ar_dy_code.
                     end. /* ELSE DO */
                  end. /* if daybooks-in-use and not cash_book and ...*/

                  /* VALIDATE EXCHANGE RATE (IF NEW) */

                  for first cb_mstr
                     fields(cb_domain cb_batch cb_line
                            cb_ex_rate cb_ex_rate2)
                     where cb_mstr.cb_domain = global_domain
                       and cb_batch          = bank_batch
                       and cb_line           = p_line
                  no-lock:
                  end. /* FOR FIRST cb_mstr */

                  if available cb_mstr
                  then do:

                     if cb_ex_rate <> bank_ex_rate
                        and bk_curr = base_curr
                     then
                        l_ex_rate  = cb_ex_rate.
                     else
                        l_ex_rate  = bank_ex_rate.

                     if cb_ex_rate2 <> bank_ex_rate2
                        and bk_curr =  base_curr
                     then
                        l_ex_rate2 = cb_ex_rate2.
                     else
                        l_ex_rate2 = bank_ex_rate2.

                  end. /* IF AVAILABLE cb_mstr */

                  if base_curr <> ar_curr and new ar_mstr then do:
                     if cash_book
                        {&ARPAMTM-P-TAG44}
                     then
                        assign
                           ar_ex_rate  = l_ex_rate
                           ar_ex_rate2 = l_ex_rate2
                           ar_exru_seq = bank_exru_seq.
                     else do:

                        /* GET EXCHANGE RATE AND ALSO CREATE THE*/
                        /* RATE USAGE RECORD IF TRIANGULATED RATE */
                        {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                           "(input ar_curr,
                             input base_curr,
                             input ar_ex_ratetype,
                             input ar_effdate,
                             output ar_ex_rate,
                             output ar_ex_rate2,
                             output ar_exru_seq,
                             output mc-error-number)"}
                        if mc-error-number <> 0 then do:
                           {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                           undo, retry.
                        end.
                     end.
                  end.
                  cash_curr = base_curr.
                  if new ar_mstr then do:
                     {&ARPAMTM-P-TAG21}
                     {&ARPAMTM-P-TAG63}
                     if ar_curr entered and not bank entered
                     {&ARPAMTM-P-TAG64}
                        and not cash_book
                        and not bank_updated
                     then do:
                        {&ARPAMTM-P-TAG22}
                        find first bk_mstr  where bk_mstr.bk_domain =
                        global_domain and  bk_code = bank
                           no-lock no-error.
                        if available bk_mstr and
                           bk_curr <> ar_curr and
                           bk_curr <> base_curr then
                           run is_euro_transparent
                              (input bk_curr,
                               input ar_mstr.ar_curr,
                               input base_curr,
                               input ar_mstr.ar_effdate,
                               output is_transparent).
                        {&ARPAMTM-P-TAG23}
                        else is_transparent = false.
                        {&ARPAMTM-P-TAG24}
                        if not available bk_mstr or
                           is_transparent = false then
                           find first bk_mstr  where bk_mstr.bk_domain =
                           global_domain and  bk_curr = ar_curr
                              no-lock no-error.

                        bank_updated = false.

                        if available bk_mstr and
                           (  bank <> bk_code or is_transparent ) then do:
                           /* VARIANCE ACCOUNTS RETRIEVED FROM ACDF_MSTR */
                           /* JUST A TEMPORARY ASSIGNMENT,*/
                           /* GAIN OR LOSS ACCT ASSIGNED LATER IN ARARGL2.P*/
                           {gprunp.i "mcpl" "p" "get-gain-loss-accounts"
                              " (input true,
                                 input ar_curr,
                                 input true,
                                 input false,
                                 output ar_var_acct,
                                 output ar_var_sub,
                                 output ar_var_cc)"}

                           {&ARPAMTM-P-TAG68}
                           if is_transparent
                           {&ARPAMTM-P-TAG61}
                           then  /*BANK EURO TRANSPARENT*/
                           do:
                              {pxmsg.i &MSGNUM=2769 &ERRORLEVEL=2}
                           end.  /* if is_transparent then */
                           {&ARPAMTM-P-TAG25}
                           else
                              assign
                                 bank        = bk_code
                                 ar_acct     = bk_acct
                                 ar_sub      = bk_sub
                                 ar_cc       = bk_cc
                                 ar_entity   = bk_entity.

                           desc1       = bk_desc.
                           display
                              desc1
                              ar_acct
                              ar_sub
                              ar_cc
                              ar_entity
                           with frame b.
                           update bank with frame b.
                           {&ARPAMTM-P-TAG26}
                           bank_updated = true.
                        end.
                     end.
                     if bank <> "" then do:
                        find first bk_mstr  where bk_mstr.bk_domain =
                        global_domain and  bk_code = bank
                           no-lock no-error.
                        if not available bk_mstr then do:
                           {pxmsg.i &MSGNUM=1200 &ERRORLEVEL=3}
                           next-prompt bank with frame b.
                           undo setamt, retry.
                        end.
                        else do:
                           cash_curr = bk_curr.
                           desc1 = bk_desc.
                           display
                              desc1
                           with frame b.
                           ar_bank = bank.
                        end.
                     end.
                     /* GET DEFAULT ACCOUNT INFORMATION FROM BANK */
                     {&ARPAMTM-P-TAG27}

                     if l_bank_entered and
                        not l_acct_entered
                     then do:
                        {&ARPAMTM-P-TAG28}

                        /*ABOVE VARIANCE ACCOUNTS RETRIEVED FROM ACDF_MSTR */
                        /* JUST A TEMPORARY ASSIGNMENT,*/
                        /* GAIN OR LOSS ACCT ASSIGNED LATER IN ARARGL2.P */

                         {gprunp.i "mcpl" "p" "get-gain-loss-accounts"
                            " (input true,
                               input ar_curr,
                               input true,
                               input false,
                               output ar_var_acct,
                               output ar_var_sub,
                               output ar_var_cc)"}

                        {&ARPAMTM-P-TAG29}
                        assign
                           ar_acct     = bk_acct
                           ar_sub      = bk_sub
                           ar_cc       = bk_cc
                           ar_entity   = bk_entity.
                        {&ARPAMTM-P-TAG30}

                        display
                           ar_acct
                           ar_sub
                           ar_cc
                           ar_entity
                        with frame b.

                        {&ARPAMTM-P-TAG31}
                     end.

                     is_transparent = false.
                     if ar_mstr.ar_curr <> cash_curr and not cash_book
                     then do:
                        {&ARPAMTM-P-TAG32}
                        run is_euro_transparent
                           (input cash_curr,
                            input ar_mstr.ar_curr,
                            input base_curr,
                            input ar_mstr.ar_effdate,
                            output is_transparent).
                        if is_transparent = false then
                        do:
                           {pxmsg.i &MSGNUM=98 &ERRORLEVEL=3}
                           /* PMT CURR MUST = BANK CURR*/
                           undo setdet, retry.
                        end.
                     end.

                     setacct:
                     do on error undo, retry:
                        {&ARPAMTM-P-TAG33}
                        set
                           ar_acct      when (new ar_mstr and not cash_book)
                           ar_sub       when (new ar_mstr and not cash_book)
                           ar_cc        when (new ar_mstr and not cash_book)

                           ar_disc_acct when (new ar_mstr)
                           ar_disc_sub  when (new ar_mstr)
                           ar_disc_cc   when (new ar_mstr)
                           ar_entity    when (new ar_mstr and not cash_book).
                        {&ARPAMTM-P-TAG34}

                        if ar_acct      entered or
                           ar_sub       entered or
                           ar_cc        entered or
                           ar_entity    entered
                        then
                           l_acct_entered = yes.

                        /* VERIFY ENTITY */
                        if ar_entity <> glentity then
                        do:
                           if not can-find (en_mstr
                               where en_mstr.en_domain = global_domain and
                               en_entity = ar_entity) then
                           do:
                              {pxmsg.i &MSGNUM=3061 &ERRORLEVEL=3}
                              /*INVALID ENTITY*/
                              next-prompt ar_entity with frame b.
                              undo setacct, retry.
                           end. /* IF NOT AVAILABLE EN_MSTR */
                        end. /* IF AR_ENTITY <> GLENTITY */

                        /* CHECK ENTITY SECURITY */
                        {glenchk.i &entity=ar_entity &entity_ok=l_entity_ok}
                        if not l_entity_ok
                        then
                           if not batchrun
                           then do:
                              next-prompt ar_entity with frame b.
                              undo setacct, retry.
                           end. /* IF NOT batchrun */
                           else do:
                              l_batch_err = yes.
                              undo mainloop, leave mainloop.
                           end. /* IF batchrun        */

                        /* VERIFY GL CALENDAR FOR SPECIFIED ENTITY */
                        {gprun.i ""gpglef.p"" "(input ""AR"",
                                             input  ar_entity,
                                             input  ar_effdate,
                                             input  1,
                                             output gpglef)"}

                        if gpglef > 0
                        then do:
                           if not batchrun
                           then do:
                              next-prompt ar_entity with frame b.
                              undo setacct, retry.
                           end. /* IF NOT BATCHRUN */
                           else
                              undo mainloop, leave mainloop.
                        end. /* IF gpglef > 0 */

                        if daybooks-in-use and not cash_book and
                           (new ar_mstr or allow-gaps) then
                           if can-find(dy_mstr  where dy_mstr.dy_domain =
                           global_domain and  dy_dy_code = ar_dy_code)
                           then do:
                              {gprun.i ""gldyver.p"" "(input ""AR"",
                                                       input ""P"",
                                                       input ar_dy_code,
                                                       input ar_entity,
                                                      output daybook-error)"}
                              if daybook-error then do:
                                 {pxmsg.i &MSGNUM=1674 &ERRORLEVEL=2}
                                 /* WARNING: DAYBOOK DOES NOT MATCH */
                                 /* ANY DEFAULT */
                                 if not batchrun then
                                 do on endkey undo, leave:
                                    pause.
                                 end. /* IF NOT BATCHRUN */
                              end. /* IF DAYBOOK-ERROR */
                           end. /* IF CAN-FIND ... */

                           /* INITIALIZE SETTINGS */
                           {gprunp.i "gpglvpl" "p" "initialize"}
                           /* SET PROJECT VERIFICATION TO NO */
                           {gprunp.i "gpglvpl" "p" "set_proj_ver"
                              "(input false)"}
                           /* ACCT/SUB/CC VALIDATION */
                           {gprunp.i "gpglvpl" "p" "validate_fullcode"
                              "(input ar_acct,
                                input ar_sub,
                                input ar_cc,
                                input """",
                                output valid_acct)"}

                           if valid_acct = no then do:
                              next-prompt ar_acct with frame b.
                              undo, retry.
                           end.

                           /* INITIALIZE SETTINGS */
                           {gprunp.i "gpglvpl" "p" "initialize"}
                           /* SET PROJECT VERIFICATION TO NO */
                           {gprunp.i "gpglvpl" "p" "set_proj_ver"
                              "(input false)"}
                           /* ACCT/SUB/CC VALIDATION */
                           {gprunp.i "gpglvpl" "p" "validate_fullcode"
                              "(input ar_disc_acct,
                                input ar_disc_sub,
                                input ar_disc_cc,
                                input """",
                                output valid_acct)"}

                           if valid_acct = no then do:
                              next-prompt ar_disc_acct with frame b.
                              undo, retry.
                           end.

                           /* ACCOUNT MUST EITHER BE BASE OR PAYMENT CURR */
                           if ar_curr <> base_curr then do:
                              find ac_mstr  where ac_mstr.ac_domain =
                              global_domain and  ac_code = ar_acct
                                 no-lock no-error.

                              /* CASH ACCOUNT CURRENCY MUST MATCH WITH    */
                              /* TRANSACTION OR BASE CURR WHEN BANK IS NOT*/
                              /* EURO TRANSPARENT. WHEN THE BANK IS       */
                              /* EURO TRANSPARENT, THE CASH ACCOUNT CURR  */
                              /* MUST MATCH EITHER BANK OR BASE CURRENCY  */
                              if available ac_mstr and
                                 ( ac_curr <> ar_curr or is_transparent)
                                 and ac_curr <> base_curr
                                 and ac_curr <> cash_curr
                              then do:
                                 /* BANK EURO TRANSPARENT */
                                 if is_transparent then
                                 do:
                                    {pxmsg.i &MSGNUM=2768 &ERRORLEVEL=3}
                                    /* ACCT CURR MUST MATCH
                                    BANK CURR OR BASE CURR */
                                 end.
                                 else do:
                                    {pxmsg.i &MSGNUM=134 &ERRORLEVEL=3}
                                    /* ACCT CURR MUST MATCH
                                    TRANSACTION OR BASE CURR*/
                                 end.
                                 next-prompt ar_acct with frame b.
                                 undo setacct, retry.

                              end.
                           end.

                     end. /* setacct */

                     /* SET EXCHANGE RATE */
                     if ar_curr <> base_curr then
                     setb_sub:
                     do on error undo, retry:
                        /* THIS FORM BEING REPLACE WITH  */
                        /* mc-ex-rate-input FOR RATE INPUT. */
                        /* ALSO ar_var_acct, _cc WILL NOT BE PROMPTED */
                        /* TO THE USER ANY MORE AND EXCHANGE RATE WILL */
                        /* BE STORED IN _ex_rate IN PLACE OF _ent_ex. */

                        /* GET EXCHANGE RATE USING mc-ex-rate-input */

                        /* PROCEDURE mc-ex-rate-input IN PLACE OF INPUT */
                        /* FRAME setb_sub TO PROMPT THE USER FOR EXCH RATE */

                        /* EXCHANGE RATE INPUT WILL NOT BE PROMPTED */
                        /* IF THE PROGRAM IS CALLED FROM CASH BOOK */
                        /* MAINTENANCE */

                        if not cash_book
                        then do:
                           {gprunp.i "mcui" "p" "mc-ex-rate-input"
                             "(input ar_curr,
                               input base_curr,
                               input ar_effdate,
                               input ar_exru_seq,
                               input false, /*DO NOT ASK FOR fixed y/n*/
                               input frame b:row + 7,
                               input-output ar_ex_rate,
                               input-output ar_ex_rate2,
                               input-output fixed_rate)"}
                        end. /* IF NOT cash_book */

                        /* INSTEAD EXCHANGE RATE STORED IN CASH BOOK */
                        /* WILL BE USED */
                        else do:

                           assign
                              ar_ex_rate  = l_ex_rate
                              ar_ex_rate2 = l_ex_rate2.

                        end. /* ELSE DO */
                     end.  /* set exchange rate */

                     /* LOGIC FOR AUTOMATIC DOCUMENT SELECTION*/
                     if new ar_mstr then
                        set_auto:
                        do on error undo, retry:
                           /* IF PAYMENT THROUGH CASHBOOK ENABLE   */
                           /* AUTO-APPLY                           */
                           update auto_apply when (new ar_mstr)
                              /* SS - 20070817.1 - B */
                              ar_user2
                              /* SS - 20070817.1 - E */
                              .

                           /* Prompt for documents to apply to */
                           if auto_apply then do:

                              hide frame b.
                              ar_recno = recid(ar_mstr).
                              {gprun.i ""arpamtb.p""}
                              /*V8! hide all.
                              view frame dtitle. */

                              /* IF AUTO PAYMENT SELECTION FRAME
                               * WAS NOT COMPLETED */

                              if not autocpl_code then do:

                                 view frame dtitle.
                                 view frame a.
                                 view frame b.

                                 if no_open_doc then do:
                                    {pxmsg.i &MSGNUM=1173 &ERRORLEVEL=2}
                                    /*NO OPEN DOCS*/
                                    if not batchrun then
                                       do on endkey undo set_auto,
                                          retry set_auto:
                                       pause.
                                 end.
                                 undo set_auto, retry.
                              end.

                              /* WHEN THE USER EXITS THE AUTO APPLY */
                              /* MODE WITHOUT APPLYING PAYMENT      */
                              /* AR_AMT IS RESET TO ZERO.           */

                              /* ALSO ar_applied IS RESET TO ZERO   */
                              assign
                                 ar_mstr.ar_amt      = 0
                                 ar_mstr.ar_applied  = 0
                                 ar_mstr.ar_base_amt = 0
                                 aramt    = - ar_mstr.ar_amt
                                 ctrldiff = artotal - aramt.

                              if ctrldiff <> 0
                                 and can-find(first ard_det
                                     where ard_det.ard_domain = global_domain
                                     and   ard_nbr             = ar_nbr
                                     and   ard_type            = "U"
                                     and   ard_disc            <> 0)
                              then do:

                                 /* BATCH/CHECK CTRL INCLUDE PAYMENT DISC FOR */
                                 /* UNNAPPLIED PAYMENTS                       */
                                 {pxmsg.i &MSGNUM=6763 &ERRORLEVEL=2 &PAUSEAFTER=TRUE}

                              end. /* IF can-find ... */

                              /* ACCEPT/EDIT/CANCEL PROMPT */
                              {gpdifchk.i
                                 &control        = artotal
                                 &distr          = aramt
                                 &diff           = ctrldiff
                                 &edit-block     = loopc
                                 &tran-block     = loopb
                              }

                              view frame a.
                              view frame b.
                              {pxmsg.i &MSGNUM=1159 &ERRORLEVEL=2}
                              /*DELETE REF*/
                              /* DEL EXCHANGE RATE USAGE (exru_usage)*/
                              run delete_rate_usage_records.
                              run delete_wkfl_record.
                              delete ar_mstr.
                              if not batchrun then
                                 do on endkey undo, leave loopb:
                                    pause.
                                 end.
                              clear frame b.
                              next loopb.
                           end.
                        end.
                     end.

                  end. /*if new ar_mstr*/

                  if not new ar_mstr
                  then do:
                     {gprun.i ""gpglef.p"" "(input ""AR"",
                                             input  ar_entity,
                                             input  ar_effdate,
                                             input  1,
                                             output gpglef)"}
                  end. /* IF NOT NEW ar_mstr */

                  if gpglef > 0
                  then do:
                     if not batchrun
                     then do:
                        next-prompt ar_entity with frame b.
                        undo, retry.
                     end. /* IF NOT BATCHRUN */
                     else
                        undo mainloop, leave mainloop.
                  end. /* IF gpglef > 0 */

                  find ac_mstr  where ac_mstr.ac_domain = global_domain and
                     ac_code = ar_acct
                     no-lock no-error.
                  if available ac_mstr and ac_curr <> "" then
                     cash_curr = ac_curr.
               end. /* setamt */
            end. /* setdet */

            /* SET DUE DATE TO EFFECTIVE DATE FOR AGING */
            if new ar_mstr then ar_due_date = ar_date.
            find cm_mstr  where cm_mstr.cm_domain = global_domain and  cm_addr
            = ar_cust no-lock
               no-error.
            if not auto_apply then
               display cm_sort.
               ar_recno = recid(ar_mstr).
            if cash_book then gl_use_curr = bk_curr.
            else gl_use_curr = ar_curr.

            if cash_book and not new_line {&ARPAMTM-P-TAG56} then do:
               {pxmsg.i &MSGNUM=3134 &ERRORLEVEL=3}
               /*MODIFICATION NOT ALLOWED*/
               /* STORE PAYMENT AMOUNTS AS NEGATIVES */
               assign
                  ar_mstr.ar_amt = - ar_mstr.ar_amt
                  ar_mstr.ar_applied = - ar_mstr.ar_applied
                  ar_mstr.ar_open =
                     (ar_mstr.ar_amt - ar_mstr.ar_applied <> 0)
                  ar_mstr.ar_base_amt = - ar_mstr.ar_base_amt
                  ar_mstr.ar_base_applied = - ar_mstr.ar_base_applied.
               if available ar_mstr
               then batch_total = batch_total - ar_mstr.ar_amt.
               next loopb.
            end.

            /* MANUAL DISTRIBUTIONS */
            setdist:
            repeat:
               hide frame a no-pause.
               hide frame b no-pause.

            assign
               l_ar_nbr  = ar_nbr
               l_daybook = ar_dy_code
               l_effdate = ar_effdate.


               {gprun.i ""arpamta.p""}
               {&ARPAMTM-P-TAG57}

               leave setdist.
            end. /*setdist*/
            {&ARPAMTM-P-TAG35}
            if cash_book then
               del_cb = no. /*made it passed undo*/
            {&ARPAMTM-P-TAG36}

            find cm_mstr  where cm_mstr.cm_domain = global_domain and  cm_addr
            = ar_mstr.ar_bill exclusive-lock
               no-error.

            find first ard_det  where ard_det.ard_domain = global_domain and
            ard_nbr = ar_mstr.ar_nbr no-lock
               no-error.
            if not available ard_det then do:
               view frame dtitle.
               view frame a.
               view frame b.
               {pxmsg.i &MSGNUM=1159 &ERRORLEVEL=2} /* DELETING REFERENCE */
               /* DEL EXCHANGE RATE USAGE (exru_usage)*/
               run delete_rate_usage_records.
               run delete_wkfl_record.
               delete ar_mstr.
               del_cb = true.
               {&ARPAMTM-P-TAG39}

               if not batchrun then
                  do on endkey undo, leave:
                     pause.
                  end.
            end.
            else
               /* STORE PAYMENT AMOUNTS AS NEGATIVES */
               assign
                  ar_mstr.ar_amt = - ar_mstr.ar_amt
                  ar_mstr.ar_applied = - ar_mstr.ar_applied
                  ar_mstr.ar_open =
                     (ar_mstr.ar_amt - ar_mstr.ar_applied <> 0)
                  ar_mstr.ar_base_amt = - ar_mstr.ar_base_amt
                  ar_mstr.ar_base_applied = - ar_mstr.ar_base_applied.

               /* UPDATION OF CUSTOMER BALANCE (cm_balance) AND  */
               /* LAST PAYMENT DATE (cm_pay_date)                */

            if available cm_mstr
            then do:
               assign
                  cm_balance = cm_balance + cust_bal
                  cust_bal   = 0.

               /* UPDATION OF LAST PAYMENT DATE (cm_pay_date)  FOR */
               /* ADDITION, MODIFICATION AND DELETION OF PAYMENT   */

               if l_new_armstr          or
                  ar_date entered       or
                  not available ard_det
               then do for armstr_temp:
                  tempdate = low_date.

                  for each armstr_temp
                     fields( ar_domain ar_bill ar_type ar_date)
                      where armstr_temp.ar_domain = global_domain and  ar_bill
                      = cm_addr and
                           ar_type = "P"
                     no-lock:
                     if ar_date > tempdate then
                        tempdate = ar_date.
                  end. /* FOR EACH armstr_temp... */

                  if tempdate = low_date
                  then
                     tempdate = ?.
                  cm_pay_date = tempdate.

               end. /* IF NEW ar_mstr... */
            end. /* IF AVAILABLE cm_mstr */

            if available ar_mstr
            then
               batch_total = batch_total - ar_mstr.ar_amt.

            if available ar_mstr and artotal <> 0 then do:

               view frame dtitle.
               view frame a.
               view frame b.

               aramt    = - ar_mstr.ar_amt.
               ctrldiff = artotal - aramt.

               if ctrldiff <> 0
                  and can-find(first ard_det
                                  where ard_det.ard_domain = global_domain
                                  and   ard_nbr             = ar_nbr
                                  and   ard_type            = "U"
                                  and   ard_disc            <> 0)
               then do:

                  /* BATCH/CHECK CTRL INCLUDE PAYMENT DISC FOR */
                  /* UNNAPPLIED PAYMENTS                       */
                  {pxmsg.i &MSGNUM=6763 &ERRORLEVEL=2 &PAUSEAFTER=TRUE}

               end. /* IF can-find ... */

               {gpdifchk.i
                  &control        = artotal
                  &distr          = aramt
                  &diff           = ctrldiff
                  &edit-block     = loopc
                  &tran-block     = loopb
                }

            end. /* available ar_mstr */

            /* CALL THE PROCEDURE nr_dispense IN nrm.p TO GENERATE      */
            /* SEQUENCE NUMBERS.IF NOT GENERATED, nrm-seq-num WILL HAVE */
            /* PREVIOUS VALUE.                                          */

            /* CONDITION ref <> "" REMOVED BECAUSE ref IS BLANK */
            /* WHEN LAST RECORD of ard_det HAS A ZERO ard_amt,  */
            /* THEN ard_det IS NOT UPDATED WITH NRM-SEQ-NUM     */

            if daybooks-in-use
            then do:

               /* NRM SEQUENCE GENERATED ONLY WHEN GL REF IS NEW   */
               if l_new_gl = yes
               then do:

                  {gprunp.i "nrm" "p" "nr_dispense"
                     "(input  l_daybook,
                       input  l_effdate,
                       output nrm-seq-num)"}

                   l_new_gl = no.

               end. /* IF l_new_gl = yes */

            /* CALL assign_nrm_seq_number FOR ASSIGNING SEQUENCE NUMBER   */
            /* TO ARD_DET AND GLT_DET FOR ADDED AND MODIFIED RECORDS, AND */
            /* GLT_DET FOR DELETED RECORDS.                               */

               {pxrun.i
                  &PROGRAM='arpamtpl.p'
                  &PROC='assign_nrm_seq_number'
                  &PARAM= "(input l_ar_nbr,
                            input nrm-seq-num,
                            input l_daybook,
                            input ref,
                            input auto_apply,
                            input-output table tt_ard_manual)"
                 }

               assign
                  l_ar_nbr  = ""
                  l_daybook = ""
                  l_effdate  = ?.

            end. /* IF daybooks-in-use */

            leave.
            end.  /* loopc */
      end. /* TRANSACTION */

      /* CONTROL SHOULD GO TO MAINLOOP TO EXECUTE THE LOGIC TO UPDATE */
      /* DAYBOOK SEQUENCE NUMBER                                      */
      if cash_book
      then
         leave loopb.

      display
         batch_total
      with frame a.
      display
         (-1 * ar_amt) when (available ar_mstr) @ ar_amt
      with frame b.

      /* LEAVE THE BLOCK IF THE USER NOT AUTHORIZED FOR THE   */
      /* LINE TRANSACTION ENTITY ONLY AFTER UPDATING CUSTOMER */
      /* BALANCE. THIS IS REQUIRED IF FEW LINES HAVE ALREADY  */
      /* BEEN COMMITED FOR USER AUTHORIZED ENTITIES.          */

      if batchrun and l_batch_err
      then
         leave loopb.

   end. /* loopb */

   if available ba_mstr and not cash_book then
   do transaction:
      ba_total = batch_total.
      if can-find(first ar_mstr  where ar_mstr.ar_domain = global_domain and
      ar_batch = ba_batch) then do:
         if ba_ctrl <> ba_total then do:
            ba_status = "UB". /*unbalanced*/
            if ba_ctrl <> 0 then do:
               {pxmsg.i &MSGNUM=1151 &ERRORLEVEL=2}
               if not batchrun then
               do on endkey undo, leave:
                  pause.
               end.
            end.
         end.
         else
            ba_status = "".         /*open, balanced*/
      end.
      else
         assign
            ba_status = "NU"  /*not used*/
            ba_ctrl = 0.
      release ba_mstr.
      batch_total = 0.
   end. /*transaction*/

   /* LEAVE THE BLOCK IF THE USER NOT AUTHORIZED FOR THE LINE */
   /* TRANSACTION ENTITY AFTER UPDATING BATCH DETAILS.        */

   if batchrun and l_batch_err
   then
      leave mainloop.

   {&ARPAMTM-P-TAG52}

   if cash_book
   then
      leave mainloop.
end.  /* mainloop */

if cash_book then do:
   {&ARPAMTM-P-TAG37}
   bank_ctrl = batch_total.
   {&ARPAMTM-P-TAG38}
   hide frame a no-pause.
   hide frame b no-pause.
   hide frame setb_sub no-pause.
   if available ar_mstr then
      b_batch = ar_check.
end.
{&ARPAMTM-P-TAG58}

undo_all = no.
status input.

PROCEDURE delete_rate_usage_records:

   /* BEING CALLED UPON CTRL-D (DELETE) AND WHEN NO LINE DETAIL ENTERED */
   /* DELETE ANY EXCHANGE RATE USAGE (exru_usage) RECORDS */
   if ar_mstr.ar_exru_seq <> 0 then
   do:
      {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
         "(input ar_mstr.ar_exru_seq)"}
   end.
   if ar_mstr.ar_dd_exru_seq <> 0 then
   do:
      {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
         "(input ar_mstr.ar_dd_exru_seq)"}
   end.
END PROCEDURE.

PROCEDURE delete_wkfl_record:
   for first qad_wkfl
      fields( qad_domain qad_decfld[1] qad_decfld[2])
       where qad_wkfl.qad_domain = global_domain and  qad_key1 = "AR_MSTR"
      and   qad_key2 = ar_mstr.ar_nbr:
   end.
   if available qad_wkfl then delete qad_wkfl.
END PROCEDURE.

{gpacctet.i} /* DEFINITION FOR procedure is_euro_transparent */
