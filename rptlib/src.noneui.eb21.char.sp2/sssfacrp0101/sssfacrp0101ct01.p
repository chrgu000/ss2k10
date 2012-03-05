/* sfacct01.p - OPERATIONS ACCOUNTING REPORT                              */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/* $Revision: 1.11.1.10 $                                                           */
/*V8:ConvertMode=Report                                                   */
/* REVISION: 7.0      LAST MODIFIED: 03/09/91   BY: pma *F270*            */
/* Revision: 7.3      Last Modified: 08/03/92   By: mpp *G337*            */
/* Revision: 7.3      Last edit:     09/27/93   By: jcd *G337*            */
/*                                   08/27/94   By: bcm *GL66*            */
/* REVISION: 7.3      LAST MODIFIED: 09/15/94   by: slm *GM62*            */
/* REVISION: 7.3      LAST MODIFIED: 12/23/94   by: cpp *FT95*            */
/* REVISION: 7.2      LAST MODIFIED: 04/13/95   BY: ais *F0QF*            */
/* REVISION: 7.3      LAST MODIFIED: 08/02/95   BY: qzl *G0SH*            */
/* REVISION: 7.3      LAST MODIFIED: 02/09/96   BY: rvw *G1MW*            */
/* REVISION: 8.6      LAST MODIFIED: 10/14/97   BY: ays *K0YH*            */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane      */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan     */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Vijaya Pakala  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 07/25/00 BY: *N0GQ* Mudit Mehta      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                */
/* Revision: 1.11.1.6  BY: Katie Hilbert      DATE: 04/05/01  ECO: *P008* */
/* Revision: 1.11.1.7  BY: Vandna Rohira      DATE: 07/10/01  ECO: *M1DM* */
/* Revision: 1.11.1.9  BY: Paul Donnelly (SB) DATE: 06/28/03  ECO: *Q00L* */
/* $Revision: 1.11.1.10 $  BY: Kirti Desai             DATE: 01/07/04  ECO: *P1HZ* */
/* $Revision: 1.11.1.10 $  BY: Bill Jiang             DATE: 05/06/08  ECO: *SS - 20080506.1* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20080506.1 - B */                                                                                  
define input parameter i_part like op_part.
define input parameter i_part1 like op_part.
define input parameter i_wonbr like op_wo_nbr.
define input parameter i_wonbr1 like op_wo_nbr.
define input parameter i_wolot  like op_wo_lot.
define input parameter i_wolot1 like op_wo_lot.
define input parameter i_efdate like op_date.
define input parameter i_efdate1 like op_date.
define input parameter i_glref  like opgl_gl_ref.
define input parameter i_glref1 like opgl_gl_ref.
define input parameter i_acct like glt_acct.
define input parameter i_acct1 like glt_acct.
define input parameter i_sub like glt_sub.
define input parameter i_sub1 like glt_sub.
define input parameter i_cc like glt_cc.
define input parameter i_cc1 like glt_cc.
define input parameter i_proj like glt_project.
define input parameter i_proj1 like glt_project.
define input parameter i_trdate like op_tran_date.
define input parameter i_trdate1 like op_tran_date.
/*
{mfdtitle.i "1+ "}
*/
{ssmfdtitle.i "1+ "}
/* SS - 20080506.1 - E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sfacct01_p_1 "WO ID!Op"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfacct01_p_5 "Detail by GL Account"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfacct01_p_8 "Detail by Transaction"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfacct01_p_15 "Dr Acct!Cr Acct"
/* MaxLen: 10 Comment: Debit/Credit Account Column Label in Report */

&SCOPED-DEFINE sfacct01_p_16 "Sub-Acct!Sub-Acct"
/* MaxLen: 11 Comment: Sub_Account Column Label in Report */

&SCOPED-DEFINE sfacct01_p_17 "CC!CC"
/* MaxLen: 4 Comment: Cost Center Column Label in Report */

/* ********** End Translatable Strings Definitions ********* */

define variable wonbr    like op_wo_nbr.
define variable wonbr1   like op_wo_nbr.
define variable wolot    like op_wo_lot.
define variable wolot1   like op_wo_lot.
define variable part     like op_part.
define variable part1    like op_part.
define variable trdate   like op_tran_date.
define variable trdate1  like op_tran_date.
define variable glref    like opgl_gl_ref.
define variable glref1   like opgl_gl_ref.
define variable efdate   like op_date.
define variable efdate1  like op_date.
define variable desc1    like pt_desc1.
define variable desc2    like pt_desc2 format "x(26)".
define variable oldtrnbr like op_trnbr format ">>>>>>>9".
define variable tr_yn    like mfc_logical label {&sfacct01_p_8}
   initial yes.
define variable gl_yn    like mfc_logical label {&sfacct01_p_5}
   initial yes.
define variable acct     like glt_acct.
define variable acct1    like glt_acct.
define variable sub      like glt_sub.
define variable sub1     like glt_sub.
define variable proj     like glt_project.
define variable proj1    like glt_project.
define variable cc       like glt_cc.
define variable cc1      like glt_cc.
define variable oplot    like op_wo_lot column-label {&sfacct01_p_1}.
define variable drcract  like glt_acct
   column-label {&sfacct01_p_15} no-undo.
define variable subact   like glt_sub
   column-label {&sfacct01_p_16} no-undo.
define variable ccdisp   like glt_cc
   column-label {&sfacct01_p_17} no-undo.

/* SS - 20080506.1 - B */
/*
/* TEMP-TABLE DEFINITION OF tt_gltw_wkfl */
{sfgltwdf.i new}
*/
/* SS - 20080506.1 - E */

form
   part           colon 20
   part1          label {t001.i} colon 49 skip
   wonbr          colon 20
   wonbr1         label {t001.i} colon 49 skip
   wolot          colon 20
   wolot1         label {t001.i} colon 49 skip
   efdate         colon 20
   efdate1        label {t001.i} colon 49 skip
   glref          colon 20
   glref1         label {t001.i} colon 49 skip
   acct           colon 20
   acct1          label {t001.i} colon 49 skip
   sub            colon 20
   sub1           label {t001.i} colon 49 skip
   cc             colon 20
   cc1            label {t001.i} colon 49 skip
   proj           colon 20
   proj1          label {t001.i} colon 49 skip
   trdate         colon 20
   trdate1        label {t001.i} colon 49 skip (1)
   tr_yn          colon 35
   gl_yn          colon 35
with frame a side-labels          width 80.

/* SS - 20080506.1 - B */
/*
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
*/
part = i_part.
part1 = i_part1.
wonbr = i_wonbr.
wonbr1 = i_wonbr1.
wolot = i_wolot.
wolot1 = i_wolot1.
efdate = i_efdate.
efdate1 = i_efdate1.
glref = i_glref.
glref1 = i_glref1.
acct = i_acct.
acct1 = i_acct1.
sub = i_sub.
sub1 = i_sub1.
cc = i_cc.
cc1 = i_cc1.
proj = i_proj.
proj1 = i_proj1.
trdate = i_trdate.
trdate1 = i_trdate1.
/* SS - 20080506.1 - E */

form
   op_date
   op_trnbr format ">>>>>>>9"
   op_wo_nbr
   oplot
   opgl_gl_ref
   desc2
   drcract
   subact
   ccdisp
   opgl_gl_amt
   with frame b width 132 down.

/* SS - 20080506.1 - B */
/*
/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).
*/
/* SS - 20080506.1 - E */

{wbrp02.i}
/* SS - 20080506.1 - B */
/*
repeat:
*/
/* SS - 20080506.1 - E */
   if part1   = hi_char
   then
      part1 = "".
   if wonbr1  = hi_char
   then
      wonbr1 = "".
   if wolot1  = hi_char
   then
      wolot1 = "".
   if trdate  = low_date
   then
      trdate = ?.
   if trdate1 = hi_date
   then
      trdate1 = ?.
   if efdate  = low_date
   then
      efdate = ?.
   if efdate1 = hi_date
   then
      efdate1 = ?.
   if glref1  = hi_char
   then
      glref1 = "".
   if acct1 = hi_char
   then
      acct1 = "".
   if sub1  = hi_char
   then
      sub1  = "".
   if cc1   = hi_char
   then
      cc1   = "".
   if proj1 = hi_char
   then
      proj1 = "".

   /* SS - 20080506.1 - B */
   /*
   if c-application-mode <> 'web'
   then
         update
         part
         part1
         wonbr
         wonbr1
         wolot
         wolot1
         efdate
         efdate1
         glref
         glref1
         acct
         acct1
         sub
         sub1
         cc
         cc1
         proj
         proj1
         trdate
         trdate1
         tr_yn
         gl_yn
      with frame a.

   {wbrp06.i &command = update
             &fields = " part part1
                         wonbr wonbr1
                         wolot wolot1
                         efdate efdate1
                         glref glref1
                         acct acct1
                         sub sub1
                         cc cc1
                         proj proj1
                         trdate trdate1
                         tr_yn gl_yn    "
             &frm = "a"}
   */
   /* SS - 20080506.1 - E */

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i part           }
      {mfquoter.i part1          }
      {mfquoter.i wonbr          }
      {mfquoter.i wonbr1         }
      {mfquoter.i wolot          }
      {mfquoter.i wolot1         }
      {mfquoter.i efdate         }
      {mfquoter.i efdate1        }
      {mfquoter.i glref          }
      {mfquoter.i glref1         }
      {mfquoter.i acct           }
      {mfquoter.i acct1          }
      {mfquoter.i sub            }
      {mfquoter.i sub1           }
      {mfquoter.i cc             }
      {mfquoter.i cc1            }
      {mfquoter.i proj           }
      {mfquoter.i proj1          }
      {mfquoter.i trdate         }
      {mfquoter.i trdate1        }
      {mfquoter.i tr_yn          }
      {mfquoter.i gl_yn          }

      if part1   = ""
      then
         part1 = hi_char.
      if wonbr1  = ""
      then
         wonbr1 = hi_char.
      if wolot1  = ""
      then
         wolot1 = hi_char.
      if trdate  = ?
      then
         trdate = low_date.
      if trdate1 = ?
      then
         trdate1 = hi_date.
      if efdate  = ?
      then
         efdate = low_date.
      if efdate1 = ?
      then
         efdate1 = hi_date.
      if glref1  = ""
      then
         glref1 = hi_char.
      if acct1  = ""
      then
         acct1  = hi_char.
      if sub1   = ""
      then
         sub1   = hi_char.
      if cc1    = ""
      then
         cc1    = hi_char.
      if proj1  = ""
      then
         proj1  = hi_char.
   end. /* IF (c-application-mode <> 'web') OR */

   /* SS - 20080506.1 - B */
   /*
   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
   {mfphead.i}

   form header
      skip(1)
   with frame a1 page-top width 80.
   view frame a1.

   /* DELETING RECORDS FROM tt_gltw_wkfl */
   for each tt_gltw_wkfl
      exclusive-lock:
      delete tt_gltw_wkfl.
   end. /* FOR EACH tt_gltw_wkfl */
   */
   define variable l_textfile        as character no-undo.
   /* SS - 20080506.1 - E */

   /* USING CORRECT INDEX BASED ON THE SELECTION CRITERIA  */
   /* ENTERED FOR IMPROVEMENT IN PERFORMANCE. THE DEFAULT  */
   /* INDEX USED WILL BE op_date IF NONE OF THE BELOW      */
   /* CONDITIONS GET SATISFIED                             */

   if  efdate  <> low_date
   and efdate1 <> hi_date
   then
      run process-use-op-date.
   else
   if  wolot  <> ""
   and wolot1 <> hi_char
   then
      run process-use-op-lot-op.
   else
   if  wonbr  <> ""
   and wonbr1 <> hi_char
   then
      run process-use-op-wo-nbr.
   else
   if  part  <> ""
   and part1 <> hi_char
   then
      run process-use-op-part.
   else
      run process-use-op-date.

   /* SS - 20080506.1 - B */
   /*
   /* PRINT GL DISTRIBUTION */
   if gl_yn then do:
      if tr_yn then page.
      /* USING tt_gltw_wkfl TO PRINT THE REPORT  */
      {gprun.i ""sfglrp.p""}
   end. /* IF gl_yn */

   /* REPORT TRAILER */
   {mfrtrail.i}

end. /* REPEAT */
   */
   /* SS - 20080506.1 - E */

{wbrp04.i &frame-spec = a}

PROCEDURE process-use-op-date:

define variable l_optrnbr like op_trnbr no-undo.

l_optrnbr = 0.

for each op_hist
   /* SS - 20080506.1 - B */
   /*
   fields( op_domain op_date   op_part   op_tran_date op_trnbr op_type
           op_wo_lot op_wo_nbr op_wo_op)
   */
   /* SS - 20080506.1 - E */
    where op_hist.op_domain = global_domain and (  (op_date      >= efdate
   and    op_date      <= efdate1)
   and   (op_wo_nbr    >= wonbr
   and    op_wo_nbr    <= wonbr1)
   and   (op_wo_lot    >= wolot
   and    op_wo_lot    <= wolot1)
   and   (op_tran_date >= trdate
   and    op_tran_date <= trdate1)
   and   (op_part      >= part
   and    op_part      <= part1)
   ) no-lock
   use-index op_date,
   each opgl_det
      /* SS - 20080506.1 - B */
      /*
      fields( opgl_domain opgl_cr_acct opgl_cr_cc  opgl_cr_line opgl_cr_proj
      opgl_cr_sub
              opgl_dr_acct opgl_dr_cc  opgl_dr_line opgl_dr_proj opgl_dr_sub
              opgl_gl_amt  opgl_gl_ref opgl_trnbr   opgl_type)
      */
      /* SS - 20080506.1 - E */
      no-lock
       where opgl_det.opgl_domain = global_domain and (  opgl_trnbr    =
       op_trnbr
      and  (opgl_gl_ref  >= glref
      and   opgl_gl_ref  <= glref1)
      and  (
              (opgl_dr_acct >= acct and
               opgl_dr_acct <= acct1)
              or
              (opgl_cr_acct >= acct and
               opgl_cr_acct <= acct1)
           )
      and  (
              (    opgl_dr_sub  >= sub
               and opgl_dr_sub  <= sub1)
              or
              (    opgl_cr_sub  >= sub
               and opgl_cr_sub  <= sub1)
           )
      and  (
              (opgl_dr_cc   >= cc and
               opgl_dr_cc   <= cc1)
              or
              (opgl_cr_cc   >= cc and
               opgl_cr_cc   <= cc1)
              )
      and  (
              (opgl_dr_proj >= proj and
               opgl_dr_proj <= proj1)
              or
              (opgl_cr_proj >= proj and
               opgl_cr_proj <= proj1)
           )
      and  (opgl_gl_amt   <> 0)
      ) by op_date by op_trnbr with frame b width 132 no-box:

      /* CREATING tt_gltw_wkfl RECORDS WHEN gl_yn = YES */
      /* AND PRINTING THE REPORT WHEN tr_yn = YES       */
      /* SS - 20080506.1 - B */
      /*
      {sfacct1a.i}
      */
      {sssfacrp0101ct1a.i}
      /* SS - 20080506.1 - E */

   end. /* FOR EACH op_hist */

END PROCEDURE. /* process-use-op-date */


PROCEDURE process-use-op-lot-op:

define variable l_optrnbr like op_trnbr no-undo.

l_optrnbr = 0.

for each op_hist
   /* SS - 20080506.1 - B */
   /*
   fields( op_domain op_date   op_part   op_tran_date op_trnbr op_type
           op_wo_lot op_wo_nbr op_wo_op)
   */
   /* SS - 20080506.1 - E */
    where op_hist.op_domain = global_domain and (  (op_wo_lot    >= wolot
   and    op_wo_lot    <= wolot1)
   and   (op_wo_nbr    >= wonbr
   and    op_wo_nbr    <= wonbr1)
   and   (op_date      >= efdate
   and    op_date      <= efdate1)
   and   (op_tran_date >= trdate
   and    op_tran_date <= trdate1)
   and   (op_part      >= part
   and    op_part      <= part1)
   ) no-lock
   use-index op_lot_op,
   each opgl_det
      /* SS - 20080506.1 - B */
      /*
      fields( opgl_domain opgl_cr_acct opgl_cr_cc  opgl_cr_line opgl_cr_proj
      opgl_cr_sub
              opgl_dr_acct opgl_dr_cc  opgl_dr_line opgl_dr_proj opgl_dr_sub
              opgl_gl_amt  opgl_gl_ref opgl_trnbr   opgl_type)
      */
      /* SS - 20080506.1 - E */
      no-lock
       where opgl_det.opgl_domain = global_domain and (  opgl_trnbr    =
       op_trnbr
      and  (opgl_gl_ref  >= glref
      and   opgl_gl_ref  <= glref1)
      and  (
              (opgl_dr_acct >= acct and
               opgl_dr_acct <= acct1)
              or
              (opgl_cr_acct >= acct and
               opgl_cr_acct <= acct1)
           )
      and  (
              (    opgl_dr_sub  >= sub
               and opgl_dr_sub  <= sub1)
              or
              (    opgl_cr_sub  >= sub
               and opgl_cr_sub  <= sub1)
           )
      and  (
              (opgl_dr_cc   >= cc and
               opgl_dr_cc   <= cc1)
              or
              (opgl_cr_cc   >= cc and
               opgl_cr_cc   <= cc1)
              )
      and  (
              (opgl_dr_proj >= proj and
               opgl_dr_proj <= proj1)
              or
              (opgl_cr_proj >= proj and
               opgl_cr_proj <= proj1)
           )
      and  (opgl_gl_amt   <> 0)
      ) by op_date by op_trnbr with frame b width 132 no-box:

      /* CREATING  tt_gltw_wkfl RECORDS WHEN gl_yn = YES */
      /* AND PRINTING THE REPORT WHEN tr_yn = YES        */
      /* SS - 20080506.1 - B */
      /*
      {sfacct1a.i}
      */
      {sssfacrp0101ct1a.i}
      /* SS - 20080506.1 - E */

   end. /* FOR EACH op_hist */

END PROCEDURE. /* process-use-op-lot-op */


PROCEDURE process-use-op-wo-nbr:

define variable l_optrnbr like op_trnbr no-undo.

l_optrnbr = 0.

for each op_hist
   /* SS - 20080506.1 - B */
   /*
   fields( op_domain op_date   op_part   op_tran_date op_trnbr op_type
           op_wo_lot op_wo_nbr op_wo_op)
   */
   /* SS - 20080506.1 - E */
    where op_hist.op_domain = global_domain and (  (op_wo_nbr    >= wonbr
   and    op_wo_nbr    <= wonbr1)
   and   (op_wo_lot    >= wolot
   and    op_wo_lot    <= wolot1)
   and   (op_date      >= efdate
   and    op_date      <= efdate1)
   and   (op_tran_date >= trdate
   and    op_tran_date <= trdate1)
   and   (op_part      >= part
   and    op_part      <= part1)
   ) no-lock
   use-index op_wo_nbr,
   each opgl_det
      /* SS - 20080506.1 - B */
      /*
      fields( opgl_domain opgl_cr_acct opgl_cr_cc  opgl_cr_line opgl_cr_proj
      opgl_cr_sub
              opgl_dr_acct opgl_dr_cc  opgl_dr_line opgl_dr_proj opgl_dr_sub
              opgl_gl_amt  opgl_gl_ref opgl_trnbr   opgl_type)
      */
      /* SS - 20080506.1 - E */
      no-lock
       where opgl_det.opgl_domain = global_domain and (  opgl_trnbr    =
       op_trnbr
      and  (opgl_gl_ref  >= glref
      and   opgl_gl_ref  <= glref1)
      and  (
              (opgl_dr_acct >= acct and
               opgl_dr_acct <= acct1)
              or
              (opgl_cr_acct >= acct and
               opgl_cr_acct <= acct1)
           )
      and  (
              (    opgl_dr_sub  >= sub
               and opgl_dr_sub  <= sub1)
              or
              (    opgl_cr_sub  >= sub
               and opgl_cr_sub  <= sub1)
           )
      and  (
              (opgl_dr_cc   >= cc and
               opgl_dr_cc   <= cc1)
              or
              (opgl_cr_cc   >= cc and
               opgl_cr_cc   <= cc1)
              )
      and  (
              (opgl_dr_proj >= proj and
               opgl_dr_proj <= proj1)
              or
              (opgl_cr_proj >= proj and
               opgl_cr_proj <= proj1)
           )
      and (opgl_gl_amt   <> 0)
      ) by op_date by op_trnbr with frame b width 132 no-box:

      /* CREATING tt_gltw_wkfl RECORDS WHEN gl_yn = YES */
      /* AND PRINTING THE REPORT WHEN tr_yn = YES        */
      /* SS - 20080506.1 - B */
      /*
      {sfacct1a.i}
      */
      {sssfacrp0101ct1a.i}
      /* SS - 20080506.1 - E */

   end. /* FOR EACH op_hist */

END PROCEDURE. /* process-use-op-wo-nbr */


PROCEDURE process-use-op-part:

define variable l_optrnbr like op_trnbr no-undo.

l_optrnbr = 0.

for each op_hist
   /* SS - 20080506.1 - B */
   /*
   fields( op_domain op_date   op_part   op_tran_date op_trnbr op_type
           op_wo_lot op_wo_nbr op_wo_op)
   */
   /* SS - 20080506.1 - E */
    where op_hist.op_domain = global_domain and (  (op_part      >= part
   and    op_part      <= part1)
   and   (op_wo_nbr    >= wonbr
   and    op_wo_nbr    <= wonbr1)
   and   (op_wo_lot    >= wolot
   and    op_wo_lot    <= wolot1)
   and   (op_date      >= efdate
   and    op_date      <= efdate1)
   and   (op_tran_date >= trdate
   and    op_tran_date <= trdate1)
   ) no-lock
   use-index op_part,
   each opgl_det
      /* SS - 20080506.1 - B */
      /*
      fields( opgl_domain opgl_cr_acct opgl_cr_cc  opgl_cr_line opgl_cr_proj
      opgl_cr_sub
              opgl_dr_acct opgl_dr_cc  opgl_dr_line opgl_dr_proj opgl_dr_sub
              opgl_gl_amt  opgl_gl_ref opgl_trnbr   opgl_type)
      */
      /* SS - 20080506.1 - E */
      no-lock
       where opgl_det.opgl_domain = global_domain and (  opgl_trnbr    =
       op_trnbr
      and  (opgl_gl_ref  >= glref
      and   opgl_gl_ref  <= glref1)
      and  (
              (opgl_dr_acct >= acct and
               opgl_dr_acct <= acct1)
              or
              (opgl_cr_acct >= acct and
               opgl_cr_acct <= acct1)
           )
      and  (
              (    opgl_dr_sub  >= sub
               and opgl_dr_sub  <= sub1)
              or
              (    opgl_cr_sub  >= sub
               and opgl_cr_sub  <= sub1)
           )
      and  (
              (opgl_dr_cc   >= cc and
               opgl_dr_cc   <= cc1)
              or
              (opgl_cr_cc   >= cc and
               opgl_cr_cc   <= cc1)
              )
      and  (
              (opgl_dr_proj >= proj and
               opgl_dr_proj <= proj1)
              or
              (opgl_cr_proj >= proj and
               opgl_cr_proj <= proj1)
           )
      and (opgl_gl_amt   <> 0)
      ) by op_date by op_trnbr with frame b width 132 no-box:

      /* CREATING tt_gltw_wkfl RECORDS WHEN gl_yn = YES */
      /* AND PRINTING THE REPORT WHEN tr_yn = YES       */
      /* SS - 20080506.1 - B */
      /*
      {sfacct1a.i}
      */
      {sssfacrp0101ct1a.i}
      /* SS - 20080506.1 - E */

   end. /* FOR EACH op_hist */

END PROCEDURE. /* process-use-op-part */
