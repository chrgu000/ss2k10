/* pxgblmgr.p  - Global Data Manager                                          */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.14 $                                                           */
/*                                                                            */
/* Hold and manage global data values.                                        */
/*                                                                            */
/* REVISION: 9.1 BY: Brian Wintz          DATE: 02/23/2000  ECO: *N03S*       */
/* REVISION: 9.1 BY: Murali Ayyagari      DATE: 03/10/2000  ECO: *N08X*       */
/* REVISION: 9.1 BY: Brian Wintz          DATE: 04/01/2000  ECO: *N092*       */
/* Revision: 1.6       BY: Murali Ayyagari  DATE: 07/11/00  ECO: *N0DP*       */
/* Revision: 1.13.1.1         BY: B. S. Rajput     DATE: 10/18/00  ECO: *N0WW*       */
/* REVISION: 9.1      LAST MODIFIED: 29 JUN 2001 BY: *N0ZX* Ed van de Gevel */
/* $Revision: 1.14 $   BY: Evan Todd DATE: 10/27/2003 ECO: *Q04J*                   */
/*                                                                            */
/*V8:ConvertMode=NoConvert                                                    */

{mfdeclre.i}
{mf1.i}
{cxcustom.i "PXGBLMGR.P"}
{pxmsglib.i}
/*N0ZX*/ {&PXGBLMGR-P-TAG2}

THIS-PROCEDURE:private-data = "pxgblmgr".

/*Constants*/
&SCOPED-DEFINE GBL_CHARACTER 1
&SCOPED-DEFINE GBL_DATE     2
&SCOPED-DEFINE GBL_DECIMAL   3
&SCOPED-DEFINE GBL_HANDLE   4
&SCOPED-DEFINE GBL_INTEGER   5
&SCOPED-DEFINE GBL_LOGICAL   6

&SCOPED-DEFINE VALOBJ "ValidationObject_"
&SCOPED-DEFINE PXTOOLS "GeneralPurposeTools"

/*Local Vars (Private)*/

/*Work Tables*/
define temp-table gbl_data
   field gbl_id as character
   field gbl_type as integer
   field gbl_character as character
   field gbl_date as date
   field gbl_decimal as decimal
   field gbl_handle as handle
   field gbl_integer as integer
   field gbl_logical as logical
   .


/*============================================================================*/
/* *************************  Function Prototypes  ************************** */
/*============================================================================*/

/*============================================================================*/
/* ****************************  Main Block  ******************************** */
/*============================================================================*/


/*============================================================================*/
/* ****************************  Functions  ********************************* */
/*============================================================================*/

/*============================================================================*/
FUNCTION getWellKnownHandle returns handle
   (input pGlobalID as character):
/*------------------------------------------------------------------------------
 Purpose:   Determine if the requested handle is for a well known service
              that we know how to start.
 Exceptions:
 Notes: public function
</Comment/>
@Interface IGlobalManager
Handle getWellKnownHandle(String pGlobalID)
   Find a global handle and return its value.
Parameters
   pGlobalID - identifier for global value to return value of
Pre Conditions
   Identifier must specify a global handle value.
Post Conditions
   Returns global value specified by identifier.
</Comment/>
 History:
----------------------------------------------------------------------------*/
   define variable retValue as handle no-undo.
   define variable pgmName as character no-undo.

   if (substring(pGlobalID, 1, length({&VALOBJ})) = {&VALOBJ}) then do:
      pgmName = substring(pGlobalID, length({&VALOBJ}) + 1) + ".p".
   end.
   else do:
      case pGlobalID:
         when {&MESSAGE-HANDLE-ID} then do:
            pgmName = "pxmsglib.p".
         end.
         when {&PXTOOLS} then do:
            pgmName = "pxtools.p".
         end.
         {&PXGBLMGR-P-TAG1}
      end.
   end.

   if (pgmName <> ?) then do:
      if(pgmName = "pxtools.p") then
         run pxtools.p persistent set retValue no-error.
      else do:
         {gprun.i pgmName "persistent set retValue no-error"}
      end.
      if (valid-handle(retValue)) then
         run setGlobalHandle(input pGlobalID, input retValue).
   end.

   return (retValue).

END FUNCTION.


/*============================================================================*/
FUNCTION getGlobalHandle returns handle
   (input pGlobalID as character):
/*------------------------------------------------------------------------------
 Purpose:    Find a global handle and return its value.
 Exceptions:
 Notes: public function
</Comment/>
@Interface IGlobalManager
Handle getGlobalHandle(String pGlobalID)
   Find a global handle and return its value.
Parameters
   pGlobalID - identifier for global value to return value of
Pre Conditions
   Identifier must specify a global handle value.
Post Conditions
   Returns global value specified by identifier.
</Comment/>
 History:
----------------------------------------------------------------------------*/
   define variable retValue as handle no-undo.

   for first gbl_data
      where gbl_id = pGlobalID
      no-lock: end.
   if available gbl_data then do:
      if gbl_type = {&GBL_HANDLE} then do:
         retValue = gbl_handle.
      end.
      if (not valid-handle(retValue)) then
         retValue = getWellKnownHandle(input pGlobalID).
   end.
   else do:
      retValue = getWellKnownHandle(input pGlobalID).
   end.

   return (retValue).

END FUNCTION.

/*============================================================================*/
FUNCTION getIntegerValue RETURNS Integer
 (input pName as character) :
/*------------------------------------------------------------------------------
Purpose:    Find a global Integer variable and return its value.
Exceptions:
Parameters: pName - Name of the variable.
Conditions:
        Pre: Identifier must specify name of the variable.
        Post: Returns value for the variable.
Notes: public function
History:
----------------------------------------------------------------------------*/
 case pName:
   when "global-screen-size" then  return(global-screen-size).
   when "global-window-size" then  return(global-window-size).
   when "global_user_lang_nbr" then  return(global_user_lang_nbr).
   when "maxpage" then  return(maxpage).
   when "printlength" then  return(printlength).
   when "trmsg" then  return(trmsg).
   when "window_down" then  return(window_down).
   when "window_row" then  return(window_row).
   otherwise
         run dispMessage (input 712, input pName).
 end.
END FUNCTION.

FUNCTION getCharacterValue RETURNS Character
 (input pName as character) :
/*------------------------------------------------------------------------------
Purpose:    Find a global Character variable and return its value.
Exceptions:
Parameters: pName - Name of the variable.
Conditions:
        Pre: Identifier must specify name of the variable.
        Post: Returns value for the variable.
Notes: public function
History:
----------------------------------------------------------------------------*/
 case pName:
   when "base_curr" then  return(base_curr).
   when "bcdparm" then  return(bcdparm).
   when "c-application-mode" then  return(c-application-mode).
   when "current_entity" then  return(current_entity).
   when "dtitle" then  return(dtitle).
   when "execname" then  return(execname).
   when "glentity" then  return(glentity).
   when "global-cursor-state" then  return(global-cursor-state).
   when "global-drill-value" then  return(global-drill-value).
   when "global-menuinfo" then  return(global-menuinfo).
   when "global_addr" then  return(global_addr).
   when "global_db" then  return(global_db).
   when "global_lang" then  return(global_lang).
   when "global_loc" then  return(global_loc).
   when "global_lot" then  return(global_lot).
   when "global_part" then  return(global_part).
   when "global_profile" then  return(global_profile).
   when "global_program_name" then  return(global_program_name).
   when "global_program_rev" then  return(global_program_rev).
   when "global_ref" then  return(global_ref).
   when "global_site" then  return(global_site).
   when "global_site_list" then  return(global_site_list).
   when "global_type" then  return(global_type).
   when "global_userid" then  return(global_userid).
   when "global_user_lang" then  return(global_user_lang).
   when "global_user_lang_dir" then  return(global_user_lang_dir).
   when "hi_char" then  return(hi_char).
   when "mfguser" then  return(mfguser).
   when "report_userid" then  return(report_userid).
   when "ststatus" then  return(ststatus).
   when "global_char" then return(global_char).
   otherwise
         run dispMessage (input 712, input pName).
 end.
END FUNCTION.

FUNCTION getDecimalValue RETURNS Decimal
 (input pName as character) :
/*------------------------------------------------------------------------------
Purpose:    Find a global Decimal variable and return its value.
Exceptions:
Parameters: pName - Name of the variable.
Conditions:
        Pre: Identifier must specify name of the variable.
        Post: Returns value for the variable.
Notes: public function
History:
----------------------------------------------------------------------------*/
 case pName:
   otherwise
         run dispMessage (input 712, input pName).
 end.
END FUNCTION.

FUNCTION getLogicalValue RETURNS Logical
 (input pName as character) :
/*------------------------------------------------------------------------------
Purpose:    Find a global Logical variable and return its value.
Exceptions:
Parameters: pName - Name of the variable.
Conditions:
        Pre: Identifier must specify name of the variable.
        Post: Returns value for the variable.
Notes: public function
History:
----------------------------------------------------------------------------*/
 case pName:
   when "batchrun" then  return(batchrun).
   when "flag-report-exit" then  return(flag-report-exit).
   when "global-drop-downs" then  return(global-drop-downs).
   when "global-hide-menus" then  return(global-hide-menus).
   when "global-menu-substitution" then  return(global-menu-substitution).
   when "global-nav-bar" then  return(global-nav-bar).
   when "global-save-settings" then  return(global-save-settings).
   when "global-tool-bar" then  return(global-tool-bar).
   when "global-beam-me-up" then  return(global-beam-me-up).
   when "global-do-menu-substitution" then
         return(global-do-menu-substitution).
   when "global_lngd_raw" then  return(global_lngd_raw).
   when "l-obj-in-use" then  return(l-obj-in-use).
   when "runok" then  return(runok).
   when "report-to-window" then  return(report-to-window).
   otherwise
         run dispMessage (input 712, input pName).
 end.
END FUNCTION.

FUNCTION getDateValue RETURNS Date
 (input pName as character) :
/*------------------------------------------------------------------------------
Purpose:    Find a global Date variable and return its value.
Exceptions:
Parameters: pName - Name of the variable.
Conditions:
        Pre: Identifier must specify name of the variable.
        Post: Returns value for the variable.
Notes: public function
History:
----------------------------------------------------------------------------*/
 case pName:
   when "hi_date" then  return(hi_date).
   when "low_date" then  return(low_date).
   otherwise
         run dispMessage (input 712, input pName).
 end.
END FUNCTION.

FUNCTION getHandleValue RETURNS Handle
 (input pName as character) :
/*------------------------------------------------------------------------------
Purpose:    Find a global Handle variable and return its value.
Exceptions:
Parameters: pName - Name of the variable.
Conditions:
        Pre: Identifier must specify name of the variable.
        Post: Returns value for the variable.
Notes: public function
History:
----------------------------------------------------------------------------*/
 case pName:
   when "button-report-cancel" then  return(button-report-cancel).
   when "frame-report-cancel" then  return(frame-report-cancel).
   when "global-drill-handle" then  return(global-drill-handle).
   when "global-drop-down-utilities" then return(global-drop-down-utilities).
   when "global-tool-bar-handle" then  return(global-tool-bar-handle).
   when "global_gblmgr_handle" then  return(global_gblmgr_handle).
   when "save-proc-window" then  return(save-proc-window).
   when "tools-hdl" then  return(tools-hdl).
   when "text-report-cancel" then  return(text-report-cancel).
   otherwise
         run dispMessage (input 712, input pName).
 end.
END FUNCTION.

FUNCTION getRecidValue RETURNS Recid
 (input pName as character) :
/*------------------------------------------------------------------------------
Purpose:    Find a global Recid variable and return its value.
Exceptions:
Parameters: pName - Name of the variable.
Conditions:
        Pre: Identifier must specify name of the variable.
        Post: Returns value for the variable.
Notes: public function
History:
----------------------------------------------------------------------------*/
 case pName:
   when "pt_recno" then  return(pt_recno).
   otherwise
         run dispMessage (input 712, input pName).
 end.
END FUNCTION.

FUNCTION getStline RETURNS Character
 (input pExtent as integer) :
/*------------------------------------------------------------------------------
Purpose:    Find a global stline variable's extent and return its value.
Exceptions:
Parameters: pExtent -  Extent variable.
Conditions:
        Pre: Identifier must specify the extent number of the variable.
        Post: Returns value for the variable.
Notes: public function
History:
----------------------------------------------------------------------------*/
   if pExtent < 1 or pExtent > extent(stline) then
      run dispMessage (input 4509, input "stline[" + string(pExtent) + "]").
   else
      return(stline[pExtent]).
END FUNCTION.

FUNCTION setIntegerValue returns logical
 (input pName as character, input pSetVal as integer) :
/*------------------------------------------------------------------------------
Purpose:    Find a global Integer variable and set its value.
Exceptions:
Parameters: pName   - Name of the variable.
            pSetVal - Value to be set.
Conditions:
        Pre: Identifier must specify name of the variable.
        Post: Set the value for the variable.
Notes: public function
History:
----------------------------------------------------------------------------*/
 case pName:
   when "global-screen-size" then  global-screen-size = pSetVal.
   when "global-window-size" then  global-window-size = pSetVal.
   when "global_user_lang_nbr" then  global_user_lang_nbr = pSetVal.
   when "maxpage" then  maxpage = pSetVal.
   when "printlength" then  printlength = pSetVal.
   when "trmsg" then  trmsg = pSetVal.
   when "window_down" then window_down = pSetVal.
   when "window_row" then  window_row  = pSetVal.
   otherwise
         run dispMessage (input 712, input pName).
 end.
END FUNCTION.

FUNCTION setCharacterValue returns logical
 (input pName as character, input pSetVal as character) :
/*------------------------------------------------------------------------------
Purpose:    Find a global Character variable and set its value.
Exceptions:
Parameters: pName   - Name of the variable.
            pSetVal - Value to be set.
Conditions:
        Pre: Identifier must specify name of the variable.
        Post: Set the value for the variable.
Notes: public function
History:
----------------------------------------------------------------------------*/
 case pName:
   when "base_curr" then  base_curr = pSetVal.
   when "bcdparm" then  bcdparm = pSetVal.
   when "c-application-mode" then  c-application-mode = pSetVal.
   when "current_entity" then  current_entity = pSetVal.
   when "dtitle" then  dtitle = pSetVal.
   when "execname" then  execname = pSetVal.
   when "glentity" then  glentity = pSetVal.
   when "global-cursor-state" then  global-cursor-state = pSetVal.
   when "global-drill-value" then  global-drill-value = pSetVal.
   when "global-menuinfo" then  global-menuinfo = pSetVal.
   when "global_addr" then  global_addr = pSetVal.
   when "global_db" then  global_db = pSetVal.
   when "global_lang" then  global_lang = pSetVal.
   when "global_loc" then  global_loc = pSetVal.
   when "global_lot" then  global_lot = pSetVal.
   when "global_part" then  global_part = pSetVal.
   when "global_profile" then  global_profile = pSetVal.
   when "global_program_name" then  global_program_name = pSetVal.
   when "global_program_rev" then  global_program_rev = pSetVal.
   when "global_ref" then  global_ref = pSetVal.
   when "global_site" then  global_site = pSetVal.
   when "global_site_list" then  global_site_list = pSetVal.
   when "global_type" then  global_type = pSetVal.
   when "global_userid" then  global_userid = pSetVal.
   when "global_user_lang" then  global_user_lang = pSetVal.
   when "global_user_lang_dir" then  global_user_lang_dir = pSetVal.
   when "hi_char" then  hi_char = pSetVal.
   when "mfquotec" then  mfquotec = pSetVal.
   when "report_userid" then  report_userid = pSetVal.
   when "ststatus" then  ststatus = pSetVal.
   when "global_char" then global_char = pSetVal.
   otherwise
         run dispMessage (input 712, input pName).
 end.
END FUNCTION.

FUNCTION setDecimalValue returns logical
 (input pName as character, input pSetVal as decimal) :
/*------------------------------------------------------------------------------
Purpose:    Find a global Decimal variable and set its value.
Exceptions:
Parameters: pName   - Name of the variable.
            pSetVal - Value to be set.
Conditions:
        Pre: Identifier must specify name of the variable.
        Post: Set the value for the variable.
Notes: public function
History:
----------------------------------------------------------------------------*/
 case pName:
   otherwise
         run dispMessage (input 712, input pName).
 end.
END FUNCTION.

FUNCTION setLogicalValue returns logical
 (input pName as character, input pSetVal as logical) :
/*------------------------------------------------------------------------------
Purpose:    Find a global Logical variable and set its value.
Exceptions:
Parameters: pName   - Name of the variable.
            pSetVal - Value to be set.
Conditions:
        Pre: Identifier must specify name of the variable.
        Post: Set the value for the variable.
Notes: public function
History:
----------------------------------------------------------------------------*/
 case pName:
   when "batchrun" then  batchrun = pSetVal.
   when "flag-report-exit" then  flag-report-exit = pSetVal.
   when "global-drop-downs" then  global-drop-downs = pSetVal.
   when "global-hide-menus" then  global-hide-menus = pSetVal.
   when "global-menu-substitution" then  global-menu-substitution = pSetVal.
   when "global-nav-bar" then  global-nav-bar = pSetVal.
   when "global-save-settings" then  global-save-settings = pSetVal.
   when "global-tool-bar" then  global-tool-bar = pSetVal.
   when "global-beam-me-up" then  global-beam-me-up = pSetVal.
   when "global-do-menu-substitution" then
        global-do-menu-substitution = pSetVal.
   when "global_lngd_raw" then  global_lngd_raw = pSetVal.
   when "l-obj-in-use" then  l-obj-in-use = pSetVal.
   when "runok" then  runok = pSetVal.
   when "report-to-window" then  report-to-window = pSetVal.
   otherwise
         run dispMessage (input 712, input pName).
 end.
END FUNCTION.

FUNCTION setDateValue returns logical
 (input pName as character, input pSetVal as Date) :
/*------------------------------------------------------------------------------
Purpose:    Find a global Date variable and set its value.
Exceptions:
Parameters: pName   - Name of the variable.
            pSetVal - Value to be set.
Conditions:
        Pre: Identifier must specify name of the variable.
        Post: Set the value for the variable.
Notes: public function
History:
----------------------------------------------------------------------------*/
 case pName:
   when "hi_date" then  hi_date = pSetVal.
   when "low_date" then  low_date = pSetVal.
   otherwise
         run dispMessage (input 712, input pName).
 end.
END FUNCTION.

FUNCTION setHandleValue returns logical
 (input pName as character, input pSetVal as Handle) :
/*------------------------------------------------------------------------------
Purpose:    Find a global Handle variable and set its value.
Exceptions:
Parameters: pName   - Name of the variable.
            pSetVal - Value to be set.
Conditions:
        Pre: Identifier must specify name of the variable.
        Post: Set the value for the variable.
Notes: public function
History:
----------------------------------------------------------------------------*/
 case pName:
   when "button-report-cancel" then  button-report-cancel = pSetVal.
   when "frame-report-cancel" then  frame-report-cancel = pSetVal.
   when "global-drill-handle" then  global-drill-handle = pSetVal.
   when "global-drop-down-utilities" then
        global-drop-down-utilities = pSetVal.
   when "global-tool-bar-handle" then  global-tool-bar-handle = pSetVal.
   when "global_gblmgr_handle" then  global_gblmgr_handle = pSetVal.
   when "save-proc-window" then  save-proc-window = pSetVal.
   when "tools-hdl" then  tools-hdl = pSetVal.
   when "text-report-cancel" then  text-report-cancel = pSetVal.
   otherwise
         run dispMessage (input 712, input pName).
 end.
END FUNCTION.

FUNCTION setRecidValue returns logical
 (input pName as character, input pSetVal as Recid) :
/*------------------------------------------------------------------------------
Purpose:    Find a global Recid variable and set its value.
Exceptions:
Parameters: pName   - Name of the variable.
            pSetVal - Value to be set.
Conditions:
        Pre: Identifier must specify name of the variable.
        Post: Set the value for the variable.
Notes: public function
History:
----------------------------------------------------------------------------*/
 case pName:
   when "pt_recno" then  pt_recno = pSetVal.
   otherwise
         run dispMessage (input 712, input pName).
 end.
END FUNCTION.

FUNCTION setStline returns logical
 (input pExtent as integer, input pSetVal as character) :
/*------------------------------------------------------------------------------
Purpose:    Find a global stline variable's extent and set its value.
Exceptions:
Parameters: pExtent -  Extent variable.
            pSetVal - Value to be set.
Conditions:
        Pre:  Identifier must specify the extent number of the variable.
        Post: Set the value of the variable.
Notes: public function
History:
----------------------------------------------------------------------------*/
   if pExtent < 1 or pExtent > extent(stline) then do:
      run dispMessage (input 4509, input "stline[" + string(pExtent) + "]").
   end.
   else
      stline[pExtent] = pSetVal.
END FUNCTION.

FUNCTION getTimezone returns character ():
/*------------------------------------------------------------------------------
Purpose:    Gets Timezone
Exceptions:
Parameters:
Conditions:
Notes:
History:
----------------------------------------------------------------------------*/
   for first qaddb_ctrl fields(qaddb_server_timezone)
      no-lock:

      return qaddb_ctrl.qaddb_server_timezone.
   end.
   return "".

END FUNCTION.

/*============================================================================*/
/* *************************  Internal Procedures  ************************** */
/*============================================================================*/

/*============================================================================*/
PROCEDURE setGlobalHandle:
/*------------------------------------------------------------------------------
 Purpose:    Set the value of a global handle.
 Exceptions:
 Notes: public procedure
</Comment/>
@Interface IGlobalManager
setGlobalHandle(
   String pGlobalID,
   Handle pValue)
   Assigns a value to a global handle.
Parameters
   pGlobalID - identifier for global value to assign value of
   pValue - value to assign
Pre Conditions
   Identifier must specify a global handle value.
Post Conditions
   Assigns value to global.
</Comment/>
 History:
----------------------------------------------------------------------------*/
   define input parameter pGlobalID as character no-undo.
   define input parameter pValue as handle no-undo.

   find first gbl_data
      where gbl_id = pGlobalID
      no-lock no-error.
   if not available gbl_data then
      create gbl_data.
   assign
      gbl_id = pGlobalID
      gbl_type = {&GBL_HANDLE}
      gbl_handle = pValue.

END PROCEDURE.

/*============================================================================*/
PROCEDURE dispMessage:
/*------------------------------------------------------------------------------
 Purpose:    Set the error message.
 Exceptions:
 Notes: public procedure
 Parameters
   pMsg    - message number for message text.
   pText   - Text to be appended at the end.
 History:
----------------------------------------------------------------------------*/
   define input parameter pMsg  as integer no-undo.
   define input parameter pText as character no-undo.

   {pxmsg.i &MSGNUM=pMsg &ERRORLEVEL=4 &MSGARG1=pText}
END PROCEDURE.

/*============================================================================*/
PROCEDURE getAuditConstants:
/*------------------------------------------------------------------------------
 Purpose:    Return constants used by Audit Trail
 Exceptions:
 Notes:      Used only by Audit Trail Triggers
 Parameters
   pUserID   - global user ID
   pUserName - global user name
   pExecName - execname
   pTimeZone - server timezone
 History:
----------------------------------------------------------------------------*/
   define output parameter pUserID   as character no-undo.
   define output parameter pUserName as character no-undo.
   define output parameter pExecName as character no-undo.
   define output parameter pTimeZone as character no-undo.

   assign
      pUserID   = global_userid
      pUserName = global_user_name
      pExecName = execname
      pTimeZone = getTimezone().
END PROCEDURE.
