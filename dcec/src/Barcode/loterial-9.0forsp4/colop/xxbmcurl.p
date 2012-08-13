/* xxbmcurl.p - ROLL-UP BOM COPPER WEIGHT                                     */
/* Copyright 2004 Shanghai e-Steering Inc., Shanghai , CHINA                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn              */
/* REVISION: 9.1      LAST MODIFIED: 08/29/00   BY: *N0PP* Jean Miller      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* $Revision: 1.8.1.11 $       BY: Rajesh Thomas  DATE: 06/28/01 ECO: *M1CD*         */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "b+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE xxbmcurl_p_1 "Print Audit Trail"
/* MaxLen: Comment: */

&SCOPED-DEFINE xxbmcurl_p_2 "As of Date"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


define new shared variable site  like si_site.

define new shared variable part  like pt_part.
define new shared variable part1 like pt_part.

define new shared variable line  like pt_prod_line.
define new shared variable line1 like pt_prod_line.
define new shared variable type  like pt_part_type.
define new shared variable type1 like pt_part_type.
define new shared variable grp   like pt_group.
define new shared variable grp1  like pt_group.

define new shared variable eff_date as date initial today
   label {&xxbmcurl_p_2}.
define new shared variable part_type like pt_part_type.
define new shared variable audit_yn like mfc_logical initial yes
   label {&xxbmcurl_p_1}.
define new shared variable rollup_id like qad_key3.

define variable yn like mfc_logical.
define variable l_is_oracle like mfc_logical initial no.
define variable i as integer.
define variable method as character format "x(15)".
define variable frm-text as character format "x(30)" no-undo.

define NEW shared variable transtype as character format "x(7)".


frm-text = getTermLabel("SET_COST_UPDATE_FIELD_FOR",30).


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
   SKIP(1) 
   part           colon 18 part1  label {t001.i} colon 49
   line           colon 18 line1  label {t001.i} colon 49
   type           colon 18 type1  label {t001.i} colon 49
   grp            colon 18 grp1   label {t001.i} colon 49
   skip(1)
   eff_date       colon 25
   skip(0.1)
   audit_yn       colon 25
    SKIP(1)
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

find first icc_ctrl no-lock.

/* IF NOT ORACLE THEN L_IS_ORACLE = NO ELSE L_IS_ORACLE = YES */
assign
   l_is_oracle = (dbtype ("qaddb") = "ORACLE")
   site = global_site.


display
   part part1
   line line1
   type type1
   grp grp1
   eff_date
   audit_yn
with frame a.

mainloop:
repeat:

   if part1 = hi_char then part1 = "".
   if line1 = hi_char then line1 = "".
   if type1 = hi_char then type1 = "".
   if grp1 = hi_char then grp1 = "".

   if not batchrun then do:
      update
         part part1
         line line1
         type type1
         grp grp1
         eff_date
         audit_yn
      with frame a.

   end. /*if not batchrun*/

   else do:
      update
         part part1
         line line1
         type type1
         grp grp1
         eff_date
         audit_yn
      with frame a.
      find si_mstr where si_site = site no-lock no-error.
   end.

   bcdparm = "".
                      
/*****   
   {gprun.i ""gpquote.p"" "(input-output bcdparm,
                     9,
                     part,
                     part1,
                     line,
                     line1,
                     type,
                     type1,
                     grp,
                     grp1,
                     string(eff_date),
                     string(audit_yn))"}
                     
   {gprun.i ""gpquote.p"" "(input-output bcdparm,
                     1,
                     string(yield_flag),
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char)"}
   ***/

   if part1 = "" then part1 = hi_char.
   if line1 = "" then line1 = hi_char.
   if type1 = "" then type1 = hi_char.
   if grp1 = "" then grp1 = hi_char.

   if eff_date = ?
   then do:
      eff_date =  today.
      display eff_date with frame a.
   end. /* IF eff_date ... */

   /*****************************************************************/
   /*ADDED THE FOLLOWING SECTION IN ORDER TO GENERATE A UNIQUE ID   */
   /*SO THAT ONCE AN ITEM IS ROLLED UP, IT WILL NOT BE ROLLED UP    */
   /*MULTIPLE TIMES.  SIMULTANEOUS ROLLUPS WITH THE SAME EFFECTIVE  */
   /*DATE AND FLAG SETTINGS WILL SHARE THIS UNIQUE ID.  SIMULTANEOUS*/
   /*ROLLUPS FOR THE SAME SITE/COSTSET WITH DIFFERENT EFFECTIVITIES */
   /*AND/OR FLAGS ARE PROHIBITED.                                   */
   /*****************************************************************/

   /*OUTER ERROR LOOP RETRY'S EVEN THOUGH NOTHING CHANGES*/
   transloop:
   repeat:

      /*ERROR WHEN TWO PROCESSES CREATE SIMULTANEOUS QAD_WKFL*/
      repeat transaction on error undo, retry:
         pause 0.
         hide message no-pause.

         /*DELETE THE NON-ACTIVE QAD_WKFL, IF ONE EXISTS*/

         /* IF NOT ORACLE THE FIND QAD_WKFL RECORD WITH EXCL-LOCK */
         if l_is_oracle = no then
         do:
            find qad_wkfl exclusive-lock
               where qad_key1 = "XXBMCURLB"
               and qad_key2 = site 
               no-error no-wait.
            if available qad_wkfl then delete qad_wkfl.
         end. /* IF L_IS_ORACLE = NO */

         /*FIND THE ACTIVE QAD_WKFL, IF ONE EXISTS*/
         find qad_wkfl share-lock where qad_key1 = "XXBMCURLB"
            and qad_key2 = site 
            no-error.

         /*TEST TO ENSURE CONFLICT CONDITIONS DON'T EXIST*/
         if available qad_wkfl and
             qad_datefld[1] <> eff_date
         then do:

            do on endkey undo mainloop, retry mainloop:
               if l_is_oracle = yes then do on error undo, retry:

                  /* ARE MULTIPLE SESSIONS ROLLING COSTS  */
                  /* FOR THE SAME SITE/COST SET?          */
               {pxmsg.i &MSGNUM=3336 &ERRORLEVEL=1
                        &CONFIRM=yn  &CONFIRM-TYPE='LOGICAL'}
                  if yn = no then do:
                     find qad_wkfl exclusive-lock
                        where qad_key1 = "XXBMCURLB"
                        and   qad_key2 = site 
                        no-error no-wait.
                     if available qad_wkfl then delete qad_wkfl.
                     else yn = yes.
                  end. /* IF YN = NO */

               end. /* IF L_IS_ORACLE = YES */
            end. /* ON ENDKEY UNDO MAINLOOP, RETRY MAINLOOP */

            if l_is_oracle = no or yn = yes  then do:
               /* CONFLICTING ROLLUP IN PROGRESS */
               {pxmsg.i &MSGNUM=5306 &ERRORLEVEL=4}
               undo mainloop, retry.
            end. /* IF L_IS_ORACLE = NO OR YN = YES */

         end. /* IF AVAILABLE QAD_WKFL */

         /*FIRST PROCESS CREATES NEW QAD_WKFL*/

         if not available qad_wkfl then do:
            create qad_wkfl.
            assign
               qad_key1       = "XXBMCURLB"
               qad_key2       = site 
               qad_datefld[1] = eff_date
               qad_charfld[1] = mfguser
               /*PROGRAM DEFINED DATE FORMAT TO AVOID CONFLICT BETWEEN */
               /*USERS WITH A DIFFERENT -d DATE DEFAULT                */
               qad_key3 = substring(string(year(today),"9999"),3,2)
                        + string(month(today),"99")
                        + string(day(today),"99")
                        + " "
                        + string(time).

         end.

         rollup_id = qad_key3.
         leave transloop.

      end.

      hide message no-pause.
      pause 0.

   end.

   if audit_yn then do:
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
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.

      {mfphead.i}
   end.
   else if not batchrun then do:
      yn = yes.
      /* BEGIN COST ROLL-UP ? */
      {pxmsg.i &MSGNUM=207 &ERRORLEVEL=1 &CONFIRM=yn
         &CONFIRM-TYPE='LOGICAL'}
      if not yn then undo, retry.
   end.

   {gprun.i ""xxbmcurlb.p""}

   global_type = "".

   /*****************
   FOR EACH pt_mstr WHERE pt__dec01 <> 0       
       and pt_part >= part and pt_part <= part1
         and pt_prod_line >= line and pt_prod_line <= line1
         and pt_part_type >= type and pt_part_type <= type1
        and pt_group >= grp and pt_group <= grp1
         no-lock:
        DISPLAY pt_part pt_desc1 pt_desc2 pt_prod_line pt_um
                      pt__dec01  FORMAT "->>>>>>>9.9<<<<<<" 
                      LABEL "Copper Weight"  WITH WIDTH 132 STREAM-IO .

   END.
   *********************/

   /*GUI*/ {mfguichk.i } /*Replace mfrpchk*/


   /* REPORT TRAILER  */
   if audit_yn then do:
      {mfrtrail.i}
   end.
      
 /* REPORT TRAILER */
 /*
   
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/
   */
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


   /*SCOPE QAD_WKFL TO MAINLOOP*/

   do transaction:
      find qad_wkfl
         where qad_key1       = "XXBMCURLB" and
         qad_key2       = site and
         qad_key3       = rollup_id and
         qad_charfld[1] = mfguser
         exclusive-lock no-error.
      if available qad_wkfl then
            delete qad_wkfl.
   end. /* DO TRANSACTION */

   release qad_wkfl.

end.
