/* GUI CONVERTED from chcftrrp.p (converter v1.71) Sun Oct 21 21:39:26 2007 */
/* chcftrrp.p - GENERAL LEDGER TRANSACTION REGISTER                           */
/* gltrrp.p - GENERAL LEDGER TRANSACTION REGISTER                             */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.20 $                                                         */
/*K11L         */
/*V8:ConvertMode=Report                                                */
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
/* $Revision: 1.20 $     BY: Manjusha Inglay     DATE: 05/27/03   ECO: *P0T6*      */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

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
/*define variable xamt             like gltr_curramt no-undo.*/
define variable curr             like gltr_curr    no-undo.

define variable account          as character      no-undo
   format "x(22)" label "Account".
define variable l_first_gltr_ref like mfc_logical  no-undo.

/*XXCH911*/ define variable dr_cr as logical format "Dr/Cr".
/*XXCH911*/ define variable drcrtxt as char format "x(2)".
/*XXCH911*/ define var xamt as decimal format "->,>>>,>>>,>>9.99".
/*CF*/ define var tot_xamt as decimal format "->,>>>,>>>,>>9.99".
/*CF*/ define buffer xcftr_b for xcftr_hist.

{&GLTRRP-P-TAG1}
/* GET NAME OF CURRENT ENTITY */
find en_mstr 
   where en_entity = current_entity
   and en_domain = global_domain 
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

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
entity   colon 30
   entity1  colon 50 label "To"
   ref      colon 30
         view-as fill-in size 14 by 1   
   ref1     colon 50 label {t001.i}
         view-as fill-in size 14 by 1   
   dt       colon 30
   dt1      colon 50 label "To"
   effdt    colon 30
   effdt1   colon 50 label "To"
   type     colon 30
   type1    colon 50 label "To"
   project  colon 30
   project1 colon 50 label "To"
   with frame a side-labels attr-space
   width 80  NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = glname.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


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
   for each xcftr_b
      where xcftr_b.xcftr_ref     >= ref
      and   xcftr_b.xcftr_ref     <= ref1
      and xcftr_b.xcftr_domain = global_domain,
    each gltr_hist
      where gltr_ref     = xcftr_ref
      and   gltr_tr_type >= type
      and   gltr_tr_type <= type1
      and   gltr_ent_dt  >= dt
      and   gltr_ent_dt  <= dt1
      and   gltr_eff_dt  >= effdt
      and   gltr_eff_dt  <= effdt1
      
/*21*/  and gltr_domain = global_domain
      no-lock use-index gltr_ref
      break by gltr_ref by gltr_line with width 132:

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
            with down frame b STREAM-IO /*GUI*/ .
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
            with down frame b STREAM-IO /*GUI*/ .
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
     if first-of(gltr_line) then do:    
         display
            gltr_line
            account
            gltr_project
            gltr_entity
            gltr_desc format "x(18)"
            gltr_amt column-label "Base Amount"
            gltr_curramt
            gltr_curr
            gltr_addr
            gltr_doc_typ
            gltr_doc
         with down frame c width 132 no-box STREAM-IO /*GUI*/ .
         {&GLTRRP-P-TAG11}
   /*   end. /* DO WITH */ */
    
     
/*CF*/      /* DISPLAY UNPOSTED CASH FLOW TRANSACTION */
/*CF* Add Begin */
         /**CLZ1**
	 find xcf_mstr where xcf_ac_code = gltr_hist.gltr_acc
                         and xcf_sub = gltr_hist.gltr_sub
                         and xcf_cc = gltr_hist.gltr_ctr
                         and xcf_pro = gltr_hist.gltr_project
                         and xcf_active = yes
/*21*/                   and xcf_domain = global_domain
                             no-lock no-error.
         **CLZ1**/

         /*CLZ1*/
	 find first xcf_mstr no-lock where xcf_ac_code = gltr_hist.gltr_acc
	       and (xcf_sub = "*" or xcf_sub = gltr_hist.gltr_sub)
	       and (xcf_cc  = "*" or xcf_cc  = gltr_hist.gltr_ctr)
	       and (xcf_pro = "*" or xcf_pro = gltr_hist.gltr_project)
	       and xcf_active = yes and xcf_domain = global_domain no-error.
         find first xcf1_mstr where xcf1_mfgc_ac_code = gltr_hist.gltr_acc
	       and (xcf1_mfgc_sub = "*" or xcf1_mfgc_sub = gltr_hist.gltr_sub)
	       and (xcf1_mfgc_cc  = "*" or xcf1_mfgc_cc  = gltr_hist.gltr_ctr)
	       and (xcf1_mfgc_pro = "*" or xcf1_mfgc_pro = gltr_hist.gltr_pro)
	       and xcf1_cf_acc = yes and xcf1_active = yes 
	       and xcf1_domain = global_domain no-lock no-error.
	 /*CLZ1*/

         if available xcf_mstr 
	    or available xcf1_mstr /*CLZ1*/
	    then do:
            tot_xamt = 0.
   for each xcftr_hist where xcftr_hist.xcftr_entity   = gltr_hist.gltr_entity
                         and xcftr_hist.xcftr_ref      = gltr_hist.gltr_ref
                         and xcftr_hist.xcftr_rflag    = gltr_hist.gltr_rflag
                         and xcftr_hist.xcftr_ac_code  = gltr_hist.gltr_acc
                         and xcftr_hist.xcftr_sub      =gltr_hist.gltr_sub
                         and xcftr_hist.xcftr_cc       =gltr_hist.gltr_ctr
                         and xcftr_hist.xcftr_pro      =gltr_hist.gltr_project
                         and xcftr_hist.xcftr_glt_line = gltr_hist.gltr_line
                         and xcftr_domain = global_domain
                                   no-lock break by xcftr_line:

                if gltr_hist.gltr_curr = base_curr then
                   tot_xamt = tot_xamt + xcftr_hist.xcftr_amt.
                else tot_xamt = tot_xamt + xcftr_hist.xcftr_curr_amt.

                   /* GENERATE DR_CR FLAG AND XAMT */
                   {chtramt1.i &glamt=xcftr_hist.xcftr_amt
                               &glcurramt=xcftr_hist.xcftr_curr_amt
                               &coa=gltr_hist.gltr_correction
                               &glcurr=gltr_hist.gltr_curr
                               &basecurr=base_curr
                               &usecurramt=yes
                               &drcr=dr_cr
                               &dispamt=xamt}
/*XXCH911*/        drcrtxt = getTermLabel(string(dr_cr, "Dr/Cr"), 2).

                   down 1 with fram c.
                  display /*xcftr_line @ gltr_hist.gltr_line*/
                 getTermLabelRtColon("CASHFLOW", 9) + xcftr_hist.xcftr_acct 
                           @ account
                           xcftr_hist.xcftr_desc @ gltr_desc
                           gltr_curr
                           /*drcrtxt @ dr_cr*/
                           xamt @ gltr_amt with frame c STREAM-IO /*GUI*/ .
                    /*  down 1 with frame f-a.*/
             end. /* for each xcftr_det */

          end. /* if available xcf_mstr or xcf1_mstr */
      end. /* DO WITH */

/*CF* Add End */
      end.  /* first-of gltr_line*/
      for first ac_mstr
         fields (ac_code ac_type ac_domain)
/*21*/   where ac_code = gltr_acc and ac_domain = global_domain
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
      
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/


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
