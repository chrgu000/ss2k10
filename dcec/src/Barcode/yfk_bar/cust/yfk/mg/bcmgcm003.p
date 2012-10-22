/* GUI CONVERTED from mgbdpro.p (converter v1.76) Wed May  7 00:16:39 2003 */
/* No convert mgbdpro.p (converter v1.60) Fri Apr 28 15:18:42 1995            */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
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
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
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
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 05/04/00   BY: *N09S* Kieran O Dea      */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* myb               */
/* REVISION: 9.1      LAST MODIFIED: 07/23/01   BY: *N10B* Hualin Zhong      */
/* Revision: 1.24     BY: Hualin Zhong   DATE: 08/10/01  ECO: *N10B*         */
/* Revision: 1.25     BY: Dipesh Bector  DATE: 09/23/02  ECO: *N1VH*         */
/* $Revision: 1.29 $  BY: Manish Dani    DATE: 04/25/03  ECO: *N2DP*         */

/* REVISION: 9.1      LAST MODIFIED: 2/6/2005   BY: *lw01* Liwei from atosorigin */
/*                                   2006.03.06 by: *H01*  hou               */

/******************************** Tokens ********************************/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

 ************************************************************************/


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT
/*lw01
{mfdtitle.i "2+ "}
*/
{mfdeclre.i} /*lw01*/
{gplabel.i}  /*lw01*/ 
define variable repeat_process like mfc_logical
   label "Repeat Processing" .
define variable pause_seconds as integer
   label "Pause Seconds Before Repeat" format ">>>>9"
   initial 300.

define variable linefield as character extent 40 format "x(80)".
define variable linedata as character.
define variable linedata2 as character.
define stream errorlog.
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
define variable first_shot     like mfc_logical.
define variable session_no     as   character.
define variable start_date     as   date.
define variable start_time     as   character.
define variable work_i_file    as   character.
define variable work_o_file    as   character.

define variable go_on like mfc_logical initial yes.

define variable save-sys-alert as logical.
define variable save-app-alert as logical.
define variable lastbatchrun like batchrun.

define variable err_out_file as character initial "" no-undo.
define variable suc_out_file as character initial "" no-undo.
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

define variable process_file as logical
   label "Process Direct From File".
define variable file_name as character format "x(20)"
   label "Input File Name".
define stream cim_load.
define variable bdl_recno as recid no-undo.

define variable terminate_msg as character no-undo.
define variable procedure_err as character no-undo.
define variable process_err as character no-undo.
define variable switching_msg as character no-undo.

define variable w-end-seek       as integer    no-undo.
define variable w-interim-seek   as integer    no-undo.
define variable w-batchload-seek as integer    no-undo.

/************ adde by lw01 for HengLong project , begin ************/
define input parameter xfileid as character.
define input parameter xfromid as int.
define input parameter xtoid   as int.
define output parameter proerrors as int.

define variable msgtxt as character format "x(80)".
define variable grppro as character.
define variable dberr  as character.
define variable pgmwrn as character.
define variable pgmerr as character.
define shared variable last_bdl_id like bdl_id.

/*H01*/
/*{xglogdef.i " "} */

{xgcmdef.i " "}
/************ adde by lw01 for HengLong project , begin ************/


/* Cim PROCESS SESSION TERMINATED DUE TO LOSS OF SESSION RECORD */
{pxmsg.i &MSGNUM=4686 &ERRORLEVEL=1 &MSGBUFFER=terminate_msg}

/* PROCEDURE DOES NOT EXIST */
{pxmsg.i &MSGNUM=1553 &ERRORLEVEL=4 &MSGBUFFER=procedure_err}

/* INVALID PROCESS TYPE */
{pxmsg.i &MSGNUM=4775 &ERRORLEVEL=4 &MSGBUFFER=process_err}

/* SWITCHING TO NEW LOAD PROCEDURE */
{pxmsg.i &MSGNUM=4776 &ERRORLEVEL=2 &MSGBUFFER=switching_msg}

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
   work_i_file = mfguser + ".bpi"
   work_o_file = mfguser + ".bpo".

/* SELECT FORM */


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

/********** deleted by lw01, begin ****************
FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
skip(1)
   from_id             colon 30
   to_id               label {t001.i}
   skip(1)
   repeat_process      colon 35 view-as toggle-box
   skip(1)
   pause_seconds       colon 35
   skip(1)
   process_file        colon 35 view-as toggle-box
   skip(1)
   file_name           colon 35
   skip(1)
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

mainloop:
repeat:

         hide all no-pause.
   if global-tool-bar and global-tool-bar-handle <> ? then
      view global-tool-bar-handle.
      view frame a.
      input from terminal.  

   update
      from_id
      to_id
      repeat_process
      pause_seconds
      process_file
      file_name with frame a.
**************** delete by lw01,end *****/ 
   
   /*** added by lw01,begin ***/
   from_id = xfromid.
   to_id   = xtoid.
   repeat_process = no.
   pause_seconds = 0.
   process_file = no.
   file_name = "".
   /*** added by lw01,begin ***/
   
   
   assign
      w-end-seek       = 0
      w-interim-seek   = 0
      w-batchload-seek = 0
      group_count      = 0.

   /********** lw01 ************
   output stream errorlog close.
   
   output stream errorlog to value(xlogname) append.
   *********** lw01 ************/

   /* CALL GENERIC OUTPUT DESTINATION SELECTION INCLUDE.
    * OUTPUT DESTINATIONS OF TYPE Email AND Winprint (Windows Printer)
    * ARE NOT ALLOWED*/

   /**delete by lw01 . begin *****
   {gpselout.i
      &printType = "printer"
      &printWidth = 132
      &pagedFlag = "page"
      &stream = "stream errorlog"
      &appendToFile = "append"
      &streamedOutputToTerminal = " "
      &withBatchOption = "no"
      &displayStatementType = 1
      &withCancelMessage = "yes"
      &pageBottomMargin = 6
      &withEmail = "no"
      &withWinprint = "no"
      &defineVariables = "yes"}
   **delete by lw01 . begin ******/
/*lw01
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
*/

   row_count = 0.
/*******************lw01 
   if process_file then do:
      run setup_input(input  file_name,
                      output execname,
                      output new_file).

      put stream errorlog
         skip(1)
         {gplblfmt.i
            &FUNC=getTermLabel(""BATCH_DATA_LOAD_STARTING"",32)}
         space(1)
         today
         space(1)
         string(time,"HH:MM:SS") format "x(8)"
         skip.
       
      if new_file then
         run process_by_screen.

      /* FIND THE OFFSET VALUE OF END OF FILE AND */
      /* CALL INTERNAL PROCEDURE process_all TILL */
      /* THE END OF FILE                          */

      else do:

         input stream cim_load from value(file_name).
         seek stream cim_load to end.
         w-end-seek = seek(cim_load).
         input stream cim_load close.

         do while w-interim-seek < w-end-seek:
            run process_all  no-error.
            if error-status:error
            then
               leave.
            group_count =  group_count + 1.
         end.  /* DO WHILE w-interim-seek < w-end-seek */

      end.  /* ELSE DO */

      os-delete value(work_i_file).
      os-delete value(work_o_file).
      if not go_on then
         function_errors = function_errors + 1.

      put stream errorlog
         skip(1)
         {gplblfmt.i
            &FUNC=getTermLabel(""BATCH_DATA_LOAD_COMPLETE"",32)}
         space(1)
         today space(1)
         string(time,"HH:MM:SS") skip.
      put stream errorlog unformatted
         getTermLabel("GROUPS_PROCESSED",21) space(1) group_count
         space(2)
         getTermLabel("DATABASE_ERRORS",20) space(1) progress_errors
         space(2)
         getTermLabel("PROGRAM_WARNINGS",21) space(1) function_warnings
         space(2)
         getTermLabel("PROGRAM_ERRORS",19) space(1) function_errors
         skip(1).
         /*next mainloop. */
         leave.
   end.
*****************************/

   do transaction on error undo, return error:
      run check_CIM(input session_no,
                    input from_id,
                    input to_id,
                    input repeat_process,
                    input pause_seconds,
                    input start_date,
                    input start_time,
                    input false).
   end.
   /* Set to first so no-find run doesn't set it from given */
   /* 1st number to 0. */
   assign
      last_id = from_id
      bcdparm = "".

   {mfquoter.i from_id}
   {mfquoter.i to_id}
   {mfquoter.i repeat_process}
   {mfquoter.i pause_seconds}
   repeat:
      assign
         group_count = 0
         writing_function_data = no.
      /*lw01* 
      put stream errorlog skip(1)
         {gplblfmt.i
            &FUNC=getTermLabel(""BATCH_DATA_LOAD_STARTING"",32)}
         space(1)
         today space(1)
         string(time,"HH:MM:SS")
         format "x(8)" 
         skip.
         *lw01*/

       msgtxt =  "Batch Load Starting: " + string(today) + " " + string(time,"HH:MM:SS").

       {xgcmlog.i xfileid ""00"" msgtxt}

      first_shot = yes.

      find_bdl:
      repeat:
         /**** lw01 **** 
         do transaction on error undo, leave mainloop:
         **** lw01 ****/   
         do transaction on error undo,leave:
            run check_CIM(input session_no,
                          input from_id,
                          input to_id,
                          input repeat_process,
                          input pause_seconds,
                          input start_date,
                          input start_time,
                          input true).

            looptdo:
            repeat:
               /* Retrieve batch data load master record (bdl_mstr) */
               if first_shot then
                  find first bdl_mstr no-lock where bdl_source = ""
                     and bdl_id >= from_id and bdl_id <= to_id
                     no-error no-wait.
               else
                  find next bdl_mstr no-lock where bdl_source = ""
                     and bdl_id >= from_id and bdl_id <= to_id
                     no-error no-wait.

               first_shot = no.

               if not available bdl_mstr then
                  leave find_bdl.

               if bdl_date_pro <> ? then
                  next looptdo.
               bdl_recno = recid(bdl_mstr).
               find bdl_mstr where recid(bdl_mstr) = bdl_recno
                  exclusive-lock no-error no-wait.
               if locked bdl_mstr then
                  next looptdo.
               if bdl_date_pro = ? then
                  leave looptdo.
               next looptdo.
            end.

            /* Set processing date and time to now */
            assign
               bdl_date_pro = today
               bdl_time_pro = string(time,"HH:MM:SS")
               current_bdl_source = bdl_source
               current_bdl_id = bdl_id
               lastexecname = execname
               execname = bdl_exec.
            release bdl_mstr.
         end.
         find first bdld_det no-lock
            where bdld_source = current_bdl_source and
            bdld_id = current_bdl_id and
            (bdld_data begins "@ACTION") no-error.
         group_count = group_count + 1.
         if available bdld_det then do:
            /*
            run process_by_screen.
            */ 
         end.
         else do:
            run process_all.
         end.

         do transaction:
            find bdl_mstr exclusive-lock where
               bdl_source = current_bdl_source
               and bdl_id = current_bdl_id.

            assign
               bdl_pgm_errs = group_function_errors
               bdl_pro_errs = group_progress_errors.

            if not go_on then do:
               assign
                  bdl_pgm_errs = 1
                  function_errors = function_errors + 1.
            end.

            last_id = bdl_id.
         end.
      end.
      /** lw01** 
      put stream errorlog skip(1)
         {gplblfmt.i
            &FUNC=getTermLabel(""BATCH_DATA_LOAD_COMPLETE"",32)}
         space(1)
         today space(1)
         string(time,"HH:MM:SS") 
         skip 
         .
      
      put stream errorlog unformatted
         getTermLabel("GROUPS_PROCESSED",21) space(1) group_count
         space(2)
         getTermLabel("DATABASE_ERRORS",20) space(1) progress_errors
         space(2)
         getTermLabel("PROGRAM_WARNINGS",21) space(1) function_warnings
         space(2)
         getTermLabel("PROGRAM_ERRORS",19) space(1) function_errors
         skip(1)
         .
      **lw01**/
     do transaction on error undo,leave: /*dss01*/
          grppro = getTermLabel("GROUPS_PROCESSED",21).
          dberr  = getTermLabel("DATABASE_ERRORS",20).
          pgmwrn = getTermLabel("PROGRAM_WARNINGS",21).
          pgmerr = getTermLabel("PROGRAM_ERRORS",19).

          msgtxt = grppro + " " + string(group_count) + "; ".
          msgtxt = msgtxt + dberr  + " " + string(progress_errors) + "; ".
          msgtxt = msgtxt + pgmwrn + " " + string(function_warnings) + "; ".
          msgtxt = msgtxt + pgmerr + " " + string(function_errors).

          proerrors = proerrors + progress_errors + function_errors.
          
          /*output the last line of the log file,
          **the summary information of the process
          */
          {xgcmlog.i xfileid ""00"" msgtxt} 

          /* Remove the temporary input and output files */
          os-delete value(work_i_file).
          os-delete value(work_o_file).

          /****** lw01 *****
          {mfrtrail.i "stream errorlog"}
          ******* lw01 *****/
          
          if not repeat_process then
             leave.
          pause pause_seconds.

          /****** lw01 ******
          {mfselp01.i printer 132 page "stream errorlog" append}
          ******* lw01 ******/
          
          from_id = last_id. /* DONT RE-READ WHAT WE ALREADY LOOKED AT */
     end. /*lw01*/
   end.

/*lw01*
end.
*/
do transaction:

   find qad_wkfl exclusive-lock where qad_key1 = "Cim Process Session" and
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
PROCEDURE process_by_screen:
   define variable current_line as integer initial 0 no-undo.
   define variable last_line as integer initial 0 no-undo.
   define variable temp_line as integer no-undo.
   define variable linedata as character no-undo.
   define variable templine as character no-undo.
   define variable first_load as logical no-undo.
   define variable wrote_line as logical no-undo.
   define variable temp_load_exec as character initial "" no-undo.
   define variable grp_name as character no-undo.
   define variable fld_name as character no-undo.
   define variable h_screen as handle no-undo.
   define variable c_loadproc as character initial "" no-undo.
   define variable c_process_type as character no-undo.
   define variable c-group as character no-undo.
   define variable c-field as character no-undo.
   define variable c-value as character no-undo.
   define variable c-temp as character no-undo.
   define variable c_msg as character no-undo.
   define variable c_err_count as integer no-undo.
   define variable c_warn_count as integer no-undo.
   define variable first_time as logical initial true no-undo.
   define variable save_appl_boxes as logical  no-undo.
   define variable save_sys_boxes as logical no-undo.
   define variable error_value as character initial "" no-undo.

   if process_file then
      input stream cim_load from value(file_name).
   assign
      lastbatchrun=batchrun
      batchrun=true
      save_appl_boxes=session:appl-alert-boxes
      save_sys_boxes=session:system-alert-boxes
      session:appl-alert-boxes=false
      session:system-alert-boxes=false.

   new_pgm_loop:
   repeat:
      /* Determine if program actually exists... */
      {gprun.i ""mgbdpro1.p"" "(input execname, output go_on)"}.
      /*... if so then execute persistently and perform setup ... */
      if go_on then do:
         pause 0 .
         if valid-handle(h_screen) then
            apply "CLOSE" to h_screen.
         do on error undo, leave on endkey undo, leave:
            {gprun.i execname "PERSISTENT SET h_screen"}

            run q-startup in h_screen.
            run q-initialize in h_screen.
         end.
      end.

      /*... otherwise, send error to log and leave procedure with error */
      else do:
         if not process_file then do:
            /*lw01*
            put stream errorlog unformatted
               getTermLabel("GROUP_ID",11) + ":"
               space
               current_bdl_id
               space.
            *lw01*/
            msgtxt = getTermLabel("GROUP_ID",11) + ": " +
            string(current_bdl_id).

            {xgcmlog.i xfileid string(current_bdl_id) msgtxt}

         end.
         else do:
             /*lw01*
             put stream errorlog unformatted
                getTermLabel("INPUT_FILE_NAME",20)
                space
                file_name
                space.

             put stream errorlog unformatted
                procedure_err
                execname
                skip(1)
                .
             error_value = "ERROR".
             leave new_pgm_loop.
             *lw01*/
         end.
      end.

      /* Process each screen individually */
      screen_break:
      repeat:
         /* Setup streams for CIM load file (work_o_file) and */
         /* PROGRESS errors (work_i_file) */
         output stream copy_file to value(work_o_file).
         output to value(work_i_file) keep-messages.
         /* Process each line of data */
         field_process:
         repeat:
            /* If inputting from a file then read in line of data ...*/
            if process_file then do:
               linedata="".
               readkey stream cim_load.
               do while lastkey <> keycode("RETURN") and lastkey >=0:
                  linedata = linedata + chr(lastkey).
                  readkey stream cim_load.
               end.
            end.
            /*... otherwise, get data from database */
            else do:
               find first bdld_det no-lock where
                  bdld_source = "" and
                  bdld_id = current_bdl_id and
                  bdld_line > current_line no-error.
               if not available bdld_det then do:
                  if(linedata="@PROCESS") then
                     error_value="DONE".
                  else
                     error_value = "ERROR".
                  leave screen_break.
               end.
               assign
                  linedata = bdld_data
                  current_line = bdld_line.
            end.
            /* If c_loadproc is not blank, send data through user */
            /* defined process */
            /* if linedata is blank on return, then skip internal processing */
            if c_loadproc <> "" then do:
               run value(c_loadproc) (input-output linedata).
               if linedata = "" then
                  next field_process.
            end.
            /* Keyword @LOADPROC identifies a user defined process to be */
            /* executed */
            if substring(linedata,1,9) = "@LOADPROC" then do:
               c_loadproc = trim(substring(linedata,10)).
               put stream errorlog unformatted switching_msg c_loadproc skip.
               next field_process.
            end.
            /* Keyword @ACTION defines how data is to be handled, will be */
            /*  followed by either an EDIT or DELETE to identify what to do, */
            /* otherwise generates  an error */
            if substring(linedata,1,7) = "@ACTION" then do:
               c_process_type = trim(substring(linedata,8)).
               if not c_process_type = "EDIT" and
                  not c_process_type = "DELETE" then do:

                  put stream errorlog unformatted
                     process_err
                     c_process_type
                     skip(1).
                  error_value = "ERROR".
                  leave screen_break.
               end.
               /* Write copy of this input to temporary file (prepend */
               /* @@BATCHLOAD, as this would have occurred before     */
               /* the redirection keywords                            */
               if err_out_file <> "" or suc_out_file <> "" then do:
                  if first_time then do:
                     first_time=false.
                     put stream copy_file unformatted
                        "@@BATCHLOAD "
                        execname
                        skip.
                  end.
                  put stream copy_file unformatted
                     linedata
                     skip.
               end.
               next field_process.
            end.
            /* On encountering @@BATCHLOAD, determine if the same screen will */
            /* be executed, if so then proceed to retrieve the next line of   */
            /* data, otherwise setup the new program by jumping out to the    */
            /* new_pgm_loop.                                                  */
            if substring(linedata,1,11) = "@@BATCHLOAD" then do:
               templine = trim(substring(linedata,12)).
               if templine <> execname then do:
                  assign
                     execname=templine
                     error_value = "RETRY".
                  leave screen_break.
               end.
               next field_process.
            end.

            /* Keyword @@END signifies the end of the CIM file - leave the */
            /* program                                                     */
            if substring(linedata,1,5) = "@@END" then do:
               error_value = "DONE".
               leave screen_break.
            end.

            /* Keyword @PROCESS means all data has been loaded and should now */
            /* be processed by the screen, leave field_process to process     */
            /* data                                                           */
            if linedata = "@PROCESS" then
               leave field_process.

            /* Keyword @ERRORDATAFILE determines an user defined file for   */
            /* saving CIM transactions which were unsuccessfully processed  */
            if substring(linedata,1,14) = "@ERRORDATAFILE" then do:
               err_out_file = trim(substring(linedata, 15)).
               /* If the file exists, it is deleted */
               os-delete value(err_out_file).
               next field_process.
            end.

            /* Keyword @SUCCESSDATAFILE determines an user defined file for */
            /* saving CIM transactions which were successfully processed    */
            if substring(linedata,1,16) = "@SUCCESSDATAFILE" then do:
               suc_out_file = trim(substring(linedata, 17)).
               /* If the file exists, it is deleted */
               os-delete value(suc_out_file).
               next field_process.
            end.

            /* Keyword @DEFAULTSFILE defines a file containing template data */
            /* to be used for this CIM process                               */
            if substring(linedata,1,13) = "@DEFAULTSFILE" then do:
               template_file = trim(substring(linedata, 14)).
               /* If template file is blank, then remove all templates */
               /* in work file ...                                     */
               if template_file = "" then do:
                  for each template-table exclusive-lock:
                     delete template-table.
                  end.
               end.
               /* ... otherwise, add new template to the work file */
               else do:
                  input stream temp_load from value(search(template_file))
                     no-echo.
                  first_load=true.
                  /* Read and process each line */
                  load_temp:
                  repeat:
                     templine = "".
                     readkey stream temp_load.
                     do while lastkey <> keycode("RETURN") and lastkey >= 0:
                        templine = templine + chr(lastkey).
                        readkey stream temp_load.
                     end.
                     if templine = "" then leave load_temp.
                     /* First line is the name of the executable to which */
                     /* template applies ...*/
                     if first_load then do:
                        assign
                           temp_load_exec=templine
                           first_load=false.
                     end.
                     /*... other lines contain "group" "field" "value" data */
                     else do:
                        create template-table.
                        assign
                           template-table.exec-name = temp_load_exec
                           i = index(templine,"""")
                           j = index(templine,"""",i + 1)
                           template-table.group-name =
                              substring(templine,i,j - i + 1)
                           i = index(templine,"""",j + 1)
                           j = index(templine,"""",i + 1)
                           template-table.field-name =
                              substring(templine,i,j - i + 1)
                           i = index(templine,"""",j + 1)
                           j = index(templine,"""",i + 1)
                           template-table.field-value =
                              substring(templine,i,j - i + 1).
                     end.
                  end.
               end.
               output stream temp_load close.
               next field_process.
            end.
            /* If there is a template file loaded, check if data exists in */
            /* a template */
            if template_file <> "" then do:
               assign
                  i = index(linedata,"""")
                  j = index(linedata,"""",i + 1).
               if i > 0 then
                  assign
                     grp_name = substring(linedata,i,j - i + 1)
                     i = index(linedata,"""",j + 1)
                     j = index(linedata,"""",i + 1).
               if i > 0 then do:
                  fld_name = substring(linedata,i,j - i + 1).

                  /* Find a template record which matches the executable */
                  /* name, group name and field name                     */
                  find first template-table where
                     template-table.exec-name = execname and
                     template-table.group-name = grp_name and
                     template-table.field-name = fld_name no-error.

                  /* If a record is found then replace the data with the */
                  /*template data */
                  if available template-table then
                     linedata = """" + grp_name + """ """ + fld_name
                              + """ """ + template-table.field-value + """".
               end.
            end.

            /* Write the resulting data out to the temporary file */
            if err_out_file <> "" or suc_out_file <> "" then do:
               put stream copy_file unformatted
                  linedata
                  skip.
            end.

            /* Divide string up into components and process */
            if index(linedata," ") > 0 then
               c-group = substring(linedata,1,index(linedata," ")).
            else
               c-group = substring(linedata,1,length(linedata)).
            c-temp  = substring(linedata,length(c-group) + 1, length(linedata)).

            if index(c-temp," ") > 0 then
               c-field = substring(c-temp,1,index(c-temp," ")).
            else
               c-field = substring(c-temp,1,length(c-temp)).
            c-temp  = substring(c-temp,length(c-field) + 1, length(c-temp)).

            /* If only two fields, assume it was field name and value */
            /* (Group is optional) */
            if c-temp <> "" then
               c-value = substring(c-temp,1,length(c-temp)).
            else
            assign
               c-value = c-field
               c-field = c-group
               c-group = "".

            /* Get rid of white spaces and outermost quotes */
            assign
               c-group = trim(trim(c-group),'"')
               c-field = trim(trim(c-field),'"')
               c-value = trim(trim(c-value),'"').

            /* Move data into data storage object */
            run q-set-data in h_screen(input c-group,
                                       input c-field,
                                       input c-value).
            temp_line=current_line.
         end.  /* field_process */

         /* Write keyword @PROCESS to temporary file */
         if err_out_file <> "" or suc_out_file <> "" then do:
            put stream copy_file unformatted "@PROCESS" skip.
         end.

         output stream copy_file close.

         /* Process data residing in window's data storage object: First */
         /* move the data from the data storage object into the screen   */
         /* and execute the desired processing (EDIT or DELETE) through  */
         /* the processing logic object, then retrieve error and warning */
         /* messages through the window's message object                 */
         assign
            session:appl-alert-boxes=true
            session:system-alert-boxes=true.

         /* ADD STOP TO TRAP FATAL INTERRUPT*/
         cloop:
         do on stop undo cloop,leave cloop:
            run q-process-data in h_screen(input c_process_type) no-error.
            run q-get-msg in h_screen(output c_msg,
                                      output c_err_count,
                                      output c_warn_count).
         end.
         output close.

         assign
            group_progress_errors=0
            group_function_errors=c_err_count
            function_errors = function_errors + c_err_count
            function_warnings = function_warnings + c_warn_count.

         /* Process any PROGRESS and validation errors (could not be */
         /* re-directed) */
         input stream temp_load from value(work_i_file) no-echo.
         load_error:
         repeat:
            templine = "".
            readkey stream temp_load.
            do while lastkey <> keycode("RETURN") and lastkey >= 0:
               templine = templine + chr(lastkey).
               readkey stream temp_load.
            end.
            if templine = "" then leave load_error.
            if substring(templine,1,2) = "**"
               /* CHECK FOR ORACLE ERRORS ADDED */
               or (substring(templine,1,6) = "ORACLE") then do:
               assign
                  progress_errors = progress_errors + 1
                  group_progress_errors = group_progress_errors + 1.
               /*lw01*
               put stream errorlog unformatted
                  getTermLabel("GROUP_ID",11) + ": "
                  current_bdl_id
                  space
                  templine
                  skip.
               *lw01*/
               grppro = getTermLabel("GROUP_ID",11).
               msgtxt = grppro + " " + string(current_bdl_id) + templine.
               {xgcmlog.i xfileid string(current_bdl_id) msgtxt}

/*H01*/     /*  {xglogdet.i current_bdl_id execname templine }              yang */

            end.
         end.
         input stream temp_load close.

         /* Write program errors and warnings to error log */
         repeat i = 1 to num-entries(c_msg,"'"):
            if substring(entry(i,c_msg,"'"),1,2) = "**"
               or (substring(templine,1,6) = "ORACLE") then
               group_progress_errors = group_progress_errors + 1.
            /*lw01*
            put stream errorlog unformatted
               entry(i,c_msg,"'")
               skip.
            *lw01*/
            msgtxt = entry(i,c_msg,"'").
            {xgcmlog.i xfileid ""00"" msgtxt}
/*H01*/    /* {xglogdet.i current_bdl_id execname msgtxt }                  yang */
         end.

         /* Concatenate successful screen transaction to user defined file */
         if (group_progress_errors = 0 and group_function_errors = 0) and
            suc_out_file <> ""  then do:
            os-append value(work_o_file) value(suc_out_file).
         end.

         /* Concatenate failed screen transaction to user defined file */
         if (group_progress_errors > 0 or group_function_errors > 0) and
            err_out_file <> ""  then do:
            os-append value(work_o_file) value(err_out_file).
         end.

         last_line = current_line.
         /* /*J13D*/ group_count=group_count + 1.*/
      end.  /* screen_break */

      output stream copy_file close.
      output close.

      /* Starting a new screen, jump to beginning of new_pgm_loop */
      if error_value = "RETRY" then
         next new_pgm_loop.

      /* Finished processing, either due to error or reached @@END keyword*/
      if error_value = "ERROR" or error_value = "DONE" then
         leave new_pgm_loop.
   end.  /* new_pgm_loop */

   /* Reset all values and perform any necessary cleanup */
   batchrun = lastbatchrun.
   if process_file then
      input stream cim_load close.
   if valid-handle(h_screen) then
      apply "CLOSE" to h_screen.

   assign
      session:appl-alert-boxes=save_appl_boxes
      session:system-alert-boxes=save_sys_boxes.

   if error_value = "ERROR" then
      return "ERROR".

   return "".

end.

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
         /*V8+*/
               do on error undo, leave on endkey undo, leave:
                  {gprun.i ""gpwinrun.p"" "(execname, 'CIM')"}.
               end.
               batchrun = lastbatchrun.   
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
            linefield[1] = (getTermLabel("WARNING",11) + ":") or
            linefield[1] = (getTermLabel("ERROR",8)    + ":")
         then do:

            if not process_file then do:
               /*lw01*
               put stream errorlog unformatted
                  getTermLabel("GROUP_ID",11) + ": "
                  space
                  current_bdl_id
                  space.
               *lw01*/ 
               /*
               msgtxt = getTermLabel("GROUP_ID",11) + ": " +
                        string(current_bdl_id) + " ".
               */
               msgtxt = "".
            end.
            else do:
               /*lw01*
               put stream errorlog unformatted
                  getTermLabel("INPUT_FILE_NAME",20)
                  space
                  file_name
                  space.
               *lw01*/

            end.

            do i = 1 to 40:
               if linefield[i] = "" then leave.
               /*lw01*
               put stream errorlog unformatted
                  linefield[i]
                  space.
               *lw01*/
               msgtxt = msgtxt + linefield[i] + " ".
            end.

            /* index of last word */
            i = i - 1.

            /*log detail*/ 
            {xgcmlog.i xfileid string(current_bdl_id) msgtxt}
/*H01*/     /*{xglogdet.i current_bdl_id execname msgtxt }               yang*/
            /*lw01*
            put stream errorlog   
            skip(1).
            *lw01*/
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
            if linefield[1] = (getTermLabel("WARNING",11) + ":" )
            then
               function_warnings = function_warnings + 1.
         else
            if linefield[1] = (getTermLabel("ERROR",8) + ":" )
            then do:
               assign
                  function_errors = function_errors + 1
                  group_function_errors = group_function_errors + 1.
         end.
      end.

      input close.
   end. /* if go_on then do: */
   else do:

      if not process_file then do:
         /*lw01*
         put stream errorlog unformatted
            getTermLabel("GROUP_ID",11) + ": "
            space
            current_bdl_id
            space
            .
          *lw01*/
         msgtxt = getTermLabel("GROUP_ID",11) + ": " + string(current_bdl_id).
         {xgcmlog.i xfileid string(current_bdl_id) msgtxt}

      end.
      else do:
          /*lw01*
          put stream errorlog unformatted
             getTermLabel("INPUT_FILE_NAME",20)
             space
             file_name
             space
             .
          put stream errorlog unformatted
             procedure_err
             execname
             skip(1)
             . 
          *lw01*/ 
           msgtxt = getTermLabel("INPUT_FILE_NAME",20) + " " + file_name + " " +
                  procedure_err + " " + execname.
           {xgcmlog.i xfileid ""00"" msgtxt}
       end.
   end.

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
            qad_key1 = "Cim Process Session"    and
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
         qad_key1 = "Cim Process Session"
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
      qad_key1 = "Cim Process Session" and
      qad_key2 = session_no    no-error.

   if not available qad_wkfl or
      qad_datefld[1] <> start_date or
      qad_charfld[1] <> start_time or
      qad_key4 = "Kill" then do:
       
      /*lw01*
      put stream errorlog
         skip(1)
         terminate_msg
         today string(time,"HH:MM:SS") format "x(8)" 
         skip.
         *lw01*/
      msgtxt = terminate_msg + string(today) + string(time,"HH:MM:SS").
      {xgcmlog.i xfileid grppro msgtxt}
      return error.
   end.

   else do:
      assign
         qad_key1 = "Cim Process Session"
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
      {pxmsg.i &MSGNUM=391 &ERRORLEVEL=3 &MSGARG1=file_name}
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