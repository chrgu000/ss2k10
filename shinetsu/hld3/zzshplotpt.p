/* zzshplotpt.p ShipLot Number Comparision Sheet Print                      */
/* REVISION: 1.0  LAST MODIFIED: 03/15/2012   BY: Leo Zhou                  */

{ScheduleReportAPI.i} 
{ParameterConstants.i}
{APIErrorCodes.i}

{mfdeclre.i}

def input param v_print  as char.
def input param v_part   as char.
def input param v_period as char.
def input param v_int1   as int.
def input param v_int2   as int.

define variable ghSession as handle no-undo.
define variable ghService as handle no-undo.
define variable userIdentifier as character no-undo.
define variable userPassword as character no-undo.
define variable loginDomain as character no-undo.

/*Service interface include files*/
{excpmgpr.i super} 
{sectxtpr.i ghService} 
{dsexcptn.i}

FUNCTION  createEmailTemplateText returns character forward.

/*Initialize the service interface programs*/
run com/qad/qra/si/SessionManager.p persistent set ghSession.
run com/qad/shell/report/ScheduleReportAPIProxy.p persistent set ghService.

/*The service interface needs userid/password/domain information*/
FIND FIRST CODE_mstr NO-LOCK WHERE CODE_domain = GLOBAL_domain
    AND CODE_fldname = "ZZ_REPORT_API1" NO-ERROR .
assign
   userIdentifier = CODE_value      /*REPLACE WITH YOUR VALUE*/
   userPassword   = CODE_cmmt       /*REPLACE WITH YOUR VALUE*/
   loginDomain    = GLOBAL_domain . /*REPLACE WITH YOUR VALUE*/

run login.

/*This is the main code which creates the report input tables and schedules the reports*/
create ttScheduleReportAPI.

/*Mandatory settings, REPLACE WITH YOUR VALUES*/
FIND FIRST CODE_mstr NO-LOCK WHERE CODE_domain = GLOBAL_domain
    AND CODE_fldname = "ZZ_REPORT_API2" NO-ERROR .
assign
   ttScheduleReportAPI.batchID     = code_value 
   ttScheduleReportAPI.domain      = GLOBAL_domain
   ttScheduleReportAPI.entity      = code_cmmt
   ttScheduleReportAPI.rroCode     = "zz206". 

FIND FIRST usr_mstr NO-LOCK WHERE usr_userid = GLOBAL_userid NO-ERROR .
ttScheduleReportAPI.appLanguage = usr_lang .
IF usr_lang = "us" THEN ttScheduleReportAPI.isoLanguage = "en-US" .
ELSE IF usr_lang = "jp" THEN ttScheduleReportAPI.isoLanguage = "ja-JP" .
ELSE IF usr_lang = "ch" THEN ttScheduleReportAPI.isoLanguage = "zh-CN" . 

/*Optional settings. REPLACE WITH YOUR VALUES AND SEE ScheduleReportAPI.i FOR MORE SETTINGS*/
FIND FIRST CODE_mstr NO-LOCK WHERE CODE_domain = GLOBAL_domain
    AND CODE_fldname = "API_Printer" 
    AND CODE_value = v_print NO-ERROR .
assign
   ttScheduleReportAPI.runOnlyOnce = true
   ttScheduleReportAPI.printer     = code_cmmt .

/*
  Create some filter conditions, SEE ParameterConstants.i FOR OPERATOR CONSTANTS

  Note: To find the table/field names of the parameters: 
        - open the report in the "Report Resource Designer"
        - select the "Data" tab
        - expand the "Parameters" section
        - here will be a list of the valid parameters
        - hover over a parameter to see its full table and field name
          for example: "tt_so_mstr.so_nbr"

  Note: date values must be in the format YYYY-MM-DD
*/
run createParameter("qad_wkfl.qad_charfld[03]", v_part,{&PARAMETER_OPERATOR_EQUALS},"").
run createParameter("qad_wkfl.qad_charfld[10]", v_period,{&PARAMETER_OPERATOR_EQUALS},"").
run createParameter("qad_wkfl.qad_intfld[01]", v_int1,{&PARAMETER_OPERATOR_EQUALS},"").
run createParameter("qad_wkfl.qad_intfld[04]", v_int2,{&PARAMETER_OPERATOR_EQUALS},"").

run ScheduleReport.
run processOutput. /*This Procedure can be customized, see the definition of it below*/
run clearTempTables.

/*Cleanup*/
if valid-handle(ghService) then do:
   apply 'close' to ghService.
   delete procedure ghService no-error.
end.
if valid-handle(ghSession) then do:
   apply 'close' to ghSession.
   delete procedure ghSession no-error.
end.

/************************INTERNAL PROCEDURES AND FUNCTIONS*****************************/

/*This procedure can be modified to log or display errors as appropriate.
  and to return or log the scheduled report ID. The error codes
  returned via ttResponseAPI.errorCode can be found in APIErrorCodes.i*/
PROCEDURE processOutput:
   /*These are the errors from the service interface layer.*/
   run getUnhandledExceptions(output dataset dsExceptions).
   for each temp_err_msg no-lock:
      message tt_msg_desc " (" + tt_msg_nbr + ")".
   end.

   /*These are the errors/info from the scheduling itself.
     See APIErrorCodes.i for error codes.*/
   for first ttResponseAPI no-lock:
      if ttResponseAPI.success = false then 
         message "error code =" ttResponseAPI.errorCode.
      else 
         message "Scheduled Report ID=" ttResponseAPI.scheduledReportId.
   end.
END PROCEDURE.


/*Sample function to create email template text that will
  override the default template.*/
FUNCTION createEmailTemplateText returns character():
   define variable templateText as character no-undo.

   /*Remove the comments on the block below and
     modify the text to suit your own needs.*/

   /********************************
   templateText =
      "[SUBJECT]"                                                          + chr(13) +
      "Scheduled Report Completed: ~{$RRO_DESC~}"                          + chr(13) +
      "[BODY]"                                                             + chr(13) +
      "A scheduled report from QAD Enterprise Applications has completed:" + chr(13) +
      "        Report: ~{$RRO_DESC~} (~{$RRO_CODE~})"                      + chr(13) + 
      "   Description: ~{$SR_DESC~}"                                       + chr(13) +
      "Link to Report: ~{$REP ORT_FILE_LINK~}"                             + chr(13) + chr(13) + chr(13).
   *********************************/

   return templateText.
END FUNCTION.



/***********NO NEED TO MODIFY THE PROCEDURES BELOW THIS LINE*************************/

/*Sets the login parameters to the service interface layer*/
PROCEDURE login:
   run setQADContextProperty in ghService (input "username",input userIdentifier).
   run setQADContextProperty in ghService (input "password",input userPassword).
   run setQADContextProperty in ghService (input "domain"  ,input loginDomain).
END PROCEDURE. 


/*Call the scheduling logic.  Only one ttScheduleReportAPI per call.*/           
PROCEDURE ScheduleReport:
   define variable sid as character no-undo.

   run setQADContextProperty in ghService (input "domain",input loginDomain).

   do on error undo, leave:
      run ScheduleReport in ghService 
      (
         input dataset dsScheduleReportAPIRequest,
         output dataset dsScheduleReportAPIResponse
      ).
   end.
END PROCEDURE.


/*Creates a parameter to send on the API call*/
PROCEDURE createParameter:
   define input parameter pParamName as character no-undo.
   define input parameter pParamValue as character no-undo.
   define input parameter pOperator as character no-undo.
   define input parameter pParamValue2 as character no-undo.

   create ttParameterAPI.
   assign
      ttParameterAPI.name            = pParamName
      ttParameterAPI.operator        = pOperator  
      ttParameterAPI.paramValue      = pParamValue
      ttParameterAPI.valueType       = {&PARAMETER_VALUETYPE_CONSTANT}
      ttParameterAPI.secondValue     = pParamValue2
      ttParameterAPI.secondValueType = {&PARAMETER_VALUETYPE_CONSTANT}.

END PROCEDURE. 


/*Deletes all records of the temp tables*/
PROCEDURE clearTempTables:
   for each ttScheduleReportAPI exclusive-lock:
      delete ttScheduleReportAPI.
   end.

   for each ttParameterAPI exclusive-lock:
      delete ttParameterAPI.
   end.

   for each temp_err_msg exclusive-lock:
      delete temp_err_msg.
   end.

   for each ttResponseAPI exclusive-lock:
      delete ttResponseAPI.
   end.

   run clearExceptions.
END PROCEDURE.
