/* gltrrp.p - GENERAL LEDGER TRANSACTION REGISTER                             */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.22 $                                                         */
/*K11L         */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 1.0      LAST MODIFIED: 03/04/87   BY: JMS                       */
/*                                   02/26/88   By: JMS                       */
/* REVISION: 4.0      LAST MODIFIED: 02/29/88   BY: WUG   *A175*              */
/*                                   03/21/88   BY: JMS                       */
/*                                   09/09/88   by: jms   *A421*              */
/*                                   10/14/88   by: jms   *A489*              */
/* REVISION: 5.0      LAST MODIFIED: 04/04/89   by: jms   *B066*              */
/*                                   03/04/90   by: pml   *B648*              */
/* REVISION: 6.0      LAST MODIFIED: 07/08/90   by: jms   *D034*              */
/*                                   02/20/91   by: jms   *D366*              */
/* REVISION: 7.0      LAST MODIFIED: 11/05/91   by: jms   *F058*              */
/*                                   02/18/92   by: jms   *F212*              */
/*                                                 (major re-write)           */
/*                                   05/29/92   by: jjs   *F550*              */
/* REVISION: 7.3      LAST MODIFIED  10/16/92   by: mpp   *G479*              */
/*                                   02/19/93   by: jms   *G703*              */
/*                                   02/14/94   by: jms   *GI70*              */
/*                                                 (backs out G479)           */
/*                                   01/16/96   by: mys   *G1K3*              */
/* REVISION: 8.6    LAST MODIFIED  10/16/97   by: bvm   *K11L*                */
/* REVISION: 8.6E   LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane            */
/* REVISION: 8.6E   LAST MODIFIED  06/18/98   BY: *J2PC* A. Licha             */
/* REVISION: 8.6E   LAST MODIFIED: 07/02/98   BY: *L039* A. Licha             */
/* REVISION: 9.0    LAST MODIFIED  12/03/98   BY: *J35Y* Prashanth Narayan    */
/* REVISION: 9.0    LAST MODIFIED  03/13/99   BY: *M0BD* Alfred Tan           */
/* REVISION: 9.1    LAST MODIFIED  09/20/99   BY: *N033* Brenda Milton        */
/* REVISION: 9.1    LAST MODIFIED  09/29/99   BY: *N014* Jeff Wootton         */
/* REVISION: 9.1    LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane     */
/* REVISION: 9.1    LAST MODIFIED: 06/26/00   BY: *N0DJ* Mudit Mehta          */
/* REVISION: 9.1    LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown           */
/* REVISION: 9.1    LAST MODIFIED: 09/25/00   BY: *N0VY* Mudit Mehta          */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.20  BY: Manjusha Inglay DATE: 05/27/03 ECO: *P0T6* */
/* $Revision: 1.22 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* SS - 090817.1 By: Neil Gao */

/*-Revision end---------------------------------------------------------------*/

/* SS 090817.1 - B */
/*
描述：栏长度，24个字符长度
*/
/* SS 090817.1 - E */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
/* SS 090817.1 - B */
{mfdtitle.i "090817.1"}
/* SS 090817.1 - E */

/* LOCALIZATION CONTROL FILE */
{cxcustom.i "GLTRRP.P"}

define variable glname           like en_name      no-undo.
define variable ref              like gltr_ref     no-undo.
define variable ref1             like gltr_ref     no-undo.
define variable dt               like gltr_ent_dt  no-undo.
define variable dt1              like gltr_ent_dt  no-undo.
define variable effdt            like gltr_eff_dt  no-undo.
define variable effdt1           like gltr_eff_dt  no-undo.
define variable drtot            as decimal        no-undo
   format ">>,>>>,>>>,>>>,>>>.99cr".
define variable crtot            like drtot        no-undo.
define variable type             like gltr_tr_type no-undo.
define variable type1            like gltr_tr_type no-undo.
define variable entity           like gltr_entity  no-undo.
define variable entity1          like gltr_entity  no-undo.
define variable project          like gltr_project no-undo.
define variable project1         like gltr_project no-undo.
define variable xamt             like gltr_curramt no-undo.
define variable curr             like gltr_curr    no-undo.

define variable account          as character      no-undo
   format "x(22)" label "Account".
define variable l_first_gltr_ref like mfc_logical  no-undo.


{&GLTRRP-P-TAG1}
/* GET NAME OF CURRENT ENTITY */
find en_mstr
    where en_mstr.en_domain = global_domain and  en_entity = current_entity
   no-lock no-error.

if not available en_mstr
then do:
   /* NO PRIMARY ENTITY DEFINED */
   {pxmsg.i &MSGNUM=3059 &ERRORLEVEL=3}

   if c-application-mode <> 'web'
   then
      pause.
   leave.
end. /* IF NOT AVAILABLE en_mstr */

else do:
   glname = en_name.
   release en_mstr.
end. /* ELSE DO */

/* SELECT FORM */
{&GLTRRP-P-TAG2}
form
   entity   colon 30
   entity1  colon 50 label "To"
   ref      colon 30
   /*V8! view-as fill-in size 14 by 1 */
   ref1     colon 50 label {t001.i}
   /*V8! view-as fill-in size 14 by 1 */
   dt       colon 30
   dt1      colon 50 label "To"
   effdt    colon 30
   effdt1   colon 50 label "To"
   type     colon 30
   type1    colon 50 label "To"
   project  colon 30
   project1 colon 50 label "To"
   with frame a side-labels attr-space
   width 80 title color normal glname.
{&GLTRRP-P-TAG3}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
{&GLTRRP-P-TAG4}

/* REPORT BLOCK */

/*  PERSISTENT .P "LIBRARY" ROUTINE FOR WEB-ENABLED REPORTS */
{wbrp01.i}

repeat:
   if ref1 = hi_char
   then
      ref1 = "".
   if dt = low_date
   then
      dt = ?.
   if dt1 = hi_date
   then
      dt1 = ?.
   if effdt = low_date
   then
      effdt = ?.
   if effdt1 = hi_date
   then
      effdt1 = ?.
   if type1 = hi_char
   then
      type1 = "".
   if project1 = hi_char
   then
      project1 = "".
   if entity1 = hi_char
   then
      entity1 = "".

   /* INPUT VARIABLES */

   if c-application-mode <> 'web'
   then
      {&GLTRRP-P-TAG5}
   update
      entity
      entity1
      ref
      ref1
      dt
      dt1
      effdt
      effdt1
      type
      type1
      project
      /* rpt_curr supp_zero */
      project1
   with frame a.

   /* REPORT INCLUDE FILE FOR WEB-ENABLEMENT */
   {wbrp06.i &command = update
             &fields  = "  entity entity1 ref ref1 dt dt1
                        effdt effdt1   type type1 project project1 "
             &frm     = "a"}
   {&GLTRRP-P-TAG6}

   if (c-application-mode <> 'web')
      or  (c-application-mode = 'web'
      and (c-web-request begins 'data'))
   then do:

      /* CREATE BATCH INPUT STRING */
      bcdparm = "".
      {mfquoter.i entity  }
      {mfquoter.i entity1 }
      {mfquoter.i ref     }
      {mfquoter.i ref1    }
      {mfquoter.i dt      }
      {mfquoter.i dt1     }
      {mfquoter.i effdt   }
      {mfquoter.i effdt1  }
      {mfquoter.i type    }
      {mfquoter.i type1   }
      {mfquoter.i project }
      {mfquoter.i project1}
      {&GLTRRP-P-TAG7}

      if ref1 = ""
      then
         ref1 = hi_char.
      if dt = ?
      then
         dt = low_date.
      if dt1 = ?
      then
         dt1 = hi_date.
      if effdt = ?
      then
         effdt = low_date.
      if effdt1 = ?
      then
         effdt1 = hi_date.
      if type1 = ""
      then
         type1 = hi_char.
      if entity1 = ""
      then
         entity1 = hi_char.
      if project1 = ""
      then
         project1 = hi_char.

   end. /* IF (c-application-mode <> 'web') ... */

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

   /* INCLUDE FILE TO PRINT PAGE HEADING FOR REPORTS */
   {mfphead.i}

   assign
      crtot = 0
      drtot = 0.

   /* PRINT REPORT */
   for each gltr_hist
       where gltr_hist.gltr_domain = global_domain and  gltr_ref     >= ref
      and   gltr_ref     <= ref1
      and   gltr_tr_type >= type
      and   gltr_tr_type <= type1
      and   gltr_ent_dt  >= dt
      and   gltr_ent_dt  <= dt1
      and   gltr_eff_dt  >= effdt
      and   gltr_eff_dt  <= effdt1
      no-lock use-index gltr_ref
/* SS 090817.1 - B */
/*
      break by gltr_ref with width 132:
*/
      break by gltr_ref with width 140:
/* SS 090817.1 - E */

      if first-of(gltr_ref)
      then
         l_first_gltr_ref = yes.

      {&GLTRRP-P-TAG8}

      /* THESE TWO LINES HAD TO BE HERE INSTEAD OF IN THE */
      /* FOR EACH SINCE ORACLE WOULD IGNORE THE INDEX IF  */
      /* THEY WERE IN THE FOR EACH.                       */
      if gltr_entity    < entity
         or gltr_entity > entity1
      then
         next.
      if gltr_project    < project
         or gltr_project > project1
      then
         next.

      do with frame b:
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).
         if gltr_entity   = ""
            and gltr_line = 0
         then do:
            display
               gltr_ref
               "" @ gltr_eff_dt
               gltr_ent_dt
               gltr_user
               "" @ gltr_batch
               gltr_desc no-label
            with down frame b.
            next.
         end. /* IF gltr_entity = " " ... */

         if l_first_gltr_ref
         then do:
            l_first_gltr_ref = no.
            if line-counter + 7 >= page-size
            then
               page.
            display
               gltr_ref
               gltr_eff_dt
               gltr_ent_dt
               gltr_user
               gltr_batch
            with down frame b.
            down 2 with frame b.
         end. /* FIRST-OF */
      end. /* DO WITH */

      /* COMBINE ACCT, SUB-ACCT, AND CC INTO SINGLE STRING */
      /* FIRST, SECOND & THIRD PARAMETERS CHANGED FROM g1.gltr_acc */

      {glacct.i
         &acc=gltr_acc
         &sub=gltr_sub
         &cc=gltr_ctr
         &acct=account}

      do with frame c:
         {&GLTRRP-P-TAG9}
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame c:handle).
         {&GLTRRP-P-TAG10}
         display
            gltr_line
            account
            gltr_project
            gltr_entity
/* SS 090817.1 - B */
/*
            gltr_desc format "x(18)"
*/
            gltr_desc
/* SS 090817.1 - E */
            gltr_amt column-label "Base Amount"
            gltr_curramt
            gltr_curr
            gltr_addr
            gltr_doc_typ
            gltr_doc
/* SS 090817.1 - B */
/*
         with down frame c width 132 no-box.
*/
         with down frame c width 140 no-box.
/* SS 090817.1 - E */
         {&GLTRRP-P-TAG11}
      end. /* DO WITH */

      for first ac_mstr
         fields( ac_domain ac_code ac_type)
          where ac_mstr.ac_domain = global_domain and  ac_code = gltr_acc
         no-lock:
      end. /* FOR FIRST ac_mstr */
      if available ac_mstr
         and ac_type <> "M"
         and ac_type <> "S"
      then do:
         if gltr_amt < 0
         then
            crtot = crtot + gltr_amt.
         else
            drtot = drtot + gltr_amt.
      end. /* IF AVAILABLE ac_mstr */

      /* REPORT EXIT FOR PAGING INCLUDE FILE */
      {mfrpchk.i}

   end. /* FOR EACH GLTR_HIST */

   /* PRINT DEBIT AND CREDIT TOTALS */

   put
      skip(2)
      /* INCLUDE FILE TO FORMAT LABEL DYNAMICALLY */
      {gplblfmt.i
         &FUNC=getTermLabel(""DEBIT_TOTAL"",20)
         &CONCAT="':'"
      }
      at 25
      drtot space(1)
      base_curr
      /* INCLUDE FILE TO FORMAT LABEL DYNAMICALLY */
      {gplblfmt.i
         &FUNC=getTermLabel(""CREDIT_TOTAL"",20)
         &CONCAT="':'"
      }
      at 75
      crtot space(1)
      base_curr.

   /* REPORT TRAILER  */
   {mfrtrail.i}

end. /* REPEAT */

/* REPORT INCLUDE FILE FOR WEB-ENABLEMENT */
{wbrp04.i &frame-spec = a}
