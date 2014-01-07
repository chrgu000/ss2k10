/* gpselout.i - INCLUDE FILE TO SELECT OUTPUT DEVICE / DESTINATION           */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*V8:ConvertMode=Report                                                      */
/* REVISION: 9.1       CREATED: 10/12/99       BY: *N03C* Thelma Stronge     */
/* REVISION: 9.1      M0DIFIED: 02/14/00       BY: *M0JQ* J. Fernando        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00  BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00  BY: *N0KS* myb                */
/* REVISION: 9.1      LAST MODIFIED: 02/07/01  BY: *M10Y* Seema Tyagi        */
/*
PURPOSE:
This include file:
-  allows selection of an output destination.
-  validates the selected output destination.
-  calls gpprsout.i to process output to the selected destination

NOTE:
- This file is a merged version of the following printer selection files
    mfselbp2.i
    mfselbpr.i
    mfselp02.i
    mfselp03.i
    mfselprt.i
    mfselpr1.i
- This file is tightly coupled with the file gpprsout.i.
- Variables defined in this file are also referenced in mfreset.i.
*/

/* Parameters:                                                                */
/*    {&printType}         Name of file to output to - "terminal", "printer"  */
/*    {&printWidth}        Width of page - e.g. 80, 132                       */
/*    {&pagedFlag}         "nopage" for programs printing checks or labels    */
/*                         Other values - "page", ""                          */
/*    {&stream}            Either specify a named stream or ""                */
/*    {&appendToFile}      "append" if report is to be appended to a file     */
/*                         "" otherwise                                       */
/*    {&streamedOutputToTerminal}                                             */
/*                         "yes" to allow a streamed report terminal          */
/*                         Other values - "no", ""                            */
/*    {&withBatchOption}   Allow submittal to batch - "yes" or "no"           */
/*    {&displayStatementType}                                                 */
/*                         Integer value which controls the format of the     */
/*                         display statement for the destination selection    */
/*                         variables.                                         */
/*    {&withCancelMessage} Specifies whether the 'Report is now running'      */
/*                         message will indicate how to cancel the report     */
/*    {&pageBottomMargin } An integer value representing the number of lines  */
/*                         which will make up the bottom margin of the page   */
/*    {&withEmail}         Allow selection of output destinations of type     */
/*                         email                                              */
/*    {&withWinprint}      Allow selection of output destinations of type     */
/*                         Winprint (Windows Printer)                         */
/*    {&defineVariables}   Specifies whether or not the variables batch_id and*/
/*                         dev will be defined in this file by making a call  */
/*                         to mfsprtdf.i.                                     */
/*                         "yes" to make a call to mfsprtdf.i                 */
/*                         "no" not to make a call to mfsprdf.i               */
/*                         This parameter is "yes" in the majority of cases.  */
/*                         It is "no" for the gpselout.i calls in grrunrp.p   */
/*                         and grexcrp.p.                                     */
/*M10Y*/  /* ADDED NEW ARGUMENT */
/*    {&removeQuotes}      Specifies whether or not to remove the quotes      */
/*                         around the pagedFlag argument before using         */

/* ********** Begin Translatable Strings Definitions ********* */

/* ********** End Translatable Strings Definitions ********* */
/*===========================================================================*/
/* DEFINE VARIABLES */

/*NOTE: SOME VARIABLES HAVE NOT BEEN RENAMED USING THE l_ PREFIX AS THEY ARE
  REFERENCED IN EXISTING REPORT PROGRAMS */


&IF "{&WEB-SELPRT-VARS}" = "" &THEN
   define variable l-web-options-ok  as   logical             no-undo.
   define variable i-web-pagesize    as   integer             no-undo.
   define variable l_webOutputOption as   character           no-undo.

/*M10Y*/ define variable l_pagedFlag as   character           no-undo.

/*M10Y*/ /* CHECK IF removeQuotes IS AN INCLUDE FILE ARGUMENT */
/*M10Y*/ l_pagedFlag = "{&pagedFlag}".

/*M10Y*/ &IF defined(removeQuotes) = 2
/*M10Y*/ &THEN
/*M10Y*/     &IF string({&removeQuotes}) = "yes"
/*M10Y*/     &THEN
/*M10Y*/         /* REMOVE THE QUOTES FROM THE pagedFlag argument */
/*M10Y*/         l_pagedFlag = {&pagedFlag}.
/*M10Y*/     &ENDIF
/*M10Y*/ &ENDIF

   /*CHECK IF defineVariables IS AN INCLUDE FILE ARGUMENT*/
   &IF defined(defineVariables) = 2 &THEN
        &IF string({&defineVariables}) = "yes" &THEN
            /*DEFINE NEW SHARED VARIABLES batch_id AND dev */
            {mfsprtdf.i new}
         &ENDIF
   &ENDIF

   /* DEFINE WEB ENABLEMENT VARIABLES */
   {wbgp03.i}

   /* GET WEB OUTPUT OPTIONS */
   {wboutopt.i
    &printType = "{&printType} "
    &printWidth = {&printWidth}
    &withOutputOption = "yes"
    &withBatchOption = "{&withBatchOption} "
   }

   &GLOBAL-DEFINE WEB-SELPRT-VARS FALSE
&ENDIF

/* DEFINE SHARED VARIABLES */
define     shared variable printdefault      like prd_dev.
define     shared variable printdefaultlevel as   integer.

/* DEFINE LOCAL VARIABLES */
define variable l_pagesize        as   integer             no-undo.
define variable l-filename        as   character           no-undo.
define variable l_validSelection  as   logical initial yes no-undo.
define variable l_initialised     as   logical             no-undo.
define variable path              like prd_path            no-undo.
define variable spooler           like prd_spooler         no-undo.
define variable scrollonly        like prd_scroll_only     no-undo.

/*THE FOLLOWING VARIABLES ARE REFERENCED IN mfreset.i*/
define variable printwidth        as   integer             no-undo.
define variable printype          as   character           no-undo.

/*V8!
/* DEFINE GUI SPECIFIC VARIABLES */
define variable terminal-window   as   widget-handle.
define variable save-window       as   widget-handle.

if printype = "terminal" then do:
   define variable criteria-prt   as   character no-undo.
   define variable criteria-prt-column as integer no-undo.
end.
*/

/*brian btst
/*===========================================================================*/

run initialise  (output l_initialised).

if not l_initialised then
   return.

/*===========================================================================*/


/* SELECT OUTPUT */
run displayOutputDestinationSelectionFields.


do on error undo, retry:

   /* ACCEPT OUTPUT SELECTION */

   if c-application-mode <> 'WEB':U then do:

      &IF defined(withBatchOption) = 2 &THEN /*2 INDICATES .i ARGUMENT*/

         &IF string({&withBatchOption}) = "yes" &THEN
            /*ALLOW EDITING OF OUTPUT AND BATCH FIELDS*/
            set dev batch_id with frame a editing:
               /* SET EXTERNAL LABELS */
               setFrameLabels(frame a:handle).
               if frame-field = "batch_id" then do:
                  /* SCROLL UP/DOWN THROUGH BATCH RECORDS */
                  {mfnp05.i bc_mstr bc_batch "yes" bc_batch "input batch_id"}
                  if recno <> ? then do:
                     batch_id = bc_batch.
                     display batch_id with frame a.
                  end.
               end.
               else do:
                  /* SCROLL UP/DOWN THROUGH OUTPUT DEVICE RECORDS */
                  {mfnp05.i prd_det prd_dev "yes" prd_dev "input dev"}
                  if recno <> ? then do:
                     dev = prd_dev.
                     display dev with frame a.
                  end.
               end.
            end. /*set.. editing*/

         &ELSEIF string({&withBatchOption}) = "no" &THEN
            /*ALLOW EDITING OF OUTPUT FIELD ONLY*/
            set dev with frame a editing:
               /* SCROLL UP/DOWN THROUGH OUTPUT DEVICE RECORDS */
               {mfnp.i prd_det dev prd_dev dev prd_dev prd_dev}
               if recno <> ? then do:
                  dev = prd_dev.
                  display dev with frame a.
               end.
            end.  /*set.. editing*/
         &ENDIF
      &ENDIF

   end. /*if c-application-mode <> WEB*/

   /* VALIDATE SELECTION */
   run validateSelection  (output l_validSelection).

   if not l_validSelection then do:
      if c-application-mode = 'WEB':U then
         return.   /* HANDLE INVALID SELECTION DIFFERENTLY IN WEB MODE */
      else
         undo , retry.
   end.

end. /*do on error undo, retry */

brian btst*/

/*brian btst*/
dev = "Local".
/*display dev with frame a.*/

/* VALIDATE SELECTION */
run validateSelection  (output l_validSelection).
/*brian btst end*/
   

/* RESET STATUS INPUT LINE ON WINDOW TO ORIGINAL STATE */
status input.

/*===========================================================================*/
/* PROCESS OUTPUT DESTINATION SELECTION */

/*M10Y*/ /* THE FIRST ARGUMENT IS NOT BEING USED BY gpprsout.i */
/*M10Y*/ /* BUT USES THE LOCAL VARIABLE l_pagedFlag            */
{gpprsout.i
 &pagedFlag = "{&pagedFlag}"
 &stream = "{&stream} "
 &appendToFile = "{&appendToFile} "
 &streamedOutputToTerminal = "{&streamedOutputToTerminal} "
 &withBatchOption = "{&withBatchOption} "
 &withCancelMessage = "{&withCancelMessage} "
 &pageBottomMargin = {&pageBottomMargin}
}
/*===========================================================================*/
/*========================= INTERNAL PROCEDURES =============================*/
/*===========================================================================*/


PROCEDURE displayOutputDestinationSelectionFields:

   /*------------------------------------------------------------------
   PURPOSE :
      Display output destination and batch ID fields in report frame
      depending on the include file arguments &withBatchOption and
      &displayStatementType.

   PARAMETERS:

   NOTES:

   ------------------------------------------------------------------*/

   /*
   ENSURE THAT withBatchOption ARGUMENT HAS BEEN DEFINED
   (2 INDICATES AN INCLUDE FILE ARGUMENT)
   */
   &IF defined(withBatchOption) = 2 &THEN

      &IF string({&withBatchOption}) = "yes" &THEN

         /* DISPLAY OUTPUT AND BATCH FIELDS (CHARACTER & WEB)*/
         /*V8-*/
         if c-application-mode <> 'WEB':U then
            display dev to 77 batch_id to 77 with frame a.
         /*V8+*/

         /* DISPLAY OUTPUT AND BATCH FIELDS (GUI)*/
         /*V8!
         &IF {&displayStatementType} = 1 &THEN
             display dev to 78.5 batch_id to 78.5 space(.5) skip(.4) with frame a.
         &ELSEIF {&displayStatementType} = 2 &THEN
             display dev to 77 batch_id to 77 with frame a.
         &ENDIF
         */

      &ELSEIF string({&withBatchOption}) = "no" &THEN

         /* DISPLAY OUTPUT FIELD ONLY (CHARACTER & WEB)*/
         /*V8-*/
         if c-application-mode <> 'WEB':U then
            display dev to 77 with frame a.
         /*V8+*/

         /* DISPLAY OUTPUT FIELD ONLY (GUI)*/
         /*V8!
         &IF {&displayStatementType} = 1 &THEN
             display dev to 78.5 space(.5) skip(.4) with frame a.
         &ELSEIF {&displayStatementType} = 2 &THEN
             display dev with frame a.
         &ENDIF
         */

      &ENDIF

   &ENDIF


END PROCEDURE.  /* displayOutputDestinationSelectionFields */

/*===========================================================================*/

PROCEDURE initialise:

   /*------------------------------------------------------------------
   PURPOSE :
      Initialise variables for output.

   PARAMETERS:
      o_initialised indicating success or failure of initialisation

   NOTES:
      This procedure currently returns 'no' if the web call get-output-options
      fails.
   ------------------------------------------------------------------*/

define output parameter o_initialised as logical initial yes no-undo.

if c-application-mode = 'WEB':U then do:

   /* GET WEB OUTPUT OPTIONS */
   run get-output-options in h-wblib
      (OUTPUT dev,
       OUTPUT batch_id,
       OUTPUT i-web-pagesize,
       OUTPUT l-web-options-ok).

   if not l-web-options-ok then do:
      o_initialised = no.
      return.
   end.

   run init-data-reply in h-wblib.

end.

/* INITIALISE VARIABLES */
/*V8!
flag-report-exit = FALSE.
*/

/* ASSIGN PASSED PARAMETERS TO LOCAL VARIABLES ( NEEDED IN mfreset.i ) */
printype = "{&printType}".
printwidth = {&printWidth}.

/* DETERMINE DEFAULT OUTPUT DEVICE AND INITIALISE VARIABLE */
run setDefaultOutputDestination .

END PROCEDURE. /* initialise */

/*===========================================================================*/

PROCEDURE setDefaultOutputDestination:

   /*------------------------------------------------------------------
   PURPOSE : Sets the default output destination

   PARAMETERS:

   NOTES:
       - The print default for the CURRENT menu selection is taken if one
         exists.
       - If a print default exists for a higher menu selection in the same
         menu structure but not for the current menu selection, the default
         for the higher menu may be taken but only if the default argument
         passed by the program is "printer" (generally, inquiries are mapped
         to "terminal" and reports are mapped to "printer").
       - Most inquiries need a specific defined printer default so "terminal"
         is chosen above any default that exists for a higher menu selection.
       - Where there is no print default at any level for a report, an attempt
         will be made to find any printer detail record with "printer" as the
         output device.  Failing this, a record with "terminal" or "window" is
         found.

   ------------------------------------------------------------------*/

   if dev = "" or dev = ? then do:

      if printype = "terminal" then do:

         /* NEED SPECIFIC DEFINED PRINTER DEFAULT FOR MOST INQUIRIES */
         if printdefault = "" or printdefaultlevel <> 1 then
            dev = "terminal".
         else
            dev = printdefault.

      end.
      else do:
         if printdefault <> "" then
            dev = printdefault.
         else do:
            if can-find(prd_det where prd_dev = "printer") then
               dev = "printer".
            else do:
               find last prd_det where
                     prd_path <> "terminal"
                 and prd_dev <> "terminal"
               /*V8!
                 and prd_path <> "window"
                 and prd_dev <> "window"
                */
               no-lock no-error.

               if available prd_det then
                  dev = prd_dev.
               else
                  dev = "printer".
            end.        /* else do (if can-find...) */
         end.        /* else do (if printdefault <> "" then) */
      end.        /* else do (if printype = "terminal" then) */
   end.        /* if dev = "" or dev = ? */

END PROCEDURE. /* setDefaultOutputDestination */

/*===========================================================================*/

PROCEDURE validateBatchNumber:

   /*------------------------------------------------------------------
   PURPOSE :
      Validate the batch value.

   PARAMETERS:
      o_validSelection: logical indicating that the selection is valid.

   NOTES:
      This procedure accesses the variable batch_id defined in the main
      part of this include file.
   ------------------------------------------------------------------*/

   define output parameter o_validSelection as logical initial yes no-undo.

   find bc_mstr where bc_batch = batch_id no-lock no-error.

   if not available bc_mstr then do:

      /* "Batch control record does not exist" */
      {mfmsg.i 67 3}
      o_validSelection = no.

   end.

END PROCEDURE. /* validateBatchNumber */

/*===========================================================================*/

PROCEDURE validateOutputDestination:

   /*------------------------------------------------------------------
   PURPOSE :
      Validate the output destination selection.

   PARAMETERS:
      o-validSelection: logical indicating whether the slected output
                        destination is valid.
   NOTES:
   ------------------------------------------------------------------*/

   define output parameter o-validSelection as logical initial yes no-undo.

   path = dev.
   scrollonly = no.

   find prd_det where prd_dev = dev no-lock no-error.

   if available prd_det then do:

      /*
      VALIDATE DIFFERENT CONDITIONS. RETURN FROM THIS PROCEDURE IF THE
      SELECTION IS INVALID FOR ANY REASON.
      */
       /* JAVAUI IS THE DEFAULT OUTPUT DEVICE FOR NETUI     */    /*M0JQ*/
       /* AND WILL BE CONSIDERED INVALID IN CHUI & GUI.     */    /*M0JQ*/
      /* BEGIN ADDED CODE */                                      /*M0JQ*/
      if path = 'JAVAUI':U
         and c-application-mode <> 'WEB':U then do:
         /* OUTPUT TO JAVAUI IS ONLY AVAILABLE WITH MFG/PRO */
         /* FOR NETUI.                                      */
         {mfmsg.i 3451 3}
         o-validSelection = no.
         return.
      end.
      /* END ADDED CODE  */                                       /*M0JQ*/

      /*V8-*/
      if path = "window" then do:
         /* OUTPUT TO WINDOW IS ONLY AVAILABLE WITH MFG/PRO FOR WINDOWS */
         {mfmsg.i 8005 3}
         o-validSelection = no.
         return.
      end.

      if prd_dest_type = 2 then do: /*WINDOWS PRINTER*/
         /* OUTPUT TO WINDOWS PRINTER IS ONLY AVAILABLE WITH MFG/PRO
            FOR WINDOWS */
         {mfmsg.i 3372 3}
         o-validSelection = no.
         return.
      end.
      /*V8+*/

      /*V8!
      if prd_dest_type = 2 and "{&withWinprint}" = "no" then do:
         /* OUTPUT TO WINDOWS PRINTER IS NOT AVAILABLE FOR THIS FUNCTION */
         {mfmsg.i 3391 3}
         o-validSelection = no.
         return.
      end.

      if path = "page" then do:
         /* PAGE IS NOT A VALID OUTPUT DEVICE IN GUI */
         {mfmsg.i 2225 3}
         o-validSelection = no.
         return.
      end.
      */

      if prd_dest_type = 1 and "{&withEmail}" = "no" then do:
         /* OUTPUT TO EMAIL IS NOT AVAILABLE FOR THIS FUNCTION */
         {mfmsg.i 3392 3}
         o-validSelection = no.
         return.
      end.

/*M10Y** if prd_scroll_only and "{&pagedFlag}" <> "" then do: */

/*M10Y*/ if prd_scroll_only
/*M10Y*/    and l_pagedFlag <> ""
/*M10Y*/ then do:
            /* MAXIMUM PAGE LIMIT NOT ALLOWED WITH NO-PAGE OPTION */
            {mfmsg.i 89 3}
            o-validSelection = no.
            return.
         end.

      if prd_path <> "" then path = prd_path.
      scrollonly = prd_scroll_only.

   end. /*if available prd_det*/

   else do:

      if not batchrun then do:
         if c-application-mode = 'WEB':U then do:

            run get-outopt-field in h-wblib
                              (input 'OPTION':U,
                               output l_webOutputOption).
            run get-outopt-field in h-wblib
                              (input 'FILE':U,
                               output l-filename).
         end.

         if not ( c-application-mode = 'WEB':U
                and l_webOutputOption = '{&REMOTE-PRINTER}':U
                and l-filename <> '':U ) then do:

            /* DEVICE ENTERED IS NOT A DEFINED PRINTER. */
            {mfmsg.i 34 2}

            if c-application-mode <> 'WEB':U then
               pause.

         end.  /* if not (c-application-mode...) */
      end.  /* if not batchrun */
   end.  /* else do */

   if    ( "{&withBatchOption}" = "yes" )
     and ( path = "terminal" or path = "/dev/tty" or path = "tt:"
          /*V8!
          or path = "window"
          */
          or scrollonly
          )
     and batch_id <> ""
   then do:

      /* OUTPUT TO TERMINAL NOT ALLOWED FOR BATCH REQUEST */
      {mfmsg.i 66 3}
      o-validSelection = no.
      return.

   end.

   /*
   DON'T ALLOW STREAMED REPORTS TO GO TO TERMINAL, UNLESS OVERRIDDEN
   THESE REPORTS USUALLY HAVE ANOTHER STREAM GOING TO TERMINAL
   */
   if (  path = "terminal" or path = "/dev/tty"
      or path = "tt:" or scrollonly )
     and "{&stream}" > "" and "{&streamedOutputToTerminal}" <> "yes"
   then do:

      /* TERMINAL NOT ALLOWED */
      {mfmsg.i 35 3}
      o-validSelection = no.
      return.

   end.

END PROCEDURE. /* validateOutputDestination */

/*===========================================================================*/
PROCEDURE validateSelection:

   /*------------------------------------------------------------------
   PURPOSE :
      Validate the selected values for output destination and batch ID.

   PARAMETERS:
      o_validSelection - Flag set to no if selection is invalid.

   NOTES:
   ------------------------------------------------------------------*/

   define output parameter o_validSelection as   logical initial yes no-undo.

   &IF defined(withBatchOption) = 2 &THEN /*2 INDICATES .i ARGUMENT*/
      /* VALIDATE SELECTED BATCH VALUE WHERE BATCH RUN OPTION IS AVAILABLE */
      if ( string({&withBatchOption}) = "yes" ) and ( batch_id <> "" ) then do:
         run validateBatchNumber (output o_validSelection).
      end.
   &ENDIF

   /* VALIDATE SELECTED OUTPUT DESTINATION */
   if (o_validSelection) then do:
      run validateOutputDestination (output o_validSelection).
   end.

END PROCEDURE.
/*===========================================================================*/
