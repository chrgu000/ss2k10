/* GUI CONVERTED from yy000203.p (converter v1.78) Mon Oct  8 11:33:50 2012 */
/* icsiiq.p - SITE INQUIRY                                                    */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.12 $                                                          */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 6.0          LAST EDIT: 02/07/90   MODIFIED BY: EMB              */
/* REVISION: 6.0          LAST EDIT: 09/03/91   BY: afs *D847*                */
/* Revision: 7.3          Last edit: 11/19/92   By: jcd *G339*                */
/*           7.3                     09/10/94   BY: bcm *GM02*                */
/*           7.3                     03/15/95   by: str *F0N1*                */
/* REVISION: 8.6          LAST EDIT: 03/09/98   BY: *K1KX* Beena Mol          */
/* REVISION: 8.6          LAST EDIT: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6          LAST EDIT: 06/02/98   BY: *K1RQ* A.Shobha           */
/* REVISION: 9.0          LAST EDIT: 03/10/99   BY: *M0B8* Hemanth Ebenezer   */
/* REVISION: 9.0          LAST EDIT: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.12 $    BY: Jean Miller          DATE: 04/06/02  ECO: *P056*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "121008.1"}

{yy000200.i "new"}
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

DEFINE VARIABLE v_site1 LIKE si_site NO-UNDO.
DEFINE VARIABLE v_site2 LIKE si_site NO-UNDO.
DEFINE VARIABLE v_part1 LIKE pt_part NO-UNDO.
DEFINE VARIABLE v_part2 LIKE pt_part NO-UNDO.
DEFINE VARIABLE v_pline1 LIKE pt_prod_line NO-UNDO.
DEFINE VARIABLE v_pline2 LIKE pt_prod_line NO-UNDO.
DEFINE VARIABLE v_type1 LIKE pt_part_type NO-UNDO.
DEFINE VARIABLE v_type2 LIKE pt_part_type NO-UNDO.
DEFINE VARIABLE v_group1 LIKE pt_group NO-UNDO.
DEFINE VARIABLE v_group2 LIKE pt_group NO-UNDO.
DEFINE VARIABLE v_effdate AS DATE INITIAL TODAY.
DEFINE VARIABLE v_days AS INTEGER NO-UNDO INITIAL 365.
define new shared variable v_rptfmt like mfc_logical
   label "1-stdout/2-browseout" format "1-stdout/2-browseout" initial yes.

FORM /*GUI*/

 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
space(1)
   v_site1 COLON 20 v_site2 COLON 40 LABEL {t001.i}
   v_part1 COLON 20 v_part2 COLON 40 LABEL {t001.i}
   v_pline1 COLON 20 v_pline2 COLON 40 LABEL {t001.i}
   v_type1 COLON 20 v_type2 COLON 40 LABEL {t001.i}
   v_group1 COLON 20 v_group2 COLON 40 LABEL {t001.i}
   v_effdate COLON 20
   v_days COLON 20
   v_rptfmt COLON 20 SKIP(1)
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

{wbrp01.i}

repeat:
    IF v_site2 = hi_char THEN v_site2 = "".
    IF v_part2 = hi_char THEN v_part2 = "".
    IF v_pline2 = hi_char THEN v_pline2 = "".
    IF v_type2 = hi_char THEN v_type2 = "".
    IF v_group2 = hi_char THEN v_group2 = "".
/*    if c-application-mode <> 'web' then                            */
/*       prompt-for si_site with frame a                             */
/*    editing:                                                       */
/*                                                                   */
/*       if frame-field = "si_site" then do:                         */
/*                                                                   */
/*          /* FIND NEXT/PREVIOUS RECORD */                          */
/*          {mfnp.i si_mstr si_site si_site si_site si_site si_site} */
/*                                                                   */
/*          if recno <> ? then display si_site si_desc with frame a. */
/*          recno = ?.                                               */
/*       end.                                                        */
/*       else do:                                                    */
/*          status input.                                            */
/*          readkey.                                                 */
/*          apply lastkey.                                           */
/*       end.                                                        */
/*    end.                                                           */
/*    status input.                                                  */
   DISPLAY v_effdate v_days WITH FRAME a.
   UPDATE v_site1 v_site2 v_part1 v_part2 v_pline1 v_pline2 v_type1 v_type2
          v_group1 v_group2 v_days v_rptfmt WITH FRAME a.
   {wbrp06.i &command = prompt-for &fields = " v_site1 v_site2 v_part1 v_part2
          v_pline1 v_pline2 v_type1 v_type2 v_group1 v_group2 v_days v_rptfmt"
             &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

     IF v_site2 = "" THEN v_site2 = hi_char.
     IF v_part2 = "" THEN v_part2 = hi_char.
     IF v_pline2 = "" THEN v_pline2 = hi_char.
     IF v_type2 = "" THEN v_type2 = hi_char.
     IF v_group2 = "" THEN v_group2 = hi_char.
      hide frame b.

   end.
   for each usrw_wkfl exclusive-lock where usrw_key1 = vkey1:
       delete usrw_wkfl.
   end.
   FOR EACH IN_mstr NO-LOCK WHERE IN_site >= v_site1 AND IN_site <= v_site2
        AND IN_part >= v_part1 AND IN_part <= v_part2,
       EACH pt_mstr NO-LOCK WHERE pt_part = IN_part
        AND pt_prod_line >= v_pline1 AND pt_prod_line <= v_pline2
        AND pt_part_type >= v_type1 AND pt_part_type <= v_type2
        AND pt_group >= v_group1 AND pt_group <= v_group2:
       FIND first tr_hist NO-LOCK WHERE tr_part = pt_part
              and tr_effdate >= v_effdate - v_days
              AND (tr_type = "ISS-SO" or tr_type = "ISS-WO" or
                   tr_type = "ISS-UNP" or tr_type = "ISS-FAS")
       use-index tr_part_eff NO-ERROR.
       IF not available tr_hist do:
          find first usrw_wkfl no-lock where usrw_key1 = vkey1
                 and usrw_key2 = pt_part no-error.
          if not available usrw_wkfl then do:
             create usrw_wkfl.
             assign usrw_key1 = vkey1
                    usrw_key2 = in_part.
          end.
       end.
   END.
/*                                                                                                    */
/*    /* OUTPUT DESTINATION SELECTION */                                                              */
/*    {gpselout.i &printType = "terminal"                                                             */
/*                &printWidth = 80                                                                    */
/*                &pagedFlag = " "                                                                    */
/*                &stream = " "                                                                       */
/*                &appendToFile = " "                                                                 */
/*                &streamedOutputToTerminal = " "                                                     */
/*                &withBatchOption = "no"                                                             */
/*                &displayStatementType = 1                                                           */
/*                &withCancelMessage = "yes"                                                          */
/*                &pageBottomMargin = 6                                                               */
/*                &withEmail = "yes"                                                                  */
/*                &withWinprint = "yes"                                                               */
/*                &defineVariables = "yes"}                                                           */
/* /*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2. */
/*                                                                                                    */
/*                                                                                                    */
/*    for each si_mstr NO-LOCK WHERE si_site >= v_site1 AND  si_site <= v_site2  WITH FRAME c down:   */
/*                                                                                                    */
/*       /* SET EXTERNAL LABELS */                                                                    */
/*       setFrameLabels(frame b:handle).                                                              */
/*                                                                                                    */
/*                                                                                                    */
/* /*GUI*/ {mfguichk.i } /*Replace mfrpchk*/                                                          */
/*                                                                                                    */
/*                                                                                                    */
/*       display                                                                                      */
/*          si_site                                                                                   */
/*          si_desc                                                                                   */
/*          si_entity                                                                                 */
/*          si_status                                                                                 */
/*          si_auto_loc                                                                               */
/*          si_db WITH STREAM-IO /*GUI*/ .                                                            */
/*                                                                                                    */
/*    end.                                                                                            */
/*                                                                                                    */
/*    {mfreset.i}                                                                                     */
/* /*GUI*/ {mfgrptrm.i} /*Report-to-Window*/                                                          */
/*                                                                                                    */
/*    {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}                                                               */
/*                                                                                                    */
end.

{wbrp04.i &frame-spec = a}
