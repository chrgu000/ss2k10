/* edprctrl.p   - ECommerce - Process Control Module                          */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.28.2.38.3.6 $                                                     */
/*V8:ConvertMode=NoConvert                                                    */
/* REVISION: 9.0          CREATED: 07/20/98   BY: *M030* Dan Herman           */
/* REVISION: 9.0    LAST MODIFIED: 01/20/99   BY: *M05T* Dan Herman           */
/* REVISION: 9.0    LAST MODIFIED: 02/02/99   BY: *M07J* Paul Dreslinski      */
/* REVISION: 9.0    LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan           */
/* REVISION: 9.0    LAST MODIFIED: 07/7/99    BY: *M0CX* Eilish Cusack        */
/* REVISION: 9.1    LAST MODIFIED: 11/7/99    BY: *N051* Paul Dreslinski      */
/* REVISION: 9.1    LAST MODIFIED: 11/15/99   BY: *N06C* Dan Herman           */
/* REVISION: 9.1    LAST MODIFIED: 04/10/00   BY: *M0M2* Paul Dreslinski      */
/* REVISION: 9.1    LAST MODIFIED: 06/10/00   BY: *N0B5* Vinay Niyak-Sujir    */
/* REVISION: 9.0    LAST MODIFIED: 07/26/00   BY: *M0Q9* Vinod Kumar          */
/* Revision: 1.28.2.21       BY: Paul Dreslinski   DATE: 05/31/01 ECO: *M15Z* */
/* Revision: 1.28.2.22     BY: Paul Dreslinski   DATE: 07/09/01 ECO: *M195* */
/* Revision: 1.28.2.23     BY: Jean Miller       DATE: 08/07/01 ECO: *M11Z* */
/* Revision: 1.28.2.24     BY: Indu Arora        DATE: 09/04/01 ECO: *N11Y* */
/* Revision: 1.28.2.25     BY: Paul Dreslinski   DATE: 11/10/01 ECO: *M15H* */
/* Revision: 1.28.2.26     BY: Dan Herman        DATE: 12/05/01 ECO: *M1QX* */
/* Revision: 1.28.2.27     BY: Vinod Kumar       DATE: 02/01/02 ECO: *M146* */
/* Revision: 1.28.2.28     BY: Dan Herman        DATE: 03/27/02 ECO: *P00F* */
/* Revision: 1.28.2.29     BY: Vinod Nair        DATE: 04/24/02 ECO: *M1X3* */
/* Revision: 1.28.2.33     BY: Paul Dreslinski   DATE: 03/10/02 ECO: *P04S* */
/* Revision: 1.28.2.34     BY: Dan Herman        DATE: 06/05/02 ECO: *P017* */
/* Revision: 1.28.2.35     BY: Paul Dreslinski   DATE: 07/23/02 ECO: *P0C2* */
/* Revision: 1.28.2.37     BY: Paul Dreslinski   DATE: 08/23/02 ECO: *P0F6* */
/* Revision: 1.28.2.38.3.3 BY: Paul Dreslinski   DATE: 11/14/02 ECO: *M213* */
/* Revision: 1.28.2.38.3.4 BY: Vinay Nayak-Sujir DATE: 11/14/03 ECO: *P158* */
/* $Revision: 1.28.2.38.3.6 $    BY: Vinod Kumar       DATE: 02/19/04 ECO: *P19G* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*----------------------------------------------------------------------
 * Parameters:
 * -----------
 * i_entry     - numeric value indicating how this program is being called
 *              (10)  inbound flat file processing initialized by the
 *                    EC SUBSYSTEM  run unattended
 *              (20)  inbound flat file processing
 *              (30)  inbound error file processing
 *              (40)  re-process inbound, start with exf sequence numbers
 *                    that had previously errored
 *              (50)  re-process inbound, start with MFG sequence numbers
 *                    that had previously errored
 *              (100) outbound gateway processing
 *              (110) re-process outbound, start with MFG sequence numbers
 *                    that had previously errored
 *              (120) re-process outbound, start with exf sequence numbers
 *                    that had previously errored
 *
 * i_file_list - list of flat files to be processed or list of sequence
 *               numbers for outbound gateways
 *               (Note: the file names MUST NOT contain the full path)
 *
 *------------------------------------------------------------------------*/

{mfdeclre.i}
{gplabel.i}

/*Temp tables tt_exf_status, tt_doc_status, tt_seq_list*/
{edtmpdef.i}

define input parameter i_entry       as integer          no-undo.
define input parameter i_file_list   as character        no-undo.

define input-output    parameter table for tt_exf_status .
define input-output    parameter table for tt_doc_status .
define output          parameter proclist as character   no-undo.

define temp-table tt_gateway no-undo
   field tt_gtwy_seq like edmfs_mfd_seq
   field tt_prgm like edmf_gtwy_pgm
   index tt_pgm_index tt_prgm.

define variable l_dir              like edc_inbound_dir  no-undo.
define variable l_exf_seq          like edxfs_exf_seq    no-undo.
define variable error-info         as   character        no-undo.
define variable l_msg_num          like edxfsdd_msg_no   no-undo.
define variable l_error            as logical initial no no-undo.
define variable l_default_subsys   like edc_subsys       no-undo.
define variable l_error_prefix     like edc_error_prefix no-undo.
define variable l_in_dir           like edc_inbound_dir  no-undo.
define variable l_arc_dir          like edc_archive_dir  no-undo.
define variable l_err_dir          like edc_error_dir    no-undo.
define variable document_in        as   logical          no-undo.
define variable proc_sess          as   integer          no-undo.
define variable prgmname           as   character        no-undo.

define variable i                    as integer          no-undo.

define variable l_ext                like edss_ecf_ext   no-undo.
define variable l_subsys             like edc_subsys     no-undo.
define variable l_list               as character        no-undo.
define variable l_file_name as character  format "x(30)" no-undo.
define variable l_err_file_name      as character        no-undo.

define variable fnerrorseq           like edxfs_exf_seq  no-undo.
define variable fnstatus             like edxfs_status   no-undo.
define variable procseq              like edxfs_exf_seq  no-undo.
define variable l_temp_int           as   integer        no-undo.
define variable l_target_file        as   character      no-undo.
define variable l_last_pos           as   integer        no-undo.
define variable l_last_butone_pos    as   integer        no-undo.
define variable l_os_cmd_stat        as   integer        no-undo.



document_in = (if i_entry < 90 then yes else no).

/* The generic report name edgenrpt.p is entered as the gateway's report name
   using  MFG/PRO Definition Maintenance. So this is a dummy reference to
   prevent the program from being caught as "unused" */
if false then do:
   {gprun.i ""edgenrpt.p""}
end.

/* CHECK IF THE CONTROL TABLE IS AVAILABLE */
for first edc_ctrl
   fields (edc_archive_dir edc_error_dir edc_error_prefix
           edc_inbound_dir edc_index1 edc_subsys
           edc_oerror_dir edc_oinbound_dir edc_oarchive_dir)
   where edc_index1 = 1
   no-lock:
end. /* FOR FIRST edc_ctrl */

if not available edc_ctrl then do:
   /*** CONTROL TABLE NOT AVAILABLE***/
   l_msg_num = 594.
   run error_proc
      (input 4,
       input yes,
       input l_exf_seq).
   return.
end.

/* GET FILE LOCATIONS */
assign
   l_default_subsys = edc_subsys
   l_error_prefix = edc_error_prefix
   file-info:file-name = if document_in then edc_inbound_dir
                         else edc_oinbound_dir
   l_in_dir = file-info:full-pathname.

{gprun.i ""edcvtdir.p"" "(INPUT-OUTPUT l_in_dir)"}

assign
   file-info:file-name = if document_in then edc_archive_dir
                         else edc_oarchive_dir
   l_arc_dir = file-info:full-pathname.

{gprun.i ""edcvtdir.p"" "(INPUT-OUTPUT l_arc_dir)"}

assign
   file-info:file-name = if document_in then edc_error_dir
                         else edc_oerror_dir
   l_err_dir = file-info:full-pathname.

{gprun.i ""edcvtdir.p"" "(INPUT-OUTPUT l_err_dir)"}

if i_entry < 40 or i_entry = 90 then do:
   /* CHECK TO SEE IF THE DIRECTORIES EXIST AND THE USER HAS WRITE PERMISSION */
   if l_in_dir = "" then do:
      assign
         l_msg_num = 4400
         error-info = getTermLabel("INBOUND_DIRECTORY",17).
                      /* Inbound Directory  */
      run error_proc
         (input 4,
          input yes,
          input l_exf_seq).
      return.
   end.
   else do:
      file-info:FILENAME = l_in_dir.
      if file-info:FILE-TYPE = ? then do:
         assign
            l_msg_num = 4400
            error-info = getTermLabel("INBOUND_DIRECTORY",17).
                         /* Inbound Directory  */
         run error_proc
            (input 4,
             input yes,
             input l_exf_seq).
         return.
      end.
      else if index( file-info:FILE-TYPE,"W" ) = 0 then do:
         assign
            l_msg_num = 4401
            error-info = getTermLabel("INBOUND_DIRECTORY",17).
                         /*Inbound Directory   */
         run error_proc
            (input 4,
             input yes,
             input l_exf_seq).
         return.
      end.
   end.

   if l_arc_dir = "" then do:
      assign
         l_msg_num = 4400
         error-info = getTermLabel("ARCHIVE_DIRECTORY",17).
                      /* Archive Directory   */
      run error_proc
         (input 4,
          input yes,
          input l_exf_seq).
      return.
   end.
   else do:
      file-info:FILENAME = l_arc_dir.
      if file-info:FILE-TYPE = ? then do:
         assign
            l_msg_num = 4400
            error-info = getTermLabel("ARCHIVE_DIRECTORY",17).
                         /* Archive Directory   */
         run error_proc
            (input 4,
             input yes,
             input l_exf_seq).
         return.
      end.
      else if index( file-info:FILE-TYPE,"W" ) = 0 then do:
         assign
            l_msg_num = 4401
            error-info = getTermLabel("ARCHIVE_DIRECTORY",17).
                         /* Archive Directory   */
         run error_proc
            (input 4,
             input yes,
             input l_exf_seq).
         return.
      end.
   end.

   if l_err_dir = "" then do:
      assign
         l_msg_num = 4400
         error-info = getTermLabel("ERROR_DIRECTORY",17).
                      /* Error Directory   */
      run error_proc
         (input 4,
          input yes,
          input l_exf_seq).
      return.
   end.
   else do:
      file-info:FILENAME = l_err_dir.
      if file-info:FILE-TYPE = ? then do:
         assign
            l_msg_num = 4400
            error-info = getTermLabel("ERROR_DIRECTORY",17).
                         /* Error Directory    */
         run error_proc
            (input 4,
             input yes,
             input l_exf_seq).
         return.
      end.
      else if index( file-info:FILE-TYPE,"W" ) = 0 then do:
         assign
            l_msg_num = 4401
            error-info = getTermLabel("ERROR_DIRECTORY",17).
                         /* Error Directory   */
         run error_proc
            (input 4,
             input yes,
             input l_exf_seq).
         return.
      end.
   end.

end. /* if i_entry < 40 */

/********************** START THE PROCESSING ****************************
 * i_entry     - numeric value indicating how this program is being called
 * (10)  inbound flat file processing initialized by the
 *       EC SUBSYSTEM  run unattended
 * (20)  inbound flat file processing
 * (30)  inbound error file processing
 * (40)  re-process inbound, start with exf sequence numbers
 *       that had previously errored
 * (50)  re-process inbound, start with MFG sequence numbers
 *       that had previously errored
 *
 * (90)  outbound external gateway processing
 * (100) outbound gateway processing
 * (110) re-process outbound, start with MFG sequence numbers
 *       that had previously errored
 * (120) re-process outbound, start with exf sequence numbers
 *       that had previously errored
 *****************************************************************************/
CASE i_entry:

   when (10) or when (20) or when (30) then do:
      /* Process a inbound flat file */
      /* 10 or 20 or 30 */
      if i_entry = 30 then
            l_dir = l_err_dir.
      else
            l_dir = l_in_dir.

      do i = 1 to num-entries(i_file_list,","):
         run ip_build_file_name.
         run ip_inbound_proc.
         run clear_tmp_tables.
      end. /*Do i = 1_...*/
   end. /* when i_entry = 10.... */

   when (40) or when (50) then do:
      /* Reprocess the errored inbound sequence numbers,
       * when 40 start processing sequence numbers
       * in tt_exf_status, when 50 only sequence numbers
       * for tt_doc_status are available
      */

      run ip_inbound_proc.
   end. /* when i_entry = 40 or 50 */

   when (100) then do: /* entry point is from outbound gateway UI*/
      document_in = no.
      run ip_get_gtwy_prgm.
      run ip_outbound_proc.
   end.  /* when i_entry = 100 */

   when (110) or when (120) then do:
      /* Reprocess the errored outbound sequence numbers,
       * when 110 start processing sequence numbers
       * in tt_doc_status, when 120 only sequence numbers
       * for tt_exf_status are available
      */

      run ip_outbound_proc.
   end.

   when (90) or when (95) then do: /* entry point is from external outbound gateway UI*/
      document_in = no.
      if i_entry = 95 then
            l_dir = l_err_dir.
      else
            l_dir = l_in_dir.
      do i = 1 to num-entries(i_file_list,","):
         run ip_build_file_name.
         run ip_outbound_proc.
         run clear_tmp_tables.
      end. /*Do i = 1_...*/

   end.  /* when i_entry = 90 or 95 */

END CASE. /* case i_entry: */

/* clear all temp tables for the next session */
hide message no-pause.
run clear_tmp_tables.

/*************************************************************************/
/*********************                               *********************/
/*********************     INTERNAL PROCEDURES       *********************/
/*********************                               *********************/
/*************************************************************************/

PROCEDURE ip_chck_xfstatus:
/*-------------------------------------------------------------------------
  Purpose: To verify that records do exist in the temp table
           tt_exf_status.  If not the error flag is set to yes
           and the routines that read from this table are not run.
  Parameters:
  Notes:
-------------------------------------------------------------------------*/
   find first tt_exf_status where tt_exf_seq > 0 no-lock no-error.

   if not available tt_exf_status then
      l_error = yes.

END PROCEDURE. /* PROCEDURE ip_chck_xfstatus */

PROCEDURE ip_chck_docstatus:
/*-------------------------------------------------------------------------
  Purpose: To verify that records do exist in the temp table
           tt_doc_status.  If not the error flag is set to yes
           and the routines that read from this table are not run.
Parameters:
Notes:
-------------------------------------------------------------------------*/

   find first tt_doc_status where tt_doc_seq > 0 no-lock no-error.

   if not available tt_doc_status then
      l_error = yes.

END PROCEDURE. /* PROCEDURE ip_chck_docstatus */

PROCEDURE ip_build_file_name:
/*-------------------------------------------------------------------------
  Purpose: Build full file name including path, and determine the
           name of the Subsystem by the file name extension.
           Clear the temp tables and get a new process session number.
           Also builds the error file name.
  Parameters: .
  Notes: Used at entry 10, 20, 30, 90 and 95
-------------------------------------------------------------------------*/
   l_file_name = entry(i,i_file_list,",").

   assign
      l_ext       = ""
      l_last_pos  = r-index(l_file_name,".")
      l_ext       = substring(l_file_name,( l_last_pos + 1))

      l_file_name    = l_dir + l_file_name.

   /* GET THE SUBSYSTEM NAME */
   for first edss_mstr
      fields (edss_ecf_ext edss_subsys)
      where edss_ecf_ext = l_ext
      no-lock:
   end. /* FOR FIRST edss_mstr */

   if not available edss_mstr then
      l_subsys = l_default_subsys.
   else
      l_subsys = edss_subsys.

   for first edss_mstr
      fields (edss_ecf_ext edss_subsys)
      where edss_subsys = l_subsys
      no-lock:
   end. /* FOR FIRST edss_mstr */

   l_ext = "." + edss_ecf_ext.

   /* CLEAR THE TEMP TABLES FOR A NEW SET OF SEQ NUMBERS */
   for each tt_exf_status exclusive-lock:
      delete tt_exf_status.
   end.

   for each tt_doc_status exclusive-lock:
      delete tt_doc_status.
   end.

   /* Check to make sure the file exists  */
   if i_entry <= 30 or i_entry = 90 or
                       i_entry = 95 then do:
      if search( l_file_name ) = ? then do:
         l_msg_num = 8004.
         error-info = l_file_name.
         run error_proc
            (input 4,
             input yes,
             input l_exf_seq).
         return.
      end. /* IF SEARCH( l_file_name ) = ? */
   end.  /* IF i_entry = 1 */

   l_error = no.

   if proc_sess = 0 then do:
      assign
         proc_sess = next-value( edc_sq01 )
         proclist  = proclist + "," + string(proc_sess).
   end.

   /* Build error file name */
   l_err_file_name = l_err_dir +
                     (if l_error_prefix = "" then "ERR"
                      else l_error_prefix ) + string( proc_sess ) + l_ext.

END PROCEDURE. /* PROCEDURE IP_BUILD_FILE_NAME */

PROCEDURE ip_inbound_proc:
/*-------------------------------------------------------------------------
  Purpose: Process the inbound documents
  Parameters:
  Notes:
-------------------------------------------------------------------------*/

   if l_error then return.

   if i_entry >= 40 then do:
      /*Get the next process session number */
      proc_sess = next-value( edc_sq01 ).
      proclist = proclist + "," + string(proc_sess).
   end.

   document_in = yes.

   if i_entry <= 30 then do:

      hide message no-pause.
      /* Processing Flat File */
      {pxmsg.i &MSGNUM=4464 &ERRORLEVEL=1 }

      {gprun.i ""edixload.p""
         "(input l_subsys,
           input l_file_name,
           input proc_sess,
           input l_err_file_name,
           output table tt_exf_status)"}

      run ip_chck_xfstatus.

   end.

   if i_entry = 40 then
      run ip_chck_xfstatus.

   if not l_error and i_entry <= 40 then do:

      hide message no-pause.
      /* Transforming exchange file */
      {pxmsg.i &MSGNUM=4465 &ERRORLEVEL=1 }

      {gprun.i ""editeng.p""
         "(input proc_sess,
           input-output table tt_exf_status,
           input-output table tt_doc_status)"}

      run ip_chck_docstatus.

   end.

   if i_entry = 50 then
      run ip_chck_docstatus.

   if not l_error then do:

      hide message no-pause.
      /* Processing MFG/PRO Document */
      {pxmsg.i &MSGNUM=4466 &ERRORLEVEL=1 }

      run ip_get_gtwy_prgm.

      for each tt_gateway break by tt_prgm:

         create tt_seq_list.
         assign
            tt_seq = tt_gtwy_seq.

         if recid(tt_seq_list) = -1 then.

         if last-of(tt_prgm) then do:

            l_error = no.

            {gprun.i ""gprunck.p""
               "(input tt_prgm,
                 output prgmname)"}

            if prgmname <> "" then do:

               {gprun.i "tt_prgm"
                  "(input proc_sess,
                    input table tt_seq_list)"}

               /* Following Code is for Release Info */
               if false then do:

                  /*CPDG - PHYSICAL TAG LOAD (846) */
                  {gprunmo.i
                     &program = ""edimitpr.p""
                     &module = "I11"
                     &param = """(input proc_sess,
                                  input table tt_seq_list)"""}
                  /*CPDG - INVENTORY RECEIPTS (944) */
                  {gprunmo.i
                     &program = ""edimirpr.p""
                     &module = "I12"
                     &param = """(input proc_sess,
                                  input table tt_seq_list)"""}
                  /*CPDG - SO SHIPPER RECEIPTS (945) */
                  {gprunmo.i
                     &program = ""edimshpr.p""
                     &module = "I10"
                     &param = """(input proc_sess,
                                  input table tt_seq_list)"""}
                  /* CUSTOMER SEQUENCE SCHEDULE (866) */
                  {gprunmo.i
                     &program = ""edimsqpr.p""
                     &module = "I09"
                     &param = """(input proc_sess,
                                  input table tt_seq_list)"""}

                  /* XML GATEWAY */
                  {gprunmo.i
                     &program = ""edimxmpr.p""
                     &module = "I17"
                     &param = """(input proc_sess,
                                  input table tt_seq_list)"""}

                  /* REPORT GATEWAY */
                  {gprunmo.i
                     &program = ""edimrppr.p""
                     &module = "I18"
                     &param = """(input proc_sess,
                                  input table tt_seq_list)"""}

                  /* REPORT IMPORT */
                  {gprun.i ""edimrppr.p""}

                  /* STATUS IMPORT */
                  {gprun.i ""edimstpr.p""}

                  /* INVOICE IMPORT */
                  {gprun.i ""edimivpr.p""}

                  /* SALES ORDER IMPORT */
                  {gprunmo.i &module="I03"
                     &program="edimsopr.p"}

                  /* CUSTOMER SCHEDULE IMPORT */
                  {gprunmo.i &module="I02"
                     &program="edimscpr.p"}
                  {gprunmo.i &module="I07"
                     &program="edimscpr.p"}

                  /* ADVANCE SHIPMENT NOTICE IMPORT */
                  {gprunmo.i &module="I05"
                     &program="edimaspr.p"}

                  /* PO CHANGE IMPORT */
                  {gprunmo.i &module="I06"
                     &program="edimpcpr.p"}

                  /* REMITTANCE ADVICE IMPORT */
                  {gprunmo.i &module="I01"
                     &program="edimrapr.p"}

                  /* PO ACKNOWLEDMENT IMPORT */
                  {gprunmo.i &module="I04"
                     &program="edimpapr.p"}

                  {gprunmo.i &module="I08"
                     &program="edimpapr.p"}

                  /* INVOICE IMPORT */
                  {gprunmo.i &module="I13"
                             &program="edimivpr.p"}

                  /* COMMENTS IMPORT */
                  {gprunmo.i &module="I14"
                             &program="edimcmpr.p"}

                  /* SELF-BILLING IMPORT */
                  {gprunmo.i &module="I15"
                             &program="edimsbpr.p"}

                  /* CUSTOMER CONSIGNMENT */
                  {gprunmo.i &module="I16"
                             &program="edimcipr.p"}

                  /* PRODUCT TRANSFER/RESALE IMPORT */
                  {gprunmo.i &module="I19"
                             &program="edimptpr.p"}

               end.

               /* Delete table for next list */
               for each tt_seq_list exclusive-lock:
                  delete tt_seq_list.
               end.

            end. /*IF PRGNAME <>"" */

            else do:   /*File not Found*/

               for each tt_seq_list:
                  assign
                     fnerrorseq = tt_seq
                     fnstatus   = 22
                     procseq = 3
                     l_msg_num = 8004
                     error-info = tt_prgm.
                  run mfg_name_error_proc.
               end.

               /* Clear table for next list */
               for each tt_seq_list exclusive-lock:
                  delete tt_seq_list.
               end.

            end. /* ELSE DO: */

         end. /* IF LAST-OF(TT_PRGM) */

      end. /* for each tt_gateway */

   end. /* if not l_error */

   /* MOVE THE FILE THAT WAS JUST PROCESSED TO AN ARCHIVE DIRECTORY */
   if i_entry <= 30 then do:

      assign
         l_target_file = trim(entry(i,i_file_list,","))
         l_last_pos    = r-index(l_target_file, ".").

      if l_last_pos > 0 then do:

         l_last_butone_pos = r-index(l_target_file,".",(l_last_pos - 1)).

         if l_last_butone_pos = 0 then
            l_last_butone_pos = l_last_pos.

      end. /* IF L_LAST_POS > 0 THEN */

      else
         assign
            l_last_butone_pos = length( l_target_file ) + 1
            l_last_pos        = l_last_butone_pos + 1
            l_target_file     = l_target_file + ".".

      l_temp_int =
         integer(substring(l_target_file,(l_last_butone_pos + 1),
         (l_last_pos  - (l_last_butone_pos + 1)))) no-error.

      if error-status:error then
         substring(l_target_file,l_last_pos, 0 ) =
            "." + string( proc_sess ).

      else
         substring(l_target_file,l_last_butone_pos + 1,
                  (l_last_pos - (l_last_butone_pos + 1))) =
                   string( proc_sess ).

      os-rename value(l_file_name) value(l_arc_dir + l_target_file).

      l_os_cmd_stat = os-error.

      if l_os_cmd_stat <> 0 then do:

         for first tt_exf_status:
            l_exf_seq = tt_exf_seq.
         end.

         /* File Exists Already */
         if l_os_cmd_stat = 10 then do:

            assign
               l_msg_num  = 4762
               error-info = l_target_file.

            run error_proc
               (input 2,
                input no,
                input l_exf_seq).

            /* APPEND CONTENTS OF THE CURRENT FILE TO THE END OF  */
            /* FILE WHICH ALREADY EXISTS IN THE ARCHIVE DIRECTORY */
            os-append value(l_file_name) value(l_arc_dir + l_target_file).

            /* CHECK TO SE IF ERROR OCCURRED WHILE MOVING THE FILE. */
            /* IF SO GENERATE ERROR MESSAGE                         */
            l_os_cmd_stat = os-error.

            if l_os_cmd_stat <> 0 then do:

               assign
                  l_msg_num  = 4764
                  error-info = l_target_file + "," +
                               string(l_os_cmd_stat).

               run error_proc
                  (input 2,
                   input no,
                   input l_exf_seq).

            end. /* IF L_OS_CMD_STAT <> 0 THEN */

            /* DELETE THE FILE BECUASE APPEND WAS SUCCESS */
            else do:

               /* NOW DELETE THE FILE IN THE CURRENT DIRECTORY */
               os-delete value(l_file_name).

               /* CHECK TO SE IF ERROR OCCURRED WHILE DELETING THE */
               /* FILE. IF SO GENERATE ERROR MESSAGE               */
               l_os_cmd_stat = os-error.

               if l_os_cmd_stat <> 0 then do:
                  assign
                     l_msg_num  = 4765
                     error-info = l_file_name + "," +
                                  string(l_os_cmd_stat).

                  run error_proc
                     (input 2,
                      input no,
                      input l_exf_seq).

               end. /* IF L_OS_CMD_STAT <> 0 THEN */

            end. /* DELETE THE FILE BECUASE APPEND WAS SUCCESS */

         end. /* IF L_OS_CMD_STAT = 10 THEN - FILE EXISTS ALREADY */

         else do: /* SOME OTHER ERROR OCCURRED */

            assign
               l_msg_num  = 4763
               error-info = trim(l_file_name) + "," +
                            string(l_os_cmd_stat).

            run error_proc
               (input 2,
                input no,
                input l_exf_seq).
         end.

      end. /* IF L_OS_CMD_STAT <> 0 THEN */

   end. /* IF I_ENTRY <= 30 THEN */

END PROCEDURE. /* IP_INBOUND_PROCESS */

PROCEDURE ip_outbound_proc:
/*-------------------------------------------------------------------------
  Purpose:    Process the selected outbound documents
  Parameters:
  Notes:
 -------------------------------------------------------------------------*/

   if l_error then return.

         if i_entry < 90 or i_entry > 95 then
         assign
   proc_sess = next-value( edc_sq01 )
   proclist = proclist + "," + string(proc_sess).

   document_in = no.


   if i_entry = 90 or i_entry = 95 then do:

      /* Processing Flat File */
      {pxmsg.i &MSGNUM=4464 &ERRORLEVEL=1 }

      {gprun.i ""edmfload.p""
         "(input l_subsys,
           input l_file_name,
           input proc_sess,
           input l_err_file_name,
           output table tt_doc_status)"}

      run ip_chck_docstatus.

   end.

   if i_entry = 100  then do:

      /* Processing MFG/PRO Document */
      {pxmsg.i &MSGNUM=4466 &ERRORLEVEL=1 }

      for each tt_gateway break by tt_prgm:

         create tt_seq_list.
         assign
            tt_seq = tt_gtwy_seq.

         if recid(tt_seq_list) = -1 then.

         if last-of(tt_prgm) then do:

            l_error = no.

            {gprun.i ""gprunck.p""
               "(input tt_prgm,
                 output prgmname)"}

            if prgmname <> "" then do:

               {gprun.i "tt_prgm"
                  "(input proc_sess,
                    input table tt_seq_list,
                    input-output table tt_doc_status)"}

               /* Following Code is for Release Info */
               if false then do:

                  /* ADVANCE SHIPMENT NOTICE EXPORT */
                  {gprunmo.i &module="O05"
                     &program="edomaspr.p"}

                  /* INVOICE EXPORT */
                  {gprunmo.i &module="O01"
                     &program="edomivpr.p"}

                  /* PO ACKNOWLEDGMENT EXPORT */
                  {gprunmo.i &module="O04"
                     &program="edompapr.p"}

                  /* PO EXPORT */
                  {gprunmo.i &module="O03"
                     &program="edompopr.p"}

                  /* SCHEDULE EXPORT */
                  {gprunmo.i &module="O02"
                     &program="edomscpr.p"}
                  {gprunmo.i &module="O07"
                     &program="edomscpr.p"}

                  /* PO CHANGE ACKNOWLEDGEMENT EXPORT */
                  {gprunmo.i &module="O08"
                     &program="edomcapr.p"}

                  /* PO CHANGE EXPORT */
                  {gprunmo.i &module="O06"
                     &program="edompcpr.p"}

                  /*INVOICE EXPORT */
                  {gprunmo.i &module="O09"
                             &program="edomvcpr.p"}
                  /* INVENTORY ADVICE - GENERIC G/W EXPORT */
                  {gprunmo.i &module="O10"
                             &program="edomgnpr.p"}
                  /* INVENTORY ADVICE - CYCLE COUNT EXPORT */
                  {gprunmo.i &module="O11"
                             &program="edomccpr.p"}
                  /*SUPPLIER CONSIGNMENT EXPORT */
                  {gprunmo.i &module="O12"
                             &program="edomsipr.p"}
                  /*PACKING LIST EXPORT */
                  {gprunmo.i &module="O13"
                             &program="edompkpr.p"}
          /*PRICE CATALOG EXPORT */
                  {gprunmo.i &module="O14"
                             &program="edomprpr.p"}
               end.

               for each tt_seq_list exclusive-lock:
                  delete tt_seq_list. /*clear table for next list*/
               end.

            end. /* if prgmname <> "" then do: */

            else do:  /*File Not Found*/

               for each tt_seq_list:
                  assign
                     fnerrorseq = tt_seq
                     fnstatus   = 31
                     procseq = 3
                     l_msg_num = 8004
                     error-info = tt_prgm.
                  run mfg_name_error_proc.
               end.

               for each tt_seq_list exclusive-lock:
                  delete tt_seq_list. /*clear table for next list */
               end.

            end. /* ELSE DO: */

         end. /* if last-of(tt_prgm)*/

      end. /* for each tt_gateway */

      run ip_chck_docstatus.

   end.

   if i_entry = 110 then
      run ip_chck_docstatus.

   if not l_error  and i_entry <= 110 then do:

      hide message no-pause.
      /* Transforming Exchange File */
      {pxmsg.i &MSGNUM=4465 &ERRORLEVEL=1 }

      {gprun.i ""edoteng.p""
         "(input proc_sess,
           input-output table tt_exf_status,
           input-output table tt_doc_status)"}.

      run ip_chck_xfstatus.

   end.

   if i_entry = 120 then
      run ip_chck_xfstatus.

   if not l_error then do:

      hide message no-pause.

      /* Processing flat file */
      {pxmsg.i &MSGNUM=4464 &ERRORLEVEL=1 }

      {gprun.i ""edoxload.p""
         "(input proc_sess,
           input l_default_subsys,
           input-output table tt_exf_status)"}

   end. /* if prgmname <> "" then */

   /* MOVE THE FILE THAT WAS JUST PROCESSED TO AN ARCHIVE DIRECTORY */
   if i_entry = 90 or i_entry = 95 then do:

      assign
         l_target_file = trim(entry(i,i_file_list,","))
         l_last_pos    = r-index(l_target_file, ".").

      if l_last_pos > 0 then do:

         l_last_butone_pos = r-index(l_target_file,".",(l_last_pos - 1)).

         if l_last_butone_pos = 0 then
            l_last_butone_pos = l_last_pos.

      end. /* IF L_LAST_POS > 0 THEN */

      else
         assign
            l_last_butone_pos = length( l_target_file ) + 1
            l_last_pos        = l_last_butone_pos + 1
            l_target_file     = l_target_file + ".".

      l_temp_int =
         integer(substring(l_target_file,(l_last_butone_pos + 1),
         (l_last_pos  - (l_last_butone_pos + 1)))) no-error.

      if error-status:error then
         substring(l_target_file,l_last_pos, 0 ) =
            "." + string( proc_sess ).

      else
         substring(l_target_file,l_last_butone_pos + 1,
                  (l_last_pos - (l_last_butone_pos + 1))) =
                   string( proc_sess ).

      os-rename value(l_file_name) value(l_arc_dir + l_target_file).

      l_os_cmd_stat = os-error.

      if l_os_cmd_stat <> 0 then do:

         for first tt_exf_status:
            l_exf_seq = tt_exf_seq.
         end.

         /* File Exists Already */
         if l_os_cmd_stat = 10 then do:

            assign
               l_msg_num  = 4762
               error-info = l_target_file.

            run error_proc
               (input 2,
                input no,
                input l_exf_seq).

            /* APPEND CONTENTS OF THE CURRENT FILE TO THE END OF  */
            /* FILE WHICH ALREADY EXISTS IN THE ARCHIVE DIRECTORY */
            os-append value(l_file_name) value(l_arc_dir + l_target_file).

            /* CHECK TO SE IF ERROR OCCURRED WHILE MOVING THE FILE. */
            /* IF SO GENERATE ERROR MESSAGE                         */
            l_os_cmd_stat = os-error.

            if l_os_cmd_stat <> 0 then do:

               assign
                  l_msg_num  = 4764
                  error-info = l_target_file + "," +
                  string(l_os_cmd_stat).

               run error_proc
                  (input 2,
                   input no,
                   input l_exf_seq).

            end. /* IF L_OS_CMD_STAT <> 0 THEN */

            /* DELETE THE FILE BECUASE APPEND WAS SUCCESS */
            else do:

               /* NOW DELETE THE FILE IN THE CURRENT DIRECTORY */
               os-delete value(l_file_name).

               /* CHECK TO SE IF ERROR OCCURRED WHILE DELETING THE */
               /* FILE. IF SO GENERATE ERROR MESSAGE               */
               l_os_cmd_stat = os-error.

               if l_os_cmd_stat <> 0 then do:
                  assign
                     l_msg_num  = 4765
                     error-info = l_file_name + "," +
                     string(l_os_cmd_stat).

                  run error_proc
                     (input 2,
                      input no,
                      input l_exf_seq).

               end. /* IF L_OS_CMD_STAT <> 0 THEN */

            end. /* DELETE THE FILE BECUASE APPEND WAS SUCCESS */

         end. /* IF L_OS_CMD_STAT = 10 THEN - FILE EXISTS ALREADY */

         else do: /* SOME OTHER ERROR OCCURRED */

            assign
               l_msg_num  = 4763
               error-info = trim(l_file_name) + "," +
               string(l_os_cmd_stat).

            run error_proc
               (input 2,
                input no,
                input l_exf_seq).
         end.

      end. /* IF L_OS_CMD_STAT <> 0 THEN */

   end. /* IF I_ENTRY <= 30 THEN */

END PROCEDURE. /* PROCEDURE IP_OUTBOUND_PROCESS */

PROCEDURE ip_get_gtwy_prgm:
/*-------------------------------------------------------------------------
  Purpose:    Get the gateway program names to be run for
              each sequence number
  Parameters:
  Notes:
-------------------------------------------------------------------------*/

   if document_in then do:

      for each tt_doc_status exclusive-lock ,
         first edmfs_mstr where edmfs_mfd_seq = tt_doc_seq no-lock,
         first edmf_mstr where
               edmf_mfd_name = edmfs_mfd_name and
               edmf_mfd_vers = edmfs_mfd_vers and
               edmf_doc_in   = edmfs_doc_in
      no-lock:

         tt_gtwy_pgm = edmf_gtwy_pgm.

         create tt_gateway.
         assign
            tt_gtwy_seq = tt_doc_seq
            tt_prgm = edmf_gtwy_pgm.

         if recid(tt_gateway) = -1 then.

      end. /* FOR EACH TT_DOC_STATUS */

   end. /* IF DOCUMENT_IN */

   else do:

      /* If outbound, get the gateway program names */
      /* for the sequence numbers in i_file_list    */
      do i = 1 to num-entries(i_file_list,","):

         for each edmfs_mstr where edmfs_mfd_seq =
                                      integer(entry(i,i_file_list,","))
                                      no-lock,
            each edmf_mstr where edmf_mfd_name = edmfs_mfd_name and
                 edmf_mfd_vers = edmfs_mfd_vers and
                 edmf_doc_in = edmfs_doc_in
         no-lock:
            create tt_gateway.
            assign
               tt_gtwy_seq = integer(entry(i,i_file_list,","))
               tt_prgm = edmf_gtwy_pgm.
            if recid(tt_gateway) = -1 then.
         end.

      end.

   end. /* else do */

END PROCEDURE.

PROCEDURE error_proc:
/*-------------------------------------------------------------------------
  Purpose:    Process control file errors
  Parameters:
              i_err_level - VARIABLE TO INDICATE WHETHER THE ERROR IS
                            FATAL, WARNING OR MESSAGE
              i_is_err    - SETS ERROR FLAG
              i_exf_seq   - EXCHANGE DOCUMENT SEQUENCE NUMBER
  Notes:
-------------------------------------------------------------------------*/
   define input parameter i_err_level like edxfsdd_error_level no-undo.
   define input parameter i_is_err    as   logical             no-undo.
   define input parameter i_exf_seq   like edxfs_exf_seq       no-undo.

   define variable        l_msg_seq   like edxfsdd_msg_seq     no-undo.

   l_msg_seq = 1.

   if i_exf_seq = 0 then do:

      assign
         i_exf_seq = next-value(edxfs_sq01)
         proc_sess = next-value(edc_sq01)
         proclist  = proclist + "," + string(proc_sess).

      /* CREATE A ERROR RECORD IN EACH EXCHANGE FILE STATUS, */
      /* HISTORY, and MESSAGE TABLE                          */
      create edxfs_mstr.
      assign
         edxfs_exf_seq = i_exf_seq
         edxfs_status = 11
         edxfs_doc_in = document_in.

      if recid(edxfs_mstr) = -1 then.

      create edxfsd_det.
      assign
         edxfsd_exf_seq = i_exf_seq
         edxfsd_status = 11
         edxfsd_proc_sess = proc_sess
         edxfsd_proc_seq = 1
         edxfsd_proc_date = today
         edxfsd_proc_time = time.

      if recid(edxfsd_det) = -1 then.

   end. /* IF I_EXF_SEQ = 0 THEN */

   /* GET THE NEXT MESSAGE SEQUENCE NUMBER */
   else do:

      for first edxfs_mstr where edxfs_exf_seq = i_exf_seq no-lock:
         for first edxfsd_det where
                   edxfsd_exf_seq   = edxfs_exf_seq and
                   edxfsd_proc_sess = proc_sess and
                   edxfsd_proc_seq  = 1
         no-lock:
            for last edxfsdd_det where
                     edxfsdd_exf_seq   = edxfs_exf_seq and
                     edxfsdd_proc_sess = proc_sess and
                     edxfsdd_proc_seq  = edxfsd_proc_seq
            no-lock:
               l_msg_seq = edxfsdd_msg_seq + 1.
            end.
         end.
      end.

   end. /* GET THE NEXT MESSAGE SEQUENCE NUMBER */

   create edxfsdd_det.
   assign
      edxfsdd_exf_seq = i_exf_seq
      edxfsdd_proc_sess = proc_sess
      edxfsdd_proc_seq = 1
      edxfsdd_msg_seq = l_msg_seq
      edxfsdd_msg_no = l_msg_num
      edxfsdd_delm_str = error-info
      edxfsdd_error_level = i_err_level.

   if recid(edxfsdd_det) = -1 then.

   l_error = i_is_err.

END PROCEDURE.

PROCEDURE mfg_name_error_proc:
/*-------------------------------------------------------------------------
  Purpose:    Process file name errors on the MFG/PRO SIDE
  Parameters:
  Notes:
-------------------------------------------------------------------------*/

   /* CREATE A ERROR RECORD IN EACH MFG/PRO DOCUMENT STATUS,*/
   /* HISTORY, and MESSAGE TABLE                            */
   for first edmfs_mstr where edmfs_mfd_seq = fnerrorseq
   exclusive-lock: end.

   if not available edmfs_mstr then do:
      create edmfs_mstr.
      assign
         edmfs_mfd_seq = fnerrorseq
         edmfs_status = fnstatus
         edmfs_doc_in = document_in.
      if recid(edmfs_mstr) = -1 then.
   end.
   else
      edmfs_status = fnstatus.

   for first edmfsd_det
       where edmfsd_mfd_seq = fnerrorseq and
             edmfsd_proc_sess = proc_sess and
             edmfsd_proc_seq = procseq
   exclusive-lock: end.

   if not available edmfsd_det then do:
      create edmfsd_det.
      assign
         edmfsd_mfd_seq = fnerrorseq
         edmfsd_status = fnstatus
         edmfsd_proc_sess = proc_sess
         edmfsd_proc_seq = procseq
         edmfsd_proc_date = today
         edmfsd_proc_time = time.
      if recid(edmfsd_det) = -1 then.
   end.
   else
      edmfsd_status = fnstatus.

   for last edmfsdd_det where edmfsdd_mfd_seq = fnerrorseq
   no-lock: end.

   create edmfsdd_det.
   assign
      edmfsdd_mfd_seq = fnerrorseq
      edmfsdd_proc_sess = proc_sess
      edmfsdd_proc_seq = procseq
      edmfsdd_msg_seq = ( if available edmfsdd_det then
      edmfsdd_msg_seq else 0 ) + 1
      edmfsdd_msg_no = l_msg_num
      edmfsdd_delm_str = error-info
      edmfsdd_error_level = 4.

   if recid(edmfsdd_det) = -1 then.

   l_error = yes.

END PROCEDURE.  /* PROCEDURE mfg_name_error_proc */

PROCEDURE clear_tmp_tables:
/*-------------------------------------------------------------------------
  Purpose:    Clear all temp tables for the next session
  Parameters:
  Notes:
-------------------------------------------------------------------------*/

   for each tt_exf_status exclusive-lock:
      delete tt_exf_status.
   end.

   for each tt_doc_status exclusive-lock:
      delete tt_doc_status.
   end.

   for each tt_gateway exclusive-lock:
      delete tt_gateway.
   end.

   for each tt_seq_list exclusive-lock:
      delete tt_seq_list.
   end.

END PROCEDURE.
