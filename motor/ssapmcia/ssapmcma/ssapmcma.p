/* apmcmt.p - AP MANUAL CHECK MAINTENANCE                                */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* $Revision: 1.61 $                                                 */
/*V8:ConvertMode=Maintenance                                             */
/* REVISION: 1.0      LAST MODIFIED: 11/15/86   by: PML                  */
/* REVISION: 6.0      LAST MODIFIED: 04/19/91   by: mlv *D546*           */
/*                                   04/23/91   by: mlv *D567* (rev only)*/
/*                                   04/24/91   by: mlv *D595*           */
/*                                   08/02/91   by: mlv *D809* (rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 09/17/91   by: mlv *F015*           */
/*                                   11/04/91   by: mlv *F031*           */
/*                                   12/11/91   by: mlv *F037*           */
/*                                   12/13/91   by: mlv *F074*           */
/*                                   01/21/92   by: mlv *F083*           */
/*                                   01/21/92   by: mlv *F090*           */
/*                                   02/04/92   by: mlv *F149*           */
/*                                   02/21/92   by: mlv *F224*           */
/*                                   06/03/92   by: mlv *F576*           */
/*                                   06/19/92   by: jjs *F672* (rev only)*/
/*                                   07/06/92   by: mlv *F725*           */
/* REVISION: 7.3      LAST MODIFIED: 10/02/92   by: mpp *G004*           */
/*                                   12/18/92   by: mpp *G475*           */
/*                                   03/15/93   by: jms *G814*           */
/*                                   04/17/93   by: bcm *G969*           */
/*                                   04/23/93   by: jms *GA21*           */
/* REVISION: 7.4      LAST MODIFIED: 07/28/93   by: pcd *H039*           */
/*                                   08/20/93   by: jms *H078*           */
/*                                   09/16/93   by: pcd *H117*           */
/*                                   09/21/93   by: bcm *H110*           */
/*                                   09/22/93   by: wep *H111*           */
/*                                   10/30/93   by: wep *H203*           */
/*                                   02/07/94   by: wep *FM12*           */
/*                                   03/21/94   by: wep *FM91*           */
/*                                   03/22/94   by: wep *GJ16*           */
/*                                   03/30/94   by: wep *FL75*           */
/*                                   07/11/94   by: pmf *FP34*           */
/*                                   07/25/94   by: pmf *FP52*           */
/*                                   08/24/94   by: cpp *GL39*           */
/*                                   08/30/94   by: pmf *FQ59*           */
/*                                   09/12/94   by: slm *GM17*           */
/*                                   11/04/94   by: str *FT36*           */
/*                                   11/06/94   by: ame *GO17*           */
/*                                   01/17/95   by: str *F0F6*           */
/*                                   02/21/95   by: wjk *F0JQ*           */
/*                                   04/10/95   by: jpm *H0CH*           */
/*                                   04/23/95   by: aed *H0D6*           */
/*                                   04/25/95   by: wjk *H0CS*           */
/*                                   06/21/95   by: jzw *F0SV*           */
/* REVISION: 8.5      LAST MODIFIED: 11/01/95   by: mwd *J053*           */
/*                                   05/09/96   by: bxw *J0MQ*           */
/*                                   06/08/96   by: wjk *G1XC*           */
/*                                   06/11/96   by: jzw *H0KZ*           */
/* REVISION: 8.6      LAST MODIFIED: 06/11/96   BY: ejh *K001*           */
/*                                   07/15/96   by: *J0VY* M. Deleeuw    */
/*                                   07/27/96   by: *J12H* M. Deleeuw    */
/*                                   11/06/96   by: rxm *H0NZ*           */
/*                                   01/28/97   by: rxm *J1FR*           */
/*                                   01/29/97   by: *K05F* Eugene Kim    */
/*                                   02/17/97   by: *K01R* E. Hughart    */
/*                                   03/18/97   by: *J1KV* Robin McCarthy*/
/*                                   05/05/97   by: *H0X5* Robin McCarthy*/
/* REVISION: 8.6      LAST MODIFIED: 05/22/97   by: *J1S0* Irine D'mello */
/* REVISION: 8.6      LAST MODIFIED: 08/12/97   by: *J1X9* Samir Bavkar  */
/* REVISION: 8.6      LAST MODIFIED: 10/08/97   by: *J22V* Irine D'mello */
/* REVISION: 8.6      LAST MODIFIED: 11/03/97   BY: *J24H* Irine D'mello */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane     */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan    */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton  */
/* REVISION: 9.0      LAST MODIFIED: 01/04/99   BY: *J37W* Hemali Desai  */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 04/22/99   BY: *L0DZ* Hemali Desai      */
/* Pre-86E commented code removed, view in archive revision 1.17             */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Paul Johnson      */
/* REVISION: 9.1      LAST MODIFIED: 06/15/99   BY: *J3H1* Anup Pereira      */
/* REVISION: 9.1      LAST MODIFIED: 07/28/99   BY: *L0FV* Hemali Desai      */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *K23F* Jose Alex         */
/* REVISION: 9.1      LAST MODIFIED: 02/09/00   BY: *L0R9* Abbas Hirkani     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 08/21/00   BY: *N0MH* Arul Victoria     */
/* REVISION: 9.1      LAST MODIFIED: 10/19/00   BY: *N0VN* BalbeerS Rajput   */
/* Revision: 1.36     BY: Katie Hilbert         DATE: 04/01/01  ECO: *P002*  */
/* Revision: 1.37     BY: Ed van de Gevel       DATE: 11/09/01  ECO: *N15N*  */
/* Revision: 1.38     BY: Mamata Samant         DATE: 01/14/02  ECO: *M1Q5*  */
/* Revision: 1.40     BY: Rajaneesh S.          DATE: 03/18/02  ECO: *N1DK*  */
/* Revision: 1.41     BY: Ed van de Gevel       DATE: 04/17/02  ECO: *N1GR*  */
/* Revision: 1.43     BY: Vinod Nair            DATE: 07/09/02  ECO: *N1LY*  */
/* Revision: 1.44     BY: Manjusha Inglay       DATE: 07/29/02  ECO: *N1P4*  */
/* Revision: 1.45     BY: Mercy Chittilapilly   DATE: 08/19/02  ECO: *N1RM*  */
/* Revision: 1.46     BY: Ed van de Gevel       DATE: 08/21/02  ECO: *P0G2*  */
/* Revision: 1.47     BY: Orawan S.             DATE: 05/02/03  ECO: *P0R0*  */
/* Revision: 1.49     BY: Paul Donnelly (SB)    DATE: 06/26/03  ECO: *Q00B*  */
/* Revision: 1.51     BY: P. Grzybowski         DATE: 08/26/03  ECO: *P10G*  */
/* Revision: 1.52     BY: Jean Miller           DATE: 09/26/03  ECO: *Q03S*  */
/* Revision: 1.53     BY: Shilpa Athalye        DATE: 11/04/03  ECO: *N2M6*  */
/* Revision: 1.54     BY: Pankaj Goswami        DATE: 12/11/03  ECO: *P1FH*  */
/* Revision: 1.55     BY: Vivek Gogte           DATE: 03/17/04  ECO: *P1T0*  */
/* Revision: 1.56     BY: Salil Pradhan         DATE: 08/17/04  ECO: *P2G1*  */
/* Revision: 1.57     BY: Bhagyashri Shinde     DATE: 09/16/04  ECO: *P2KP*  */
/* Revision: 1.58     BY: Ajay Nair             DATE: 01/13/05  ECO: *P33Y*  */
/* Revision: 1.59     BY: Tony Brooks           DATE: 05/11/05  ECO: *N322*  */
/* Revision: 1.60     BY: Salil Pradhan DATE: 09/20/05  ECO: *P41T* */
/* $Revision: 1.61 $  BY: Dinesh Dubey DATE: 11/17/05  ECO: *P485* */
/* $Revision: 1.61 $  BY: Bill Jiang DATE: 08/26/07  ECO: *SS - 20070826.1* */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "1+ "}
{cxcustom.i "APMCMT.P"}

{gldydef.i new}
{gldynrm.i new}
{pxpgmmgr.i}
{glsec.i}

define new shared variable ba_recno     as recid.
define new shared variable aprecid      as recid.
define new shared variable ap1recid     as recid.
define new shared variable bkrecid      as recid.
define new shared variable ckrecid      as recid.
define new shared variable apbuffrecid  as recid.
define new shared variable vorecid      as recid.
define new shared variable ckdrecid     as recid.
define new shared variable trtype       as character initial "man".
define new shared variable msg_string   as character format "X(8)".
define new shared variable ref          as character format "X(14)".
define new shared variable bactrl       like ba_ctrl.
define new shared variable apref        like ap_ref.
define new shared variable jrnl         like glt_ref.
define new shared variable bank         like bk_code.
define new shared variable disc_ok      like ap_amt.
define new shared variable old_effdate  like ap_effdate.
define new shared variable base_amt     like ap_amt.
define new shared variable base_disc    like ap_amt.
define new shared variable gain_amt     like ap_amt.
define new shared variable check_amt    like ckd_amt.
define new shared variable undo_all     like mfc_logical.
define new shared variable curr_amt     like glt_curr_amt.
define new shared variable curr_disc    like glt_curr_amt.
define new shared variable base_det_amt like glt_amt.
define new shared variable batch        like ap_batch label "Batch".
define new shared variable amt_open     like ap_amt label "Balance".
define new shared variable amt_disc     like ap_amt label "Disc Bal".
{&APMCMT-P-TAG1}
define new shared variable aptotal      like ap_amt label "Check Ctrl"
   format ">>>>>,>>>,>>9.99".
{&APMCMT-P-TAG2}
define new shared variable apply_amt    like ap_amt label "Amt to Apply".
define new shared variable apply_disc   like ap_amt label "Amt to Disc".
define new shared variable gen_desc     like glt_desc.
define new shared variable ckdamt       like ckd_amt.
define new shared variable ap_due_date  like ap_date label "Due Date".
define new shared variable for_curr_amt like ckd_cur_amt.
define new shared variable tot-vtadj    as decimal.
define new shared variable rndmthd      like rnd_rnd_mthd.
define new shared variable old_curr     like ap_curr.
define new shared variable ap_amt_fmt   as character no-undo.
define new shared variable ap_amt_old   as character no-undo.
define new shared variable action       as character initial "2" format "x(1)".
define new shared variable useacct      like ap_acct.
define new shared variable usesub       like ap_sub.
define new shared variable usecc        like ap_cc.
define new shared variable del-yn       like mfc_logical initial no.
define new shared variable glvalid      like mfc_logical.
define new shared variable newapmstr    like mfc_logical.
define new shared variable apamt        like ap_amt.
define new shared variable ctrldiff     like ap_amt.
define new shared variable draft_yn     like mfc_logical initial no
   label "Draft".
define new shared variable use_draft    like mfc_logical.
define new shared variable use_pip      like mfc_logical.
define new shared variable addrec       like mfc_logical.
define new shared variable check-num    like ck_nbr.
define new shared variable retval       as integer.
define new shared variable ckbank       like ck_bank.
define new shared variable cknbr        like ck_nbr.
define new shared variable undo_all2    as logical no-undo.

define variable d_pos                   as integer.
define variable dd_mon                  as integer.
define variable dd_day                  as integer.
define variable dd_yr                   as integer.
define variable bk-action               as character.
define variable gltline                 like glt_line.
define variable amt_to_apply            like ap_amt label "Amt to Apply".
define variable first_ck_in_batch       like mfc_logical.
define variable tax_tr_type             like tx2d_tr_type initial "29".
define variable inbatch                 like ap_batch.
define variable tax_nbr                 like tx2d_nbr.
define variable temp_bank               like bk_code.
define variable rndamt                  like ap_amt.
define variable init-daybook            like dy_dy_code.
define variable mc-error-number         like msg_nbr no-undo.

define variable l_daybook               like ap_dy_code no-undo.
define variable l_effdate               like ap_effdate no-undo.
define variable l_round                 like ap_amt      no-undo    initial 0.
define variable l_ap_amt                like ap_amt      no-undo    initial 0.
define variable l_base_amt              like ap_amt      no-undo    initial 0.
define variable l_ref                   as character format "X(14)" initial "".
define variable entity_ok               like mfc_logical no-undo.

{&APMCMT-P-TAG89}
{&APMCMT-P-TAG48}
gen_desc = getTermLabel("AP_PAYMENT",24).

form
   batch          colon 8 deblank
   bactrl         format "->>>>>>>,>>>,>>9.999"
   label "Ctrl"
   ba_total       format "->>>>>>>,>>>,>>9.999"
with side-labels frame a width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

define new shared frame b.

/* DEFINE SELECTION FORM */
{apmcfmb.i}

define new shared buffer apmstr for ap_mstr.

/* DEFINE VARIABLES FOR GPGLEF.P (GL CALENDAR VALIDATION) */
{gpglefdf.i}

/* DEFINED TEMP TABLE FOR GETTING THE RECORDS ADDED IN apmcmta.p */
/* WITH INDEX SAME AS PRIMARY UNIQUE INDEX OF ckd_det.           */
{apdydef.i &type="new shared"}

{&APMCMT-P-TAG3}
do for apc_ctrl:
   /*ADDED TO CONTROL SCOPING OF APC_CTRL TO AVOID BLEEDING LOCKS*/
   find first apc_ctrl where apc_domain = global_domain no-lock no-error.
   if available apc_ctrl then
   assign
      use_pip = apc_pip
      use_draft = apc_use_drft.
end. /* DO FOR APC_CTRL */
{&APMCMT-P-TAG4}

/*INITIAL READ TO OBTAIN DEFAULTS*/
find first gl_ctrl where gl_domain = global_domain no-lock no-error.

ap_amt_old = ap_amt:format in frame b.

mainloop:
repeat with frame a:

   view frame a.
   {&APMCMT-P-TAG5}

   do transaction:
      status input.

      view frame b.

      assign
         recno  = ?
         batch  = ""
         bactrl = 0.

      set batch with frame a.

      if batch <> "" then do:

         find first ap_mstr where ap_mstr.ap_domain = global_domain and
                                  ap_mstr.ap_batch = batch
         no-lock no-error.

         /* CODE MOVED FROM BELOW */
         if available ap_mstr
            and ap_mstr.ap_type <> "CK"
         then do:
            /* BATCH ALREADY ASSIGNED */
            {pxmsg.i &MSGNUM=1182 &ERRORLEVEL=3 &PAUSEAFTER=true}
            next-prompt batch with frame a.
            undo, retry.
         end. /* IF AVAILABLE ap_mstr AND ... */

         if available ap_mstr then do:
            find last ck_mstr where ck_domain = global_domain and
                                    ck_ref = ap_ref
            no-lock no-error.
            if available ck_mstr then
               bank = string(ck_bank, "X(2)").
         end.

         find ba_mstr where ba_domain = global_domain and
                            ba_batch =  batch and
                            ba_module = "AP"
         exclusive-lock no-error.

         if available ba_mstr then do:

            /* PREVENT ENTRY OF BATCH NUMBER ASSIGNED TO AP */
            /* MODULE IF ITS DOCUMENT TYPE IS NOT A CHECK   */
            if ba_doc_type <> "CK"
            then do:
               /* BATCH NUMBER ALREADY ASSIGNED */
               {pxmsg.i &MSGNUM=1182 &ERRORLEVEL=3 &PAUSEAFTER=true}
               next-prompt batch with frame a.
               undo, retry.
            end. /* IF BA_DOC_TYPE <> "CK" */

            assign
               bactrl = ba_ctrl
               /* ENSURE BATCH TOTAL = SUM OF VOUCHERS */
               ba_total = 0.

            for each ap_mstr where ap_mstr.ap_domain = global_domain and
                                   ap_mstr.ap_batch = ba_batch
            no-lock:
               ba_total = ba_total - ap_amt.
            end.

            display ba_total with frame a.

         end.
         else
            display 0 @ ba_total with frame a.

      end.  /* IF BATCH <> "" */
      else
         display
            0 @ bactrl
            0 @ ba_total
         with frame a.

      update bactrl with frame a.

      if available ba_mstr
      then
         assign
            ba_ctrl = bactrl
            ba_recno = recid(ba_mstr).

      first_ck_in_batch = yes.

   end. /* DO TRANSACTION */
   {&APMCMT-P-TAG6}

   loopb:
   repeat with frame b:

      {&APMCMT-P-TAG7}
      clear frame b no-pause.

      do transaction:
         if available ba_mstr then display ba_total with frame a.
         {&APMCMT-P-TAG8}
         display bank @ ck_bank.

         do on error undo, retry:
            {&APMCMT-P-TAG9}
            {&APMCMT-P-TAG49}

            /* RESET DRAFT VARS */
            assign
               draft_yn = no
               addrec = no.

            {&APMCMT-P-TAG10}
            prompt-for ck_mstr.ck_bank.

            find bk_mstr where bk_domain = global_domain and
                               bk_code   = input ck_bank
            exclusive-lock no-error.

            if not available bk_mstr then do:
               /* Invalid Bank */
               {pxmsg.i &MSGNUM=1200 &ERRORLEVEL=3}
               {&APMCMT-P-TAG11}
               undo, retry.
            end.

            /* CHECK BANK ENTITY SECURITY */
            {glenchk.i &entity=bk_entity &entity_ok=entity_ok}
            if not entity_ok then
               undo, retry.

            {gprun.i ""gldydft.p""
               "(input ""AP"",
                 input ""CK"",
                 input bk_entity,
                 output dft-daybook,
                 output daybook-desc)"}

            init-daybook = dft-daybook.
            {&APMCMT-P-TAG12}

            prompt-for ck_nbr
            editing:

               ref = string(input ck_bank,"X(2)") +
                     {&APMCMT-P-TAG42}
                     string(input ck_nbr).
                     {&APMCMT-P-TAG43}

               if frame-field = "ck_nbr" and batch <> "" then do:

                  /* FIND NEXT/PREVIOUS RECORD */
                  {mfnp06.i ap_mstr ap_batch
                     " ap_mstr.ap_domain = global_domain and batch  = ap_batch"
                     ap_ref
                     ref ap_batch batch}

                  if recno <> ? then do:
                     /*CONVERT QAD__01 INTO DATE FORMAT*/
                     if ap__qad01 > "" then do:
                        {gprun.i ""gpchtodt.p""
                           "(input  ap__qad01,
                             output ap_due_date)"}
                        draft_yn = yes.
                     end.
                     else
                     assign
                        draft_yn = no
                        ap_due_date = ?.

                     {&APMCMT-P-TAG13}
                     {&APMCMT-P-TAG50}
                     display integer(substring(ap_ref,3,6)) @ ck_nbr.
                     {&APMCMT-P-TAG51}
                     {&APMCMT-P-TAG14}

                     if ap_curr <> old_curr or old_curr = "" then do:
                        /* GET ROUNDING METHOD */
                        /* FROM CURRENCY MASTER */
                        {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                           "(input ap_curr,
                             output rndmthd,
                             output mc-error-number)"}
                        if mc-error-number <> 0 then do:
                           {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                           pause 0.
                           undo loopb, retry loopb.
                        end.

                        ap_amt_fmt = ap_amt_old.

                        {gprun.i ""gpcurfmt.p""
                           "(input-output ap_amt_fmt, input rndmthd)"}
                        old_curr = ap_curr.
                     end. /* IF AP_CURR <> OLD_CURR */

                     assign
                        ap_amt:format in frame b = ap_amt_fmt
                        aptotal:format in frame b = ap_amt_fmt.

                     {&APMCMT-P-TAG52}

                     display
                        ap_effdate
                        ap_date
                        draft_yn
                        ap_due_date when (draft_yn)
                        ap_vend
                        (- ap_amt) @ ap_amt
                        ap_acct
                        ap_sub
                        ap_cc
                        ap_disc_acct
                        ap_disc_sub
                        ap_disc_cc
                        ap_dy_code
                        ap_rmk
                        ap_batch
                        ap_curr
                     with frame b.
                     {&APMCMT-P-TAG53}
                     {&APMCMT-P-TAG15}

                     find vd_mstr where vd_domain = global_domain and
                                        vd_addr = ap_vend
                     no-lock no-error.

                     if available vd_mstr then
                        display vd_sort.
                     else
                        display " " @ vd_sort.

                     find ck_mstr where ck_domain = global_domain and
                                        ck_ref = ap_ref
                     no-lock no-error.

                     if available ck_mstr then do:
                        bank = string(ck_bank, "X(2)").
                        display bank @ ck_bank.
                     end.

                  end. /* IF RECNO <> "" */

               end. /* FRAME-FIELD = "CK_NBR" */

               else do:
                  status input.
                  readkey.
                  apply lastkey.
               end.

            end. /* PROMPT-FOR...EDITING */

            /*IF CK_NBR IS BLANK OR 0, GENERATE THE NEXT CK_NBR*/
            {&APMCMT-P-TAG16}
            if input ck_nbr = "" or
               input ck_nbr = 0
            then do:
               {&APMCMT-P-TAG17}
               bk-action = "gen".
            end.
            else
            assign
               bk-action = "incr"
               check-num  = input ck_nbr.

            {&APMCMT-P-TAG18}

            /*INCREMENT OR GENERATE NEXT CHECK NUMBER*/
            {gprun.i ""apmcmtb.p""
               "(input   bk-action,
                 input   bk_code,
                 input-output  check-num)"}

            {&APMCMT-P-TAG19}
            ckbank = input ck_bank.

            {&APMCMT-P-TAG54}

            display check-num @ ck_nbr with frame b.

            assign
               ckrecid = ?
               cknbr   = input ck_nbr.
            {&APMCMT-P-TAG55}

            /* CODE FROM APMCMTC.P IS REMOVED AND INTRODUCED IN  */
            /* THIS PROGRAM                                      */
            for first ck_mstr
               fields(ck_domain ck_nbr ck_ref ck_type ck_status
                      ck_bank ck_curr ck_exru_seq
                      ck_ex_rate ck_ex_rate2 ck_ex_ratetype)
                where ck_domain = global_domain
                  and ck_ref = string(input ck_bank, "x(2)" ) +
                               {&APMCMT-P-TAG44}
                               string(input ck_nbr)
            {&APMCMT-P-TAG45}
            no-lock: end.

            if not available ck_mstr and available ap_mstr then
            for first ck_mstr
               fields(ck_domain ck_bank ck_nbr ck_ref ck_curr
                      ck_exru_seq ck_ex_rate ck_ex_rate2 ck_ex_ratetype
                      ck_status ck_type)
                where ck_domain = global_domain and
                      ck_ref = ap_ref
            no-lock: end.

            if available ck_mstr and ck_nbr <> input ck_nbr or
               not available ck_mstr
            then do:
               /* ADDING NEW RECORD */
               {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
               assign addrec = yes.
            end.

            else do:

               if ck_type <> "MN" then do:
                  /* UPDATE NOT ALLOWED */
                  {pxmsg.i &MSGNUM=171 &ERRORLEVEL=3}
                  {&APMCMT-P-TAG56}
                  undo, retry.
                  {&APMCMT-P-TAG57}
               end.
               {&APMCMT-P-TAG58}

               if ck_status = "VOID" or ck_status = "CANCEL"
               then do:
                  /* CHECK THAT THE CHECK IS NOT VOIDED OR CANCELED */
                  {pxmsg.i &MSGNUM=1203 &ERRORLEVEL=3}
                  {&APMCMT-P-TAG59}
                  undo, retry.
                  {&APMCMT-P-TAG60}
               end.

            end.

            if available ck_mstr then
               assign ckrecid = recid(ck_mstr).

            {&APMCMT-P-TAG61}
            {&APMCMT-P-TAG20}

            /* RETRIEVE THE ck_mstr RECORD FOUND IN apmcmtc.p */
            if ckrecid <> ? then
               find ck_mstr where recid(ck_mstr) = ckrecid
               no-lock no-error.

            /* ADDED PROCEDURE TO GET THE NEXT BATCH NUMBER AND  */
            /* CREATE THE BATCH MASTER (BA_MSTR).  IF THE BA_MSTR */
            /* ALREADY EXISTS THE RECORD WILL BE UPDATED          */
            if available ck_mstr then
               find first ap_mstr where ap_mstr.ap_domain = global_domain
                                    and ap_mstr.ap_ref = ck_ref
                                    and ap_type = "CK"
            no-lock no-error.

            if available ap_mstr and batch = "" then
               batch = ap_batch.

            {&APMCMT-P-TAG62}
            find first ba_mstr where ba_domain = global_domain and
                                     ba_batch = batch and
                                     ba_module = "AP"
            no-lock no-error.

            if available ba_mstr then
            assign
               bactrl = ba_ctrl.
            {&APMCMT-P-TAG83}
            inbatch = batch.

            {gprun.i ""gpgetbat.p""
               "(input  inbatch,  /*IN-BATCH #*/
                 input  ""AP"",   /*MODULE         */
                 input  ""CK"",   /*DOC TYPE       */
                 input  bactrl,   /*CONTROL AMT    */
                 output ba_recno, /*NEW BATCH RECID*/
                 output batch)"}  /*NEW BATCH #    */
            {&APMCMT-P-TAG84}

            display
               batch
               bactrl
            with frame a.

         end.

         if jrnl = ""
            or can-find(first apc_ctrl
                        where apc_domain   = global_domain
                        and   apc_sum_lvl  = 3)
         then do:
            do for apc_ctrl:
               /* GET NEXT JOURNAL REFERENCE NUMBER */
               {apnjrnl.i today jrnl}
            end. /* DO FOR apc_ctrl */
         end. /* IF JRNL = "" */

      end. /*  DO TRANSACTION */

      do transaction on error undo, leave:

         assign
            newapmstr = false.

         loopc:
         do while true:

            {&APMCMT-P-TAG21}
            {gprun.i ""apmcmtd.p""}
            {&APMCMT-P-TAG22}
            {&APMCMT-P-TAG63}

            if (available ck_mstr  and
               (ck_nbr <> input ck_nbr or
               (ck_nbr = input ck_nbr and ck_bank <> input ck_bank))) or
               not available ck_mstr
            then do:

               create ck_mstr.
               assign
                  ck_domain = global_domain
                  ck_nbr
                  ck_bank = input ck_bank
                  ck_ref  = string(input ck_bank, "X(2)") +
                            {&APMCMT-P-TAG46}
                            string(input ck_nbr)
                            {&APMCMT-P-TAG47}
                  ck_type = "MN".

               if recid(ck_mstr) = -1 then .

               create ap_mstr.
               assign
                  ap_domain = global_domain
                  ap_type  = "CK"
                  ap_ref   = ck_ref
                  ap_batch = batch
                  {&APMCMT-P-TAG23}
                  ap_dy_code = init-daybook.

               if recid(ap_mstr) = -1 then .

               find first gl_ctrl where gl_domain = global_domain
               no-lock no-error.

               if available gl_ctrl then
               assign
                  ap_disc_acct = gl_apds_acct
                  ap_disc_sub  = gl_apds_sub
                  ap_disc_cc   = gl_apds_cc.

               display
                  ap_batch
                  ap_disc_acct
                  ap_disc_sub
                  ap_disc_cc.

               assign
                  ap_date    = today
                  ap_effdate = today
                  ap_type    = "CK"
                  aptotal    = 0.

               find bk_mstr where bk_domain = global_domain and
                                  bk_code = string(ck_bank, "X(2)")
               no-lock no-error.

               assign
                  ap_curr   = bk_curr
                  ck_curr   = bk_curr
                  ap_acct   = useacct
                  ap_sub    = usesub
                  ap_cc     = usecc
                  newapmstr = true.
               {&APMCMT-P-TAG24}

            end.  /* IF ADDING NEW CHECK */

            else do:

               find ap_mstr where ap_mstr.ap_domain = global_domain and
                                  ap_mstr.ap_ref = ck_ref and
                                  ap_mstr.ap_type = "CK"
               exclusive-lock no-error.

               find bk_mstr where bk_domain = global_domain and
                                  bk_code = string(ck_bank, "X(2)")
               no-lock no-error.

               assign
                  aptotal = - ap_amt
                  old_effdate = ap_effdate
                  batch = ap_batch.
               {&APMCMT-P-TAG64}

               /* CONVERT QAD__01 INTO DATE FORMAT */
               {gprun.i ""gpchtodt.p""
                  "(input  ap__qad01,
                    output ap_due_date)"}

               if ap__qad01 > "" then
                  draft_yn = yes.

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

                  ap_amt_fmt = ap_amt_old.
                  {gprun.i ""gpcurfmt.p"" "(input-output ap_amt_fmt,
                       input rndmthd)"}
                  old_curr = ap_curr.

               end. /* IF AP_CURR <> OLD_CURR */

               assign
                  ap_amt:format in frame b = ap_amt_fmt
                  aptotal:format in frame b = ap_amt_fmt.

               {&APMCMT-P-TAG65}
               display
                  draft_yn
                  aptotal
                  (- ap_amt) @ ap_amt
                  ap_vend
                  ap_date
                  ap_effdate
                  ap_acct
                  ap_sub
                  ap_cc
                  ap_dy_code
                  ap_batch
                  ck_status
                  ap_curr
                  ap_due_date  when (draft_yn)
               with frame b.
               {&APMCMT-P-TAG66}
               {&APMCMT-P-TAG25}

               /* CHECK THAT RECORD IS A PAYMENT */
               if ap_type <> "CK" then do:
                  /* Must be a Payment */
                  {pxmsg.i &MSGNUM=1155 &ERRORLEVEL=3}
                  undo,retry.
               end.

               /* CHECK THAT PAYMENT IS IN BATCH */
               if batch <> "" and batch <> ap_batch then do:
                  /* Not in this batch */
                  {pxmsg.i &MSGNUM=1152 &ERRORLEVEL=3}
                  undo, retry.
               end.

               /* CHECK THAT THE CHECK IS NOT VOIDED OR CANCELED */
               find ck_mstr where ck_domain = global_domain and
                                  ck_ref = ap_ref
               no-lock no-error.

            end.  /* ELSE IF NOT ADDING NEW CHECK ... **/

            find ba_mstr where ba_domain = global_domain and
                               ba_batch  = batch and
                               ba_module = "AP"
            exclusive-lock no-error.

            display
               ba_batch @ batch
               ba_ctrl @ bactrl
               ba_total
            with frame a.

            /* BACKOUT BATCH TOTALS */
            assign
               ap_amt = - ap_amt
               ap_base_amt = - ap_base_amt
               aptotal = ap_amt.

            if ap_batch = batch then
               ba_total = ba_total - ap_amt.

            {&APMCMT-P-TAG67}
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

               ap_amt_fmt = ap_amt_old.
               {gprun.i ""gpcurfmt.p""
                  "(input-output ap_amt_fmt, input rndmthd)"}
               old_curr = ap_curr.

            end. /* IF AP_CURR <> OLD_CURR */

            assign
               ap_amt:format  in frame b = ap_amt_fmt
               aptotal:format in frame b = ap_amt_fmt.

            {&APMCMT-P-TAG68}
            display aptotal ap_batch.
            {&APMCMT-P-TAG69}

            assign
               bank = string(ck_bank, "X(2)")
               aprecid = recid(ap_mstr)
               bkrecid = recid(bk_mstr)
               ckrecid = recid(ck_mstr)
               recno = recid(ap_mstr)
               del-yn = no.

            {&APMCMT-P-TAG26}
            {&APMCMT-P-TAG70}
            display
               draft_yn
               aptotal
               ap_vend
               ap_date
               ap_effdate
               ap_acct
               ap_sub
               ap_cc
               ap_disc_acct
               ap_disc_sub
               ap_disc_cc
               ap_dy_code
               ap_rmk
               ap_curr
               ap_due_date when (draft_yn).
            {&APMCMT-P-TAG71}

            assign
               ap1recid = recid(ap_mstr)
               undo_all2 = no.

            {gprun.i ""apmcmte.p""}

            /* SS - 20070826.1 - B */
            {gprun.i ""ssapmcmae.p""}
            /* SS - 20070826.1 - E */

            if undo_all2 = yes then do:
               hide message.
               undo loopb, retry.
            end.

            global_addr = ap_vend.
            if newapmstr and base_curr <> ap_curr then do:

               assign
                  ck_ex_rate = ap_ex_rate
                  ck_ex_rate2 = ap_ex_rate2
                  ck_ex_ratetype = ap_ex_ratetype.
               /* COPY RATE USAGE FROM AP TO CK */
               {gprunp.i "mcpl" "p" "mc-copy-ex-rate-usage"
                  "(input ap_exru_seq,
                    output ck_exru_seq)"}
            end.

            if del-yn then do
            on error undo mainloop, leave:

               /* DELETE PAYMENT */
               for each ckd_det where ckd_domain = global_domain and
                                      ckd_ref = ap_ref
               exclusive-lock:

                  assign
                     ckdrecid = recid(ckd_det)
                     undo_all = yes
                     base_amt = - ckd_amt
                     curr_amt = base_amt
                     curr_disc = - ckd_disc
                     {&APMCMT-P-TAG27}
                     base_det_amt = - (ckd_amt + ckd_disc).

                  if base_curr <> ap_mstr.ap_curr then do:

                     /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input ck_curr,
                          input base_curr,
                          input ck_ex_rate,
                          input ck_ex_rate2,
                          input base_amt,
                          input true, /* ROUND */
                          output base_amt,
                          output mc-error-number)"}.
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end.

                     if ckd_voucher <> "" then do:

                        find vo_mstr where vo_mstr.vo_domain = global_domain
                                       and vo_mstr.vo_ref = ckd_voucher
                        no-lock no-error.

                        /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                        {gprunp.i "mcpl" "p" "mc-curr-conv"
                           "(input vo_curr,
                             input base_curr,
                             input vo_ex_rate,
                             input vo_ex_rate2,
                             input base_det_amt,
                             input true, /* ROUND */
                             output base_det_amt,
                             output mc-error-number)"}.
                        if mc-error-number <> 0 then do:
                           {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                        end.

                     end.

                     else do:

                        /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                        {gprunp.i "mcpl" "p" "mc-curr-conv"
                           "(input ck_curr,
                             input base_curr,
                             input ck_ex_rate,
                             input ck_ex_rate2,
                             input base_det_amt,
                             input true, /* ROUND */
                             output base_det_amt,
                             output mc-error-number)"}.
                        if mc-error-number <> 0 then do:
                           {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                        end.

                     end. /* IF CKD_VOUCHER = "" */

                  end. /* IF BASE_CURR <> AP_MSTR.AP_CURR */

                  else
                  if ckd_voucher <> "" then do:

                     find vo_mstr where vo_mstr.vo_domain = global_domain
                                    and vo_mstr.vo_ref = ckd_voucher
                     no-lock no-error.

                     if vo_mstr.vo_curr <> base_curr
                     then do:

                        /* SET curr_disc TO DISCOUNT IN TRANSACTION  */
                        /* CURRENCY WHEN PAYING A FOREIGN CURRENCY   */
                        /* VOUCHER IN BASE CURRENCY.                 */
                        /* SET curr_amt  IN TRANSACTION CURRENCY WHEN*/
                        /* PAYING A FOREIGN CURRENCY VOUCHER IN BASE */
                        /* CURRENCY. curr_amt AND curr_disc WILL BE  */
                        /* SET IN BASE CURRENCY IN APAPGL1.P         */
                        assign
                           curr_amt  = - ckd_cur_amt
                           curr_disc = - ckd_cur_disc.

                        /* RESTORED CONVERSION OF BASE_DET_AMT WHICH */
                        /* WAS COMMENTED OUT ABOVE BY FM12; THIS LED */
                        /* TO NO GAIN/LOSS TRANSACTIONS BEING        */
                        /* CREATED WHEN PAYING A FOREIGN CURRENCY    */
                        /* VOUCHER IN BASE CURRENCY                  */

                        /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                        {gprunp.i "mcpl" "p" "mc-curr-conv"
                           "(input vo_curr,
                             input base_curr,
                             input vo_ex_rate,
                             input vo_ex_rate2,
                             input -(ckd_cur_amt + ckd_cur_disc),
                             input true, /* ROUND */
                             output base_det_amt,
                             output mc-error-number)"}.
                        if mc-error-number <> 0 then do:
                           {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                        end.

                     end. /* IF VO_MSTR.VO_CURR <> BASE_CURR */

                  end.  /* IF CKD_VOUCHER <> "" */

                  if ckd_voucher <> "" then do:

                     find vo_mstr where vo_mstr.vo_domain = global_domain
                                    and vo_mstr.vo_ref = ckd_voucher
                     exclusive-lock no-error.

                     find apmstr where apmstr.ap_domain = global_domain and
                                       apmstr.ap_ref = vo_mstr.vo_ref
                                   and apmstr.ap_type = "VO"
                     exclusive-lock no-error.

                     assign
                        apbuffrecid = recid(apmstr)
                        vorecid = recid(vo_mstr)
                        tax_nbr = vo_ref
                        /* UPDATE VOUCHER APPLIED AMOUNT*/
                        amt_to_apply = ckd_amt + ckd_disc.

                     if apmstr.ap_curr <> ap_mstr.ap_curr then do:

                        /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                        {gprunp.i "mcpl" "p" "mc-curr-conv"
                           "(input ck_curr,
                             input base_curr,
                             input ck_ex_rate,
                             input ck_ex_rate2,
                             input apmstr.ap_amt,
                             input true, /* ROUND */
                             output rndamt,
                             output mc-error-number)"}.
                        if mc-error-number <> 0 then do:
                           {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                        end.

                        if rndamt = amt_to_apply then
                           amt_to_apply = apmstr.ap_amt.
                        else do:

                           /* CONVERT FROM BASE TO FOREIGN CURRENCY */
                           {gprunp.i "mcpl" "p" "mc-curr-conv"
                              "(input base_curr,
                                input ck_curr,
                                input ck_ex_rate2,
                                input ck_ex_rate,
                                input amt_to_apply,
                                input true, /* ROUND */
                                output amt_to_apply,
                                output mc-error-number)"}.
                           if mc-error-number <> 0 then do:
                              {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                           end.

                        end.

                     end. /* IF APMSTR.AP_CURR <> ... */

                     {&APMCMT-P-TAG28}
                     vo_mstr.vo_applied = vo_mstr.vo_applied - amt_to_apply.

                     /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input vo_curr,
                          input base_curr,
                          input vo_ex_rate,
                          input vo_ex_rate2,
                          input vo_mstr.vo_applied,
                          input true, /* ROUND */
                          output vo_mstr.vo_base_applied,
                          output mc-error-number)"}.
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end.

                     if vo_mstr.vo_applied = 0 then
                        vo_mstr.vo_paid_date = ?.
                     {&APMCMT-P-TAG29}
                     if apmstr.ap_amt - vo_applied = 0 then
                        apmstr.ap_open = no.
                     else
                        apmstr.ap_open = yes.
                     {&APMCMT-P-TAG30}

                     /* UPDATE VENDOR BALANCE */
                     find vd_mstr where vd_domain = global_domain
                                    and vd_addr = ap_vend
                     exclusive-lock no-error.

                     /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input vo_curr,
                          input base_curr,
                          input vo_ex_rate,
                          input vo_ex_rate2,
                          input amt_to_apply,
                          input true, /* ROUND */
                          output rndamt,
                          output mc-error-number)"}.
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end.
                     {&APMCMT-P-TAG31}

                     vd_balance = vd_balance + rndamt.

                  end.  /* IF CKD_VOUCHER <> "" */
                  {&APMCMT-P-TAG32}

                  assign
                     gain_amt = 0
                     for_curr_amt = - ckd_cur_amt.

                  {gprun.i ""apapgl1.p"" "(input true)"} /* REVERSAL */

                  if undo_all then undo mainloop, leave.

                  /* ASSIGINIG l_daybook and l_effdate TO LOCAL */
                  /* VARIABLES FOR PASSING AS A PARAMETER.      */
                  assign
                     l_daybook = ap_mstr.ap_dy_code
                     l_effdate = ap_mstr.ap_effdate.

                  if daybooks-in-use
                  then do:

                     /* NRM SEQUENCE GENERATED ONLY WHEN GL REF */
                     /* IS NEW.                                 */
                     if l_new_gl = yes
                     then do:

                        {gprunp.i "nrm" "p" "nr_dispense"
                           "(input  l_daybook,
                             input  l_effdate,
                             output nrm-seq-num)"}

                        l_new_gl = no.

                     end. /* IF l_new_gl = yes */

                     /* CALL assign_nrm_seq_number TO ASSIGN SEQ */
                     /* ONLY TO glt_det FOR DELETED RECORDS.     */

                     {pxrun.i
                         &PROGRAM='apgl.p'
                         &PROC='assign_nrm_seq_number'
                         &PARAM= "(input nrm-seq-num,
                                   input l_daybook,
                                   input ref,
                                   input-output table tt_ckd_manual)"
                      }

                      assign
                         l_daybook = ""
                         l_effdate  = ?.

                  end. /* IF daybooks-in-use */

                  if ap_mstr.ap_curr <> base_curr
                  then
                     l_base_amt  = base_amt + l_base_amt.


                  {&APMCMT-P-TAG33}
                  {gprun.i ""txdelete.p""
                     "(input tax_tr_type,
                       input ck_ref,
                       input tax_nbr)"}
                  {&APMCMT-P-TAG34}
                  {&APMCMT-P-TAG72}
                  delete ckd_det.

               end. /*EACH CKD_DET*/

               {&APMCMT-P-TAG73}

               if ap_mstr.ap_curr <> base_curr
               then  do:

                  /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input  ck_curr,
                       input  base_curr,
                       input  ck_ex_rate,
                       input  ck_ex_rate2,
                       input  ap_mstr.ap_amt,
                       input  true, /* ROUND */
                       output l_ap_amt,
                       output mc-error-number)"}.

                  if mc-error-number <> 0
                  then do:
                     /* REASON FOR FAILURE */
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.


                  assign
                     l_ref     = ref
                     l_round   = - (l_ap_amt + l_base_amt).

                  if l_round <> 0
                  then  do:

                     /* GENERAL LEDGER ENTRIES FOR ROUNDING ERROR */
                     {gprun.i ""apglrnd.p""
                        "(input        bk_entity,
                          input        ap_mstr.ap_acct,
                          input        ap_mstr.ap_sub,
                          input        ap_mstr.ap_cc,
                          input        ap_mstr.ap_curr,
                          input        ck_ex_rate,
                          input        ck_ex_rate2,
                          input        ck_ex_ratetype,
                          input        ck_exru_seq,
                          input        ck_voideff,
                          input        ap_mstr.ap_effdate,
                          input        ap_mstr.ap_batch,
                          input        ap_mstr.ap_vend,
                          input        ap_mstr.ap_ref,
                          input        ap_mstr.ap_type,
                          input        ap_mstr.ap_dy_code,
                          input        l_ref,
                          input        l_round)"}

                     l_round    = 0.

                  end. /* IF l_round  <> 0 */

                  l_ap_amt = 0.

               end.  /* IF ap_mstr.ap_curr <>  base_curr */

               l_base_amt = 0.

               {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                  "(input ck_exru_seq)"}
               delete ck_mstr.
               {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                  "(input ap_exru_seq)"}
               delete ap_mstr.
               clear frame b.
               del-yn = no.
               next loopb.

            end.  /* IF DEL-YN...*/

            {&APMCMT-P-TAG74}
            find vd_mstr where vd_domain = global_domain and
                               vd_addr = input ap_vend
            exclusive-lock no-error.
            {&APMCMT-P-TAG75}
            display vd_sort.
            {&APMCMT-P-TAG76}
            {&APMCMT-P-TAG35}

            /* ENTER CHECK DISTRIBUTION */
            {gprun.i ""apmcmta.p""}

            /* IF NOT GENERATED, nrm-seq-num WILL HAVE    */
            /* PREVIOUS VALUE.                            */

            assign
               l_daybook = ap_mstr.ap_dy_code
               l_effdate = ap_mstr.ap_effdate.


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

               /* CALL assign_nrm_seq_number TO ASSIGN SEQUENCE      */
               /* NUMBER TO ckd_det AND glt_det FOR ADDED AND        */
               /* MODIFIED RECORDS, AND glt_det FOR DELETED RECORDS. */

               {pxrun.i
                   &PROGRAM='apgl.p'
                   &PROC='assign_nrm_seq_number'
                   &PARAM= "(input nrm-seq-num,
                             input l_daybook,
                             input ref,
                             input-output table tt_ckd_manual)"
                }

                assign
                   l_daybook = ""
                   l_effdate  = ?.

            end. /* IF daybooks-in-use */

            {&APMCMT-P-TAG77}
            {&APMCMT-P-TAG36}

            if newapmstr then do:
               {&APMCMT-P-TAG37}
               vd_last_ck = max(vd_last_ck,ap_mstr.ap_date).
               if vd_last_ck = ? then
                  vd_last_ck = ap_mstr.ap_date.
            end.

            if ap_mstr.ap_curr <> base_curr
            then do:

               /* CONVERT FROM FOREIGN TO BASE CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input ck_curr,
                    input base_curr,
                    input ck_ex_rate,
                    input ck_ex_rate2,
                    input ap_mstr.ap_amt,
                    input true, /* ROUND */
                    output l_ap_amt,
                    output mc-error-number)"}.
               if mc-error-number <> 0
               then do:
                  /* REASON FOR FAILURE */
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.

               assign
                  l_ref   = ref
                  l_round   = l_ap_amt - ap_mstr.ap_base_amt.

               if l_round  <>  0
               then do:

                  /* GENERAL LEDGER ENTRIES FOR ROUNDING ERROR */
                  {gprun.i ""apglrnd.p""
                     "(input        bk_entity,
                       input        ap_mstr.ap_acct,
                       input        ap_mstr.ap_sub,
                       input        ap_mstr.ap_cc,
                       input        ap_mstr.ap_curr,
                       input        ck_ex_rate,
                       input        ck_ex_rate2,
                       input        ck_ex_ratetype,
                       input        ck_exru_seq,
                       input        ck_voideff,
                       input        ap_mstr.ap_effdate,
                       input        ap_mstr.ap_batch,
                       input        ap_mstr.ap_vend,
                       input        ap_mstr.ap_ref,
                       input        ap_mstr.ap_type,
                       input        ap_mstr.ap_dy_code,
                       input        l_ref,
                       input        l_round)"}

                  assign
                     ap_mstr.ap_base_amt = l_ap_amt
                     l_round             = 0.

               end. /* IF l_round <> 0 */

               l_ap_amt = 0.

            end. /* IF ap_mstr.ap_curr <> base_curr */

            find first ckd_det where ckd_domain = global_domain and
                                     ckd_ref = ap_mstr.ap_ref
            no-lock no-error.

            if not available ckd_det then do:
               /* Deleting Reference */
               {pxmsg.i &MSGNUM=1159 &ERRORLEVEL=2}
               delete ap_mstr.
               {&APMCMT-P-TAG88}
               delete ck_mstr.
               pause.
               {&APMCMT-P-TAG78}
            end.

            else do:
               /* STORE PAYMENT AMOUNTS AS NEGATIVES */
               assign
                  ap_mstr.ap_amt = - ap_mstr.ap_amt
                  ap_mstr.ap_base_amt = - ap_mstr.ap_base_amt.
               {&APMCMT-P-TAG38}
               if ap_mstr.ap_amt <> 0 then
                  ap_mstr.ap_open = yes.
               else
                  ap_mstr.ap_open = no.
               {&APMCMT-P-TAG39}

               /* STORE DUE DATE (USED FOR DRAFTS) */
               /* IN QAD FIELD UNTIL               */
               /* DATABASE CAN BE MODIFIED         */
               if draft_yn then
               ap__qad01 = string(year(ap_due_date),"9999")
                         + string(month(ap_due_date),"99")
                         + string(day(ap_due_date),"99").
            end.

            if available ap_mstr and ap_mstr.ap_batch = batch then
               ba_total = ba_total - ap_mstr.ap_amt.

            {&APMCMT-P-TAG79}

            repeat:   /* TRAP UNDO */

               if available ap_mstr then do:

                  assign
                     action      = "2"
                     apamt       = - ap_mstr.ap_amt
                     ctrldiff    = apamt - aptotal.

                  {&APMCMT-P-TAG85}
                  if aptotal <> apamt and aptotal <> 0 then do:
                     bell.
                     /* Control: # Distribution: # Difference: */
                     {pxmsg.i &MSGNUM=1163 &ERRORLEVEL=1
                              &MSGARG1=aptotal
                              &MSGARG2=apamt
                              &MSGARG3=ctrldiff}
                     {&APMCMT-P-TAG80}
                     /*V8-*/
                     /* ACTION - 1:Accept/2:Edit/3:Cancel */
                     {pxmsg.i &MSGNUM=1721 &ERRORLEVEL=1 &CONFIRM=action}
                     /* 1:Accept/2:Edit/3:Cancel */
                     /*V8+*/
                     /*V8!
                     /* ADDED SECOND, THIRD, FOURTH AND FIFTH PARAMETER */
                     {gprun.i ""gpaecupd.p""
                              "(input-output action,
                                input 1721,
                                input getTermLabel('&Accept', 9),
                                input getTermLabel('&Edit', 9),
                                input getTermLabel('&Cancel', 9))"}
                     */
                     if action = "2"
                     then do:
                        newapmstr = false.
                        next loopc.
                     end.
                     else
                        if action = "3" then
                        undo loopb, retry.

                  end. /* if aptotal <> apamt */

               end. /* AVAILABLE AP_MSTR */

               leave. /* TRAP UNDO */

            end. /* REPEAT */

            leave.

         end. /* LOOPC */

         {&APMCMT-P-TAG40}

      end. /* TRANSACTION */ /* DO ON ERROR */

      {&APMCMT-P-TAG81}
      {&APMCMT-P-TAG90}

   end.  /* LOOPB */

   {&APMCMT-P-TAG82}
   {gprun.i ""apmcmtf.p""}

end. /* MAINLOOP */

status input.
{&APMCMT-P-TAG41}
