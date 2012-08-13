/* edixload.p   - EDI - Transfer data from SNF to Exchange File Repository    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.42.1.8 $                                                               */
/*V8:ConvertMode=NoConvert                                                    */
/* REVISION: 9.0        CREATED: 03/24/98   BY: *M030* Vinod Kumar            */
/* REVISION: 9.0  LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan             */
/* REVISION: 9.0  LAST MODIFIED: 03/23/99   BY: *M0BP* Julie Milligan         */
/* REVISION: 9.0  LAST MODIFIED: 03/29/99   BY: *M0BV* Julie Milligan         */
/* REVISION: 9.1  LAST MODIFIED: 07/01/99   BY: *N00T* Jean Miller            */
/* REVISION: 9.1  LAST MODIFIED: 04/17/00   BY: *N07D* Antony Babu            */
/* REVISION: 9.1  LAST MODIFIED: 05/25/00   BY: *M0LR* Reetu Kapoor           */
/* REVISION: 9.0  LAST MODIFIED: 06/01/00   BY: *M0QH* Paul Dreslinski        */
/* REVISION: 9.1  LAST MODIFIED: 08/14/00   BY: *N0KW* Jacolyn Neder          */
/* Revision: 1.34     BY: Paul Dreslinski       DATE: 09/27/01  ECO: *M14M*  */
/* Revision: 1.36     BY: Paul Dreslinski       DATE: 03/10/02  ECO: *P04S*  */
/* Revision: 1.37     BY: Paul Dreslinski       DATE: 06/08/02  ECO: *P07W* */
/* Revision: 1.38     BY: Dipesh Bector         DATE: 12/12/02  ECO: *N21Z* */
/* Revision: 1.39   BY: Seema Tyagi         DATE: 01/13/03  ECO: *N23K* */
/* Revision: 1.41   BY: Paul Dreslinski     DATE: 04/25/03  ECO: *P0QP* */
/* Revision: 1.42   BY: Paul Dreslinski     DATE: 04/29/03  ECO: *P0R1* */
/* Revision: 1.42.1.5  BY: Paul Dreslinski  DATE: 06/12/03  ECO: *N2H9* */
/* Revision: 1.42.1.6  BY: Salil Pradhan    DATE: 06/15/04  ECO: *P260* */
/* $Revision: 1.42.1.8 $        BY: Vivek Gogte      DATE: 06/28/04  ECO: *P279* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*                                                                            */
/* Developed by : Vinod Kumar & Dan Herman                                    */
/*                                                                            */
/*                                                                            */
/* PARAMETERS:                                                                */
/*     CHK_SUBSYS      - NAME OF THE EC SUBSYSTEM                             */
/*     SNFILE_NAME     - NAME OF FILE BEING PROCESSED                         */
/*     PROC_SESS       - PROCESS SESSION NUMBER                               */
/*     L_ERR_FILE_NAME - NAME OF THE FILE TO WRITE ERROR DATA TO              */
/*                                                                            */
/*                                                                            */
/* NOTE:- TRANSACTION IS SCOPED TO A DOCUMENT. TO ACHEIVE THIS A RECORD WITH  */
/*        STATUS '11' (ERROR) IS CREATED IN BOTH EXCHANGE FILE STATUS AND     */
/*        EXCHANGE FILE STATUS HISTORY TABLE. ONCE A NEW DOCUMENT IS          */
/*        ENCOUNTERED, THE STATUS FOR PREVIOUS ONE IS CHANGED TO '12'         */
/*        INDICATING IT IS SUCCESSFULL. EACH RECORD THAT IS READ, IF CONTROL  */
/*        RECORD IS WRITTEN INTO TT_SNF_REC TEMPORARY TABLE OTHERWISE IT IS   */
/*        WRITTEN TO TT_SNF_ERR TEMPORARY TABLE AND IF AN ERROR IS            */
/*        ENCOUNTERED IN THE CURRENT DOCUMENT, THE PROCESS JUST KEEPS WRITING */
/*        DATA TO BOTH TEMPORARY TABLES DEPENDING UPON CONTROL/DATA RECORD    */
/*        UNTIL A NEW DOCUMENT IS ENCOUNTERED. ONCE A NEW DOCUMENT IS         */
/*        ENCOUNTERED, THE CONTENTS OF THE TEMPORARY TABLES FOR THE PREVIOUS  */
/*        DOCUMENT IS DUMPED TO A FLAT IF IF THE PREVIOUS DOCUMENT IS BAD.    */
/*        OTHERWISE THE TEMPORARY TABLE CONTAINING DATA IS DELETED. ALL       */
/*        INCOMPLETED DOCUMENTS THAT ARE CREATED IN THE EXCHANGE FILE         */
/*        REPOSITORY MASTER AND DETAIL ARE PURGED AT THE END OF THIS PROCESS. */
/*                                                                            */
/*                                                                            */
/* TOKENS:- TOKEN ARE HANDLED DIFFERENTLY. TOKENS VALUES FROM THE CURRENT     */
/*          DOCUMENT IS ALSO USED IN THE PROCESSING OF THE DOCUMENTS FOLLOWED */
/*          BY THE CURRENT ONE. IF THERE ARE TOKEN VALUES IN THE DOCUMENTS    */
/*          FOLLOWED BY THE CURRENT DOCUMENT, THEN THE TOKENS VALUES FROM THE */
/*          CURRENT DOCUMENT IS REPLACED WITH THE NEW TOKEN VALUES.           */
/******************************************************************************/
         {mfdeclre.i}
         {gplabel.i} /* EXTERNAL LABEL INCLUDE */

         /* ************** Begin Translatable Strings Definitions *********** */

         &SCOPED-DEFINE edixload_p_1 "*ERROR SEQUENCE*"
         /* MaxLen:80    Comment: value checked for in a flat file
                                      the asterisk (*) must be included at
                                      the begining and end    */

         &SCOPED-DEFINE edixload_p_2 "ERROR SEQUENCE :"
         /* MaxLen:80    Comment: value written to a flat file if the
                                    document is in error. The colon in the
                                    above label is MANDATORY  */


         /* ************** End Translatable Strings Definitions *********** */
         {edtoken.i}
         {edtmpdef.i}

      define input    parameter chk_subsys       like edss_subsys    no-undo.
      define input    parameter snfile_name      as   character      no-undo.
      define input    parameter proc_sess        as   integer        no-undo.
      define input    parameter l_err_file_name  as   character      no-undo.

      define output parameter table for tt_exf_status.

         define stream snfile.

         define buffer b_edxrd_det for edxrd_det.
         define buffer b_edsd_det  for edsd_det.

         define variable hXML        as handle     no-undo.
         define variable hRoot       as handle     no-undo.
         define variable hRecord     as handle     no-undo.
         define variable hXMLField   as handle     no-undo.
         define variable hFieldValue as handle     no-undo.

         define variable iNumRecords as integer    no-undo.
         define variable iNumFields  as integer    no-undo.
         define variable iNumValues  as integer    no-undo.

         define variable hBuffer as handle     no-undo.
         define variable hField  as handle     no-undo.
         define variable listname as character     no-undo.

         define variable isControlData like mfc_logical no-undo.
         define variable prev_Control  like mfc_logical no-undo.

         define temp-table RecordFields no-undo
           field seq        as integer
           field recName    as character
           field FieldName  as character
           field FieldValue as character
           field assigned   as logical.

         define variable subsys           like edss_subsys              no-undo.
         define variable doc_in           like edsd_doc_in initial yes  no-undo.
         define variable docseq           as   integer     initial 0    no-undo.
         define variable seqlist          as   character                no-undo.
         define variable seqctr           as   character                no-undo.
         define variable msgnbr           like msg_nbr                  no-undo.
         define variable msglevel         as   integer                  no-undo.
         define variable ctr              as   integer                  no-undo.
         define variable data_transition  as   character                no-undo.
         define variable curr_rec_type    as   character                no-undo.
         define variable xfseq            like edxrd_det.edxrd_exf_rec_seq        no-undo.
         define variable xfdata           like edxrd_det.edxrd_exf_fld            no-undo.
         define variable xfname           like edxfd_exf_name           no-undo.
         define variable xfvers           like edxfd_exf_vers           no-undo.
         define variable xfline           as   character                no-undo.
         define variable i_line           as   character                no-undo.
         define variable l_retn_val       as   character                no-undo.
         define variable prev_rec_type    as   character                no-undo.
         define variable prev_xfseq       like edxrd_det.edxrd_exf_rec_seq        no-undo.
         define variable curr_snf_err     as   logical                  no-undo.
         define variable prev_snf_err     as   logical                  no-undo.
         define variable rec_code         like edsd_rec_cde             no-undo.
         define variable par_pos          as   integer                  no-undo.
         define variable l_quote_char     as   character                no-undo.
         define variable l_tmp_data       as   character                no-undo.
         define variable l_data           like edxrd_det.edxrd_exf_fld            no-undo.
         define variable l_fld_ctr        as   integer                  no-undo.
         define variable l_last_rec_seq   like edsd_rec_seq             no-undo.
         define variable l_counter        as   integer     initial 1    no-undo.
         define variable l_new_doc        as   logical                  no-undo.
         define variable l_delim          as   character                no-undo.
         define variable l_loop_stack     as   character                no-undo.
         define variable l_cur_loop_level as   integer                  no-undo.
         define variable l_struct_id      as   character                no-undo.
         define variable l_quote_found    as   logical                  no-undo.
         define variable l_filename       as   character                no-undo.
         define variable l_errorfile      as   character                no-undo.
         define variable error_data       as   character                no-undo.
         define variable l_brk_lvl        as   integer                  no-undo.
         define variable isGood           as   logical                  no-undo.


         {edttstk.i "new"}

         define temp-table tt_snf_err no-undo
             field tt_seq_no as integer
             field tt_line   as character
             index tt_idx tt_seq_no.

         define temp-table inControlData no-undo like edxrd_det.


         /* TEMP TABLE TO STORE CONTROL RECORD LINE */

         define temp-table tt_snf_rec no-undo
             field tt_sf_rec_seq  like  edsd_rec_seq
             field tt_sf_rec_line as    character
             index tt_sf_idx tt_sf_rec_seq.


         /* TEMP TABLE TO STORE TOKEN NAME, ITS VALUE AND THE LEVEL AT WHICH IT
            IS AVAILABLE
         */
         define temp-table tt_token no-undo
             field tt_tk_rec_seq   like edsd_rec_seq
             field tt_tk_rec_type  as   character
             field tt_tk_tkn_name  as   character
             field tt_tk_tkn_value as   character
           index tt_seq is primary tt_tk_rec_seq.

         l_filename  =
            (if num-entries(snfile_name,"/") > 1 then
                entry(num-entries(snfile_name,"/" ),snfile_name,"/")
            else
                entry(num-entries(snfile_name,"~\"),snfile_name,"~\")).

         l_errorfile  =
            (if num-entries(l_err_file_name,"/") > 1 then
                entry(num-entries(l_err_file_name,"/" ),l_err_file_name,"/")
            else
                entry(num-entries(l_err_file_name,"~\"),l_err_file_name,"~\")).


         /* GET THE NEXT SEQUENCE NUMBER FOR CREATING EXCHANGE FILE
            STATUS AND EXCHANGE FILE HISTORY TABLES
         */
         run getseq in THIS-PROCEDURE ( INPUT-OUTPUT docseq ).


         /* CREATE EXCHANGE FILE STATUS AND EXCHANGE FILE HISTORY RECORDS */

         run cr_exstat in THIS-PROCEDURE (INPUT docseq, INPUT proc_sess ).


         /* GET THE EC SUBSYSTEM INFORMATION */

         for first edss_mstr where edss_subsys = chk_subsys no-lock:
         end.

         if not available edss_mstr then do:

           /* ERROR: EC SUBSYSTEM DOES NOT EXIST */
           error_data = chk_subsys + "; " + l_filename + "; " + l_errorfile.
            run error_proc in THIS-PROCEDURE(
                input docseq                ,
                input 4411                  ,
                input 4                     ,
                input error_data            ).  /* FATAL */
            return.

         end. /* IF NOT AVAILABLE EDSS_MSTR THEN */

         assign
             subsys            = edss_subsys    /* SET THE DEFAULT SUBSYS */
             l_delim           = chr( edss_ecf_delim )
             l_loop_stack      = "1,1,0,0"
             l_cur_loop_level  = 1
             data_transition   = "none"
             prev_rec_type     = "CONTROL".

         if edss_ecf_fixed = ? then  do:

            create x-document hXML.
            create x-noderef  hRoot.
            create x-noderef  hRecord.
            create x-noderef  hXMLField.
            create x-noderef  hFieldValue.

            isGood = hXML:LOAD('FILE', snfile_name , FALSE) no-error.

            if not isGood then do:
               error_data = error-status:get-message(1) + "; " + l_errorfile.
                run error_proc in THIS-PROCEDURE(
                    input docseq                ,
                    input 2685                  ,
                    input 4                     ,
                    input error_data            ).  /* FATAL */
                return.
            end. /* LOAD DID NOT OCCUR GIVE ERROR BACK */

            /*Get the root element handle*/
            hXML:GET-DOCUMENT-ELEMENT(hRoot).

            /*CREATE BUFFER hBuffer FOR TABLE "customer".*/
            RUN cycleTree (Hroot).
         end.
         else do:
           input stream snfile from value (snfile_name) no-echo.

           procloop:
           repeat:
               import stream snfile unformatted xfline.

               if xfline matches {&edixload_p_1} or
                  xfline = " " then do:

                   next procloop.

               end.

             run processRecord (?).

           end.
         end.

             /* DETERMINE WHAT TO DO BASED ON THE TRANSITION */

             case data_transition:

                 when ("ControlToControl") or
                     when ("DataToControl") then do:


                    /* MANDATORY DATA RECORD MISSING  */
                    error_data = subsys + "; " + "?; " + xfname + "; " +
                                 string(xfvers) + "; " +
                                 l_filename + "; " + l_errorfile.

                     run error_proc in THIS-PROCEDURE(
                         INPUT docseq                ,
                         INPUT 4402                  ,
                         INPUT 4                     ,
                         INPUT error_data            ).  /* FATAL */

                     end.

                 when ("ControlToData") or
                     when ("DataToData") then do:


                     /* VALIDATE THAT ALL MANDATORY DATA RECORDS WERE READ */

                     run val_data2eof in THIS-PROCEDURE(
                         OUTPUT msgnbr                 ,
                         OUTPUT l_retn_val             ).


                     if msgnbr <> 0 then
                         run error_proc in THIS-PROCEDURE(
                             INPUT docseq                ,
                             INPUT msgnbr                ,
                             INPUT 4                     ,
                             INPUT l_retn_val            ).  /* FATAL */

                     if not curr_snf_err then
                         run up_repmstr in THIS-PROCEDURE( INPUT docseq ).

                     run up_stsmstr in THIS-PROCEDURE(
                         INPUT docseq                ,
                         INPUT curr_snf_err          ,
                         INPUT proc_sess             ).

                 end.  /* DATATODATA */

                 when ("none") then   /* UNKNOWN FILE FORMAT */
                     run error_proc in THIS-PROCEDURE(
                         INPUT docseq                ,
                         INPUT 4412                  ,
                         INPUT 4                     ,
                         INPUT l_filename + "; " + l_errorfile).  /* FATAL */

             end case.  /* CASE DATA_TRANSITION */

             if curr_snf_err then do:

                 /* EXPORT CURRENT DOCUMENT RECORDS TO ERROR FILE */

                 OUTPUT to value( l_err_file_name ) append.

                 put unformatted {&edixload_p_2} docseq skip.

                 for each tt_snf_rec :
                     put unformatted tt_snf_rec.tt_sf_rec_line skip.
                 end.

                 for each tt_snf_err :
                     put unformatted tt_snf_err.tt_line skip.
                 end.

                 output close.

             end. /* IF curr_snf_err THEN */

             /* CLEAN UP THE FAILED DOCUMENTS IN THE REPOSITORIES */
             for each edxfsd_det
                fields (edxfsd_exf_seq   edxfsd_proc_date edxfsd_proc_seq
                        edxfsd_proc_sess edxfsd_proc_time edxfsd_status)
                where edxfsd_proc_sess = proc_sess
                no-lock,
                first edxfs_mstr
                   fields (edxfs_doc_in edxfs_exf_seq edxfs_file_name
                           edxfs_status edxfs_tp_doc  edxfs_tp_doc_ref
                           edxfs_tp_id)
                   where edxfs_exf_seq = edxfsd_exf_seq
                   and   edxfs_status  = 11
                   no-lock:

                   for first edxr_mstr
                      where edxr_exf_seq = edxfs_exf_seq
                      exclusive-lock:

                      for each edxrd_det
                         where edxrd_exf_seq = edxr_exf_seq
                         exclusive-lock:

                         delete edxrd_det.

                      end. /* FOR EACH edxrd_det */

                      delete edxr_mstr.

                   end. /* FOR FIRST edxr_mstr */
             end. /* FOR EACH edxfsd_det */

/* - ------------------------INTERNAL PROCEDURE *******************/


PROCEDURE cycleRecs:


    /* The purpose of this procedure is to determine the actual elements
       that have text associated with it - therefore a segment must have
       a child segement (the field) and a grandchild segment that is text
       at that point the element (tag) can be loaded as a record, field and
       text  - all attributes are considered to be field and value
       combinations ********/


    define input parameter ihNode as handle no-undo.
    define output parameter hadFieldLevel as logical initial no no-undo.

    define variable fldName   as character no-undo.
    define variable fldValue  as character no-undo.
    define variable valname   as character no-undo.

    define variable FldHandle as handle    no-undo.
    define variable ValHandle as handle    no-undo.
    define variable i         as integer   no-undo.
    define variable j         as integer   no-undo.
    define variable x         as integer   no-undo.
    define variable wasOk     as logical   no-undo.

    if valid-handle(ihNode) then do:
        create x-nodeRef FldHandle.

        FldLevel:
        do i = 1 to ihNode:num-children:

          wasOk = ihNode:get-child(fldHandle,i).
          if not wasOK then next.

          if FldHandle:subtype <> "element" then do:
            next FldLevel.
          end.

          if FldHandle:num-Children > 0 then do:

            create x-nodeRef valHandle.

            ValLevel:
            do j = 1 to FldHandle:num-children:

              wasOk = fldHandle:get-child(valHandle,j).
              if not wasOk then next.
              assign hadFieldLevel = yes.


              if valHandle:subtype <> "text" then next.

              if valHandle:subtype = "text" then do:

                  if asc(substring(valHandle:node-value,1,1)) = 10 then
                      next ValLevel.

                  valname = valHandle:node-value.
                  do while index(valName,chr(10)) <> 0:

                     overlay (Valname,index(ValName,chr(10))) = chr(32).

                  end.

                  valHandle:node-value = valName.

                  if valHandle:node-value <> "" then  do:
                     CREATE RecordFields.
                     ASSIGN
                         RecordFields.seq = 0
                         recordFields.RecName = ihNode:name
                         RecordFields.FieldName = fldHandle:name
                         RecordFields.FieldValue = valHandle:node-value.

                  end. /* IF NODE-HANDLE <> "" */

              end. /* IF SUBTYPE = TEXT */

            end. /* DO J = 1 to FLDHANLDE:NUM_CHILDREN*/

          end. /* IF FlHANDLE:NUM-CHILDREN > 0*/

        end. /* I = 1 to Num-CHILDREN*/

    end. /* VALID HANDLE */
END PROCEDURE. /* CYCLERECS*/

/*******************************************************************/

PROCEDURE cycleTree:
define input parameter ihroot as handle  no-undo.
define variable icounter as integer      no-undo.
define variable childCounter as integer  no-undo.
define variable good as logical          no-undo.
define variable hChild as handle         no-undo.

create x-noderef hChild.


repeat icounter = 1 to num-entries(ihRoot:ATTRIBUTE-NAMES):

  create RecordFields.
  assign
      RecordFields.seq = icounter
      recordFields.RecName = ihRoot:NAME
      RecordFields.FieldName = ENTRY(iCounter,ihRoot:ATTRIBUTE-NAMES)
      RecordFields.FieldValue = ihRoot:GET-ATTRIBUTE(ENTRY(iCounter,ihRoot:ATTRIBUTE-NAMES)).
end.

/* FIND OUT IF RECORD HAS FIELDS */
run cycleRecs (input ihRoot,
               output good).

/* GOOD = LEVEL HAD TEXT LEVEL BUT NO FIELDS SO NEED TO MAKE SURE AT LEAST 1 REC CREATED*/
if good then do:
   if not can-find (first REcordFields where
         recordFields.RecName = ihRoot:name) then do:
      create recordFields.
      assign recordFields.seq = 1
             recordFields.RecName = ihRoot:name.
   end.
end.

if can-find(first RecordFields where
                  recordFields.RecName = ihRoot:name) then do:
   RUN processRecord (INPUT ihRoot).
   for each RecordFields where recordFields.assigned = no and
            RecordFields.FieldValue <> "":
      /* WARNING: FIELD FOUND BUT NOT ASSIGNED TO A FIELD IN REP */
      error_data = recordFields.RecName + "." + RecordFields.fieldName + "=" + RecordFields.FieldValue.
       run error_proc in THIS-PROCEDURE(
           INPUT docseq                ,
           INPUT 5064                  ,
           INPUT 2                     ,
           INPUT error_data            ).  /* FATAL */
   end. /* FOR EACH FIELD NOT ASSIGNED */
end. /* IF WE ARE AT A RECORD THAT HAS FIELDS */

for each RecordFields exclusive-lock:
delete REcordFields.
end.


repeat childCounter = 1 to ihRoot:num-children  :

  if retry then return.

  good = ihroot:GET-CHILD(hChild, childCounter).
  if not good  then next.

     if hChild:num-children = 0 then do:
        repeat icounter = 1 to num-entries(hChild:ATTRIBUTE-NAMES):

          create RecordFields.
          assign
              RecordFields.seq = iCounter
              recordFields.RecName = hChild:NAME
              RecordFields.FieldName = entry(iCounter,hChild:ATTRIBUTE-NAMES)
              RecordFields.FieldValue = hchild:GET-ATTRIBUTE(ENTRY(iCounter,hChild:ATTRIBUTE-NAMES)).

        end.

        if can-find(first RecordFields where
                          recordFields.RecName = hChild:name) then
           run processRecord (INPUT hChild).

        for each RecordFields where recordFields.assigned = no and
                 RecordFields.FieldValue <> "":
           /* WARNING: FIELD FOUND BUT NOT ASSIGNED TO REP VALUE */
           error_data = recordFields.RecName + "." + RecordFields.fieldName + "=" + RecordFields.FieldValue.
            run error_proc in THIS-PROCEDURE(
                INPUT docseq                ,
                INPUT 5064                  ,
                INPUT 2                     ,
                INPUT error_data            ).  /* WARNING */
        end.

        for each RecordFields exclusive-lock:
           delete REcordFields.
        end. /* FOR EACH RECORDFIELDS */

     end. /* IF NUM-CHILDREN =0 */

     if hChild:num-children > 0  then do:
         run cycleTree (hChild).
     end. /* NUM-HCILDREN > 0 */


end.   /* REPEAT CHILDCOUNTER */

END PROCEDURE. /* CYCLETREE*/

/********************************************************************************/

PROCEDURE processRecord:

    DEFINE INPUT PARAMETER ihNode AS HANDLE NO-UNDO.

    if valid-handle(ihNode) then
      IF ihNode:NAME = ? OR ihNode:NAME = "#Text" THEN RETURN.

                /* COUNTER FOR SORTING RECORDS IN TEMPORARY TABLE */

                 l_counter = l_counter + 1.


                 /* GET THE NEXT SEQUENCE NUMBER FOR CREATING EXCHANGE FILE
                    STATUS AND EXCHANGE FILE HISTORY TABLES
                 */
                 run getseq in THIS-PROCEDURE (INPUT-OUTPUT docseq ).


                 /* CREATE EXCHANGE FILE STATUS TABLE AND EXCHANGE FILE HISTORY
                    TABLE RECORDS FOR EACH DOCUMENT
                 */
                 run cr_exstat in THIS-PROCEDURE(
                     INPUT docseq               ,
                     INPUT proc_sess            ).


                 /* CONVERT QUOTE ASCII VALUE INTO CHARACTER */

                 assign
                     rec_code      = ""
                     i_line        = xfline
                     l_data        = ""
                     curr_rec_type = ""
                     l_quote_char  =
                         ( if edss_mstr.edss_ecf_quote > 0 then
                             chr( edss_ecf_quote )
                         else ? ).

                 IF edss_ecf_fixed = ? THEN
                     ASSIGN rec_code = ihNode:NAME.
                 ELSE
                 if edss_ecf_fixed then do:

                    /* RECORD CODE POSITION IS AT END OF LINE */

                    if edss_ecf_cde_pos = 0 then

                        assign
                            rec_code = substring( i_line, length( i_line ) -
                                ( edss_ecf_cde_len - 1 ), edss_ecf_cde_len )

                            i_line   = substring( i_line, 1,length( i_line ) -
                                edss_ecf_cde_len ).

                    /* RECORD CODE POSITION IS NOT AT END OF LINE */

                    else do:

                        rec_code =
                            substring( i_line, edss_ecf_cde_pos,
                                edss_ecf_cde_len ).

                        if edss_ecf_cde_pos = 1 then
                            i_line = substring( i_line, edss_ecf_cde_len + 1,
                                length( i_line ) - edss_ecf_cde_len ).
                        else
                            i_line =
                                substring( i_line,1,edss_ecf_cde_pos - 1 ) +
                                    substring( i_line,edss_ecf_cde_pos +
                                        edss_ecf_cde_len, length( i_line )).

                    end.  /* RECORD CODE POSITION IS NOT AT END OF LINE */

                 end. /* IF EDSS_ECF_FIXED THEN */


                 else do:   /* VARIABLE FORMAT */

                    assign
                        ctr           = 1
                        l_quote_found = no.

                    do l_fld_ctr = 1 to num-entries( i_line,l_delim ) :

                        l_tmp_data = entry( l_fld_ctr,i_line,l_delim ).

                        if not l_quote_found and length( l_tmp_data ) > 0 and
                            ( substring( l_tmp_data,length( l_tmp_data ),1 ) <>
                                l_quote_char or substring( l_tmp_data,1,1 ) =
                                    l_quote_char ) then do:

                            l_data[ ctr ] = trim( l_tmp_data, l_quote_char ).

                            if not l_quote_found and
                                substring( l_tmp_data,1,1 ) =
                                    l_quote_char then do:

                                if length( l_tmp_data ) > 1 and
                                    substring( l_tmp_data,
                                        length( l_tmp_data ),1 ) =
                                            l_quote_char then
                                    assign
                                        ctr           = ctr + 1
                                        l_quote_found = no.

                                else l_quote_found = yes.
                            end.

                            else if not l_quote_found and
                                substring( l_tmp_data,length(
                                    l_tmp_data ),1 ) <> l_quote_char then
                                ctr = ctr + 1.

                        end. /* IF NOT L_QUOTE_FOUND AND LENGTH( L_TMP_DATA ) */

                        else if l_quote_found and length( l_tmp_data ) > 0 and
                            ( substring( l_tmp_data,length( l_tmp_data ),1 ) <>
                                 l_quote_char or substring( l_tmp_data,
                                     length( l_tmp_data ), 1 ) =
                                         l_quote_char ) then do:

                            l_data[ ctr ] = l_data[ ctr ] + l_delim +
                                trim( l_tmp_data, l_quote_char ).

                            if substring( l_tmp_data,length( l_tmp_data ),1 ) =
                                l_quote_char then
                                assign
                                    ctr           = ctr + 1
                                    l_quote_found = no.
                        end.
                        else if length( l_tmp_data ) = 0 or
                            l_tmp_data = l_quote_char or ( not l_quote_found and
                                substring( l_tmp_data,length( l_tmp_data ),1 ) =
                                    l_quote_char ) then do:

                            l_data[ ctr ] = l_data[ ctr ] +
                                ( if l_quote_found and ( length( l_tmp_data ) =
                                    0 or l_tmp_data = l_quote_char) then l_delim
                                else "" ) + trim( l_tmp_data, l_quote_char ).

                            if not l_quote_found then ctr = ctr + 1.
                        end.
                    end.

                    if not l_quote_found then do:

                        if edss_ecf_cde_pos = 0 then

                            assign
                                rec_code          = l_data[ ctr - 1 ]
                                l_data[ ctr - 1 ] = "".

                        else do:

                            rec_code = l_data[ edss_ecf_cde_pos ].

                            do l_fld_ctr = edss_ecf_cde_pos to ctr - 1:

                                l_data[ l_fld_ctr ] = l_data[ l_fld_ctr + 1 ].

                            end.
                        end.

                    end. /* IF NOT L_QUOTE_FOUND THEN */

                    else do: /* QUOTE CHARACTER FOUND */

                        curr_rec_type = "UNKNOWN".

                        /* ERROR: NO MATCHING QUOTE FOUND IN RECORD */
                        error_data = substring(xfline,1,5) +
                                     "...; " + l_filename + "; " +
                                     l_errorfile.

                        run error_proc in THIS-PROCEDURE(
                            INPUT docseq                ,
                            INPUT 4403                  ,
                            INPUT 4                     ,
                            INPUT error_data            ).

                    end.

                end. /* VARIABLE FORMAT */


                if curr_rec_type <> "UNKOWN" then do:

                    /* IF THE CURRENT SNF RECORD IS A 'DATA RECORD' THEN
                       INSERT IT INTO TT_SNF_ERR TEMP TABLE
                    */
                    for first edsd_det            where
                        edsd_subsys  = chk_subsys and
                        edsd_doc_in  = doc_in     and
                        edsd_rec_cde = rec_code   no-lock:
                    end.

                    if available edsd_det  and (l_brk_lvl = 0 or
                       not can-find (
                            first edsxx_ref                    where
                            edsxx_subsys      = subsys         and
                            edsxx_tp_doc      = tp-document-id and
                            edsxx_doc_in      = doc_in         and
                           (edsxx_tp_id       = tp-id          or
                            edsxx_tp_id       = ""        )    and
                            edsxx_ecf_rec_cde = rec_code         )) then do:

                        assign
                            l_brk_lvl = 0
                            curr_rec_type = "CONTROL"
                            isControlData = no
                            xfseq         = edsd_rec_seq.

                        if edsd_rec_token <> "" then

                             run up_token in THIS-PROCEDURE    (
                                 INPUT edsd_rec_token         ,
                                 INPUT docseq                  ,
                                 INPUT edsd_rec_seq           ,
                                 INPUT "CTRL-REC"            ,
                                 INPUT rec_code                ,
                                 INPUT "" ).
                    end.

                    else do: /* NOT AVAILABLE EDSD_DET */


                        /* CHECK WHETHER THE RECORD CODE IS 'DATA' */
                        for first edsxx_ref                    where
                            edsxx_subsys      = subsys         and
                            edsxx_tp_doc      = tp-document-id and
                            edsxx_doc_in      = doc_in         and
                            edsxx_tp_id       = tp-id          and
                            edsxx_ecf_rec_cde = rec_code       and
                            edsxx_break_lvl     >= l_brk_lvl  no-lock :
                        end.

                        if not available edsxx_ref then
                          for first edsxx_ref                    where
                              edsxx_subsys      = subsys         and
                              edsxx_tp_doc      = tp-document-id and
                              edsxx_doc_in      = doc_in         and
                              edsxx_tp_id       = ""             and
                              edsxx_ecf_rec_cde = rec_code       and
                              edsxx_break_lvl     >= l_brk_lvl  no-lock :
                          end.

                        if not available edsxx_ref then
                            for last edsxx_ref where
                              edsxx_subsys      = subsys         and
                              edsxx_tp_doc      = tp-document-id and
                              edsxx_doc_in      = doc_in         and
                              edsxx_tp_id       = tp-id          and
                              edsxx_ecf_rec_cde = rec_code       and
                              edsxx_break_lvl     < l_brk_lvl  no-lock :
                            end.

                        if not available edsxx_ref then
                            for last edsxx_ref where
                            edsxx_subsys      = subsys         and
                            edsxx_tp_doc      = tp-document-id and
                            edsxx_doc_in      = doc_in         and
                            edsxx_tp_id       = ""             and
                            edsxx_ecf_rec_cde = rec_code       and
                            edsxx_break_lvl     < l_brk_lvl  no-lock :
                            end.


                        if available edsxx_ref then do:
                           assign
                                curr_rec_type = "DATA"
                                xfname        = edsxx_exf_name
                                xfvers        = edsxx_exf_vers
                                xfseq         = edsxx_exf_rec_seq
                                l_brk_lvl     = edsxx_break_lvl.

                          if edsxx__qadl01 then
                              isControlData = yes.
                          else
                              isControlData = no.

                        end.

                        /* RECORD CODE IS EITHER CONTROL NOR DATA */
                        else do:

                            curr_rec_type = "UNKNOWN".
                            isControlData = no.


                            /* ERROR: UNKNOW RECORD CODE */
                           error_data = rec_code + "; " + tp-document-id + "/" + subsys +
                                     "; " + l_filename + "; " +
                                     l_errorfile.
                            run error_proc in THIS-PROCEDURE(
                                INPUT docseq                ,
                                INPUT 4406                  ,
                                INPUT 4                     ,
                                INPUT error_data            ).

                        end. /* RECORD CODE IS EITHER CONTROL NOR DATA */

                    end. /* NOT AVAILABLE EDSD_DET */

                end. /* IF CURR_REC_TYPE <> "UNKNOWN" THEN */

                assign
                    xfdata  = ""
                    par_pos = 1.


                 /* DETERMINE WHAT TO DO BASED ON THE TRANSITION */

                 data_transition = prev_rec_type + "TO" + curr_rec_type.

                 case data_transition :

                     when ("CONTROLTOCONTROL") then do:

                        run controltocontrol.

                     end. /* CONTROLTOCONTROL */

                     when ("DATATOCONTROL") then do:


                        for each inControlData exclusive-lock:
                            delete inControlData.
                        end.

                        run datatocontrol.

                     end. /* DATATOCONTROL */

                     when ("DATATODATA") then do:

                        if isControlData and prev_rec_type <> "CONTROL" and
                           not prev_control then do:
                           run datatocontrol.
                           /* GET THE NEXT SEQUENCE NUMBER FOR CREATING EXCHANGE FILE
                               STATUS AND EXCHANGE FILE HISTORY TABLES
                           */
                           run getseq in THIS-PROCEDURE (INPUT-OUTPUT docseq ).


                           /* CREATE EXCHANGE FILE STATUS TABLE AND EXCHANGE FILE HISTORY
                              TABLE RECORDS FOR EACH DOCUMENT
                           */
                           run cr_exstat in THIS-PROCEDURE(
                                          INPUT docseq               ,
                                          INPUT proc_sess            ).

                           if not prev_snf_err and not curr_snf_err then
                               run cr_repmstr in THIS-PROCEDURE (INPUT docseq ).

                        end.

                        run datatodata.

                     end. /* WHEN "DATATODATA" THEN */

                     when ("CONTROLTODATA") then do:

                        run controltodata.

                     end. /* WHEN "CONTROLTODATA" THEN */

                     otherwise do:


                         /* INSERT RECORDS INTO TEMPORARY TABLE */

                         create tt_snf_err.
                         assign
                             tt_seq_no = l_counter
                             tt_line   = xfline.

                         if recid( tt_snf_err ) = -1 then .

                     end.

                 end case. /* DATA_TRANSITION */


                 /* PARSE THE REST OF THE I_LINE INTO THE XFDATA ARRAY */

                 if curr_rec_type = "CONTROL"  then do:  /* CONTROL RECORD */

                     for each edsdd_det         where
                         edsdd_subsys  = subsys and
                         edsdd_doc_in  = doc_in and
                         edsdd_rec_seq = xfseq  no-lock:

                        IF edss_ecf_fixed = ? then do:
                            for each RecordFields:
                                if RecordFields.FieldName = edsdd_fld_name then
                                    assign
                                       RecordFields.assigned = yes
                                       xfdata[edsdd_fld_seq] = RecordFields.FieldValue.
                            end.

                        end.
                        else
                        if edss_ecf_fixed then        /* FIXED LENGTH */
                            assign
                                xfdata[edsdd_fld_seq] =
                                    substring( i_line, par_pos, edsdd_fld_max )
                                par_pos               = par_pos + edsdd_fld_max.
                        else
                            xfdata[ edsdd_fld_seq ]   = l_data[ edsdd_fld_seq ].

                         /* CHECK MIN AND MAX ANLY IF A FIELD IS REQUIRED OR ITS
                            LENGTH > 0
                         */

                         if ( edsdd_fld_reqd or
                             length( xfdata[ edsdd_fld_seq ]) > 0 ) and
                             length( xfdata[ edsdd_fld_seq ]) < edsdd_fld_min or
                             length( xfdata[ edsdd_fld_seq ]) > edsdd_fld_max
                         then do:

                             /* ERROR: CONTROL FIELD LENGTH OUTSIDE BOUNDRIES */
                            error_data = subsys + "; " +
                                         string(edsdd_rec_seq) + "; " +
                                         edsdd_fld_name + "; " +
                                         string(length( xfdata[ edsdd_fld_seq ]))
                                         + "; " + l_filename + ";" +
                                         l_errorfile.

                             run error_proc in THIS-PROCEDURE(
                                 INPUT docseq                ,
                                 INPUT 4407                  ,
                                 INPUT 4                     ,
                                 INPUT error_data            ).

                         end.

                        /* VALIDATE ALL MANDATORY FIELDS */

                        if edsdd_fld_reqd and
                            xfdata[ edsdd_fld_seq ] = "" then do:

                             /* MANDATORY CONTROL FIELD HAS NOT BEEN SET */
                            error_data = subsys + "; " +
                                         string(edsdd_rec_seq) + "; " +
                                         edsdd_fld_name + "; " +
                                         l_filename + "; " + l_errorfile.
                             run error_proc in THIS-PROCEDURE(
                                 INPUT docseq                ,
                                 INPUT 4408                  ,
                                 INPUT 4                     ,
                                 INPUT error_data            ).
                        end.


                        /* UPDATE THE TOKEN INFO FOR CONTROL RECORDS ONLY */

                        if edsdd_fld_token <> "" then

                             run up_token in THIS-PROCEDURE    (
                                 INPUT edsdd_fld_token         ,
                                 INPUT docseq                  ,
                                 INPUT edsdd_rec_seq           ,
                                 INPUT "CTRL-REC"            ,
                                 INPUT xfdata[ edsdd_fld_seq ] ,
                                 INPUT ""                      ).

                    end.  /* FOR EACH EDSDD_DET */

                 end. /* IF CURR_REC_TYPE = "CONTROL"  THEN */


                 else if curr_rec_type = "DATA" then do:  /* DATA RECORD */


                   for each edxfdd_det          where
                       edxfdd_exf_name = xfname and
                       edxfdd_exf_vers = xfvers and
                       edxfdd_doc_in   = doc_in and
                       edxfdd_rec_seq  = xfseq  no-lock:

                      IF edss_ecf_fixed = ? THEN DO:
                          FOR EACH RecordFields:
                              IF RecordFields.FieldName = edxfdd_fld_name THEN
                                  ASSIGN
                                       RecordFields.assigned = yes
                                       xfdata[edxfdd_fld_seq] = RecordFields.FieldValue.
                          END.
                      END.
                      ELSE
                      if edss_ecf_fixed then
                          assign
                              xfdata[ edxfdd_fld_seq ] =
                                  substring( i_line, par_pos, edxfdd_fld_max )
                              par_pos                  =
                                  par_pos + edxfdd_fld_max.

                      else do:  /* HANDLE VARIABLE FORMAT */

                          xfdata[ edxfdd_fld_seq ] = l_data[ edxfdd_fld_seq ].


                         /* ONLY CHECK MIN & MAX IF FIELD IS REQ'D OR LEN > 0 */

                         if (( edxfdd_fld_reqd and
                             length( xfdata[ edxfdd_fld_seq ]) > 0 ) or
                             length( xfdata[ edxfdd_fld_seq ]) > 0 ) and

                             length( xfdata[ edxfdd_fld_seq ]) <
                                 edxfdd_fld_min                      or

                             length( xfdata[ edxfdd_fld_seq ]) >
                                 edxfdd_fld_max                      then do:

                             /* ERROR: DATA FIELD LENGTH OUTSIDE BOUNDRIES:
                                EDXFDD_FLD_NAME XFDATA[EDXFDD_FLD_SEQ]
                             */

                             error_data = subsys + "; " +
                                          xfname + "; " + string(xfvers) + "; " +
                                          string(edxfdd_rec_seq) + "; " +
                                          edxfdd_fld_name + "; " +
                                          string(length( xfdata[ edxfdd_fld_seq ]))
                                          + "; " + l_filename +
                                          "; " + l_errorfile.

                             run error_proc in THIS-PROCEDURE(
                                 INPUT docseq                ,
                                 INPUT 4410                  ,
                                 INPUT 4                     ,
                                 INPUT error_data            ).
                         end.

                      end.  /* NOT FIXED (I.E., VARIABLE) */


                      /* VALIDATE ALL MANDATORY FIELDS */

                      if edxfdd_fld_reqd and
                          xfdata[ edxfdd_fld_seq ] = "" then do:

                        /* ERROR: MANDATORY DATA FIELD HAS NOT BEEN SET */
                        error_data = subsys + "; " +
                                     xfname + "; " + string(xfvers) + ";" +
                                     string(edxfdd_rec_seq) + "; " +
                                     edxfdd_fld_name + "; " +
                                     l_filename + "; " + l_errorfile.

                         run error_proc in THIS-PROCEDURE(
                             INPUT docseq                ,
                             INPUT 4409                  ,
                             INPUT 4                     ,
                             INPUT error_data            ).

                      end. /* IF EDXFDD_FLD_REQD AND */


                      /* UPDATE THE TOKEN INFORMATION FOR DATA RECORDS ONLY */

                      if edxfdd_fld_token <> "" then

                         run up_token in THIS-PROCEDURE    (
                             INPUT edxfdd_fld_token        ,
                             INPUT docseq                  ,
                             INPUT edxfdd_rec_seq          ,
                             INPUT "DATA-REC"            ,
                             INPUT xfdata[ edxfdd_fld_seq ],
                             INPUT edxfdd_fld_type         ).

                   end.  /* FOR EACH EDXFDD_DET */


                   run cr_repdtl in THIS-PROCEDURE(
                       INPUT docseq               ,
                       INPUT xfseq                ).

                 end. /* ELSE IF CURR_REC_TYPE = "DATA" THEN */


                 prev_snf_err = curr_snf_err.

                 assign
                     prev_Control  = isControlData
                     prev_rec_type = curr_rec_type
                     prev_xfseq    = xfseq.


END PROCEDURE.



         PROCEDURE cr_repdtl:
         /*----------------------------------------------------------------
           Purpose: create exchange file repository detail records
           Parameters: None

           Notes:
         ----------------------------------------------------------------*/

             define input parameter io_docseq like edxfs_exf_seq no-undo.
             define input parameter io_xfseq  like edsdd_rec_seq no-undo.

             define variable i_data_type like edxfdd_fld_type    no-undo.

             for last b_edxrd_det                      where
                 b_edxrd_det.edxrd_exf_seq = io_docseq no-lock:
             end.

             if not can-find(edxf_mstr
                             where edxf_exf_name = xfname
                             and   edxf_exf_vers = xfvers
                             and   edxf_doc_in   = doc_in)
             then do:
                /* EXCHANGE FILE RECORD TABLE RECORD DOES NOT EXIST. */
                error_data = xfname + "; " + l_filename + "; " + l_errorfile.
                run error_proc in THIS-PROCEDURE(
                   INPUT docseq                ,
                   INPUT 4414                  ,
                   INPUT 4                     ,
                   INPUT error_data            ).  /* FATAL */
                return.
             end. /* IF NOT CAN-FIND edxf_mstr */

             /* GET THE CURRENT RECORDS END LOOP */
             for first edxfd_det
                where edxfd_exf_name =  xfname
                and   edxfd_exf_vers =  xfvers
                and   edxfd_doc_in   =  doc_in
                and   edxfd_rec_seq  =  io_xfseq
                no-lock :
             end. /* FOR FIRST edxfd_det */

             /* BUILD RECORD STRUCTURE SEQUENCE ID */
             if available edxfd_det
             then do:
                {gprun.i ""edgenseq.p""
                   "(INPUT        io_xfseq         ,
                     INPUT        edxfd_rec_lp_end ,
                     INPUT-OUTPUT l_loop_stack     ,
                     INPUT-OUTPUT l_cur_loop_level ,
                     OUTPUT       l_struct_id      )"}.

             end. /* IF AVAILABLE edxfd_det */
             else do:
                /* EXCHANGE FILE RECORD TABLE RECORD DOES NOT EXIST. */
                error_data = xfname + "; " + l_filename + "; " + l_errorfile.
                run error_proc in THIS-PROCEDURE(
                   INPUT docseq                ,
                   INPUT 4414                  ,
                   INPUT 4                     ,
                   INPUT error_data            ).  /* FATAL */
                return.
             end. /* ELSE DO */

             for first edxrd_det                            where
                 edxrd_det.edxrd_exf_seq      = io_docseq   and
                 edxrd_det.edxrd_exf_rec_seq  = io_xfseq    and
                 edxrd_det.edxrd_exf_rec_stru = l_struct_id no-lock:
             end.

             if not available edxrd_det then do:
                 create edxrd_det.
                 assign
                     edxrd_det.edxrd_exf_seq      = io_docseq
                     edxrd_det.edxrd_exf_rec_seq  = io_xfseq
                     edxrd_det.edxrd_exf_rec_stru = l_struct_id.

                 do ctr = 1 to 100:


                     i_data_type = "".

                     for first edxfdd_det          where
                         edxfdd_exf_name =  xfname    and
                         edxfdd_exf_vers =  xfvers    and
                         edxfdd_doc_in   =  doc_in    and
                         edxfdd_rec_seq  =  io_xfseq  and
                         edxfdd_fld_seq  =  ctr      no-lock :

                         i_data_type = edxfdd_fld_type.

                     end.

                     if i_data_type = "S" then
                         edxrd_det.edxrd_exf_fld[ ctr ] =
                             right-trim( xfdata[ ctr ] ).
                     else


                     edxrd_det.edxrd_exf_fld[ ctr ] = trim( xfdata[ ctr ] ).

                 end.  /* DO CTR = 1 TO NUM-EXTENTS */

                 if recid( edxrd_det ) = -1 then.

                 if isControlData then do:
                    create inControlData.
                    buffer-copy edxrd_det
                       except edxrd_exf_seq
                       to inControlData.

                    if recid(inControlData) = -1 then.

                 end.

             end. /* IF NOT AVAILABLE EDXRD_DET THEN */

         END PROCEDURE. /* PROCEDURE CR_REPDTL */


         PROCEDURE error_proc:
         /*----------------------------------------------------------------
           Purpose: Process any and all errors
           Parameters: i_docseq     - document sequence number
                       i_msgnbr     - message number
                       i_error_type - severity of error
                       i_err_data   - value that caused the errror

           Notes: creates a record in the Exchange File Status History
                  table.
         ----------------------------------------------------------------*/


             define input parameter i_docseq   as integer           no-undo.
             define input parameter i_msgnbr   as integer           no-undo.
             define input parameter i_err_type as integer           no-undo.
             define input parameter i_err_data as character         no-undo.

             define       variable  l_msg_seq  as integer initial 0 no-undo.


             /* GET THE LAST MESSAGE SEQUENCE NUMBER AND INCREMENT IT */

             for last edxfsdd_det           where
                 edxfsdd_exf_seq = i_docseq no-lock:
             end.
            l_msg_seq =
                 ( if available edxfsdd_det then edxfsdd_msg_seq else 0 ) + 1.

             /* MAKE SURE THAT YOU DON'T HAVE ANY WARNINGS IN THIS EXCHANGE
                FILE LOAD. IF ANY THEN SET THE VALUE OF 'curr_snf_err' TO 'NO'.
                CAUSE 'curr_snf_err' WILL IGNORE THE PROCESSING AND THERE BY
                CREATING RECORDS IN TEMPORARY TABLE (TT_SNF_ERR), WHICH WILL
                BE LATER EXPORTED TO ERROR FILE FOR FIXING AND FURTURE
                PROCESSING
             */

             create edxfsdd_det.
             assign
                 edxfsdd_exf_seq     = i_docseq
                 edxfsdd_proc_sess   = proc_sess
                 edxfsdd_msg_seq     = l_msg_seq
                 edxfsdd_msg_no      = i_msgnbr
                 edxfsdd_error_level = i_err_type
                 curr_snf_err        = ( if i_err_type >= 3 then yes else no )
                 edxfsdd_proc_seq    = 1
                 edxfsdd_delm_str    = i_err_data.

             if recid( edxfsdd_det ) = -1 then .

         END PROCEDURE.  /* PROCEDURE ERROR_PROC */


         PROCEDURE up_token:
         /*----------------------------------------------------------------
           Purpose: Update token variables using the edsdd_det and
                    the xfdata array
           Parameters: i_token - name of the token to be updated
                       i_value - value of the token

           Notes:
         ----------------------------------------------------------------*/


             define input parameter i_token    like edsdd_fld_token no-undo.
             define input parameter i_docseq   as   integer         no-undo.
             define input parameter i_rec_seq  like edsdd_rec_seq   no-undo.
             define input parameter i_rec_type as   character       no-undo.
             define input parameter i_value    as   character       no-undo.
             define input parameter i_data_type as  character       no-undo.
             define variable x as integer no-undo.

            do x = 1 to num-entries(i_token,","):

             for first tt_token              where
                 tt_tk_rec_type = i_rec_type and
                 tt_tk_rec_seq  = i_rec_seq  and
                  tt_tk_tkn_name = entry(x,i_token,",")    :
             end.

             if not available tt_token then do:
                 create tt_token.
                 assign
                     tt_tk_rec_type = i_rec_type
                     tt_tk_rec_seq  = i_rec_seq
                     tt_tk_tkn_name = entry(x,i_token,",").
             end.

         /* ADD trim TO i_value FOR ORACLE */
             if i_data_type = "S" then
                 tt_tk_tkn_value = right-trim( i_value ).
             else
             tt_tk_tkn_value = trim(i_value).
            end.

             if recid( tt_token ) = -1 then .


             /* ASSIGN TOKEN VARIABLES */

             repeat x = 1 to num-entries(i_token,","):
               case entry(x,i_token,","):

         /* ADD trim TO i_value FOR ORACLE */
                 when ("tp-id")              then tp-id              =
                     if i_data_type = "S" then right-trim(i_value) else
                     trim(i_value).
                 when ("tp-document-id")     then tp-document-id     =
                     if i_data_type = "S" then right-trim(i_value) else
                     trim(i_value).
                 when ("tp-message-nbr")     then tp-message-nbr     =
                     if i_data_type = "S" then right-trim(i_value) else
                     trim(i_value).
                 when ("tp-func-grp-nbr")    then tp-func-grp-nbr    =
                     if i_data_type = "S" then right-trim(i_value) else
                     trim(i_value).
                 when ("tp-interchange-nbr") then tp-interchange-nbr =
                     if i_data_type = "S" then right-trim(i_value) else
                     trim(i_value).
                 when ("tp-document-nbr")    then tp-document-nbr    =
                     if i_data_type = "S" then right-trim(i_value) else
                     trim(i_value).
                 when ("tp-address")         then tp-address         =
                     if i_data_type = "S" then right-trim(i_value) else
                     trim(i_value).
                 when ("tp-site")            then tp-site            =
                     if i_data_type = "S" then right-trim(i_value) else
                     trim(i_value).

                 when ("app-table")           then app-table          =
                     if i_data_type = "S" then right-trim(i_value) else
                     trim(i_value).
                 when ("app-document-id")     then app-document-id    =
                     if i_data_type = "S" then right-trim(i_value) else
                     trim(i_value).
                 when ("app-document-vers")   then app-document-vers  =
                     if i_data_type = "S" then right-trim(i_value) else
                     trim(i_value).
                 when ("app-table-index")     then app-table-index    =
                     if i_data_type = "S" then right-trim(i_value) else
                     trim(i_value).
                 when ("app-table-value")     then app-table-value    =
                     if i_data_type = "S" then right-trim(i_value) else
                     trim(i_value).
                 when ("app-address")         then app-address        =
                     if i_data_type = "S" then right-trim(i_value) else
                     trim(i_value).
                 when ("app-site")            then app-site           =
                     if i_data_type = "S" then right-trim(i_value) else
                     trim(i_value).

             end.  /* CASE I_TOKEN */
             end. /* MULTIPLE TOKEN STATEMENT */

         END PROCEDURE.  /* PROCEDURE UP_TOKEN */


         PROCEDURE up_repmstr:
         /*----------------------------------------------------------------
           Purpose: Update the Exchange File Repository Master using tokens.
           Parameters: i_exfseq - exchange file sequence number

           Notes: IF the token and value does not exist in temp table
                  tt_token then the token value was not available until the
                  data section of the document, use the value from the
                  token variable to update the master repository.
         ----------------------------------------------------------------*/

             define input parameter i_exfseq  like edxr_exf_seq no-undo.

             define variable x as integer no-undo.

              /* UPDATE REST OF EXCHANGE FILE REPOSITORY MASTER FIELDS */

             for first edxr_mstr         where
                 edxr_exf_seq = i_exfseq exclusive-lock:
             end.

             for each tt_token where tt_tk_rec_type = "CTRL-REC":

                case tt_tk_tkn_name:
                  when ("tp-id")             then edxr_tp_id      =
               tt_tk_tkn_value.
                  when ("tp-document-id")    then edxr_tp_doc     =
               tt_tk_tkn_value.
                  when ("tp-message-nbr")    then edxr_tp_msg_no  =
               tt_tk_tkn_value.
                  when ("tp-func-grp-nbr")   then edxr_tp_fg_no   =
               tt_tk_tkn_value.
                  when ("tp-interchange-nbr") then edxr_tp_ic_no  =
               tt_tk_tkn_value.
                  when ("tp-document-nbr")   then edxr_tp_doc_ref =
               tt_tk_tkn_value.
                  when ("tp-address")        then edxr_tp_addr    =
               tt_tk_tkn_value.
                  when ("tp-site")           then edxr_tp_site    =
               tt_tk_tkn_value.

                end.  /* CASE TT_TK_TKN_NAME */
             end.
             assign
                 edxr_tp_id      =
                     ( if edxr_tp_id = "" then tp-id else edxr_tp_id )

                 edxr_tp_doc     =
                     ( if edxr_tp_doc = "" then tp-document-id
                     else edxr_tp_doc )

                 edxr_tp_doc_ref =
                     ( if edxr_tp_doc_ref = "" then tp-document-nbr
                     else edxr_tp_doc_ref )

                 edxr_tp_ic_no   =
                     ( if edxr_tp_ic_no = "" then tp-interchange-nbr
                     else edxr_tp_ic_no )

                 edxr_tp_fg_no   =
                     ( if edxr_tp_fg_no = "" then tp-func-grp-nbr
                     else edxr_tp_fg_no )

                 edxr_tp_msg_no  =
                     ( if edxr_tp_msg_no = "" then tp-message-nbr
                     else edxr_tp_msg_no )

                 edxr_tp_site    =
                     ( if edxr_tp_site = "" then tp-site
                     else edxr_tp_site )

                 edxr_tp_addr    =
                     ( if edxr_tp_addr = "" then tp-address
                     else edxr_tp_addr )

                 edxr_exf_name   = xfname
                 edxr_exf_vers   = xfvers.


             edxr_token_val_list = "".
             /* ADD DATA TO THE TOKEN LIST */
             for first edtpd_det where
                       edtpd_tp_id = edxr_tp_id and
                       edtpd_tp_doc = edxr_tp_doc and
                       edtpd_doc_in no-lock:

                repeat x = 1 to num-entries(edtpd_token_list):

                  case entry(x,edtpd_token_list):

                     when ("TP-ID") then edxr_token_val_list = edxr_token_val_list + tp-id + ",".
                     when ("TP-DOCUMENT-ID") then edxr_token_val_list = edxr_token_val_list + tp-document-id + ",".
                     when ("TP-DOCUMENT-NBR") then edxr_token_val_list = edxr_token_val_list + tp-document-nbr + ",".
                     when ("TP-INTERCHANGE-NBR") then edxr_token_val_list = edxr_token_val_list + tp-interchange-nbr + ",".
                     when ("TP-FUNC-GRP-NBR") then edxr_token_val_list = edxr_token_val_list + tp-func-grp-nbr + ",".
                     when ("TP-MESSAGE-NBR") then edxr_token_val_list = edxr_token_val_list + tp-message-nbr + ",".
                     when ("TP-SITE") then edxr_token_val_list = edxr_token_val_list + tp-site + ",".
                     when ("TP-ADDRESS") then edxr_token_val_list = edxr_token_val_list + tp-address + ",".

                     when ("APP-ADDRESS") then edxr_token_val_list = edxr_token_val_list + app-address + ",".
                     when ("APP-SITE") then edxr_token_val_list = edxr_token_val_list + app-site + ",".
                     when ("APP-TABLE") then edxr_token_val_list = edxr_token_val_list + app-table + ",".
                     when ("APP-TABLE-INDEX") then edxr_token_val_list = edxr_token_val_list + app-table-index + ",".
                     when ("APP-TABLE-VALUE") then edxr_token_val_list = edxr_token_val_list + app-table-value + ",".
                     when ("APP-DOCUMENT-ID") then edxr_token_val_list = edxr_token_val_list + app-document-id + ",".
                     when ("APP-DOCUMENT-VERS") then edxr_token_val_list = edxr_token_val_list + app-document-vers + ",".
                  end case.

                end. /*REPEAT */

                /* REMOVE COMMA FROM END OF LIST */
                edxr_token_val_list = substring(edxr_token_val_list,1,length(edxr_token_val_list) - 1 ).
             end.

         END PROCEDURE.  /* PROCEDURE UP_REPMSTR */


         PROCEDURE init_docvars:
         /*----------------------------------------------------------------
           Purpose: Initialize the common variables.
           Parameters: None

           Notes:
         ----------------------------------------------------------------*/

             define input parameter i_rec_seq  like edsd_rec_seq no-undo.

             /* INITIALIZE THE TOKEN VALUES IN TT_TOKEN TEMP TABLE */

             if not isControlData then
               run reset_tokens in THIS-PROCEDURE(
                   INPUT i_rec_seq               ).

             assign
                 l_loop_stack       = "1,1,0,0"
                 l_cur_loop_level   = 1
                 seqlist          = ""
                 seqctr           = ""
                 docseq             = 0
                 l_counter          = 1.


             /* CLEAR OUT THE RECORDS IN TEMPORARY TABLE FOR THE
                PREVIOUS DOCUMENT
             */

             if not curr_snf_err and not isControlData then  do:

                for each tt_snf_err exclusive-lock:
                    delete tt_snf_err.
                end.

             end. /* IF NOT curr_snf_err THEN */


             /* CLEAR OUT STRUCTURE SEQUENCE ID TEMPORARY TABLE */

             for each tt_stack exclusive-lock:
                 delete tt_stack.
             end.

         END PROCEDURE.  /* PROCEDURE INIT_DOCVARS */


         PROCEDURE getseq:
         /*----------------------------------------------------------------
           Purpose: Get the next document sequence number from the
                    progress sequence.
           Parameters: io_docseq - exchange file sequence number
                                    (document sequence number)
           Notes:
         ----------------------------------------------------------------*/


             define input-output parameter io_docseq as integer no-undo.

             if io_docseq = 0 then

                 /* GET THE NEXT FILE SEQUENCE NUMBER */
                 io_docseq = next-value(edxfs_sq01).

         END PROCEDURE.  /* PROCEDURE GETSEQ */



         PROCEDURE up_stsmstr:
         /*----------------------------------------------------------------
           Purpose:  Update the Exchange File Status tables
           Parameters: i_docseq    - exchange file sequence number
                                        (document sequence number)
                       i_proc_sess - process session number

           Notes:  Updates the exchange file status Master table with token
                   values and sets the status as being successful.

                   Updates the status in the exchange file status History table
                   as being successful.

                   Adds the document sequence number to the processing
                   list work file.
         ----------------------------------------------------------------*/

             define input parameter i_docseq     like edxr_exf_seq no-undo.
             define input parameter i_snf_err    like curr_snf_err no-undo.
             define input parameter i_proc_sess  like edc_proc_sess no-undo.


             /* UPDATE EXCHANGE FILE STATUS TABLE */

             for first edxfs_mstr         where
                 edxfs_exf_seq = i_docseq exclusive-lock:
             end.
             assign
                 edxfs_tp_doc_ref = tp-document-nbr
                 edxfs_tp_id      = tp-id
                 edxfs_tp_doc     = tp-document-id
                 edxfs_status     = ( if i_snf_err then 11 else 12 )
                 edxfs_file_name  =
                     (if num-entries(snfile_name,"/") > 1 then
                       trim(substring(entry(num-entries(
                         snfile_name,"/" ),snfile_name,"/"),1,30))
                     else
                        trim(substring(entry(num-entries(
                          snfile_name,"~\"),snfile_name,"~\"),1,30))).


             /* UPDATE EXCHANGE FILE HISTORY TABLE */

             for first edxfsd_det               where
                 edxfsd_exf_seq   = i_docseq    and
                 edxfsd_proc_sess = i_proc_sess and
                 edxfsd_proc_seq  = 1           exclusive-lock:
             end.

             edxfsd_status = edxfs_status.


             /* IF THE DOCUMENT IS GOOD ONLY THEN PROCEED WITH TRANSFORMATION */

             if not i_snf_err then do:

                 /* CREATE RECORDS INTO EXCHANGE FILE PROCESSING LIST WORK
                    FILE
                 */
                 create tt_exf_status.
                 tt_exf_seq = i_docseq.

                 if recid( tt_exf_status ) = -1 then .

             end.

         END PROCEDURE.  /* PROCEDURE UP_STSMSTR */



         PROCEDURE cr_repmstr:
         /*----------------------------------------------------------------
           Purpose: Create the exchange file repository master
           Parameters: i_docseq - exchange file sequence number
                                    (document sequence number)

           Notes:
         ----------------------------------------------------------------*/

             define input parameter i_docseq like edxr_exf_seq no-undo.

             /* CREATE A REPOSITORY MASTER RECORD */

             create edxr_mstr.
             assign
                 edxr_exf_seq = i_docseq
                 edxr_doc_in  = doc_in
                 l_loop_stack      = "1,1,0,0"
                 l_cur_loop_level  = 1.

             if recid( edxrd_det ) = -1 then.

             run up_repmstr in THIS-PROCEDURE( INPUT i_docseq ).

             /* DELETE RECORDS IN THE COPIED VALUES SO TO NOT DUP THEM */
             for each inControlData        where
                      inControlData.edxrd_exf_rec_seq  >= xfseq exclusive-lock:
                 delete inControlData.
             end.

             for each inControlData no-lock:
                create edxrd_det.
                buffer-copy inControlData
                  to
                edxrd_det.

                assign edxrd_det.edxrd_exf_seq = i_docseq.

                if recid(edxrd_det) = -1 then .

                /* GET THE CURRENT RECORDS END LOOP */
                for first edxfd_det
                   where edxfd_exf_name =  xfname
                   and   edxfd_exf_vers =  xfvers
                   and   edxfd_doc_in   =  doc_in
                   and   edxfd_rec_seq  =  inControlData.edxrd_exf_rec_seq
                   no-lock :

                   {gprun.i ""edgenseq.p""
                      "(INPUT        edxfd_rec_seq    ,
                        INPUT        edxfd_rec_lp_end ,
                        INPUT-OUTPUT l_loop_stack     ,
                        INPUT-OUTPUT l_cur_loop_level ,
                        OUTPUT       l_struct_id      )"}.

                end. /* FOR FIRST edxfd_det */

             end.

         END PROCEDURE.  /* PROCEDURE CR_REPMSTR */



         PROCEDURE val_data2eof:
         /*----------------------------------------------------------------
           Purpose: Verify that no mandatory data records have been missed.
           Parameters: i_msgnbr - message number

           Notes:
         ----------------------------------------------------------------*/


             define output parameter i_msgnbr   as integer no-undo.
             define output parameter i_err_data as character.

             for first edxfd_det  no-lock where
                 edxfd_exf_name = xfname  and
                 edxfd_exf_vers = xfvers  and
                 edxfd_doc_in   = doc_in  and
                 edxfd_rec_seq  > xfseq   and
                 edxfd_rec_reqd:
             end.

             if available edxfd_det then
                 assign
                     i_msgnbr   = 4402
                     i_err_data = subsys + "; " + edxfd_rec_name + "; " +
                                  xfname + "; " + string(xfvers) + "; " +
                                  l_filename + "; " + l_errorfile.

         END PROCEDURE.  /* PROCEDURE VAL_DATA2EOF */



         PROCEDURE cr_exstat:
         /*----------------------------------------------------------------
           Purpose: Create the Exchange File Status and History records for
                    the document.
           Parameters: i_docseq - exchange file sequence number
                                    (document sequence number)
                       i_proc_sess - process session number

           Notes:
         ----------------------------------------------------------------*/

             define input parameter i_docseq    as  integer no-undo.
             define input parameter i_proc_sess as  integer no-undo.


             for first edxfs_mstr         where
                 edxfs_exf_seq = i_docseq no-lock:
             end.

             if not available edxfs_mstr then do:

                 create edxfs_mstr.

                 assign
                    edxfs_exf_seq   = i_docseq
                    edxfs_status    = 11
                    edxfs_doc_in    = doc_in.

                 if recid( edxfs_mstr ) = -1 then .

             end. /* IF NOT AVAILABLE  EDXFS_MSTR */


             for first edxfsd_det               where
                 edxfsd_exf_seq   = i_docseq    and
                 edxfsd_proc_sess = i_proc_sess and
                 edxfsd_proc_seq  = 1 no-lock:
             end.

             if not available edxfsd_det then do:

                 /* CREATE EXCHANGE FILE STATUS HISTORY RECORD */

                 create edxfsd_det.
                 assign
                     edxfsd_exf_seq   = i_docseq
                     edxfsd_status    = 11
                     edxfsd_proc_sess = i_proc_sess
                     edxfsd_proc_date = today
                     edxfsd_proc_time = time
                     edxfsd_proc_seq  = 1.

                 if recid( edxfsd_det ) = -1 then .

             end. /* IF NOT AVAILABLE EDXFSD_DET THEN */


         END PROCEDURE.  /* PROCEDURE CR_EXSTAT */


         /*****************************************************************
           OUTPUT THE PREVIOUS DOCUMENT TO ERROR FILE IN CASE OF ERROR
         *****************************************************************/
         PROCEDURE cr_err_file:
         /*----------------------------------------------------------------
           Purpose: Output the previous document to error file
           Parameters: i_xfline - data from the SNF file for the new document
                       i_err_file_name - name of the file the previous
                                         document will be written to
                       i_proc_sess - process session number
                       i_doc_seq - i_docseq - exchange file sequence number
                                    (document sequence number)
                       io_snf_err - error flag

           Notes:
         ----------------------------------------------------------------*/

             define input parameter  i_rec_seq       like edsd_rec_seq  no-undo.
             define input parameter  i_xfline        as character       no-undo.
             define input parameter  i_err_file_name as character       no-undo.
             define input parameter  i_proc_sess     as integer         no-undo.
             define input-output parameter io_docseq as integer         no-undo.
             define input-output parameter io_snf_err as  logical       no-undo.

             for first edxfs_mstr          where
                 edxfs_exf_seq = io_docseq exclusive-lock:
             end.

             if available edxfs_mstr then
                 assign
                     edxfs_tp_doc_ref = tp-document-nbr
                     edxfs_tp_id      = tp-id
                     edxfs_tp_doc     = tp-document-id.


             /* EXPORT THE PREVIOUS DOCUMENT RECORDS TO ERROR FILE */

             output to value( i_err_file_name ) append.

             put unformatted {&edixload_p_2} docseq skip.
             for each tt_snf_rec :
                 put unformatted tt_snf_rec.tt_sf_rec_line skip.
             end.
             for each tt_snf_err :
                 put unformatted tt_snf_err.tt_line skip.
             end.

             output close.


             /* CLEAR OUT THE RECORDS IN TEMPORARY TABLE FOR THE
                PREVIOUS DOCUMENT AND CREATE NEW EXCHANGE FILE STATUS AND
                HISTORY RECORDS
             */

             run create_new_status in THIS-PROCEDURE(
                 INPUT i_rec_seq                    ,
                 INPUT i_xfline                     ,
                 INPUT l_counter                    ,
                 INPUT i_proc_sess                  ,
                 INPUT-OUTPUT io_docseq             ).

             io_snf_err = no.      /* RESET SNF ERROR FLAG          */


         END PROCEDURE. /* PROCEDURE CR_ERR_FILE */



         PROCEDURE create_new_status:
         /*----------------------------------------------------------------
           Purpose: Purge all records from temp table and create status records
           Parameters: i_xfline - data from the SNF file for the document
                       io_counter - used to keep temp table records in
                                    correct order
                       i_proc_sess - process session number
                       io_doc_seq - i_docseq - exchange file sequence number
                                    (document sequence number)
           Notes:
         ----------------------------------------------------------------*/

             define input parameter  i_rec_seq       like edsd_rec_seq  no-undo.
             define input parameter  i_xfline        as character       no-undo.
             define input parameter  io_counter      as integer         no-undo.
             define input parameter  i_proc_sess     as integer         no-undo.
             define input-output parameter io_docseq like edxrd_det.edxrd_exf_seq no-undo.


             /* CLEAR OUT THE RECORDS IN TEMPORARY TABLE FOR THE
                PREVIOUS DOCUMENT
             */

             for each tt_snf_err exclusive-lock:
                 delete tt_snf_err.
             end.


             /* CLEAR OUT STRUCTURE SEQUENCE ID TEMPORARY TABLE */

             for each tt_stack exclusive-lock:
                 delete tt_stack.
             end.


             assign
                 l_loop_stack     = "1,1,0,0"
                 l_cur_loop_level = 1
                 seqlist          = ""
                 seqctr           = ""
                 curr_snf_err     = no
                 io_counter       = 1
                 io_docseq        = 0.       /* GENERATE NEW DOCUMENT SEQ. NO */


             /* GET THE NEXT SEQUENCE NUMBER FOR CREATING EXCHANGE FILE
                STATUS AND EXCHANGE FILE HISTORY TABLES
             */
             run getseq in THIS-PROCEDURE (INPUT-OUTPUT io_docseq ).


             /* INITIALIZE THE TOKEN VALUES IN TT_TOKEN TEMP TABLE */

             run reset_tokens in THIS-PROCEDURE( INPUT i_rec_seq ).


             /* CREATE EXCHANGE FILE STATUS TABLE AND EXCHANGE FILE
                HISTORY TABLE RECORDS FOR THE NEW DOCUMENT
             */

             run cr_exstat in THIS-PROCEDURE(
                 INPUT io_docseq            ,
                 INPUT i_proc_sess          ).


         END PROCEDURE. /* PROCEDURE CREATE_NEW_STATUS */


         PROCEDURE reset_tokens:
         /*----------------------------------------------------------------
           Purpose: Initialize the token variables.
           Parameters: None

           Notes:
         ----------------------------------------------------------------*/

             define input parameter ip_rec_seq  like edsd_rec_seq no-undo.

             for each tt_token                      where
                 ( tt_tk_rec_type = "CTRL-REC"   and
                     tt_tk_rec_seq  >= ip_rec_seq ) or

                 tt_tk_rec_type = "DATA-REC" :

                 tt_tk_tkn_value = "".

                 /* INITIALIZE TOKEN VARIABLES */

                 case tt_tk_tkn_name:

                     when ("tp-id")              then tp-id              = "".
                     when ("tp-document-id")     then tp-document-id     = "".
                     when ("tp-message-nbr")     then tp-message-nbr     = "".
                     when ("tp-func-grp-nbr")    then tp-func-grp-nbr    = "".
                     when ("tp-interchange-nbr") then tp-interchange-nbr = "".
                     when ("tp-document-nbr")    then tp-document-nbr    = "".
                     when ("tp-address")         then tp-address         = "".
                     when ("tp-site")            then tp-site            = "".

                     when ("app-table")           then app-table         = "".
                     when ("app-document-id")     then app-document-id   = "".
                     when ("app-document-vers")   then app-document-vers = "".
                     when ("app-table-index")     then app-table-index   = "".
                     when ("app-table-value")     then app-table-value   = "".
                     when ("app-address")         then app-address       = "".
                     when ("app-site")            then app-site          = "".
                 end.  /* CASE TT_TK_TKN_NAME */

             end. /* FOR EACH TT_TOKEN WHERE */


         END PROCEDURE. /* PROCEDURE RESET_TOKENS */

         PROCEDURE controltocontrol:
         /*----------------------------------------------------------------
           Purpose: Run logic for control to control transition
           Parameters: None

           Notes:
         ----------------------------------------------------------------*/


         /* IF PREVIOUS CONTROL RECORD SEQUENCE NUMBER IS EQUAL
            TO THE CURRENT CONTROL RECORD SEQUENCE THEN ERROR
         */
         if prev_xfseq > 0 and xfseq > 0 and
             prev_xfseq = xfseq then do:

             /* ERROR: DUPLICATE CONTROL RECORDS */
            error_data = rec_code + "; " +
                         subsys + "; " + l_filename +
                         "; " + l_errorfile.

             run error_proc in THIS-PROCEDURE       (
                 INPUT docseq                       ,
                 INPUT 4404                         ,
                 INPUT 4                            ,
                 INPUT error_data                   ).
         end.


         /* DELETE ALL RECORDS ONLY IF THE PREVIOUS SEQUENCE
            NUMBER IS NOT EQUAL TO THE CURRENT ONE, FROM
            TT_SNF_REC WHOSE RECORD SEQUENCE IS GREATER THAN
            OR EQUAL TO THE CURRENT RECORD SEQUENCE
         */

         if prev_xfseq <> xfseq then

             for each tt_snf_rec        where
                 tt_sf_rec_seq >= xfseq exclusive-lock:

                 delete tt_snf_rec.
             end.

         /* GET THE LAST RECORD SEQUENCE FROM TT_SNF_REC */

         for last tt_snf_rec :
         end.

         if available tt_snf_rec then
             l_last_rec_seq = tt_sf_rec_seq.
         else l_last_rec_seq = 0.


         /* INSERT THE CURRENT SNF RECORD TO TT_SNF_REC TABLE */

         create tt_snf_rec.
         assign
             tt_sf_rec_seq  = xfseq
             tt_sf_rec_line = xfline.

         if recid( tt_snf_rec ) = -1 then .

         /* CHECK IF ANY MANDATORY CONTROL RECORD IS MISSED. IF
            SO CHECK IF IT IS AVAILABLE IN TT_SNF_REC
            ( TEMP TABLE ). IF NOT THEN GENERATE ERROR MESSAGE
         */
         for each b_edsd_det no-lock                   where
             b_edsd_det.edsd_subsys   = chk_subsys     and
             b_edsd_det.edsd_doc_in   = doc_in         and
             b_edsd_det.edsd_rec_seq  > l_last_rec_seq and
             b_edsd_det.edsd_rec_seq  < xfseq          and
             b_edsd_det.edsd_rec_reqd :

             if not can-find( first tt_snf_rec where
                 tt_sf_rec_seq = b_edsd_det.edsd_rec_seq)
                     then do:

                 /* MANDATORY CONTROL RECORD IS MISSING */
                error_data =  b_edsd_det.edsd_rec_cde +
                              "; " + subsys + "; " +
                              l_filename + "; " +
                              l_errorfile.

                 run error_proc in THIS-PROCEDURE  (
                     INPUT docseq                  ,
                     INPUT 4405                    ,
                     INPUT 4                       ,
                     INPUT error_data              ).
             end.

         end. /* FOR EACH B_EDSD_DET NO-LOCK WHERE */

         END PROCEDURE. /* PROCEDURE CONTROLTOCONTROL */



         PROCEDURE datatocontrol:
         /*----------------------------------------------------------------
           Purpose: Run logic for data to control transition
           Parameters: None

           Notes:
         ----------------------------------------------------------------*/


          /* PREVIOUS DOCUMENT IS AN ERROR DOCUMENT */

          if prev_snf_err then do:

              run cr_err_file in THIS-PROCEDURE(
                  INPUT        xfseq           ,
                  INPUT        xfline          ,
                  INPUT        l_err_file_name ,
                  INPUT        proc_sess       ,
                  INPUT-OUTPUT docseq          ,
                  INPUT-OUTPUT curr_snf_err    ).

          end. /* IF PREV_SNF_ERR THEN */

          /* PREVIOUS DOCUMENT IS A GOOD DOCUMENT */
          else do:

              /* MAKE SURE THAT ARE NO MISSING MANDATORY DATA
                 RECORDS
              */
              if not isControlData then do:
                 {gprun.i ""edchkseq.p""
                     "(INPUT        """"    ,
                       INPUT        subsys    ,
                       INPUT        doc_in    ,
                       INPUT        xfname    ,
                       INPUT        xfvers    ,
                       INPUT        prev_xfseq,
                       INPUT        xfseq     ,
                       INPUT        NO        , /* PREV - DATA    */
                       INPUT        YES       , /* CURR - CONTROL */
                       INPUT-OUTPUT seqlist   ,
                       INPUT-OUTPUT seqctr    ,
                       OUTPUT       msgnbr    ,
                       OUTPUT       l_retn_val)"}.

                 end. /* IF NOT IS CONTROLDATA */

                 if msgnbr > 0 then do:
                      /* 4402 Mandatory data record is missing
                         the return value is the record name
                      */

                     prev_snf_err = curr_snf_err.
                     error_data = subsys + "; " +
                                     l_retn_val + ";" +
                                     l_filename + "; " +
                                     l_errorfile.

                     run error_proc in THIS-PROCEDURE(
                         INPUT docseq                ,
                         INPUT msgnbr                ,
                         INPUT 4                     ,
                         INPUT error_data            ).

                     run cr_err_file in THIS-PROCEDURE(
                         INPUT        xfseq           ,
                         INPUT        xfline          ,
                         INPUT        l_err_file_name ,
                         INPUT        proc_sess       ,
                         INPUT-OUTPUT docseq          ,
                         INPUT-OUTPUT curr_snf_err    ).

                     curr_snf_err = prev_snf_err.

                 end. /* IF MSGNBR > 0 THEN */

                 /* UPDATE THE STATUS TABLE AND REPOSITORY TABLES */
                 else do:

                     run up_repmstr in THIS-PROCEDURE(
                         INPUT docseq ).

                     run up_stsmstr in THIS-PROCEDURE(
                         INPUT docseq                ,
                         INPUT curr_snf_err          ,
                         INPUT proc_sess             ).

                     run init_docvars in THIS-PROCEDURE(
                         INPUT xfseq                   ).

                /* NEED TO REFERENCE CONTROL-RECORD FOR MULTIPLE MESSAGES */
                     for first edsd_det
                        fields (edsd_subsys edsd_doc_in edsd_rec_cde
                                edsd_rec_token edsd_rec_seq)
                        where edsd_subsys  = subsys
                        and   edsd_doc_in  = doc_in
                        and   edsd_rec_cde = rec_code
                        no-lock:

                        if edsd_rec_token <> ""
                        then
                           run up_token in THIS-PROCEDURE(
                              input edsd_rec_token       ,
                              input docseq               ,
                              input edsd_rec_seq         ,
                              input "CTRL-REC"           ,
                              input rec_code             ,
                              input ""                   ).

                     end. /* FOR FIRST edsd_det */

                 end. /* UPDATE THE STATUS TABLE AND REP. TABLES */

          end. /* PREVIOUS DOCUMENT IS A GOOD DOCUMENT */


          /* DELETE ALL RECORDS FROM TT_SNF_REC WHOSE RECORD
             SEQUENCE IS GREATER THAN OR EQUAL TO THE CURRENT
             RECORD SEQUENCE
          */
          if not isControlData then do:
             for each tt_snf_rec        where
                 tt_sf_rec_seq >= xfseq exclusive-lock:

                 delete tt_snf_rec.
             end.

             /* GET THE LAST RECORD SEQUENCE FROM TT_SNF_REC */

             for last tt_snf_rec :
             end.

             if available tt_snf_rec then
                 l_last_rec_seq = tt_sf_rec_seq.
             else l_last_rec_seq = 0.



             /* INSERT THE CURRENT SNF RECORD TO TT_SNF_REC
                TABLE
             */
             create tt_snf_rec.
             assign
                 tt_sf_rec_seq  = xfseq
                 tt_sf_rec_line = xfline.

             if recid( tt_snf_rec ) = -1 then .
          end.

         /* GET THE NEXT SEQUENCE NUMBER FOR CREATING EXCHANGE FILE
             STATUS AND EXCHANGE FILE HISTORY TABLES
         */
         run getseq in THIS-PROCEDURE (INPUT-OUTPUT docseq ).


         /* CREATE EXCHANGE FILE STATUS TABLE AND EXCHANGE FILE HISTORY
            TABLE RECORDS FOR EACH DOCUMENT
         */
         run cr_exstat in THIS-PROCEDURE(
                        INPUT docseq               ,
                        INPUT proc_sess            ).

         /* CHECK IF ANY MANDATORY CONTROL RECORD IS MISSED.
            IF SO CHECK IF IT IS AVAILABLE IN TT_SNF_REC
            ( TEMP TABLE ). IF NOT THEN GENERATE ERROR MESSAGE
         */
         if not isControlData then
         for each b_edsd_det no-lock                   where
             b_edsd_det.edsd_subsys   = chk_subsys     and
             b_edsd_det.edsd_doc_in   = doc_in         and
             b_edsd_det.edsd_rec_seq  > l_last_rec_seq and
             b_edsd_det.edsd_rec_seq  < xfseq          and
             b_edsd_det.edsd_rec_reqd :

             if not can-find( first tt_snf_rec where
                 tt_sf_rec_seq = b_edsd_det.edsd_rec_seq )
                     then do:

                 /* MANDATORY CONTROL RECORD IS MISSING IN
                    SNF FILE
                 */
                 error_data = b_edsd_det.edsd_rec_cde +
                              "; " + subsys + "; " +
                              l_filename + "; " +
                              l_errorfile.

                 run error_proc in THIS-PROCEDURE  (
                     INPUT docseq                  ,
                     INPUT 4405                    ,
                     INPUT 4                       ,
                     INPUT error_data              ).
             end.

         end. /* FOR EACH B_EDSD_DET NO-LOCK WHERE */

         END PROCEDURE. /* PROCEDURE datatocontrol */

         PROCEDURE controltodata:
         /*----------------------------------------------------------------
           Purpose: Run logic for control to data transition
           Parameters: None

           Notes:
         ----------------------------------------------------------------*/
         if not prev_snf_err then prev_snf_err = curr_snf_err.


         /* INSERT RECORDS INTO TEMPORARY TABLE */

         create tt_snf_err.
         assign
             tt_seq_no = l_counter
             tt_line   = xfline.

         if recid( tt_snf_err ) = -1 then .

         /* GET THE LAST RECORD SEQUENCE FROM TT_SNF_REC */

         for last tt_snf_rec :
         end.

         if available tt_snf_rec then
             l_last_rec_seq = tt_sf_rec_seq.

         /* CHECK IF ANY MANDATORY CONTROL RECORD IS MISSED. IF
            SO CHECK IF IT IS AVAILABLE IN TT_SNF_REC
            ( TEMP TABLE ).  IF NOT THEN GENERATE ERROR MESSAGE
         */
         for each b_edsd_det no-lock                      where
             b_edsd_det.edsd_subsys   = chk_subsys        and
             b_edsd_det.edsd_doc_in   = doc_in            and
             b_edsd_det.edsd_rec_seq  > l_last_rec_seq    and
             b_edsd_det.edsd_rec_reqd :

             if not can-find( first tt_snf_rec where
                 tt_sf_rec_seq = b_edsd_det.edsd_rec_seq )
                     then do:

                 /* MANDATORY CONTROL RECORD IS MISSING */

                error_data =  b_edsd_det.edsd_rec_cde +
                              "; " + subsys + "; " +
                              l_filename + ";" + l_errorfile.

                 run error_proc in THIS-PROCEDURE   (
                      INPUT docseq                  ,
                      INPUT 4405                    ,
                      INPUT 4                       ,
                      INPUT error_data              ).

             end. /* IF NOT CAN-FIND( FIRST TT_SNF_REC WHERE */

         end. /* FOR EACH B_EDSD_DET NO-LOCK WHERE */


         /* MAKE SURE THAT NO MANDATORY DATA RECORDS ARE
            MISSED
         */
         {gprun.i ""edchkseq.p""
             "(INPUT        """"    ,
               INPUT        subsys    ,
               INPUT        doc_in    ,
               INPUT        xfname    ,
               INPUT        xfvers    ,
               INPUT        prev_xfseq,
               INPUT        xfseq     ,
               INPUT        YES       , /* PREV - CONTROL */
               INPUT        NO        , /* CURR - DATA */
               INPUT-OUTPUT seqlist   ,
               INPUT-OUTPUT seqctr    ,
               OUTPUT       msgnbr    ,
               OUTPUT       l_retn_val)"}.

         if msgnbr > 0 then do:
             /*4402 or 4405 or 4415

                    4402 returns <record name>; <xfname>;
                         and <xfvers>
                         needs <subsystem> <record name>
                               <xfname> <xfvers>
                               <file name> <error file>

                     4405 returns <record code>
                          needs <record code> <subsystem>
                           <file name> <error file>
             */

            if msgnbr = 4402 then
                error_data = subsys + "; " +
                             l_retn_val + ";" +
                             l_filename + "; " +
                             l_errorfile.
             else
                if msgnbr = 4405 then
                    error_data = l_retn_val + "; " +
                                 subsys + "; " +
                                 l_filename + "; " +
                                 l_errorfile.
            else
                error_data = l_retn_val.

             run error_proc in THIS-PROCEDURE(
                 INPUT docseq                ,
                 INPUT msgnbr                ,
                 INPUT 4                     ,
                 INPUT error_data            ).

         end. /* IF MSGNBR > 0 THEN */


         if not prev_snf_err and not curr_snf_err then
             run cr_repmstr in THIS-PROCEDURE (INPUT docseq ).


         END PROCEDURE. /* PROCEDURE CONTROLTODATA */

         PROCEDURE datatodata:
         /*----------------------------------------------------------------
           Purpose: Run logic for data to data transition
           Parameters: None

           Notes:
         ----------------------------------------------------------------*/
         if not prev_snf_err then prev_snf_err = curr_snf_err.

         /* INSERT RECORDS INTO TEMPORARY TABLE */

         create tt_snf_err.
         assign
             tt_seq_no = l_counter
             tt_line   = xfline.

         if recid( tt_snf_err ) = -1 then .

         if not curr_snf_err then do:

             /* MAKE SURE THAT NO MANDATORY DATA RECORDS ARE
                MISSED
             */

             {gprun.i ""edchkseq.p""
                 "(INPUT        """"    ,
                   INPUT        subsys    ,
                   INPUT        doc_in    ,
                   INPUT        xfname    ,
                   INPUT        xfvers    ,
                   INPUT        prev_xfseq,
                   INPUT        xfseq     ,
                   INPUT        NO        , /* PREV - DATA */
                   INPUT        NO        , /* CURR - DATA */
                   INPUT-OUTPUT seqlist   ,
                   INPUT-OUTPUT seqctr    ,
                   OUTPUT       msgnbr    ,
                   OUTPUT       l_retn_val)"}.

             if msgnbr > 0 then do:
                 /* 4402 or 4414 or 4415
                    4402 returns <record name>; <xfname>;
                         and <xfvers>
                         needs <subsystem> <record name>
                               <xfname> <xfvers>
                               <file name> <error file>

                     4414 returns <xfname>;<p_xfvers>;
                          and <sequence not found>.
                          needs <xfname> <xfvers>
                          <seq number>
                     4415 same as 4414
                 */

                 if msgnbr = 4402 then
                    error_data = subsys + "; " +
                                 l_retn_val + ";" +
                                 l_filename + "; " +
                                 l_errorfile.
                 else
                     error_data = l_retn_val.

                 run error_proc in THIS-PROCEDURE(
                     INPUT docseq                ,
                     INPUT msgnbr                ,
                     INPUT 4                     ,
                     INPUT error_data            ).
             end. /* IF MSGNBR > 0 */
         end. /* IF NOT CURR_SNF_ERR THEN */

         END PROCEDURE. /* PROCEDURE datatodata */
         /* EOF */
