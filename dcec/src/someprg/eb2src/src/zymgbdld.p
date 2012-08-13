/* mgbdld.p - Load batch CIM data into database for future processing.        */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.18 $                                                              */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 6.0      LAST MODIFIED:  05/30/90  BY: WUG Initial               */
/* REVISION: 6.0      LAST MODIFIED: 10/12/90   BY: WUG *D094*                */
/* REVISION: 7.0      LAST MODIFIED: 10/09/91   BY: WUG *7.0*                 */
/* REVISION: 7.0      LAST MODIFIED: 03/27/92   BY: WUG *F327*                */
/* REVISION: 7.0      LAST MODIFIED: 04/14/92   BY: dgh *F717*                */
/* REVISION: 7.3      LAST MODIFIED: 10/07/92   BY: wug *G132*                */
/* REVISION: 7.3      LAST MODIFIED: 04/23/93   BY: jzs *GA20*                */
/* REVISION: 7.3      LAST MODIFIED: 10/20/93   BY: jzs *GG47*                */
/* REVISION: 7.3      LAST MODIFIED: 09/29/94   BY: rmh *GM91*                */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: ame *GO02*                */
/* REVISION: 7.3      LAST MODIFIED: 03/28/95   BY: jzs *G0FB*                */
/* REVISION: 7.4      LAST MODIFIED: 01/10/97   BY: *H0QT* Cynthia Terry      */
/* REVISION: 7.4      LAST MODIFIED: 03/26/97   BY: *G2LT* David Seo          */
/* REVISION: 7.4      LAST MODIFIED: 05/21/97   BY: *F0XN* David Seo          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer   */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 02/10/00   BY: *N07W* Vandna Rohira      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane     */
/* REVISION: 9.1      LAST MODIFIED: 04/11/00   BY: *N08R* Sandeep Rao        */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.16      BY: Hualin Zhong          DATE: 08/10/01  ECO: *N11N*  */
/* Revision: 1.17      BY: John Corda            DATE: 08/23/01  ECO: *M1J4*  */
/* $Revision: 1.18 $   BY: Karan Motwani        DATE: 09/05/02  ECO: *N1T5*  */
/* Revisioin: 1.18     BY: LI WEI               DATE: 22/10/04   * dss01*    */
/* Revisioin: 1.18     BY: LI WEI               DATE: 11/12/2004 * dss01*    */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* output LOG $ MSG to table xslogd_det 11/12/2004   liwei AtosOrigin         */

/*
{mfdtitle.i "2+ "}
dss01*/

{mfdeclre.i} /*dss01*/
{gplabel.i}  /*dss01*/ 
/*yy*/ {zycimload.i} 
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
   format "x(24)".
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
define buffer bdl_next_id for bdl_mstr.
define variable f_id like bdld_id.
define variable l_id like bdld_id label {&mgbdld_p_11} initial 0.

define variable bdl_recno  as   recid.
define variable next_id    like bdl_id.
define variable session_no as   character.
define variable start_date as   date.
define variable start_time as   character.
define variable end_file as logical.
define variable date_time as character.


/** dss01 begin added,liwei **/
define input  parameter xsdataname as char.
/*dss01-01 define input  parameter xslogname  as char. */
/*yy* define input  parameter transid  as char.*/
/*yy define output parameter xsfid like bdld_id.
define output parameter xslid like bdld_id.*/
define stream xsstream  . 
define var msgtxt  as char format "x(150)" .
define var msgtype as char .

/* Description: This program copy from mgbdpro.p.
* Modified this program for Load the date automatically
* input parameter 1 : The filename which you will load.
* input parameter 2 : The error log file name .
* output parameter 1 : The first gropeID.
* output parameter 2 : The last gropeID.
**dss01 end added,liwei**/ 

/* DELETING the qad_wkfl RECORD, WHEN THE USER EXITS BY */
/* PRESSING THE EXIT/X BUTTON OR EXITING FROM USER MENU */



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
      find first qad_wkfl exclusive-lock where
         qad_key1 = "CIM Load Session" and
         qad_key2 > string(i, "999")
         use-index qad_index1 no-error.

      if not available qad_wkfl then leave.

      else if decimal(qad_key2) > i + 1 then leave.
   end.

   if i = 999 then do:
      bell.

      /* TOO MANY CIM LOAD SESSIONS IN OPERATION */
      /**dss01**
      {pxmsg.i &MSGNUM=1324 &ERRORLEVEL=1}
      **dss01**/
      /**liwei************/
      {pxmsg.i &MSGNUM=1324 &ERRORLEVEL=1 &MSGBUFFER=msgtxt}
      /*Dss01-01 {xslogger.i xslogname ""CIM-INFO"" msgtxt} */
/*yy*      {xslogger.i transid ""CIM"" ""IMP"" ""INFO"" MSGTXT}.*/
/*yy*/      CREATE xxerrtb .
            xxerr = "00" .
            xxmsg = msgtxt .
      /**liwei************/ 
      pause.
      return.
   end.

   session_no = string(i + 1, "999").

   if available qad_wkfl then release qad_wkfl.

   create qad_wkfl.

   assign
      qad_key1 = "CIM Load Session"
      qad_key2 = session_no
      qad_datefld[1] = start_date
      qad_charfld[1] = start_time.

   release qad_wkfl.
end.

/*********************
/* SELECT FORM */
form
   skip(1)
   datasource   colon 50 skip
   sourcename   colon 50 skip(1)
   sets_entered colon 50 skip
   f_id         colon 50 space(2) l_id skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
main_loop:
repeat on stop undo, leave:
dss01 liwei**********/

   f_id = 0.
   do transaction:
      find qad_wkfl exclusive-lock where
         qad_key1 = "CIM Load Session" and
         qad_key2 = session_no    no-error.

      if not available qad_wkfl or
         qad_datefld[1] <> start_date or
         qad_charfld[1] <> start_time or
         qad_key4 = "Kill" then do:
         date_time = " " + string(today)
                   + " " + string(time,"HH:MM:SS").
         /* CIM PROCESS SESSION TERMINATED DUE TO LOSS OF SESSION RECORD */
         /**DSS01**
         {pxmsg.i &MSGNUM=4686 &ERRORLEVEL=1 &MSGARG1=date_time}
         **DSS01**/
         /**liwei************/
         {pxmsg.i &MSGNUM=4686 
                  &ERRORLEVEL=1 
                  &MSGARG1=date_time 
                  &MSGBUFFER=MSGTXT}
         /*dss01-01 {xslogger.i xslogname ""CIM-INFO"" MSGTXT} */
/*yy*         {xslogger.i transid ""CIM"" ""IMP"" ""INFO"" MSGTXT}.*/
/*yy*/          CREATE xxerrtb .
                xxerr = "00" .
                xxmsg = msgtxt .
         /**liwei************/
         pause 10.
         leave. /*main_loop dss01 liwei.*/
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
  
   /******************
   update datasource sourcename with frame a.
   display "" @ sets_entered "" @ f_id "" @ l_id with frame a.
   dss01,liwei *****/
   
   
   /** dss01 begin added **/
   datasource = yes.
   sourcename   = xsdataname.
   /** dss01 end   added **/
   do transaction:  /**dss01**/
       if opsys <> "UNIX" and datasource = continuous then do:
          /* Continuous process not allowed for this op system */
          /**DSS01**
          {pxmsg.i &MSGNUM=365 &ERRORLEVEL=3}
           **DSS01**/
          /**liwei************/
          {pxmsg.i &MSGNUM=365 &ERRORLEVEL=4 &MSGBUFFER=MSGTXT}
       
          /*Dss01-01 {xslogger.i xslogname ""CIM-ERROR"" MSGTXT} */
/*yy*          {xslogger.i transid ""CIM"" ""IMP"" ""INFO"" MSGTXT}.*/
/*yy*/          CREATE xxerrtb .
                xxerr = "00" .
                xxmsg = msgtxt .
          /**liwei************/
          undo, retry.
       end.

       if datasource <> continuous and search(sourcename) = ? then do:
          /* FILE DOES NOT EXIST */
          /**DSS01**/
          /**liwei************/
          {pxmsg.i &MSGNUM=53 &ERRORLEVEL=4 &MSGBUFFER=MSGTXT}
      
          /*dss01-01 {xslogger.i xslogname ""CIM-ERROR"" MSGTXT} */
/*yy*          {xslogger.i transid ""CIM"" ""IMP"" ""ERROR"" MSGTXT}.*/
/*yy*/          CREATE xxerrtb .
                xxerr = "09" .
                xxmsg = msgtxt .
          /**liwei************/
          undo, retry.
       end.
   end. /**dss01**/

   do transaction:
       find first qad_wkfl where
          qad_key1 = "CIM Load Session" and
          qad_key2 <> session_no        and
          qad_charfld[3] = string(datasource)   and
          qad_charfld[4] = sourcename use-index qad_index1
          no-lock no-error.

          if available qad_wkfl then do:
          bell.

          /* DATA SOURCE/NAME IN USE BY ANOTHER CIM LOAD SESSION */
          /**DSS01**
          {pxmsg.i &MSGNUM=3732 &ERRORLEVEL=3}
          **DSS01**/
          /**liwei************/
          {pxmsg.i &MSGNUM=3732 &ERRORLEVEL=4 &MSGBUFFER=MSGTXT}
          /*dss01
          {xslogger.i xslogname ""CIM-ERROR"" MSGTXT}
           */
/*yy*           {xslogger.i transid ""CIM"" ""IMP"" ""ERROE"" MSGTXT}.*/
/*yy*/          CREATE xxerrtb .
                xxerr = "09" .
                xxmsg = msgtxt .
          /**liwei************/
          undo, retry.
       end.
   end.  /**dss01*/

   do transaction:
      find qad_wkfl exclusive-lock where
         qad_key1 = "CIM Load Session" and
         qad_key2 = session_no    no-error.

      if not available qad_wkfl or
         qad_datefld[1] <> start_date or
         qad_charfld[1] <> start_time or
         qad_key4 = "Kill" then do:
         date_time = " " + string(today)
                   + " " + string(time,"HH:MM:SS").
         /* CIM PROCESS SESSION TERMINATED DUE TO LOSS OF SESSION RECORD */
         /**DSS01**
         {pxmsg.i &MSGNUM=4686 &ERRORLEVEL=1 &MSGARG1=date_time}
         **DSS01**/
         /**liwei************/
         {pxmsg.i &MSGNUM=4686 
                  &ERRORLEVEL=1 
                  &MSGARG1=date_time 
                  &MSGBUFFER=MSGTXT}
         /*dss01-01{xslogger.i xslogname ""CIM-INFO"" MSGTXT} */
/*yy*         {xslogger.i transid ""CIM"" ""IMP"" ""INFO"" MSGTXT}.*/
/*yy*/          CREATE xxerrtb .
                xxerr = "00" .
                xxmsg = msgtxt .
         /**liwei************/
         pause 10.
         leave. /* main_loop.*/
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
         if substring(linedata,1,5) = "@@end" then do:
         if work_count > 0 then do:

            do transaction:
               assign_bdl_id:
               repeat on error undo:

                  find last bdl_next_id where
                     bdl_next_id.bdl_source >= "" and
                     bdl_next_id.bdl_id     >= 0
                     exclusive-lock no-error.
                  if available bdl_next_id then
                     next_id = bdl_next_id.bdl_id + 1.
                  else
                     next_id = 1.
                  create bdl_mstr.
                  assign
                     bdl_mstr.bdl_source = ""
                     bdl_mstr.bdl_id = next_id
                     bdl_mstr.bdl_exec = function_to_run
                     bdl_mstr.bdl_date_ent = today
                     bdl_mstr.bdl_time_ent =
                     string(time,"HH:MM:SS").
                  leave assign_bdl_id.
               end.
               if f_id = 0 then
                  f_id = bdl_mstr.bdl_id.
               l_id = bdl_mstr.bdl_id.
               release bdl_next_id.
               release bdl_mstr.
            end.

            /* Changed the scope of the bdld_det creation loop to avoid lock
             * table overflow problems*/
            do:

               i = 0.
               for each work_input no-lock:
                  i = i + 1.
                  create bdld_det.

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
               find qad_wkfl exclusive-lock where
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
                  /**dss01**
                  {pxmsg.i &MSGNUM=4686 &ERRORLEVEL=1
                           &MSGARG1=date_time}
                  **dss01**/
                  /**liwei************/
                  {pxmsg.i &MSGNUM=4686 
                           &ERRORLEVEL=1 
                           &MSGARG1=date_time 
                           &MSGBUFFER=MSGTXT}
                  /*dss01-01 {xslogger.i xslogname ""CIM-INFO"" MSGTXT} */
/*yy*                  {xslogger.i transid ""CIM"" ""IMP"" ""INFO"" MSGTXT}.*/
/*yy*/                  CREATE xxerrtb .
                  xxerr = "00" .
                  xxmsg = msgtxt .
                  /**liwei************/
                  pause 10.
                  leave. /* main_loop. dss01,liwei*/
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

   input stream batchdata close.
   /*
   display sets_entered f_id l_id with frame a.
   */
   
   /*dss01 begin added*/
   xxxfid = f_id.
   xxxlid = l_id.
   /*dss01 end added*/

/***************      
end.
dss01 liwei****/
run p-delete-qadwkfl in this-procedure.


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
         where qad_key1 = "CIM Load Session"
         and   qad_key2 = session_no
         exclusive-lock no-error.

      if available qad_wkfl
      then
         delete qad_wkfl.
   end.
END PROCEDURE.
