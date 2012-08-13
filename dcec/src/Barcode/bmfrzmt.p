/* GUI CONVERTED from bmfrzmt.p (converter v1.78) Fri Oct 29 14:32:44 2004 */
/* bmfrzmt.p - COST ROLL UP FREEZE / UNFREEZE                            */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* $Revision: 1.12.1.5.3.2 $                                                         */
/*V8:ConvertMode=Report                                                  */
/* REVISION: 7.3      LAST MODIFIED: 02/15/93   BY: pma *G681*          */
/* REVISION: 8.5      LAST MODIFIED: 10/20/94   BY: mwd *J034*          */
/* REVISION: 7.3      LAST MODIFIED: 03/08/95   BY: srk *G0GN*          */
/*                                   07/07/95   by: qzl *G0RX*          */
/*                                   10/23/95   by: jym *G19Q*          */
/*                                   12/18/95   by: bcm *G1F9*          */
/*                                   01/16/95   by: bcm *G1K5*          */
/* REVISION: 8.5      LAST MODIFIED: 01/27/98   BY: *J2CR* Viswanathan  */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 07/07/00   BY: *N0F9* Arul Victoria      */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.12.1.5     BY: Hualin Zhong      DATE: 10/01/01  ECO: *N12T*   */
/* Revision: 1.12.1.5.3.1 BY: Katie Hilbert     DATE: 01/08/04  ECO *P1J4*    */
/* $Revision: 1.12.1.5.3.2 $ BY: Katie Hilbert      DATE: 01/14/04  ECO *P1JS*    */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

define variable site     like si_site      no-undo.
define variable csset    like sct_sim      no-undo.
define variable part     like pt_part      no-undo.
define variable part1    like pt_part      no-undo.
define variable line     like pt_prod_line no-undo.
define variable line1    like pt_prod_line no-undo.
define variable type     like pt_part_type no-undo.
define variable type1    like pt_part_type no-undo.
define variable grp      like pt_group     no-undo.
define variable grp1     like pt_group     no-undo.
define variable pmcode   like pt_pm_code   no-undo.
define variable pmcode1  like pt_pm_code   no-undo.
define variable buyer    like pt_buyer     no-undo.
define variable buyer1   like pt_buyer     no-undo.
define variable frz_flag like mfc_logical initial yes
                         label  "Freeze/Unfreeze"
                         format "Freeze/Unfreeze" no-undo.
define variable audit_yn like mfc_logical initial yes
                         label "Print Audit Trail" no-undo.
define variable yn       like mfc_logical  no-undo.
define variable method   as character format "x(15)".
define variable threeast as character format "x(3)" no-undo
                         initial "***".


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
site           colon 18
   csset          colon 18
   cs_desc        colon 30 no-label
   method         no-label
   skip(1)
   part           colon 18 part1   label "To"  colon 49
   line           colon 18 line1   label "To"  colon 49
   type           colon 18 type1   label "To"  colon 49
   grp            colon 18 grp1    label "To"  colon 49
   pmcode         colon 18 pmcode1 label "To"  colon 49
   buyer          colon 18 buyer1  label "To"  colon 49
   skip(1)
   frz_flag       colon 25
   audit_yn       colon 25
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

FORM /*GUI*/ 
   pt_part
   pt_desc1
   sct_cst_date
   sct_rollup format "Frozen/Unfrozen" column-label "Was"
   frz_flag   format "Frozen/Unfrozen" column-label "Is"
   threeast   no-label
with STREAM-IO /*GUI*/  frame b width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

/* DIFFERENT LABELS/FORMATS ARE DISPLAYED FOR SAME VARIABLE, */
/* SO NEED TO ASSIGN THEM MANUALLY.                          */
if dynamic-function('getTranslateFramesFlag' in h-label) then
   assign
      frz_flag:label    = getTermLabel("IS",4)
      frz_flag:format   = getTermLabel("FROZEN/UNFROZEN",17)
      sct_rollup:format = getTermLabel("FROZEN/UNFROZEN",17).

site = global_site.
display
   site
   csset
with frame a.

find first icc_ctrl no-lock.

mainloop:
repeat:
   if part1 = hi_char then
      part1 = "".
   if line1 = hi_char then
      line1 = "".
   if type1 = hi_char then
      type1 = "".
   if grp1 = hi_char then
      grp1 = "".
   if pmcode1 = hi_char then
      pmcode1 = "".
   if buyer1 = hi_char then
      buyer1 = "".

   if not batchrun then do:
      seta1:
      do transaction on error undo, retry:
         set site with frame a editing:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i si_mstr site si_site site si_site si_site}

            if recno <> ? then do:
               site = si_site.
               display site with frame a.
               recno = ?.
            end.
         end.

         find si_mstr where si_site = site no-lock no-error.
         if not available si_mstr then do:
            {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3} /* Site does not exist */
            next-prompt site with frame a.
            undo, retry.
         end.

         if si_db <> global_db then do:
            /* Site is not assigned to this database */
            {pxmsg.i &MSGNUM=5421 &ERRORLEVEL=3}
            next-prompt site with frame a.
            undo, retry.
         end.
         {gprun.i ""gpsiver.p""
            "(input site, input recid(si_mstr), output return_int)"}
         if return_int = 0 then do:

            /* USER DOES NOT HAVE ACCESS TO THIS SITE */
            {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
            next-prompt site with frame a.
            undo mainloop, retry mainloop.
         end.
      end.

      seta2:
      do transaction on error undo, retry:
         set csset with frame a editing:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i cs_mstr csset cs_set csset cs_set cs_set}
            if recno <> ? then do:
               csset = cs_set.
               display csset with frame a.
               find cs_mstr where cs_set = csset no-lock no-error.
               method = "".
               if available cs_mstr then do:
                  method = "[ " + cs_method + " / " + cs_type + " ]".
                  display cs_desc method with frame a.
               end.
               recno = ?.
            end.
         end.

         if csset = "" then do:
            {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3} /*Blank not allowed*/
            next-prompt csset.
            undo, retry.
         end.

         find cs_mstr where cs_set = csset no-lock no-error.
         if not available cs_mstr then do:
            {pxmsg.i &MSGNUM=5407 &ERRORLEVEL=3} /*Cost set does not exist*/
            next-prompt csset.
            undo, retry.
         end.

         method = "[ " + cs_method + " / " + cs_type + " ]".
         display cs_desc method with frame a.
      end.

      status input.
      update
         part
         part1
         line
         line1
         type
         type1
         grp
         grp1
         pmcode
         pmcode1
         buyer
         buyer1
         frz_flag
         audit_yn
      with frame a.
   end. /*if not batchrun*/

   else do:
      update
         site
         csset
         part
         part1
         line
         line1
         type
         type1
         grp
         grp1
         pmcode
         pmcode1
         buyer
         buyer1
         frz_flag
         audit_yn
      with frame a.
      find si_mstr where si_site = site no-lock no-error.
   end.

   bcdparm = "".
   {mfquoter.i site     }
   {mfquoter.i csset    }
   {mfquoter.i part     }
   {mfquoter.i part1    }
   {mfquoter.i line     }
   {mfquoter.i line1    }
   {mfquoter.i type     }
   {mfquoter.i type1    }
   {mfquoter.i grp      }
   {mfquoter.i grp1     }
   {mfquoter.i pmcode   }
   {mfquoter.i pmcode1  }
   {mfquoter.i buyer    }
   {mfquoter.i buyer1   }
   {mfquoter.i frz_flag }
   {mfquoter.i audit_yn }

   if part1 = "" then
      part1 = hi_char.
   if line1 = "" then
      line1 = hi_char.
   if type1 = "" then
      type1 = hi_char.
   if grp1 = "" then
      grp1 = hi_char.
   if pmcode1 = "" then
      pmcode1 = hi_char.
   if buyer1 = "" then
      buyer1 = hi_char.

   if audit_yn then do:
      /* OUTPUT DESTINATION SELECTION */
      {gpselout.i &printType = "printer"
                  &printWidth = 80
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
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.

      {mfphead2.i}
   end.
   else if not batchrun then do:
      yn = yes.
      /*Begin cost roll-up ? */
      {pxmsg.i &MSGNUM=207 &ERRORLEVEL=1 &CONFIRM=yn}
      if not yn then undo, retry.
   end.

   /* WE NEED TO IDENTIFY ALL ITEM MASTER OR ITEM-SITE RECORDS THAT *
    * MATCH THE SELECTION CRITERIA.  IT IS IMPORTANT TO UNDERSTAND  *
    * THAT COSTING INFORMATION (sct_det) CAN EXIST FOR AN ITEM-SITE *
    * COMBINATION EVEN THOUGH NO ITEM-SITE PLANNING RECORD (ptp_det)*
    * EXISTS.  IF THAT IS THE CASE, WE RELY ON THE ITEM MASTER      *
    * RECORD FOR SELECTION CRITERIA.                                */

   pt_mstr-loop:
   for each pt_mstr no-lock
         where (pt_part >= part and pt_part <= part1)
         and   (pt_prod_line >= line and pt_prod_line <= line1)
         and   (pt_part_type >= type and pt_part_type <= type1)
         and   (pt_group >= grp and pt_group <= grp1)
   with frame b down width 80:

      /* CHECK ITEM PLANNING DETAIL */
      find ptp_det
         where ptp_part = pt_part
         and   ptp_site = site
      no-lock no-error.

      if ((available ptp_det and
         (ptp_pm_code >= pmcode and ptp_pm_code <= pmcode1) and
         (ptp_buyer   >= buyer  and ptp_buyer   <= buyer1))
         or
         (not available ptp_det and
         (pt_pm_code >= pmcode  and pt_pm_code <= pmcode1)  and
         (pt_buyer   >= buyer   and pt_buyer   <= buyer1)))
      then do:

         find sct_det
            where sct_part = pt_part
              and sct_site = site
              and sct_sim = csset
         exclusive-lock no-error.

         if available sct_det then do:
            if audit_yn then do:
               if sct_rollup <> frz_flag then
                  threeast = "***".
               else
                  threeast = "".
               display
                  pt_part
                  pt_desc1
                  sct_cst_date
                  sct_rollup
                  frz_flag
                  threeast
               with frame b STREAM-IO /*GUI*/ .
               down with frame b.
            end. /* PRINT THE REPORT */

            sct_rollup = frz_flag.
         end.

      end.

      
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

   end.

   assign
      global_type = ""
      global_site = site.

   /* REPORT TRAILER  */
   if audit_yn then do:
      {mftrl080.i}
   end.

end.
