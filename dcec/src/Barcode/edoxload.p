/* edoxload.p   - EDI - Transfer from Exchange File Rep. to Flat File         */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.45.1.2 $                                                               */
/*V8:ConvertMode=NoConvert                                                    */
/* REVISION: 9.0            CREATED: 04/06/98   BY: *M030* Vinod Kumar        */
/* REVISION: 9.0      LAST MODIFIED: 01/19/99   BY: *M05T* Dan Herman         */
/* REVISION: 9.0      LAST MODIFIED: 02/12/99   BY: *M07J* Paul Dreslinski    */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/23/99   BY: *M0BP* Julie Milligan     */
/* REVISION: 9.1      LAST MODIFIED: 07/01/99   BY: *N00T* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 07/13/99   BY: *M0D5* Reetu Kapoor       */
/* REVISION: 9.1      LAST-MODIFIED: 10/10/99   BY: *N051* Paul Dreslinski    */
/* REVISION: 9.1      LAST-MODIFIED: 03/03/00   BY: *M0KF* Paul Dreslinski    */
/* REVISION: 9.1      LAST-MODIFIED: 04/10/00   BY: *M0M2* Paul Dreslinski    */
/* REVISION: 9.1      LAST MODIFIED: 05/25/00   BY: *M0LR* Reetu Kapoor       */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0KW* Jacolyn Neder      */
/* Revision: 1.33     BY: Jean Miller     DATE: 06/14/01  ECO: *M11Z*       */
/* Revision: 1.34     BY: Paul Dreslinski DATE: 09/14/01  ECO: *P00Y*       */
/* Revision: 1.34     BY: A.R. Jayaram    DATE: 11/27/01  ECO: *N15W*       */
/* Revision: 1.35     BY: Dipesh Bector   DATE: 01/23/02  ECO: *M1TR*       */
/* Revision: 1.38     BY: Paul Dreslinski       DATE: 03/10/02  ECO: *P04S*  */
/* Revision: 1.39     BY: Paul Dreslinski       DATE: 06/08/02  ECO: *P07W* */
/* Revision: 1.42     BY: Paul Dreslinski       DATE: 08/20/02  ECO: *P0F6*  */
/* Revision: 1.43     BY: Vivek Gogte           DATE: 12/20/02  ECO: *N22H*  */
/* Revision: 1.44     BY: Paul Dreslinski       DATE: 02/25/03  ECO: *P0N3*  */
/* Revision: 1.45     BY: Paul Dreslinski       DATE: 04/29/03  ECO: *P0R2*  */
/* Revision: 1.45.1.1 BY: Sudheer DS           DATE: 06/04/03  ECO: *P0TX*  */
/* $Revision: 1.45.1.2 $     BY: Paul Dreslinski      DATE: 07/28/04  ECO: *P2CV*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*                                                                            */
/* Developed by : Vinod Kumar & Dan Herman                                    */
/*                                                                            */
/* Parameters:                                                                */
/*  INPUT    proc_sess  - Process session number                              */
/*  INPUT    chk_subsys - Name of the EC Subsystem                            */
/*                                                                            */
/* NOTE:-                                                                     */
/*                                                                            */
/*     *  A 'NULL' DEMILITER CHARACTER IS NOT SUPPORTED BY PROGRESS SO A      */
/*        'NULL' DELIMITER CHARACTER IS NOT VALID                             */
/*                                                                            */
/*     *  WHEN THE RECORD CODE POSITION FIELD IN THE 'EC SUBSYSTEM            */
/*        TABLE' IS SET TO '0' (IMMATERIAL OF FIXED OR VARIABLE) THEN         */
/*        RECORD CODE IS ATTACHED AS THE LAST FIELD IMMATERIAL OF THE         */
/*        LENGTH OF THE RECORD.                                               */
/*                                                                            */

/* ADDED ADDITIONAL LOGIC TO THE EXECUTION OF THE EXTERNAL PROGRAM         */
/* SUCH AS EDI-WINDOWS.                                                    */

{mfdeclre.i}

{gplabel.i}
{edtoken.i}
{edtmpdef.i}

define input parameter proc_sess  as   integer     no-undo.
define input parameter chk_subsys like edss_subsys no-undo.

define input-output    parameter table for tt_exf_status.

{edimttpv.i new}

define variable doc_in          like edsd_doc_in initial no no-undo.
define variable docseq          as   integer     initial 0  no-undo.

define variable prev_docseq     as   integer     initial 0  no-undo.
define variable seqlist         as   character              no-undo.
define variable seqctr          as   character              no-undo.

define variable msgnbr          like msg_nbr                no-undo.
define variable ctr             as   integer                no-undo.
define variable xfcontrol       as   logical    initial no  no-undo.
define variable xfseq           like edxrd_exf_rec_seq      no-undo.
define variable prev_xfcontrol  as   logical    initial no  no-undo.
define variable prev_xfseq      like edxrd_exf_rec_seq      no-undo.
define variable l_proc_script   like edtg_proc_scr          no-undo.
define variable l_trans_grp_err as   logical                no-undo.
define variable l_filename      as   character              no-undo.
define variable l_err_type      as   character              no-undo.
define variable l_start_seq     like edsd_rec_seq           no-undo.

define variable l_data_rec      as   character              no-undo.
define variable l_data_field    as   character              no-undo.
define variable xfline          as   character              no-undo.
define variable l_data          as   character              no-undo.
define variable l_delim         as   character              no-undo.
define variable l_new_position  as   integer                no-undo.
define variable l_fld_ctr       as   integer                no-undo.
define variable l_quote_char    as   character              no-undo.
define variable l_err_level     as   integer                no-undo.
define variable error_data      as   character              no-undo.
define variable l_retn_val      as   character              no-undo.
define variable l_format        as   character              no-undo.
define variable l_seq_prev      like  edxrd_exf_seq         no-undo.

define variable X             as integer              no-undo.
define variable hDoc          as handle               no-undo.
define variable hRoot         as handle               no-undo.
define variable hText         as handle               no-undo.
define variable hfield        as handle               no-undo.
define variable hTemp         as handle               no-undo.
define variable hCurr         as handle               no-undo.
define variable hNS           as handle               no-undo.
define variable hSchema       as handle               no-undo.
define variable useName       as character            no-undo.
define variable RecName       as character            no-undo.
define variable FldName       as character            no-undo.
define variable Y             as integer              no-undo.
define variable curr_struc_id like edxrd_exf_rec_stru no-undo.
define variable prev_struc_id like edxrd_exf_rec_stru no-undo.
define variable new_loop       as logical             no-undo.
define variable end_loop       as logical             no-undo.
define variable iterate_loop   as logical             no-undo.
define variable found          as logical             no-undo.
define variable loop-counter   as integer initial 0   no-undo.
define variable curr_level     as integer initial 0   no-undo.
define variable text-msg       as character           no-undo.
DEF SHARED VAR isfirst AS LOGICAL.
DEF SHARED VAR ismerge AS LOGICAL.
DEF SHARED VAR pre_vend AS CHAR.
define temp-table loop-stack no-undo
    field seq as integer
    field SeqRec as integer
    field SeqEnd as integer
    field PrimaryHandle as handle
    field parentHandle  as handle
    index seq is primary seq.

define variable loop-count as integer no-undo.

/* TEMPORARY TABLE FOR STORING THE CONTRUCTED RECORDS */
define temp-table tt_document no-undo
   field tt_seq_no as integer
   field tt_line as character
   index tt_idx tt_seq_no.

/* DEFINE TEMPORARY TABLE FOR STORING PROCESSING SCRIPT FILE NAME */
define temp-table tt_script no-undo
   field tt_script_name like edtg_proc_scr
   field tt_dtg_name    like edtg_dtg_name
   field tt_op_file     as   character.

/* GET THE DEFAULT SUBSYTEM NAME IF THE PASSED SUSBSYTEM IS BLANK */
if chk_subsys = "" then do:
   for first edc_ctrl no-lock: end.
   chk_subsys = edc_subsys.
end.

for first edss_mstr where edss_subsys = chk_subsys
no-lock: end.

if not available edss_mstr then
assign
   error_data = chk_subsys
   msgnbr    = 4411.
else
assign
   l_format = fill("X",edss_ecf_cde_len)
   l_delim    = chr(edss_ecf_delim)

   /* CONVERT QUOTE ASCII VALUE INTO CHARACTER */
   l_quote_char = (if edss_mstr.edss_ecf_quote > 0 then
                      chr(edss_ecf_quote)
                   else ? ).

TRANS_BLK:
for each tt_exf_status,
    each edxfs_mstr where
         edxfs_exf_seq = tt_exf_seq exclusive-lock
break by edxfs_dtg_name
      by edxfs_tp_id
      by edxfs_tp_doc:

   run removeObjects.

   /* UPDATE EXCHANGE FILE STATUS TO '42' (ERROR) */
   assign
      edxfs_status = 42
      msgnbr       = 0.

   for each tt_document exclusive-lock:
      delete tt_document.
   end.

   /* CREATE EXCHANGE FILE HISTORY RECORDS */
   run cr_exf_history
      (input edxfs_exf_seq,
       input proc_sess ).

   if msgnbr > 0 then do:
      /* 4411 Subsytem not found */
      run error_proc
         (input        edxfs_exf_seq,
          input        proc_sess,
          input        msgnbr,
          input        l_err_level,
          input        l_err_type,
          input-output l_trans_grp_err,
          input        error_data).

      next TRANS_BLK.
   end. /* IF MSGNBR > 0 */

   /* IF TRANSMISSION GROUP NAME CHANGES */
   if first-of(edxfs_dtg_name) or edss_ecf_fixed = ? then do:

      assign
         prev_struc_id = ""
         curr_struc_id = "".

      run get_trans_grp
         (input  edxfs_dtg_name,
          input  edxfs_exf_seq,
          output msgnbr,
          output l_err_type,
          output l_err_level,
          output l_trans_grp_err,
          output error_data,
          input-output chk_subsys).
   end.

   if msgnbr > 0 then do:
      /* 4401; 4416; 4417; 4423 */
      run error_proc
         (input        edxfs_exf_seq,
          input        proc_sess,
          input        msgnbr,
          input        l_err_level,
          input        l_err_type,
          input-output l_trans_grp_err,
          input        error_data).

      msgnbr = 0.
   end. /* IF MSGNBR > 0 */

   /* IF ERROR, SKIP THE CURRENT TRANSMISSION GROUP */

   if l_trans_grp_err then
      next TRANS_BLK.

   /* MAKE SURE THAT REPOSITORY MASTER RECORD EXISTS */
   for first edxr_mstr where
         edxr_exf_seq = edxfs_exf_seq no-lock:
   end.

   if not available edxr_mstr then do:

      /*Exchange File Repository master record not found.*/
      run error_proc
         (input        edxfs_exf_seq,
          input        proc_sess,
          input        4418,
          input        4,
          input        "SKIP-DOCUMENT",
          input-output l_trans_grp_err,
          input        "").

      next TRANS_BLK.

   end.

   /* ASSUMPTION:-
    * ------------
    * DATA RECORDS EXISTS IN 'EXCHANGE FILE REPOSITORY DETAIL' FOR
    * ALL THE VALID SEQUENCE NUMBERS SELECTED FROM 'EXCHANGE FILE
    * STATUS TABLE'.
    */

   if edss_ecf_fixed <> ? then do:
   /* LEAVE ROOM FOR CREATING CONTROL DATA FOR THE CURRENT RECORD */
   for last edsd_det where
         edsd_subsys = chk_subsys and
         edsd_doc_in = doc_in no-lock:
   end.

   if not available edsd_det then do:

      /* EC Subsystem Control record does not exist.*/
      error_data = chk_subsys + "; " + edxfs_dtg_name.
      run error_proc
         (input        edxfs_exf_seq,
          input        proc_sess,
          input        4419,
          input        4,
          input        "SKIP-DOCUMENT",
          input-output l_trans_grp_err,
          input        error_data).

      next TRANS_BLK.

   end. /* IF NOT AVAILABLE EDSD_DET */
   end. /* IF NOT XML */

   if not can-find(first edxrd_det where
                         edxrd_exf_seq = edxr_exf_seq )
   then do:

      /* Repository detail record does not exist for sequence */
      run error_proc
         (input        edxfs_exf_seq,
          input        proc_sess,
          input        4420,
          input        4,
          input        "SKIP-DOCUMENT",
          input-output l_trans_grp_err,
          input        ""  ).

      next TRANS_BLK.

   end. /* IF NOT CAN-FIND( FIRST EDXRD_DET WHERE */

   /* STARTING RECORD SEQUENCE NUMBER FOR REPOSITORY DETAIL */
   assign
      l_start_seq = if available edsd_det then edsd_rec_seq else 0
      seqlist     = ""
      x        = 0
      curr_level = 0
      seqctr      = "".

   /* BUILD DATA RECORDS */
   for each edxrd_det where
            edxrd_exf_seq = edxr_exf_seq no-lock
   on error undo TRANS_BLK, leave TRANS_BLK
   on endkey undo TRANS_BLK, leave TRANS_BLK:

      x = x + 1.


      for first edxf_mstr where
                edxf_exf_name = edxr_exf_name and
                edxf_exf_vers = edxr_exf_vers and
                edxf_doc_in   = doc_in        no-lock:
      end.

      if not available edxf_mstr then do:

         /* Exchange file record table record does not exist.*/
         error_data = edxr_exf_name + "; " + string(edxr_exf_vers) +
                      "; " + string(edxrd_exf_rec_seq).

         run error_proc
            (input        edxfs_exf_seq,
             input        proc_sess,
             input        4414,
             input        4,
             input        "SKIP-DOCUMENT",
             input-output l_trans_grp_err,
             input        error_data).

         next TRANS_BLK.

      end. /* IF NOT AVAILABLE EDXFD_DET */

      /* GET THE EXCHANGE FILE RECORD TABLE RECORD */
      for first edxfd_det where
                edxfd_exf_name = edxr_exf_name and
                edxfd_exf_vers = edxr_exf_vers and
                edxfd_doc_in   = doc_in        and
                edxfd_rec_seq  = edxrd_exf_rec_seq
      no-lock: end.

      if not available edxfd_det then do:

         /* Exchange file record table record does not exist.*/
         error_data = edxr_exf_name + "; " + string(edxr_exf_vers) +
                      "; " + string(edxrd_exf_rec_seq).

         run error_proc
            (input        edxfs_exf_seq,
             input        proc_sess,
             input        4414,
             input        4,
             input        "SKIP-DOCUMENT",
             input-output l_trans_grp_err,
             input        error_data).

         next TRANS_BLK.

      end. /* IF NOT AVAILABLE EDXFD_DET */

      /* SET THE CURRENT SEQUENCE NUMBER */
      xfseq = edxfd_rec_seq.


      /* VALIDATE SEQUENCE, LOOPING AND MANDATORY FOR THE
       * CURRENT RECORD AGAINST THE PREVIOUS RECORD
       * I.E. IS IT OKAY TO MOVE FROM THE PREV RECORD TO THE
       * CURRENT RECORD
       */

      if l_seq_prev <> edxrd_exf_seq
      then do:
         assign
            l_seq_prev = edxrd_exf_seq
            prev_xfseq = 0.
      end. /* IF l_seq_prev <> edxrd_exf_seq THEN */

      {gprun.i ""edchkseq.p""
         "(input """",
           input chk_subsys,
           input doc_in,
           input edxfd_exf_name,
           input edxfd_exf_vers,
           input prev_xfseq,
           input xfseq,
           input xfcontrol,
           input prev_xfcontrol,
           input-output seqlist,
           input-output seqctr,
           output msgnbr,
           output l_retn_val     )"}.

      if msgnbr <> 0 then do:
         /* 4402, 4405, 4413, 4414, 4415
          * 4402 returns <record name>; <exchange file name>; <version>.
          * 4405 returns <record code>.
          * 4413 returns <record sequence number>.
          * 4414 returns <exchange file name>; <version>; <record seq number>.
          * 4415 returns <exchange file name>; <version>; <record seq number>.
          */
         CASE msgnbr:
            when (4402) then
               error_data = chk_subsys + "; " + l_retn_val.
            when (4405) or when (4413) then
               error_data = l_retn_val + "; " + chk_subsys.
            otherwise
               error_data = l_retn_val.
         END CASE.

         run error_proc
            (input        edxfs_exf_seq,
             input        proc_sess,
             input        msgnbr,
             input        4,
             input        "SKIP-DOCUMENT",
             input-output l_trans_grp_err,
             input        error_data).

         next TRANS_BLK.

      end. /* IF MSGNBR <> 0 THEN */

      /* GET EC SUB.SYSTEM TO EXCHANGE FILE XREF RECORD */
      for first edsxx_ref where
                edsxx_subsys = chk_subsys             and
                edsxx_tp_doc = edxr_tp_doc            and
                edsxx_doc_in = doc_in                 and
                edsxx_tp_id = edxr_tp_id              and
                edsxx_exf_rec_seq = edxrd_exf_rec_seq and
                edsxx_break_lvl >= curr_level
      no-lock: end.

      if not available edsxx_ref then
      for first edsxx_ref where
                edsxx_subsys = chk_subsys             and
                edsxx_tp_doc = edxr_tp_doc            and
                edsxx_doc_in = doc_in                 and
                edsxx_tp_id = ""                      and
                edsxx_exf_rec_seq = edxrd_exf_rec_seq and
                edsxx_break_lvl >= curr_level
      no-lock: end.

      if not available edsxx_ref then
      for first edsxx_ref where
                edsxx_subsys = chk_subsys             and
                edsxx_tp_doc = edxr_tp_doc            and
                edsxx_doc_in = doc_in                 and
                edsxx_tp_id = edxr_tp_id              and
                edsxx_exf_rec_seq = edxrd_exf_rec_seq and
                edsxx_break_lvl < curr_level         no-lock:
      end.

      if not available edsxx_ref then
      for first edsxx_ref where
                edsxx_subsys = chk_subsys             and
                edsxx_tp_doc = edxr_tp_doc            and
                edsxx_doc_in = doc_in                 and
                edsxx_tp_id = ""                      and
                edsxx_exf_rec_seq = edxrd_exf_rec_seq and
                edsxx_break_lvl < curr_level         no-lock:
      end.

      if not available edsxx_ref then do:

         /* EC Subsystem to XREF record not available for exchange file
         Sequence
         */
         error_data = chk_subsys + "; " +
                      edxr_tp_doc + "; " +
                      string(edxrd_exf_rec_seq).

         run error_proc
            (input        edxfs_exf_seq,
             input        proc_sess,
             input        4421,
             input        4,
             input        "SKIP-DOCUMENT",
             input-output l_trans_grp_err,
             input        error_data).

         next TRANS_BLK.

      end. /* IF NOT AVAILABLE EDSXX_REF THEN */

      /* MAKE SURE THAT THERE IS A VALUE IN 'RECORD CODE' FIELD
       * FOR DATA RECORDS
      */
      else if edsxx_ecf_rec_cde = "" then do:

         /* Record code blank for 'Data Records'..*/

         error_data = chk_subsys + "; " +
                      edxr_tp_doc + "; " +
                      string(edxrd_exf_rec_seq).
         run error_proc
            (input        edxfs_exf_seq,
             input        proc_sess,
             input        4422,
             input        4,
             input        "SKIP-DOCUMENT",
             input-output l_trans_grp_err,
             input        error_data ).

         next TRANS_BLK.

      end.

      assign
        curr_level = edsxx_break_lvl
        recName    = if edxfd__qadc01 <> "" then
                        edxfd__qadc01 + ":" + edsxx_ecf_rec_cde
                     else
                        edsxx_ecf_rec_cde.

 if edss_ecf_fixed  = ? then do:
   if x = 1 then do:

       create x-document hDoc.
       create x-noderef hRoot.
       create x-noderef hCurr.

       if edxf_doc_type  <> "" then do:
          hDoc:initialize-document-type(
                         edxf_doc_xmlentity,
                         edxf_doc_type,
                         edxf_sys_literal,
                         edxf_pubid_literal).
       end. /* IF DOC TYPPE <> "" */

       hDoc:get-document-element(hRoot).
       hCurr = hRoot.
    end.

    run parse-struc (INPUT edxrd_exf_rec_stru).

    if iterate_loop THEN
        assign
        new_loop = yes
        end_loop = yes.

    if end_loop then do:
        found = no.
        do while not found:

            find last loop-stack exclusive-lock no-error.
            if available loop-stack then
            delete loop-stack.
            find last loop-stack no-lock no-error.
            if available loop-stack then do:
              assign
                hCurr = parentHandle
                hCurr = primaryHandle
                loop-count = loop-count - 1.
            if edxrd_exf_rec_seq > loop-stack.seqRec and
               edxrd_exf_rec_seq <= loop-stack.seqEnd then
                found = yes.
            end.
            if not available loop-stack theN
                assign
                  found = yes
                  hCurr = hRoot.
         end.
    end.

    if new_loop then do:
        loop-count = loop-count + 1.
        create loop-stack.
        assign
            loop-stack.seq    = loop-count
            loop-stack.seqRec = edxrd_exf_rec_seq
            loop-stack.seqEnd = edxfd_rec_lp_end
            parentHandle      = if x = 1 then hRoot else hCurr.


        if x = 1 and edxf_doc_type = "" then do:
           create x-noderef hRoot.
           assign
              loop-stack.primaryHandle = hRoot.
           hdoc:create-node(hRoot,RecName,"ELEMENT").
           hdoc:append-child(hRoot).
           hCurr = hRoot.

        end. /* IF X = 1 & DOC_TYPE = "" */
        else
        if x > 0 then do:
           create x-noderef hTemp.
           assign
               loop-stack.primaryHandle = hTemp.
               hDoc:CREATE-NODE(hTemp,RecName,"ELEMENT").
               hCurr:APPEND-CHILD(hTemp).
               hCurr = hTemp.
        end.

    END.
 end.

      /* ASSUMPTIONS:
       *
       * (.) IF THE DOCUMENT IS FIXED OR VARIABLE ONE THEN THE
       *     RECORD CODE IS EXPECTED AT ANY POSITION.
       * (.) IN FIXED THE POSITIOn REPRESENTS 'COLUMN POSITION'
       *     AND IN CASE OF VARIABLE, THE POSITION REPRESENTS
       *     'FIELD POSTION'.
       * (.) IN CASE OF FIXED, THE 'RECORD CODE' IS INSERTED AT
       *     THE POSITION SPECIFIED IN THE 'EC SUBSYSTEM TABLE'.
       * (.) IN CASE OF VARIABLE ONE, THE 'RECORD CODE' IS
       *     INSERTED AT THE SPECIFIED FIELD.
       * (.) BOTH DECIMAL AND INTEGER FIELDS WILL BE REPRESENTED
       *     BY 'REAL' (R) DATA TYPE IN 'EXCHANGE FILE DEFINITION'
       * (.) ALL REAL FIELDS WILL BE PREFIXED WITH ZEROS.
       * (.) ALL ALPHA-NUMNERIC FIELDS WILL BE SUFFIXED WITH
       *     BLANK SPACE.
       */

      assign
         l_data_rec     = ""
         l_new_position = edss_ecf_cde_pos
         l_fld_ctr      = 1.

      /* MAKE SURE THAT ALL MANDATORY FIELDS ARE PRESENT */
      for each edxfdd_det where
            edxfdd_exf_name = edxfd_exf_name and
            edxfdd_exf_vers = edxfd_exf_vers and
            edxfdd_doc_in   = edxfd_doc_in   and
            edxfdd_rec_seq  = edxfd_rec_seq
      no-lock:

         l_fld_ctr = edxfdd_fld_seq.

         /* MAKE SURE THAT MANDATORY FIELD EXISTS */
         if edxfdd_fld_reqd and
            edxrd_exf_fld[ l_fld_ctr ] = ""
         then do:

            /* Mandatory field " edxfdd_fld_name is blank */
            error_data = chk_subsys + "; " +
                         edxfd_exf_name + "; " +
                         string(edxfd_exf_vers) + "; " +
                         string(edxfdd_rec_seq) + "; " +
                         edxfdd_fld_name.
            run error_proc
               (input        edxfs_exf_seq,
                input        proc_sess,
                input        4409,
                input        4,
                input        "SKIP-DOCUMENT",
                input-output l_trans_grp_err,
                input        error_data ).

            next TRANS_BLK.

         end. /* IF EDXFDD_FLD_REQD AND */

         /* CHECK IF MINIMUM AND MAXIMUM FIELD LIMITS ARE MET */
         if (edxfdd_fld_reqd or
            length( edxrd_exf_fld[ l_fld_ctr ]) > 0 ) and
            (length( edxrd_exf_fld[ l_fld_ctr ]) < edxfdd_fld_min or
             length( edxrd_exf_fld[ l_fld_ctr ]) > edxfdd_fld_max )
         then do:

            /*Field " edxfdd_fld_name exceeded its min. and max. limits  */
            error_data = chk_subsys + "; " +
                         edxfdd_exf_name + "; " +
                         string(edxfdd_exf_vers) + "; " +
                         string(edxfdd_rec_seq) + "; " +
                         edxfdd_fld_name + "; " +
                         string(length(edxrd_exf_fld[ l_fld_ctr ])).

            run error_proc
               (input        edxfs_exf_seq,
                input        proc_sess,
                input        4410,
                input        4,
                input        "SKIP-DOCUMENT",
                input-output l_trans_grp_err,
                input        error_data).

            next TRANS_BLK.

         end. /* IF ( EDXFDD_FLD_REQD OR */

         /* SET THE NECESSARY TOKEN INFORMATION */
         if edxfdd_fld_token <> "" then
            run set_token
               (input edxfdd_fld_token,
                input edxrd_exf_fld[ l_fld_ctr ]).

      if edss_ecf_fixed = ? then do:
        IF edxrd_exf_fld[l_fld_ctr] <> ""  THEN DO:

           fldName = "".
           if edxfdd_xml_tag <> "" then
              useName = if edxfdd__qadc01 <> "" then
                           edxfdd__qadc01 + ":" + edxfdd_xml_tag
                        else
                           edxfdd_xml_tag.
           else
              useName = if edxfdd__qadc01 <> "" then
                           edxfdd__qadc01 + ":" + edxfdd_fld_name
                        else
                           edxfdd_fld_name.

           repeat Y = 1 to length(useName):
               fldName = fldName + (if substring(useName,Y,1) <> "" then
                         substring(useName,Y,1)
                         else "").
           end.

           if not edxfdd_tag_type or
                  edxfdd_tag_type = ? then do:

              create x-noderef hfield.
              hDoc:CREATE-NODE(hfield,fldName,"ELEMENT").
              hCurr:APPEND-CHILD(hfield).


              create X-NODEREF hText.
              hDoc:CREATE-NODE(hText,"","Text").
              hfield:APPEND-CHILD(hText).
              hText:NODE-VALUE = STRING(edxrd_exf_fld[l_fld_ctr]).
           end.
           else
              hCurr:SET-ATTRIBUTE(fldName,edxrd_exf_fld[l_fld_ctr]).

        end.

      end.
         /* IF FIXED THEN PAD WITH ZEROS/BLANK SPACE */
         else if edss_ecf_fixed then do:

            /* PREFIX ZEROS IF FIELD TYPE IF 'REAL'/'TIME' */
            if lookup(edxfdd_fld_type,"R,TM" ) > 0 then
               l_data_field =
                  fill( "0",( edxfdd_fld_max -
                  length( trim(edxrd_exf_fld[ l_fld_ctr ],"")))) +
                  trim( edxrd_exf_fld[ l_fld_ctr ],"").

            /* SUFFIX BLANK SPACE FOR OTHER FIELDS */
            else
            if  edxrd_exf_fld [ l_fld_ctr ] = ? then do:
               l_data_field = fill( " ", edxfdd_fld_max).
            end.

            else
               l_data_field = substring(edxrd_exf_fld[ l_fld_ctr ] +
                              fill( " ",edxfdd_fld_max ),1,
                              edxfdd_fld_max ).

            /* CONSTRUCT DATA RECORD */
            l_data_rec  = l_data_rec + l_data_field.

         end. /* IF EDSS_EXF_FIXED THEN */

         else do: /* VARIABLE FORMAT */

            l_data_field = edxrd_exf_fld[ l_fld_ctr ].

            if l_fld_ctr < edss_ecf_cde_pos and
               (num-entries( l_data_field,l_delim ) - 1 ) > 0
            then
               l_new_position = l_new_position +
                                num-entries( l_data_field,l_delim ) - 1.

            /* CONSTRUCT DATA RECORD */
            l_data_rec  = l_data_rec +
                         (if edxfdd_fld_type = "AN" and edss_ecf_quote > 0 then
                             l_quote_char + l_data_field + l_quote_char
                          else l_data_field ) + l_delim.

         end. /* VARIABLE FORMAT */

      end. /* FOR EACH EDXFDD_DET WHERE */

      /* REMOVE THE LAST DELIMITER */
      if edss_ecf_fixed <> ? then
      if not edss_ecf_fixed and
         substring( l_data_rec,length( l_data_rec ),1 ) = l_delim
      then
         l_data_rec = substring( l_data_rec,1, length( l_data_rec ) - 1 ).

      if edss_ecf_fixed then do:

         if edss_ecf_cde_pos <> 0 then
            substring( l_data_rec,edss_ecf_cde_pos,0) = string(edsxx_ecf_rec_cde,l_format).
         else
            l_data_rec = l_data_rec + string(edsxx_ecf_rec_cde,l_format).

      end. /* IF EDSS_ECF_FIXED THEN */

      else do: /* VARIABLE FORMAT */

         /* GET THE NEW FIELD POSITION */
         if l_new_position <> 0 and
            l_new_position <= num-entries( l_data_rec, l_delim )
         then
            entry(l_new_position,l_data_rec,l_delim ) =
               edsxx_ecf_rec_cde + l_delim +
               entry( l_new_position,l_data_rec, l_delim ).

         /* ADD THE BALANCE DELIMITER AND AT THE END OF THE */
         /* RECORD, ADD THE 'RECORD CODE'                   */
         else if l_new_position <> 0 then do:
            do ctr = num-entries(l_data_rec, l_delim) to l_new_position - 1:
               l_data_rec = l_data_rec + l_delim.
            end.
            l_data_rec = l_data_rec + edsxx_ecf_rec_cde.
         end.
         else if l_new_position = 0 then
            l_data_rec = l_data_rec + l_delim + edsxx_ecf_rec_cde.
      end.

      /* INSERT RECORDS INTO TEMPORARY TABLE */
      create tt_document.
      assign
         l_start_seq = l_start_seq + 1
         tt_seq_no   = l_start_seq
         tt_line     = l_data_rec
         prev_xfseq  = xfseq.

   end. /* FOR EACH EDXRD_DET WHERE */


   /* DONE WITH  CREATION OF DATA PORTION OF DOCUMENT */


   /* MAKE SURE THAT NO MANDATORY DATA RECORDS ARE MISSED FROM */
   /* CURRENT RECORD SEQUENCE NUMBER TILL END-OF-TABLE         */
   run val_data2eot
      (input edxfd_exf_name,
       input edxfd_exf_vers,
       input edxfd_doc_in,
       input edxfd_rec_seq,
       output msgnbr,
       output error_data).

   if msgnbr > 0 then do:

      /* Mandatory data record is missing in exchange file repository detail.*/
      run error_proc
         (input        edxfs_exf_seq,
          input        proc_sess,
          input        msgnbr,
          input        4,
          input        "SKIP-DOCUMENT",
          input-output l_trans_grp_err,
          input        error_data  ).

      next TRANS_BLK.

   end. /* IF MSGNBR > 0 THEN */

   /* BUILDING CONTROL RECORDS AND INSERT THEM INTO TEMP-TABLE */

   if edss_ecf_fixed <> ? then
   /* FOR EACH RECORD IN EC SUBSYSTEM CONTROL TABLE */
   for each edsd_det where
            edsd_subsys = chk_subsys and
            edsd_doc_in = doc_in
   no-lock:

      /* MAKE SURE THAT THERE IS A VALUE IN RECODE CODE FIELD */
      if edsd_rec_cde = "" then do:

         error_data = chk_subsys + "; " +
                      edsd_rec_name + "; " +
                      string(edxrd_exf_rec_seq).

         run error_proc
            (input        edxfs_exf_seq,
             input        proc_sess,
             input        4728,
             input        4,
             input        "SKIP-DOCUMENT",
             input-output l_trans_grp_err,
             input         error_data     ).

         next TRANS_BLK.
      end.

      assign
         xfline         = ""
         l_data_rec     = ""
         l_new_position = edss_ecf_cde_pos
         l_fld_ctr      = 0.

      for each edsdd_det where
            edsdd_subsys = edsd_subsys and
            edsdd_doc_in = edsd_doc_in and
            edsdd_rec_seq = edsd_rec_seq
      no-lock:

         assign
            l_data    = ""
            l_fld_ctr = l_fld_ctr + 1 .

         CASE edsdd_fld_token:
            when ("")                   then
               l_data = edsdd_default.
            when ("tp-id")              then
               l_data = edxr_tp_id.
            when ("tp-document-id")     then
               l_data = edxr_tp_doc.
            when ("tp-message-nbr")     then
               l_data = if tp-message-nbr = "" then edxr_tp_msg_no
                        else tp-message-nbr.
            when ("tp-func-grp-nbr")    then
               l_data = if tp-func-grp-nbr = "" then edxr_tp_fg_no
                        else tp-func-grp-nbr.
            when ("tp-document-nbr")    then
               l_data = if tp-document-nbr = "" then edxr_tp_doc_ref
                        else tp-document-nbr.
            when ("tp-address")         then
               l_data = if tp-address = "" then edxr_tp_addr else tp-address.
            when ("tp-site")            then
               l_data = if tp-site = "" then edxr_tp_site else tp-site.
            when ("tp-interchange-nbr") then
                  l_data = if tp-interchange-nbr = "" then edxr_tp_ic_no
                           else tp-interchange-nbr.

            /* THERE MAY BE MORE TOKENS TO GO IN HERE LATER */

         end.  /* case edsdd_fld_token */

         if edsdd_fld_req and
            (length( l_data ) < edsdd_fld_min or
             length( l_data ) > edsdd_fld_max )
         then do:

            /*Mandatory Control Token limits are not met.*/
            error_data = chk_subsys + "; " +
                         string(edsdd_rec_seq) + "; " +
                         edsdd_fld_name + "; " + edsdd_fld_token +
                         "; " + string(length(l_data)).
            run error_proc
               (input        edxfs_exf_seq,
                input        proc_sess,
                input        4425,
                input        4,
                input        "SKIP-DOCUMENT",
                input-output l_trans_grp_err,
                input        error_data).

            next TRANS_BLK.
         end.

         /* ASSUMPTION:                                               */
         /* IF THE CONTROL FIELD RECORD FIELD IS OPTIONAL AND HAS A   */
         /* TOKEN ASSIGNED TO IT, THE TOKEN CAN CONTAIN A NULL VALUE. */
         if not edsdd_fld_req                        and
            edsdd_fld_token      <> ""               and
            l_data               <> ""               and
            (length( l_data )   <  edsdd_fld_min    or
             length( l_data ) >  edsdd_fld_max )
         then do:

            /* Optional Control Token limits are not met.*/
            error_data = chk_subsys + "; " +
                         string(edsdd_rec_seq) + "; " +
                         edsdd_fld_name + "; " + edsdd_fld_token +
                         "; " + string(length(l_data)).
            run error_proc
               (input        edxfs_exf_seq,
                input        proc_sess,
                input        4426,
                input        4,
                input        "SKIP-DOCUMENT",
                input-output l_trans_grp_err,
                input        error_data).

            next TRANS_BLK.

         end.

         /* IF THE STRING LENGTH OF L_DATA IS BETWEEN THE MINIMUM  */
         /* AND MAXIMUM LENGTH VALUES THEN PAD SPACES IF IN FIXED  */
         /* FORMAT.                                                */
         if edss_ecf_fixed then
            if (edsdd_fld_max - length( l_data )) > 0 then
               l_data_rec = l_data_rec + l_data +
                            fill( " ",edsdd_fld_max - length( l_data )).
            else
               l_data_rec = l_data_rec + l_data.

         else do:  /* VARIABLE FORMAT */

            /* GET THE NEW FIELD POSITION */
            if l_fld_ctr < edss_ecf_cde_pos and
               ( num-entries( l_data,l_delim ) - 1 ) > 0
            then
               l_new_position = l_new_position +
                                num-entries( l_data,l_delim ) - 1.

            /* BUILD THE CONTROL RECORD */
            l_data_rec = l_data_rec +
                         (if index( l_data,l_delim ) > 0 then
                             "~`" + l_data + "~`"
                          else l_data ) + l_delim.

         end. /* VARIABLE FORMAT */

      end.   /* FOR EACH EDSDD_DET   */

      /* REMOVE THE LAST DELIMITER */

      if not edss_ecf_fixed and
         substring(l_data_rec,length(l_data_rec ),1) = l_delim
      then
         l_data_rec = substring( l_data_rec,1, length( l_data_rec ) - 1 ).

      /* DIDN'T FIND RECORD(S) IN  'EC SUSBSYTEM CONTROL */
      /* RECORD FIELD TABLE                              */

      if  l_data_rec = ""
      and edsd_rec_reqd
      then do:

         /* EC Sub.System control field records not found..*/
         error_data = chk_subsys + "; " + string(edxfs_exf_seq).
         run error_proc
            (input        edxfs_exf_seq,
             input        proc_sess,
             input        4427,
             input        4,
             input        "SKIP-DOCUMENT",
             input-output l_trans_grp_err,
             input        error_data).

         next TRANS_BLK.

      end. /* IF l_data_rec ... */

      if edss_ecf_fixed then do:

         if edss_ecf_cde_pos <> 0 then
            substring( l_data_rec,edss_ecf_cde_pos,0) =
               string(edsd_rec_cde,l_format).
         else
            l_data_rec = l_data_rec + string(edsd_rec_cde,l_format).

         xfline = l_data_rec.

      end. /* IF EDSS_ECF_FIXED THEN */

      else do: /* VARIABLE FORMAT */

         /* IF THE 'RECORD CODE' POSITION IS WITHIN THE MAXIMUM */
         /* NO.OF FIELDS IN CONTROL RECORD THEN INSERT THE      */
         /* 'RECORD CODE' AT THE SPECIFIED POSITION             */
         if l_new_position <= num-entries( l_data_rec, l_delim ) and
            l_new_position <> 0
         then
            entry(l_new_position,l_data_rec,l_delim ) =
               edsd_rec_cde + l_delim +
               entry(l_new_position,l_data_rec,l_delim ).

         /* ADD THE BALANCE DELIMITER AND AT THE END OF THE */
         /* RECORD, ADD THE 'RECORD CODE'                   */
         else if l_new_position <> 0 then do:
            do ctr = num-entries( l_data_rec, l_delim ) to
                  l_new_position - 1:
               l_data_rec = l_data_rec + l_delim.
            end.
            l_data_rec = l_data_rec + edsd_rec_cde.
         end.
         else if l_new_position = 0 then
               l_data_rec = l_data_rec + l_delim + edsd_rec_cde.

         xfline     = l_data_rec.

      end. /* VARIABLE FORMAT */

      edxfs_file_name = (if num-entries(l_filename,"/") > 1 then
                         trim(substring(entry(num-entries
                           (l_filename,"/" ),l_filename,"/"),1,12))
                         else
                         trim(substring(entry(num-entries
                           (l_filename,"~\"),l_filename,"~\"),1,12))).

      create tt_document.
      assign
         tt_seq_no = edsd_rec_seq
         tt_line   = xfline.

   end. /* FOR EACH EDSD_DET */

   if edss_ecf_fixed = ? then  do:

      hDoc:SAVE("file",l_filename).
      hDoc:SAVE("memptr",tt_xmlptr).
      run removeObjects.
   end.
   else if edss_ecf_fixed <> ? then  do:
   /* OUTPUT ALL RECORDS FOR THE CURRENT DOC.           */
   /* SEQEUNCE NUMBER TO THE FILE AND DELETE THE RECORD */
       
       output to value(l_filename) append.
 FIND FIRST tt_document WHERE  substring(tt_line,1,4) = '830a' NO-LOCK.
   IF isfirst THEN do:
       pre_vend = SUBSTRING(tt_line,6,5).
            
         END.
       ELSE
           IF pre_vend = SUBSTRING(tt_line,6,5) THEN ismerge = YES.
           ELSE ismerge = NO.
   for each tt_document exclusive-lock:
       IF isfirst THEN DO:
                /* DISP tt_line.*/
       put unformatted tt_line skip.
           END.
      ELSE DO:
          IF ismerge THEN DO:
         
            IF SUBSTRING(tt_line,1,4) = '830p' OR SUBSTRING(tt_line,1,4) = '830f' THEN
               put unformatted tt_line skip.
              
              END.
          ELSE
               
              put unformatted tt_line skip.
          END.
           delete tt_document.
   end.
   put unformatted skip.

   output close.
   isfirst = NO.
   end.

   edxfs_status = 43. /* SUCCESSFUL */

   /* UPDATE EXCHANGE FILE HISTORY TABLE TO '43' (SUCCESS) */

   for first edxfsd_det where
         edxfsd_exf_seq = edxfs_exf_seq and
         edxfsd_proc_sess = proc_sess   and
         edxfsd_proc_seq  = 1
   exclusive-lock: end.

   edxfsd_status = 43. /* SUCCESSFUL */

   /* NEED TO SETUP THE TRACKING HERE */
   TRACKLOOP:
   do:
      if edxr_tp_doc_ref = "" then do:
            run error_proc
               (input        edxfs_exf_seq,
                input        proc_sess,
                input        5695,
                input        2,
                input        "SKIP",
                input-output l_trans_grp_err,
                input        "").
            leave TRACKLOOP.
      end.

      for first edtpd_det where edtpd_tp_id = edxr_tp_id and
                           edtpd_tp_doc = edxr_tp_doc and
                           edtpd_doc_in = doc_in no-lock:

         if edtpd__qadl01   /*TRACKING SETUP TRACKING DOCUMENT */
         then do:

            find qad_wkfl
               where qad_key1 = "ECDocTrack" and
                     qad_key2 = edxr_tp_id + "|" + edxr_tp_doc_ref
                                           + "|" + edxr_tp_doc
            exclusive-lock no-error.

            if not available qad_wkfl then
               create qad_wkfl.

            text-msg = getTermLabel("NONE_EXPECTED",20).
            assign qad_key1 = "ECDocTrack"
                   qad_key2 = edxr_tp_id + "|" + edxr_tp_doc_ref + "|"
                            + edxr_tp_doc
                   qad_key3 = edxr_tp_doc
                   qad_key4 = edxr_tp_doc_ref
                   qad_key6 = string(edxfs_exf_seq).
            assign qad_charfld[1] = getTermLabel("EXPORTED",10)
                   qad_charfld[15] = if edtpd__qadl02 then "" /* EXPECT ACKS */
                                     else text-msg
                   qad_datefld[1] = today
                   qad_intfld[1] = time.
         end.
      end.
   end.

   /* STORE PROCESSING SCRIPT FILE NAME */
   if l_proc_script <> "" then do:
      create tt_script.
      assign
         tt_script_name = l_proc_script
         tt_op_file     = l_filename
         tt_dtg_name    = edxfs_dtg_name.
   end.

end. /* TRANS_BLK: FOR EACH TT_EXF_STATUS */

/* EXECUTE ALL THE PROCESSING SCRIPTS */

for each tt_script break by tt_dtg_name:

   if not first-of(tt_dtg_name) then
      next.

   for first edtg_mstr where edtg_dtg_name = tt_dtg_name no-lock: end.

   if available edtg_mstr and edtg__qadc01 <> "" then do:

      run setupParams.

      if edtg__qadc01 = "edwin.p" then
        /* RUN THE DOC. TRANS. GROUP EXPORT PROGRAM (EDTG__QADC01) */
        {gprun.i edtg__qadc01
           "(input tt_dtg_name,
             input tt_script_name,
             input tt_op_file)"}
      else do:
         {gprun.i edtg__qadc01
            "(input table ttParamValues,
              input tt_xmlptr,
              input-output table tt_msg_det,
              output tt_succ)"}

          for each tt_msg_det no-lock:
              run error_proc
                 (input        edxfs_exf_seq,
                  input        proc_sess,
                  input        tt_msg_msg_no,
                  input        2,
                  input        "SKIP",
                  input-output l_trans_grp_err,
                  input        tt_msg_delm_str).
          end.
      end.

      if false then
      {gprun.i ""edwin.p""
         "(input tt_dtg_name,
           input tt_script_name,
           input tt_op_file)"}

   end.  /* AVAIL EDTG_MSTR AND EDTG__QADC01 <> "" */
   else
      /* Run Script File */
      os-command silent value( tt_script_name + " " + tt_op_file ).
end.


PROCEDURE setUpParams:

   /* Purpose: Setup a temp table with values from the processing
   which are passed to the next process so users can do what
   they wish to do within the processing scripts

   Parameters:
   **********************************************************/

   define variable l_counter as integer no-undo.
   define variable l_flds    as character no-undo.
   define variable l_values  as character no-undo.

   assign l_flds = "fileName,Seq,procSess,tp-id,tp-document-id,tp-message-nbr,"
                 + "tp-func-grp-nbr,tp-interchange-nbr,tp-document-nbr,"
                 + "tp-address,tp-site,ScriptName,TransGrp"

      l_Values = tt_script.tt_op_file     + ","
      + string(edxfs_mstr.edxfs_exf_seq)  + ","
      + string(proc_sess)                 + ","
      + tp-id                             + ","
      + tp-document-id                    + ","
      + tp-message-nbr                    + ","
      + tp-func-grp-nbr                   + ","
      + tp-interchange-nbr                + ","
      + tp-document-nbr                   + ","
      + tp-address                        + ","
      + tp-site                           + ","
      + tt_script_name                    + ","
      + tt_dtg_name .

   repeat l_counter = 1 to num-entries(l_flds):
      create ttParamValues.
      assign tt_seq        = l_counter
         tt_paramName  = entry(l_counter,l_flds)
         tt_paramValue = entry(l_counter,l_values) .
   end.
END PROCEDURE.

PROCEDURE error_proc:
/*-------------------------------------------------------------------------
  Purpose:     Process any and all error messages
  Parameters:
               i_docseq    - Document Sequence Number
               i_proc_sess - Process Session Number
               i_msgnbr    - Message Number
               i_err_level - Error Level
               i_err_type  - Type of error - SKIP-TRANS-GRP
                                             ABORT-PROCESS
                                             SKIP-DOCUMENT
               i_err_data  - value that caused the error
  Notes:
-------------------------------------------------------------------------*/
   define input parameter i_docseq    as integer   no-undo.
   define input parameter i_proc_sess as integer   no-undo.
   define input parameter i_msgnbr    as integer   no-undo.
   define input parameter i_err_level as integer   no-undo.
   define input parameter i_err_type  as character no-undo.
   define input-output parameter io_trans_grp_err as logical   no-undo.
   define input parameter i_err_data  as character  no-undo.

   define variable l_msg_seq          as integer initial 0 no-undo.

   /* CREATE EXCHANGE FILE HISTORY RECORD */
   for first edxfsd_det where
             edxfsd_exf_seq   = i_docseq    and
             edxfsd_proc_sess = i_proc_sess and
             edxfsd_proc_seq  = 1
   no-lock: end.

   if not available edxfsd_det then
   run cr_exf_history
      (input i_docseq,
       input i_proc_sess ).

   /* GET THE LAST MESSAGE SEQUENCE NUMBER AND INCREMENT IT */
   for last edxfsdd_det where
            edxfsdd_exf_seq = i_docseq
   no-lock: end.

   assign
      l_msg_seq = (if available edxfsdd_det then edxfsdd_msg_seq
                   else 0 ) + 1
      io_trans_grp_err = (if i_err_type = "SKIP-TRANS-GRP" or
                             i_err_type = "ABORT-PROCESS" then yes
                          else no ).

   create edxfsdd_det.
   assign
      edxfsdd_exf_seq     = i_docseq
      edxfsdd_proc_sess   = i_proc_sess
      edxfsdd_msg_seq     = l_msg_seq
      edxfsdd_msg_no      = i_msgnbr
      edxfsdd_error_level = i_err_level
      edxfsdd_proc_seq    = 1
      edxfsdd_delm_str    = i_err_data.

   if recid( edxfsdd_det ) = -1 then .

END PROCEDURE.  /* PROCEDURE ERROR_PROC */

PROCEDURE cr_exf_history:
/*----------------------------------------------------------------
  Purpose:    Create Exchange File History Table
  Parameters:
              i_docseq    - Document Sequence Number
              i_proc_sess - Process Session Number

  Notes:
----------------------------------------------------------------*/
   define input parameter i_docseq    as integer   no-undo.
   define input parameter i_proc_sess as integer   no-undo.

   /* CREATE EXCHANGE FILE HISTORY RECORDS */
   create edxfsd_det.
   assign
      edxfsd_exf_seq   = i_docseq
      edxfsd_status    = 42
      edxfsd_proc_sess = i_proc_sess
      edxfsd_proc_date = today
      edxfsd_proc_time = time
      edxfsd_proc_seq  = 1.

   if recid( edxfsd_det ) = -1 then .

END PROCEDURE. /* PROCEDURE CR_EX_HISTORY */

PROCEDURE get_trans_grp:
/*-------------------------------------------------------------------------
  Purpose:    Get The Transmission Group Name
  Parameters:
              i_dtg_name       - Document Transmission Group Name
              i_exf_seq        - Document Sequence Number
              o_msgnbr         - Message Number
              o_err_level      - Error Level
              o_trans_grp_err  - Is there a transmission group error
              io_chk_subsys    - The subsystem used by the transmission grp
              o_err_data       - error information
  Notes:
-------------------------------------------------------------------------*/
   define input     parameter i_dtg_name       like edxfs_dtg_name no-undo.
   define input     parameter i_exf_seq        like edxfs_exf_seq  no-undo.

   define output parameter       o_msgnbr        as integer   no-undo.
   define output parameter       o_err_type      as character no-undo.
   define output parameter       o_err_level     as integer   no-undo.
   define output parameter       o_trans_grp_err as logical   no-undo.
   define output parameter       o_err_data      as character no-undo.
   define input-output parameter io_chk_subsys   as character no-undo.
   define variable l_dir as character no-undo.

   assign
      o_err_type = ""
      o_err_data = "".

   for first edtg_mstr where
             edtg_dtg_name = i_dtg_name
   exclusive-lock: end.

   if not available edtg_mstr then do:

      /* Invalid Document Transmission Group Name.*/
      assign
         o_msgnbr   = 4416
         o_err_type = "SKIP-TRANS-GRP"
         o_err_level = 4
         o_trans_grp_err = yes
         o_err_data = i_dtg_name.

      return.

   end. /* IF NOT AVAILABLE EDTG_MSTR */

   /* Assign the correct subsystem based on trans group */
   if edtg_subsys <> "" then
      io_chk_subsys = edtg_subsys.

   if edtg_dest_dir = "" or edtg_dest_prefix = "" then do:

      /* Destination Dir / File Prefix is blank..*/
      assign
         o_msgnbr   = 4417
         o_err_type = "SKIP-TRANS-GRP"
         o_err_level = 4
         o_trans_grp_err = yes
         o_err_data = i_dtg_name.

      return.

   end.

   /* CHECK IF THE DIRECTORY EXISTS */
   file-info:filename = edtg_dest_dir.

   if file-info:file-type = ? then do:

      /* DIRECTORY DOES NOT EXISTS */
      /* CREATING DIRECTORY */
      os-create-dir value( file-info:full-pathname ).

      if os-error <> 0 then do:

         /* UNABLE TO CREATE DIRECTORY */
         assign
            o_msgnbr    = 4423
            o_err_type  = "SKIP-TRANS-GRP"
            o_err_level = 4
            o_trans_grp_err = yes
            o_err_data = edtg_dest_dir + "," + i_dtg_name.

         return.

      end. /* IF OS-ERROR <> 0 THEN */

   end.

   /* CHECK IF USER HAS WRITE PERMISSION IN THE DIRECTORY */
   /* SPECIFIED IN THE MFG/EC CONTROL TABLE               */
   else if index( file-info:file-type,"W" ) = 0 then do:

      /*  User doesn't have write permission in directory */
      assign
         o_msgnbr    = 4401
         o_err_type  = "SKIP-TRANS-GRP"
         o_err_level = 4
         o_trans_grp_err = yes
         o_err_data = edtg_dest_dir.

      return.

   end.

   /* Assumption : The destination dir. ends with a '/' or   */
   /* '\' depending on the operating system....              */
   for first edss_mstr
      where edss_subsys = edtg_subsys
      no-lock:

      /* FIELD VALUES SHOULD BE ASSIGNED FROM THE SUBSYSTEM  */
      /* USED FOR EXPORTING DOCUMENT                         */
      assign
         l_delim        = chr(edss_ecf_delim)
         l_format       = fill("X",edss_ecf_cde_len)
         l_quote_char   = if edss_mstr.edss_ecf_quote > 0
                          then
                             chr(edss_ecf_quote)
                          else
                             ?.
   end.


   l_format = fill("x",edss_ecf_cde_len).

   file-info:file-name = edtg_dest_dir.
   l_dir = file-info:full-pathname.

   {gprun.i ""edcvtdir.p"" "(INPUT-OUTPUT l_dir)"}

   assign
      l_filename      = l_dir + edtg_dest_prefix +
                        string( edtg_dtg_ctrl ) + "." + edss_ecf_ext
      edtg_dtg_ctrl   = edtg_dtg_ctrl + 1
      l_trans_grp_err = no
      l_proc_script   = edtg_proc_scr.

END PROCEDURE. /* PROCEDURE GET_TRANS_GRP */

PROCEDURE set_token:
/*-------------------------------------------------------------------------
  Purpose:    Update Token Variables Using Exchange File Reposiroty Detail
  Parameters:
              i_token    - Token To Update
              i_value    - Token value
  Notes:
-------------------------------------------------------------------------*/
   define input parameter i_token like edsdd_fld_token no-undo.
   define input parameter i_value as character no-undo.

   /* ASSIGN TOKEN VARIABLES */
   CASE i_token:

      when ("tp-id")              then tp-id              = trim(i_value).
      when ("tp-document-id")     then tp-document-id     = trim(i_value).
      when ("tp-message-nbr")     then tp-message-nbr     = trim(i_value).
      when ("tp-func-grp-nbr")    then tp-func-grp-nbr    = trim(i_value).
      when ("tp-interchange-nbr") then tp-interchange-nbr = trim(i_value).
      when ("tp-document-nbr")    then tp-document-nbr    = trim(i_value).
      when ("tp-address")         then tp-address         = trim(i_value).
      when ("tp-site")            then tp-site            = trim(i_value).

   end.  /* CASE I_TOKEN */

END PROCEDURE.  /* PROCEDURE UP_TOKEN */

PROCEDURE val_data2eot:
/*-------------------------------------------------------------------------
  Purpose:    Make Sure That No Mandatory Data Records Are Missed
              From Currnet Record To End-Of-Table
  Parameters:
              i_xfname  - Exchange File Name
              i_xfvers  - Exchange File Verwion
              i_doc_in  - Document Direction
              i_rec_seq - Record Sequence Number
              i_msgnbr  - Message Number
              o_err_data - error information
  Notes:
-------------------------------------------------------------------------*/
   define input parameter i_xfname like edxfd_exf_name no-undo.
   define input parameter i_xfvers like edxfd_exf_vers no-undo.
   define input parameter i_doc_in like edxfd_doc_in   no-undo.
   define input parameter i_rec_seq like edxfd_rec_seq  no-undo.
   define output parameter i_msgnbr  as integer        no-undo.
   define output parameter o_err_data as character     no-undo.

   for first edxfd_det where
         edxfd_exf_name = i_xfname and
         edxfd_exf_vers = i_xfvers and
         edxfd_doc_in   = i_doc_in and
         edxfd_rec_seq  > i_rec_seq  and
         edxfd_rec_reqd
   no-lock: end.

   if available edxfd_det then
      assign
         i_msgnbr   = 4402
         o_err_data = chk_subsys + "; " + edxfd_rec_name +
                      "; " + i_xfname + "; " + string(i_xfvers).

END PROCEDURE.  /* PROCEDURE VAL_DATA2EOT */


PROCEDURE removeObjects:

if valid-handle(hfield) then
  delete object hfield.
if valid-handle(hDoc) then
  DELETE OBJECT hDoc.
if valid-handle(hRoot) then
  DELETE OBJECT hRoot.
if valid-handle(hText) then
  DELETE OBJECT hText.
if valid-handle(hTemp) then
  DELETE OBJECT hTemp.
if valid-handle(hCurr) then
  DELETE OBJECT hCurr.

assign
   hfield = ?
   hDoc   = ?
   hRoot  = ?
   hText  = ?
   hTemp  = ?
   hCurr  = ?.
end PROCEDURE.

PROCEDURE parse-struc.

  /* Purpose: Parse the structure-sequence-id and set several key
              variables that will be used to detect new_loop, end_loop,
              iterate_loop, etc.

     Parameters:
       IN  i_struc_id  - The looping strucute id

  *******************************************************************/

  define input parameter i_struc_id like edxrd_exf_rec_stru no-undo.

  define variable curr_struc_len as integer no-undo.
  define variable prev_struc_len as integer no-undo.
  define variable curr_s_loop    as integer no-undo.
  define variable curr_loop_iter as integer no-undo.
  define variable prev_s_loop    as integer no-undo.
  define variable prev_loop_iter as integer no-undo.
  define variable prev_rec_lp_end as integer no-undo.

  assign new_loop       = no
         iterate_loop   = no
         end_loop       = no
         prev_struc_id  = curr_struc_id
         curr_struc_id  = i_struc_id
         prev_struc_len = length(prev_struc_id)
         curr_struc_len = length(curr_struc_id).

  /* check if we started a new loop */

  if curr_struc_len > prev_struc_len THEN DO:
    new_loop = yes.
  END.
  else do:
    if curr_struc_len < prev_struc_len then
      end_loop = yes.

    assign curr_s_loop    =
       integer(substring(curr_struc_id,curr_struc_len - 13,4))

           curr_loop_iter =
       integer(substring(curr_struc_id,curr_struc_len - 9,6))

           prev_s_loop    =
       integer(substring(prev_struc_id,curr_struc_len - 13,4))

           prev_loop_iter =
       integer(substring(prev_struc_id,curr_struc_len - 9,6)).

    if curr_s_loop > prev_s_loop then do:
       new_loop = yes.
       if curr_struc_len = prev_struc_len then
         end_loop = yes.
    end.
    else
    if curr_s_loop <> prev_s_loop or
       curr_loop_iter <> prev_loop_iter then
         iterate_loop = yes.

    if curr_s_loop < prev_s_loop then
       end_loop = yes.

  end.  /* curr <= prev */


END PROCEDURE. /* PROCEDURE parse-struc */
