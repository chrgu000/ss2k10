/* gpnrseq.i - Internal procedures for various NR attributes          */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/*V8:ConvertMode=NoConvert                                            */
/*K1Q4*/ /*V8:WebEnabled=No                                               */
/* REVISION: 8.6    LAST MODIFIED: 08/01/96   BY: *K003* Vinay Nayak-Sujir */
/* REVISION: 8.6    LAST MODIFIED: 12/30/96   BY: *K03V* Vinay Nayak-Sujir */
/* REVISION: 8.6    LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 9.1    LAST MODIFIED: 08/13/00   BY: *N0KS* myb               */
/*By: Neil Gao 08/07/13 ECO: *SS 20080713* */


      procedure chk_internal:
         define input  parameter    seqid   as character no-undo.
         define output parameter    is_internal as logical no-undo.
         define output parameter    errorst as logical no-undo.
         define output parameter    errornum as integer no-undo.

         define variable h_nrm as handle no-undo.

         assign is_internal = ?
            errorst = true.

/*SS 20080713 - B*/
/*
         {gprun.i ""nrm.p"" "  " "persistent set h_nrm"}
*/
         {gprun.i ""xxnrm.p"" "  " "persistent set h_nrm"}

/*SS 20080713 - E*/

         run nr_is_internal in h_nrm (input seqid, output is_internal).

         run nr_check_error in h_nrm (output errorst, output errornum).

         delete procedure h_nrm.

      end. /* procedure chk_internal */

      procedure chk_valid:
          define input  parameter   seqid   as character no-undo.
          define input  parameter   reqd_dataset as character no-undo.
          define output parameter   errorst as logical no-undo.
          define output parameter   errornum as integer no-undo.

          define variable seq_dataset as character no-undo.
          define variable h_nrm as handle no-undo.
          define variable does_exist as logical no-undo.

/*SS 20080713 - B*/
/*
          {gprun.i ""nrm.p"" "  " "persistent set h_nrm"}
*/
          {gprun.i ""xxnrm.p"" "  " "persistent set h_nrm"}
/*SS 20080713 - E*/
          run nr_exists in h_nrm (input seqid, output does_exist).

          run nr_check_error in h_nrm (output errorst, output errornum).

          if not errorst then do:
         if not does_exist then
            assign errorst = true
               errornum = 5955.
         /* SEQUENCE # DOES NOT EXIST */
         else do:
             run nr_dataset in h_nrm (input seqid, output seq_dataset).
             if seq_dataset <> reqd_dataset then
            assign errorst = true
                   errornum = 5960.
         end.
          end.

          delete procedure h_nrm.
      end. /* procedure chk_valid */

      procedure chk_delnbr:

          define input  parameter   seqid   as character no-undo.
          define output parameter   can_discard as logical no-undo.
          define output parameter   errorst as logical no-undo.
          define output parameter   errornum as integer no-undo.

          define variable h_nrm as handle no-undo.

          assign errorst = true
             can_discard = false.

/*SS 20080713 - B*/
/*
         {gprun.i ""nrm.p"" "  " "persistent set h_nrm"}
*/
         {gprun.i ""xxnrm.p"" "  " "persistent set h_nrm"}

/*SS 20080713 - E*/
          run nr_can_discard in h_nrm (input seqid, output can_discard).
          run nr_check_error in h_nrm (output errorst, output errornum).

          delete procedure h_nrm.

      end. /* procedure delnbr */

      procedure get_nrdesc:
         define input  parameter    seqid   as character no-undo.
         define output parameter    descr as character no-undo.
         define output parameter    errorst as logical no-undo.
         define output parameter    errornum as integer no-undo.

         define variable h_nrm as handle no-undo.

         assign errorst = true.

/*SS 20080713 - B*/
/*
         {gprun.i ""nrm.p"" "  " "persistent set h_nrm"}
*/
         {gprun.i ""xxnrm.p"" "  " "persistent set h_nrm"}

/*SS 20080713 - E*/

         run nr_description in h_nrm (input seqid, output descr).

         run nr_check_error in h_nrm (output errorst, output errornum).

         delete procedure h_nrm.

      end. /* procedure get_nrdesc: */

/*K03V*   Added procedure get_nr_length */
      procedure get_nr_length:
         define input  parameter    seqid   as character no-undo.
         define output parameter    id_length as integer no-undo.
         define output parameter    errorst as logical no-undo.
         define output parameter    errornum as integer no-undo.

         define variable h_nrm as handle no-undo.

         errorst = true.

/*SS 20080713 - B*/
/*
         {gprun.i ""nrm.p"" "  " "persistent set h_nrm"}
*/
         {gprun.i ""xxnrm.p"" "  " "persistent set h_nrm"}

/*SS 20080713 - E*/
         run nr_get_length in h_nrm (input seqid, output id_length).

         run nr_check_error in h_nrm (output errorst, output errornum).

         delete procedure h_nrm.

      end. /* procedure get_nr_length */
