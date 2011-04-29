/* womtacct.p - WORK ORDER MAINTENANCE ACCOUNTING DATA                        */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.15 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.0      LAST MODIFIED: 10/23/91           BY: pma *F003*        */
/* REVISION: 7.0      LAST MODIFIED: 03/05/92           BY: pma *F085*        */
/* REVISION: 7.0      LAST MODIFIED: 06/09/92           BY: pma *F590*        */
/* REVISION: 7.0      LAST MODIFIED: 06/17/92           BY: pma *F663*        */
/* REVISION: 7.0      LAST MODIFIED: 07/21/92           BY: emb *F787*        */
/* REVISION: 7.3      LAST MODIFIED: 07/29/92           BY: mpp *G014*        */
/* REVISION: 7.3      LAST MODIFIED: 08/08/94           By: pxd *FP91*        */
/* REVISION: 7.5      LAST MODIFIED: 11/23/94           BY: tjs *J027*        */
/* REVISION: 8.5      LAST MODIFIED: 08/02/96   BY: *G2B2*  Julie Milligan    */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Paul Johnson       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.11     BY: Katie Hilbert         DATE: 04/01/01 ECO: *P008*    */
/* Revision: 1.14     BY: Niranjan R.           DATE: 07/13/01 ECO: *P00L*    */
/* Revision: 1.15     BY: Vivek Gogte           DATE: 11/06/01 ECO: *N156*    */
/* $Revision: 1.15 $    BY: Inna Fox              DATE: 06/13/02 ECO: *P04Z*    */

/* $Revision: ss - 090616.1  $    BY: mage chen : 05/14/09 ECO: *090616.1*    */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{pxmaint.i}
{pxphdef.i wocmnrtn}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE womtacct_p_1 "Sub Rate Variance Acct"
/* MaxLen: Comment: */

&SCOPED-DEFINE womtacct_p_2 "Sub Usage Variance Acct"
/* MaxLen: Comment: */

&SCOPED-DEFINE womtacct_p_3 "WIP Account"
/* MaxLen: Comment: */

&SCOPED-DEFINE womtacct_p_5 "Mtl Usage Variance Acct"
/* MaxLen: Comment: */

&SCOPED-DEFINE womtacct_p_6 "Mtl Rate Variance Acct"
/* MaxLen: Comment: */

&SCOPED-DEFINE womtacct_p_7 "Mix Variance Acct"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define shared variable wo_recno as recid.
define shared variable new_wo like mfc_logical.
define variable valid_acct like mfc_logical.
define variable l_joint_prod like mfc_logical no-undo.
define variable l_prodline   as   character   no-undo.
define variable l_glacct     like mfc_logical no-undo.

define buffer wo_mstr1 for wo_mstr.

{gprunpdf.i "gpglvpl" "p"}

form
   skip(1)
   wo_acct        colon 30 label {&womtacct_p_3}
   wo_sub         no-label
   wo_cc          no-label
   wo_project     no-label
   wo_mvar_acct   colon 30 label {&womtacct_p_5}
   wo_mvar_sub    no-label
   wo_mvar_cc     no-label
   wo_mvrr_acct   colon 30 label {&womtacct_p_6}
   wo_mvrr_sub    no-label
   wo_mvrr_cc     no-label
   wo_svar_acct   colon 30 label {&womtacct_p_2}
   wo_svar_sub    no-label
   wo_svar_cc     no-label
   wo_svrr_acct   colon 30 label {&womtacct_p_1}
   wo_svrr_sub    no-label
   wo_svrr_cc     no-label
   wo_xvar_acct   colon 30 label {&womtacct_p_7}
   wo_xvar_sub    no-label
   wo_xvar_cc     no-label
   wo_flr_acct    colon 30
   wo_flr_sub     no-label
   wo_flr_cc      no-label
with frame c side-labels width 80 attr-space
   title color normal (getFrameTitle("ACCOUNTING_DATA",23)).

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

/* SS - 090616.1 - B 
ststatus = stline[3].
status input ststatus.
SS - 090616.1 - E */

find wo_mstr
   exclusive-lock
   where recid(wo_mstr) = wo_recno.

if new_wo
then do:

   /* MIX VARIANCE ACCT/SUB-ACCT/CC DEFAULTED FROM CO/BY PRODUCTS PRODUCT  */
   /* LINE, OTHER ACCT/SUB-ACCT/CC DEFAULTED FROM BASE ITEM'S PRODUCT LINE */
   if wo_joint_type <> ""
      and wo_joint_type <> "5"
   then do:
      for first pt_mstr
         fields(pt_part pt_prod_line)
         where pt_part = wo_bom_code no-lock:
      end.
      l_joint_prod = yes.
   end.

   else
      for first pt_mstr
         fields(pt_part pt_prod_line)
         where pt_part = wo_part no-lock:
      end.

   if available pt_mstr
   then do:

      for first pl_mstr
         fields (pl_prod_line)
         where  pl_prod_line = pt_prod_line no-lock:
      end.

      if available pl_mstr
      then do:

         /* ASSIGN DEFAULT ACCOUNT CODES AND COST CENTER */
         {pxrun.i &PROC    = 'assign_default_wo_acct'
                  &PROGRAM = 'wocmnrtn.p'
                  &HANDLE  = ph_wocmnrtn
                  &PARAM   = "(
                               buffer wo_mstr,
                               input  pt_prod_line
                              )"
         }
      end. /* IF AVAILABLE pl_mstr */
   end. /* IF AVAILABLE pt_mstr */

   if l_joint_prod = yes
   then do:

      for first pt_mstr
         fields(pt_part pt_prod_line)
         where pt_part = wo_part no-lock:
      end.

      if available pt_mstr
      then do:

         for first pl_mstr
            fields (pl_prod_line pl_xvar_acct)
            where  pl_prod_line = pt_prod_line no-lock:
         end.

         if available pl_mstr
         then do:

            /* VALUE "9999999999999999999999999" IS ASSIGNED TO l_prodline TO */
            /* DEFAULT THE MIX VARIANCE ACCOUNTS FROM SYSTEM/ACCOUNT CONTROL  */
            /* FILE WHEN PRODUCT LINE MIX VARIANCE ACCOUNTS ARE BLANK         */
            if pl_xvar_acct <> ""
            then
               assign
                  l_prodline = pt_prod_line
                  l_glacct   = no.
            else
               assign
                  l_prodline = "9999999999999999999999999"
                  l_glacct   = yes.

            {gprun.i ""glactdft.p"" "(input ""WO_XVAR_ACCT"",
                                      input l_prodline,
                                      input wo_site,
                                      input """",
                                      input """",
                                      input l_glacct,
                                      output wo_xvar_acct,
                                      output wo_xvar_sub,
                                      output wo_xvar_cc)"}

         end. /* IF AVAILABLE pl_mstr */
      end. /* IF AVAILABLE pt_mstr */
   end. /* IF l_joint_prod = yes */
end.  /* NEW_WO */

/* SS - 090616.1 - B 
display
   wo_acct
   wo_sub
   wo_cc
   wo_project
   wo_mvar_acct
   wo_mvar_sub
   wo_mvar_cc
   wo_mvrr_acct
   wo_mvrr_sub
   wo_mvrr_cc
   wo_svar_acct
   wo_svar_sub
   wo_svar_cc
   wo_svrr_acct
   wo_svrr_sub
   wo_svrr_cc
   wo_xvar_acct
   wo_xvar_sub
   wo_xvar_cc
   wo_flr_acct
   wo_flr_sub
   wo_flr_cc
with frame c.

/* If wo_type = "w" then display only, do not allow edit */
if wo_type <> "w" then
cloop:
do with frame c on error undo cloop, return
   on endkey undo cloop, return:

   set
      wo_acct
      wo_sub
      wo_cc
      wo_project
      wo_mvar_acct
      wo_mvar_sub
      wo_mvar_cc
      wo_mvrr_acct
      wo_mvrr_sub
      wo_mvrr_cc
      wo_svar_acct
      wo_svar_sub
      wo_svar_cc
      wo_svrr_acct
      wo_svrr_sub
      wo_svrr_cc
      wo_xvar_acct
      wo_xvar_sub
      wo_xvar_cc
      wo_flr_acct
      wo_flr_sub
      wo_flr_cc
      go-on ("F1" "CTRL-X")
   with frame c.

   run ip-validate
      (input wo_acct,
       input wo_sub,
       input wo_cc,
       input wo_project).

   if not valid_acct then do:
      next-prompt wo_acct with frame c.
      undo, retry.
   end.

   run ip-validate
      (input wo_mvar_acct,
       input wo_mvar_sub,
       input wo_mvar_cc,
       input wo_project).

   if not valid_acct then do:
      next-prompt wo_mvar_acct with frame c.
      undo, retry.
   end.

   run ip-validate
      (input wo_mvrr_acct,
       input wo_mvrr_sub,
       input wo_mvrr_cc,
       input wo_project).

   if not valid_acct then do:
      next-prompt wo_mvrr_acct with frame c.
      undo, retry.
   end.

   run ip-validate
      (input wo_svar_acct,
       input wo_svar_sub,
       input wo_svar_cc,
       input wo_project).

   if not valid_acct then do:
      next-prompt wo_svar_acct with frame c.
      undo, retry.
   end.

   run ip-validate
      (input wo_svrr_acct,
       input wo_svrr_sub,
       input wo_svrr_cc,
       input wo_project).

   if not valid_acct then do:
      next-prompt wo_svrr_acct with frame c.
      undo, retry.
   end.

   run ip-validate
      (input wo_xvar_acct,
       input wo_xvar_sub,
       input wo_xvar_cc,
       input wo_project).

   if not valid_acct then do:
      next-prompt wo_xvar_acct with frame c.
      undo, retry.
   end.

   run ip-validate
      (input wo_flr_acct,
       input wo_flr_sub,
       input wo_flr_cc,
       input wo_project).

   if not valid_acct then do:
      next-prompt wo_flr_acct with frame c.
      undo, retry.
   end.

   /* JOINT PRODUCT WORK ORDERS HAVE THE SAME ACCT, CC PROJECT */
   if wo_joint_type <> "" and
      (wo_acct entered
      or wo_sub entered
      or wo_cc entered
      or wo_project entered
      or wo_mvar_acct entered
      or wo_mvar_sub entered
      or wo_mvar_cc entered
      or wo_mvrr_acct entered
      or wo_mvrr_sub entered
      or wo_mvrr_cc entered
      or wo_svar_acct entered
      or wo_svar_sub entered
      or wo_svar_cc entered
      or wo_svrr_acct entered
      or wo_svrr_sub entered
      or wo_svrr_cc entered
      or wo_xvar_acct entered
      or wo_xvar_sub entered
      or wo_xvar_cc entered
      or wo_flr_acct entered
      or wo_flr_sub entered
      or wo_flr_cc entered)
      then do for wo_mstr1:
         for each wo_mstr1 where wo_mstr1.wo_nbr = wo_mstr.wo_nbr and
               wo_mstr1.wo_type = "" and
               wo_mstr1.wo_lot <> wo_mstr.wo_lot.

            assign
               wo_mstr1.wo_acct      = wo_mstr.wo_acct
               wo_mstr1.wo_sub       = wo_mstr.wo_sub
               wo_mstr1.wo_cc        = wo_mstr.wo_cc
               wo_mstr1.wo_project   = wo_mstr.wo_project
               wo_mstr1.wo_mvar_acct = wo_mstr.wo_mvar_acct
               wo_mstr1.wo_mvar_sub  = wo_mstr.wo_mvar_sub
               wo_mstr1.wo_mvar_cc   = wo_mstr.wo_mvar_cc
               wo_mstr1.wo_mvrr_acct = wo_mstr.wo_mvrr_acct
               wo_mstr1.wo_mvrr_sub  = wo_mstr.wo_mvrr_sub
               wo_mstr1.wo_mvrr_cc   = wo_mstr.wo_mvrr_cc
               wo_mstr1.wo_svar_acct = wo_mstr.wo_svar_acct
               wo_mstr1.wo_svar_sub  = wo_mstr.wo_svar_sub
               wo_mstr1.wo_svar_cc   = wo_mstr.wo_svar_cc
               wo_mstr1.wo_svrr_acct = wo_mstr.wo_svrr_acct
               wo_mstr1.wo_svrr_sub  = wo_mstr.wo_svrr_sub
               wo_mstr1.wo_svrr_cc   = wo_mstr.wo_svrr_cc
               wo_mstr1.wo_xvar_acct = wo_mstr.wo_xvar_acct
               wo_mstr1.wo_xvar_sub  = wo_mstr.wo_xvar_sub
               wo_mstr1.wo_xvar_cc   = wo_mstr.wo_xvar_cc
               wo_mstr1.wo_flr_acct  = wo_mstr.wo_flr_acct
               wo_mstr1.wo_flr_sub   = wo_mstr.wo_flr_sub
               wo_mstr1.wo_flr_cc    = wo_mstr.wo_flr_cc.
         end.
   end.
   hide frame c.
end.
SS - 090616.1 - E */

PROCEDURE ip-validate:
   define input parameter ip-acct as character no-undo.
   define input parameter ip-sub  as character no-undo.
   define input parameter ip-cc   as character no-undo.
   define input parameter ip-proj as character no-undo.

   /* INITIALIZE SETTINGS */
   {gprunp.i "gpglvpl" "p" "initialize"}

   /* VALIDATE ACCT/SUB/CC/PROJ */
   {gprunp.i "gpglvpl" "p" "validate_fullcode"
      "(input ip-acct,
        input ip-sub,
        input ip-cc,
        input ip-proj,
        output valid_acct)"}

END PROCEDURE.  /* IP-VALIDATE */
