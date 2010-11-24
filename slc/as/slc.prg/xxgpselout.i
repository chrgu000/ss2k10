/* gpselout.i - INCLUDE FILE TO SELECT OUTPUT DEVICE / DESTINATION           */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*                                                      */
/* REVISION: 9.1       CREATED: 10/12/99       BY: *N03C* Thelma Stronge     */
/* REVISION: 9.1      M0DIFIED: 02/14/00       BY: *M0JQ* J. Fernando        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00  BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00  BY: *N0KS* myb                */
/* REVISION: 9.1      LAST MODIFIED: 02/07/01  BY: *M10Y* Seema Tyagi        */
/* Revision: 1.19     BY: Paul Donnelly (SB)   DATE: 06/28/03  ECO: *Q00F*   */
/* Revision: 1.21     BY: Vandna Rohira        DATE: 08/22/04  ECO: *P2G9*   */
/* Revision: 1.22     BY: Mugdha Tambe         DATE: 08/30/05  ECO: *P3KW*   */
/* Revision: 1.24     BY: Gerard Menezes       DATE: 01/05/06  ECO: *P4F8*   */
/* Revision: 1.26     BY: Gerard Menezes       DATE: 06/08/06  ECO: *P4MV*   */
/* $Revision: 1.27 $  BY: Ajay Nair            DATE: 06/27/06  ECO: *P4NQ*   */
/*By: Neil Gao 08/03/21 ECO: *SS 20080321* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*-Revision end---------------------------------------------------------------*/

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
/* ADDED NEW ARGUMENT          */
/*    {&removeQuotes}      Specifies whether or not to remove the quotes      */
/*                         around the pagedFlag argument before using         */
/*    {&device}            Alternate variable for setting the output device   */
/*                         Useful when more than one output device has to     */
/*                         setup upfront.                                     */
/*===========================================================================*/
/*V8:ConvertMode=Report                                                      */

{cxcustom.i "GPSELOUT.I"}

/* DEFINE VARIABLES */

/*NOTE: SOME VARIABLES HAVE NOT BEEN RENAMED USING THE l_ PREFIX AS THEY ARE
REFERENCED IN EXISTING REPORT PROGRAMS */

&IF "{&WEB-SELPRT-VARS}" = "" &THEN
   define variable l-web-options-ok  as   logical             no-undo.
   define variable i-web-pagesize    as   integer             no-undo.
   define variable l_webOutputOption as   character           no-undo.

   define variable l_pagedFlag as   character           no-undo.

   /* CHECK IF removeQuotes IS AN INCLUDE FILE ARGUMENT */
   l_pagedFlag = "{&pagedFlag}".

   &IF defined(removeQuotes) = 2
         &THEN
      &IF string({&removeQuotes}) = "yes"
            &THEN
         /* REMOVE THE QUOTES FROM THE pagedFlag argument */
         l_pagedFlag = {&pagedFlag}.
      &ENDIF
   &ENDIF

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

   &GLOBAL-DEFINE WEB-SELPRT-VARS false
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

if printype = "terminal"
then do:
   define variable criteria-prt   as   character no-undo.
   define variable criteria-prt-column as integer no-undo.
end. /* IF printype = "TERMINAL" */
*/

/*===========================================================================*/

run initialise  (output l_initialised).

if not l_initialised
then
   return.

/*===========================================================================*/

/* SELECT OUTPUT */
&IF NOT defined(device)  = 2 &THEN
run displayOutputDestinationSelectionFields.
&ENDIF

do on error undo, retry:

   /* ACCEPT OUTPUT SELECTION */

   if c-application-mode <> 'WEB' and
      c-application-mode <> 'WORKBENCH' then do:

      &IF NOT defined(device)  = 2 &THEN

      &IF defined(withBatchOption) = 2 &THEN /*2 INDICATES .i ARGUMENT*/

         &IF string({&withBatchOption}) = "yes" &THEN

            /* DEFINE BATCHID ONLY WHEN PROGRAM IS SUBMITTED IN BATCH MODE */
            &GLOBAL-DEFINE BATCHID batch_id
            /*ALLOW EDITING OF OUTPUT AND BATCH FIELDS*/
            set dev batch_id with frame a
            editing:
               /* SET EXTERNAL LABELS */
               setFrameLabels(frame a:handle).
               if frame-field = "batch_id"
               then do:
                  /* SCROLL UP/DOWN THROUGH BATCH RECORDS */
                  {mfnp05.i bc_mstr bc_batch " bc_mstr.bc_domain =
                       global_domain and yes"  bc_batch "input batch_id"}
                  if recno <> ?
                  then do:
                     batch_id = bc_batch.
                     display batch_id with frame a.
                  end. /* IF recno <> ? */
               end. /* IF FRAME-FIELD = "batch_id" */
               else do:
                  /* SCROLL UP/DOWN THROUGH OUTPUT DEVICE RECORDS */
                  {mfnp05.i prd_det prd_dev "yes" prd_dev "input dev"}
                  if recno <> ?
                  then do:
                     dev = prd_dev.
                     display dev with frame a.
                  end. /* IF recno <> ? */
               end. /* IF FRAME-FIELD <> "batch_id" */
            end. /*SET.. EDITING*/

            &ELSEIF string({&withBatchOption}) = "no" &THEN
            /*ALLOW EDITING OF OUTPUT FIELD ONLY*/

	    
/*SS 20080321 - B*/
/*
            set dev with frame a
            editing:
               /* SCROLL UP/DOWN THROUGH OUTPUT DEVICE RECORDS */
               {mfnp.i prd_det dev prd_dev dev prd_dev prd_dev}
               if recno <> ?
               then do:
                  dev = prd_dev.
                  display dev with frame a.
               end. /* IF recno <> ? */
            end.  /*SET.. EDITING*/
*/
	
	/*---Add Begin by davild 20080421.1*/	   
	    dev =  "vinprint" .
	    display dev with frame a.
	    /*---Add End   by davild 20080421.1*/
/*SS 20080321 - E*/            
            &ENDIF /* if string withBatchOption is 2 */
         &ENDIF /* if defined withBatchOption */
      &ELSE  /* &device has been provided */
          assign dev  =  {&device} .
          &IF defined(batch)  = 2 &THEN
             assign batch_id = {&batch} .
         &ENDIF
      &ENDIF
   end. /*IF c-application-mode <> WEB*/

   /* VALIDATE SELECTION */
   run validateSelection  (output l_validSelection).

   if not l_validSelection
   then do:
      if c-application-mode = 'WEB'
      then
         return.   /* HANDLE INVALID SELECTION DIFFERENTLY IN WEB MODE */
      else
         undo , retry.
   end. /* IF NOT l_validSelection */

end. /*DO ON ERROR UNDO, RETRY */

/* RESET STATUS INPUT LINE ON WINDOW TO ORIGINAL STATE */
status input.

/*===========================================================================*/
/* PROCESS OUTPUT DESTINATION SELECTION */

/* THE FIRST ARGUMENT IS NOT BEING USED BY gpprsout.i */
/* BUT USES THE LOCAL VARIABLE l_pagedFlag            */
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
PURPOSE:
Display output destination and batch ID fields in report frame
depending on the include file arguments &withBatchOption and
&displayStatementType.

PARAMETERS:

NOTES:

------------------------------------------------------------------*/

   /* ENSURE THAT withBatchOption ARGUMENT HAS BEEN DEFINED  */
   /* (2 INDICATES AN INCLUDE FILE ARGUMENT)                 */

   &IF defined(withBatchOption) = 2 &THEN

      &IF string({&withBatchOption}) = "yes" &THEN

         /* DISPLAY OUTPUT AND BATCH FIELDS (CHARACTER & WEB)*/
         /*V8-*/
         if c-application-mode <> 'WEB'
         then
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
         if c-application-mode <> 'WEB'
         then
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
PURPOSE:
Initialise variables for output.

PARAMETERS:
o_initialised indicating success or failure of initialisation

NOTES:
This procedure currently returns 'no' if the web call get-output-options
fails.
------------------------------------------------------------------*/

   define output parameter o_initialised as logical initial yes no-undo.

   if c-application-mode = 'WEB'
   then do:

      /* GET WEB OUTPUT OPTIONS */
      run get-output-options in h-wblib
         (output dev,
         output batch_id,
         output i-web-pagesize,
         output l-web-options-ok).

      if not l-web-options-ok
      then do:
         o_initialised = no.
         return.
      end. /* IF NOT L-web-options-ok */

      run init-data-reply in h-wblib.

   end. /* IF c-application-mode = 'WEB' */

   /* INITIALISE VARIABLES */
   /*V8!
   flag-report-exit = FALSE.
   */

   /* ASSIGN PASSED PARAMETERS TO LOCAL VARIABLES ( NEEDED IN mfreset.i ) */
   printype = "{&printType}".
   printwidth = {&printWidth}.

   /* DETERMINE DEFAULT OUTPUT DEVICE AND INITIALISE VARIABLE */
   /* IF QXTEND THEN SET DEFAULT PRINTER */
   if {gpisapi.i} then run setDefaultPrinter.
   run setDefaultOutputDestination .

END PROCEDURE. /* initialise */

/*===========================================================================*/

PROCEDURE setDefaultPrinter:

/*--------------------------------------------------------------------------
PURPOSE: Initialise default printer for current user and menu selection

PARAMETERS:

NOTES:
--------------------------------------------------------------------------*/
   define variable thismenu      as character no-undo.
   define variable thisselection as integer   no-undo.

   for first mnd_det no-lock
       where mnd_det.mnd_exec = execname:

       assign
             thismenu      = mnd_det.mnd_nbr + "." + string(mnd_det.mnd_select)
             thisselection = mnd_det.mnd_select.

      {mfprdef.i thismenu thisselection}
   end.

END PROCEDURE. /* setDefaultPrinter */

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

   if dev = "" or dev = ?
   then do:

      if printype = "terminal"
      then do:

         /* NEED SPECIFIC DEFINED PRINTER DEFAULT FOR MOST INQUIRIES */
         if printdefault = "" or printdefaultlevel <> 1
         then
            dev = "terminal".
         else
            dev = printdefault.

      end. /* IF printype = "TERMINAL" */
      else do:
         if printdefault <> ""
         then
            dev = printdefault.
         else do:
            if can-find(prd_det where prd_dev = "printer")
            then
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

               if available prd_det
               then
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
PURPOSE:
Validate the batch value.

PARAMETERS:
o_validSelection: logical indicating that the selection is valid.

NOTES:
This procedure accesses the variable batch_id defined in the main
part of this include file.
------------------------------------------------------------------*/

   define output parameter o_validSelection as logical initial yes no-undo.

   find bc_mstr  where bc_mstr.bc_domain = global_domain and  bc_batch =
      batch_id no-lock no-error.

   if not available bc_mstr
   then do:

      /* "BATCH CONTROL RECORD DOES NOT EXIST" */
      {pxmsg.i &MSGNUM=67 &ERRORLEVEL=3}
      o_validSelection = no.

   end. /* IF NOT AVAILABLE bc_mstr */

END PROCEDURE. /* validateBatchNumber */

/*===========================================================================*/

PROCEDURE validateOutputDestination:

/*------------------------------------------------------------------
PURPOSE:
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

   if available prd_det
   then do:

      /* VALIDATE DIFFERENT CONDITIONS. RETURN FROM THIS PROCEDURE IF THE */
      /* SELECTION IS INVALID FOR ANY REASON.                             */

      /* JAVAUI IS THE DEFAULT OUTPUT DEVICE FOR NETUI     */
      /* AND WILL BE CONSIDERED INVALID IN CHUI & GUI.     */
      if path = 'JAVAUI'
         and c-application-mode <> 'WEB'
      then do:
         /* OUTPUT TO JAVAUI IS ONLY AVAILABLE WITH MFG/PRO */
         /* FOR NETUI.                                      */
         {pxmsg.i &MSGNUM=3451 &ERRORLEVEL=3}
         o-validSelection = no.
         return.
      end. /* IF path = 'JAVAUI' */

      /*V8-*/
      if path = "window"
      then do:
         /* OUTPUT TO WINDOW IS ONLY AVAILABLE WITH MFG/PRO FOR WINDOWS */
         {pxmsg.i &MSGNUM=8005 &ERRORLEVEL=3}
         o-validSelection = no.
         return.
      end. /* IF path = "window" */

      if prd_dest_type = 2
      then do:
         /*WINDOWS PRINTER*/
         /* OUTPUT TO WINDOWS PRINTER IS ONLY AVAILABLE WITH MFG/PRO
         FOR WINDOWS */
         {pxmsg.i &MSGNUM=3372 &ERRORLEVEL=3}
         o-validSelection = no.
         return.
      end. /* IF prd_dest_type = 2 */
      /*V8+*/

      {&GPSELOUT-I-TAG1}

      /*V8!
      if prd_dest_type = 2
         and "{&withWinprint}" = "no"
      then do:
         /* OUTPUT TO WINDOWS PRINTER IS NOT AVAILABLE FOR THIS FUNCTION */
         {pxmsg.i &MSGNUM=3391 &ERRORLEVEL=3}
         o-validSelection = no.
         return.
      end. /* IF prd_dest_type = 2 */

      if path = "page"
      then do:
         /* PAGE IS NOT A VALID OUTPUT DEVICE IN GUI */
         {pxmsg.i &MSGNUM=2225 &ERRORLEVEL=3}
         o-validSelection = no.
         return.
      end. /* IF path = "page" */
      */

      if prd_dest_type = 1
         and "{&withEmail}" = "no"
      then do:
         /* OUTPUT TO EMAIL IS NOT AVAILABLE FOR THIS FUNCTION */
         {pxmsg.i &MSGNUM=3392 &ERRORLEVEL=3}
         o-validSelection = no.
         return.
      end. /* IF prd_dest_type = 1 */

      if prd_scroll_only
         and l_pagedFlag <> ""
      then do:
         /* MAXIMUM PAGE LIMIT NOT ALLOWED WITH NO-PAGE OPTION */
         {pxmsg.i &MSGNUM=89 &ERRORLEVEL=3}
         o-validSelection = no.
         return.
      end. /* IF prd_scroll_only */

      if prd_path <> ""
      then
         path = prd_path.
      scrollonly = prd_scroll_only.

   end. /*IF AVAILABLE prd_det*/

   else do:

      if not batchrun
      then do:
         if c-application-mode = 'WEB'
         then do:

            run get-outopt-field in h-wblib
               (input 'OPTION',
               output l_webOutputOption).
            run get-outopt-field in h-wblib
               (input 'FILE',
               output l-filename).
         end.  /* IF c-application-mode = 'WEB' */

         if not ( c-application-mode = 'WEB'
            and l_webOutputOption = '{&REMOTE-PRINTER}'
            and l-filename <> '' )
         then do:

            /* DEVICE ENTERED IS NOT A DEFINED PRINTER. */
            {pxmsg.i &MSGNUM=34 &ERRORLEVEL=2}

            if c-application-mode <> 'WEB'
            then
               pause.

         end.  /* IF NOT (c-application-mode...) */
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
      {pxmsg.i &MSGNUM=66 &ERRORLEVEL=3}
      o-validSelection = no.
      return.

   end. /* IF ( "{&withBatchOption}" = "yes" ) */

   /* DON'T ALLOW STREAMED REPORTS TO GO TO TERMINAL, UNLESS OVERRIDDEN */
   /* THESE REPORTS USUALLY HAVE ANOTHER STREAM GOING TO TERMINAL       */

   if (  path = "terminal"
      or path = "/dev/tty"
      or path = "tt:" or scrollonly )
      and "{&stream}" > "" and "{&streamedOutputToTerminal}" <> "yes"
   then do:

      /* TERMINAL NOT ALLOWED */
      {pxmsg.i &MSGNUM=35 &ERRORLEVEL=3}
      o-validSelection = no.
      return.

   end. /* IF (  path = "terminal" */

END PROCEDURE. /* validateOutputDestination */

/*===========================================================================*/
PROCEDURE validateSelection:

/*------------------------------------------------------------------
PURPOSE:
Validate the selected values for output destination and batch ID.

PARAMETERS:
o_validSelection - Flag set to no if selection is invalid.

NOTES:
------------------------------------------------------------------*/

   define output parameter o_validSelection as   logical initial yes no-undo.

   &IF defined(withBatchOption) = 2 &THEN /*2 INDICATES .i ARGUMENT*/
      /* VALIDATE SELECTED BATCH VALUE WHERE BATCH RUN OPTION IS AVAILABLE */
      if ( string({&withBatchOption}) = "yes" ) and ( batch_id <> "" )
      then do:
         run validateBatchNumber (output o_validSelection).
      end. /* IF ( STRING({&withBatchOption}) = "yes" ) */
   &ENDIF

   /* VALIDATE SELECTED OUTPUT DESTINATION */
   if (o_validSelection) then do:
      run validateOutputDestination (output o_validSelection).
   end. /* IF (o_validSelection) */

END PROCEDURE.
/*===========================================================================*/
