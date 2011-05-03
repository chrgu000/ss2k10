/* gltrmtm.p  --   GENERAL LEDGER JOURNAL ENTRY TRANSACTION MAINTENANCE      */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.60.1.1 $                                                         */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION: 1.0     LAST MODIFIED:  07/31/87   BY:  JMS                     */
/*                                   10/28/87   BY:  JMS                     */
/*                                   02/02/88   by:  JMS                     */
/* REVISION: 4.0     LAST MODIFIED:  02/25/88   By:  JMS                     */
/*                                   08/03/88   by:  jms   *A376*            */
/*                                   08/03/88   by:  jms   *A377*            */
/*                                   08/09/88   by:  jms   *A378*            */
/*                                   09/01/88   BY:  jms   *A392*            */
/*                                   09/12/88   by:  jms   *A421*            */
/*                                   10/10/88   by:  jms   *A475*            */
/*                                   10/13/88   by:  jms   *A487*            */
/*                                   10/14/88   by:  jms   *A488*            */
/* REVISION: 5.0     LAST MODIFIED:  12/09/88   By:  RL    *C0028            */
/*                                   05/25/89   BY:  JMS   *B066*            */
/*                                   05/25/89   by:  jms   *A744*            */
/*                                   06/01/89   BY:  MLB   *B118*            */
/*                                   07/05/89   by:  jms   *B154*            */
/*                                   07/14/89   by:  pml   *B186*            */
/*                                   09/13/89   by:  jms   *B279*            */
/*                                   09/27/89   by:  jms   *B316*            */
/*                                   04/27/90   by:  jms   *B681*            */
/* REVISION: 6.0     LAST MODIFIED:  05/30/90   by:  jms   *D029*            */
/*                                   08/17/90   by:  jms   *D034*            */
/*                                          (program split)                  */
/*                                   02/21/91   by:  jms   *D371* (rev only) */
/*                                   03/12/91   by:  jms   *D434* (rev only) */
/*                                   03/18/91   by:  jms   *D442*            */
/*                                   04/24/91   by:  jms   *D582* (rev only) */
/*                                   04/29/91   by:  jms   *D604* (rev only) */
/*                                   08/13/91   by:  jms   *D826* (rev only) */
/* REVISION: 7.0     LAST MODIFIED:  10/02/91   by:  jms   *F058*            */
/*                                   10/10/91   by:  dgh   *D892*            */
/*                                   01/22/92   BY:  mlv   *F081*            */
/*                                   01/24/92   by:  jms   *F058*            */
/*                                   02/11/92   by:  jms   *F193* (rev only) */
/*                                   02/25/92   by:  jms   *F231*            */
/*                                   05/19/92   BY:  MLV   *F512*            */
/*                                   05/29/92   by:  jms   *F540*            */
/*                                   05/29/92   BY:  MLV   *F513*            */
/*                                   07/07/92   by:  jms   *F734* (rev only) */
/* REVISION: 7.3     LAST MODIFIED:  08/26/92   by:  mpp   *G016*            */
/*                                   12/03/92   by:  mpp   *G387* (rev only) */
/*                                   02/19/93   by:  jms   *G703*            */
/*                                   02/23/93   by:  mpp   *G479*            */
/*                                   04/19/93   by:  jms   *G974*            */
/*                                   04/20/93   by:  jms   *G991*            */
/*                                   05/11/93   by:  wep   *GA85* (rev only) */
/*                                   05/12/94   by:  pmf   *FO12*            */
/*                                   09/03/94   by:  srk   *FQ80*            */
/*                                   09/11/94   by:  rmh   *GM08*            */
/*                                   10/11/94   by:  str   *FS30*            */
/*                                   11/06/94   by:  rwl   *GO24*            */
/*                                   01/03/95   by:  str   *F0CH*            */
/*                                   01/27/95   by:  str   *G0D6*            */
/* REVISION: 7.4     LAST MODIFIED:  02/17/95   by:  str   *F0JD*            */
/*                                   04/20/95   by:  jpm   *H0CH*            */
/*                                   04/21/95   by:  aed   *H0D6*            */
/*                                   05/05/95   by:  jzw   *F0RC*            */
/*                                   11/28/95   by:  wjk   *G1F2*            */
/* REVISION: 8.5     LAST MODIFIED:  09/18/95   BY:  ccc   *J053*            */
/*                                   12/20/95   by:  mys   *G1H6*            */
/*                                   01/18/96   by:  mys   *G1K3*            */
/*                                   04/09/96   by:  jzw   *G1P8*            */
/* REVISION: 8.6     LAST MODIFIED:  07/18/96   by:  bjl   *K001*            */
/* REVISION: 8.5     LAST MODIFIED:  07/24/96   BY:  taf   *J115*            */
/* REVISION: 8.6     LAST MODIFIED:  10/02/96   By:  pjg   *K00S*            */
/*       ORACLE PERFORMANCE FIX      11/21/96   BY:  rxm   *H0PS*            */
/*                                   12/06/96   BY:  bjl   *K01S*            */
/*                                   01/28/97   BY:  rxm   *J1FR*            */
/*                                   02/17/97   BY: *K01R* E. Hughart        */
/*                                   03/04/97   BY:  bkm   *K06R*            */
/*                                   03/07/97   BY:  rxm   *K070*            */
/*                                   03/11/97   BY:  *K079* E. Hughart       */
/*                                   05/19/97   *K0DD*  Jeff Wootton         */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 04/10/98   BY: *J2HF* Niranjan R.       */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton      */
/* REVISION: 8.6E     LAST MODIFIED: 06/25/98   BY: *L01J* Mansour Kazemi    */
/* REVISION: 8.6E     LAST MODIFIED: 08/03/98   BY: *L05B* Brenda Milton     */
/* REVISION: 8.6E     LAST MODIFIED: 08/21/98   BY: *H1L8* Dana Tunstall     */
/* REVISION: 8.6E     LAST MODIFIED: 09/15/98   BY: *L097* Brenda Milton     */
/* REVISION: 8.6E     LAST MODIFIED: 04/12/99   BY: *K209* Abbas Hirkani     */
/* REVISION: 9.1      LAST MODIFIED: 06/28/99   BY: *N00D* Adam Harris       */
/* REVISION: 9.1      LAST MODIFIED: 08/18/99   BY: *N014* Jeff Wootton      */
/* REVISION: 9.1      LAST MODIFIED: 11/22/99   BY: *L0LK* Ranjit Jain       */
/* REVISION: 9.1      LAST MODIFIED: 02/04/00   BY: *N07M* Vijaya Pakala     */
/* REVISION: 9.1      LAST MODIFIED: 02/14/00   BY: *N05F* Atul Dhatrak      */
/* REVISION: 9.1      LAST MODIFIED: 03/01/00   BY: *N03S* Jeff Wootton      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 05/16/00   BY: *L0XS* Vihang Talwalkar  */
/* REVISION: 9.1      LAST MODIFIED: 05/24/00   BY: *L0TX* Vihang Talwalkar  */
/* REVISION: 9.1      LAST MODIFIED: 06/26/00   BY: *N0DJ* Mudit Mehta       */
/* REVISION: 9.1      LAST MODIFIED: 07/10/00   BY: *N0FD* Inna Lyubarsky    */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown        */
/* REVISION: 9.1      LAST MODIFIED: 01/08/01   BY: *M0ZJ* Veena Lad         */
/* REVISION: 9.1      LAST MODIFIED: 01/24/01   BY: *N0VT* Rajesh Lokre      */
/* REVISION: 9.1      LAST MODIFIED: 08/07/00   BY: *N0W6* Mudit Mehta       */
/* REVISION: 8.6E     LAST MODIFIED: 03/20/01   BY: *L18P* Jean Miller       */
/* Revision: 1.46     BY: Vihang Talwalkar    DATE: 05/31/01 ECO: *N0ZD*     */
/* Revision: 1.47     BY: Mercy C.            DATE: 09/20/01 ECO: *N12K*     */
/* Revision: 1.48     BY: Mamata Samant       DATE: 01/14/02 ECO: *M1Q5*     */
/* Revision: 1.50     BY: Anitha Gopal        DATE: 02/17/02 ECO: *N19M*     */
/* Revision: 1.51     BY: Ed van de Gevel     DATE: 04/16/02 ECO: *N1GP*     */
/* Revision: 1.51     BY: Kirti Desai         DATE: 05/06/02  ECO: *M1XX*    */
/* Revision: 1.52     BY: K Paneesh           DATE: 05/24/02  ECO: *N1JX*    */
/* Revision: 1.53     BY: Jose Alex           DATE: 05/27/02  ECO: *N1K1*    */
/* Revision: 1.55     BY: Amit Chaturvedi     DATE: 07/01/02  ECO: *N1M8*    */
/* Revision: 1.56     BY: Ed van de Gevel     DATE: 07/04/02  ECO: *P0B4*    */
/* Revision: 1.57     BY: Manjusha Inglay     DATE: 08/19/02  ECO: *N1QP*    */
/* Revision: 1.58     BY: Subramanian Iyer   DATE: 10/04/02   ECO: *N1TQ*    */
/* Revision: 1.59     BY: W.Palczynski        DATE: 02/26/03  ECO: *P0N9*    */
/* Revision: 1.60     BY: Narathip W.         DATE: 04/30/03  ECO: *P0QX*    */
/* $Revision: 1.60.1.1 $    BY: K Paneesh           DATE: 08/08/03  ECO: *N2JT*    */
/* $Revision: eb2sp4       BY: Micho Yang           DATE: 06/06/06  ECO: *SS - Micho - 20060606 *    */
/* $Revision: eb2sp4       BY: Micho Yang           DATE: 07/09/06  ECO: *SS - Micho - 20060709 *    */
/* BY: Micho Yang          DATE: 04/24/08  ECO: *SS - 20080424.1* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* ECO: N1TQ INTRODUCES TWO NEW FRAMES FOR THE HEADER. THE FIRST IS FOR   */
/* STANDARD TRANSACTION MAINTENANCE (FRAME a) AND THE SECOND IS FOR       */
/* YEAR END ADJUSTMENT MAINTENANCE (FRAME ya). THIS IS REQUIRED SINCE     */
/* THE EFFECTIVE DATE LOST ITS FORMAT. THE DATE FORMAT IS NOW RETAINED BY */
/* USING DATE DATATYPE.                                                   */

/* SS - 20080424.1 - B */
/*
1. 每Line指定DR/CR  (金额为正数时默认DR,负数时默认CR)
2. 添加多项目录入数据界面，采用并列式和多级式并存的方式．相关的资料存放在usrw_wkfl
*/                                                                        
/* SS - 20080424.1 - E */     
/* ss - 100923.1 by: jack */ /*单号连续，生效日期控制 */

{mfdeclre.i}
{cxcustom.i "GLTRMTM.P"}

/* EXTERNAL LABEL INCLUDE */
{gplabel.i}

{gldydef.i}
{gldynrm.i}
{gprunpdf.i "gpglvpl" "p"}
{gprunpdf.i "mcpl" "p"}
{gprunpdf.i "nrm" "p"}

define input parameter type_parm as character.
define new shared variable tr_type   like glt_tr_type label "Type".
define new shared variable ctrl_amt  like glt_amt     label "Control".
define new shared variable per_yr    as   character   format "x(7)"
                                                      label "Period".
define new shared variable desc1     like glt_desc    format "x(22)".
define new shared variable tot_amt   like glt_amt     label "Total".
define new shared variable disp_curr like glt_curr    format "x(4)".

define new shared variable enter_dt  like glt_date.
define new shared variable eff_dt    like glt_effdate initial today
                                                  label "Effective".
define new shared variable dr_tot    like glt_amt.
define new shared variable pl        like co_pl.
define new shared variable entities_balanced like co_enty_bal.
define new shared variable allow_mod         like co_allow_mod.
define new shared variable entity            like en_entity.
define new shared variable glname            like en_name.
define new shared variable ctrl_curr         like glt_curr.
define new shared variable use_sub           like co_use_sub.
define new shared variable use_cc            like co_use_cc.
define new shared variable ctrl_rndmthd      like rnd_rnd_mthd no-undo.

define new shared frame a.
define new shared frame ya.

define variable l_glt_ref                    like glt_ref     no-undo.
define shared variable ref                   like glt_ref.
define shared variable new_glt               like mfc_logical no-undo.
define shared variable co_daily_seq          like mfc_logical no-undo.
define shared variable cash_book             like mfc_logical.
define shared variable bank_bank             like ck_bank.
define shared variable bank_ctrl             like ap_amt.
define shared variable bank_batch            like ba_batch.
define shared variable b_batch               like ba_batch.
define shared variable bank_date             like ba_date.
define shared variable bank_curr             like glt_curr.
define shared variable bank_ex_rate          like cb_ex_rate.
define shared variable bank_ex_rate2         like cb_ex_rate2.
define shared variable undo_all              like mfc_logical.
define shared variable del_cb                like mfc_logical.
define shared variable corr-flag             like glt_correction.

/****************************** Add by SS - Micho - 20060709 B ******************************/
DEF SHARED VAR v_annex LIKE glt_user2 .
/****************************** Add by SS - Micho - 20060709 B ******************************/

define variable undo_flag   like mfc_logical                 no-undo.
define variable inv_flag    as   logical                     no-undo.
define variable tot_flag    as   logical                     no-undo.
define variable ent_flag    as   logical                     no-undo.
define variable temp_curr   like glt_curr                    no-undo.
define variable new_glt_ref like mfc_logical                 no-undo.
define variable valid_acct  like mfc_logical                 no-undo.
define variable ctr_no      as   integer                     no-undo.
define variable glt_recno   as   recid                       no-undo.
define variable yn          like mfc_logical                 no-undo.
define variable jlnbr       as   integer                     no-undo.
define variable ctrldiff    like ctrl_amt                    no-undo.
define variable action      as   character     format "x(1)" no-undo.
define variable del-yn      as   logical       initial no    no-undo.
define variable l_man_glref like mfc_logical                 no-undo.

define buffer gltdet for glt_det.

/* NEED CURRENCY ROUNDING METHODS FOR GLT_CURR, DISP_CURR & CTRL_CURR */
define            variable disp_rndmthd    like rnd_rnd_mthd no-undo.
define            variable ctrl_amt_old      as character    no-undo.
define            variable ctrl_amt_base_fmt as character    no-undo.
define            variable ctrl_amt_gltc_fmt as character    no-undo.
define            variable tot_amt_old       as character    no-undo.
define            variable tot_amt_base_fmt  as character    no-undo.
define            variable tot_amt_gltc_fmt  as character    no-undo.
define            variable retval            as integer      no-undo.
define            variable rndmthd         like rnd_rnd_mthd no-undo.
define            variable mc-error-number like msg_nbr      no-undo.
define            variable dynew_glt       like new_glt      no-undo.
define            variable l-glcd-clsd       as logical      no-undo.

{&GLTRMTM-P-TAG1}

/* L_DAYBOOK_FLAG INDICATES EXISTING GL TRANSACTION IS HAVING      */
/* A NON-BLANK DAYBOOK CODE                                        */
define variable l_daybook_flag  like mfc_logical no-undo.
define variable l_msg1          as   character   no-undo.

/* ss - 100923.1 -b */
DEFINE VAR v_gltref LIKE glt_ref .
DEFINE VAR v_ref LIKE glt_ref .
DEFINE VAR v_error AS LOGICAL .
DEFINE VAR v_date AS DATE .
DEFINE VAR v_type AS CHAR .  /*1 为小于上一日期，2大于后日期 */
/* ss - 100923.1 -e */

for first gl_ctrl
   fields(gl_rnd_mthd)
   no-lock:
end. /* FOR FIRST gl_ctrl */

disp_curr = (if cash_book
             then
                bank_curr
             else
                getTermLabel("BASE",4)).

if not cash_book
then
   disp_rndmthd = gl_rnd_mthd.
else do:

   /* GET ROUNDING METHOD FROM CURRENCY MASTER */
   {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
      "(input  disp_curr,
        output disp_rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0
   then do:

      run p-disp-msg(input mc-error-number, input 3).
      pause 0.
      leave.
   end. /* IF mc-error-number <> 0 */

end.  /* ELSE DO */

{&GLTRMTM-P-TAG2}

/* GET P/L ACCOUNT CODE */
for first co_ctrl
   fields(co_allow_mod co_enty_bal co_pl co_use_cc co_use_sub)
   no-lock:
end. /* FOR FIRST co_ctrl */

if not available co_ctrl
then do:

   /* CONTROL FILE MUST BE DEFINED BEFORE RUNNING REPORT */
   run p-disp-msg(input 3032, input 3).
   pause.
   leave.

end. /* IF NOT AVAILABLE co_ctrl */

assign
   pl                = co_pl
   use_cc            = co_use_cc
   use_sub           = co_use_sub
   entities_balanced = co_enty_bal
   allow_mod         = co_allow_mod.

release co_ctrl.
       
if not cash_book
then do:

   /* GET MFC_CTRL FIELD co_daily_seq, ADD IF NECESSARY */
   run get-co-daily-seq.

end. /* IF NOT cash_book */

/* GET NAME OF PRIMARY ENTITY */
do transaction:

   /* IF CASH BOOK THEN DEFAULT TO BANK ENTITY */
   if cash_book
   then do:

      for first bk_mstr
         fields(bk_acct bk_cc bk_code bk_entity bk_sub)
         where bk_code = bank_bank
         no-lock:
         entity        = bk_entity.
      end. /* FOR FIRST bk_mstr */
      release bk_mstr.
   end. /* IF cash_book */
   else
      entity = current_entity.

   for first en_mstr
      fields(en_curr en_entity en_name)
      where en_entity = entity
      no-lock:
   end. /* FOR FIRST en_mstr */

   if not available en_mstr
   then do:
      /* NO PRIMARY ENTITY DEFINED */
      run p-disp-msg(input 3059, input 3).
      pause.
      leave.
   end. /* IF NOR AVAILABLE en_mstr */
   else do:
      glname = en_name.
      release en_mstr.
   end. /* ELDE DO */
end. /* DO TRANSACTION */

{&GLTRMTM-P-TAG31}

/* DISPLAY FORM */
/****************************** Add by SS - Micho - 20060709 B ******************************/
/* {gltrfm.i} */
{a6gltrfm.i}
/****************************** Add by SS - Micho - 20060709 B ******************************/

{&GLTRMTM-P-TAG3}

/* INITIALIZE CURRENCY DEPENDENT ROUNDING VARIABLES  */
/* SET CTRL_AMT_BASE_FMT & TOT_AMT_BASE_FMT ONE TIME */
/* CAPTURE ORIGINAL FORMATS INTO _OLD FORMAT FIELDS. */
assign
   ctrl_amt_old      = ctrl_amt:format
   tot_amt_old       = tot_amt:format
   ctrl_amt_base_fmt = ctrl_amt_old
   tot_amt_base_fmt  = tot_amt_old.

{gprun.i ""gpcurfmt.p"" "(input-output ctrl_amt_base_fmt,
                          input gl_rnd_mthd)"}

{gprun.i ""gpcurfmt.p"" "(input-output tot_amt_base_fmt,
                          input gl_rnd_mthd)"}
if type_parm = "YA"
then
   assign
      per_yr:label     = getTermLabel("YEAR",4)
      per_yr:format    = "9999".

mainloop:

repeat:

   if type_parm =  "JL"
   then
      view frame a.
   else
      view frame ya.

   status input.

   /* DELETE ANY HOLDING TRANSACTIONS LEFT */
   run delete-holding-trans.

   /* DISPLAY TRANSACTION IF ALREADY IN DATA BASE */
   for first glt_det
      fields(glt_acct    glt_addr       glt_amt        glt_batch
             glt_cc      glt_correction glt_curr       glt_curr_amt
             glt_date    glt_desc       glt_doc        glt_doc_type
             glt_dy_code glt_dy_num     glt_ecur_amt   glt_effdate
             glt_entity  glt_en_exrate  glt_en_exrate2 glt_en_exru_seq
             glt_error   glt_exru_seq   glt_ex_rate    glt_ex_rate2
             glt_line    glt_project    glt_ref        glt_ex_ratetype
             glt_rflag   glt_sub        glt_tr_type    glt_unb
             glt_user1   glt_user2      glt_userid)
      where glt_ref = l_glt_ref
      no-lock:
   end. /* FOR FIRST glt_det */

   if not available glt_det
   then do:

      if type_parm <> "YA"
      then
         display
            "" @ glt_ref
         with frame a.
      else
         display
            "" @ glt_ref
         with frame ya.
   end. /* IF NOT AVAILABLE glt_det */

   do transaction:

      nrm-seq-num = "".

      if not cash_book
      then
         run get_glt_ref.

      if undo_flag = true
      then
         undo mainloop, leave.

      if not cash_book
      then
         assign
            new_glt     = false
            l_man_glref = false
            dynew_glt   = false
            new_glt_ref = (l_glt_ref <> "")
                           and
                          (not can-find(first glt_det
                           where
                          glt_ref = l_glt_ref )).

      if ( l_glt_ref = "")
      then do:

         if not cash_book
         then do:
            /* GET REFERENCE NUMBER */
             /****************************** Add by SS - Micho - 20060606 B ******************************/
             /*
            if co_daily_seq
            then
               ref = type_parm + substring(string(year(today),"9999"),3,2)
                   + string(month(today),"99") + string(day(today),"99").
            else
               ref = type_parm.
               */
            
            if co_daily_seq
            then
               ref = type_parm + substring(string(year(today),"9999"),3,2)
                   + string(month(today),"99") .
            else
               ref = type_parm.
             /****************************** Add by SS - Micho - 20060606 B ******************************/

            for last glt_det
               fields(glt_acct    glt_addr       glt_amt        glt_batch
                      glt_cc      glt_correction glt_curr       glt_curr_amt
                      glt_date    glt_desc       glt_doc        glt_doc_type
                      glt_dy_code glt_dy_num     glt_ecur_amt   glt_effdate
                      glt_entity  glt_en_exrate  glt_en_exrate2 glt_en_exru_seq
                      glt_error   glt_exru_seq   glt_ex_rate    glt_ex_rate2
                      glt_line    glt_project    glt_ref        glt_ex_ratetype
                      glt_rflag   glt_sub        glt_tr_type    glt_unb
                      glt_user1   glt_user2      glt_userid)
               where glt_ref >= ref
               and glt_ref   <= ref + fill(hi_char,14)
               no-lock:
            end. /* FOR LAST glt_det */

            for last gltr_hist
               fields(gltr_desc gltr_eff_dt gltr_ent_dt gltr_line
                      gltr_ref gltr_tr_type gltr_user)
               where gltr_ref >= ref
               and gltr_ref   <= ref + fill(hi_char,14)
               no-lock:
            end. /* FOR LAST gltr_hist */

            /* IF DAILY */
            if co_daily_seq
            then do:

               /****************************** Add by SS - Micho - 20060606 B ******************************/
               /*
               assign
                  ref   = max(ref + string(0, "999999"),
                          max(if available glt_det
                              then
                                 glt_ref
                              else
                                 "",
                          if available gltr_hist
                          then
                             gltr_ref
                          else
                             ""))
                  jlnbr = 0.
                  */
               assign
                  ref   = max(ref + string(0, "99999999"),
                          max(if available glt_det
                              then
                                 glt_ref
                              else
                                 "",
                          if available gltr_hist
                          then
                             gltr_ref
                          else
                             ""))
                  jlnbr = 0. 
                /****************************** Add by SS - Micho - 20060606 B ******************************/

               do on error undo, leave:
                  /****************************** Add by SS - Micho - 20060606 B ******************************/
                   /*
                  jlnbr = integer(substring(ref,9,6)).
                  */
                  jlnbr = integer(substring(ref,7,8)).
                  /****************************** Add by SS - Micho - 20060606 B ******************************/
               end. /* DO ON ERROR */

               hide message no-pause.

               /****************************** Add by SS - Micho - 20060606 B ******************************/
               /*
               ref = type_parm
                   + substring(string(year(today),"9999"),3,2)
                   + string(month(today),"99")
                   + string(day(today),"99")
                   + string((jlnbr + 1),"999999").
                   */
               ref = type_parm
                   + substring(string(year(today),"9999"),3,2)
                   + string(month(today),"99")
                   + string((jlnbr + 1),"99999999").
               /****************************** Add by SS - Micho - 20060606 B ******************************/
               
            end. /* IF co_daily_seq */

            else do:  /* IF CONTINUOUS */

               assign
                  ref = max(ref + string(0, "999999999999"),
                        max(if available glt_det
                            then
                               glt_ref
                            else
                               "",
                            if available gltr_hist
                            then
                               gltr_ref
                            else
                               ""))
                  jlnbr = 0.

               do ctr_no = 6 to 14:
                  if substring(ref,ctr_no,1)  >= "0"
                  and substring(ref,ctr_no,1) <= "9"
                  then
                     next.
                  else
                     leave.
               end. /* DO ctrl_no = 6 TO 14 */

               if ctr_no = 15
               then
                  do on error undo, leave:

                     jlnbr = integer(substring(ref,6,9)).
               end. /* IF ctrl_no = 15 */

               hide message no-pause.

               /* DUE TO INTEGER LIMITATIONS, CAN ONLY INCREMENT THE */ 
               /* LAST 9 DIGITS OF THE REFERENCE NUMBER              */
               ref = type_parm
                   + substring(ref,3,3)
                   + string(integer(jlnbr + 1),"999999999").

            end. /* IF CONTINUOUS */

            repeat:
               if not can-find(first glt_det
                                  where glt_ref = ref)
               and not can-find(first gltr_hist
                                  where gltr_ref = ref)
               then do:

                  /* CREATE THE HOLDING TRANSACTION (GLT_TR_TYPE = "**") */
                  /* WITH GLT_USERID = MFGUSER (SESSION ID)              */

                  create glt_det.
                  assign
                     glt_ref     = caps(ref)
                     glt_userid  = mfguser
                     {&GLTRMTM-P-TAG34}
                     glt_tr_type = "**".
                  {&GLTRMTM-P-TAG4}

                  if recid(glt_det) = -1
                  then .

                  assign
                     dynew_glt = true
                     new_glt   = true.

                  {gprunp.i "gpaudpl" "p" "set_audit_new" "(input true)"}
                  leave.

               end. /* IF NOT CAN-FIND(FIRST glt_det */

               else do:
                  if co_daily_seq
                  then
                  /****************************** Add by SS - Micho - 20060606 B ******************************/
                      /*
                     ref = substring(ref,1,8)
                         + string(integer (substring(ref,9,6)) + 1, "999999").
                         */
                     ref = substring(ref,1,6)
                         + string(integer (substring(ref,7,8)) + 1, "99999999").
                  /****************************** Add by SS - Micho - 20060606 B ******************************/
                  else
                     ref = substring(ref,1,5)
                        + string(integer (substring(ref,6,9)) + 1, "999999999").
                  {gprunp.i "gpaudpl" "p" "set_audit_new" "(input false)"}
               end. /* ELSE DO */
            end. /* REPEAT */
         end. /* IF NOT cash_book */

         {&GLTRMTM-P-TAG29}
                    
         if type_parm <> "YA"
         then
            display
               ref @ glt_ref
            with frame a.
         else
            display
               ref @ glt_ref
            with frame ya.

         l_glt_ref = ref.
      end. /* IF (INPUT glt_ref = "") */
      {&GLTRMTM-P-TAG32}
      else do:

         /****************************** Add by SS - Micho - 20060709 B ******************************/
         if type_parm <> "YA"
         then
            display
               l_glt_ref @ glt_ref
            with frame a.
         else
            display
               l_glt_ref @ glt_ref
            with frame ya.
         /****************************** Add by SS - Micho - 20060709 E ******************************/

         if (can-find(first glt_det
                      where glt_ref = l_glt_ref )) = false
         then do:

            assign
               new_glt     = true
               l_man_glref = true.

               {gprunp.i "gpaudpl" "p" "set_audit_new" "(input true)"}
         end. /* IF (CAN-FIND(FIRST glt_det ... */
         if not cash_book
         then
            ref = l_glt_ref .

      end. /* ELSE DO */
      {&GLTRMTM-P-TAG33}
   end.  /* TRANSACTION END */

   /* ADDED FIRST PARAMETER WITH THE VALUE OF DATABASE NAME     */
   /* TO AVOID THE DISPLAY OF ERROR AFTER THE USER HAS SWITCHED */
   /* TO A DIFFERENT DATABASE IN MULTI-DB ENVIRONMENT           */
   {gprunp.i "gpaudpl" "p" "initialize"
      "(input ""qaddb"",
        input ""glt_det"",
        input ref)"}

   {gprunp.i "gpaudpl" "p" "set_mode_gl"}

   {&GLTRMTM-P-TAG30}

   do transaction:

      /* ADD/MOD/DELETE */
      assign
         ctrl_amt     = 0
         tot_amt      = 0
         dr_tot       = 0
         ctrl_curr    = base_curr

         /* CTRL_CURR IS NOW SET TO BASE_CURR.  SET ROUNDING METHOD,  */
         /* CTRL_AMT FORMAT & TOT_AMT FORMAT BASED ON THIS ASSIGNMENT */
         ctrl_rndmthd    = gl_rnd_mthd
         ctrl_amt:format = ctrl_amt_base_fmt
         tot_amt:format  = tot_amt_base_fmt.

      for first glt_det
         fields(glt_acct    glt_addr       glt_amt        glt_batch
                glt_cc      glt_correction glt_curr       glt_curr_amt
                glt_date    glt_desc       glt_doc        glt_doc_type
                glt_dy_code glt_dy_num     glt_ecur_amt   glt_effdate
                glt_entity  glt_en_exrate  glt_en_exrate2 glt_en_exru_seq
                glt_error   glt_exru_seq   glt_ex_rate    glt_ex_rate2
                glt_line    glt_project    glt_ref        glt_ex_ratetype
                glt_rflag   glt_sub        glt_tr_type    glt_unb
                glt_user1   glt_user2      glt_userid)
         where glt_ref   = l_glt_ref
         and glt_tr_type <> "**"
         no-lock:
      end. /* FOR FIRST glt_det */

      if not new_glt
      then do:

         {gprunp.i "gpaudpl" "p" "set_audit_new" "(input false)"}
      end. /* IF NOT new_glt */


      if not available glt_det
      then do:
         /* CHECK POSTED TRANSACTIONS FOR SAME REFERENCE */
         if can-find(first gltr_hist
                     where gltr_ref = l_glt_ref )
         then do:

            /* REFERENCE ALREADY IN USE BY A POSTED TRANSACTION */
            run p-disp-msg(input 3066, input 3).
            if cash_book
            then
               leave mainloop.
            else
               undo, next mainloop.
         end. /* IF CAN-FIND(FIRST gltr_hist */

         /* IF CONTINUOUS SEQUENCING DO NOT ALLOW EXTERNAL REFERENCE */
         if l_man_glref
         and not co_daily_seq
         then do:

            /* INVALID TRANSACTION REFERENCE */
            run p-disp-msg(input 3157, input 3).
            undo, next mainloop.
         end. /* IF l_man_glref AND ... */

         if (type_parm = "YA")
         and substring(ref,1,2) <> "YA"
         then do:

            /* CAN ONLY ADD AND MODIFY YA TRANSACTIONS */
            run p-disp-msg(input 3056, input 3).
            undo, next mainloop.
         end. /* IF (type_perm = "YA") .. */
         else
         if (type_parm <> "YA")
         then do:
          
            /****************************** Add by SS - Micho - 20060709 B ******************************/
            /*
            if substring(ref,1,2) <> "JL" 
            then do:

               /* CAN ONLY ADD JL TRANSACTIONS */
               run p-disp-msg(input 3007, input 3).
               undo, next mainloop.
            end. /* IF substring(ref,1,2) <> "JL" */
            */
            if upper(substring(ref,1,2)) <> "JL" 
            then do:

               /* CAN ONLY ADD JL TRANSACTIONS */
               run p-disp-msg(input 3007, input 3).
               undo, next mainloop.
            end. /* IF substring(ref,1,2) <> "JL" */
            /****************************** Add by SS - Micho - 20060709 E ******************************/

         end. /* IF (type_parm <> "YA") */

         /* ADD RECORD. */
         /* ADDING NEW JOURNAL */
         run p-disp-msg(input 3013, input 1).
         tr_type = type_parm.

         /* THIRD PARAMETER CHANGED FROM current_entity TO entity */
         {gprun.i ""gldydft.p"" "(input type_parm,
                                  input """",
                                  input entity,
                                  output dft-daybook,
                                  output daybook-desc)"}
         /* Get GL Period/Year */

         run get-gl-period-year
            (input  eff_dt,
             input  1,
             output per_yr).

         if type_parm <> "YA"
         then
            display
               tr_type
               eff_dt
               per_yr
               ctrl_curr
               ctrl_amt
               tot_amt
               disp_curr
              /****************************** Add by SS - Micho - 20060709 B ******************************/
               v_annex 
              /****************************** Add by SS - Micho - 20060709 B ******************************/
               corr-flag
               dft-daybook
               nrm-seq-num
            with frame a.
         else
            display
               tr_type
               per_yr
               eff_dt
               ctrl_curr
               ctrl_amt
               tot_amt
               disp_curr
               corr-flag
               dft-daybook
               nrm-seq-num
            with frame ya.

         desc1 = "".

         {&GLTRMTM-P-TAG5}
      end. /* IF NOT AVAILABLE glt_det */

      /* AVAILABLE glt_det */
      else do:

         /* CHECK FOR YEAR END TRANSACTIONS */
         if (type_parm   =  "YA")
         and glt_tr_type <> "YA"
         then do:

            /* CAN ONLY ADD AND MODIFY YA TRANSACTIONS */
            run p-disp-msg(input 3056, input 3).
            undo, next mainloop.
         end. /* IF (type_perm = "YA") .. */
         else do:


            /* CHECK FOR YEAR-END OR CONSOLIDATED TRANSACTIONS  */
            if glt_tr_type = "YR"
            or glt_tr_type = "CS"
            then do:

               /* CANNOT MODIFY OR DELETE YR OR CS TRANSACTIONS */
               run p-disp-msg(input 3027, input 3).
               undo, next mainloop.
            end. /* IF glt_tr_type = "YR" */

            /* CHECK FOR RETROACTIVE TRANSACTIONS */
            if glt_tr_type = "RA"
            then do:

               /* MUST USE RETROACTIVE MAINTENANCE TO DELETE OR MODIFY*/
               run p-disp-msg(input 3041, input 3).
               undo, next mainloop.
            end. /* IF glt_tr_type = "RA" */

            /* CHECK FOR REVERSING TRANSACTIONS */
            if glt_tr_type = "RV"
            or glt_tr_type = "R1"
            then do:

               /* MUST USE REVERSING TRANSACTION MAINT TO DELETE OR MODIFY*/
               run p-disp-msg(input 3051, input 3).
               undo, next mainloop.
            end. /* IF glt_tr_type = "RV"... */

            if type_parm <> "YA"
            and glt_tr_type = "YA"
            then do:
               /* MUST USE YEAR END ADJUSTMENT MAINT TO DELETE OR MODIFY */
               {pxmsg.i &MSGNUM=5763 &ERRORLEVEL=3}
               undo, next mainloop.
            end. /* IF type_parm <> "YA" ... */

            /* IF NOT CASH BOOK MAKE SURE REF NOT CREATED WITH CASHBOOK */
            if not cash_book
            then do:

               for first cb_mstr
                  fields(cb_ref cb_type)
                  where cb_ref  = ref
                  and   cb_type = "G"
                  no-lock:

                  /* CREATED WITH CASH BOOK MODIFICATION NOT ALLOWED */
                  run p-disp-msg(input 58, input 3).
                  undo, next mainloop.
               end. /* FOR FIRST cb_mstr */
            end. /* IF NOT cash_book */
         end. /* ELSE DO */

         {&GLTRMTM-P-TAG6}
         /* DISPLAY JOURNAL GENERAL INFORMATION. */
         assign
            tr_type     = glt_tr_type
            eff_dt      = glt_effdate
            /****************************** Add by SS - Micho - 20060709 B ******************************/
             v_annex    = glt_user2
            /****************************** Add by SS - Micho - 20060709 B ******************************/
            dft-daybook = glt_dy_code
            nrm-seq-num = glt_dy_num.

         /* GET GL PERIOD/YEAR */

         run get-gl-period-year
            (input  glt_effdate,
            input  2,
            output per_yr).

         if type_parm <> "YA"
         then
            display
               tr_type
               glt_effdate    @ eff_dt
               per_yr
               base_curr      @ ctrl_curr
               disp_curr
            /****************************** Add by SS - Micho - 20060709 B ******************************/
               glt_user2      @ v_annex
            /****************************** Add by SS - Micho - 20060709 B ******************************/               
               glt_correction @ corr-flag
               dft-daybook
               nrm-seq-num
            with frame a.
         else
            display
               tr_type
               per_yr
               glt_effdate    @ eff_dt
               base_curr      @ ctrl_curr
               disp_curr
               glt_correction @ corr-flag
               dft-daybook
               nrm-seq-num
            with frame ya.


         /* FIND CONTROL CURRENCY */

         /* READ ALL REFERENCED TRANSACTIONS TO CALCULATE TOTAL AND */
         /* CONTROL AMOUNTS. TOT_AMT & CTRL_AMT BOTH REFLECT BASE   */
         /* CURRENCY, SINCE GLT_AMT STORED IN BASE & CTRL_CURR =    */
         /* BASE_CURR                                               */
         if not cash_book
         then do:
            for each glt_det
               fields(glt_acct    glt_addr       glt_amt        glt_batch
                      glt_cc      glt_correction glt_curr       glt_curr_amt
                      glt_date    glt_desc       glt_doc        glt_doc_type
                      glt_dy_code glt_dy_num     glt_ecur_amt   glt_effdate
                      glt_entity  glt_en_exrate  glt_en_exrate2 glt_en_exru_seq
                      glt_error   glt_exru_seq   glt_ex_rate    glt_ex_rate2
                      glt_line    glt_project    glt_ref        glt_ex_ratetype
                      glt_rflag   glt_sub        glt_tr_type    glt_unb
                      glt_user1   glt_user2      glt_userid)
               where glt_ref = ref
               no-lock:

               for first ac_mstr
                  fields(ac_active ac_code ac_curr ac_type)
                  where ac_code = glt_acc
                  no-lock:
               end. /* FOR FIRST ac_mstr */

               /* DON'T COUNT MEMO OR STATISTICAL ACCTS IN TOTAL */
               if available ac_mstr
               and ac_type <> "M"
               and ac_type <> "S"
               then
                  tot_amt = tot_amt + glt_amt.

               else
                  if not available ac_mstr
                  then
                     tot_amt = tot_amt + glt_amt.

               if glt_amt      > 0
               or glt_curr_amt > 0
               then do:

                  if ctrl_curr = base_curr
                  then
                     ctrl_amt = ctrl_amt + glt_amt.

                  else
                  if glt_curr = ctrl_curr
                  or (available ac_mstr
                  and ac_curr = ctrl_curr)
                  then
                     ctrl_amt = ctrl_amt + glt_curr_amt.
               end. /* IF glt_amt > 0 OR glt_curr_amt > 0 */
            end. /* IF glt_amt > 0 */
         end. /* IF NOT cash_book */

         if type_parm <> "YA"
         then
            display
               ctrl_amt
               tot_amt
            with frame a.
         else
            display
               ctrl_amt
               tot_amt
            with frame ya.

         assign
            dr_tot = ctrl_amt
            recno  = recid(glt_det)
            del-yn = no.
      end. /* ELSE DO , IF AVAILABLE glt_det */

      /* ss - 100923.1 -b */
      
      IF SUBSTRING(ref,1,2) = "jl" AND INDEX( "xyz",SUBSTRING(ref,3,1) )  > 0 THEN  DO:
     
   
    /*  IF SUBSTRING(ref,1,2) = "jl"  THEN  DO: */


          v_error = NO .
 
                {gprun.i ""xxgltcheck.p"" 
              "( input  ref,  
              output v_ref , 
              output v_error  )"}
              IF v_error  THEN DO:
                  MESSAGE "凭证不连续,上一个凭证为:"  + v_ref VIEW-AS ALERT-BOX .
                 
              END.
        END.
      /* ss - 100923.1 -e */
   end. /* END OF TRANSACTION */

   /* UPDATE PERIOD, YEAR AND EFFECTIVE DATE. */
   loopb:

   do transaction:

      assign
         ststatus = stline[2]
         del-yn   = no.

      status input ststatus.

      run p-exclusive-lock.

      seta:
      do on error undo, retry:

         if not cash_book
         then do:

            {&GLTRMTM-P-TAG10}

            allow-gaps = no.

            if daybooks-in-use
            and dft-daybook > ""
            then do:

               {gprunp.i "nrm" "p" "nr_can_void"
                  "(input dft-daybook,
                    output allow-gaps)"}

               if new_glt
               then
                  l_daybook_flag = yes.

               if not can-find (dy_mstr
               where dy_dy_code = dft-daybook)
               then
                  allow-gaps = yes.
               else
               if not can-find (nr_mstr
               where nr_seqid = dft-daybook)
               and l_daybook_flag
               then
                  allow-gaps = yes.

            end. /* IF daybooks-in-use & dft-daybook ISN'T BLANK */

            /* ELSE PART IS ADDED SO THAT IF BLANK DAYBOOK IS  */
            /* ENTERED WHILE MODIFYING EXISTING GL TRANSACTION */
            /* THEN DAYBOOK FIELD SHOULD BE GIVEN ACCESS       */
            else
            if daybooks-in-use
            and dft-daybook = ""
            and l_daybook_flag
            then
               allow-gaps = yes.

            {&GLTRMTM-P-TAG11}
            if type_parm <> "YA"
            then do:
              /* ss - 100923.1 -b
               set
                  eff_dt
                  when (allow_mod
                        or substring(ref,1,2) = "JL")
                  ctrl_curr
                  when (allow_mod
                        or substring(ref,1,2) = "JL")
                  dft-daybook
                  when (daybooks-in-use
                        and (new_glt
                        or  allow-gaps
                        or  new_glt_ref)
                        and (allow_mod
                        or  substring(ref,1,2) = "JL"))
            /****************************** Add by SS - Micho - 20060709 B ******************************/
                  v_annex when (allow_mod OR substring(ref,1,2) = "JL")
            /****************************** Add by SS - Micho - 20060709 B ******************************/
                  corr-flag
                  when (substring(ref,1,2) = "JL")
                  go-on("F5" "CTRL-D") with frame a.
                  ss - 100923.1 -e */
                /* ss - 100923.1 -b */
                  set
                  eff_dt
                  when (allow_mod
                        or substring(ref,1,2) = "JL") WITH FRAME a .
               
                                 
              IF SUBSTRING(ref,1,2) = "jl" AND INDEX( "xyz",SUBSTRING(ref,3,1) )  > 0 THEN  DO:
             /*
              IF SUBSTRING(ref,1,2) = "jl"  THEN  DO:
              */
                          v_error = NO .
                   
                                 {gprun.i ""xxgltdate.p"" 
                                  "( input  ref,
                                      INPUT eff_dt,
                                  output v_date , 
                                  output v_error  ,
                                  OUTPUT v_type )"}

                              IF v_error  THEN DO:
                                  IF v_type = "1"  THEN 
                                  MESSAGE "小于上一凭证日期"    +  string( v_date) VIEW-AS ALERT-BOX  .
                                  ELSE 
                                     MESSAGE "大于下一凭证日期"    +  string( v_date) VIEW-AS ALERT-BOX  .
                                  
                                  NEXT-PROMPT  eff_dt  with frame a.
                                  UNDO ,RETRY .
                              END.
                       END.
                /* ss - 100923.1 -e */

                      /* ss - 100923.1 -b */
                        set
                
                          ctrl_curr
                          when (allow_mod
                                or substring(ref,1,2) = "JL")
                          dft-daybook
                          when (daybooks-in-use
                                and (new_glt
                                or  allow-gaps
                                or  new_glt_ref)
                                and (allow_mod
                                or  substring(ref,1,2) = "JL"))
                    /****************************** Add by SS - Micho - 20060709 B ******************************/
                          v_annex when (allow_mod OR substring(ref,1,2) = "JL")
                    /****************************** Add by SS - Micho - 20060709 B ******************************/
                          corr-flag
                          when (substring(ref,1,2) = "JL")
                          go-on("F5" "CTRL-D") with frame a.
                      /* ss - 100923.1 -e */
            end. /* IF type_parm <> "YA" */
            else do:
               set
                  per_yr
                  when (allow_mod
                     or substring(ref,1,2) = "YA")
                  ctrl_curr
                  when (allow_mod
                        or type_parm       = "YA")
                  dft-daybook
                  when (daybooks-in-use
                     and (new_glt
                     or  allow-gaps
                     or  new_glt_ref)
                     and allow_mod)
                  corr-flag
                  go-on("F5" "CTRL-D") with frame ya.
            end. /* ELSE-DO: */


            if type_parm <> "YA"
            and (allow_mod
            or substring(ref,1,2) = "JL")
            then do:

               if eff_dt = ?
               then do:
                  eff_dt = today.
                  display
                     eff_dt
                  with frame a.
               end. /* IF eff_dt = ? */
            end. /* IF type_parm <> "YA" AND ... */

         end. /* IF NOT cash_book */
         else
            assign
               del_cb    = no
               ctrl_amt  = bank_ctrl
               eff_dt    = bank_date
               ctrl_curr = bank_curr.

         {&GLTRMTM-P-TAG39}

         /* GET ROUNDING METHOD FROM CURRENCY MASTER */
         {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
            "(input ctrl_curr,
              output ctrl_rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0
         then do:

            run p-disp-msg(input mc-error-number, input 3).
            if type_parm <> "YA"
            then
               next-prompt
                  ctrl_curr
               with frame a.
            else
               next-prompt
                  ctrl_curr
               with frame ya.

            undo, retry seta.
         end. /* IF mc-error-number <> 0 */

         /* CALL GPCURFMT.P FOR NEW CTRL CURRENCY FORMAT */
         ctrl_amt_gltc_fmt = ctrl_amt_old.

         {gprun.i ""gpcurfmt.p"" "(input-output ctrl_amt_gltc_fmt,
                                   input ctrl_rndmthd)"}

         ctrl_amt:format = ctrl_amt_gltc_fmt.

         if not cash_book
         then do:

            /* READ ALL REFERENCED TRANSACTIONS TO CALCULATE */
            /* CONTROL AMOUNTS                               */
            ctrl_amt = 0.

            for each glt_det
               fields(glt_acct    glt_addr       glt_amt        glt_batch
                      glt_cc      glt_correction glt_curr       glt_curr_amt
                      glt_date    glt_desc       glt_doc        glt_doc_type
                      glt_dy_code glt_dy_num     glt_ecur_amt   glt_effdate
                      glt_entity  glt_en_exrate  glt_en_exrate2 glt_en_exru_seq
                      glt_error   glt_exru_seq   glt_ex_rate    glt_ex_rate2
                      glt_line    glt_project    glt_ref        glt_ex_ratetype
                      glt_rflag   glt_sub        glt_tr_type    glt_unb
                      glt_user1   glt_user2      glt_userid)
               where glt_ref = ref
               no-lock:

               if glt_amt      > 0
               or glt_curr_amt > 0
               then do:

                  if ctrl_curr = base_curr
                  then
                     ctrl_amt = ctrl_amt + glt_amt.
                  else
                  if glt_curr = ctrl_curr
                     or (available ac_mstr
                     and ac_curr = ctrl_curr)
                  then
                     ctrl_amt = ctrl_amt + glt_curr_amt.
               end. /* IF glt_amt > 0 OR ..*/
            end. /* FOR EACH glt_det */

            if type_parm <> "YA"
            then
               display
                  ctrl_amt
               with frame a.
            else
               display
                  ctrl_amt
               with frame ya.

            dr_tot = ctrl_amt.
         end. /* IF NOT cash_book */
         else if type_parm <> "YA"
         then
            display
               eff_dt
               per_yr
               ctrl_curr
               ctrl_amt
            /****************************** Add by SS - Micho - 20060709 B ******************************/
                  v_annex 
            /****************************** Add by SS - Micho - 20060709 B ******************************/
            with frame a.
         else
            display
               per_yr
               eff_dt
               ctrl_curr
               ctrl_amt
            with frame ya.

         /* DELETE */
         if lastkey = keycode("F5")
         or lastkey = keycode("CTRL-D")
         then do:

            del-yn = yes.

            /* CONFIRM DELETE */
            {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn
                     &CONFIRM-TYPE='LOGICAL'}

            if del-yn = no
            then
               undo seta.
         end. /* IF LASTKEY = keycode("F5") */

         if del-yn
         and not allow-gaps
         and daybooks-in-use
         then do:

            /* SEQUENCE DOES NOT ALLOW GAPS */
            run p-disp-msg(input 1349, input 3).
            if type_parm <> "YA"
            then
               next-prompt
                  eff_dt
               with frame a.
            else
               next-prompt
                  per_yr
               with frame ya.

            undo seta.
         end. /* IF del-yn AND NOT allow-gaps */

         if del-yn
         and (type_parm = "YA"
         or allow_mod
         or substring(ref,1,2) = "JL")
         then do:

            {pxmsg.i &MSGNUM=4106 &MSGBUFFER=l_msg1}

            if daybooks-in-use
            then do:
               {gprunp.i "nrm" "p" "nr_void_value"
                  "(input dft-daybook,
                    input nrm-seq-num,
                    input l_msg1)"}
            end. /* IF daybooks-in-use */

            run ip-glt-del.

            /* ADD VOID RECORD IF CONTINUOUS SEQUENCING */
            if not co_daily_seq
            then do:
               create gltr_hist.
               assign
                  gltr_ref     = caps(ref)
                  gltr_line    = 0
                  gltr_desc    = "VOID"
                  gltr_ent_dt  = today
                  gltr_eff_dt  = today
                  gltr_tr_type = substring(ref, 1, 2)
                  gltr_user    = global_userid.

               {&GLTRMTM-P-TAG7}

               if recid(gltr_hist) = -1
               then .
            end. /* IF NOT co_daily_seq */

            /* DO: END BLOCK IS REQUIRED FOR GUI -- DO NOT REMOVE */
            if type_parm <> "YA"
            then do:
               clear frame a.
            end. /* IF type_parm <> "YA" */
            else do:
               clear frame ya.
            end. /* ELSE DO */

            del-yn = no.
            if cash_book
            then
               leave mainloop.
            else
               next mainloop.
         end. /* IF del-yn */

         /* VALIDATE PERIOD AND YEAR */
         if type_parm = "YA"
         then do:

            for first glc_cal
               fields(glc_end glc_per glc_start glc_year)
               where glc_year = integer(per_yr)
               no-lock:
            end. /* FOR FIRST glc_cal */

            if not available glc_cal
            then do:

               /* INVALID YEAR */
               run p-disp-msg(input 3019, input 3).
               next-prompt
                  per_yr
               with frame ya.
               undo seta, retry.
            end. /* IF NOT AVAILABLE glc_cal */

            for last glc_cal
               fields(glc_end glc_per glc_start glc_year)
               where glc_year = integer(per_yr)
               no-lock:
            end. /* FOR LAST glc_cal */

            if available glc_cal
            then
               assign
                  eff_dt = glc_end
                  per_yr = string(glc_per)
                         + "/"
                         + string(glc_year).

            display
               eff_dt
            with frame ya.
         end. /* IF type_parm = "YA" */
         else do:

            /* Get GL Period/Year */
            run get-gl-period-year
               (input eff_dt,
                input 0,
                output per_yr).

            if per_yr = ""
            then do:

               /* INVALID PERIOD/YEAR */
               run p-disp-msg(input 3008, input 3).
               next-prompt
                  eff_dt
               with frame a.
               undo seta, retry.
            end. /* IF per_yr = "" */

            display
               per_yr
            with frame a.
         end. /* IF type_parm <> "YA" */

         /* VALIDATE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
            "(input ctrl_curr,
              output mc-error-number)"}

         if mc-error-number <> 0
         then do:

            run p-disp-msg(input mc-error-number, input 3).

            if type_parm <> "YA"
            then
               next-prompt
                  ctrl_curr
               with frame a.
            else
               next-prompt
                  ctrl_curr
               with frame ya.

            undo, retry seta.
         end. /* IF mc-error-number <> 0 */

         /* VALIDATE DAYBOOK */
         if (daybooks-in-use
         and (new_glt
           or allow-gaps
           or new_glt_ref)
         and (type_parm = "YA"
           or allow_mod
           or substring(ref,1,2)="JL"))
         then do:

            run dbk_valid.

            if undo_flag
            then do:
               if type_parm <> "YA"
               then
                  next-prompt
                     dft-daybook
                  with frame a.
               else
                  next-prompt
                     dft-daybook
                  with frame ya.

               undo seta, retry.
            end. /* IF undo_flag */

         end. /* IF (daybooks-in-use and .... */

         new_glt = false.

         /* UPDATE ALL REFERENCE TRANSACTION IF EFFECTIVE DATE HAS */
         /* BEEN MODIFIED.                                         */

         if (type_parm = "YA"
             and frame ya per_yr entered)
         or (type_parm = "JL"
             and frame a eff_dt entered)
         then do:

            for each glt_det
               where glt_ref    =  ref
               and glt_tr_type <> "**":

               /* CHECK FOR CLOSED PERIODS */
               run check-closed-period
                  (input  eff_dt,
                  input  glt_entity,
                  output per_yr,
                  output l-glcd-clsd).

               if l-glcd-clsd
               then do:

                  if type_parm <> "YA"
                  then
                     next-prompt
                        eff_dt
                     with frame a.
                  else
                     next-prompt
                        per_yr
                     with frame ya.

                  undo seta, retry.
               end. /* IF l-glcd-clsd */

               {&GLTRMTM-P-TAG12}

               {gprunp.i "gpaudpl" "p" "set_search_key"
                  "(input glt_det.glt_ref + ""."" +
                    string(glt_det.glt_line))"}

               {gprunp.i "gpaudpl" "p" "save_before_image"
                  "(input rowid(glt_det))"}

               glt_effdate = eff_dt.

               {gprunp.i "gpaudpl" "p" "audit_record_change"}

               {&GLTRMTM-P-TAG13}

               release glt_det.

            end. /* FOR EACH glt_det */

         end. /* IF eff_dt ENTERED */

         /* SS - 20080424.1 - B */
         /*
         if corr-flag entered
         then do:

            for each glt_det
               where glt_ref     =  ref
               and   glt_tr_type <> "**"
               exclusive-lock:

               {&GLTRMTM-P-TAG14}

               {gprunp.i "gpaudpl" "p" "set_search_key"
                  "(input glt_det.glt_ref + ""."" +
                    string(glt_det.glt_line))"}

               {gprunp.i "gpaudpl" "p" "save_before_image"
                  "(input rowid(glt_det))"}

               glt_correction = corr-flag.

               {gprunp.i "gpaudpl" "p" "audit_record_change"}

               {&GLTRMTM-P-TAG15}

               release glt_det.

            end. /* FOR EACH glt_det */

         end. /* corr-flag ENTERED */
         */
         /* SS - 20080424.1 - E */

         /* SETA */

         updt_ctrl:
         do on error undo, retry:

            if not cash_book
            then do:
               if type_parm = "JL"
               then
                  if allow_mod
                  then
                     update
                        ctrl_amt
                     with frame a.
                  else if substring(ref,1,2) = "JL"
                  then
                     update
                        ctrl_amt
                     with frame a.

               update
                  ctrl_amt
                  when (type_parm = "YA")
               with frame ya.

               /* VALIDATE CTRL_AMT TO CURRENCY ROUNDING METHOD */
               if (ctrl_amt <> 0)
               then do:

                  {gprun.i ""gpcurval.p"" "(input ctrl_amt,
                                            input ctrl_rndmthd,
                                            output retval)"}
                  if retval <> 0
                  then do:

                      if type_parm <> "YA"
                      then
                         next-prompt
                            ctrl_amt
                         with frame a.
                      else
                         next-prompt
                            ctrl_amt
                         with frame ya.

                     undo updt_ctrl, retry updt_ctrl.
                  end. /* IF retval <> 0 */
               end. /* IF ctrl_amt  <> 0 */
            end. /* IF NOT cash_book */
         end. /* updt_ctrl */

      end. /* SETA */

    /****************************** Add by SS - Micho - 20060709 B ******************************/
    /* MESSAGE ref VIEW-AS ALERT-BOX. */
    FOR EACH glt_det WHERE glt_ref = ref :
        /* MESSAGE v_annex VIEW-AS ALERT-BOX. */
        ASSIGN 
            glt_user2 = v_annex 
            .
    END.
   /****************************** Add by SS - Micho - 20060709 B ******************************/

      setdist:
      repeat:

         /* ENTER LINE ITEMS */
         /****************************** Add by SS - Micho - 20060424 B ******************************/ 
         {gprun.i ""a6gltrmta.p"" "(input type_parm)"}
         /****************************** Add by SS - Micho - 20060424 E ******************************/ 

         /* CHECK CONTROL AMOUNT */
         if not cash_book
         then
            repeat:

               if dr_tot <> ctrl_amt
               then do:

                  /* DEBIT TOTAL <> CONTROL AMOUNT */
                  run p-disp-msg(input 3010, input 2).
                  if not batchrun
                  then
                     pause.
               end. /* IF dr_tot <> ctrl_amt */
               leave.
         end. /* IF NOT cash_book */

         if cash_book
         then do:

            if tot_amt <> ctrl_amt
            then
               do on endkey undo, retry:

                  assign
                     ctrldiff = ctrl_amt - tot_amt
                     action   = "2".

                  bell.

                  action_block:
                  do on endkey undo, retry:
                     input clear.

                     {pxmsg.i &MSGNUM=1163 &ERRORLEVEL=1 &MSGARG1=ctrl_amt
                         &MSGARG2=tot_amt &MSGARG3=ctrldiff}

                     /*V8-*/
                     {pxmsg.i &MSGNUM=1721 &ERRORLEVEL=1 &CONFIRM=action}
                     /*V8+*/

                     /*V8!

                     /* ADDED NEW INPUT PARAMETERS */
                     {gprun.i ""gpaecupd.p"" "(input-output action,
                                             input 1721,
                                             input getTermLabel('&Accept', 9),
                                             input getTermLabel('&Edit', 9),
                                             input getTermLabel('&Cancel', 9))"}
                     */

                     if action = "2"
                     then
                        next setdist.
                     else
                     if action = "3"
                     then
                        undo mainloop, leave.
                     else
                     if action <> "1"
                     then
                        undo action_block, retry.
                  end. /* DO ON endkey undo, retry */

               end. /* DO ON endkey undo, retry */
         end. /* IF cash_book */

    /****************************** Add by SS - Micho - 20060606 B ******************************/
    if tot_amt <> 0 and not cash_book then do: 
           /* JOURNAL ENTRY OUT OF BALANCE.  TOTAL <> 0. */
           {pxmsg.i &MSGNUM=3011 &ERRORLEVEL=3}
            /* UNDO setdist ,RETRY. */
            NEXT setdist.
           
    END.
   /****************************** Add by SS - Micho - 20060606 E ******************************/

         leave setdist.
      end. /* SETDIST */

      /* CHECK TOTAL AMOUNT */
      repeat:

         assign
            ent_flag  = no
            tot_flag  = no.

         if tot_amt <> 0
         and not cash_book
         then do:

            tot_flag = yes.
            
            /****************************** Add by SS - Micho - 20060606 B ******************************/
             /*
            /* JOURNAL ENTRY OUT OF BALANCE.  TOTAL <> 0. */
            {pxmsg.i &MSGNUM=3011 &ERRORLEVEL=2}
            */
            /****************************** Add by SS - Micho - 20060606 E ******************************/

            if not batchrun
            then
               pause.

         end. /* IF tot_amt <> 0 */

         else do:

            for each glt_det
               where glt_ref = ref
               exclusive-lock:

               {gprunp.i "gpaudpl" "p" "set_search_key"
                  "(input glt_det.glt_ref + ""."" +
                  string(glt_det.glt_line))"}

               {gprunp.i "gpaudpl" "p" "save_before_image"
                  "(input rowid(glt_det))"}

               assign
                  glt_unb   = no
                  glt_error = "".

               {gprunp.i "gpaudpl" "p" "audit_record_change"}

            end. /* FOR EACH glt_det */

            /* CHECK FOR INVALID ACCOUNT/COST CENTERS */
            run ip-invalid-acc.

            if inv_flag = yes
            then do:

               /* ENTRY MARKED OUT OF BALANCED */
               /* -- INVALID ACC/COST CENTER   */
               {pxmsg.i &MSGNUM=3030 &ERRORLEVEL=2}

               if not batchrun
               then
                  pause.

            end. /* IF inv_flag = YES */

            else
            /* WILL ALWAYS BALANCE FOR CASH BOOK */
            if not cash_book
            then do:

               /* CHECK FOR BALANCED ENTITIES IF NOT CENTRALIZED */

               if entities_balanced
               then do:

                  {gprunp.i "gpglpl" "p" "gpgl-check-bal-entities"
                     "(input  ref,
                       output mc-error-number)"}

                  if mc-error-number <> 0
                  then do:

                     ent_flag = yes.

                     /* ENTITIES OUT OF BALANCE */
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     if not batchrun
                     then
                        pause.
                  end. /* IF mc-error-number <> 0 */

               end. /* IF entities_balanced */

            end. /* ELSE IF NOT cash_book */

         end. /* ELSE DO */

         leave.
      end. /* REPEAT: CHECK TOTAL AMOUNT */

      if tot_flag = yes
      then do:

         for each glt_det
            where glt_ref = ref
            exclusive-lock:

            {&GLTRMTM-P-TAG18}

            {gprunp.i "gpaudpl" "p" "set_search_key"
               "(input glt_det.glt_ref + ""."" +
                 string(glt_det.glt_line))"}

            {gprunp.i "gpaudpl" "p" "save_before_image"
               "(input rowid(glt_det))"}

            assign
               glt_error = getTermLabel("UNBALANCED",16)
               glt_unb   = yes.

            {gprunp.i "gpaudpl" "p" "audit_record_change"}

            {&GLTRMTM-P-TAG19}
         end. /* FOR EACH glt_det */
      end. /* IF tot_flag = yes */
      else do:

         if ent_flag = yes
         then do:

            for each glt_det
               where glt_ref = ref
               exclusive-lock:

               {&GLTRMTM-P-TAG20}
               {gprunp.i "gpaudpl" "p" "set_search_key"
                  "(input glt_det.glt_ref + ""."" +
                    string(glt_det.glt_line))"}

               {gprunp.i "gpaudpl" "p" "save_before_image"
                  "(input rowid(glt_det))"}

               assign
                  glt_error = getTermLabel("UNB_ENTITIES",16)
                  glt_unb   = yes.

               {gprunp.i "gpaudpl" "p" "audit_record_change"}
               {&GLTRMTM-P-TAG21}
            end. /* FOR EACH glt_det */
         end. /* IF ent_flag = yes */
         else
         if inv_flag = yes
         then do:

            for each glt_det
               where glt_ref = ref
               exclusive-lock:

               {&GLTRMTM-P-TAG22}
               {gprunp.i "gpaudpl" "p" "set_search_key"
                  "(input glt_det.glt_ref + ""."" +
                    string(glt_det.glt_line))"}

               {gprunp.i "gpaudpl" "p" "save_before_image"
                  "(input rowid(glt_det))"}

               glt_unb = yes.

               {gprunp.i "gpaudpl" "p" "audit_record_change"}
               {&GLTRMTM-P-TAG23}
            end. /* FOR EACH glt_det */
         end. /* IF inv_flag = yes */
      end. /* ELSE DO */

      /* MOVED FROM ABOVE, SO THAT IT DOES NOT LOCK nr_mstr */
      /* UNTIL THE ENTIRE TRANSACTION IS COMPLETED.         */
      if dft-daybook entered
      and not dynew_glt
      then do:

         for first glt_det
            fields(glt_ref glt_dy_code glt_dy_num)
            where glt_ref = ref
            no-lock:

         end. /* FOR FIRST glt_det */

         if available glt_det
         and dft-daybook <> glt_dy_code
         then do:

            {gprunp.i "nrm" "p" "nr_void_value"
               "(input glt_dy_code,
                 input glt_dy_num,
                 input getTermLabel('STD_TRANS_MAINT_CHANGED_DAYBOOK',45))"}

            /* CHANGED SECOND INPUT PARAMETER FROM today TO eff_dt */
            {gprunp.i "nrm" "p" "nr_dispense"
               "(input dft-daybook,
                 input eff_dt,
                 output nrm-seq-num)"}

         if type_parm <> "YA"
         then
            display
               nrm-seq-num
            with frame a.
         else
            display
               nrm-seq-num
            with frame ya.

            for each glt_det
               where glt_ref   = ref
               and glt_tr_type <> "**"
               exclusive-lock:

               {&GLTRMTM-P-TAG24}
               {gprunp.i "gpaudpl" "p" "set_search_key"
                  "(input glt_det.glt_ref + ""."" +
                    string(glt_det.glt_line))"}

               {gprunp.i "gpaudpl" "p" "save_before_image"
                  "(input rowid(glt_det))"}

               assign
                  glt_dy_code = dft-daybook
                  glt_dy_num  = nrm-seq-num.

               {gprunp.i "gpaudpl" "p" "audit_record_change"}
               {&GLTRMTM-P-TAG25}

            end. /* FOR EACH GLT_DET */
         end. /* IF AVAILABLE GLT_DET AND ... */
      end. /* IF DFT-DAYBOOK ENTERED AND ... */

      /* ASSIGN A SEQUENCE NUMBER FROM NRM IF NEEDED. */
      nrm-seq-num = "".
      if daybooks-in-use
         and can-find(first glt_det
         where glt_ref     =  ref
         and   glt_tr_type <> "**"
         and   glt_dy_num  =  "")
      then do:

         for first glt_det
            fields(glt_acct    glt_addr       glt_amt        glt_batch
                   glt_cc      glt_correction glt_curr       glt_curr_amt
                   glt_date    glt_desc       glt_doc        glt_doc_type
                   glt_dy_code glt_dy_num     glt_ecur_amt   glt_effdate
                   glt_entity  glt_en_exrate  glt_en_exrate2 glt_en_exru_seq
                   glt_error   glt_exru_seq   glt_ex_rate    glt_ex_rate2
                   glt_line    glt_project    glt_ref        glt_ex_ratetype
                   glt_rflag   glt_sub        glt_tr_type    glt_unb
                   glt_user1   glt_user2      glt_userid)
            where glt_ref     =  ref
            and   glt_tr_type <> "**"
            and   glt_dy_num  <> ""
            no-lock:
         end. /* FOR FIRST glt_det */

         if available glt_det
         then
            nrm-seq-num = glt_dy_num.
         else do:
            /* CHANGED SECOND INPUT PARAMETER FROM today TO eff_dt */
            {gprunp.i "nrm" "p" "nr_dispense"
               "(input dft-daybook,
                 input eff_dt,
                 output nrm-seq-num)"}
         end. /* ELSE DO */

         if type_parm <> "YA"
         then
            display
               nrm-seq-num
            with frame a.
         else
            display
               nrm-seq-num
            with frame ya.

         /* ASSIGN THIS SEQUENCE NUMBER TO ALL LINES. */

         ASSIGN-SEQ-BLOCK:
         for each glt_det
            where glt_ref     =  ref
            and   glt_tr_type <> "**"
            and   glt_dy_num  =  ""
            exclusive-lock:

            {&GLTRMTM-P-TAG26}
            {gprunp.i "gpaudpl" "p" "set_search_key"
               "(input glt_det.glt_ref + ""."" +
                 string(glt_det.glt_line))"}

            {gprunp.i "gpaudpl" "p" "save_before_image"
               "(input rowid(glt_det))"}

            glt_dy_num = nrm-seq-num.

            {gprunp.i "gpaudpl" "p" "audit_record_change"}
            {&GLTRMTM-P-TAG27}

         end. /* FOR EACH glt_det (ASSIGN-SEQ-BLOCK) */
      end. /* IF daybooks-in-use */

   end. /* END TRANSACTION */

   /* DELETE HOLDING TRANSACTION */
   if not cash_book
   then

      do transaction:

         find glt_det
            where glt_tr_type = "**"
            and   glt_ref     = ref
            exclusive-lock
            no-error.

         /* DELETE ANY RELATED EXCHANGE RATE USAGE RECORDS */
         if available glt_det
         then do:

            {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
               "(input glt_det.glt_exru_seq)"}

            {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
               "(input glt_det.glt_en_exru_seq)"}

            delete glt_det.
         end. /* IF AVAILABLE glt_det */
      end. /* DO TRANSACTION */

   if cash_book
   then
      leave mainloop.
end. /* END OF MAINLOOP */

/* DELETE ANY HOLDING TRANSACTIONS LEFT */
run delete-holding-trans.

/* IF CASH BOOK THEN CREATE NEW OFFSETTING LINE FOR BANK'S CASH ACCOUNT */
if cash_book
then
   hide frame a no-pause.

if cash_book
and not del_cb
then do:

   assign
      bank_ctrl = tot_amt
      b_batch   = ref.

   hide frame a no-pause.

   do transaction:

      for first bk_mstr
         fields(bk_acct bk_cc bk_code bk_entity bk_sub)
         where bk_code = bank_bank
         no-lock:

      end. /* FOR FIRST bk_mstr */

      /* FOR CASH BOOK, HOLDING TRANSACTION (GLT_TR_TYPE = "**") IS      */
      /* DELETED IN CMBKMTA.P AFTER THE EXECUTION OF GLTRMTM.P AND HENCE */
      /* EXCLUDE "**"                                                    */

      for each gltdet
         where gltdet.glt_ref     =  ref
         and   gltdet.glt_tr_type <> "**"
         break by gltdet.glt_line:

         if first(gltdet.glt_line)
         then do:

            create glt_det.

            run build_glt_det.
            {&GLTRMTM-P-TAG8}
            {gprunp.i "mcpl" "p" "mc-copy-ex-rate-usage"
               "(input gltdet.glt_exru_seq,
                 output glt_det.glt_exru_seq)"}

            if recid(glt_det) = -1
            then .

            {gprunp.i "gpaudpl" "p" "set_search_key"
               "(input glt_det.glt_ref + ""."" +
                 string(glt_det.glt_line))"}
         end. /* IF FIRST glt_det */

         for first ac_mstr
            fields(ac_active ac_code ac_curr ac_type)
            where ac_code = gltdet.glt_acc
            no-lock:

         end. /* FOR FIRST ac_mstr */

         /* IGNORE AMOUNTS IN MEMO OR STATISTICAL ACCOUNTS */
         if available ac_mstr
         and (ac_type <> "M"
         and  ac_type <> "S")
         then do:

            assign
               glt_det.glt_curr_amt = glt_det.glt_curr_amt
                                    - gltdet.glt_curr_amt
               glt_det.glt_amt      = glt_det.glt_amt
                                    - gltdet.glt_amt.
         end. /* IF AVAILABLE ac_mstr */
         else
         if not available ac_mstr
         then
            assign
               glt_det.glt_curr_amt = glt_det.glt_curr_amt
                                    - gltdet.glt_curr_amt
               glt_det.glt_amt      = glt_det.glt_amt
                                    - gltdet.glt_amt.

         if last(gltdet.glt_line)
         then
            glt_det.glt_line = gltdet.glt_line + 1.

         for first en_mstr
            fields(en_curr en_entity en_name)
            where en_entity = glt_entity
            no-lock:

            if glt_curr = en_curr
            then
               assign
                  glt_ecur_amt   = glt_curr_amt
                  glt_en_exrate  = 1
                  glt_en_exrate2 = 1.
            else
            if en_curr = base_curr
            then
               assign
                  glt_ecur_amt    = glt_amt
                  glt_en_exrate   = glt_ex_rate
                  glt_en_exrate2  = glt_ex_rate2
                  glt_en_exru_seq = glt_exru_seq.
         end. /* FOR FIRST en_mstr */

         if last(gltdet.glt_line)
         then do:

            {gprunp.i "gpaudpl" "p" "audit_record_addition"
               "(input rowid(glt_det))"}
         end. /* IF LAST(gltdet.glt_line) */

      end. /* FOR EACH GLTDET */
   end. /* DO TRANSACTION */
end. /* IF CASH_BOOK AND NOT del_db */

/* END PATCH */

status input.

undo_all = no.
{&GLTRMTM-P-TAG9}

/* ADDED THE FOLLOWING PROCEDURES. THE ARE SIMILAR TO, BUT NOT */
/* THE SAME AS, THOSE THAT WERE FOUND IN glrvmt.p ON 06/24/99. */
/*---------------------------------------------------------------------------*/

PROCEDURE get_glt_ref:

   undo_flag = true.

   if type_parm = "JL"
   then do:

      prompt-for
         glt_ref
         with frame a
      editing:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i glt_det glt_ref glt_ref glt_ref glt_ref
            glt_ref }

         if recno <> ?
         then do:

            /* Get GL Period/Year */

            run get-gl-period-year
               (input  glt_effdate,
                input  2,
                output per_yr).

            display
               glt_ref
               glt_tr_type    @ tr_type
               glt_effdate    @ eff_dt
               per_yr
               base_curr      @ ctrl_curr
               disp_curr
            /****************************** Add by SS - Micho - 20060709 B ******************************/
               glt_user2        @ v_annex
            /****************************** Add by SS - Micho - 20060709 B ******************************/
               glt_correction @ corr-flag
               glt_dy_code    @ dft-daybook
               glt_dy_num     @ nrm-seq-num
            with frame a.

            recno = ?.

            if glt_dy_code <> ""
            and can-find (nr_mstr
            where nr_seqid = glt_dy_code)
            then
               l_daybook_flag = yes.
            else
               l_daybook_flag = no.

         end. /* IF recno <> ? */

      end.  /* PROMPT-FOR glt_ref EDITING */

      assign
         undo_flag = false
         l_glt_ref = input frame a glt_ref.

      /****************************** Add by SS - Micho - 20060709 B ******************************/
       IF l_glt_ref <> "" AND (upper(l_glt_ref) = "JLX" OR UPPER(l_glt_ref) = "JLY" 
                               OR UPPER(l_glt_ref) = "JLZ") THEN DO:
           DEF VAR v_year AS CHAR .
           DEF VAR v_per  AS CHAR .
    
           FIND FIRST glcd_det WHERE glcd_gl_clsd = NO NO-LOCK NO-ERROR.
           IF AVAIL glcd_det THEN DO:
               ASSIGN 
                   v_year = STRING(glcd_year) 
                   v_per  = fill('0' ,2 - length(string(glcd_per))) + string(glcd_per)
                   .
           END.
    
           FIND LAST glt_det WHERE substring(glt_ref,1,3) = upper(l_glt_ref) 
                               AND SUBSTRING(glt_ref,4,4) = v_year 
                               AND SUBSTRING(glt_ref,8,2) = v_per  NO-LOCK NO-ERROR.
           IF AVAIL glt_det THEN DO:
               ASSIGN
                   l_glt_ref = SUBSTRING(glt_ref,1,9) + string(int(SUBSTRING(glt_ref,10,5)) + 1,"99999")  
                   .
           END.
           ELSE DO:
               ASSIGN
                   l_glt_ref = upper(l_glt_ref) + v_year + v_per + STRING(1,"99999")
                   .
           END.
       END.
      /****************************** Add by SS - Micho - 20060709 E ******************************/

   end. /* IF type_parm = "JL" */
   else do:
      undo_flag = true.

      prompt-for
         glt_ref
         with frame ya
      editing:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp05.i glt_det glt_tr_type "glt_tr_type = ""YA"""
            glt_ref "input glt_ref"}
         if recno <> ?
         then do:

            /* Get GL Period/Year */

            run get-gl-period-year
               (input  glt_effdate,
               input  2,
               output per_yr).

            display
               glt_ref
               glt_tr_type    @ tr_type
               per_yr
               glt_effdate    @ eff_dt
               base_curr      @ ctrl_curr
               disp_curr
               glt_correction @ corr-flag
               glt_dy_code    @ dft-daybook
               glt_dy_num     @ nrm-seq-num
            with frame ya.

            recno = ?.

            if glt_dy_code <> ""
            and can-find (nr_mstr
            where nr_seqid = glt_dy_code)
            then
               l_daybook_flag = yes.
            else
               l_daybook_flag = no.

         end. /* IF recno <> ? */

      end.  /* PROMPT-FOR glt_ref EDITING */

      assign
         undo_flag = false
         l_glt_ref = input frame ya glt_ref.

   end. /* ELSE-DO */
END PROCEDURE. /* GET_GLT_REF */

PROCEDURE dbk_valid:

   /* VALIDATE DAYBOOK */
   undo_flag = yes.
   if not can-find(dy_mstr where dy_dy_code = dft-daybook)
   then do:

      /* ERROR: INVALID DAYBOOK */
      {pxmsg.i &MSGNUM=1299 &ERRORLEVEL=3}
      return.
   end. /* IF NOT CAN-FIND(dy_mstr WHERE dy_dy_code = dft-daybook) */
   else do:

      {gprun.i ""gldyver.p"" "(input type_parm,
                               input """",
                               input dft-daybook,
                               input entity,
                               output daybook-error)"}
      if daybook-error
      then do:

         /* WARNING: DAYBOOK DOES NOT MATCH ANY DEFAULT */
         {pxmsg.i &MSGNUM=1674 &ERRORLEVEL=2}

         if not batchrun
         then
            pause.

         if keyfunction(lastkey) = "END-ERROR"
         then
            return.
      end. /* IF daybook-error */

      {gprunp.i "nrm" "p" "nr_can_dispense"
         "(input dft-daybook,
           input eff_dt)"}

      {gprunp.i "nrm" "p" "nr_check_error"
         "(output daybook-error,
           output return_int)"}

      if daybook-error
      then do:

         {pxmsg.i &MSGNUM=return_int &ERRORLEVEL=3}
         return.
      end. /* IF daybook-error */
   end. /* ELSE DO */
   undo_flag = no.
END PROCEDURE. /* dbk_valid */

PROCEDURE ip-invalid-acc:
   /* CHECK FOR INVALID ACCOUNT/COST CENTERS */
   inv_flag = no.

   loope:
   for each glt_det exclusive-lock
      where glt_ref     =  ref
        and glt_tr_type <> "**":

      {gprunp.i "gpaudpl" "p" "set_search_key"
         "(input glt_det.glt_ref + ""."" +
           string(glt_det.glt_line))"}
      {gprunp.i "gpaudpl" "p" "save_before_image"
         "(input rowid(glt_det))"}

      if glt_acc = pl
      then do:

         assign
            glt_error = getTermLabel("INVALID_ACCOUNT",16)
            inv_flag  = yes.
      end. /* IF glc_acc = pl */

      for first ac_mstr
         fields(ac_active ac_code ac_curr ac_type)
         where ac_code = glt_det.glt_acc
         no-lock:
      end. /* FOR FIRST ac_mstr */

      if not available ac_mstr
      then do:
         for first al_mstr
            fields(al_code)
            where al_code = glt_det.glt_acc
            no-lock:
         end. /* FOR FIRST al_mstr */

         if not available al_mstr
         then
            assign
               glt_det.glt_error = getTermLabel("INVALID_ACCOUNT",16)
               inv_flag = yes.
      end. /* IF NOT AVAILABLE ac_mstr */

      if available ac_mstr
         and ac_active = no
      then
         assign
            glt_error = getTermLabel("INACTIVE_ACCOUNT",16)
            inv_flag = yes.

      /* INITIALIZE SETTINGS */
      {gprunp.i "gpglvpl" "p" "initialize"}

      /* ADDED GLT_PROJECT CODE AS FOURTH PARAMETER IN VALIDATION */
      /* ROUTINE BELOW ACCT/SUB/CC/PROJ VALIDATION                */
      {gprunp.i "gpglvpl" "p" "validate_fullcode"
         "(input glt_acc,
           input glt_sub,
           input glt_cc,
           input glt_project,
           output valid_acct)"}

      if not valid_acct
      then
         assign
            glt_error = getTermLabel("INVALID_CODE",16)
            inv_flag = yes.

      {gprunp.i "gpaudpl" "p" "audit_record_change"}
   end. /* LOOPE */
END PROCEDURE. /* ip-invalid-acc */

PROCEDURE ip-glt-del:
   for each glt_det
      where glt_ref = ref
      exclusive-lock:

      {gprunp.i "gpaudpl" "p" "set_search_key"
         "(input glt_det.glt_ref + ""."" +
           string(glt_det.glt_line))"}
      {gprunp.i "gpaudpl" "p" "save_before_image"
         "(input rowid(glt_det))"}

      /* DELETE ANY RELATED EXCHANGE RATE USAGE RECORDS */
      {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
         "(input glt_det.glt_exru_seq)"}
      {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
         "(input glt_det.glt_en_exru_seq)"}

      if glt_det.glt_tr_type    <> "**"
         and (glt_det.glt_rflag =  no
         or can-do("RV,RA",glt_det.glt_tr_type) = no)
      then do:

         {gprunp.i "gpaudpl" "p" "set_delete_message"
            "(input getTermLabelRtColon(""ACCOUNT"",4) +
                    glt_det.glt_acc +
                    (if glt_det.glt_sub <> """"
                     then
                        "" "" + getTermLabelRtColon(""SUB_ACCOUNT"",4) +
                        glt_det.glt_sub
                     else
                        """") +
                     (if glt_det.glt_cc <> """"
                      then
                         "" "" + getTermLabelRtColon(""CC"",3) +
                         glt_det.glt_cc
                      else
                         """") +
                     (if glt_det.glt_project <> """"
                      then
                         "" "" + getTermLabelRtColon(""PROJ"",5) +
                         glt_det.glt_project
                      else """") +
                     (if glt_det.glt_doc <> """"
                      then
                         "" "" + getTermLabelRtColon(""DOCUMENT_NUMBER"",4) +
                         glt_det.glt_doc
                      else
                         """") +
                     (if glt_det.glt_desc <> """"
                      then
                         "" "" + getTermLabelRtColon(""DESCRIPTION"",5) +
                         glt_det.glt_desc
                      else
                         """"))"}
         {gprunp.i "gpaudpl" "p" "audit_record_deletion"}
      end. /* IF glt_det.glt_tr_type <> "**"... */
      delete glt_det.
   end. /* FOR EACH glt_det */

   /****************************** Add by SS - Micho - 20060606 B ******************************/
   FOR EACH glta_det WHERE glta_ref = ref EXCLUSIVE-LOCK :
       DELETE glta_det .
   END.
   /****************************** Add by SS - Micho - 20060606 E ******************************/

   /* SS - 20080424.1 - B */
   FOR EACH usrw_wkfl WHERE usrw_key1 = 'glsum1' AND usrw_key3 = ref :
       DELETE usrw_wkfl .
   END.
   /* SS - 20080424.1 - E */

END PROCEDURE. /* ip-glt-del */

PROCEDURE build_glt_det:
   assign
      glt_det.glt_entity      = gltdet.glt_entity
      glt_det.glt_acct        = bk_mstr.bk_acct
      glt_det.glt_sub         = bk_sub
      glt_det.glt_cc          = bk_cc
      glt_det.glt_project     = gltdet.glt_project
      glt_det.glt_date        = gltdet.glt_date
      glt_det.glt_ref         = gltdet.glt_ref
      glt_det.glt_effdate     = gltdet.glt_effdate
      glt_det.glt_desc        = gltdet.glt_desc
      glt_det.glt_curr        = gltdet.glt_curr
      glt_det.glt_doc         = gltdet.glt_doc
      glt_det.glt_userid      = gltdet.glt_userid
      glt_det.glt_addr        = gltdet.glt_addr
      glt_det.glt_batch       = gltdet.glt_batch
      glt_det.glt_doc_type    = gltdet.glt_doc_type
      glt_det.glt_ex_rate     = gltdet.glt_ex_rate
      glt_det.glt_ex_rate2    = gltdet.glt_ex_rate2
      glt_det.glt_ex_ratetype = gltdet.glt_ex_ratetype
      glt_det.glt_tr_type     = gltdet.glt_tr_type
      glt_det.glt_user1       = gltdet.glt_user1
      glt_det.glt_user2       = gltdet.glt_user2
      glt_det.glt_rflag       = gltdet.glt_rflag
      glt_det.glt_unb         = gltdet.glt_unb
      glt_det.glt_correction  = gltdet.glt_correction
      glt_det.glt_dy_code     = dft-daybook
      glt_det.glt_dy_num      = nrm-seq-num.
END PROCEDURE. /* build_glt_det */

PROCEDURE p-exclusive-lock:
   for first glt_det
      where glt_ref = ref
      exclusive-lock:

   end. /* FOR FIRST glt_det */
END PROCEDURE. /* P-EXCLUSIVE-LOCK */

PROCEDURE p-disp-msg:
   define input parameter msg_number  like msg_nbr no-undo.
   define input parameter error_level as   integer no-undo.

   {pxmsg.i &MSGNUM=msg_number &ERRORLEVEL=error_level}
END PROCEDURE. /* p-disp-msg */

{&GLTRMTM-P-TAG28}

PROCEDURE get-co-daily-seq:
/*-----------------------------------------------------------
Purpose:      Returns the value for co_daily_seq from mfc_ctrl
Parameters:   <None>
Notes:        Created with L18P to avoid action segment error
-------------------------------------------------------------*/

   {glmfcctl.i}

END PROCEDURE. /* get-co-daily-seq */

PROCEDURE delete-holding-trans:
/*-----------------------------------------------------------
Purpose:      Deletes any holding transactions from glt_det
Parameters:   <None>
Notes:        Created with L18P to avoid action segment error
-------------------------------------------------------------*/
   if not cash_book
   then

      repeat:

      for first glt_det
         fields(glt_acct    glt_addr       glt_amt        glt_batch
                glt_cc      glt_correction glt_curr       glt_curr_amt
                glt_date    glt_desc       glt_doc        glt_doc_type
                glt_dy_code glt_dy_num     glt_ecur_amt   glt_effdate
                glt_entity  glt_en_exrate  glt_en_exrate2 glt_en_exru_seq
                glt_error   glt_exru_seq   glt_ex_rate    glt_ex_rate2
                glt_line    glt_project    glt_ref        glt_ex_ratetype
                glt_rflag   glt_sub        glt_tr_type    glt_unb
                glt_user1   glt_user2      glt_userid)
         where glt_tr_type = "**"
         and   glt_userid  = mfguser
         use-index glt_tr_type
         no-lock:
      end. /* FOR FIRST glt_det */

      if not available glt_det
      then
         leave.

      else do:
         glt_recno = recid(glt_det).

         find glt_det
            where recid(glt_det) = glt_recno
            exclusive-lock.

         {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
            "(input glt_det.glt_exru_seq)"}
         {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
            "(input glt_det.glt_en_exru_seq)"}

         delete glt_det.

      end. /* ELSE DO */

   end. /* IF NOT cash_book */

END PROCEDURE. /* delete-holding-trans */

PROCEDURE check-closed-period:
/*-----------------------------------------------------------
Purpose:      Check to see if the GL Calendar is closed
Parameters:   p-date   Input Date
              p-entity Entity
              p-peryr  Period-Year
              p-error  Calendar Error Occurred
Notes:        Created with L18P to avoid action segment error
-------------------------------------------------------------*/
   define input  parameter p-date   as   date                    no-undo.
   define input  parameter p-entity like glt_det.glt_entity      no-undo.
   define output parameter p-peryr  as   character format "x(7)" no-undo.
   define output parameter p-error  as   logical                 no-undo.

   p-error = no.

   {glper.i p-date p-peryr p-entity}

   if glcd_yr_clsd = yes
   then do:
      /* YEAR HAS BEEN CLOSED */
      {pxmsg.i &MSGNUM=3022 &ERRORLEVEL=3}
      p-error = yes.
   end. /* IF glcd_yr_clsd = yes */

   if glcd_gl_clsd = yes
   then do:

      /* PERIOD HAS BEEN CLOSED */
      {pxmsg.i &MSGNUM=3023 &ERRORLEVEL=3}
      p-error = yes.
   end. /* IF glcd_gl_clsd = yes */

END PROCEDURE. /* check-closed-period */

PROCEDURE get-gl-period-year:
/*-----------------------------------------------------------
Purpose:      Get the GL Period and Year based on a date
Parameters:   p-date  Input Date p-peryr Period-Year
Notes:        Created with L18P to avoid action segment error
-------------------------------------------------------------*/
   define input  parameter p-date  as date    no-undo.
   define input  parameter p-iter  as integer no-undo.
   define output parameter p-peryr as character format "x(7)" no-undo.

   {glper1.i p-date p-peryr}

   if type_parm = "YA"
   then do:

      if p-iter = 1
      then do:

         p-peryr = string(year(today) - 1).

         for last glc_cal
            fields (glc_year glc_end)
            where glc_year = integer(per_yr)
            no-lock:
         end. /* FOR LAST glc_cal */

         eff_dt = if available glc_cal
                  then
                     glc_end
                  else
                     ?.
      end. /* IF p-iter = 1 */

      if p-iter = 2
      then
         p-peryr = string((if available glc_cal
                           then
                              glc_year
                           else
                              0)).
   end. /* IF type_parm = "YA" */

END PROCEDURE. /* get-gl-period-year */
