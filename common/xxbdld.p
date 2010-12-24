/* xxmgbdld.p - Load batch CIM data into database for future processing.      */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION:Y0BG LAST MODIFIED: 10/27/10 BY: zy                  *bg          */
/*-Revision end---------------------------------------------------------------*/
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character           */

/*bg:直接处理来自文件设置为NO,方便CIM_PRO处理                                 */
/*bg*/{mfdtitle.i "0BYG"}
/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mgbdld_p_2 "Input File/Continuous Process Name"
/* MaxLen: Comment: */

&SCOPED-DEFINE mgbdld_p_3 "Batch Data Load Groups Entered"
/* MaxLen: Comment: */

&SCOPED-DEFINE mgbdld_p_5 "Input from File or Continuous Process (F/C)"
/* MaxLen: Comment: */

&SCOPED-DEFINE mgbdld_p_7 "File/Cont"
/* MaxLen: Comment: */

&SCOPED-DEFINE mgbdld_p_11 "To"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define variable datasource like mfc_logical
   label {&mgbdld_p_5}
   format {&mgbdld_p_7} initial yes.
define variable sourcename as character
   label {&mgbdld_p_2}
   format "x(32)".
define variable writing_data like mfc_logical.
define variable linedata as character.
define variable function_to_run as character.
define variable work_count as integer.
define variable i as integer.
define variable sets_entered as integer
   label {&mgbdld_p_3}.
define variable continuous like mfc_logical initial no.
define stream batchdata.
define workfile work_input field work_data as character.
define variable f_id like bdld_id.
define variable l_id like bdld_id label {&mgbdld_p_11} initial 0.

define variable bdl_recno     as   recid.
define variable next_id       like bdl_id.
define variable session_no    as   character.
define variable start_date    as   date.
define variable start_time    as   character.
define variable end_file      as logical.
define variable date_time     as character.
define variable l_sudden_exit like mfc_logical no-undo.

/* DELETING the qad_wkfl RECORD, WHEN THE USER EXITS BY */
/* PRESSING THE EXIT/X BUTTON OR EXITING FROM USER MENU */

/*zy*/ do transaction:
/*zy*/ /*initial variable*/
/*zy*/ find first qad_wkfl exclusive-lock where qad_domain = global_domain and
/*zy*/            qad_key1 = "mgbdpro" and qad_key2 = global_userid no-error.
/*zy*/ if avail qad_wkfl and not locked(qad_wkfl) then do:
/*zy*/   assign sourcename = qad_charfld[1].
/*zy*/ end.
/*zy*/ end. /*do transaction:*/

if not session:batch-mode
then do:
   on "END-ERROR":U of current-window anywhere
   do:
      run p-delete-qadwkfl in this-procedure.

      if valid-handle(self)
      then
         apply "END-ERROR":U to self.
   end. /* ON END-ERROR */
end. /* IF NOT SESSION:BATCH-MODE */

start_date = today.
start_time = string(time, "hh:MM:ss").

do transaction:
   do i = 0 to 999:
      find first qad_wkfl exclusive-lock  where qad_wkfl.qad_domain =
      global_domain and
         qad_key1 = "CIM Load Session" and
         qad_key2 > string(i, "999")
         use-index qad_index1 no-error.

      if not available qad_wkfl then leave.

      else if decimal(qad_key2) > i + 1 then leave.
   end.

   if i = 999 then do:
      bell.

      /* TOO MANY CIM LOAD SESSIONS IN OPERATION */
      {pxmsg.i &MSGNUM=1324 &ERRORLEVEL=1}

      pause.
      return.
   end.

   session_no = string(i + 1, "999").

   if available qad_wkfl then release qad_wkfl.

   create qad_wkfl. qad_wkfl.qad_domain = global_domain.

   assign
      qad_key1 = "CIM Load Session"
      qad_key2 = session_no
      qad_datefld[1] = start_date
      qad_charfld[1] = start_time.

   release qad_wkfl.
end.

/* SELECT FORM */
form
   skip(1)
   datasource   colon 44 skip
   sourcename   colon 44 skip(1)
   sets_entered colon 40 skip
   f_id         colon 40 space(2) l_id skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

main_loop:

repeat on stop undo, retry:

   l_sudden_exit = retry.
   if l_sudden_exit then leave.

   f_id = 0.

   do transaction:
      find qad_wkfl exclusive-lock  where qad_wkfl.qad_domain = global_domain
      and
         qad_key1 = "CIM Load Session" and
         qad_key2 = session_no    no-error.

      if not available qad_wkfl or
         qad_datefld[1] <> start_date or
         qad_charfld[1] <> start_time or
         qad_key4 = "Kill" then do:
         date_time = " " + string(today)
                   + " " + string(time,"HH:MM:SS").
         /* CIM PROCESS SESSION TERMINATED DUE TO LOSS OF SESSION RECORD */
         {pxmsg.i &MSGNUM=4686 &ERRORLEVEL=1 &MSGARG1=date_time}
         pause 10.
         leave main_loop.
      end.

      else do:
         assign
            qad_datefld[2] = today
            qad_charfld[2] = string(time, "hh:mm:ss")
            qad_charfld[3] = ""
            qad_charfld[4] = ""
            qad_key3 = "Waiting for Input".
      end.

      release qad_wkfl.
   end.

   update datasource sourcename with frame a.
   display "" @ sets_entered "" @ f_id "" @ l_id with frame a.
   if opsys <> "UNIX" and datasource = continuous then do:
       /* Continuous process not allowed for this op system */
      {pxmsg.i &MSGNUM=365 &ERRORLEVEL=3}
      undo, retry.
   end.

   if datasource <> continuous and search(sourcename) = ? then do:
      /* FILE DOES NOT EXIST */
      {pxmsg.i &MSGNUM=53 &ERRORLEVEL=3}
      undo, retry.
   end.
   find first qad_wkfl  where qad_wkfl.qad_domain = global_domain and
      qad_key1 = "CIM Load Session" and
      qad_key2 <> session_no        and
      qad_charfld[3] = string(datasource)   and
      qad_charfld[4] = sourcename use-index qad_index1
      no-lock no-error.

   if available qad_wkfl then do:
      bell.

      /* DATA SOURCE/NAME IN USE BY ANOTHER CIM LOAD SESSION */
      {pxmsg.i &MSGNUM=3732 &ERRORLEVEL=3}
      undo, retry.
   end.

   do transaction:
      find qad_wkfl exclusive-lock  where qad_wkfl.qad_domain = global_domain
      and
         qad_key1 = "CIM Load Session" and
         qad_key2 = session_no    no-error.

      if not available qad_wkfl or
         qad_datefld[1] <> start_date or
         qad_charfld[1] <> start_time or
         qad_key4 = "Kill" then do:
         date_time = " " + string(today)
                   + " " + string(time,"HH:MM:SS").
         /* CIM PROCESS SESSION TERMINATED DUE TO LOSS OF SESSION RECORD */
         {pxmsg.i &MSGNUM=4686 &ERRORLEVEL=1 &MSGARG1=date_time}
         pause 10.
         leave main_loop.
      end.

      else do:
         assign
            qad_datefld[2] = today
            qad_charfld[2] = string(time, "hh:mm:ss")
            qad_charfld[3] = string(datasource)
            qad_charfld[4] = sourcename
            qad_key3       = "Processing".
      end.
      release qad_wkfl.
   end.

   if datasource = continuous then
      input stream batchdata through value(sourcename) no-echo.
   else
      input stream batchdata from value(search(sourcename)) no-echo.

   assign
      writing_data = no
      sets_entered = 0.

   linedata = "".
   readkey stream batchdata.
   do while lastkey <> keycode("RETURN") and lastkey >= 0:
      linedata = linedata + chr(lastkey).
      readkey stream batchdata.
   end.

   end_file = no.
   read_and_create:
   do while lastkey >= 0 or lastkey = -2:
      if end_file then
         leave read_and_create.
      if lastkey = -2 then
         end_file = yes.

      if substring(linedata,1,11) = "@@batchload" then do:
         function_to_run = trim(substring(linedata,12)).
         writing_data = yes.
      end.

      else
         if substring(linedata,1,5) = "@@end"
         then do:
         if work_count > 0
         then do:
            do transaction:
               assign_bdl_id:
               repeat on error undo:

                  {mfnxtsq1.i "bdl_mstr.bdl_domain = global_domain
                               and bdl_source      = """"
                               and"
                               bdl_mstr
                               bdl_id
                               mf_sq04
                               next_id}

                  create bdl_mstr. bdl_mstr.bdl_domain = global_domain.

                  assign
                     bdl_mstr.bdl_source = ""
                     bdl_mstr.bdl_id = next_id
                     bdl_mstr.bdl_exec = function_to_run
                     bdl_mstr.bdl_date_ent = today
                     bdl_mstr.bdl_time_ent =
                     string(time,"HH:MM:SS").
                  leave assign_bdl_id.
               end. /* REPEAT ON ERROR UNDO */

               if f_id = 0
               then
                  f_id = bdl_mstr.bdl_id.

               l_id = bdl_mstr.bdl_id.

               if recid(bdl_mstr) = -1
               then
                  .
               release bdl_mstr.
            end. /* DO TRANSACTION */

            /* Changed the scope of the bdld_det creation loop to avoid lock
             * table overflow problems*/
            do:
               i = 0.
               for each work_input no-lock:
                  i = i + 1.
                  create bdld_det. bdld_det.bdld_domain = global_domain.

                  assign
                     bdld_source = ""
                     bdld_id = next_id
                     bdld_line = i
                     bdld_data = work_data.
               end.
               sets_entered = sets_entered + 1.
            end.

            release bdl_mstr.
            release bdld_det.

            do transaction:
               find qad_wkfl exclusive-lock  where qad_wkfl.qad_domain =
               global_domain and
                  qad_key1 = "CIM Load Session" and
                  qad_key2 = session_no    no-error.

               if not available qad_wkfl or
                  qad_datefld[1] <> start_date or
                  qad_charfld[1] <> start_time or
                  qad_key4 = "Kill" then do:
                  date_time = " " + string(today)
                            + " " + string(time,"HH:MM:SS").
                  /* CIM PROCESS SESSION TERMINATED DUE TO LOSS OF SESSION
                   * RECORD */
                  {pxmsg.i &MSGNUM=4686 &ERRORLEVEL=1
                           &MSGARG1=date_time}
                  pause 10.
                  leave main_loop.
               end.

               else do:
                  qad_datefld[2] = today.
                  qad_charfld[2] = string(time, "hh:mm:ss").
               end.
            end.
            release qad_wkfl.

            for each work_input exclusive-lock:
               delete work_input.
            end.
            work_count = 0.
         end.
         writing_data = no.

      end.

      else
         if writing_data then do:
         create work_input.
         assign
            work_data = linedata
            work_count = work_count + 1.
      end.

      linedata = "".
      readkey stream batchdata.
      do while lastkey <> keycode("RETURN") and lastkey >= 0:
         linedata = linedata + chr(lastkey).
         readkey stream batchdata.
      end.
   end.
/*zy*/ do transaction:
/*zy*/ /* 备份变量以便装入时使用. */
/*zy*/ release qad_wkfl.
/*zy*/ find first qad_wkfl exclusive-lock where qad_domain = global_domain and
/*zy*/            qad_key1 = "mgbdpro" and qad_key2 = global_userid no-error.
/*zy*/ if avail qad_wkfl and not locked(qad_wkfl) then do:
/*zy*/   assign qad_intfld[1] = f_id
/*zy*/          qad_intfld[2] = l_id
/*bg*/          qad_logfld[2] = no
/*zy*/          qad_charfld[1] = sourcename.
/*zy*/ end.
/*zy*/ else do:
/*zy*/   create qad_wkfl.
/*zy*/   assign qad_domain = global_domain
/*zy*/          qad_key1 = "mgbdpro"
/*zy*/          qad_key2 = global_userid
/*zy*/          qad_intfld[1] = f_id
/*zy*/          qad_intfld[2] = l_id
/*bg*/          qad_logfld[2] = no
/*zy*/          qad_charfld[1] = sourcename.
/*zy*/ end.
/*zy*/ end. /*do transaction:*/
   input stream batchdata close.
   display sets_entered f_id l_id with frame a.
end.

run p-delete-qadwkfl in this-procedure.

if l_sudden_exit then stop.

PROCEDURE p-delete-qadwkfl:
/* --------------------------------------------------------------------
   Purpose:     To delete qad_wkfl record to remove CIM Load Session
                record
   Parameters:  <none>
   Notes:       <none>
   History:
   --------------------------------------------------------------------*/

   do transaction:
      find first qad_wkfl
         where qad_wkfl.qad_domain = global_domain
         and   qad_key1            = "CIM Load Session"
         and   qad_key2            = session_no
         exclusive-lock no-error.

      if available qad_wkfl
      then
         delete qad_wkfl.
   end. /* DO TRANSACTION */
END PROCEDURE.
