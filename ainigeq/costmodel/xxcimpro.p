/* No convert xxcimpro.p (converter v1.60) Fri Apr 28 15:18:42 1995          */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.29 $                                                         */
/*
 * File: mgbdpro.p
 *
 * Description: Process CIM batch data that has been loaded into the database
 *
 * Primary Table: None
 *
 * Input Parms: None
 *
 * Output Parms: None
 *
    Last change:  KPO  15 May 2000    2:53 am
 ************************************************************************/
/*V8:ConvertMode=Report                                                 */
/******************************** History ********************************
/* REVISION: 5.0      LAST MODIFIED:  05/30/90  BY: WUG                      */
/* REVISION: 6.0      LAST MODIFIED:  06/19/91  BY: WUG  *D713*              */
/* REVISION: 6.0      LAST MODIFIED:  10/09/91  BY: WUG  *7.0*               */
/* REVISION: 7.0      LAST MODIFIED:  03/27/92  BY: WUG  *F327*              */
/* REVISION: 7.0      LAST MODIFIED:  04/10/92  BY: dgh  *F717*              */
/* REVISION: 7.3      LAST MODIFIED:  10/07/92  BY: WUG  *G132*              */
/* REVISION: 7.3      LAST MODIFIED:  10/09/92  BY: jzs  *G165*              */
/* REVISION: 7.3      LAST MODIFIED:  11/09/92  BY: rwl  *G297*              */
/* REVISION: 7.3      LAST MODIFIED:  03/26/93  BY: jzs  *G877*              */
/* REVISION: 7.3      LAST MODIFIED:  05/11/93  BY: jzs  *GA22*              */
/* REVISION: 7.3      LAST MODIFIED:  10/20/93  BY: jzs  *GG47*              */
/* REVISION: 7.3      LAST MODIFIED:  09/15/94  BY: ljm  *GM66*              */
/* REVISION: 7.3      LAST MODIFIED:  10/20/94  BY: rmh  *FS61*              */
/* REVISION: 7.3      LAST MODIFIED:  11/06/94  BY: rmh  *FS47*              */
/* REVISION: 7.3      LAST MODIFIED:  12/06/94  BY: rmh  *FU36*              */
/* REVISION: 7.3      LAST MODIFIED:  03/20/95  BY: aed  *G0HT*              */
/* REVISION: 7.3      LAST MODIFIED:  03/31/95  BY: jzs  *G0FB*              */
/* REVISION: 8.5      LAST MODIFIED:  08/20/95  BY: bkw  *J09J*              */
/* REVISION: 7.3      LAST MODIFIED:  01/05/95  BY: qzl  *G1J4*              */
/* REVISION: 8.5      LAST MODIFIED:  03/13/96  BY: bkw  *J0FF*              */
/* REVISION: 8.5      LAST MODIFIED:  03/18/96  BY: bkw  *J0FT*              */
/* REVISION: 8.5      LAST MODIFIED:  06/25/96  BY: bkw  *J0W6*              */
/* REVISION: 8.5      LAST MODIFIED:  08/15/96  BY: bkw  *J13D*              */
/* REVISION: 8.5      LAST MODIFIED:  10/09/96  BY: taf  *G2GW*              */
/* REVISION: 8.5      LAST MODIFIED:  01/24/97  BY: *G2K1* Tamra MacInnis    */
/* REVISION: 8.5      LAST MODIFIED:  04/18/97  BY: *J171* Brian Wintz       */
/* REVISION: 8.6E     LAST MODIFIED:  02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED:  05/05/98  BY: *J2M0* Raphael T         */
/* REVISION: 8.6E     LAST MODIFIED:  05/20/98  BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED:  10/04/98  BY: *J314* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED:  10/13/98  BY: *J324* Raphael T         */
/* REVISION: 9.0      LAST MODIFIED:  03/10/99  BY: *M0B8* Hemanth Ebenezer  */
/* REVISION: 9.0      LAST MODIFIED:  03/13/99  BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED:  06/28/99  BY: *N00M* J. Fernando       */
/* REVISION: 9.1      LAST MODIFIED:  07/28/99  BY: *N018* J. Fernando       */
/* REVISION: 9.1      LAST MODIFIED:  11/08/99  BY: *N03C* Kieran O Dea      */
/* REVISION: 9.1      LAST MODIFIED:  01/25/00  BY: *J3NW* Raphael T         */
/* REVISION: 9.1      LAST MODIFIED:  03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED:  05/04/00   BY: *N09S* Kieran O Dea     */
/* REVISION: 9.1      LAST MODIFIED:  08/13/00   BY: *N0KR* myb              */
/* REVISION: 9.1      LAST MODIFIED:  07/23/01   BY: *N10B* Hualin Zhong     */
/* Revision: 1.24     BY: Hualin Zhong   DATE: 08/10/01  ECO: *N10B*         */
/* Revision: 1.25     BY: Dipesh Bector  DATE: 09/23/02  ECO: *N1VH*         */
/* $Revision: 1.29 $  BY: Manish Dani    DATE: 04/25/03  ECO: *N2DP*         */
/******************************** Tokens ********************************/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

 ************************************************************************/

/*zy*/ /*{mfdtitle.i "2+ "}*/
/*zy*/ {mfdeclre.i}

/******* 这是CIM_LOAD程序在WIN。及CHAEACTER上均已测过  *******/
/******* convert from eb2sp8 character version         *******/
/************测试代码***********************************/
/* {mfdeclre.i "new global"}                           */
/* {mf1.i "new global"}                                */
/*                                                     */
/* hi_date = DATE(12,31,3999).                         */
/* low_date = DATE(1,1,1900).                          */
/* hi_char  = CHR(255).                                */
/*                                                     */
/* global_userid = "MFG".                              */
/* global_user_lang_dir = "ch/".                       */
/* global_user_name = "MFG".                           */
/*                                                     */
/*                                                     */
/* DEFINE VARIABLE fname AS CHARACTER NO-UNDO.         */
/* DEFINE VARIABLE messg as CHARACTER NO-UNDO.         */
/* ASSIGN fname= "d:\ssqad\init.cim".                  */
/* /* message fname view-as alert-box.  */             */
/* {gprun.i ""xxcimpro"" "(INPUT fname,output messg)"} */
/* message messg view-as alert-box.                    */
/* quit.                                               */
/*                                                     */

define input  parameter file_name as character no-undo.
define output parameter error_msg as character no-undo.
/* define variable file_name as character format "x(20)"        */
/*        label "Input File Name" INITIAL ".\init.cim".         */
/* define variable repeat_process like mfc_logical        */
/*    label "Repeat Processing"  initial no.              */
/* define variable pause_seconds as integer               */
/*    label "Pause Seconds Before Repeat" format ">>>>9"  */
/*    initial 300.                                        */

define variable linefield as character extent 40 format "x(80)".
define variable linedata as character.
define variable linedata2 as character.
/* define stream errorlog.  */
define variable writing_function_data like mfc_logical.
define variable i as integer.
define variable j as integer.
define variable group_count as integer.
define variable progress_errors as integer.
define variable function_warnings as integer.
define variable function_errors as integer.
define variable group_progress_errors as integer.
define variable group_function_errors as integer.
define variable from_id like bdl_id initial 0.
define variable to_id like bdl_id initial 99999999.
define variable last_id like bdl_id.
define variable lastexecname as character.
define variable current_bdl_source like bdl_source.
define variable current_bdl_id like bdl_id.
define variable first_shot  like mfc_logical.
define variable session_no  as character.
define variable start_date  as date.
define variable start_time  as character.
define variable work_i_file as character.
define variable work_o_file as character.

define variable go_on like mfc_logical initial yes.

define variable save-sys-alert as logical.
define variable save-app-alert as logical.
define variable lastbatchrun like batchrun.

define variable err_out_file  as character initial "" no-undo.
define variable suc_out_file  as character initial "" no-undo.
define variable template_file as character initial "" no-undo.
define temp-table template-table
   field exec-name as character
   field group-name as character
   field field-name as character
   field field-value as character
   index template-index is unique primary exec-name group-name field-name.
define stream temp_load.
define stream copy_file.
define variable row_count as integer no-undo.
define variable old_row_count as integer no-undo.
define variable finished as logical no-undo.
define variable new_file as logical no-undo.

define variable process_file as logical INITIAL YES.
define stream cim_load.
define variable bdl_recno as recid no-undo.

define variable terminate_msg as character no-undo.
define variable procedure_err as character no-undo.
define variable process_err as character no-undo.
define variable switching_msg as character no-undo.

define variable w-end-seek       as integer    no-undo.
define variable w-interim-seek   as integer    no-undo.
define variable w-batchload-seek as integer    no-undo.
DEFINE VARIABLE vkey1 AS CHARACTER INITIAL "Cim_Process_Session".
/*zy*//* /* Cim PROCESS SESSION TERMINATED DUE TO LOSS OF SESSION RECORD */  */
/*zy*//* {pxmsg.i &MSGNUM=4686 &ERRORLEVEL=1 &MSGBUFFER=terminate_msg}       */
/*zy*//*                                                                     */
/*zy*//* /* PROCEDURE DOES NOT EXIST */                                      */
/*zy*//* {pxmsg.i &MSGNUM=1553 &ERRORLEVEL=4 &MSGBUFFER=procedure_err}       */
/*zy*//*                                                                     */
/*zy*//* /* INVALID PROCESS TYPE */                                          */
/*zy*//* c{pxmsg.i &MSGNUM=4775 &ERRORLEVEL=4 &MSGBUFFER=process_err}        */
/*zy*//*                                                                     */
/*zy*//* /* SWITCHING TO NEW LOAD PROCEDURE */                               */
/*zy*//* {pxmsg.i &MSGNUM=4776 &ERRORLEVEL=2 &MSGBUFFER=switching_msg}       */

assign
   terminate_msg = substring(terminate_msg,1,length(terminate_msg) - 1)
                 + " "
   procedure_err = substring(procedure_err,1,length(procedure_err) - 1)
                 + " ->"
   process_err = substring(process_err,1,length(process_err) - 1)
                 + " ->"
   switching_msg = substring(switching_msg,1,length(switching_msg) - 1)
                 + " : "
   lastbatchrun = batchrun
   start_date = today
   start_time = string(time, "HH:MM:SS").

/* Retrieve the next CIM process session number */
do on error undo, return error:
   run get_CIM_session (output session_no).
end.

/* Set up input and output streams */
assign
   work_i_file = STRING(TODAY,"99999999") + "-" + STRING(TIME) + ".bpi"
   work_o_file = STRING(TODAY,"99999999") + "-" + STRING(TIME) + ".bpo".

/*zy*/ /* SELECT FORM */
/*zy*/
/*zy*/ /* form                                               */
/*zy*/ /*    skip(1)                                         */
/*zy*/ /*    from_id               colon 30                  */
/*zy*/ /*    to_id       00        label {t1.i}              */
/*zy*/ /*    skip(1)                                         */
/*zy*/ /*    repeat_proce vss      colon 35iew-as toggle-box */
/*zy*/ /*    skip(1)                                         */
/*zy*/ /*    pause_second  s       colon 35                  */
/*zy*/ /*    skip(1)                                         */
/*zy*/ /*    process_file        colon 35 view-as toggle-box */
/*zy*/ /*    skip(1)                                         */
/*zy*/ /*    file_name           colon 35                    */
/*zy*/ /*    skip(1)                                         */
/*zy*/ /* with frame a side-labels width 80 attr-space.      */
/*zy*/ /*                                                    */
/*zy*/ /* /* SET EXTERNAL LABELS */                          */
/*zy*/ /* setFrameLabels(frame a:handle).                    */


mainloop:
repeat:

   /*V8! hide all no-pause.
   if global-tool-bar and global-tool-bar-handle <> ? then
      view global-tool-bar-handle.
   view frame a.
   input from terminal.*/

/*    update                     */
/*       from_id                 */
/*       to_id                   */
/*       repeat_process          */
/*       pause_seconds           */
/*       process_file            */
/*       file_name with frame a. */

   assign
      w-end-seek       = 0
      w-interim-seek   = 0
      w-batchload-seek = 0
      group_count      = 0.

/*    output stream errorlog close.           */
/*    OUTPUT STREAM errorlog TO "cimlog.log". */
   /* CALL GENERIC OUTPUT DESTINATION SELECTION INCLUDE.
    * OUTPUT DESTINATIONS OF TYPE Email AND Winprint (Windows Printer)
    * ARE NOT ALLOWED*/

/*zy*/ /*    {gpselout.i                        */
/*zy*/ /*       &printType = "printer"          */
/*zy*/ /*       &printWidth = 132               */
/*zy*/ /*       &pagedFlag = "page"             */
/*zy*/ /*       &stream = "stream errorlog"     */
/*zy*/ /*       &appendToFile = "append"        */
/*zy*/ /*       &streamedOutputToTerminal = " " */
/*zy*/ /*       &withBatchOption = "no"         */
/*zy*/ /*       &displayStatementType = 1       */
/*zy*/ /*       &withCancelMessage = "yes"      */
/*zy*/ /*       &pageBottomMargin = 6           */
/*zy*/ /*       &withEmail = "no"               */
/*zy*/ /*       &withWinprint = "no"            */
/*zy*/ /*       &defineVariables = "yes"}       */

   row_count = 0.

   if process_file then do:
      run setup_input(input  file_name,
                      output execname,
                      output new_file).

/*       put stream errorlog                                                   */
/*          skip(1)                                                            */
/* /*zy* /         {gplblfmt.i                                                 */
/* / *zy* /            '&FUNC=getTermLabel(""BATCH_DATA_LOAD_STARTING"",32)}'  */
/* / *zy*/     "BATCH_DATA_LOAD_STRING"                                        */
/*          space(1)                                                           */
/*          today                                                              */
/*          space(1)                                                           */
/*          string(time,"HH:MM:SS") format "x(8)"                              */
/*          skip.                                                              */

/*zy*//*       if new_file then DO:                            */
/*zy*//*           run process_by_screen.                      */
/*zy*//*       END.                                            */
/*zy*//*                                                       */
/*zy*//*       /* FIND THE OFFSET VALUE OF END OF FILE AND */  */
/*zy*//*       /* CALL INTERNAL PROCEDURE process_all TILL */  */
/*zy*//*       /* THE END OF FILE                          */  */
/*zy*//*                                                       */
/*zy*//*       else do:                                        */
/*zy*//*                                                       */
         input stream cim_load from value(file_name).
         seek stream cim_load to end.
         w-end-seek = seek(cim_load).
         input stream cim_load close.

         do while w-interim-seek < w-end-seek:
            run process_all no-error.
            if error-status:error
            then
               leave.
            group_count =  group_count + 1.
         end.  /* DO WHILE w-interim-seek < w-end-seek */

/*zy*//*       end.  /* ELSE DO */  */
      os-delete value(work_i_file).
      os-delete value(work_o_file).

      if not go_on then
         function_errors = function_errors + 1.

/*       put stream errorlog                                                   */
/*          skip(1)                                                            */
/* /*zy* /         '{gplblfmt.i'                                               */
/* / *zy* /           ' &FUNC=getTermLabel(""BATCH_DATA_LOAD_COMPLETE"",32)} ' */
/* / *zy*/                                                                     */
/*          space(1)                                                           */
/*          today space(1)                                                     */
/*          string(time,"HH:MM:SS") skip.                                      */
/*       put stream errorlog unformatted                                       */
/* /*          getTermLabel("GROUPS_PROCESSED",21) */                          */
/*           space(1) group_count                                              */
/*          space(2)                                                           */
/* /*          getTermLabel("DATABASE_ERRORS",20)  */                          */
/*           space(1) progress_errors                                          */
/*          space(2)                                                           */
/* /*          getTermLabel("PROGRAM_WARNINGS",21) */                          */
/*           space(1) function_warnings                                        */
/*          space(2)                                                           */
/* /*          getTermLabel("PROGRAM_ERRORS",19)  */                           */
/*           space(1) function_errors                                          */
/*          skip(1).                                                           */
 /*       next mainloop.  */
     LEAVE.
    end.
/*zy*//*                                                                             */
/*zy*//*    do transaction on error undo, return error:                              */
/*zy*//*       run check_CIM(input session_no,                                       */
/*zy*//*                     input from_id,                                          */
/*zy*//*                     input to_id,                                            */
/*zy*//*                     input repeat_process,                                   */
/*zy*//*                     input pause_seconds,                                    */
/*zy*//*                     input start_date,                                       */
/*zy*//*                     input start_time,                                       */
/*zy*//*                     input false).                                           */
/*zy*//*    end.                                                                     */
/*zy*//*    /* Set to first so no-find run doesn't set it from given */              */
/*zy*//*    /* 1st number to 0. */                                                   */
/*zy*//*    assign                                                                   */
/*zy*//*       last_id = from_id                                                     */
/*zy*//*       bcdparm = "".                                                         */
/*zy*//*                                                                             */
/*zy*//* /*zy*//*    {mfquoter.i from_id}        */                                  */
/*zy*//* /*zy*//*    {mfquoter.i to_id}          */                                  */
/*zy*//* /*zy*//*    {mfquoter.i repeat_process} */                                  */
/*zy*//* /*zy*//*    {mfquoter.i pause_seconds}  */                                  */
/*zy*//*                                                                             */
/*zy*//*    repeat:                                                                  */
/*zy*//*       assign                                                                */
/*zy*//*          group_count = 0                                                    */
/*zy*//*          writing_function_data = no.                                        */
/*zy*//*                                                                             */
/*zy*//*       put stream errorlog skip(1)                                           */
/*zy*//* /*zy* /         '{gplblfmt.i'                                               */
/*zy*//* / *zy* /           ' &FUNC=getTermLabel(""BATCH_DATA_LOAD_STARTING"",32)} ' */
/*zy*//* / *zy*/                                                                     */
/*zy*//*          space(1)                                                           */
/*zy*//*          today space(1)                                                     */
/*zy*//*          string(time,"HH:MM:SS")                                            */
/*zy*//*          format "x(8)" skip.                                                */
/*zy*//*                                                                             */
/*zy*//*       first_shot = yes.                                                     */
/*zy*//*                                                                             */
/*zy*//*       find_bdl:                                                             */
/*zy*//*       repeat:                                                               */
/*zy*//*          do transaction on error undo, leave mainloop:                      */
/*zy*//*             run check_CIM(input session_no,                                 */
/*zy*//*                           input from_id,                                    */
/*zy*//*                           input to_id,                                      */
/*zy*//*                           input repeat_process,                             */
/*zy*//*                           input pause_seconds,                              */
/*zy*//*                           input start_date,                                 */
/*zy*//*                           input start_time,                                 */
/*zy*//*                           input true).                                      */
/*zy*//*                                                                             */
/*zy*//*             looptdo:                                                        */
/*zy*//*             repeat:                                                         */
/*zy*//*                /* Retrieve batch data load master record (bdl_mstr) */      */
/*zy*//*                if first_shot then                                           */
/*zy*//*                   find first bdl_mstr no-lock where bdl_source = ""         */
/*zy*//*                      and bdl_id >= from_id and bdl_id <= to_id              */
/*zy*//*                      no-error no-wait.                                      */
/*zy*//*                else                                                         */
/*zy*//*                   find next bdl_mstr no-lock where bdl_source = ""          */
/*zy*//*                      and bdl_id >= from_id and bdl_id <= to_id              */
/*zy*//*                      no-error no-wait.                                      */
/*zy*//*                                                                             */
/*zy*//*                first_shot = no.                                             */
/*zy*//*                                                                             */
/*zy*//*                if not available bdl_mstr then                               */
/*zy*//*                   leave find_bdl.                                           */
/*zy*//*                                                                             */
/*zy*//*                if bdl_date_pro <> ? then                                    */
/*zy*//*                   next looptdo.                                             */
/*zy*//*                bdl_recno = recid(bdl_mstr).                                 */
/*zy*//*                find bdl_mstr where recid(bdl_mstr) = bdl_recno              */
/*zy*//*                   exclusive-lock no-error no-wait.                          */
/*zy*//*                if locked bdl_mstr then                                      */
/*zy*//*                   next looptdo.                                             */
/*zy*//*                if bdl_date_pro = ? then                                     */
/*zy*//*                   leave looptdo.                                            */
/*zy*//*                next looptdo.                                                */
/*zy*//*             end.                                                            */
/*zy*//*                                                                             */
/*zy*//*             /* Set processing date and time to now */                       */
/*zy*//*             assign                                                          */
/*zy*//*                bdl_date_pro = today                                         */
/*zy*//*                bdl_time_pro = string(time,"HH:MM:SS")                       */
/*zy*//*                current_bdl_source = bdl_source                              */
/*zy*//*                current_bdl_id = bdl_id                                      */
/*zy*//*                lastexecname = execname                                      */
/*zy*//*                execname = bdl_exec.                                         */
/*zy*//*             release bdl_mstr.                                               */
/*zy*//*          end.                                                               */
/*zy*//*                                                                             */
/*zy*//*          find first bdld_det no-lock                                        */
/*zy*//*             where bdld_source = current_bdl_source and                      */
/*zy*//*             bdld_id = current_bdl_id and                                    */
/*zy*//*             (bdld_data begins "@ACTION") no-error.                          */
/*zy*//*          group_count = group_count + 1.                                     */
/*zy*//*          if available bdld_det then                                         */
/*zy*//*             run process_by_screen.                                          */
/*zy*//*          else                                                               */
/*zy*//*             run process_all.                                                */
/*zy*//*                                                                             */
/*zy*//*          do transaction:                                                    */
/*zy*//*             find bdl_mstr exclusive-lock where                              */
/*zy*//*                bdl_source = current_bdl_source                              */
/*zy*//*                and bdl_id = current_bdl_id.                                 */
/*zy*//*                                                                             */
/*zy*//*             assign                                                          */
/*zy*//*                bdl_pgm_errs = group_function_errors                         */
/*zy*//*                bdl_pro_errs = group_progress_errors.                        */
/*zy*//*                                                                             */
/*zy*//*             if not go_on then do:                                           */
/*zy*//*                assign                                                       */
/*zy*//*                   bdl_pgm_errs = 1                                          */
/*zy*//*                   function_errors = function_errors + 1.                    */
/*zy*//*             end.                                                            */
/*zy*//*                                                                             */
/*zy*//*             last_id = bdl_id.                                               */
/*zy*//*          end.                                                               */
/*zy*//*       end.                                                                  */
/*zy*//*                                                                             */
/*zy*//*       put stream errorlog skip(1)                                           */
/*zy*//* /*zy* /         '{gplblfmt.i'                                               */
/*zy*//* / *zy* /            '&FUNC=getTermLabel(""BATCH_DATA_LOAD_COMPLETE"",32)}'  */
/*zy*//* / *zy*/                                                                     */
/*zy*//*          space(1)                                                           */
/*zy*//*          today space(1)                                                     */
/*zy*//*          string(time,"HH:MM:SS") skip.                                      */
/*zy*//*       put stream errorlog unformatted                                       */
/*zy*//*          'getTermLabel("GROUPS_PROCESSED",21)' space(1) group_count         */
/*zy*//*          space(2)                                                           */
/*zy*//*          'getTermLabel("DATABASE_ERRORS",20)' space(1) progress_errors      */
/*zy*//*          space(2)                                                           */
/*zy*//*          'getTermLabel("PROGRAM_WARNINGS",21)' space(1) function_warnings   */
/*zy*//*          space(2)                                                           */
/*zy*//*         'getTermLabel("PROGRAM_ERRORS",19)' space(1) function_errors        */
/*zy*//*          skip(1).                                                           */
/*zy*//*                                                                             */
/*zy*//*       /* Remove the temporary input and output files */                     */
/*zy*//*       OUTPUT STREAM errorlog CLOSE.                                         */
/*zy*//*       os-delete value(work_i_file).                                         */
/*zy*//*       os-delete value(work_o_file).                                         */
/*zy*//*                                                                             */
/*zy*//* /*       {mfrtrail.i "stream errorlog"}  */                                 */
/*zy*//*                                                                             */
/*zy*//* /*       if not repeat_process then  */                                     */
/*zy*//*          leave.                                                             */
/*zy*//* /*       pause pause_seconds.  */                                           */
/*zy*//*     OUTPUT STREAM errorlog CLOSE.                                           */
/*zy*//* /*       {mfselp01.i printer 132 page "stream errorlog" append}  */         */
/*zy*//*       from_id = last_id. /* DONT RE-READ WHAT WE ALREADY LOOKED AT */       */
/*zy*//*    end.                                                                     */
/*zy*//*                                                                             */
end.

do transaction:
   find qad_wkfl exclusive-lock where qad_key1 = vkey1 and
      qad_key2 = session_no no-error.

   if available qad_wkfl then do:
      delete qad_wkfl.
   end.
end.

/**********************************************************************
 * Purpose:
 * Handles CIM processing for new, object-orientated screens.
 * Parmeters:
 * None, but uses the following file global variables:
 * function_errrors:  number of program errors encountered
 * function_warnings:  number of program warnings encountered
 * process_file:  logical value of whether to process file directly
 * file_name:  name of flat file to process directly
 * execname: name of screen to be executed
 * errorlog: stream where processing results are stored
 * work_o_file: name of temporary output file
 * work_i_file: name of temporary input file
 * Also uses the following temporary table:
 * template-table
 * exec-name:  name of executable file
 * group-name:  name of group
 * field-name:  name of field within group
 * field-value: value for field, group, executable combination
 * Notes:
 *********************************************************************/
/*zy*//* PROCEDURE process_by_screen:                                                      */
/*zy*//*    define variable current_line as integer initial 0 no-undo.                     */
/*zy*//*    define variable last_line as integer initial 0 no-undo.                        */
/*zy*//*    define variable temp_line as integer no-undo.                                  */
/*zy*//*    define variable linedata as character no-undo.                                 */
/*zy*//*    define variable templine as character no-undo.                                 */
/*zy*//*    define variable first_load as logical no-undo.                                 */
/*zy*//*    define variable wrote_line as logical no-undo.                                 */
/*zy*//*    define variable temp_load_exec as character initial "" no-undo.                */
/*zy*//*    define variable grp_name as character no-undo.                                 */
/*zy*//*    define variable fld_name as character no-undo.                                 */
/*zy*//*    define variable h_screen as handle no-undo.                                    */
/*zy*//*    define variable c_loadproc as character initial "" no-undo.                    */
/*zy*//*    define variable c_process_type as character no-undo.                           */
/*zy*//*    define variable c-group as character no-undo.                                  */
/*zy*//*    define variable c-field as character no-undo.                                  */
/*zy*//*    define variable c-value as character no-undo.                                  */
/*zy*//*    define variable c-temp as character no-undo.                                   */
/*zy*//*    define variable c_msg as character no-undo.                                    */
/*zy*//*    define variable c_err_count as integer no-undo.                                */
/*zy*//*    define variable c_warn_count as integer no-undo.                               */
/*zy*//*    define variable first_time as logical initial true no-undo.                    */
/*zy*//*    define variable save_appl_boxes as logical  no-undo.                           */
/*zy*//*    define variable save_sys_boxes as logical no-undo.                             */
/*zy*//*    define variable error_value as character initial "" no-undo.                   */
/*zy*//*                                                                                   */
/*zy*//*    if process_file then                                                           */
/*zy*//*       input stream cim_load from value(file_name).                                */
/*zy*//*    assign                                                                         */
/*zy*//*       lastbatchrun=batchrun                                                       */
/*zy*//*       batchrun=true                                                               */
/*zy*//*       save_appl_boxes=session:appl-alert-boxes                                    */
/*zy*//*       save_sys_boxes=session:system-alert-boxes                                   */
/*zy*//*       session:appl-alert-boxes=false                                              */
/*zy*//*       session:system-alert-boxes=false.                                           */
/*zy*//*                                                                                   */
/*zy*//*    new_pgm_loop:                                                                  */
/*zy*//*    repeat:                                                                        */
/*zy*//*       /* Determine if program actually exists... */                               */
/*zy*//*       {gprun.i ""mgbdpro1.p"" "(input execname, output go_on)"}.                  */
/*zy*//*       /*... if so then execute persistently and perform setup ... */              */
/*zy*//*       if go_on then do:                                                           */
/*zy*//*          pause 0 .                                                                */
/*zy*//*          if valid-handle(h_screen) then                                           */
/*zy*//*             apply "CLOSE" to h_screen.                                            */
/*zy*//*          do on error undo, leave on endkey undo, leave:                           */
/*zy*//*             {gprun.i execname "PERSISTENT SET h_screen"}                          */
/*zy*//*                                                                                   */
/*zy*//*             run q-startup in h_screen.                                            */
/*zy*//*             run q-initialize in h_screen.                                         */
/*zy*//*          end.                                                                     */
/*zy*//*       end.                                                                        */
/*zy*//*                                                                                   */
/*zy*//*       /*... otherwise, send error to log and leave procedure with error */        */
/*zy*//*       else do:                                                                    */
/*zy*//*          if not process_file then                                                 */
/*zy*//*             put stream errorlog unformatted                                       */
/*zy*//*                'getTermLabel("GROUP_ID",11)' + ":"                                */
/*zy*//*                space                                                              */
/*zy*//*                current_bdl_id                                                     */
/*zy*//*                space.                                                             */
/*zy*//*          else                                                                     */
/*zy*//*          put stream errorlog unformatted                                          */
/*zy*//*             'getTermLabel("INPUT_FILE_NAME",20)'                                  */
/*zy*//*             space                                                                 */
/*zy*//*             file_name                                                             */
/*zy*//*             space.                                                                */
/*zy*//*                                                                                   */
/*zy*//*          put stream errorlog unformatted                                          */
/*zy*//*             procedure_err                                                         */
/*zy*//*             execname                                                              */
/*zy*//*             skip(1).                                                              */
/*zy*//*          error_value = "ERROR".                                                   */
/*zy*//*          leave new_pgm_loop.                                                      */
/*zy*//*       end.                                                                        */
/*zy*//*                                                                                   */
/*zy*//*       /* Process each screen individually */                                      */
/*zy*//*       screen_break:                                                               */
/*zy*//*       repeat:                                                                     */
/*zy*//*          /* Setup streams for CIM load file (work_o_file) and */                  */
/*zy*//*          /* PROGRESS errors (work_i_file) */                                      */
/*zy*//*          output stream copy_file to value(work_o_file).                           */
/*zy*//*          output to value(work_i_file) keep-messages.                              */
/*zy*//*          /* Process each line of data */                                          */
/*zy*//*          field_process:                                                           */
/*zy*//*          repeat:                                                                  */
/*zy*//*             /* If inputting from a file then read in line of data ...*/           */
/*zy*//*             if process_file then do:                                              */
/*zy*//*                linedata="".                                                       */
/*zy*//*                readkey stream cim_load.                                           */
/*zy*//*                do while lastkey <> keycode("RETURN") and lastkey >=0:             */
/*zy*//*                   linedata = linedata + chr(lastkey).                             */
/*zy*//*                   readkey stream cim_load.                                        */
/*zy*//*                end.                                                               */
/*zy*//*             end.                                                                  */
/*zy*//*             /*... otherwise, get data from database */                            */
/*zy*//*             else do:                                                              */
/*zy*//*                find first bdld_det no-lock where                                  */
/*zy*//*                   bdld_source = "" and                                            */
/*zy*//*                   bdld_id = current_bdl_id and                                    */
/*zy*//*                   bdld_line > current_line no-error.                              */
/*zy*//*                if not available bdld_det then do:                                 */
/*zy*//*                   if(linedata="@PROCESS") then                                    */
/*zy*//*                      error_value="DONE".                                          */
/*zy*//*                   else                                                            */
/*zy*//*                      error_value = "ERROR".                                       */
/*zy*//*                   leave screen_break.                                             */
/*zy*//*                end.                                                               */
/*zy*//*                assign                                                             */
/*zy*//*                   linedata = bdld_data                                            */
/*zy*//*                   current_line = bdld_line.                                       */
/*zy*//*             end.                                                                  */
/*zy*//*             /* If c_loadproc is not blank, send data through user */              */
/*zy*//*             /* defined process */                                                 */
/*zy*//*             /* if linedata is blank on return, then skip internal processing */   */
/*zy*//*             if c_loadproc <> "" then do:                                          */
/*zy*//*                run value(c_loadproc) (input-output linedata).                     */
/*zy*//*                if linedata = "" then                                              */
/*zy*//*                   next field_process.                                             */
/*zy*//*             end.                                                                  */
/*zy*//*             /* Keyword @LOADPROC identifies a user defined process to be */       */
/*zy*//*             /* executed */                                                        */
/*zy*//*             if substring(linedata,1,9) = "@LOADPROC" then do:                     */
/*zy*//*                c_loadproc = trim(substring(linedata,10)).                         */
/*zy*//*                put stream errorlog unformatted switching_msg c_loadproc skip.     */
/*zy*//*                next field_process.                                                */
/*zy*//*             end.                                                                  */
/*zy*//*             /* Keyword @ACTION defines how data is to be handled, will be */      */
/*zy*//*             /*  followed by either an EDIT or DELETE to identify what to do, */   */
/*zy*//*             /* otherwise generates  an error */                                   */
/*zy*//*             if substring(linedata,1,7) = "@ACTION" then do:                       */
/*zy*//*                c_process_type = trim(substring(linedata,8)).                      */
/*zy*//*                if not c_process_type = "EDIT" and                                 */
/*zy*//*                   not c_process_type = "DELETE" then do:                          */
/*zy*//*                                                                                   */
/*zy*//*                   put stream errorlog unformatted                                 */
/*zy*//*                      process_err                                                  */
/*zy*//*                      c_process_type                                               */
/*zy*//*                      skip(1).                                                     */
/*zy*//*                   error_value = "ERROR".                                          */
/*zy*//*                   leave screen_break.                                             */
/*zy*//*                end.                                                               */
/*zy*//*                /* Write copy of this input to temporary file (prepend */          */
/*zy*//*                /* @@BATCHLOAD, as this would have occurred before     */          */
/*zy*//*                /* the redirection keywords                            */          */
/*zy*//*                if err_out_file <> "" or suc_out_file <> "" then do:               */
/*zy*//*                   if first_time then do:                                          */
/*zy*//*                      first_time=false.                                            */
/*zy*//*                      put stream copy_file unformatted                             */
/*zy*//*                         "@@BATCHLOAD "                                            */
/*zy*//*                         execname                                                  */
/*zy*//*                         skip.                                                     */
/*zy*//*                   end.                                                            */
/*zy*//*                   put stream copy_file unformatted                                */
/*zy*//*                      linedata                                                     */
/*zy*//*                      skip.                                                        */
/*zy*//*                end.                                                               */
/*zy*//*                next field_process.                                                */
/*zy*//*             end.                                                                  */
/*zy*//*             /* On encountering @@BATCHLOAD, determine if the same screen will */  */
/*zy*//*             /* be executed, if so then proceed to retrieve the next line of   */  */
/*zy*//*             /* data, otherwise setup the new program by jumping out to the    */  */
/*zy*//*             /* new_pgm_loop.                                                  */  */
/*zy*//*             if substring(linedata,1,11) = "@@BATCHLOAD" then do:                  */
/*zy*//*                templine = trim(substring(linedata,12)).                           */
/*zy*//*                if templine <> execname then do:                                   */
/*zy*//*                   assign                                                          */
/*zy*//*                      execname=templine                                            */
/*zy*//*                      error_value = "RETRY".                                       */
/*zy*//*                   leave screen_break.                                             */
/*zy*//*                end.                                                               */
/*zy*//*                next field_process.                                                */
/*zy*//*             end.                                                                  */
/*zy*//*                                                                                   */
/*zy*//*             /* Keyword @@END signifies the end of the CIM file - leave the */     */
/*zy*//*             /* program                                                     */     */
/*zy*//*             if substring(linedata,1,5) = "@@END" then do:                         */
/*zy*//*                error_value = "DONE".                                              */
/*zy*//*                leave screen_break.                                                */
/*zy*//*             end.                                                                  */
/*zy*//*                                                                                   */
/*zy*//*             /* Keyword @PROCESS means all data has been loaded and should now */  */
/*zy*//*             /* be processed by the screen, leave field_process to process     */  */
/*zy*//*             /* data                                                           */  */
/*zy*//*             if linedata = "@PROCESS" then                                         */
/*zy*//*                leave field_process.                                               */
/*zy*//*                                                                                   */
/*zy*//*             /* Keyword @ERRORDATAFILE determines an user defined file for   */    */
/*zy*//*             /* saving CIM transactions which were unsuccessfully processed  */    */
/*zy*//*             if substring(linedata,1,14) = "@ERRORDATAFILE" then do:               */
/*zy*//*                err_out_file = trim(substring(linedata, 15)).                      */
/*zy*//*                /* If the file exists, it is deleted */                            */
/*zy*//*                os-delete value(err_out_file).                                     */
/*zy*//*                next field_process.                                                */
/*zy*//*             end.                                                                  */
/*zy*//*                                                                                   */
/*zy*//*             /* Keyword @SUCCESSDATAFILE determines an user defined file for */    */
/*zy*//*             /* saving CIM transactions which were successfully processed    */    */
/*zy*//*             if substring(linedata,1,16) = "@SUCCESSDATAFILE" then do:             */
/*zy*//*                suc_out_file = trim(substring(linedata, 17)).                      */
/*zy*//*                /* If the file exists, it is deleted */                            */
/*zy*//*                os-delete value(suc_out_file).                                     */
/*zy*//*                next field_process.                                                */
/*zy*//*             end.                                                                  */
/*zy*//*                                                                                   */
/*zy*//*             /* Keyword @DEFAULTSFILE defines a file containing template data */   */
/*zy*//*             /* to be used for this CIM process                               */   */
/*zy*//*             if substring(linedata,1,13) = "@DEFAULTSFILE" then do:                */
/*zy*//*                template_file = trim(substring(linedata, 14)).                     */
/*zy*//*                /* If template file is blank, then remove all templates */         */
/*zy*//*                /* in work file ...                                     */         */
/*zy*//*                if template_file = "" then do:                                     */
/*zy*//*                   for each template-table exclusive-lock:                         */
/*zy*//*                      delete template-table.                                       */
/*zy*//*                   end.                                                            */
/*zy*//*                end.                                                               */
/*zy*//*                /* ... otherwise, add new template to the work file */             */
/*zy*//*                else do:                                                           */
/*zy*//*                   input stream temp_load from value(search(template_file))        */
/*zy*//*                      no-echo.                                                     */
/*zy*//*                   first_load=true.                                                */
/*zy*//*                   /* Read and process each line */                                */
/*zy*//*                   load_temp:                                                      */
/*zy*//*                   repeat:                                                         */
/*zy*//*                      templine = "".                                               */
/*zy*//*                      readkey stream temp_load.                                    */
/*zy*//*                      do while lastkey <> keycode("RETURN") and lastkey >= 0:      */
/*zy*//*                         templine = templine + chr(lastkey).                       */
/*zy*//*                         readkey stream temp_load.                                 */
/*zy*//*                      end.                                                         */
/*zy*//*                      if templine = "" then leave load_temp.                       */
/*zy*//*                      /* First line is the name of the executable to which */      */
/*zy*//*                      /* template applies ...*/                                    */
/*zy*//*                      if first_load then do:                                       */
/*zy*//*                         assign                                                    */
/*zy*//*                            temp_load_exec=templine                                */
/*zy*//*                            first_load=false.                                      */
/*zy*//*                      end.                                                         */
/*zy*//*                      /*... other lines contain "group" "field" "value" data */    */
/*zy*//*                      else do:                                                     */
/*zy*//*                         create template-table.                                    */
/*zy*//*                         assign                                                    */
/*zy*//*                            template-table.exec-name = temp_load_exec              */
/*zy*//*                            i = index(templine,"""")                               */
/*zy*//*                            j = index(templine,"""",i + 1)                         */
/*zy*//*                            template-table.group-name =                            */
/*zy*//*                               substring(templine,i,j - i + 1)                     */
/*zy*//*                            i = index(templine,"""",j + 1)                         */
/*zy*//*                            j = index(templine,"""",i + 1)                         */
/*zy*//*                            template-table.field-name =                            */
/*zy*//*                               substring(templine,i,j - i + 1)                     */
/*zy*//*                            i = index(templine,"""",j + 1)                         */
/*zy*//*                            j = index(templine,"""",i + 1)                         */
/*zy*//*                            template-table.field-value =                           */
/*zy*//*                               substring(templine,i,j - i + 1).                    */
/*zy*//*                      end.                                                         */
/*zy*//*                   end.                                                            */
/*zy*//*                end.                                                               */
/*zy*//*                output stream temp_load close.                                     */
/*zy*//*                next field_process.                                                */
/*zy*//*             end.                                                                  */
/*zy*//*             /* If there is a template file loaded, check if data exists in */     */
/*zy*//*             /* a template */                                                      */
/*zy*//*             if template_file <> "" then do:                                       */
/*zy*//*                assign                                                             */
/*zy*//*                   i = index(linedata,"""")                                        */
/*zy*//*                   j = index(linedata,"""",i + 1).                                 */
/*zy*//*                if i > 0 then                                                      */
/*zy*//*                   assign                                                          */
/*zy*//*                      grp_name = substring(linedata,i,j - i + 1)                   */
/*zy*//*                      i = index(linedata,"""",j + 1)                               */
/*zy*//*                      j = index(linedata,"""",i + 1).                              */
/*zy*//*                if i > 0 then do:                                                  */
/*zy*//*                   fld_name = substring(linedata,i,j - i + 1).                     */
/*zy*//*                                                                                   */
/*zy*//*                   /* Find a template record which matches the executable */       */
/*zy*//*                   /* name, group name and field name                     */       */
/*zy*//*                   find first template-table where                                 */
/*zy*//*                      template-table.exec-name = execname and                      */
/*zy*//*                      template-table.group-name = grp_name and                     */
/*zy*//*                      template-table.field-name = fld_name no-error.               */
/*zy*//*                                                                                   */
/*zy*//*                   /* If a record is found then replace the data with the */       */
/*zy*//*                   /*template data */                                              */
/*zy*//*                   if available template-table then                                */
/*zy*//*                      linedata = """" + grp_name + """ """ + fld_name              */
/*zy*//*                               + """ """ + template-table.field-value + """".      */
/*zy*//*                end.                                                               */
/*zy*//*             end.                                                                  */
/*zy*//*                                                                                   */
/*zy*//*             /* Write the resulting data out to the temporary file */              */
/*zy*//*             if err_out_file <> "" or suc_out_file <> "" then do:                  */
/*zy*//*                put stream copy_file unformatted                                   */
/*zy*//*                   linedata                                                        */
/*zy*//*                   skip.                                                           */
/*zy*//*             end.                                                                  */
/*zy*//*                                                                                   */
/*zy*//*             /* Divide string up into components and process */                    */
/*zy*//*             if index(linedata," ") > 0 then                                       */
/*zy*//*                c-group = substring(linedata,1,index(linedata," ")).               */
/*zy*//*             else                                                                  */
/*zy*//*                c-group = substring(linedata,1,length(linedata)).                  */
/*zy*//*             c-temp  = substring(linedata,length(c-group) + 1, length(linedata)).  */
/*zy*//*                                                                                   */
/*zy*//*             if index(c-temp," ") > 0 then                                         */
/*zy*//*                c-field = substring(c-temp,1,index(c-temp," ")).                   */
/*zy*//*             else                                                                  */
/*zy*//*                c-field = substring(c-temp,1,length(c-temp)).                      */
/*zy*//*             c-temp  = substring(c-temp,length(c-field) + 1, length(c-temp)).      */
/*zy*//*                                                                                   */
/*zy*//*             /* If only two fields, assume it was field name and value */          */
/*zy*//*             /* (Group is optional) */                                             */
/*zy*//*             if c-temp <> "" then                                                  */
/*zy*//*                c-value = substring(c-temp,1,length(c-temp)).                      */
/*zy*//*             else                                                                  */
/*zy*//*             assign                                                                */
/*zy*//*                c-value = c-field                                                  */
/*zy*//*                c-field = c-group                                                  */
/*zy*//*                c-group = "".                                                      */
/*zy*//*                                                                                   */
/*zy*//*             /* Get rid of white spaces and outermost quotes */                    */
/*zy*//*             assign                                                                */
/*zy*//*                c-group = trim(trim(c-group),'"')                                  */
/*zy*//*                c-field = trim(trim(c-field),'"')                                  */
/*zy*//*                c-value = trim(trim(c-value),'"').                                 */
/*zy*//*                                                                                   */
/*zy*//*             /* Move data into data storage object */                              */
/*zy*//*             run q-set-data in h_screen(input c-group,                             */
/*zy*//*                                        input c-field,                             */
/*zy*//*                                        input c-value).                            */
/*zy*//*             temp_line=current_line.                                               */
/*zy*//*          end.  /* field_process */                                                */
/*zy*//*                                                                                   */
/*zy*//*          /* Write keyword @PROCESS to temporary file */                           */
/*zy*//*          if err_out_file <> "" or suc_out_file <> "" then do:                     */
/*zy*//*             put stream copy_file unformatted "@PROCESS" skip.                     */
/*zy*//*          end.                                                                     */
/*zy*//*                                                                                   */
/*zy*//*          output stream copy_file close.                                           */
/*zy*//*                                                                                   */
/*zy*//*          /* Process data residing in window's data storage object: First */       */
/*zy*//*          /* move the data from the data storage object into the screen   */       */
/*zy*//*          /* and execute the desired processing (EDIT or DELETE) through  */       */
/*zy*//*          /* the processing logic object, then retrieve error and warning */       */
/*zy*//*          /* messages through the window's message object                 */       */
/*zy*//*          assign                                                                   */
/*zy*//*             session:appl-alert-boxes=true                                         */
/*zy*//*             session:system-alert-boxes=true.                                      */
/*zy*//*                                                                                   */
/*zy*//*          /* ADD STOP TO TRAP FATAL INTERRUPT*/                                    */
/*zy*//*          cloop:                                                                   */
/*zy*//*          do on stop undo cloop,leave cloop:                                       */
/*zy*//*             run q-process-data in h_screen(input c_process_type) no-error.        */
/*zy*//*             run q-get-msg in h_screen(output c_msg,                               */
/*zy*//*                                       output c_err_count,                         */
/*zy*//*                                       output c_warn_count).                       */
/*zy*//*          end.                                                                     */
/*zy*//*          output close.                                                            */
/*zy*//*                                                                                   */
/*zy*//*          assign                                                                   */
/*zy*//*             group_progress_errors=0                                               */
/*zy*//*             group_function_errors=c_err_count                                     */
/*zy*//*             function_errors = function_errors + c_err_count                       */
/*zy*//*             function_warnings = function_warnings + c_warn_count.                 */
/*zy*//*                                                                                   */
/*zy*//*          /* Process any PROGRESS and validation errors (could not be */           */
/*zy*//*          /* re-directed) */                                                       */
/*zy*//*          input stream temp_load from value(work_i_file) no-echo.                  */
/*zy*//*          load_error:                                                              */
/*zy*//*          repeat:                                                                  */
/*zy*//*             templine = "".                                                        */
/*zy*//*             readkey stream temp_load.                                             */
/*zy*//*             do while lastkey <> keycode("RETURN") and lastkey >= 0:               */
/*zy*//*                templine = templine + chr(lastkey).                                */
/*zy*//*                readkey stream temp_load.                                          */
/*zy*//*             end.                                                                  */
/*zy*//*             if templine = "" then leave load_error.                               */
/*zy*//*             if substring(templine,1,2) = "**"                                     */
/*zy*//*                /* CHECK FOR ORACLE ERRORS ADDED */                                */
/*zy*//*                or (substring(templine,1,6) = "ORACLE") then do:                   */
/*zy*//*                assign                                                             */
/*zy*//*                   progress_errors = progress_errors + 1                           */
/*zy*//*                   group_progress_errors = group_progress_errors + 1.              */
/*zy*//*                                                                                   */
/*zy*//*                put stream errorlog unformatted                                    */
/*zy*//*                   'getTermLabel("GROUP_ID",11)' + ": "                            */
/*zy*//*                   current_bdl_id                                                  */
/*zy*//*                   space                                                           */
/*zy*//*                   templine                                                        */
/*zy*//*                   skip.                                                           */
/*zy*//*             end.                                                                  */
/*zy*//*          end.                                                                     */
/*zy*//*          input stream temp_load close.                                            */
/*zy*//*                                                                                   */
/*zy*//*          /* Write program errors and warnings to error log */                     */
/*zy*//*          repeat i = 1 to num-entries(c_msg,"'"):                                  */
/*zy*//*             if substring(entry(i,c_msg,"'"),1,2) = "**"                           */
/*zy*//*                or (substring(templine,1,6) = "ORACLE") then                       */
/*zy*//*                group_progress_errors = group_progress_errors + 1.                 */
/*zy*//*             put stream errorlog unformatted                                       */
/*zy*//*                entry(i,c_msg,"'")                                                 */
/*zy*//*                skip.                                                              */
/*zy*//*          end.                                                                     */
/*zy*//*                                                                                   */
/*zy*//*          /* Concatenate successful screen transaction to user defined file */     */
/*zy*//*          if (group_progress_errors = 0 and group_function_errors = 0) and         */
/*zy*//*             suc_out_file <> ""  then do:                                          */
/*zy*//*             os-append value(work_o_file) value(suc_out_file).                     */
/*zy*//*          end.                                                                     */
/*zy*//*                                                                                   */
/*zy*//*          /* Concatenate failed screen transaction to user defined file */         */
/*zy*//*          if (group_progress_errors > 0 or group_function_errors > 0) and          */
/*zy*//*             err_out_file <> ""  then do:                                          */
/*zy*//*             os-append value(work_o_file) value(err_out_file).                     */
/*zy*//*          end.                                                                     */
/*zy*//*                                                                                   */
/*zy*//*          last_line = current_line.                                                */
/*zy*//*          /* /*J13D*/ group_count=group_count + 1.*/                               */
/*zy*//*       end.  /* screen_break */                                                    */
/*zy*//*                                                                                   */
/*zy*//*       output stream copy_file close.                                              */
/*zy*//*       output close.                                                               */
/*zy*//*                                                                                   */
/*zy*//*       /* Starting a new screen, jump to beginning of new_pgm_loop */              */
/*zy*//*       if error_value = "RETRY" then                                               */
/*zy*//*          next new_pgm_loop.                                                       */
/*zy*//*                                                                                   */
/*zy*//*       /* Finished processing, either due to error or reached @@END keyword*/      */
/*zy*//*       if error_value = "ERROR" or error_value = "DONE" then                       */
/*zy*//*          leave new_pgm_loop.                                                      */
/*zy*//*    end.  /* new_pgm_loop */                                                       */
/*zy*//*                                                                                   */
/*zy*//*    /* Reset all values and perform any necessary cleanup */                       */
/*zy*//*    batchrun = lastbatchrun.                                                       */
/*zy*//*    if process_file then                                                           */
/*zy*//*       input stream cim_load close.                                                */
/*zy*//*    if valid-handle(h_screen) then                                                 */
/*zy*//*       apply "CLOSE" to h_screen.                                                  */
/*zy*//*                                                                                   */
/*zy*//*    assign                                                                         */
/*zy*//*       session:appl-alert-boxes=save_appl_boxes                                    */
/*zy*//*       session:system-alert-boxes=save_sys_boxes.                                  */
/*zy*//*                                                                                   */
/*zy*//*    if error_value = "ERROR" then                                                  */
/*zy*//*       return "ERROR".                                                             */
/*zy*//*                                                                                   */
/*zy*//*    return "".                                                                     */
/*zy*//*                                                                                   */
/*zy*//* end.                                                                              */
/*zy*//*                                                                                   */
/****************************************************************************
 * Purpose:
 * Handles CIM processing for pre-8.5 MFG/PRO applications.
 * Parmeters:
 * None, but uses the following file global variables:
 * function_errrors:  number of program errors encountered
 * function_warnings:  number of program warnings encountered
 * process_file:  logical value of whether to process file directly
 * file_name:  name of flat file to process directly
 * execname: name of screen to be executed
 * errorlog: stream where processing results are stored
 * work_o_file: name of temporary output file
 * work_i_file: name of temporary input file
 * Notes:
 * Old CIM format files require processing through input/output files
 * since is no other way to direct input into the screen and no other way
 * to retrieve errors and warnings during the processing.
 ***************************************************************************/
PROCEDURE process_all:

   define variable linedata as character no-undo.
   define variable current_line as integer initial -1 no-undo.
   define variable save_appl_boxes as logical no-undo.
   define variable save_sys_boxes as logical no-undo.
   define variable l-first as logical initial true no-undo.

   if process_file then
      input stream cim_load from value(file_name).

   /* POSITION THE FILE POINTER TO THE OFFSET VALUE */
   /* OF NEXT @@BATCHLOAD MARKER IN CIM FILE        */

   if  process_file
   and w-interim-seek <> 0
   then
      seek stream cim_load to w-interim-seek.

   assign
      lastbatchrun = batchrun
      save_appl_boxes = session:appl-alert-boxes
      save_sys_boxes = session:system-alert-boxes
      session:appl-alert-boxes = false
      session:system-alert-boxes = false.

   output to value(work_i_file).

   /* Retrieve batch data load detail (bdld_det) for this batch data load */
   /* master (bdl_mstr) */
   old_line_process:
   repeat:
      if process_file then do:
         linedata = "".
         readkey stream cim_load.
         do while lastkey <> keycode("RETURN") and lastkey >= 0:
            linedata = linedata + chr(lastkey).
            readkey stream cim_load.
         end.

         if (lastkey < 0)
         then do:
            assign
               w-interim-seek   = seek(cim_load)
               w-batchload-seek = 0.

            leave old_line_process.
         end.  /* IF (lastkey < 0) */
      end.
      else do:
         find first bdld_det no-lock where
            bdld_source = current_bdl_source and
            bdld_id = current_bdl_id and
            bdld_line > current_line no-error.

         /* if no record, but found previous record, process data */
         if((not available(bdld_det)) and (not l-first)) then
            leave old_line_process.

         /* if no record and no previous data, return */
         if((not available(bdld_det)) and (l-first)) then do:
            output close.
            return "".
         end.
         assign
            l-first=false
            linedata = bdld_data
            current_line = bdld_line.
      end.


      /* Write data to output file */
      if substring(linedata,1,11) = "@@BATCHLOAD" then do:

         assign
            w-batchload-seek = seek(cim_load)
            execname         = trim(substring(linedata,12)).

         next old_line_process.
      end.

      if(substring(linedata,1,5) = "@@END" and not process_file) then do:
         leave old_line_process.
      end.

      /* ONCE AN @@END STATEMENT IS ENCOUNTERED WHEN PROCESSING FROM  */
      /* A FILE, THEN STORE THE OFFSET VALUE OF THE CURRENT POSITION  */
      /* OF THE FILE POINTER IN w-interim-seek AND LEAVE THE REPEAT   */
      /* LOOP TO PROCESS THE DATA OF AN INDIVIDUAL BATCH LOAD         */

      if  substring(linedata,1,5) = "@@END"
      and process_file
      then do:
         assign
            w-interim-seek   = seek(cim_load)
            w-batchload-seek = 0.

         leave old_line_process.
      end. /* IF  SUBSTRING(linedata,1,5) = "@@END"  */

      /* WE HAVE TO TAKE CARE IF THERE ARE ANY BLANK LINES AT THE END */
      /* OF THE CIM FILE. ALSO TAKE CARE FOR BLANK LINES BETWEEN TWO  */
      /* BATCHLOADS */

      if (substring(linedata,1,5)<>"@@END")
      then do:

         /* IF THERE ARE ANY BLANK LINES AT THE END OF THE  */
         /* CIM FILE THEN JUST RETURN                       */
         if process_file
         then do:

            if w-end-seek = seek(cim_load)
            then
               return error.

            /* DO NOT OUTPUT THE DATA UNTIL @@BATCHLOAD MARKER */
            /* IS ENCOUNTERED                                  */
            if w-batchload-seek = 0
            then
               next old_line_process.

         end.  /* IF process_file */

         if linedata = "" then
            put skip(1).
         else
            put unformatted linedata skip.
      end.
   end.
   output close.

   {gprun.i ""mgbdpro1.p"" "(input execname, output go_on)"}
   if go_on then do:
      input from value(work_i_file) no-echo.

      /* V 7 OF PROGRESS DOES NOT ACT LIKE V 6. INSTEAD OF WRITING           */
      /* THE PROGRESS MESSAGES TO THE FILE, MESSAGES ARE WRTTTEN TO THE      */
      /* TERMINAL. ADDING "KEEP-MESSAGES" MAKES PROGRESS 7 WORK LIKE         */
      /* PROGRESS 6.                                                         */

      output to value(work_o_file) keep-messages.

      /* Setup dtitle for callable program for reports that use it */
      find first mnd_det where mnd_exec=execname no-lock no-error.

      /* THE VARIABLE DTITLE IS ASSIGNED THE VALUE IN EXECNAME BEFORE */
      /* THE CALL TO MFMENU.I SO THAT THE TITLE HEADER INFORMATION IS */
      /* ASSIGNED ACCURATELY TO THE VARIABLE DTITLE IN MFMENU.I       */

      dtitle = lc(execname).
      {mfmenu.i}
      batchrun=yes.

      pause 0 before-hide.

      /* ADD STOP TO TRAP FATAL INTERRUPT*/
      aloop:
      do on stop undo aloop,leave aloop:

         /*V8-*/
         {gprun.i execname} /*V8+*/
         /*V8! do on error undo, leave on endkey undo, leave:
                  {gprun.i ""gpwinrun.p"" "(execname, 'CIM')"}.
               end.
               batchrun = lastbatchrun. */
      end.

      pause before-hide.

      output close.
      input close.
      execname = lastexecname.

      /* Now let's look for errors in the function output file */
      assign
         group_progress_errors = 0
         group_function_errors = 0.

      input from value(work_o_file) no-echo.

      repeat:
         /* Clear all elements */
         linefield = "".
         set linefield with width 255.

         /* Output error lines to report. */
         if linefield[1] = "**" or
            /* CHECK FOR ORACLE ERRORS ADDED */
            linefield[1] = "ORACLE" or
            linefield[1] = ('getTermLabel("WARNING",11)' + ":") or
            linefield[1] = ('getTermLabel("ERROR",8)'    + ":")
         then do:

/*             if not process_file then                   */
/*                put stream errorlog unformatted         */
/*                   'getTermLabel("GROUP_ID",11)' + ": " */
/*                   space                                */
/*                   current_bdl_id                       */
/*                   space.                               */
/*             else                                       */
/*                put stream errorlog unformatted         */
/*                   'getTermLabel("INPUT_FILE_NAME",20)' */
/*                   space                                */
/*                   file_name                            */
/*                   space.                               */

            do i = 1 to 40:
               if linefield[i] = "" then leave.
               error_msg = error_msg + linefield[i].
/*                put stream errorlog unformatted            */
/*                   "LINEFIELD" + string(i) + linefield[i]  */
/*                   space.                                  */
            end.

            /* index of last word */
            i = i - 1.
/*             put stream errorlog skip(1).  */
         end.

         /* Count warning/error messages by type */
         if linefield[1] = "**" or linefield[1] = "ORACLE" then do:

            if ( linefield[2] = "tr_hist"  and linefield[i] = "(132)" ) or
               ( linefield[2] = "op_hist" and linefield[i] = "(132)" )  then
               function_warnings = function_warnings + 1.
            else
               assign
                  progress_errors = progress_errors + 1
                  group_progress_errors = group_progress_errors + 1.
         end.
         else
            if linefield[1] = ('getTermLabel("WARNING",11)' + ":" )
            then
               function_warnings = function_warnings + 1.
         else
            if linefield[1] = ('getTermLabel("ERROR",8)' + ":" )
            then do:
               assign
                  function_errors = function_errors + 1
                  group_function_errors = group_function_errors + 1.
         end.
      end.

      input close.
   end. /* if go_on then do: */
/*    else do:                                       */
/*                                                   */
/*       if not process_file then                    */
/*          put stream errorlog unformatted          */
/*             'getTermLabel("GROUP_ID",11)' + ": "  */
/*             space                                 */
/*             current_bdl_id                        */
/*             space.                                */
/*                                                   */
/*       else                                        */
/*       put stream errorlog unformatted             */
/*          'getTermLabel("INPUT_FILE_NAME",20)'     */
/*          space                                    */
/*          file_name                                */
/*          space.                                   */
/*       put stream errorlog unformatted             */
/*          procedure_err                            */
/*          execname                                 */
/*          skip(1).                                 */
/*                                                   */
/*    end.                                           */

   batchrun = lastbatchrun.
   if process_file then
      input stream cim_load close.

   assign
      session:appl-alert-boxes = save_appl_boxes
      session:system-alert-boxes = save_sys_boxes.
end.

PROCEDURE get_CIM_session:

   define output parameter session_no as character.

   do transaction:
      /* Find first CIM process session - leave if more than 999 CIM sessions*/
      do i = 0 to 999:
         find first qad_wkfl exclusive-lock where
            qad_key1 = vkey1    and
            qad_key2 > string(i, "999")
            use-index qad_index1 no-error.
         if not available qad_wkfl then
            leave.
         else
         if decimal(qad_key2) > i + 1 then
            leave.
      end.

      if i = 999 then do:
         bell.
         /* Too many CIM Load Sessions in operation */
         {pxmsg.i &MSGNUM=1324 &ERRORLEVEL=4}
         return error.
      end.

      session_no = string(i + 1, "999").

      if available qad_wkfl then release qad_wkfl.

      /* Set up CIM process session in qad_wkfl record */
      create qad_wkfl.
      assign
         qad_key1 = vkey1
         qad_key2 = session_no
         qad_datefld[1] = start_date
         qad_charfld[1] = start_time.
      release qad_wkfl.

   end.
end.

PROCEDURE check_CIM:

   define input parameter session_no as character no-undo.
   define input parameter from_id as integer no-undo.
   define input parameter to_id as integer no-undo.
   define input parameter repeat_process as logical no-undo.
   define input parameter pause_seconds as integer no-undo.
   define input parameter start_date as date no-undo.
   define input parameter start_time as character no-undo.
   define input parameter in_loop as logical no-undo.

   /* Determine if CIM processing session has been lost */
   find qad_wkfl exclusive-lock where
      qad_key1 = vkey1 and
      qad_key2 = session_no    no-error.

   if not available qad_wkfl or
      qad_datefld[1] <> start_date or
      qad_charfld[1] <> start_time or
      qad_key4 = "Kill" then do:

/*       put stream errorlog                                  */
/*          skip(1)                                           */
/*          terminate_msg                                     */
/*          today string(time,"HH:MM:SS") format "x(8)" skip. */
      return error.
   end.

   else do:
      assign
         qad_key1 = vkey1
         qad_key2 = session_no
         qad_datefld[2] = today
         qad_charfld[2] = string(time, "hh:mm:ss").
      if in_loop then do:
         assign
            qad_key3 = "Processing".
            qad_charfld[3] = trim(string(from_id,"zzzzzzz9")) +
                             "  " + trim(string(to_id,"zzzzzzz9")).
            qad_charfld[4] = trim(string(repeat_process)) +
                             "  " + trim(string(pause_seconds,"zzzzzzz9")).
      end.
      else do:
         assign
            qad_key3 = "Waiting for input"
            qad_charfld[3] = ""
            qad_charfld[4] = "".
      end.
   end.
   release qad_wkfl.

end.

PROCEDURE setup_input:

   /* Passed Parameters */
   define input parameter file_name as character no-undo.
   define output parameter function_to_run as character no-undo.
   define output parameter new_file as logical no-undo.

   /* Local variables */
   define variable linedata as character no-undo.
   define variable i as integer no-undo.
   define variable tmp_function as character no-undo.

   if search(file_name) = ? then do:
      /* Unable to find file: # */
/*zy*/ /*   {pxmsg.i &MSGNUM=391 &ERRORLEVEL=3 &MSGARG1=file_name}  */
      ASSIGN error_msg = "cim load source file not found.".
      return "".
   end.

   assign
      function_to_run=""
      new_file=false.

   /* Open input stream */
   input stream temp_load from value(file_name).

   do while not new_file:
      /* Get the current row */
      linedata="".
      readkey stream temp_load.
      do while lastkey <> keycode("RETURN") and lastkey >= 0:
         linedata = linedata + chr(lastkey).
         readkey stream temp_load.
      end.

      /* Get name of program to run */
      if substring(linedata,1,11) = "@@BATCHLOAD" then
         function_to_run = trim(substring(linedata,12)).

      if substring(linedata,1,5) = "@@END"  then
         leave.
      if substring(linedata,1,7) = "@ACTION" then do:
         new_file=true.
         leave.
      end.
   end.
   input stream temp_load close.
   return "".
end.
