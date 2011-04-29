/* glutrrp.p - GENERAL LEDGER UNPOSTED TRANSACTION REGISTER                   */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.7.3.15 $                                                               */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 5.0      LAST MODIFIED: 03/16/89   BY: JMS   *B066*              */
/*                                   10/06/89   by: jms   *B330*              */
/* REVISION: 6.0      LAST MODIFIED: 07/06/90   by: jms   *D034*              */
/*                                   02/20/91   by: jms   *D366*              */
/* REVISION: 7.0      LAST MODIFIED: 10/18/91   by: jjs   *F058*              */
/*                                   02/26/92   by: jms   *F231*              */
/*                                   08/15/94   by: pmf   *FQ15*              */
/*                                   09/03/94   by: srk   *FQ80*              */
/*                                   11/17/94   by: str   *FT77*              */
/*                                   12/11/96   by: bjl   *K01S*              */
/*                                   04/10/97   BY: *K0BF* E. Hughart         */
/* REVISION: 8.6      LAST MODIFIED: 10/16/97   by: bvm   *K11J*              */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 09/20/99   BY: *N033* Brenda Milton      */
/* REVISION: 9.1      LAST MODIFIED: 09/29/99   BY: *N014* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 06/26/00   BY: *N0DJ* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/25/00   BY: *N0VY* BalbeerS Rajput    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.7.3.9  BY: Ed van de Gevel       DATE: 07/04/02  ECO: *P0B4*   */
/* Revision: 1.7.3.11 BY: Pawel Grzybowski      DATE: 04/01/03  ECO: *P0PN*   */
/* Revision: 1.7.3.12 BY: Narathip W.           DATE: 05/03/03  ECO: *P0R5*   */
/* Revision: 1.7.3.14 BY: Paul Donnelly (SB)    DATE: 06/26/03  ECO: *Q00D*   */
/* $Revision: 1.7.3.15 $       BY: Preeti Sattur         DATE: 07/29/04  ECO: *P2CN*   */
/*By: Neil Gao 09/02/06 ECO: *SS 20090206* */
/* SS - 090703.1 By: Neil Gao */
/* SS - 090817.1 By: Neil Gao */
/* SS - 090923.1 By: Neil Gao */

/*-Revision end---------------------------------------------------------------*/

/* SS 090817.1 - B */
/*
增加生效日期
*/
/* SS 090817.1 - E */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "090923.1"}
{cxcustom.i "GLUTRRP.P"}


{gldydef.i new}

define variable ref               like gltr_ref     no-undo.
define variable ref1              like gltr_ref     no-undo.
define variable dt                like gltr_ent_dt    no-undo.
define variable dt1               like gltr_ent_dt    no-undo.
define variable effdt             like gltr_eff_dt no-undo.
define variable effdt1            like gltr_eff_dt no-undo.
define variable btch              like gltr_batch   no-undo.
define variable unb               like gltr_unb label "Unbalanced Only" no-undo.
define variable unb_msg           as character format "x(5)" no-undo.
define variable drtot             as decimal       no-undo
                                  format ">>>,>>>,>>>,>>>,>>>.99cr".
define variable crtot             like drtot       no-undo.
define variable type              like gltr_tr_type no-undo.
define variable amt               like gltr_amt     no-undo.
define variable unbflag           like mfc_logical no-undo.
define variable account           as character format "x(22)"
                                  label "Account"  no-undo.
define variable glname            like en_name     no-undo.
define variable entity            like gltr_entity no-undo.
define variable entity1           like gltr_entity no-undo.
define variable displayed_effdate as logical       no-undo.
define variable l_first_gltr_ref   like mfc_logical no-undo.

define buffer gltrhist for gltr_hist.
{&GLUTRRP-P-TAG14}

/*SS 20090206 - B*/
define variable trtype like tr_type.
/*SS 20090206 - E*/

/* GET NAME OF CURRENT ENTITY */
find en_mstr  where en_mstr.en_domain = global_domain and  en_entity =
current_entity no-lock no-error.
if not available en_mstr then do:
   {pxmsg.i &MSGNUM=3059 &ERRORLEVEL=3} /* NO PRIMARY ENTITY DEFINED */

   if c-application-mode <> 'web' then
      pause.
   leave.
end.
else do:
   glname = en_name.
   release en_mstr.
end.
assign
   entity  = current_entity
   entity1 = entity.

/* SELECT FORM */
{&GLUTRRP-P-TAG15}
form
   entity   colon 25    entity1 colon 50 label {t001.i}
   ref      colon 25    ref1    colon 50 label {t001.i}
   dt       colon 25    dt1     colon 50 label {t001.i}
   effdt    colon 25    effdt1  colon 50 label {t001.i}
   btch     colon 25
/*SS 20090206 - B*/
		trtype   colon 25
/*SS 20090206 - E*/
   type     colon 25
   unb      colon 25
with frame a side-labels attr-space width 80
   title color normal glname.
{&GLUTRRP-P-TAG16}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{&GLUTRRP-P-TAG7}
/*SS 20090206 - B*/
/*
type = "JL".
*/
type = "".
/*SS 20090206 - E*/
/* REPORT BLOCK */

{wbrp01.i}

repeat:
   if ref1 = hi_char then ref1 = "".
   if dt =  low_date then dt = ?.
   if dt1 = hi_date then dt1 = ?.
   if effdt = low_date then effdt = ?.
   if effdt1 = hi_date then effdt1 = ?.
   if entity1 = hi_char then entity1 = "".
   {&GLUTRRP-P-TAG17}
   unb = no.

   if c-application-mode <> 'web' then
      {&GLUTRRP-P-TAG18}
      update
         entity entity1
         ref ref1
         dt dt1
         effdt effdt1
         btch
/*SS 20090206 - B*/
					trtype
/*SS 20090206 - B*/
         type
         unb
      with frame a.

   {wbrp06.i &command = update &fields = "   entity entity1 ref ref1 dt dt1
        effdt effdt1 btch type unb" &frm = "a"}

   {&GLUTRRP-P-TAG19}
   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      /* CREATE BATCH INPUT STRING */
      bcdparm = "".
      {&GLUTRRP-P-TAG20}
      {mfquoter.i entity  }
      {mfquoter.i entity1 }
      {mfquoter.i ref     }
      {mfquoter.i ref1    }
      {mfquoter.i dt      }
      {mfquoter.i dt1     }
      {mfquoter.i effdt   }
      {mfquoter.i effdt1  }
      {mfquoter.i btch    }
      {mfquoter.i type    }
      {mfquoter.i unb     }
      {&GLUTRRP-P-TAG21}

      if ref1 = "" then ref1 = hi_char.
      if dt = ?  then dt = low_date.
      if dt1 = ? then dt1 = hi_date.
      if effdt = ? then effdt = low_date.
      if effdt1 = ? then effdt1 = hi_date.
      if entity1 = "" then entity1 = hi_char.
      {&GLUTRRP-P-TAG22}

      assign
         crtot = 0
         drtot = 0.
      {&GLUTRRP-P-TAG23}

   end.

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

   {&GLUTRRP-P-TAG24}

   for each gltr_hist  where gltr_hist.gltr_domain = global_domain and (
      gltr_ref >= ref and gltr_ref <= ref1 and
      gltr_ent_dt >= dt and gltr_ent_dt <= dt1 and
			(substring(gltr_desc,1,7) = trtype or trtype = "") and                                 
      gltr_eff_dt >= effdt and gltr_eff_dt <= effdt1 and
      (gltr_batch = btch or btch = "")
      ) no-lock use-index gltr_ref
         break by gltr_ref
/* SS 090817.1 - B */
/*
      with width 132 no-attr-space frame f-a no-box:
*/
      with width 142 no-attr-space frame f-a no-box:
/* SS 090817.1 - E */

      if first-of(gltr_ref)
      then
         l_first_gltr_ref = yes.

      {&GLUTRRP-P-TAG25}

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame f-a:handle).

      /* THIS ENTITY CHECK CANNOT BE IN THE FOR EACH SINCE */
      /* IF IT IS, ORACLE WILL IGNORE THE USE-INDEX PHRASE */
      if gltr_entity < entity or gltr_entity > entity1 then next.

      if type <> "" and substring(gltr_ref, 1, 2) <> type then next.
      if unb = yes and gltr_unb = no then next.

      {&GLUTRRP-P-TAG26}
      if l_first_gltr_ref
      then do:

         l_first_gltr_ref = no.

         {&GLUTRRP-P-TAG27}

         {&GLUTRRP-P-TAG1}
         {&GLUTRRP-P-TAG28}
         display
            gltr_hist.gltr_ref
            {&GLUTRRP-P-TAG29}
            gltr_hist.gltr_ent_dt column-label "Entered!Eff Date"
/* SS 090817.1 - B */
						gltr_hist.gltr_eff_dt column-label "userid!EFF_Date"
/* SS 090817.1 - E */
/* SS 090923.1 - B */
/*
            gltr_hist.gltr_user
*/
/* SS 090923.1 - E */
            .

         assign
            unb_msg = ""
            unbflag = no
            /* INDICATE THAT EFFDATE HAS NOT BEEN DISPLAYED */
            displayed_effdate = no.
         {&GLUTRRP-P-TAG2}
      end.

      else do:

         {&GLUTRRP-P-TAG5}
         {&GLUTRRP-P-TAG30}
         display "" @ gltr_hist.gltr_ref.
         {&GLUTRRP-P-TAG31}

         /* DISPLAY EFFECTIVE DATE STACKED UNDER ENTERED DATE, */
         /* ON 2ND LINE OF REF IF NO ERROR ON 1ST LINE OF REF. */
         if not displayed_effdate
         then do:
            display
               gltr_hist.gltr_eff_dt @ gltr_hist.gltr_ent_dt
/* SS 090923.1 - B */
								gltr_hist.gltr_user @ gltr_hist.gltr_eff_dt.
/* SS 090923.1 - E */
            displayed_effdate = yes.
         end.
         else
            display
               "" @ gltr_hist.gltr_ent_dt.
/* SS 090923.1 - B */
/*
         display
            "" @ gltr_hist.gltr_user.
*/
/* SS 090923.1 - E */
         {&GLUTRRP-P-TAG6}
      end.
      {&GLUTRRP-P-TAG32}
      amt = gltr_hist.gltr_amt.
      if gltr_hist.gltr_curr <> base_curr
      then
         amt = gltr_hist.gltr_curramt.
      find ac_mstr  where ac_mstr.ac_domain = global_domain and  ac_code =
      gltr_hist.gltr_acc no-lock no-error.
      if not available ac_mstr then do:
         accumulate gltr_hist.gltr_amt (total by gltr_hist.gltr_ref).
         {&GLUTRRP-P-TAG10}
         if gltr_hist.gltr_amt < 0
         then crtot = crtot - gltr_hist.gltr_amt.
         else drtot = drtot + gltr_hist.gltr_amt.
         {&GLUTRRP-P-TAG11}
      end.
      else
      if ac_type <> "S" and ac_type <> "M" then do:
         accumulate gltr_hist.gltr_amt (total by gltr_hist.gltr_ref).
         {&GLUTRRP-P-TAG12}
         if gltr_hist.gltr_amt < 0
         then crtot = crtot - gltr_hist.gltr_amt.
         else drtot = drtot + gltr_hist.gltr_amt.
         {&GLUTRRP-P-TAG13}
      end.
      {glacct.i
         &acc=gltr_hist.gltr_acc
         &sub=gltr_hist.gltr_sub
         &cc=gltr_hist.gltr_ctr
         &acct=account}
      {&GLUTRRP-P-TAG3}
      display
         gltr_hist.gltr_line
         account
         gltr_hist.gltr_project
         gltr_hist.gltr_entity
         gltr_hist.gltr_desc
         amt
         gltr_hist.gltr_curr
         gltr_hist.gltr_dy_code.
      {&GLUTRRP-P-TAG4}
      /* SECOND LINE NEEDED WHEN AN ERROR. */
      /* ALSO DISPLAY EFFECTIVE DATE STACKED UNDER ENTERED DATE. */
      if gltr_hist.gltr_error <> "" then do:
         down 1.
         if not displayed_effdate
         then do:
            {&GLUTRRP-P-TAG8}
            display
               gltr_hist.gltr_eff_dt @ gltr_hist.gltr_ent_dt.
            {&GLUTRRP-P-TAG9}
            displayed_effdate = yes.
         end.

         display gltr_hist.gltr_error @ gltr_hist.gltr_desc.
      end.

      if daybooks-in-use and gltr_hist.gltr_dy_code > "" and
         (gltr_hist.gltr_dy_num = "" or gltr_hist.gltr_dy_num = ?)
      then do:
         down 1.
         display  "* " + getTermLabel("NO_DAYBOOK_ENTRY",19) + "# *"
            @ gltr_hist.gltr_desc.
      end.

      if gltr_hist.gltr_unb = yes then unbflag = yes.

      if last-of(gltr_hist.gltr_ref) then do:

         /* DISPLAY EFFECTIVE DATE STACKED UNDER ENTERED DATE, */
         /* ON LAST LINE OF REF IF NOT ALREADY DISPLAYED.      */
         if not displayed_effdate
         then do:
            down 1.
            {&GLUTRRP-P-TAG8}
            display
               gltr_hist.gltr_eff_dt @ gltr_hist.gltr_ent_dt.
            {&GLUTRRP-P-TAG9}
            displayed_effdate = yes.
         end.

         if unbflag = yes then
            unb_msg = "*" + getTermLabel("UNBALANCED",3) + "*".
         underline amt.

         display
            accum total by gltr_hist.gltr_ref gltr_hist.gltr_amt @ amt
            base_curr @ gltr_hist.gltr_curr
            unb_msg @ gltr_hist.gltr_dy_code.
         down 1.
      end.

      {&GLUTRRP-P-TAG33}
      {mfrpchk.i}
   end.

   /* PRINT DEBIT AND CREDIT TOTALS */

   {&GLUTRRP-P-TAG34}
   put skip(2)

      {gplblfmt.i
         &FUNC=getTermLabelRtColon(""DEBIT_TOTAL"",20)
         &CONCAT="'  '"
      }  at 25 drtot space(1) base_curr

      {gplblfmt.i
         &FUNC=getTermLabelRtColon(""CREDIT_TOTAL"",20)
         &CONCAT="'  '"
      } at 75 crtot space(1) base_curr.
      {&GLUTRRP-P-TAG35}

   /* REPORT TRAILER  */
   {mfrtrail.i}
end.

{wbrp04.i &frame-spec = a}
