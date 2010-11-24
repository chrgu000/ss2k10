/* gpnrmgv.p - Generate/validate number per NRM                              */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*V8:ConvertMode=NoConvert                                                   */
/*K1Q4*/ /*V8:WebEnabled=No                                                  */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* myb               */


     {mfdeclre.i}


         /* Generates (for internal sequences) or validates (for external */
         /* sequences) a sequence number for a given sequence, using NRM */
         /* functionality */

         /* PARAMETERS */
         define input        parameter i_nrseq   as character          no-undo.
         define input-output parameter io_number as character          no-undo.
         define output       parameter o_err     as logical init false no-undo.
         define output       parameter o_errnum  as integer init 0     no-undo.

         /* LOCAL VARIABLES */
         define variable v_internal as logical no-undo.
         define variable v_valid    as logical no-undo.


         /* MAIN PROCEDURE BODY */


         /* Check whether given sequence is internal */
         run chk_internal
            (i_nrseq,
             output v_internal,
             output o_err,
             output o_errnum).
         if o_err then return.

     /* If internal, then attempt to generate a new number */
         if v_internal then do:
            if io_number ne "" then o_errnum = 5935.  /* Record does not exist */
            else do:
               run getnbr
                  (i_nrseq,
                   today,
                   output io_number,
                   output o_err,
                   output o_errnum).
               if o_err then return.
            end.  /* else */
         end.  /* if v_internal */

         /* If external and blank, then not valid */
         else if io_number eq "" then o_errnum = 5930.  /* Number must be entered */

     /* If external and non-blank, then validate */
         else do:
            run valnbr
               (i_nrseq,
                today,
                io_number,
                output v_valid,
                output o_err,
                output o_errnum).
            if o_err then return.

            if not v_valid then o_errnum = 5950.  /* Invalid number format */

         end.  /* else */

         o_err = o_errnum ne 0.


         /* END OF MAIN PROCEDURE BODY */


         /* INTERNAL PROCEDURES */

/*SS 20080713 - B*/
/*
         {gpnrseq.i}   /* includes 'chk_internal' */
*/
         {xxgpnrseq.i}   /* includes 'chk_internal' */
/*SS 20080713 - E*/
/* ss 20071204 - b */
/*
         {gpnbrgen.i}  /* includes 'getnbr' and 'valnbr' */
*/
         {xxgpnbrgen.i}  /* includes 'getnbr' and 'valnbr' */
/* ss 20071204 - e */


         /* END OF INTERNAL PROCEDURES */
