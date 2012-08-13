/* GUI CONVERTED from mgbdpro.p (converter v1.71) Tue Oct  6 14:33:47 1998 */
/* No convert mgbdpro.p (converter v1.60) Fri Apr 28 15:18:42 1995 */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.*/
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
 ************************************************************************/

/******************************** Tokens ********************************/
/*J0FT*/ /*V8:ConvertMode=Report                                        */
/*K1Q4*/ /*V8:WebEnabled=No                                             */
/************************************************************************/

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
 ************************************************************************/
/*J09J*/
/*J09J*//* Reconstructed CIM processing to handle object applications */
/*J09J*//* following is replacement for commented out code at end of file */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdeclre.i }
{gplabel.i} 
/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mgbdpro_p_1 "  Program warnings "
/* MaxLen: Comment: */

&SCOPED-DEFINE mgbdpro_p_2 "Cim Process Session terminated due to loss of session record "
/* MaxLen: Comment: */

/*J2M0** &SCOPED-DEFINE mgbdpro_p_3 "Group Id:" */
/* MaxLen: Comment: */

&SCOPED-DEFINE mgbdpro_p_4 "  Progress errors "
/* MaxLen: Comment: */

&SCOPED-DEFINE mgbdpro_p_5 "Batch Data File Name"
/* MaxLen: Comment: */

&SCOPED-DEFINE mgbdpro_p_6 "Group ID: "
/* MaxLen: Comment: */

&SCOPED-DEFINE mgbdpro_p_7 "  Program errors "
/* MaxLen: Comment: */

&SCOPED-DEFINE mgbdpro_p_8 "Batch Data Load Complete "
/* MaxLen: Comment: */

&SCOPED-DEFINE mgbdpro_p_9 "Groups processed "
/* MaxLen: Comment: */

&SCOPED-DEFINE mgbdpro_p_10 "ERROR: Procedure does not exist -> "
/* MaxLen: Comment: */

&SCOPED-DEFINE mgbdpro_p_11 "Batch Data Load starting "
/* MaxLen: Comment: */

&SCOPED-DEFINE mgbdpro_p_12 "Group ID:"
/* MaxLen: Comment: */

&SCOPED-DEFINE mgbdpro_p_13 "ERROR: Invalid process type -> "
/* MaxLen: Comment: */

&SCOPED-DEFINE mgbdpro_p_14 "Input File Name"
/* MaxLen: Comment: */

&SCOPED-DEFINE mgbdpro_p_15 "Exception File Name"
/* MaxLen: Comment: */

&SCOPED-DEFINE mgbdpro_p_16 "Process Direct From File"
/* MaxLen: Comment: */

&SCOPED-DEFINE mgbdpro_p_17 "Pause Seconds Before Repeat"
/* MaxLen: Comment: */

&SCOPED-DEFINE mgbdpro_p_18 "Repeat Processing"
/* MaxLen: Comment: */

&SCOPED-DEFINE mgbdpro_p_19 "WARNING: Switching to new load procedure : "
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


define variable batchdata as character format "x(20)":U
  label {&mgbdpro_p_5}.
define variable exceptionfile as character format "x(20)":U
  label {&mgbdpro_p_15}.
define variable repeat_process like mfc_logical
  label {&mgbdpro_p_18} .
define variable pause_seconds as integer
  label {&mgbdpro_p_17} format ">>>>9":U
  init 300.
/*G1J4*  def var linefield as char extent 40 format "x(40)".  */
/*G1J4*/ define variable linefield as character extent 40 format "x(80)":U.
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
define variable from_id like bdl_id init 0.
define variable to_id like bdl_id init 99999999.
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

define variable go_on like mfc_logical init yes.

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
  label {&mgbdpro_p_16}.
define variable file_name as character format "x(20)":U
  label {&mgbdpro_p_14}.
define stream cim_load.
/*G2GW*/ define variable bdl_recno as recid no-undo.

DEFINE INPUT PARAMETER i_name AS CHAR FORMAT "x(20)".     /*yangxing 2006-05-30*/
DEFINE INPUT PARAMETER o_name AS CHAR FORMAT "x(20)".    /*yangxing 2006-05-30*/

lastbatchrun = batchrun.

start_date = today.
start_time = string(time, "HH:MM:SS":U).

/* Retrieve the next CIM process session number */
do on error undo, return ERROR:
  run get_CIM_session (OUTPUT session_no).
end.

/* Set up input and output streams */
work_i_file = mfguser + ".bpi".
work_o_file = mfguser + ".bpo".

         /* SELECT FORM */
/*J0FF* - Replaced GUI converted form */
/*J0FF*/ 
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
/*J0FF*/   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
skip(1)
/*J0FF*/   from_id             colon 30
/*J0FF*/   to_id               label {t001.i}
/*J0FF*/   skip(1)
/*J0FF*/   repeat_process      colon 35 view-as toggle-box
/*J0FF*/   skip(1)
/*J0FF*/   pause_seconds       colon 35
/*J0FF*/   skip(1)
/*J0FF*/   process_file        colon 35 view-as toggle-box
/*J0FF*/   skip(1)
/*J0FF*/   file_name           colon 35
/*J0FT*/   skip(1)
/*J0FF*/ with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/*J0FF - Commented out converted GUI form */
/* FORM /*GUI*/
**   RECT-FRAME       AT ROW 1 COLUMN 1.25
**   RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
**   SKIP(.1)  /*GUI*/
**   skip(1)
**   from_id              colon 30
**   to_id                label {t001.i}
**   skip(1)
**   repeat_process       colon 35 view-as toggle-box
**   skip(1)
**   pause_seconds        colon 35
**   skip(1)
**   process_file              colon 35 view-as toggle-box
**   skip(1)
**   file_name                   colon 35
**     with frame a side-labels width 80 attr-space NO-BOX THREE-D. /*GUI*/
**
** define variable F-a-title AS CHARACTER INITIAL "".
** RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
** RECT-FRAME-LABEL:HIDDEN in frame a = yes.
** RECT-FRAME:HEIGHT-PIXELS in frame a =
**   FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
** RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/ */

mainloop:
repeat:

/*J0FF - Added V8 comment*/
/*J0FF*/       hide all no-pause.
  if global-tool-bar and global-tool-bar-handle <> ? then
    view global-tool-bar-handle.
 /* view frame a.*/
/*J0FF*/   input from terminal.  

  /*update from_id to_id repeat_process pause_seconds
    process_file file_name with frame a.*/

   PROCESS_file = YES.                              /*yangxing 2006-05-30  specify execute cimload using file method*/
   FILE_name = i_name.                              /*yangxing 2006-05-30*/


  output stream errorlog close.
  /*{mfselprt.i "e:\b.prn" 132 page "stream errorlog" append}    yangxing 2006-05-30*/
  OUTPUT STREAM errorlog TO value(o_name) APPEND.             /*yangxing 2006-05-30*/      

/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.


  row_count = 0.

  if process_file then do:
    run setup_input(INPUT file_name,
                    OUTPUT execname,
                    OUTPUT new_file).
    if new_file then
      run process_by_screen.
    else
      run process_all.
    os-delete value(work_i_file).
    os-delete value(work_o_file).
/*J13D*/    if not go_on then
/*J13D*/      function_errors = function_errors + 1.

/*J13D*/    group_count = 1.

/*J13D*/    put stream errorlog skip(1) {&mgbdpro_p_8}
/*J13D*/      today space(1)
/*J13D*/      string(time,"HH:MM:SS":U) skip.
/*J13D*/    put stream errorlog unformatted
/*J13D*/      {&mgbdpro_p_9} group_count
/*J13D*/      {&mgbdpro_p_4} progress_errors
/*J13D*/      {&mgbdpro_p_1} function_warnings
/*J13D*/      {&mgbdpro_p_7} function_errors
/*J13D*/      skip(1).
    /*next mainloop.*/
    LEAVE.                                     /*yangxing 2006-05-30 quit the loop*/
  end.


  do transaction on error undo, return ERROR:
    run check_CIM(INPUT session_no,
                  INPUT from_id,
                  INPUT to_id,
                  INPUT repeat_process,
                  INPUT pause_seconds,
                  INPUT start_date,
                  INPUT start_time,
                  INPUT FALSE).
  end.
 /* Set to first so no-find run doesn't set it from given  1st number to 0. */
  last_id = from_id.

  bcdparm = "".
  {mfquoter.i from_id}
  {mfquoter.i to_id}
  {mfquoter.i repeat_process}
  {mfquoter.i pause_seconds}

/*J0FF - Commented out GUI converted code */
/* /*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.*/

  repeat:
    group_count = 0.
    writing_function_data = no.
/*J13D*    progress_errors = 0.
 *J13D*    function_warnings = 0.
 *J13D*    function_errors = 0. *J13D*/

    put stream errorlog skip(1) {&mgbdpro_p_11}
      today space(1)
      string(time,"HH:MM:SS":U)
      format "x(8)":U skip.

    first_shot = yes.

    find_bdl:
    repeat:
      do transaction on error undo, leave mainloop:
        run check_CIM(INPUT session_no,
                      INPUT from_id,
                      INPUT to_id,
                      INPUT repeat_process,
                      INPUT pause_seconds,
                      INPUT start_date,
                      INPUT start_time,
                      INPUT TRUE).

        looptdo:
        repeat:
/* Retrieve batch data load master record (bdl_mstr) */
          if first_shot then
/*G2GW      find first bdl_mstr exclusive-lock where bdl_source = "" */
/*G2GW*/    find first bdl_mstr no-lock where bdl_source = ""
              and bdl_id >= from_id and bdl_id <= to_id
              no-error no-wait.
          else
/*G2GW      find next bdl_mstr exclusive-lock where bdl_source = "" */
/*G2GW*/    find next bdl_mstr no-lock where bdl_source = ""
              and bdl_id >= from_id and bdl_id <= to_id
              no-error no-wait.

            first_shot = no.

            if not available bdl_mstr then leave find_bdl.

/*G2K1 /*G2GW*/ bdl_recno = recid(bdl_mstr).  */
/*G2K1*/    if bdl_date_pro <> ? then next looptdo.
/*G2K1*/    bdl_recno = recid(bdl_mstr).
/*G2K1*/    find bdl_mstr where recid(bdl_mstr) = bdl_recno
/*G2K1*/    exclusive-lock no-error no-wait.
/*G2K1*/    if locked bdl_mstr then next looptdo.
            if bdl_date_pro = ? then leave looptdo.
            next looptdo.
          end.

/* Set processing date and time to now */
/****G2K1
/*G2GW*/  find bdl_mstr where recid(bdl_mstr) = bdl_recno
/*G2GW*/  exclusive-lock no-error no-wait.
***********/
          bdl_date_pro = today.
          bdl_time_pro = string(time,"HH:MM:SS":U).

          current_bdl_source = bdl_source.
          current_bdl_id = bdl_id.
          lastexecname = execname.
          execname = bdl_exec.
          release bdl_mstr.
        end.

        find first bdld_det no-lock
          where bdld_source = current_bdl_source and
          bdld_id = current_bdl_id and
          (bdld_data begins "@ACTION":U) no-error.
/*J13D*/ group_count = group_count + 1.
        if available bdld_det then
          run process_by_screen.
        else
          run process_all.

        do transaction:
          find bdl_mstr exclusive-lock where
            bdl_source = current_bdl_source
            and bdl_id = current_bdl_id.

          bdl_pgm_errs = group_function_errors.
          bdl_pro_errs = group_progress_errors.

          if not go_on then do:
            bdl_pgm_errs = 1.
            function_errors = function_errors + 1.
          end.

/*J13D*   group_count = group_count + 1. *J13D*/
          last_id = bdl_id.
        end.
      end.

      put stream errorlog skip(1) {&mgbdpro_p_8}
        today space(1)
        string(time,"HH:MM:SS":U) skip.
      put stream errorlog unformatted
        {&mgbdpro_p_9} group_count
        {&mgbdpro_p_4} progress_errors
        {&mgbdpro_p_1} function_warnings
        {&mgbdpro_p_7} function_errors
        skip(1).

/* Remove the temporary input and output files */
       os-delete value(work_i_file).
       os-delete value(work_o_file).

      /*{mfrtrail.i "stream errorlog"}*/                   /*yangxing 2006-05-30*/
       OUTPUT STREAM errorlog CLOSE.                       /*yangxing 2006-05-30*/

      if not repeat_process then leave.
        pause pause_seconds.

      /*{mfselp01.i printer 132 page "stream errorlog" append}*/                   /*yangxing 2006-05-30*/
      from_id = last_id. /* DONT RE-READ WHAT WE ALREADY LOOKED AT */
    end.
  end.

  do transaction:
    find qad_wkfl exclusive-lock where qad_key1 = "Cim Process Session":U and
      qad_key2 = session_no no-error.

    if available qad_wkfl then do:
      delete qad_wkfl.
    end.
  end.

/**********************************************************************************************
Purpose:
  Handles CIM processing for new, object-orientated screens.
Parmeters:
  None, but uses the following file global variables:
    function_errrors:  number of program errors encountered
    function_warnings:  number of program warnings encountered
    process_file:  logical value of whether to process file directly
    file_name:  name of flat file to process directly
    execname: name of screen to be executed
    errorlog: stream where processing results are stored
    work_o_file: name of temporary output file
    work_i_file: name of temporary input file
  Also uses the following temporary table:
    template-table
      exec-name:  name of executable file
      group-name:  name of group
      field-name:  name of field within group
      field-value: value for field, group, executable combination
Notes:
**********************************************************************************************/
procedure process_by_screen:
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
  define variable first_time as logical initial TRUE no-undo.
  define variable save_appl_boxes as logical  no-undo.
  define variable save_sys_boxes as logical no-undo.
  define variable error_value as character initial "" no-undo.

/*J13D*  function_errors = 0.
 *J13D*  function_warnings = 0. *J13D*/
  if process_file then
    input stream cim_load from value(file_name).
  lastbatchrun=batchrun.
  batchrun=TRUE.
  save_appl_boxes=session:appl-alert-boxes.
  save_sys_boxes=session:system-alert-boxes.
  session:appl-alert-boxes=FALSE.
  session:system-alert-boxes=FALSE.

  new_pgm_loop:
  repeat:
/* Determine if program actually exists... */
    {gprun.i ""mgbdpro1.p"" "(input execname, output go_on)"}.
/*... if so then execute persistently and perform setup ... */
    if go_on then do:
      pause 0 .
      if valid-handle(h_screen) then
        apply "CLOSE":U to h_screen.
      do on error undo, leave on endkey undo, leave:
/*J0W6*/    {gprun.i execname "PERSISTENT SET h_screen"}
/*J0W6* /*J0FF*/   {gprun.i execname "'PERSISTENT SET h_screen'"}*/
/*J0FF     run value(execname) persistent set h_screen.*/
        run q-startup in h_screen.
        run q-initialize in h_screen.
      end.
    end.
/*... otherwise, send error to log and leave procedure with error */
    else do:
      put stream errorlog unformatted {&mgbdpro_p_12} space current_bdl_id space.
      put stream errorlog unformatted {&mgbdpro_p_10} execname skip(1).
      error_value = "ERROR":U.
      leave new_pgm_loop.
    end.

/* Process each screen individually */
    screen_break:
    repeat:
/* Setup streams for CIM load file (work_o_file) and PROGRESS errors (work_i_file) */
      output stream copy_file to value(work_o_file).
      output to value(work_i_file) keep-messages.
/* Process each line of data */
      field_process:
      repeat:
/* If inputting from a file then read in line of data ...*/
        if process_file then do:
          linedata="".
          readkey stream cim_load.
          do while lastkey <> keycode("RETURN":U) and lastkey >=0:
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
/*J171*/    if(linedata="@PROCESS":U) then
/*J171*/      error_value="DONE":U.
/*J171*/    else
              error_value = "ERROR":U.
            leave screen_break.
          end.
          linedata = bdld_data.
          current_line = bdld_line.
        end.
/* If c_loadproc is not blank, send data through user defined process */
/* if linedata is blank on return, then skip internal processing                */
        if c_loadproc <> "" then do:
          run value(c_loadproc) (INPUT-OUTPUT linedata).
          if linedata = "" then
            next field_process.
        end.
/* Keyword @LOADPROC identifies a user defined process to be executed */
        if substr(linedata,1,9) = "@LOADPROC":U then do:
          c_loadproc = trim(substr(linedata,10)).
          put stream errorlog unformatted {&mgbdpro_p_19} c_loadproc skip.
          next field_process.
        end.
/* Keyword @ACTION defines how data is to be handled, will be followed */
/* by either an EDIT or DELETE to identify what to do, otherwise generates */
/* an error                                                                                                        */
        if substr(linedata,1,7) = "@ACTION":U then do:
          c_process_type = trim(substr(linedata,8)).
          if not c_process_type = "EDIT":U and
             not c_process_type = "DELETE":U then do:
            put stream errorlog unformatted {&mgbdpro_p_13} c_process_type skip(1).
            error_value = "ERROR":U.
            leave screen_break.
          end.
/* Write copy of this input to temporary file (prepend @@BATCHLOAD, as */
/* this would have occurred before the redirection keywords                       */
          if err_out_file <> "" or suc_out_file <> "" then do:
            if first_time then do:
              first_time=FALSE.
              put stream copy_file unformatted "@@BATCHLOAD ":U execname skip.
            end.
            put stream copy_file unformatted linedata skip.
          end.
          next field_process.
        end.
/* On encountering @@BATCHLOAD, determine if the same screen will         */
/* be executed, if so then proceed to retrieve the next line of data, otherwise */
/* setup the new program by jumping out to the new_pgm_loop.                         */
        if substr(linedata,1,11) = "@@BATCHLOAD":U then do:
          templine = trim(substr(linedata,12)).
          if templine <> execname then do:
            execname=templine.
            error_value = "RETRY":U.
            leave screen_break.
          end.
          next field_process.
        end.
/* Keyword @@END signifies the end of the CIM file - leave the program */
        if substr(linedata,1,5) = "@@END":U then do:
          error_value = "DONE":U.
          leave screen_break.
        end.
/* Keyword @PROCESS means all data has been loaded and should now */
/* be processed by the screen, leave field_process to process data     */
        if linedata = "@PROCESS":U then
          leave field_process.
/* Keyword @ERRORDATAFILE determines an user defined file for saving */
/* CIM transactions which were unsuccessfully processed                          */
         if substr(linedata,1,14) = "@ERRORDATAFILE":U then do:
          err_out_file = trim(substr(linedata, 15)).
/* If the file exists, it is deleted */
          os-delete value(err_out_file).
          next field_process.
        end.
/* Keyword @SUCCESSDATAFILE determines an user defined file for saving */
/* CIM transactions which were successfully processed                                  */
        if substr(linedata,1,16) = "@SUCCESSDATAFILE":U then do:
          suc_out_file = trim(substr(linedata, 17)).
/* If the file exists, it is deleted */
          os-delete value(suc_out_file).
          next field_process.
        end.
/* Keyword @DEFAULTSFILE defines a file containing template data to be */
/* used for this CIM process                                           */
/*J171*/ if substr(linedata,1,13) = "@DEFAULTSFILE":U then do:
           template_file = trim(substr(linedata, 14)).
/* If template file is blank, then remove all templates in work file ... */
          if template_file = "" then do:
            for each template-table exclusive-lock:
              delete template-table.
            end.
          end.
/* ... otherwise, add new template to the work file */
          else do:
            input stream temp_load from value(search(template_file)) no-echo.
            first_load=TRUE.
/* Read and process each line */
            load_temp:
            repeat:
              templine = "".
              readkey stream temp_load.
              do while lastkey <> keycode("RETURN":U) and lastkey >= 0:
                templine = templine + chr(lastkey).
                readkey stream temp_load.
              end.
              if templine = "" then leave load_temp.
/* First line is the name of the executable to which template applies ...*/
               if first_load then do:
                temp_load_exec=templine.
                first_load=FALSE.
              end.
/*... other lines contain "group" "field" "value" data */
              else do:
                create template-table.
                template-table.exec-name = temp_load_exec.
                i=index(templine,"""":U).
                j=index(templine,"""":U,i + 1).
                template-table.group-name = substr(templine,i,j - i + 1).
                i=index(templine,"""":U,j + 1).
                j=index(templine,"""":U,i + 1).
                template-table.field-name = substr(templine,i,j - i + 1).
                i=index(templine,"""":U,j + 1).
                j=index(templine,"""":U,i + 1).
                template-table.field-value = substr(templine,i,j - i + 1).
              end.
            end.
          end.
          output stream temp_load close.
          next field_process.
        end.
/* If there is a template file loaded, check if data exists in a template */
        if template_file <> "" then do:
          i=index(linedata,"""":U).
          j=index(linedata,"""":U,i + 1).
          if i > 0 then do:
            grp_name=substr(linedata,i,j - i + 1).
            i=index(linedata,"""":U,j + 1).
            j=index(linedata,"""":U,i + 1).
          end.
          if i > 0 then do:
            fld_name=substr(linedata,i,j - i + 1).
/* Find a template record which matches the executable name, group name */
/* and field name                                                                                              */
            find first template-table where
              template-table.exec-name = execname and
              template-table.group-name = grp_name and
              template-table.field-name = fld_name no-error.
/* If a record is found then replace the data with the template data */
            if available template-table then
              linedata = """":U + grp_name + """ """:U + fld_name + """ """:U + template-table.field-value + """":U.
          end.
        end.

/* Write the resulting data out to the temporary file */
        if err_out_file <> "" or suc_out_file <> "" then do:
         put stream copy_file unformatted linedata skip.
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
/* If only two fields, assume it was field name and value (Group is optional) */
         if c-temp <> "" then
          c-value = substring(c-temp,1,length(c-temp)).
        else
          assign
            c-value = c-field
            c-field = c-group
            c-group = "".

/* Get rid of white spaces and outermost quotes */
          c-group = trim(trim(c-group),'"').
          c-field = trim(trim(c-field),'"').
          c-value = trim(trim(c-value),'"').

/* Move data into data storage object */
        run q-set-data in h_screen(INPUT c-group,INPUT c-field,INPUT c-value).
        temp_line=current_line.
      end.  /* field_process */

/* Write keyword @PROCESS to temporary file */
      if err_out_file <> "" or suc_out_file <> "" then do:
        put stream copy_file unformatted "@PROCESS":U skip.
      end.

      output stream copy_file close.

/* Process data residing in window's data storage object: First move the data       */
/* from the data storage object into the screen and execute the desired                 */
/* processing (EDIT or DELETE) through the processing logic object, then retrieve  */
/* error and warning messages through the window's message object                  */
      session:appl-alert-boxes=TRUE.
      session:system-alert-boxes=TRUE.
      run q-process-data in h_screen(INPUT c_process_type) no-error.
      run q-get-msg in h_screen(OUTPUT c_msg,OUTPUT c_err_count,OUTPUT c_warn_count).
      output close.

      group_progress_errors=0.
      group_function_errors=c_err_count.
      function_errors = function_errors + c_err_count.
      function_warnings = function_warnings + c_warn_count.

/* Process any PROGRESS and validation errors (could not be re-directed) */
      input stream temp_load from value(work_i_file) no-echo.
      load_error:
      repeat:
        templine = "".
        readkey stream temp_load.
        do while lastkey <> keycode("RETURN":U) and lastkey >= 0:
          templine = templine + chr(lastkey).
          readkey stream temp_load.
        end.
        if templine = "" then leave load_error.
        if substr(templine,1,2) = "**":U then do:
          progress_errors = progress_errors + 1.
          group_progress_errors = group_progress_errors + 1.
          put stream errorlog unformatted {&mgbdpro_p_6} current_bdl_id space templine skip.
        end.
      end.
      input stream temp_load close.

/* Write program errors and warnings to error log */
      repeat i = 1 to num-entries(c_msg,"'"):
        if substr(entry(i,c_msg,"'"),1,2) = "**":U then
          group_progress_errors = group_progress_errors + 1.
        put stream errorlog unformatted entry(i,c_msg,"'") skip.
      end.

/* Concatenate successful screen transaction to user defined file */
        if (group_progress_errors = 0 and group_function_errors = 0) and suc_out_file <> ""  then do:
          os-append value(work_o_file) value(suc_out_file).
        end.

/* Concatenate failed screen transaction to user defined file */
        if (group_progress_errors > 0 or group_function_errors > 0) and err_out_file <> ""  then do:
          os-append value(work_o_file) value(err_out_file).
        end.

        last_line = current_line.
/* /*J13D*/ group_count=group_count + 1.*/
      end.  /* screen_break */

      output stream copy_file close.
      output close.
/* Starting a new screen, jump to beginning of new_pgm_loop */
      if error_value = "RETRY":U then
        next new_pgm_loop.
/* Finished processing, either due to error or reached @@END keyword*/
      if error_value = "ERROR":U or error_value = "DONE":U then
        leave new_pgm_loop.
    end.  /* new_pgm_loop */

/* Reset all values and perform any necessary cleanup */
    batchrun = lastbatchrun.
    if process_file then
      input stream cim_load close.
    if valid-handle(h_screen) then
      apply "CLOSE":U to h_screen.
    session:appl-alert-boxes=save_appl_boxes.
    session:system-alert-boxes=save_sys_boxes.

  if error_value = "ERROR":U then
/*J13D*/    return "ERROR":U.
/*J13D*    return ERROR. */

  return "".

end.

/**********************************************************************************************
Purpose:
  Handles CIM processing for pre-8.5 MFG/PRO applications.
Parmeters:
  None, but uses the following file global variables:
    function_errrors:  number of program errors encountered
    function_warnings:  number of program warnings encountered
    process_file:  logical value of whether to process file directly
    file_name:  name of flat file to process directly
    execname: name of screen to be executed
    errorlog: stream where processing results are stored
    work_o_file: name of temporary output file
    work_i_file: name of temporary input file
Notes:
  Old CIM format files require processing through input/output files since there
  is no other way to direct input into the screen and no other way to retrieve
  errors and warnings during the processing.
**********************************************************************************************/
procedure process_all:

  define variable linedata as character no-undo.
  define variable current_line as integer initial -1 no-undo.
  define variable save_appl_boxes as logical no-undo.
  define variable save_sys_boxes as logical no-undo.
/*J0FF*/  define variable l-first as logical initial TRUE no-undo.

/*J0FF  function_errors = 0.*/
/*J0FF  function_warnings = 0.*/
  if process_file then
    input stream cim_load from value(file_name).
  lastbatchrun = batchrun.
  save_appl_boxes = session:appl-alert-boxes.
  save_sys_boxes = session:system-alert-boxes.
  session:appl-alert-boxes = FALSE.
  session:system-alert-boxes = FALSE.

/*J0FF removed old_pgm_loop: processing occurs one batch at a time*/
/*  old_pgm_loop:
**  repeat:*/
    output to value(work_i_file).
/*  Retrieve batch data load detail (bdld_det) for this batch data load master (bdl_mstr) */
    old_line_process:
    repeat:
      if process_file then do:
        linedata = "".
        readkey stream cim_load.
        do while lastkey <> keycode("RETURN":U) and lastkey >= 0:
          linedata = linedata + chr(lastkey).
          readkey stream cim_load.
        end.
/*J0W6*/ if(lastkey<0) then
/*J0W6*/   leave old_line_process.
      end.
      else do:
        find first bdld_det no-lock where
          bdld_source = current_bdl_source and
          bdld_id = current_bdl_id and
          bdld_line > current_line no-error.
/*J0FF - if no record, but found previous record, process data */
/*J0FF*/        if((not available(bdld_det)) and (not l-first)) then
/*J0FF*/          leave old_line_process.
/*J0FF - if no record and no previous data, return */
/*J0FF*/  if((not available(bdld_det)) and (l-first)) then do:
/*J0FF*/    output close.
/*J0FF*/    return "".
/*J0FF*/  end.
/*J0FF*/ l-first=FALSE.
        linedata = bdld_data.
        current_line = bdld_line.
      end.

/* Write data to output file */
      if substr(linedata,1,11) = "@@BATCHLOAD":U then do:
        execname = trim(substr(linedata,12)).
        next old_line_process.
      end.
/*J0W6*       if substr(linedata,1,5) = "@@END":U then do:*/
/*J0W6*/      if(substr(linedata,1,5) = "@@END":U and not process_file) then do:
        leave old_line_process.
      end.
/*J0W6*/ if(substr(linedata,1,5)<>"@@END":U) then do:
      if linedata = "" then
        put skip(1).
      else
        put unformatted linedata skip.
/*J0W6*/ end.
    end.
    output close.

    {gprun.i ""mgbdpro1.p"" "(input execname, output go_on)"}
    if go_on then do:
      input from value(work_i_file) no-echo.
/*J0FF ************************************************************************/
       /* V 7 OF PROGRESS DOES NOT ACT LIKE V 6. INSTEAD OF WRITING           */
       /* THE PROGRESS MESSAGES TO THE FILE, MESSAGES ARE WRTTTEN TO THE      */
       /* TERMINAL. ADDING "KEEP-MESSAGES" MAKES PROGRESS 7 WORK LIKE         */
       /* PROGRESS 6.                                                         */
/*J0FF ***********************************************************************/

/*J0FF**** /*F717*/          output to value(work_o_file).  ***/

/*J0FF*/          output to value(work_o_file) keep-messages.

/* Setup dtitle for callable program for reports that use it */
/*J0FT*/      find first mnd_det where mnd_exec=execname no-lock no-error.
/*J0FT*/      {mfmenu.i}
/*J0FT*/      batchrun=yes.
      dtitle = lc(execname).

/*J0FT*/      pause 0 before-hide.

/*J0FT*/ /*V8+*/
/*J0FT*/          do on error undo, leave on endkey undo, leave:
/*J0FT*/            {gprun.i ""gpwinrun.p"" "(execname, 'CIM')"}.
/*J0FT*/          end.
/*J0FT*/      batchrun = lastbatchrun.   

      pause before-hide.

      output close.
      input close.
      execname = lastexecname.

/* Now let's look for errors in the function output file */
      group_progress_errors = 0.
      group_function_errors = 0.

      if process_file then
        return "".

      input from value(work_o_file) no-echo.

      repeat:
/* Clear all elements */
        linefield = "".
        set linefield with width 255.
/* Output error lines to report. */
        if linefield[1] = "**":U or
           linefield[1] = "WARNING: ":U or
           linefield[1] = "ERROR: ":U  then do:
/*J2M0**  put stream errorlog unformatted {&mgbdpro_p_3} space current_bdl_id space. */
          put stream errorlog unformatted {&mgbdpro_p_6} space current_bdl_id space.  /*J2M0*/
          do i = 1 to 40:
            if linefield[i] = "" then leave.
            put stream errorlog unformatted linefield[i] space.
          end.
/* index of last word */
          i = i - 1.
          put stream errorlog skip(1).
        end.

/* Count warning/error messages by type */
        if linefield[1] = "**":U then do:
          if ( linefield[2] = "tr_hist":U  and linefield[i] = "(132)":U ) or
             ( linefield[2] = "op_hist":U and linefield[i] = "(132)":U )  then
            function_warnings = function_warnings + 1.
          else do:
            progress_errors = progress_errors + 1.
            group_progress_errors = group_progress_errors + 1.
          end.
        end.
        else
          if linefield[1] = "WARNING: ":U then
            function_warnings = function_warnings + 1.
          else
          if linefield[1] = "ERROR: ":U then do:
            function_errors = function_errors + 1.
            group_function_errors = group_function_errors + 1.
          end.
        end.

        input close.
      end. /* if go_on then do: */
      else do:
/*J2M0** put stream errorlog unformatted {&mgbdpro_p_3} space      */
/*J2M0** current_bdl_id space.                                     */
        put stream errorlog unformatted {&mgbdpro_p_6} space /*J2M0*/
        current_bdl_id space.                                /*J2M0*/
        put stream errorlog unformatted
          {&mgbdpro_p_10} execname skip(1).
/*J0FF*/ /* leave old_pgm_loop.*/
      end.
/*J0FF*/ /* end. /* old_pgm_loop */ */
    batchrun = lastbatchrun.
    if process_file then
      input stream cim_load close.
    session:appl-alert-boxes = save_appl_boxes.
    session:system-alert-boxes = save_sys_boxes.
end.

procedure get_CIM_session:

  define output parameter session_no as character.

  do transaction:
/* Find first CIM process session - leave if more than 999 CIM sessions*/
    do i = 0 to 999:
      find first qad_wkfl exclusive-lock where
        qad_key1 = "Cim Process Session":U    and
        qad_key2 > string(i, "999":U)
        use-index qad_index1 no-error.
      if not available qad_wkfl then leave.
      else if decimal(qad_key2) > i + 1 then leave.
    end.

    if i = 999 then do:
      bell.
      /* Too many CIM Load Sessions in operation */
      {mfmsg.i 1324 4}
      return ERROR.
    end.

    session_no = string(i + 1, "999":U).

    if available qad_wkfl then release qad_wkfl.

/* Set up CIM process session in qad_wkfl record */
    create qad_wkfl.
    qad_key1 = "Cim Process Session":U.
    qad_key2 = session_no.
    qad_datefld[1] = start_date.
    qad_charfld[1] = start_time.
    release qad_wkfl.

  end.
end.

procedure check_CIM:

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
    qad_key1 = "Cim Process Session":U and
    qad_key2 = session_no    no-error.

  if not available qad_wkfl or
    qad_datefld[1] <> start_date or
    qad_charfld[1] <> start_time or
    qad_key4 = "Kill":U then do:
    put stream  errorlog skip(1)
      {&mgbdpro_p_2}
      today string(time,"HH:MM:SS":U) format "x(8)":U skip.
    return ERROR.
  end.

  else do:
    qad_key1 = "Cim Process Session":U.
    qad_key2 = session_no.
    qad_datefld[2] = today.
    qad_charfld[2] = string(time, "hh:mm:ss":U).
    if in_loop then do:
      qad_key3 = "Processing":U.
      qad_charfld[3] = trim(string(from_id,"zzzzzzz9":U)) +
          "  " + trim(string(to_id,"zzzzzzz9":U)).
      qad_charfld[4] = trim(string(repeat_process)) +
          "  " + trim(string(pause_seconds,"zzzzzzz9":U)).
    end.
    else do:
      qad_key3 = "Waiting for input":U.
      qad_charfld[3] = "".
      qad_charfld[4] = "".
    end.
  end.
  release qad_wkfl.

end.


procedure setup_input:

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
    {mfmsg03.i 391 3 file_name '' ''}
    return "".
  end.

  function_to_run="".
  new_file=FALSE.

/* Open input stream */
  input stream temp_load from value(file_name).

do while not new_file:
/* Get the current row */
  linedata="".
  readkey stream temp_load.
  do while lastkey <> keycode("RETURN":U) and lastkey >= 0:
    linedata = linedata + chr(lastkey).
    readkey stream temp_load.
  end.

/* Get name of program to run */
  if substr(linedata,1,11) = "@@BATCHLOAD":U then
    function_to_run = trim(substr(linedata,12)).

    if substr(linedata,1,5) = "@@END":U  then
      leave.
    if substr(linedata,1,7) = "@ACTION":U then do:
      new_file=TRUE.
      leave.
    end.
  end.

  input stream temp_load close.

  return "".
end.
/*J09J*//* End reconstructed code */
/*J09J*/

/*J09J*/
/*J09J*//* Previous code obsoleted original code */
/*J09J*//* following code has been commented out */
/*         {mfdtitle.i "e+ "} /*GG47*/
**
**         def var batchdata as char format "x(20)" label "Batch Data File Name".
**         def var exceptionfile as char format "x(20)"
**          label "Exception File Name".
**         def var repeat_process like mfc_logical label "Repeat Processing" .
**         def var pause_seconds as int
**          label "Pause Seconds Before Repeat" format ">>>>9"
**            init 300.
**         def var linefield as char extent 40 format "x(40)".
**         def var linedata as char.
**         def var linedata2 as char.
**         def stream errorlog.
**         def var writing_function_data like mfc_logical.
**         def var i as int.
**         def var j as int.
**         def var group_count as int.
**         def var progress_errors as int.
**         def var function_warnings as int.
**         def var function_errors as int.
**         def var group_progress_errors as int.
**         def var group_function_errors as int.
**         def var from_id like bdl_id init 0.
**         def var to_id like bdl_id init 99999999.
**         def var last_id like bdl_id.
**         def var lastexecname as character.
**
** /*G132 /*F717*/ def var current_bdl_id as char. */
** /*G132*/ def var current_bdl_source like bdl_source.
** /*G132*/ def var current_bdl_id like bdl_id.
** /*F717*/ def var first_shot     like mfc_logical.
** /*F717*/ def var session_no     as   char.
** /*F717*/ def var start_date     as   date.
** /*F717*/ def var start_time     as   char.
** /*F717*/ def var work_i_file    as   char.
** /*F717*/ def var work_o_file    as   char.
**
** /*FS47*/ def var go_on like mfc_logical init yes.
**
** /*G0FB*/       def var save-sys-alert as logical.
** /*G0FB*/       def var save-app-alert as logical.
** /*GM66*/      def var lastbatchrun like batchrun.
**                    lastbatchrun = batchrun.
**
** /*F717*/ start_date = today.
** /*F717*/ start_time = string(time, "hh:MM:ss").
**
** /*F717*/ do transaction:
** /*F717*/    do i = 0 to 999:
** /*F717*/       find first qad_wkfl exclusive where
** /*F717*/          qad_key1 = "Cim Process Session"    and
** /*F717*/          qad_key2 > string(i, "999")
** /*F717*/          use-index qad_index1 no-error.
** /*F717*/
** /*F717*/       if not available qad_wkfl then leave.
** /*F717*/
** /*F717*/       else if decimal(qad_key2) > i + 1 then leave.
** /*F717*/    end.
** /*F717*/
** /*F717*/    if i = 999 then do:
** /*F717*/       bell.
** /*F717*/       message "Too many Cim Process Sessions in operation.".
** /*F717*/       pause.
** /*F717*/       return.
** /*F717*/    end.
**
** /*F717*/    session_no = string(i + 1, "999").
** /*F717*/
** /*F717*/    if available qad_wkfl then release qad_wkfl.
**
** /*F717*/    create qad_wkfl.
**
** /*F717*/    qad_key1 = "Cim Process Session".
** /*F717*/    qad_key2 = session_no.
** /*F717*/    qad_datefld[1] = start_date.
** /*F717*/    qad_charfld[1] = start_time.
**
** /*F717*/    release qad_wkfl.
** /*F717*/ end.
**
** /*F717*  work_i_file = "batloadi." + session_no. *GA22*/
** /*F717*  work_o_file = "batloado." + session_no. *GA22*/
** /*F717*/ work_i_file = mfguser + ".bpi".      /*GA22*/
** /*F717*/ work_o_file = mfguser + ".bpo".      /*GA22*/
**
**         /* SELECT FORM */
**         FORM /*GUI*/
**
**RECT-FRAME       AT ROW 1 COLUMN 1.25
**RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY **1
**SKIP(.1)  /*GUI*/
**skip(1)
**            from_id              colon 30
**            to_id                label {t001.i}
**            skip(1)
**            repeat_process       colon 35
**            pause_seconds        colon 35
**            skip(1)
**         with frame a side-labels width 80 attr-space NO-BOX THREE-D. /*GUI*/
**
**DEF VAR F-a-title AS CHAR INITIAL "".
**RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
**RECT-FRAME-LABEL:HIDDEN in frame a = yes.
**RECT-FRAME:HEIGHT-PIXELS in frame a =
** FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
**RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/
**
** /*F717*/ mainloop:
**         repeat:
**
** /*GM66*/      hide all no-pause.
**            if global-tool-bar and global-tool-bar-handle <> ? then
**               view global-tool-bar-handle.
**            view frame a.
**            input from terminal.
**
** /*F717*/    do transaction:
** /*F717*/       find qad_wkfl exclusive where
** /*F717*/          qad_key1 = "Cim Process Session" and
** /*F717*/          qad_key2 = session_no    no-error.
**
** /*F717*/       if not available qad_wkfl or
** /*F717*/         qad_datefld[1] <> start_date or
** /*F717*/         qad_charfld[1] <> start_time or
** /*F717*/         qad_key4 = "Kill" then do:
** /*F717*/           put stream  errorlog skip(1)
** /*F717*/         "Cim Process Session terminated due to loss of session record "
** /*F717*/          today string(time,"HH:MM:SS") format "x(8)" skip.
** /*F717*/           leave mainloop.
** /*F717*/       end.
**
** /*F717*/       else do:
** /*F717*/          qad_datefld[2] = today.
** /*F717*/          qad_charfld[2] = string(time, "hh:mm:ss").
** /*F717*/          qad_key3 = "Waiting for input".
** /*F717*/          qad_charfld[3] = "".
** /*F717*/          qad_charfld[4] = "".
** /*F717*/       end.
**
** /*F717*/       release qad_wkfl.
** /*F717*/    end.
**
**            update from_id to_id repeat_process pause_seconds with frame a.
**           /* Set to first so no-find run doesn't set it from given *
**          * 1st number to 0. */
** /*G165*/    last_id = from_id.
**
**            bcdparm = "".
**            {mfquoter.i from_id}
**            {mfquoter.i to_id}
**            {mfquoter.i repeat_process}
**            {mfquoter.i pause_seconds}
**
** /*GM66*/      output stream errorlog close.
**            {mfselprt.i "printer" 132 page "stream errorlog" append}
** /*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-
**FRAME:Y in frame a - 2.
**
**
**            repeat:
**               group_count = 0.
**               writing_function_data = no.
**               progress_errors = 0.
**               function_warnings = 0.
**               function_errors = 0.
**
**               put stream errorlog skip(1) "Batch Data Load starting "
**             today space(1)
**               string(time,"HH:MM:SS")
**               format "x(8)" skip.
**
** /*F717*/       first_shot = yes.
**
** /*FU36*/       find_bdl:
** /*F717*/       repeat:
** /*F717*/          do transaction:
** /*F717*/             find qad_wkfl exclusive where
** /*F717*/                qad_key1 = "Cim Process Session" and
** /*F717*/                qad_key2 = session_no    no-error.
**
** /*F717*/             if not available qad_wkfl or
** /*F717*/                        qad_datefld[1] <> start_date or
** /*F717*/                        qad_charfld[1] <> start_time or
** /*F717*/                        qad_key4 = "Kill" then do:
** /*F717*/                put stream  errorlog skip(1)
** /*F717*/                 "Cim Process Session terminated due to loss"
** /*F717*/                 " of session record "
** /*F717*/                 today string(time,"HH:MM:SS") format "x(8)" skip.
** /*F717*/             leave mainloop.
** /*F717*/          end.
**
** /*F717*/          else do:
** /*F717*/             qad_datefld[2] = today.
** /*F717*/             qad_charfld[2] = string(time, "hh:mm:ss").
** /*F717*/             qad_key3 = "Processing".
** /*F717*/             qad_charfld[3] = trim(string(from_id, "zzzzzzz9"))
**                                 + "   " + trim(string(to_id, "zzzzzzz9")).
** /*F717*/             qad_charfld[4] = trim(string(repeat_process)) + "   " +
** /*F717*/                           trim(string(pause_seconds, "zzzzzzz9")).
** /*F717*/          end.
**
** /*F717*/          release qad_wkfl.
**
** /*FU36*
** * /*F717*/       if first_shot then
** * /*F717*/       find first bdl_mstr exclusive where bdl_source = "" /*7.0*/
** * /*F717*/                       and bdl_id >= from_id and bdl_id <= to_id
** * /*F717*/                       and bdl_date_pro = ? no-error no-wait.
** *
** * /*F717*/       else find next bdl_mstr exclusive where bdl_source = ""
** * /*F717*/                       and bdl_id >= from_id and bdl_id <= to_id
** * /*F717*/                       and bdl_date_pro = ? no-error no-wait.
** *FU36*/
**
** /*FU36*/          looptdo:
** /*FU36*/          repeat:
** /*FU36*/             if first_shot then
** /*FU36*/                find first bdl_mstr exclusive where bdl_source = ""
** /*FU36*/                   and bdl_id >= from_id and bdl_id <= to_id
** /*FU36*/                   no-error no-wait.
** /*FU36*/             else
** /*FU36*/                find next bdl_mstr exclusive where bdl_source = ""
** /*FU36*/                   and bdl_id >= from_id and bdl_id <= to_id
** /*FU36*/                   no-error no-wait.
**
** /*F717*/             first_shot = no.
** /*FU36*
** * /*F717*/          if not available bdl_mstr then leave.
** *FU36*/
**
** /*FU36*/             if not available bdl_mstr then leave find_bdl.
** /*FU36*/             if bdl_date_pro = ? then leave looptdo.
** /*FU36*/             next looptdo.
** /*FU36*/          end.
**
** /*F717*/          bdl_date_pro = today.
** /*F717*/          bdl_time_pro = string(time,"HH:MM:SS").
**
** /*G132 /*F717*/   current_bdl_id = string(bdl_id). */
**
** /*G132*/          current_bdl_source = bdl_source.
** /*G132*/          current_bdl_id = bdl_id.
** /*F717*/          lastexecname = execname.
** /*F717*/          execname = bdl_exec.
** /*F717*/          release bdl_mstr.
** /*F717*/       end.
**
** /*F717      START OF COMMENTED OUT CODE
** *             for each bdl_mstr exclusive
** *             where
** *               bdl_source = "" /*7.0*/
** *               and bdl_id >= from_id and bdl_id <= to_id
** *               and bdl_date_pro = ?:
** *
** *
** *               output to batloadi.wrk.
** *F717*    END OF COMMENTED OUT CODE       */
**
** /*F717*/       output to value(work_i_file).
**
**               for each bdld_det no-lock
** /*G132*
** * /*F327      where bdld_source = bdl_source /*7.0*/ */
** * /*F327      and bdld_id = bdl_id:                  */
** * /*F717 /*F327*/ where bdld_source = string(bdl_id):*/
** * /*F717*/ /*F327*/ where bdld_source = current_bdl_id:
** *G132* */
**
** /*G132*/       where bdld_source = current_bdl_source
** /*G132*/       and bdld_id = current_bdl_id:
**
** /*D713*           put unformatted bdld_data. */
** /*D713*           put " " skip.              */
**
** /*D713*/          if bdld_data = "" then put skip(1).
** /*D713*/          else put unformatted bdld_data skip.
**               end.
**               output close.
**
**
**
** /*F717*        lastexecname = execname.        */
** /*F717*        execname = bdl_exec.            */
** /*F717*        input from batloadi.wrk no-echo.*/
** /*F717*        output to batloado.wrk.         */
**
** /*FS47*/       {gprun.i ""mgbdpro1.p"" "(input execname, output go_on)"}
** /*FS47*/       if go_on then do:
**
** /*F717*/          input from value(work_i_file) no-echo.
** /*F717*/          output to value(work_o_file).
**
** /*GG47* Setup dtitle for callable program for reports that use it, */
** /*GG47* ours won't be messed up since output is redirected.        */
**
** /*GG47*/          find first mnd_det where mnd_exec = execname
**                no-lock no-error.
**
** /*GG47* in case no menu detail use progname */
** /*GG47* Build dtitle from menu detail       */
**                  dtitle = lc(execname).
**                  {mfmenu.i}
**                  batchrun = yes.
**
** /*F717*           {gprun.i bdl_exec}*/
**
** /*FS61*/          pause 0 before-hide.
**          /*V8-*/
** /*GM66*/ /*V8+*/
** /*GM66*/          do on error undo, leave on endkey undo, leave:
** /*G0FB*/             {gprun.i ""gpwinrun.p"" "(execname, 'CIM')"}.
**                end.
**                batchrun = lastbatchrun.
** /*FS61*/          pause before-hide.
**
**                output close.
**                input close.
**                execname = lastexecname.
**
**               /* Now let's look for errors in the function output file */
**                group_progress_errors = 0.
**                group_function_errors = 0.
** /*F717*           input from batloado.wrk no-echo.*/
** /*F717*/          input from value(work_o_file) no-echo.
**
**                repeat:
** /*GA22* Clear all elements */
**                   linefield = "".
**                   set linefield with width 255.
**
**                  /* Output error lines to report. */
**                   if linefield[1] = "**"
** /*G877*/                  or linefield[1] = "WARNING: "
** /*G877*/                  or linefield[1] = "ERROR: "
**                   then do:
** /*F717*                 put stream errorlog unformatted
**                         "Group Id:" space bdl_id space.*/
** /*F717*/                put stream errorlog unformatted "Group Id:" space
** /*F717*/                current_bdl_id space.
**                      do i = 1 to 40:
** /*GA22*/                        if linefield[i] = "" then leave.
**                         put stream errorlog unformatted linefield[i] space.
**                      end.
** /*GA22* index of last word */
**                      i = i - 1.
**                      put stream errorlog skip(1).
**                   end.
**
**                  /* Count warning/error messages by type */
**                   if linefield[1] = "**" then do:
**                      if ( linefield[2] = "tr_hist"
**                         and linefield[i] = "(132)" )
**                      or ( linefield[2] = "op_hist"
**                         and linefield[i] = "(132)" )
** /*GA22*/                     then
**                         function_warnings = function_warnings + 1.
** /*GA22*/                     else do:
**                         progress_errors = progress_errors + 1.
**                         group_progress_errors = group_progress_errors + 1.
** /*GA22*/                     end.
**                   end.
**                   else
** /*G877*/                  if linefield[1] = "WARNING: " then
**                      function_warnings = function_warnings + 1.
**                   else
** /*G877*/                  if linefield[1] = "ERROR: " then do:
**                      function_errors = function_errors + 1.
**                      group_function_errors = group_function_errors + 1.
**                   end.
**                end.
**
**                input close.
** /*FS47*/      end.  /* if go_on then do: */
** /*FS47*/         else do:
** /*FS47*/            put stream errorlog unformatted "Group Id:" space
** /*FS47*/               current_bdl_id space.
** /*FS47*/            put stream errorlog unformatted
** /*FS47*/             "ERROR: Procedure does not exist -> " execname skip(1).
** /*FS47*/         end.
**
** /*F717*          bdl_date_pro = today.                  */
** /*F717*          bdl_time_pro = string(time,"HH:MM:SS").*/
**
** /*F717*/         do transaction:
**
** /*G132*
** * /*F717*/         find bdl_mstr exclusive where bdl_source = "" /*7.0*/
** * /*F717*/                      and bdl_id = integer(current_bdl_id).
** *G132*/
**
** /*G132*/            find bdl_mstr exclusive where
**                  bdl_source = current_bdl_source
** /*G132*/            and bdl_id = current_bdl_id.
**
**                  bdl_pgm_errs = group_function_errors.
**                  bdl_pro_errs = group_progress_errors.
**
** /*FS47*/         if not go_on then do:
** /*FS47*/            bdl_pgm_errs = 1.
** /*FS47*/                    function_errors = function_errors + 1.
** /*FS47*/         end.
**
**                  group_count = group_count + 1.
**                  last_id = bdl_id.
** /*F717*/         end.
**               end.
**
**               put stream errorlog skip(1) "Batch Data Load Complete "
**             today space(1)
**               string(time,"HH:MM:SS") skip.
**               put stream errorlog unformatted
**               "Groups processed " group_count
**               "  Progress errors " progress_errors
**               "  Program warnings " function_warnings
**               "  Program errors " function_errors
**               skip(1).
**
**               /* remove the temporary input and output files */ /*G297*/
** /*G297*/       {gpfildel.i &filename = work_i_file}
** /*G297*/       {gpfildel.i &filename = work_o_file}
**
**               {mfrtrail.i "stream errorlog"}
**
**               if not repeat_process then leave.
**               pause pause_seconds.
**
**               {mfselp01.i printer 132 page "stream errorlog" append}
**               from_id = last_id. /* DONT RE-READ WHAT WE ALREADY LOOKED AT */
**            end.
**         end.
**
** /*F717*/ do transaction:
** /*F717*/    find qad_wkfl exclusive where qad_key1 = "Cim Process Session" and
** /*F717*/                                  qad_key2 = session_no no-error.
**
** /*F717*/    if available qad_wkfl then do:
** /*F717*/       delete qad_wkfl.
** /*F717*/    end.
** /*F717*/ end.*/
/*J09J*//* End commented out code */
/*J09J*/

