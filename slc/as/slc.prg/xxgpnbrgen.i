/* gpnbrgen.i - NRM Number generation and validation of number against NRM */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/*V8:ConvertMode=NoConvert                                            */
/*K1Q4*/ /*V8:WebEnabled=No                                                */
/* REVISION: 8.6    LAST MODIFIED: 08/13/96   BY: *K003* Vinay Nayak-Sujir  */
/* REVISION: 8.6    LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1    LAST MODIFIED: 08/13/00   BY: *N0KS* myb                */
/* By: Neil Gao Date: 07/12/04 ECO: * ss 20071204 * */


      procedure getnbr:
         define input parameter seqid   as character no-undo.
         define input parameter effdate as date no-undo.
         define output parameter    nextnbr as character no-undo.
         define output parameter    errorst as logical no-undo.
         define output parameter    errornum as integer no-undo.

         define variable h_nrm as handle no-undo.

         errorst = true.

/* ss 20071204 - b */
/*
         {gprun.i ""nrm.p"" " " "persistent set h_nrm"}
*/
         {gprun.i ""xxnrm.p"" " " "persistent set h_nrm"}
/* ss 20071204 - e */

         run nr_dispense in h_nrm (seqid,effdate,output nextnbr).
         run nr_check_error in h_nrm (output errorst, output errornum).

         delete procedure h_nrm.

      end. /* procedure getnbr */

      procedure valnbr:
         define input  parameter    seqid   as character no-undo.
         define input  parameter    effdate as date no-undo.
         define input  parameter    nextnbr as character no-undo.
         define output parameter    is_valid as logical no-undo.
         define output parameter    errorst as logical no-undo.
         define output parameter    errornum as integer no-undo.

         define variable h_nrm as handle no-undo.

         assign errorst = false
            is_valid = true.

         {gprun.i ""nrm.p"" "  " "persistent set h_nrm"}

             run nr_validate in h_nrm (input seqid , input nextnbr,
                       input effdate, output is_valid).
         run nr_check_error in h_nrm (output errorst, output errornum).

         if errorst then is_valid = false.

         delete procedure h_nrm.

      end. /* procedure getnbr */
