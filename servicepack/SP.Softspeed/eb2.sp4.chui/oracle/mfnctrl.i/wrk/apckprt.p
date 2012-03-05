/* apckprt.p - AP CHECK PRINTING                                             */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.20.1.20 $                                             */
/*V8:ConvertMode=Report                                                      */
/* REVISION: 1.0      LAST MODIFIED: 10/18/86   BY: PML                      */
/* REVISION: 6.0      LAST MODIFIED: 09/03/91   BY: mlv *D843*               */
/*                                   11/01/91   BY: mlv *D909*               */
/*                                   11/04/91   BY: mlv *D910*               */
/* REVISION: 7.0      LAST MODIFIED: 11/04/91   BY: mlv *F031*               */
/*                                   11/12/91   BY: mlv *F037*               */
/*                                   12/13/91   BY: mlv *F074*               */
/*                                   01/31/92   BY: mlv *F115*               */
/*                                   02/11/92   BY: mlv *F194*               */
/*                                   02/19/92   BY: mlv *F224*               */
/*                                   05/14/92   BY: mlv *F494*               */
/*                                   05/15/92   BY: mlv *F498*               */
/*                                   08/07/92   BY: mlv *F836*               */
/* REVISION: 7.3      LAST MODIFIED: 09/10/92   BY: mlv *G059*               */
/*                                   09/15/92   BY: mlv *G060*               */
/*                                   10/20/92   BY: mpp *G212*               */
/*                                   10/30/92   BY: jcd *G258*               */
/*                                   11/24/92   BY: jjs *G355* (rev only)    */
/*                                   11/24/92   BY: jjs *G356* (rev only)    */
/*                                   12/01/92   BY: bcm *G373*               */
/*                                   01/04/92   BY: mpp *G475*               */
/*                                   02/16/93   by: jms *G690*               */
/*                                   03/12/93   by: jms *G807* (rev only)    */
/*                                   03/23/93   by: bcm *G863* (rev only)    */
/*                                   04/17/93   by: bcm *G966* (rev only)    */
/*                                   04/19/93   by: bcm *G976* (rev only)    */
/*                                   04/26/93   by: bcm *GA38*               */
/*                                   05/13/93   by: bcm *GA91*               */
/*                                   06/21/93   by: wep *GC59*               */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   BY: pcd *H039*               */
/*                                   09/12/93   BY: wep *H111*               */
/*                                   10/13/93   BY: jjs *H181*               */
/*                                   10/22/93   BY: wep *H183*               */
/*                                   12/02/93   BY: jjs *H262*               */
/*                                   03/10/94   BY: jjs *FM81*               */
/*                                   08/23/94   BY: cpp *GL39*               */
/*                                   09/12/94   by: slm *GM17*               */
/*                                   11/01/94   by: rmh *FT16*               */
/*                                   11/12/94   by: str *FT60*               */
/*                                   10/29/94   BY: bcm *GN72*               */
/*                                   01/03/95   BY: jzw *H09N*               */
/*                                   01/23/95   BY: jzw *F0FV*               */
/*                                   02/13/95   BY: str *H0B8*               */
/*                                   02/28/95   BY: jzw *F0KP*               */
/*                                   03/22/95   BY: smp *F0NQ*               */
/*                                   05/19/95   BY: jzw *H0DN*               */
/* REVISION: 8.5      LAST MODIFIED: 07/11/95   BY: cdt *J057*               */
/* REVISION: 8.6      LAST MODIFIED: 06/17/96   BY: bjl *K001*               */
/* REVISION: 8.6      LAST MODIFIED: 09/16/96   BY: rxm *G2F2*               */
/*       ORACLE PERFORMANCE FIX      11/19/96   BY: rxm *H0PQ*               */
/*                                   12/11/96   BY: bjl *K01S*               */
/*                                   01/23/97   BY: bkm *G2KB*               */
/*                                   01/29/97   BY: *K05F* Eugene Kim        */
/*                                   02/12/97   BY: *K01G* E. Hughart        */
/*                                   02/17/97   BY: *K01R* E. Hughart        */
/*                                   05/05/97   BY: *H0X5* Robin McCarthy    */
/* REVISION: 8.6      LAST MODIFIED: 12/04/97   BY: *H1H1* Irine D'mello     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 03/31/98   BY: *J2D8* Kawal Batra       */
/* ADDED NO-UNDO, ASSIGN THROUGHOUT                                          */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton      */
/* Pre-86E commented code removed, view in archive revision 1.18             */
/* Old ECO marker removed, but no ECO header exists *B352*                   */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton      */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 06/08/99   BY: *N00G* Jean Miller       */
/* REVISION: 9.1      LAST MODIFIED: 08/04/99   BY: *J3K6* Brenda Milton     */
/* REVISION: 9.1      LAST MODIFIED: 08/25/99   BY: *L0H7* Ranjit Jain       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Brian Compton     */
/* REVISION: 9.1      LAST MODIFIED: 11/08/99   BY: *N03C* Kieran O Dea      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 05/04/00   BY: *N09S* Kieran O Dea      */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.20.1.12     BY: Hualin Zhong        DATE: 05/18/01 ECO: *N0YT* */
/* Revision: 1.20.1.15     BY: Veena Lad           DATE: 09/13/01 ECO: *M1HL* */
/* Revision: 1.20.1.16     BY: Ed van de Gevel     DATE: 11/02/01 ECO: *N15M* */
/* Revision: 1.20.1.18     BY: Rajaneesh S.        DATE: 03/18/02 ECO: *N1DK* */
/* Revision: 1.20.1.19     BY: Manjusha Inglay     DATE: 07/29/02 ECO: *N1P4* */
/* $Revision: 1.20.1.20 $     BY: Mercy Chittilapilly DATE: 08/19/02 ECO: *N1RM* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "2+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apckprt_p_1 "Supplier Bank"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckprt_p_2 "Starting Draft"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckprt_p_3 "Starting Check"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckprt_p_5 "Payment File"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckprt_p_6 "Check Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckprt_p_7 "Print Voucher Remarks"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckprt_p_8 "Bank Acct/Giro Acct"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckprt_p_9 "Print Test Check"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckprt_p_11 "Print Audit Trail"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckprt_p_12 "Account Type"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckprt_p_13 "Due Date"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{gldydef.i new}
{gldynrm.i new}

define new shared variable ckrecid           as recid.
define new shared variable aprecid           as recid.
define new shared variable ba_recno          as recid.
define new shared variable bkrecid           as recid.
define new shared variable next_temp_ck      as integer.
define new shared variable bankacct1         as decimal
   format ">>>>>>>>>>>>>>9999999999".
define new shared variable hash_total        as decimal
   format ">>>>>>>>>>>>>>>>>9999999999". /* 27 digits */
define new shared variable printype1         as character.
define new shared variable trtype            as character initial "auto".
define new shared variable ref               as character format "X(14)".
define new shared variable file_name         as character format "X(12)"
   label {&apckprt_p_5}.
define new shared variable do_11_ck          like mfc_logical.
define new shared variable undo_all          like mfc_logical.
define new shared variable first_check       like mfc_logical.
define new shared variable pay_spec          like mfc_logical.
define new shared variable bk_val            like mfc_logical.
define new shared variable bk1_ok            like mfc_logical.
define new shared variable bk2_ok            like mfc_logical.
define new shared variable spot_rate         like mfc_logical.
define new shared variable print_rmk         like mfc_logical
   label {&apckprt_p_7} initial yes.
define new shared variable bank_giro         like mfc_logical
   format {&apckprt_p_8} initial yes.
define new shared variable chk               like mfc_logical
   initial false.
define new shared variable draft             like mfc_logical
   initial false.
define new shared variable batch             like ap_batch.
define new shared variable bank              like bk_code.
define new shared variable jrnl              like glt_ref.
define new shared variable ckfrm             like apc_ckfrm.
define new shared variable path1             like prd_path.
define new shared variable spooler1          like prd_spooler.
define new shared variable effdate           like ap_effdate
   initial today.
define new shared variable cknbr             like ck_nbr
   label {&apckprt_p_3}.
define new shared variable ckdate            like ap_date
   initial today label {&apckprt_p_6}.
define new shared variable gen_desc          like glt_desc.
define new shared variable base_amt          like ap_amt.
define new shared variable base_disc         like ap_amt.
define new shared variable gain_amt          like ap_amt.
define new shared variable curr_amt          like glt_curr_amt.
define new shared variable curr_disc         like glt_curr_amt.
define new shared variable base_det_amt      like glt_amt.
define new shared variable scrollonly1       like prd_scroll_only.
define new shared variable useacct           like ap_acct.
define new shared variable usesub            like ap_sub.
define new shared variable usecc             like ap_cc.
define new shared variable check_rate        like exr_rate.
define new shared variable check_rate2       like exr_rate2.
define new shared variable check_ratetype    like exr_ratetype no-undo.
define new shared variable check_exru_seq    like exru_seq no-undo.
define new shared variable error_flg         like mfc_logical.
define new shared variable bk_acct_type_code like ad_addr
   initial "2".  /* PRT */
define new shared variable suppbank          like ad_addr
   label {&apckprt_p_1}.
define new shared variable fname             like lngd_dataset no-undo
   initial "csbd_det".
define new shared variable drftnbr           like ck_nbr
   label {&apckprt_p_2}.
define new shared variable duedate           like ap_date
   label {&apckprt_p_13}.
define new shared variable csbdtype          like ad_addr format "X(2)"
   label {&apckprt_p_12}.

/* VARIABLE TO STORE BANK ACCOUNT SO THAT LEADING ZEROS ARE  */
/* RETAINED FOR CHECK FORM "3" and "4" AND                   */
/* BANK ACCOUNT VALIDATION AS BLANK                          */
define new shared variable l_bankacct1       like bk_bk_acct1
   format "x(24)"  no-undo.

define variable i                   as integer  no-undo.
define variable topayfrom           as character format "x(60)"  no-undo.
define variable yn                  like mfc_logical  no-undo.
define variable print_test          like mfc_logical
   label {&apckprt_p_9} initial no  no-undo.
define variable audit_trail         like mfc_logical
   label {&apckprt_p_11} initial yes  no-undo.
define variable void_range          like mfc_logical  no-undo.
define variable reset_check         like mfc_logical initial true  no-undo.
define variable isvalid             like mfc_logical  no-undo.
define variable bk_acct_type        like ad_addr format "x(3)"
   label {&apckprt_p_12}  no-undo.
define variable bk_acct1            like ad_bk_acct1  no-undo.
define variable bk_acct2            like ad_bk_acct1  no-undo.
define variable bk_acct_type_desc   like glt_desc  no-undo.
define variable init-daybook        like dy_dy_code  no-undo.
define variable mc-error-number     like msg_nbr no-undo.
define variable fixed_rate_not_used like mfc_logical no-undo.
define variable l_error             like mfc_logical no-undo initial no.

define new shared buffer apmstr  for ap_mstr.
define new shared buffer prd_det for prd_det.

define new shared stream prt.

define new shared workfile ckw_wkfl
   field ckw_bankno like ad_bk_acct1
   field ckw_cknbr  like ck_nbr
   field ckw_curr   like ck_curr
   field ckw_ref    like ap_ref.

{gpglefdf.i}

form
   bank           colon 25
   ckfrm          colon 25 format "x(1)"
   bk_acct_type   colon 55 skip(1)
   cknbr          colon 25 format "999999"
   ckdate         colon 25
   effdate        colon 25
   duedate        colon 25 skip(1)
   audit_trail    colon 30
   print_rmk      colon 30
   print_test     colon 30
   batch          colon 30
   dft-daybook    colon 30
   topayfrom      at 19 no-label skip
   file_name      colon 30 skip
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

gen_desc = getTermLabel("AP_PAYMENT",24).

for first apc_ctrl
   fields (apc_bank apc_ckfrm apc_jrnl apc_pip)
no-lock:
end.

ckfrm = apc_ckfrm.

for first bk_mstr
   fields (bk_acct bk_bk_acct1 bk_bk_acct2 bk_cc bk_check
   bk_sub bk_dftap_sub bk_pip_sub
   bk_code bk_curr bk_dftap_acct bk_dftap_cc bk_entity
   bk_pip_acct bk_pip_cc)
   where bk_code = apc_bank
no-lock:
end.

/* GET PIP ACCT OR CASH ACCT, WILL BE OVERIDDEN LATER FOR DRAFTS */
assign
   useacct = bk_acct
   usesub  = bk_sub
   usecc   = bk_cc.

if apc_pip and bk_pip_acct <> ""
   then
assign
   useacct = bk_pip_acct
   usesub  = bk_pip_sub
   usecc   = bk_pip_cc.

assign
   bankacct1   = 0
   l_bankacct1 = "".

if not available bk_mstr
   then
for first bk_mstr
   fields (bk_acct bk_bk_acct1 bk_bk_acct2 bk_cc bk_check
   bk_sub bk_dftap_sub bk_pip_sub
   bk_code bk_curr bk_dftap_acct bk_dftap_cc bk_entity
   bk_pip_acct bk_pip_cc)
   where bk_code >= ""
no-lock:
end.

if available bk_mstr
   then
   bank = bk_code.

display bank with frame a.

for first gl_ctrl
   fields (gl_bk_val)
no-lock:
end.

if gl_bk_val    = "12"
   or gl_bk_val = "11"
   then
   bk_val = yes.

/* BEGIN CHECK PROCESSING */
repeat:
   mainloop:

   /* SEPERATED THE USER INTERFACE FROM TRANSACTION BLOCK */
   do on error undo, retry:
      assign
         l_error    = no
         hash_total = 0.

      set bank with frame a.

      /* ISSUE ERROR WHEN THE BANK IS IN USE BY ANOTHER USER */
      run p_is_bank_in_use.
      if l_error
         then
         undo mainloop, retry.

      /* VALIDATE BANK */
      for first bk_mstr
         fields (bk_acct bk_bk_acct1 bk_bk_acct2 bk_cc bk_check
         bk_sub bk_dftap_sub bk_pip_sub bk_code bk_curr
         bk_dftap_acct bk_dftap_cc bk_entity bk_pip_acct
         bk_pip_cc)
         where bk_code = bank
      no-lock:
      end. /* FOR FIRST bk_mstr */

      if not available bk_mstr
      then do:
         /* NOT A VALID BANK */
         {pxmsg.i &MSGNUM=1200 &ERRORLEVEL=3}
         bell.
         undo mainloop, retry.
      end.

      else do:
         assign
            useacct = bk_acct
            usesub  = bk_sub
            usecc   = bk_cc.

         /* SCOPE apc_ctrl TO CURRENT BLOCK */
         for first apc_ctrl
            fields (apc_bank apc_ckfrm apc_jrnl apc_pip)
         no-lock:
         ckfrm = apc_ckfrm.

         if apc_pip
            and bk_pip_acct <> ""
            then
         assign
            useacct = bk_pip_acct
            usesub  = bk_pip_sub
            usecc   = bk_pip_cc.

         end. /* FOR FIRST apc_ctrl */

         {gprun.i ""gldydft.p"" "(input ""AP"",
              input ""CK"",
              input bk_entity,
              output dft-daybook,
              output daybook-desc)"}

         init-daybook = dft-daybook.

      end.

      cknbr = bk_check.

      /* DO NOT CHECK FOR THE ckfrm SINCE IT DOES NOT RESET THE  */
      /* Starting Check TO THE DEFAULT OF THE NEXT BANK WHEN     */
      /* END-ERROR IS PRESSED AND THE NEXT BANK IS ENTERED       */

      /* DO NOT OVERWRITE USER'S ENTERED DATA */
      if not cknbr entered
         and not ckdate entered
         and not effdate entered
         and not duedate entered
         and not print_rmk entered
         and not audit_trail entered
         and not print_test entered
         then
      display
         cknbr
         ckdate
         effdate
         duedate
         ckfrm
         "" @ bk_acct_type
         audit_trail
         print_rmk
         print_test
         init-daybook @ dft-daybook
         "" @ topayfrom
      with frame a.

      /* GET DEFAULT FOR ACCOUNT TYPE */
      {gplngn2a.i &file = ""csbd_det""
         &field = ""bk_acct_type""
         &code  = bk_acct_type_code
         &mnemonic = bk_acct_type
         &label = bk_acct_type_desc}

      set_frm:
      do with frame a on error undo, retry:
         assign
            chk   = false
            draft = false.
         set ckfrm with frame a.

         /* SET FLAG TO INDICATE WHETHER THE CHECK FORM */
         /* INDICATES A "CHECK" OR A "DRAFT"            */
         if lookup(ckfrm,"5,6,7") = 0
            then
            chk = true.
         else
         assign
            draft   = true
            /* OVERRIDE CASH OR PIP ACCOUNT */
            useacct = bk_dftap_acct
            usesub  = bk_dftap_sub
            usecc   = bk_dftap_cc.

         /* VERIFY CHECK FORM */
         if ckfrm = ""
         then do:
            /* BLANK NOT ALLOWED */
            {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
            next-prompt ckfrm with frame a.
            undo set_frm, retry.
         end.

         {gpckfval.i &ckfrm=ckfrm
            &undoloop=set_frm
            &curr=bk_curr
            &error-warning=3
            &frame="a"}

         /* IF CHECKFORM <> 1 OR 2                     */
         /* FIND AND DISPLAY BANKACCT TO BE PAID FROM  */
         /* ADDED SEVENTH OUTPUT PARAMETER l_bankacct1 */

         {gprun.i ""apbkval.p"" "(input  bk_val,
              input  bk_bk_acct1,
              input  bk_bk_acct2,
              output bk1_ok,
              output bk2_ok,
              output bankacct1,
              output l_bankacct1)"}

         if ckfrm     <> "1"
            and ckfrm <> "2"
         then do:

            if bk1_ok
               then
               bank_giro = yes.
            else
         if bk2_ok
               then
               bank_giro = no.
            else do:
               if ckfrm = "3"
                  then
                  bank_giro = yes.
               else do:
                  /* INVALID BANK/GIRO ACCOUNT NUMBER */
                  {pxmsg.i &MSGNUM=183 &ERRORLEVEL=2}
               end.
            end.
            if ckfrm    = "3"
               or ckfrm = "4"
            then do:

               if bk_val then
               topayfrom = getTermLabel("TO_PAY_FROM",15)
               + ": "
               + string(bank_giro,
                  getTermLabel("BANK_ACCT/GIRO_ACCT", 25))
                  + " "
                  + string(bankacct1).
               else
               topayfrom = getTermLabel("TO_PAY_FROM",15)
               + ": "
               + string(bank_giro,
                  getTermLabel("BANK_ACCT/GIRO_ACCT", 25))
                  + " "
                  + l_bankacct1.

               display topayfrom with frame a.

            end.  /* IF ckfrm = "3", "4" */
         end.  /* IF ckfrm <> "1", "2" */

         /* SEPARATED THIS UPDATE FROM SETA UPDATE */
         if ckfrm > "2"
         then do:
            setaa:
            do with frame a on error undo, retry:
               display bk_acct_type.
               set bk_acct_type with frame a.

               /* VALIDATE ACCOUNT TYPE - MUST BE IN lngd_det */
               {gplngv.i &file     = ""csbd_det""
                  &field    = ""bk_acct_type""
                  &mnemonic = bk_acct_type
                  &isvalid  = isvalid}

               /* DISALLOW IF PRT/2 SUPP BANK AND EDI CHECK FORM */
               {gplnga2n.i &file     = ""csbd_det""
                  &field    = ""bk_acct_type""
                  &mnemonic = bk_acct_type
                  &code     = bk_acct_type_code
                  &label    = bk_acct_type_desc}
               if (ckfrm    = "3"
                  or ckfrm = "4")
                  and bk_acct_type_code = "2"
                  then
                  isvalid = false.

               if not isvalid
               then do:
                  /* INVALID MNEMONIC bk_acct_type */
                  {pxmsg.i &MSGNUM=3169 &ERRORLEVEL=3}
                  next-prompt bk_acct_type with frame a.
                  undo setaa, retry.
               end.

            end. /* SETAA */
         end. /*IF ckfrm > "2"*/

         /* SCOPE INCREASED AFTER ACCOUNT TYPE */
      end. /* SET_FRM */

      /* DEFAULT DUE DATE TO 90 DAYS IN THE FUTURE */
      if draft
         then
         duedate = today + 90.

      display
         duedate
         bk_acct_type when (ckfrm > "2")
      with frame a.

      /* IN UI, FIELDS FROM Starting Check TO Daybook WILL PROMPT */
      /* TO Bank INSTEAD OF Check Form ON END-ERROR               */

      seta:
      do with frame a on error undo, retry:

         /* OBTAIN REMAINING INFORMATION */
         set
            cknbr
            ckdate
            effdate
            duedate when (draft)
            audit_trail
            print_rmk
            print_test
            dft-daybook when (daybooks-in-use)
         with frame a.

         display
            cknbr
            ckdate
            effdate
            duedate when (draft)
            audit_trail
            print_rmk
            print_test
            dft-daybook when (daybooks-in-use)
         with frame a.

         if ckfrm = "3"
            and audit_trail = no
         then do:
            audit_trail = yes.
            display audit_trail with frame a.
            bell.
            /* CHECK FORM 3 AUDIT TRAIL SET TO YES */
            {pxmsg.i &MSGNUM=1222 &ERRORLEVEL=1}
         end.

         if lookup(ckfrm,"3,4") <> 0
            and print_test = yes
         then do:
            print_test = no.
            display print_test with frame a.
            bell.
            /* CHECK FORM 3,4             */
            /* PRINT TEST CHECK SET TO NO */
            {pxmsg.i &MSGNUM=1225 &ERRORLEVEL=1}
         end.

         /* VERIFY EFFECTIVE DATE */
         {gpglef.i ""AP"" bk_entity effdate}
         assign
            check_rate  = 1
            check_rate2 = 1
            spot_rate   = no.

         if base_curr <> bk_curr
         then do:

            /* GET EXCHANGE RATE, CREATE TEMPORARY USAGE */
            {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
               "(input bk_curr,
                 input base_curr,
                 input check_ratetype,
                 input effdate,
                 output check_rate,
                 output check_rate2,
                 output check_exru_seq,
                 output mc-error-number)"}
            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
               undo, retry.
            end.

            /* SPOT RATE */
            spot_rate = yes.

            /* ALLOW ENTRY OF NEW SPOT RATE */
            {gprunp.i "mcui" "p" "mc-ex-rate-input"
               "(input bk_curr,
                 input base_curr,
                 input effdate,
                 input check_exru_seq,
                 input false,
                 input 17,
                 input-output check_rate,
                 input-output check_rate2,
                 input-output fixed_rate_not_used)"}

         end. /* IF base_curr <> bk_curr */

         /* IF DRAFT, DUE DATE IS REQUIRED */
         if draft and duedate = ?
         then do:
            /* DUE DATE IS REQUIRED FOR DRAFTS */
            {pxmsg.i &MSGNUM=3544 &ERRORLEVEL=3}
            next-prompt duedate with frame a.
            undo seta, retry.
         end.

         /* VERIFY DAYBOOK */
         if daybooks-in-use
         then do:
            if not can-find(dy_mstr where dy_dy_code = dft-daybook)
            then do:
               /* ERROR: INVALID DAYBOOK */
               {pxmsg.i &MSGNUM=1299 &ERRORLEVEL=3}
               next-prompt dft-daybook with frame a.
               undo seta, retry.
            end.
            else do:
               {gprun.i ""gldyver.p"" "(input ""AP"",
                    input ""CK"",
                    input dft-daybook,
                    input gl_trans_ent,
                    output daybook-error)"}
               if daybook-error
               then do:
                  /* WARNING: DAYBOOK DOES NOT MATCH ANY DEFAULT */
                  {pxmsg.i &MSGNUM=1674 &ERRORLEVEL=2}
                  pause.
               end.

               {gprunp.i "nrm" "p" "nr_can_dispense"
                  "(input dft-daybook,
                    input effdate)"}

               {gprunp.i "nrm" "p" "nr_check_error"
                  "(output daybook-error,
                    output return_int)"}

               if daybook-error
               then do:
                  {pxmsg.i &MSGNUM=return_int &ERRORLEVEL=3}
                  next-prompt dft-daybook with frame a.
                  undo seta, retry.
               end.

               for first dy_mstr
                  fields (dy_desc dy_dy_code)
                  where dy_dy_code = dft-daybook
               no-lock:
               end.

               if available dy_mstr then
                  daybook-desc = dy_desc.

            end. /* IF CAN-FIND(dy_mstr ...) */
         end. /* IF daybooks-in-use */

         /* FIND FILE NAME AND UPDATE */
         file_name = "".

         if lookup(ckfrm,"1,2,3,5,6,7") = 0
            then
            seta_sub:
         do on error undo, retry:
            assign
               file_name = string(today,"999999")
               file_name = bank +
               substring(file_name,5,2) +
               substring(file_name,1,2) +
               substring(file_name,3,2)
               file_name = file_name + ".pmt".

            update file_name with frame a.
            if search(file_name) <> ?
               or file_name       = " "
            then do:
               /* INVALID FILE NAME */
               {pxmsg.i  &MSGNUM=184 &ERRORLEVEL=3}
               next-prompt file_name.
               undo seta_sub, retry.
            end.

         end. /* SETA_SUB */

         output stream prt close.

         /*CALL GENERIC OUTPUT DESTINATION SELECTION INCLUDE.
         OUTPUT DESTINATIONS OF TYPE Email AND Winprint
         (Windows Printer) ARE NOT ALLOWED*/

         {gpselout.i &printType = "printer"
            &printWidth = 80
            &pagedFlag = "nopage"
            &stream = " "
            &appendToFile = " "
            &streamedOutputToTerminal = " "
            &displayStatementType = 1
            &withBatchOption = "no"
            &withCancelMessage = "yes"
            &pageBottomMargin = 6
            &withEmail = "no"
            &withWinprint = "no"
            &defineVariables = "yes"}

         output close.

         assign
            spooler1    = spooler
            scrollonly1 = scrollonly
            printype1   = printype
            path1       = path.

         /*OBTAIN BATCH NUMBER AND GENERATE "UNUSED" BATCH MASTER*/
         {gprun.i ""gpgetbat.p""
            "(input  """",        /*IN-BATCH #     */
              input  ""AP"",      /*MODULE         */
              input  ""CK"",      /*DOC TYPE       */
              input  "0",         /*CONTROL AMOUNT */
            output ba_recno,    /*NEW BATCH RECID*/
            output batch)"}     /*NEW BATCH #    */

              /* GET NEXT JOURNAL REFERENCE NUMBER  */
              {mfnctrl.i apc_ctrl apc_jrnl glt_det glt_ref jrnl}

              display batch with frame a.

              end. /* SETA */

              bk_block:
              repeat:

              /* WHEN MULTIPLE USERS PROCESS FOR SAME BANK AT SAME */
              /* TIME (i.e. BOTH ENTER THE UI AT THE SAME TIME)    */
              /* AND ONE OF THE USERS STARTS PROCESSING FIRST,     */
              /* DISPLAY ERROR MESSAGE TO OTHER USER               */
              run p_is_bank_in_use.
              if l_error
              then
              undo mainloop, retry.

              /* PLACE EXCLUSIVE LOCK ON bk_mstr TO OBTAIN NEXT CHECK# */
              find first bk_mstr
              where bk_code = bank
           exclusive-lock no-error no-wait.

              /* IN ORACLE, SINCE qad_wkfl RECORD IS NOT COMMITED */
              /* HENCE ADDED THE bk_mstr CHECK                    */
              if locked bk_mstr
           then do:
              /* CHECK PROCESSING IN USE BY ANOTHER USER */
              {pxmsg.i &MSGNUM=1217 &ERRORLEVEL=3}
              bell.
              undo mainloop, retry.
              end. /* IF LOCKED bk_mstr */

              /* SET BANK CHECK OR DRAFT NUMBER TO STARTING NUMBER   */
              /* CHECKS & DRAFTS USE THE SAME # RANGE                */
              if available bk_mstr
              then
              assign
              bk_check = cknbr
              bkrecid  = recid(bk_mstr).

              /* CREATE WORKFILE ENTRY TO FLAG PROCESSING FOR BANK */
              create qad_wkfl.
              assign
              qad_key1 = "apckprt.p"
            qad_key2 = bank
            recno    = recid(qad_wkfl).

            /* PICK UP NUMERIC FOR BANK ACCOUNT TYPE CODE FROM MNEMONIC */
            {gplnga2n.i &file     = ""csbd_det""
            &field    = ""bk_acct_type""
            &mnemonic = bk_acct_type
            &code     = bk_acct_type_code
            &label    = bk_acct_type_desc}

            /* PRINTING OF TEST CHECK IS IN apckprth.p */
            if print_test
         then do:
               {gprun.i ""apckprth.p""}

               if undo_all
               or error_flg
            then do:
                  /* MAKE TEST CHECK NUMBER AVAILABLE */
                  /* ('no' WILL VOID CHECK)           */
                  {pxmsg.i &MSGNUM=1214
                  &ERRORLEVEL=1
                  &CONFIRM=reset_check}
                  if reset_check
                  then
                     undo mainloop, leave.
                  else
                     leave mainloop.
               end.

            end. /* IF print_test */

            /* INITIALIZE VARIABLES */
            next_temp_ck = - (bk_check - 1).

            for first ck_mstr
            fields (ck_bank ck_nbr ck_ref ck_voiddate ck_voideff)
            where ck_nbr < 0
            and ck_bank  = bank
         no-lock:
            end.

            if available ck_mstr then
               next_temp_ck = ck_nbr.

            {gprun.i ""apckprti.p""}

            /* PRINT THE CHECKS */
            undo_all = yes.
            if ckfrm    = "1"
            or ckfrm = "2"
         then do:
               {gprun.i ""apckprb2.p""}             /*CHECKS*/
            end.
            else
         if ckfrm    = "3"
            or ckfrm = "4"
         then do:
               {gprun.i ""apckprb3.p""}             /*EDI*/
            end.
            else
         if ckfrm    = "5"
            or ckfrm = "6"
            or ckfrm = "7"
         then do:
               {gprun.i ""apdmprb.p""}              /*DRAFTS*/
            end.

            /* CAN ONLY VOID IF FIRST CHECK PRINTED OK */
            if undo_all
            and first_check
            then
               undo mainloop.

            void_range = no.
            if undo_all
         then do:
               voidloop:
               repeat on endkey undo, retry:
                  yn = no.
                  /* DO YOU WISH TO VOID */
                  {pxmsg.i &MSGNUM=38 &ERRORLEVEL=1 &CONFIRM=yn}
                  if yn
                  then
                     void_range = yes.
                  if void_range = no
                  then
                     undo mainloop, leave.

                  if void_range
               then do:
                     undo_all = yes.
                     /* PROMPT FOR RANGE AND VOID CHECKS */
                     {gprun.i ""apvcrg.p""}

                     /* IF apvcrg.p WAS EXITED BY PRESSING F4  */
                     /* DON'T EXIT VOIDLOOP.  USER MUST DECIDE */
                     /* IF THE PRINTED CHECKS SHOULD OR SHOULD */
                     /* NOT BE VOIDED.                         */

                     if keyfunction(lastkey) = "end-error"
                     then
                        undo voidloop, retry.
                     if undo_all
                     then
                        undo mainloop, leave.
                     leave voidloop.

                  end.   /* IF void_range */
               end.  /* VOIDLOOP */
            end.  /* IF undo_all */

            /* SET FINAL STATUS FOR VOUCHERS */
            for each ck_mstr
               where ck_nbr >= cknbr
               and   ck_nbr <= (bk_check - 1)
               and   (ck_bank    = bk_code
               or ck_bank = ""):

               for each ckd_det
                  where ckd_ref = ck_ref:

                  find vo_mstr
                  where vo_ref = ckd_voucher
               exclusive-lock no-error.

                  find ap_mstr
                  where ap_type        = "VO"
                  and   ap_mstr.ap_ref = vo_ref
               exclusive-lock no-error.

                  if ck_voiddate    = ?
                  and ck_voideff = ?
               then do:
                     /* CLEAR VOUCHERS AMOUNTS FOR CHECKS NOT VOIDED */
                     if available vo_mstr
                  then do:
                        assign
                        vo_amt_chg       = 0
                        vo_base_amt_chg  = 0
                        vo_disc_chg      = 0
                        vo_base_disc_chg = 0.

                        /* UPDATE VENDOR LAST CHECK DATE */
                        if ckdate <> ?
                     then do:
                           find vd_mstr
                           where vd_addr = ap_vend
                        exclusive-lock no-error.
                           if available vd_mstr
                        then do:
                              vd_last_ck = max(vd_last_ck,ckdate).
                              if vd_last_ck = ?
                              then
                                 vd_last_ck = ckdate.
                           end. /* IF AVAILABLE vd_mstr */
                        end. /* IF ckdate <> ? */

                     end.
                  end.
                  else do:
                     /* LEAVE VOUCHERS SELECTED */
                     find ap_mstr
                     where ap_type        = "VO"
                     and   ap_mstr.ap_ref = vo_ref
                  exclusive-lock no-error.
                     ap_mstr.ap_open = true.
                  end.

               end. /* FOR EACH ckd_det */
            end. /* FOR EACH ck_mstr */

            /* PRINT PAYMENT SPECIFICATIONS FOR U.S. TYPE CHECKS IF */
            /* NECESSARY                                            */
            if (ckfrm    = "1"
            or ckfrm = "2"
            or ckfrm = "5"
            or ckfrm = "6"
            or ckfrm = "7")
            and pay_spec
         then do:
               {gprun.i ""apckprps.p""}
            end.

            /* PRINT AUDIT TRAIL */
            if audit_trail
            then do:
               {gprun.i ""apckprrp.p""}
            end.

            if ref <> ""
               and daybooks-in-use
            then do:
               /* NOW GET THE SEQUENCE NUMBER FROM THE nr_mstr */
               /* AND UPDATE THE glt_det                       */
               for first ap_mstr
                  fields(ap_day_code ap_effdate ap_open
                         ap_ref ap_type ap_vend)
                  where recid(ap_mstr) = aprecid
                  no-lock:

                  if nrm-seq-num = " "
                  then do:

                  {gprunp.i "nrm" "p" "nr_dispense"
                     "(input  ap_dy_code,
                       input  ap_effdate,
                       output nrm-seq-num)"}

                  end. /* IF nrm-seq-num  = " " */

                     for each ckd_det
                        where ckd_ref = ap_ref
                        exclusive-lock:

                        ckd_dy_num = nrm-seq-num.

                     end. /* FOR EACH ckd_det */

                  for each glt_det
                     where glt_ref = ref
                     exclusive-lock:
                     glt_dy_num = nrm-seq-num.
                  end. /* FOR EACH glt_det */
               end. /* FOR FIRST ap_mstr  */

            end. /* IF ref <> "" */

            leave bk_block.

         end.  /* BK_BLOCK */

      end.  /* MAINLOOP */

      if spot_rate           = yes
      and check_exru_seq <> 0
      then do:
         /* DELETE SPOT-RATE TEMPORARY RATE USAGE */
         {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
         "(input check_exru_seq)"}
      end.

      /* REMOVE QAD_WKFL RECORD, RELEASE BK_MSTR */
      release bk_mstr.
      do transaction:
         find first qad_wkfl
         where qad_key1 = "apckprt.p"
         and   qad_key2 = bank
      exclusive-lock no-error.
         if available qad_wkfl
         then
            delete qad_wkfl.
      end.

   end. /* REPEAT */

   /* PROCEDURE ADDED TO DISPLAY ERROR MESSAGE IF BANK */
   /* IS IN USE BY ANOTHER USER                        */

   PROCEDURE p_is_bank_in_use:

      if can-find(first qad_wkfl
      where qad_key1 = "apckprt.p"
      and   qad_key2 = bank)
   then do:
         l_error = yes.
         /* CHECK PROCESSING IN USE BY ANOTHER USER */
         {pxmsg.i &MSGNUM=1217 &ERRORLEVEL=3}
         bell.
      end. /* IF CAN-FIND(FIRST qad_wkfl ...) */

   END PROCEDURE. /* PROCEDURE p_is_bank_in_use */
