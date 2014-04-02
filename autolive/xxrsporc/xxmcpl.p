/* mcpl.p - Multi-Currency procedure library (non-interface routines)        */
/* Copyright 1986 QAD Inc. All rights reserved.                               */
/* $Id:: mcpl.p 15200 2012-02-23 20:06:30Z myb                             $: */

/* REVISION: 8.6E           CREATED: 05/26/98   BY: *L018* Steve Goeke       */
/* REVISION: 8.6E     LAST MODIFIED: 06/24/98   BY: *L01G* Robin McCarthy    */
/* REVISION: 8.6E     LAST MODIFIED: 07/14/98   BY: *L03X* Steve Goeke       */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* myb               */
/* Revision: 1.15     BY: Jeff Wootton          DATE: 03/12/02  ECO: *P020*  */
/* Revision: 1.16     BY: Mercy C.              DATE: 03/18/02  ECO: *M1WF* */
/* Revision: 1.19     BY: Paul Donnelly (SB)    DATE: 06/28/03  ECO: *Q00G* */
/* Revision: 1.20     BY: Sandy Brown           DATE: 12/06/03  ECO: *Q04L* */
/* Revision: 1.22     BY: Jean Miller           DATE: 07/05/07  ECO: *R0C6* */
/* Revision: 1.23     BY: Jean Miller           DATE: 11/08/07  ECO: *P66C* */
/* $Revision: 1.24 $  BY: Jean Miller           DATE: 11/22/09  ECO: *R1TW* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* CHANGED WEB TOKEN TO YES AS THIS ROUTINE IS USED IN REPORTS THAT */
/* ARE WEB-ENABLED */

/* This routine encapsulates all of the functions required for      */
/* Multi-Currency processing, excluding those requiring user        */
/* interface.  Each function is implemented below as an internal    */
/* procedure.  This procedure library routine is intended to be run */
/* PERSISTENT within any application that requires Multi-Currency   */
/* functionality.  The application may then call individual         */
/* internal procedures within the persistent routine as necessary.  */
/* The recommended method for instantiating the persistent          */
/* procedure and calling the various internal procedures is through */
/* use of gprunp.i.                                                 */
/*                                                                  */
/* Multi-Currency functions requiring user interface are            */
/* encapsulated in a separate procedure library, mcui.p.            */

/* Remove mc-chk-member-curr - output is "" and no */
/* Remove mc-chk-union-transparency - output is no */

/*324******************************************By zy***********/
/* when have code_fldname = "Standard Cost Exchange Rate Type"*/
/* Standard PO , Supplier Scheduled Order & recive            */
/* use code_value as exchange rate type                       */
/* other wise use system standard exchange rate type          */

{us/bbi/mfdeclre.i}
{us/gp/gprunpdf.i "glacdfpl" "p"}
{xxexrt.i}
/* TEMP TABLE DEFINITIONS */
define temp-table t_chk
   field t_chk_curr1 as character
   field t_chk_curr2 as character
   index t_chk_currs is primary unique
   t_chk_curr1
   t_chk_curr2.

define temp-table t_exru_usage
   field t_exru_step     as integer
   field t_exru_curr1    as character
   field t_exru_curr2    as character
   field t_exru_ex_rate  as decimal
   field t_exru_ex_rate2 as decimal
   index t_exru_curr1 is primary
   t_exru_curr1
   index t_exru_curr2
   t_exru_curr2.

/* STREAM DEFINITIONS */
define stream s_archive.

/* MAIN PROCEDURE BODY IS EMPTY */

/********************************************************************/

/* MULTI-CURRENCY LIBRARY PROCEDURES */

/* The following internal procedures comprise the Multi-Currency */
/* library.  They may be called from within any application      */
/* whenever the encapsulating library procedure is running       */
/* persistently.                                                 */

/********************************************************************/

PROCEDURE mc-archive-ex-rate-usage:

   /* This routine archives a set of Exchange Rate Usage            */
   /* (exru_usage) records.  This is intended to be used when       */
   /* archiving the associated transaction.  This routine does not  */
   /* delete the archived records - if deletion is required, a      */
   /* separate call to mc-delete-ex-rate-usage should be made.      */
   /* To prevent file conflict, always close output to the          */
   /* destination file before calling this routine, then re-open it */
   /* using the APPEND attribute following the call.                */
   /*                                                               */
   /* INPUT PARAMETERS                                              */
   /*  i_seq      - Sequence number identifying the set of Exchange */
   /*               Rate Usage records to be archived.              */
   /*  i_filename - Name of flatfile to which the set of usage      */
   /*               records is to be archived.  Contents of usage   */
   /*               records will be appended to this file.          */

   define input parameter i_seq      as integer   no-undo.
   define input parameter i_filename as character no-undo.

   define buffer b_exru_usage for exru_usage.

   /* Cycle through usage records to archive */
   for each b_exru_usage no-lock where exru_seq = i_seq
         break by exru_seq:

      /* Open output stream on first record */
      if first(exru_seq) then
         output stream s_archive to value(i_filename) append.

      /* Export the record */
      export stream s_archive "exru_usage".
      export stream s_archive b_exru_usage.

      /* Close output stream on last record */
      if last(exru_seq) then
         output stream s_archive close.

   end.  /* for each b_exru_usage */

END PROCEDURE.  /* mc-archive-ex-rate-usage */

/********************************************************************/
PROCEDURE mc-chk-valid-curr:

   /* This routine determines whether a given currency is valid.  A */
   /* currency is valid if it exists and is active.                 */
   /*                                                               */
   /* INPUT PARAMETERS                                              */
   /*  i_curr - Currency code to be validated.                      */
   /*                                                               */
   /* OUTPUT PARAMETERS                                             */
   /*  o_error - 0 if currency is valid; error message number       */
   /*            identifying reason for invalidity otherwise.       */

   define input  parameter i_curr  as character no-undo.
   define output parameter o_error as integer   no-undo.

   define buffer b_cu_mstr for cu_mstr.

   o_error = 3088.  /*  Invalid currency code */

   for first b_cu_mstr fields (cu_curr cu_active) no-lock
      where cu_curr = i_curr:

   o_error =
   if cu_active
   then
      0
   else
      2659.  /* Currency is not active */

   end.  /* for */

END PROCEDURE.  /* mc-chk-valid-curr */

/********************************************************************/

PROCEDURE mc-combine-ex-rates:

   /* Changed proc name from ip-combine-rates */

   /* This routine combines an exchange rate between a currency A   */
   /* and a second currency B, with an exchange between currency B  */
   /* a third currency C, resulting in an effective exchange rate   */
   /* between currencies A and C.  The result is scaled to prevent  */
   /* loss of accuracy resulting from Progress' limitation of 10    */
   /* decimal places.                                               */
   /*                                                               */
   /* INPUT PARAMETERS                                              */
   /*  i_AB_rate  - First component of the exchange rate between    */
   /*               currencies A and B.                             */
   /*  i_AB_rate2 - Second component of the exchange rate between   */
   /*               currencies A and B.                             */
   /*  i_BC_rate  - First component of the exchange rate between    */
   /*               currencies B and C.                             */
   /*  i_BC_rate2 - Second component of the exchange rate between   */
   /*               currencies B and C.                             */
   /*                                                               */
   /* OUTPUT PARAMETERS                                             */
   /*  o_AC_rate  - First component of the exchange rate between    */
   /*               currencies A and C.                             */
   /*  o_AC_rate2 - Second component of the exchange rate between   */
   /*               currencies A and C.                             */

   define input  parameter i_AB_rate  as decimal no-undo.
   define input  parameter i_AB_rate2 as decimal no-undo.
   define input  parameter i_BC_rate  as decimal no-undo.
   define input  parameter i_BC_rate2 as decimal no-undo.
   define output parameter o_AC_rate  as decimal no-undo.
   define output parameter o_AC_rate2 as decimal no-undo.

   define variable v_scale as integer no-undo.

   /* Combine two-step exchange rate into a single scaled step */
   assign
      o_AC_rate  = 10000000000 * i_AB_rate  * i_BC_rate
      o_AC_rate2 = 10000000000 * i_AB_rate2 * i_BC_rate2
      v_scale    =
      max
      (length(string(o_AC_rate  - truncate(o_AC_rate ,0))),
      length(string(o_AC_rate2 - truncate(o_AC_rate2,0))))
      o_AC_rate  = o_AC_rate  / exp(10, 11 - v_scale)
      o_AC_rate2 = o_AC_rate2 / exp(10, 11 - v_scale).

END PROCEDURE.  /* mc-combine-ex-rates */

/********************************************************************/

PROCEDURE mc-copy-ex-rate-usage:

   /* This routine creates a copy of a set of Exchange Rate Usage   */
   /* (exru_usage) records.  This is intended to be used when       */
   /* creating a transaction record with the same exchange rate as  */
   /* another transaction - for example, when creating a            */
   /* transaction history (tr_hist) entry.                          */
   /*                                                               */
   /* INPUT PARAMETERS                                              */
   /*  i_seq - Sequence number identifying the set of Exchange Rate */
   /*          Usage records to be copied.                          */
   /*                                                               */
   /* OUTPUT PARAMETERS                                             */
   /*  o_seq - Sequence number identifying the new set of Exchange  */
   /*          Rate Usage records created.                          */

   define input  parameter i_seq as integer no-undo.
   define output parameter o_seq as integer no-undo initial 0.

   define buffer b1_exru_usage for exru_usage.
   define buffer b2_exru_usage for exru_usage.

   /* Cycle through usage records to copy */
   for each b1_exru_usage no-lock where exru_seq = i_seq
         break by exru_seq:

      /* Get next unused sequence number for new usage records */
      if first(exru_seq) then do:
         {us/mf/mfnxtsq1.i  "true and " b2_exru_usage exru_seq exru_sq1 o_seq}
      end.  /* if first-of */

      /* Copy usage record to new buffer */
      buffer-copy
         b1_exru_usage except oid_exru_usage exru_seq
         to b2_exru_usage.
      b2_exru_usage.exru_seq = o_seq.
      if recid (b2_exru_usage) = -1 then .

   end.  /* for each b1_exru_usage */

END PROCEDURE.  /* mc-copy-ex-rate-usage */

/********************************************************************/

PROCEDURE mc-create-ex-rate-usage:

   /* This routine retrieves an exchange rate in the same manner as */
   /* mc-get-ex-rate.  Additionally, if the exchange rate is        */
   /* obtained indirectly, it creates a series of records in the    */
   /* Exchange Rate Usage table (exru_usage) detailing the steps    */
   /* taken to obtain the rate.  This sequence number is intended   */
   /* to be stored within the transaction record for which the      */
   /* exchange rate was obtained, so that the user may see and      */
   /* possibly modify the rate during maintenance of the            */
   /* transaction.                                                  */
   /*                                                               */
   /* Exchange Rate Usage records are effectively part of the       */
   /* transaction with which they are associated, and should always */
   /* be deleted (using mc-delete-ex-rate-usage) whenever the       */
   /* corresponding transaction is deleted.                         */
   /*                                                               */
   /* INPUT PARAMETERS                                              */
   /*  i_curr1 - First currency involved in the exchange.           */
   /*  i_curr2 - Second currency involved in the exchange.          */
   /*  i_type  - Exchange rate type.                                */
   /*  i_date  - Effective date of the currency exchange.           */
   /*                                                               */
   /* OUTPUT PARAMETERS                                             */
   /*  o_rate  - First component of the exchange rate between       */
   /*            i_curr1 and i_curr2.                               */
   /*  o_rate2 - Second component of the exchange rate between      */
   /*            i_curr1 and i_curr2.                               */
   /*  o_seq   - Sequence number identifying the set of Exchange    */
   /*            Rate Usage records created.                        */
   /*  o_error - 0 if a valid exchange rate is found; error message */
   /*            number identifying reason for failure otherwise.   */

   define input  parameter i_curr1 as character no-undo.
   define input  parameter i_curr2 as character no-undo.
   define input  parameter i_type  as character no-undo.
   define input  parameter i_date  as date      no-undo.
   define output parameter o_rate  as decimal   no-undo initial 1.
   define output parameter o_rate2 as decimal   no-undo initial 1.
   define output parameter o_seq   as integer   no-undo initial 0.
   define output parameter o_error as integer   no-undo initial 0.

   define variable v_step  as integer   no-undo initial 0.
   define variable v_curr  as character no-undo.
   define variable v_found as logical   no-undo.

   define buffer b_exru_usage for exru_usage.

   /* Make sure temp tables are empty */
   run ip-cleanup-temps.

   /* Get the direct or indirect exchange rate, tracking its path. */
   /* In the parameter list below, the last input parameter (true) */
   /* indicates that the the steps taken to obtain the rate should */
   /* be tracked in a temp table, so that a set of usage records   */
   /* can be created.  The i-o parameter (v_step) is initialized   */
   /* to 0, and is used to accumulate the number of steps tracked  */
   /* throughout multiple levels of recursive calls to             */
   /* ip-get-rate.  See also mc-get-ex-rate.                       */
   run ip-get-rate
      (input        i_curr1,
      input        i_curr2,
      input        i_type,
      input        i_date,
      input        true,
      input-output v_step,
      output       o_rate,
      output       o_rate2,
      output       v_found).

   /* Create usage records to track multiple steps used to get rate */
   if v_found and v_step > 1 then do:

      assign
         v_curr = i_curr1
         v_step = 0.

      /* Get next unused sequence number for usage records */
      {us/mf/mfnxtsq1.i  "true and " b_exru_usage exru_seq exru_sq1 o_seq}

      /* Cycle through temp recs and build sorted set of usage recs */
      do while true:
         find first t_exru_usage exclusive-lock where
            t_exru_curr1 = v_curr no-error.
         if not available t_exru_usage then
         find first t_exru_usage exclusive-lock where
            t_exru_curr2 = v_curr no-error.
         if not available t_exru_usage then
         leave.  /* do */

         create b_exru_usage.
         assign
            exru_seq  = o_seq
            v_step    = v_step + 1
            exru_step = v_step.
         if recid (b_exru_usage) = -1 then .

         if v_curr = t_exru_curr1 then
         assign
            exru_curr1    = t_exru_curr1
            exru_curr2    = t_exru_curr2
            exru_ex_rate  = t_exru_ex_rate
            exru_ex_rate2 = t_exru_ex_rate2.
         else
         assign
            exru_curr1    = t_exru_curr2
            exru_curr2    = t_exru_curr1
            exru_ex_rate  = t_exru_ex_rate2
            exru_ex_rate2 = t_exru_ex_rate.
         v_curr = exru_curr2.

         delete t_exru_usage.

      end.  /* do while true */

   end.  /* if v_found */

   /* Finished with temp tables, so clear them */
   run ip-cleanup-temps.

   if not v_found then
      o_error = 81.  /* Exchange rate does not exist */

END PROCEDURE.  /* mc-create-ex-rate-usage */

/********************************************************************/

PROCEDURE mc-curr-conv:

   /* This routine performs a currency conversion, optionally       */
   /* rounding the result based on the target currency's rounding   */
   /* method.                                                       */
   /*                                                               */
   /* INPUT PARAMETERS                                              */
   /*  i_src_curr  - Currency in which the amount to be converted   */
   /*                expressed.  This parameter is not actually     */
   /*                used, but is only included for consistency.    */
   /*  i_targ_curr - Currency to which the amount is to be          */
   /*                converted.  This parameter is only used when   */
   /*                rounding the result.  If the result is not     */
   /*                rounded, this may be left blank.               */
   /*  i_src_rate  - Source currency component of the exchange rate */
   /*                between the source and target currencies.      */
   /*  i_targ_rate - Target currency component of the exchange rate */
   /*                between the source and target currencies.      */
   /*  i_src_amt   - Source amount to be converted to the target    */
   /*                currency.                                      */
   /*  i_round     - Logical indicating whether to round the result */
   /*                of the conversion.                             */
   /*                                                               */
   /* OUTPUT PARAMETERS                                             */
   /*  o_targ_amt - Result of the currency conversion: the          */
   /*               equivalent of the source amount expressed in    */
   /*               terms of the target currency.                   */
   /*  o_error    - 0 if currency conversion is successful; error   */
   /*               message number identifying reason for failure   */
   /*               otherwise.                                      */

   define input  parameter i_src_curr  as character no-undo.
   define input  parameter i_targ_curr as character no-undo.
   define input  parameter i_src_rate  as decimal   no-undo.
   define input  parameter i_targ_rate as decimal   no-undo.
   define input  parameter i_src_amt   as decimal   no-undo.
   define input  parameter i_round     as logical   no-undo.
   define output parameter o_targ_amt  as decimal   no-undo.
   define output parameter o_error     as integer   no-undo initial 0.

   define variable v_rnd_mthd as character no-undo.

   /* Perform the raw conversion calculation.  Scaling of the rates */
   /* used prevents loss of accuracy resulting from Progress'       */
   /* limitation of 10 decimal places.                              */
   o_targ_amt =
   i_src_amt *
   (10000000000 * i_targ_rate) /
   (10000000000 * i_src_rate).

   /* Round if necesary */
   if i_round then do:

      /* Get rounding method of currency */
      run mc-get-rnd-mthd
         (input  i_targ_curr,
         output v_rnd_mthd,
         output o_error).

      /* Round according to returned rounding method */
      if o_error = 0 then
      run mc-curr-rnd
         (input-output o_targ_amt,
         input        v_rnd_mthd,
         output       o_error).

   end.  /* if i_round */

END PROCEDURE.  /* mc-curr-conv */

/********************************************************************/

PROCEDURE mc-curr-rnd:

   /* This routine rounds a given amount according to a specified   */
   /* rounding method.  It is identical in function to gpcurrnd.p,  */
   /* except that it returns an error number in the case of         */
   /* failure, rather than displaying an error message directly.    */
   /*                                                               */
   /* Note: Changes made here may also have to be made to           */
   /* gpcurrnd.p, and vice versa.                                   */
   /*                                                               */
   /* INPUT-OUTPUT PARAMETERS                                       */
   /*  io_amt - The amount to be rounded.                           */
   /*                                                               */
   /* INPUT PARAMETERS                                              */
   /*  i_rnd_mthd - The rounding method to be used in rounding the  */
   /*               result.                                         */
   /* OUTPUT PARAMETERS                                             */
   /*  o_error - 0 if rounding is successful; error message number  */
   /*            identifying reason for failure otherwise.          */

   define input-output parameter io_amt     as decimal   no-undo.
   define input        parameter i_rnd_mthd as character no-undo.
   define output       parameter o_error    as integer   no-undo.

   define variable v_abs_amt  as decimal no-undo.
   define variable v_negative as logical no-undo.

   define buffer b_rnd_mstr for rnd_mstr.

   o_error = 863.  /* Rounding method does not exist */

   for first b_rnd_mstr where b_rnd_mstr.rnd_rnd_mthd = i_rnd_mthd
   no-lock:

   /* Clear error flag, truncate value to rounding precision */
   assign
      o_error    = 0
      v_negative = io_amt < 0
      v_abs_amt  = absolute(io_amt)
      io_amt     = rnd_unit * truncate(v_abs_amt / rnd_unit,0).

   /* If threshold = 0 and remainder > 0, or ...  */

   if (rnd_thrshld = 0 and v_abs_amt > io_amt) or

      /* ... 0 < threshold < 1 and remainder >= threshold... */

      (rnd_thrshld >  0        and
      rnd_thrshld <> rnd_unit and
      v_abs_amt - io_amt >= rnd_thrshld) then

   /* ... then round it at the threshold */

   io_amt = io_amt + rnd_unit.

   if v_negative then io_amt = - io_amt.

   end.  /* for */

END PROCEDURE.  /* mc-curr-rnd */

/********************************************************************/

PROCEDURE mc-delete-ex-rate-usage:

   /* This routine deletes a set of Exchange Rate Usage             */
   /* (exru_usage) records.  Exchange Rate Usage records should be  */
   /* deleted whenever their associated transaction record is       */
   /* deleted.                                                      */
   /*                                                               */
   /* INPUT PARAMETERS                                              */
   /*  i_seq - Sequence number identifying the set of Exchange Rate */
   /*          Usage records to be deleted.                         */

   define input parameter i_seq as integer no-undo.

   define buffer b_exru_usage for exru_usage.

   for each b_exru_usage exclusive-lock where exru_seq = i_seq:
      delete b_exru_usage.
   end.  /* for exh b_exru_usage */

END PROCEDURE.  /* mc-delete-ex-rate-usage */

/********************************************************************/

PROCEDURE mc-get-ex-rate:

   /* This routine returns a direct or indirect exchange rate       */
   /* between two currencies.  A direct rate is one which exists in */
   /* the Exchange Rate table (exr_rate).  An indirect rate is      */
   /* no longer valid in this version of the product.               */
   /*                                                               */
   /* INPUT PARAMETERS                                              */
   /*  i_curr1 - First currency involved in the exchange.           */
   /*  i_curr2 - Second currency involved in the exchange.          */
   /*  i_type  - Exchange rate type.                                */
   /*  i_date  - Effective date of the currency exchange.           */
   /*                                                               */
   /* OUTPUT PARAMETERS                                             */
   /*  o_rate  - First component of the exchange rate between       */
   /*            i_curr1 and i_curr2.                               */
   /*  o_rate2 - Second component of the exchange rate between      */
   /*            i_curr1 and i_curr2.                               */
   /*  o_error - 0 if a valid exchange rate is found; error message */
   /*            number identifying reason for failure otherwise.   */

   define input  parameter i_curr1 as character no-undo.
   define input  parameter i_curr2 as character no-undo.
   define input  parameter i_type  as character no-undo.
   define input  parameter i_date  as date      no-undo.
   define output parameter o_rate  as decimal   no-undo initial 1.
   define output parameter o_rate2 as decimal   no-undo initial 1.
   define output parameter o_error as integer   no-undo initial 0.

   define variable v_step  as integer no-undo initial 0.
   define variable v_found as logical no-undo.

   /* Make sure temp tables are empty */
   run ip-cleanup-temps.

   /* Get the direct or indirect exchange rate.  In the parameter */
   /* list below, the last input parameter (false) indicates      */
   /* not to track the steps taken to obtain the rate.  The i-o   */
   /* parameter (v_step) is only used when tracking steps.  See   */
   /* also mc-create-ex-rate-usage.                               */
   run ip-get-rate
      (input        i_curr1,
      input        i_curr2,
      input        i_type,
      input        i_date,
      input        false,
      input-output v_step,
      output       o_rate,
      output       o_rate2,
      output       v_found).

   /* Finished with temp tables, so clear them */
   run ip-cleanup-temps.

   if not v_found then
      o_error = 81.  /* Exchange rate does not exist */

END PROCEDURE.  /* mc-get-ex-rate */

/********************************************************************/
PROCEDURE mc-get-rnd-mthd:

   /* This routine returns the rounding method for a given          */
   /* currency.                                                     */
   /*                                                               */
   /* INPUT PARAMETERS                                              */
   /*  i_curr - Currency code for which rounding method is needed.  */
   /*                                                               */
   /* OUTPUT PARAMETERS                                             */
   /*  o_rnd_mthd - The rounding method for the specified currency. */
   /*  o_error    - 0 if the rounding method is found; error        */
   /*               message number identifying reason for failure   */
   /*               otherwise.                                      */

   define input  parameter i_curr     as character no-undo.
   define output parameter o_rnd_mthd as character no-undo initial "".
   define output parameter o_error    as integer   no-undo.

   define buffer b_cu_mstr for cu_mstr.

   o_error = 3088.  /*  Invalid currency code */

   /* Get currency master record */
   for first b_cu_mstr fields (cu_curr cu_rnd_mthd) no-lock
      where cu_curr = i_curr:

   assign
      o_rnd_mthd = cu_rnd_mthd
      o_error    = 0.

   end.  /* for */

END PROCEDURE.  /* mc-get-rnd-mthd */

/********************************************************************/

/* END OF LIBRARY PROCEDURES */

/********************************************************************/

/* INTERNAL PROCEDURES */

/* The following procedures should only be called from within other */
/* MC library routines (procedures internal to mcpl.p or mcui.p).   */
/* There should never be a reason to call them directly from any    */
/* application.                                                     */

/********************************************************************/

PROCEDURE ip-cleanup-temps:

   /* This routine deletes all records in the temp tables used for  */
   /* exchange rate retrieval and usage record creation.            */

   empty temp-table t_chk.
   empty temp-table t_exru_usage.

END PROCEDURE.  /* ip-cleanup-temps */

/********************************************************************/

PROCEDURE ip-get-direct-rate:

   /* This routine returns a direct exchange rate between two       */
   /* currencies, optionally tracking the step used to obtain the   */
   /* rate.                                                         */
   /*                                                               */
   /* INPUT PARAMETERS                                              */
   /*  i_curr1 - First currency involved in the exchange.           */
   /*  i_curr2 - Second currency involved in the exchange.          */
   /*  i_type  - Exchange rate type.                                */
   /*  i_date  - Effective date of the currency exchange.           */
   /*  i_track - Logical indicating whether to track retrieval      */
   /*            step.                                              */
   /*                                                               */
   /* INPUT-OUTPUT PARAMETERS                                       */
   /*  io_step - Step number used for tracking retrieval steps.     */
   /*            Incremented when a direct exchange rate record is  */
   /*            found and tracked.                                 */
   /*                                                               */
   /* OUTPUT PARAMETERS                                             */
   /*  o_rate  - First component of the exchange rate between       */
   /*            i_curr1 and i_curr2.                               */
   /*  o_rate2 - Second component of the exchange rate between      */
   /*            i_curr1 and i_curr2.                               */
   /*  o_found - Logical indicating whether an exchange rate was    */
   /*            found.                                             */

   define input        parameter i_curr1 as character no-undo.
   define input        parameter i_curr2 as character no-undo.
   define input        parameter i_type  as character no-undo.
   define input        parameter i_date  as date      no-undo.
   define input        parameter i_track as logical   no-undo.
   define input-output parameter io_step as integer   no-undo.
   define output       parameter o_rate  as decimal   no-undo
      initial 1.
   define output       parameter o_rate2 as decimal   no-undo
      initial 1.
   define output       parameter o_found as logical   no-undo
      initial false.

   define buffer b_exr_rate for exr_rate.

   /* Look for a direct exchange rate between the currencies */
   for first b_exr_rate exclusive-lock where b_exr_rate.exr_domain = global_domain and
      exr_curr1      =  i_curr1 and
      exr_curr2      =  i_curr2 and
      exr_ratetype   =  i_type  and
      exr_start_date <= i_date  and
      exr_end_date   >= i_date:

/*324*/  for first code_mstr no-lock where
/*324*/            code_domain = global_domain and
/*324*/            code_fldname = "Standard Cost Exchange Rate Type":
/*324*/     assign exr_rate2 = getexratebycurr(input i_curr2,
/*324*/            input i_curr1, input code_value,
/*324*/            input i_date).
/*324*/  end.

   assign
      o_rate  = exr_rate
      o_rate2 = exr_rate2
      o_found = true.

   /* Track that the direct rate was found */
   if i_track then do:
      create t_exru_usage.
      assign
         io_step         = io_step + 1
         t_exru_step     = io_step
         t_exru_curr1    = exr_curr1
         t_exru_curr2    = exr_curr2
         t_exru_ex_rate  = exr_rate
         t_exru_ex_rate2 = exr_rate2.
      if recid (t_exru_usage) = -1 then .
      end.  /* if i_track */

   end.  /* for first b_exr_rate */

END PROCEDURE.  /* ip-get-direct-rate */


PROCEDURE ip-get-rate:

   /* This routine returns a direct or indirect exchange rate       */
   /* between two currencies, optionally tracking the steps used to */
   /* obtain the rate.                                              */
   /*                                                               */
   /* INPUT PARAMETERS                                              */
   /*  i_curr1 - First currency involved in the exchange.           */
   /*  i_curr2 - Second currency involved in the exchange.          */
   /*  i_type  - Exchange rate type.                                */
   /*  i_date  - Effective date of the currency exchange.           */
   /*  i_track - Logical indicating whether to track retrieval      */
   /*            steps.                                             */
   /*                                                               */
   /* INPUT-OUTPUT PARAMETERS                                       */
   /*  io_step - Step number used when tracking retrieval steps.    */
   /*            Should be set to 0 when this routine is initially  */
   /*            called, and increments throughout subsequent       */
   /*            recursive calls as tracking records are created.   */
   /*                                                               */
   /* OUTPUT PARAMETERS                                             */
   /*  o_rate  - First component of the exchange rate between       */
   /*            i_curr1 and i_curr2.                               */
   /*  o_rate2 - Second component of the exchange rate between      */
   /*            i_curr1 and i_curr2.                               */
   /*  o_found - Logical indicating whether an exchange rate was    */
   /*            found.                                             */

   define input        parameter i_curr1 as character no-undo.
   define input        parameter i_curr2 as character no-undo.
   define input        parameter i_type  as character no-undo.
   define input        parameter i_date  as date      no-undo.
   define input        parameter i_track as logical   no-undo.
   define input-output parameter io_step as integer   no-undo.
   define output       parameter o_rate  as decimal   no-undo
      initial 1.
   define output       parameter o_rate2 as decimal   no-undo
      initial 1.
   define output       parameter o_found as logical   no-undo
      initial false.

   /* If currencies are identical, no conversion is necessary */
   if i_curr1 = i_curr2 then do:
      o_found = true.
      return.
   end.  /* if i_curr1 = i_curr2 */

   /* Circularity check - just in case */
   /* Check if this pair has been considered already */
   if can-find
      (t_chk where
      t_chk_curr1 = i_curr1 and
      t_chk_curr2 = i_curr2) or
      can-find
      (t_chk where
      t_chk_curr1 = i_curr2 and
      t_chk_curr2 = i_curr1)
      then return.

   /* Flag that this pair has been considered */
   create t_chk.
   assign
      t_chk_curr1 = i_curr1
      t_chk_curr2 = i_curr2.
   if recid (t_chk) = -1 then .

   /* Look for a single-step conversion */
   run ip-get-direct-rate
      (input        i_curr1,
      input        i_curr2,
      input        i_type,
      input        i_date,
      input        i_track,
      input-output io_step,
      output       o_rate,
      output       o_rate2,
      output       o_found).

   /* Look for an inverse single-step conversion */
   if not o_found then
   run ip-get-direct-rate
      (input        i_curr2,
      input        i_curr1,
      input        i_type,
      input        i_date,
      input        i_track,
      input-output io_step,
      output       o_rate2,
      output       o_rate,
      output       o_found).

   /* Look for a two-step conversion using first currency's union */
   if not o_found then
      assign
         o_rate = 1
         o_rate2 = 1
         o_found = no.

END PROCEDURE.  /* ip-get-rate */

/********************************************************************/


/* END OF INTERNAL PROCEDURES */
