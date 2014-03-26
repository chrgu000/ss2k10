/* mcui.p - Multi-Currency procedure library (user interface routines)        */
/* Copyright 1986 QAD Inc. All rights reserved.                               */
/* $Id:: mcui.p 27571 2013-01-15 07:42:15Z j2x                             $: */
/*                                                                            */
/* Revision: 8.6E  BY: Steve Goeke        DATE: 05/26/98          ECO: *L018* */
/* Revision: 8.6E  BY: Brenda Milton      DATE: 07/06/98          ECO: *L03F* */
/* Revision: 8.6E  BY: Steve Goeke        DATE: 07/14/98          ECO: *L03X* */
/* Revision: 8.6E  BY: Russ Witt          DATE: 07/23/98          ECO: *L04F* */
/* REVISION: 9.1   BY: Annasaheb Rahane   DATE: 03/24/00          ECO: *N08T* */
/* Revision: 1.13      BY: Jeff Wootton           DATE: 05/15/00  ECO: *N059* */
/* Revision: 1.14      BY: Jean Miller            DATE: 05/15/00  ECO: *N0T3* */
/* Revision: 1.20      BY: Andrea Suchankova      DATE: 03/07/02  ECO: *N13P* */
/* $Revision: 1.21 $   BY: Jean Miller            DATE: 11/23/09  ECO: *R1TW* */
/* ************************************************************************** */
/* Note: This code has been modified to run when called inside an MFG/PRO API */
/* method as well as from the MFG/PRO menu, using the global variable         */
/* c-application-mode to conditionally execute API- vs. UI-specific logic.    */
/* Before modifying the code, please review the MFG/PRO API Development Guide */
/* in the QAD Development Standards for specific API coding standards and     */
/* guidelines.                                                                */
/* ************************************************************************** */

/* ----------------------------------------------------------------------------
   This routine encapsulates all of the functions required for multi-Currency
   Processing that require user interface. Each function is implemented below
   As an internal procedure. This Procedure library routine is intended to be
   Run PERSISTENT within any application that requires Multi-Currency
   Functionality. The application may then call individual internal procedures
   Within the persistent routine as necessary. The recommended method for
   Instantiating the persistent procedure and calling the various internal
   Procedures is through use of us/gp/gprunp.i.

   Multi-Currency functions that do not require user interface are
   Encapsulated in a separate procedure library, mcpl.p.
  --------------------------------------------------------------------------- */

/*============================================================================*/
/* *************************** Definitions ********************************** */
/*============================================================================*/

{us/bbi/mfdeclre.i}
{us/bbi/gplabel.i} /* EXTERNAL LABEL INCLUDE */
{us/px/pxsevcon.i}
{us/px/pxpgmmgr.i}
{/home/mfg/xrc/xxexrt.i}
/*
 * We need to define the API constants and variables as well as
 * include the temp table definition for the exchange rate temp-table.
 * Also get the handle to the controller and the temp table data from
 * the controller for use when running the internal procedures.
 */
{us/mf/mfaimfg.i} /* Common API constants and variables */

{us/mc/mctrit01.i} /* API Exchange Rate temp tables */

/* Multi-Currency procedure library API dataset definition */
{us/mc/mcdsui.i "reference-only"}

/* Some definitions required by us/gp/gprunp.i can't be declared in an internal     */
/* Procedure, so they're declared here.                                       */

{us/gp/gprunpdf.i "mcpl" "p"}

/* ----------------------------------------------------------------------------
   Both input and output routines are currently limited to dealing with
   Indirect exchange rates with a maximum of two steps. To change this limit,
   Change the preprocessor PP_MAX, below, accordingly. Changes will also have
   To be made in mc-ex-rate-input to the definition of input frame a-exch and the
   Update within the frame, and in mc-ex-rate-output to the definition of the
   Output parameters and their assignment.
  --------------------------------------------------------------------------- */

/* Constants */
&SCOPED-DEFINE PP_MAX 2

/* Buffer */
define buffer b_exru_usage for exru_usage.

/*============================================================================*/
/* ***************************** Main Block ********************************* */
/*============================================================================*/

/* MAIN PROCEDURE BODY IS EMPTY */


/*============================================================================*/
/* ********************* Multi Currency Library Procedures ****************** */
/*============================================================================*/
/* ----------------------------------------------------------------------------
   The following internal procedures comprise the Multi-Currency
   User-interface library.  They may be called from within any
   Application whenever the encapsulating library procedure is
   Running persistently.
  --------------------------------------------------------------------------- */

/*============================================================================*/
PROCEDURE mc-ex-rate-input:
/*------------------------------------------------------------------------------
Purpose:     To Handle The Input And Update Exchange Rate
Exceptions:  NONE
Conditions:
       Pre:   None.
       Post:   None.
Notes: This routine handles the input and updating of any exchange
       Rate, whether direct or indirect, associated with a
       Transaction.  In general, a table XX_mstr for some type of
       Transaction that requires foreign currency exchange will
       Include a field XX_curr for the transaction currency, fields
       XX_rate and XX_rate2 for the two components of the working
       Exchange rate (the rate used to perform the actual
       Conversions within the transaction) between the base and
       Transaction currencies, and a field XX_exru_seq that points
       To a set of exchange rate usage records in table exru_usage.
       Exru_usage stores the complete path used to obtain the
       Working exchange rate, whenever this rate is calculated
       Indirectly via some intermediate currency (such as the Euro).

       This routine handles all user input, updates the exru_usage
       Records, and recalculates and returns the working exchange rate.

       INPUT PARAMETERS
         i_curr1      - First currency involved in the exchange,
                        Usually transaction currency XX_curr.
         i_curr2      - Second currency involved in the exchange,
                        Usually the functional base currency.
         i_date       - Effective date of the transaction exchange.
         i_seq        - Sequence number of exchange rate usage record
                        Associated with the transaction, usually
                        XX_exru_seq.
         i_disp_fixed - Logical indicating whether to display and
                        Allow update of a "Fixed Rate" field during
                        Update of the exchange rate.
         i_row        - Starting row at which to display the
                        Overlaying update frame.

       INPUT-OUTPUT PARAMETERS
         io_rate      - First component of the working exchange rate
                        Between i_curr1 and i_curr2, usually XX_rate.
         io_rate2     - Second component of the working exchange rate
                        Between i_curr1 and i_curr2, usually XX_rate2.
         io_fix_rate  - "Fixed Rate" field, optionally updatable based
                        On value of i_disp_fixed.
History:
------------------------------------------------------------------------------*/
   define input        parameter i_curr1      as   character   no-undo.
   define input        parameter i_curr2      as   character   no-undo.
   define input        parameter i_date       as   date        no-undo.
   define input        parameter i_seq        as   integer     no-undo.
   define input        parameter i_disp_fixed as   logical     no-undo.
   define input        parameter i_row        as   integer     no-undo.
   define input-output parameter io_rate      as   decimal     no-undo.
   define input-output parameter io_rate2     as   decimal     no-undo.
   define input-output parameter io_fix_rate  like so_fix_rate no-undo.

   define variable v_curr1   like exr_curr1 extent {&PP_MAX} no-undo.
   define variable v_curr2   like exr_curr1 extent {&PP_MAX} no-undo.
   define variable v_rate    like exr_rate  extent {&PP_MAX} no-undo.
   define variable v_rate2   like exr_rate2 extent {&PP_MAX} no-undo.
   define variable v_equal   as   character extent {&PP_MAX}
                             format "x"     initial "="      no-undo.
   define variable v_union   as   logical   extent {&PP_MAX} no-undo.
   define variable v_steps   as   integer no-undo initial {&PP_MAX}.
   define variable v_invert  as   logical no-undo.
   define variable v_cnt     as   integer no-undo.
   define variable tempRate1 as   decimal no-undo.
   define variable tempRate2 as   decimal no-undo.
   define variable tempUnion as   logical no-undo.

   define variable lLegacyAPI     as   logical     no-undo.

   define buffer b_exru_usage for exru_usage.

   /*Multi-currency Exchange rate form definition*/
   form
      v_curr1[1] label "Exch Rate" colon 20
      v_rate [1] no-label
      v_equal[1] no-label
      v_curr2[1] no-label
      v_rate2[1] no-label
      space(2)
      skip
      v_curr1[2] no-label at 22
      v_rate [2] no-label
      v_equal[2] no-label
      v_curr2[2] no-label
      v_rate2[2] no-label
      space(2)
      skip
      io_fix_rate         colon 20

   with frame a-exch side-labels centered overlay.

   /* Set Frame Labels */
   setFrameLabels(frame a-exch:handle).

   if c-application-mode = "API" then do:

      {us/bbi/gprun.i ""gpaigach.p"" "(output ApiMethodHandle)"}

      if valid-handle(ApiMethodHandle) then do:
         /* Get the Multi-Currency procedure API dataset from the controller */
         run getDataset in ApiMethodHandle (input "dsExchangeRate",
                                            output dataset dsExchangeRate bind).
         lLegacyAPI = false.
      end.
      else do:
         lLegacyAPI  = true.

         /* Get handle of API Controller */
         {us/bbi/gprun.i ""gpaigh.p""
            "(output ApiMethodHandle,
              output ApiProgramName,
              output ApiMethodName,
              output ApiContextString)"}

         /* Get Exchange Rate temp-table */
         run getTransExchangeRates in ApiMethodHandle
            (output table ttTransExchangeRates).
      end.

   end. /* IF c-application-mode = "API" */

   /* Exchange rate input only required if currencies are different */
   if i_curr1 <> i_curr2 then
   main-blk:

   do transaction with frame a-exch:
      if c-application-mode <> "API" then
         assign
            frame a-exch:ROW   = max(i_row,1)
            io_fix_rate:HIDDEN = not i_disp_fixed.
      {us/px/pxrun.i &PROC='getUsageData'
         &PARAM="(input  i_seq,
            input  i_curr1,
            input  i_curr2,
            input  i_date,
            input  io_rate,
            input  io_rate2,
            output v_curr1[1],
            output v_curr2[1],
            output v_rate[1],
            output v_rate2[1],
            output v_union[1],
            output v_curr1[2],
            output v_curr2[2],
            output v_rate[2],
            output v_rate2[2],
            output v_union[2])"}

      if v_curr1[2] = "" and v_curr2[2] = "" then
         v_steps = 1.
      else
         v_steps = 2.

      if c-application-mode <> "API" then do:
         do v_cnt = 1 to v_steps:
            /* Display rates */
            display
               v_curr1[v_cnt]
               v_rate [v_cnt]
               v_equal[v_cnt]
               v_curr2[v_cnt]
               v_rate2[v_cnt].
         end.
      end.  /* if c-application-mode <> "API" */

      /* Do not display 'Fixed Rate?' field if exchange rate is not updateable*/
      if ((v_steps = 1 and v_union[1]) or
          (v_steps = 2 and v_union[1]  and v_union[2]))
         and c-application-mode <> "API"
      then
         assign
            io_fix_rate:HIDDEN = yes
            i_disp_fixed = no.

      /* Start at first field that's not "1" */
      if c-application-mode <> "API" then do:
         do v_cnt = 1 to v_steps:
            if  not v_union[v_cnt]
               and (v_rate [v_cnt] <> 1 or v_rate2[v_cnt] <> 1)
            then do:
               if v_rate [v_cnt] <> 1 then
                  next-prompt v_rate[v_cnt].
               else
                  next-prompt v_rate2[v_cnt].
               leave.  /* do v_cnt */
            end.  /* if not */

         end.  /* do v_cnt */
      end. /* c-application-mode <> "API" */

      up-blk:
      do on error  undo up-blk,   retry up-blk
            on endkey undo main-blk, leave main-blk:

         if retry and c-application-mode = "API" then
            undo main-blk, return error.

         if c-application-mode = "API" and not lLegacyAPI then do:
            run getNextRecord in ApiMethodHandle (input "ttExchangeRateInfo").
            if return-value = {&RECORD-NOT-FOUND} then leave.
         end.
         define variable vexchangeratetype as character initial "".
/*324*/  for first code_mstr no-lock where
/*324*/            code_domain = global_domain and
/*324*/            code_fldname = "Standard Cost Exchange Rate Type":
/*324*/       assign vexchangeratetype = code_value.
/*324*/       assign v_rate[1] = getexratebycurr(input i_curr2,
/*324*/              input i_curr1, input vexchangeratetype ,
/*324*/              input i_date).
/*324*/       display v_rate[1] with frame a-exch.
/*324*/  end.

/*324 display getcurrencyid("CNY") vexchangeratetype v_rate[1] i_curr1 i_curr2 i_date v_rate[2] with frame a-exch. */
         if c-application-mode <> "API" then do:
            /* Update only those rates which are displayed */
            update
               v_rate [1]  when (not v_union[1])
               v_rate2[1]  when (not v_union[1])
               v_rate [2]  when (not v_union[2] and v_steps >= 2)
               v_rate2[2]  when (not v_union[2] and v_steps >= 2)
               io_fix_rate when (i_disp_fixed).
         end.  /* if c-application-mode <> "API" */
         else do: /* if c-application-mode = "API" */
            if lLegacyAPI then do:
               for first ttTransExchangeRates no-lock:
                  if not v_union[1] then
                     assign
                        {us/mf/mfaiset.i v_rate[1]   ttTransExchangeRates.exRate}
                        {us/mf/mfaiset.i v_rate2[1]  ttTransExchangeRates.exRate2}
                                 .
                  if not v_union[2] and v_steps >= 2 then
                     assign
                        {us/mf/mfaiset.i v_rate[2]   ttTransExchangeRates.exRateInt}
                        {us/mf/mfaiset.i v_rate2[2]  ttTransExchangeRates.exRate2Int}
                                 .
                  if i_disp_fixed then
                     assign
                        {us/mf/mfaiset.i io_fix_rate ttTransExchangeRates.fixRate}
                  .
               end. /* first ttExchangeRate */
            end. /* if lLegacyAPI */
            else do:
               if not v_union[1] then
                  assign
                     {us/mf/mfaistvl.i v_rate[1]   ttExchangeRateInfo.vRate[1]}
                     {us/mf/mfaistvl.i v_rate2[1]  ttExchangeRateInfo.vRate2[1]}
                     .
               if not v_union[2] and v_steps >= 2 then
                  assign
                     {us/mf/mfaistvl.i v_rate[2]   ttExchangeRateInfo.vRate[2]}
                     {us/mf/mfaistvl.i v_rate2[2]  ttExchangeRateInfo.vRate2[2]}
                     .
               if i_disp_fixed then
                  assign
                     {us/mf/mfaistvl.i io_fix_rate ttExchangeRateInfo.ioFixRate}
                     .
            end.
         end. /* c-application-mode = "API" */

         /* Validate rates entered */
         do v_cnt = 1 to v_steps:

            /*Assign rates for passing to another procedure*/
            assign
               tempRate1 = v_rate[v_cnt]
               tempRate2 = v_rate2[v_cnt]
               tempUnion = v_union[v_cnt].

            {us/px/pxrun.i &PROC='validateEnteredRates'
               &PARAM="(input tempRate1,
                 input tempRate2,
                 input tempUnion)" &NOAPPERROR=true}
            if return-value = {&APP-ERROR-RESULT} then do:
               if c-application-mode <> "API" then do:
                  if v_rate2[v_cnt] = 0 then
                     next-prompt v_rate2[v_cnt].
                  else
                     next-prompt v_rate [v_cnt].

                  undo up-blk, retry up-blk.
               end. /* c-application-mode <> "API" */
               else /* c-application-mode = "API" */
                  undo up-blk, return error.
            end.
         end.  /* Do v_cnt */
      end.  /* DO ON ERROR */

      {us/px/pxrun.i &PROC='calcNewWorkingRate'
         &PARAM="(input i_seq,
            input v_rate[1],
            input v_rate2[1],
            input v_rate[2],
            input v_rate2[2],
            input v_invert,
            output io_rate,
            output io_rate2)"}
   end.  /* DO TRANSACTION */

   if c-application-mode <> "API" then
      hide frame a-exch.

END PROCEDURE.

/*============================================================================*/
PROCEDURE mc-ex-rate-output:
/*------------------------------------------------------------------------------
Purpose:     To Retrieve And Format Exchange Rate
Exceptions:  NONE
Conditions:
       Pre:   None.
       Post:   None.
Notes: This routine retrieves and formats for output the exchange
       Rate of a transaction, whether direct or indirect.  If the
       Rate is indirect, output will show each step used to obtain
       The working rate actually used to perform conversions within
       The transaction.

       INPUT PARAMETERS
         i_curr1 - First currency involved in the exchange, usually
                   Transaction currency XX_curr.
         i_curr2 - Second currency involved in the exchange, usually
                   The functional base currency.
         i_rate  - First component of the working exchange rate
                   Between i_curr1 and i_curr2, usually XX_rate.
         i_rate2 - Second component of the working exchange rate
                   Between i_curr1 and i_curr2, usually XX_rate2.
         i_seq   - Sequence number of exchange rate usage record
                   Associated with the transaction, usually
                   XX_exru_seq.

       OUTPUT PARAMETERS
         o_disp_line1 - Formatted output string showing the first (or
                        Only) step in the path used to obtain the
                        Working exchange rate of the transaction.
         o_disp_line2 - Formatted output string showing the second
                        Step (if any) in the path used to obtain the
History:
------------------------------------------------------------------------------*/
   define input  parameter i_curr1      as character no-undo.
   define input  parameter i_curr2      as character no-undo.
   define input  parameter i_rate       as decimal   no-undo.
   define input  parameter i_rate2      as decimal   no-undo.
   define input  parameter i_seq        as integer   no-undo.
   define output parameter o_disp_line1 as character no-undo initial "".
   define output parameter o_disp_line2 as character no-undo initial "".

   define variable v_disp_line as character extent {&pp_max} no-undo.
   define variable v_cnt       as integer                    no-undo.

   define buffer b_exru_usage for exru_usage.

   /* Format first output line based on the working exchange rate */
   {us/px/pxrun.i &PROC='ip-build-disp-line'
      &PARAM="(input  i_curr1,
         input  i_curr2,
         input  i_rate,
         input  i_rate2,
         output v_disp_line[1])"}

   /* Step through usage records to build output for each step */
   for each b_exru_usage
      fields
         (exru_seq exru_curr1 exru_curr2 exru_ex_rate exru_ex_rate2)
      no-lock where exru_seq = i_seq
      v_cnt = 1 to {&pp_max}:

      /* Format line based on single step of usage record series */
      {us/px/pxrun.i &PROC='ip-build-disp-line'
         &PARAM="(input  exru_curr1,
          input  exru_curr2,
          input  exru_ex_rate,
          input  exru_ex_rate2,
          output v_disp_line[v_cnt])"}
   end.  /* for each b_exru_usage */

   assign
      o_disp_line1 = v_disp_line[1]
      o_disp_line2 = v_disp_line[2].
END PROCEDURE.

/*============================================================================*/
PROCEDURE ip-build-disp-line:
/*------------------------------------------------------------------------------
Purpose:     To Build Display Line For An Exchange Rate
Exceptions:  NONE
Conditions:
       Pre:   None.
       Post:   None.
Notes: This following procedure should only be called from within other
       MC library routines (procedures internal to mcpl.p or mcui.p).
       There should never be a reason to call them directly from any

       This routine builds a single formatted display line for an
       exchange rate.

       INPUT PARAMETERS:
         i_curr1 - First currency involved in the exchange.
         i_curr2 - Second currency involved in the exchange.
         i_rate  - First component of the exchange rate between
                   i_curr1 and i_curr2.
         i_rate2 - Second component of the exchange rate between
                   i_curr1 and i_curr2.

       OUTPUT PARAMETERS
         o_disp_line - Formatted output string showing the exchange
History:
------------------------------------------------------------------------------*/
   define input  parameter i_curr1     as character no-undo.
   define input  parameter i_curr2     as character no-undo.
   define input  parameter i_rate      as decimal   no-undo.
   define input  parameter i_rate2     as decimal   no-undo.
   define output parameter o_disp_line as character no-undo initial "".

   o_disp_line = i_curr1 + " " + trim(string(i_rate,  ">>>>,>>>,>>9.9<<<<<<<<<"))
                         + " = " + i_curr2 + " "
                         + trim(string(i_rate2, ">>>>,>>>,>>9.9<<<<<<<<<")).

END PROCEDURE.

/*============================================================================*/
PROCEDURE getUsageData:
/*------------------------------------------------------------------------------
Purpose:     To get the exchange rate usage data
Exceptions:  None.
Conditions:
Pre:   None.
Post:   None.
Notes:
History:
------------------------------------------------------------------------------*/
   define input  parameter pSeqNbr      as integer   no-undo.
   define input  parameter pCurr1       as character no-undo.
   define input  parameter pCurr2       as character no-undo.
   define input  parameter pEffdate     as date      no-undo.
   define input  parameter pRate1       as decimal   no-undo.
   define input  parameter pRate2       as decimal   no-undo.
   define output parameter pCurr1Step1  as character no-undo.
   define output parameter pCurr2Step1  as character no-undo.
   define output parameter pRate1Step1  as decimal   no-undo.
   define output parameter pRate2Step1  as decimal   no-undo.
   define output parameter pUnion1      as logical   no-undo.
   define output parameter pCurr1Step2  as character no-undo.
   define output parameter pCurr2Step2  as character no-undo.
   define output parameter pRate1Step2  as decimal   no-undo.
   define output parameter pRate2Step2  as decimal   no-undo.
   define output parameter pUnion2      as logical   no-undo.

   define variable v_curr1  like exr_curr1 extent {&PP_MAX} no-undo.
   define variable v_curr2  like exr_curr1 extent {&PP_MAX} no-undo.
   define variable v_rate1  like exr_rate  extent {&PP_MAX} no-undo.
   define variable v_rate2  like exr_rate2 extent {&PP_MAX} no-undo.
   define variable v_union  as   logical   extent {&PP_MAX} no-undo.
   define variable v_invert as   logical                    no-undo.
   define variable v_steps  as   integer                    no-undo.
   define variable v_cnt    as   integer                    no-undo.

   /* Populate display/update vars from usage records.  Lock */
   /* Usage records to prevent other users from updating.    */
   for each exru_usage where exru_seq = pSeqNbr exclusive-lock
      v_steps = 1 to {&PP_MAX}:
      assign
         v_curr1[v_steps] = exru_curr1
         v_curr2[v_steps] = exru_curr2
         v_rate1[v_steps] = exru_ex_rate
         v_rate2[v_steps] = exru_ex_rate2.
   end.

   assign
      v_invert = v_curr1[1] = pCurr2.
      v_steps  = min({&PP_MAX}, v_steps).

   /* If no usage records found, use working exchange rate */
   if v_steps < 1 then
      assign
         v_steps    = 1
         v_curr1[1] = pCurr1
         v_curr2[1] = pCurr2
         v_rate1[1] = pRate1
         v_rate2[1] = pRate2.

   do v_cnt = 1 to v_steps:
      v_union[v_cnt] = no.
   end.  /* DO v_cnt */

   /*Assign the parameter values*/
   /*Note: Current implementation allows for more that 1 currency to be         */
   /*      in the currency conversion. However, it seems unlikey that this will */
   /*      extend past 2. Curent implemntation really only allows for 2 since   */
   /*      frame definition only allows 2. Thus, it it were needed to extended, */
   /*      more output parameters would be required since arrays cannot be      */
   /*      as parameters in Progress.                                           */
   /*                                                                           */
   do v_cnt = 1 to {&PP_MAX}:
      CASE v_cnt:
         when 1 then do:
            assign
               pCurr1Step1 = v_curr1[v_cnt]
               pCurr2Step1 = v_curr2[v_cnt]
               pRate1Step1 = v_rate1[v_cnt]
               pRate2Step1 = v_rate2[v_cnt]
               pUnion1     = v_union[v_cnt].
         end.
         when 2 then do:
            assign
               pCurr1Step2 = v_curr1[v_cnt]
               pCurr2Step2 = v_curr2[v_cnt]
               pRate1Step2 = v_rate1[v_cnt]
               pRate2Step2 = v_rate2[v_cnt]
               pUnion2     = v_union[v_cnt].
         end.
      END CASE.
   end.
END PROCEDURE.

/*============================================================================*/
PROCEDURE calcNewWorkingRate:
/*------------------------------------------------------------------------------
Purpose:     To Update Usage And Calculate New Working Rate
Exceptions:  NONE
Conditions:
        Pre:   None.
       Post:   None.
Notes:
History:
------------------------------------------------------------------------------*/
   define input  parameter pSequence       as integer no-undo.
   define input  parameter pRate1Step1     as decimal no-undo.
   define input  parameter pRate2Step1     as decimal no-undo.
   define input  parameter pRate1Step2     as decimal no-undo.
   define input  parameter pRate2Step2     as decimal no-undo.
   define input  parameter pInvert         as logical no-undo.
   define output parameter pConvertedRate1 as decimal no-undo.
   define output parameter pConvertedRate2 as decimal no-undo.

   define variable steps    as integer no-undo initial {&PP_MAX}.
   define variable tempRate as decimal no-undo.
   define variable i        as integer no-undo.

   /* Initialize working rate for output */
   assign
      pConvertedRate1 = pRate1Step1
      pConvertedRate2 = pRate2Step1
      i               = 0.

   /*TO DO: Need to validate this. Since exru_ex_rate's are initialized to 1*/
   /*       This should be ok even though the logic would bypass this if    */
   /*       there were 2 steps with both rates being equal to 1.            */
   if pRate1Step2 = 1 and pRate2Step2 = 1 then
      steps = 1.

   /* Update usage records based on entered values, and */
   /* Calculate a new working rate for output based on  */
   /* Each step in the series of usage records          */
   for each exru_usage where exru_seq = pSequence exclusive-lock:
      /* Only update those records which were displayed */
      if i < steps then do:
         i = i + 1.
         CASE i:
            when 1 then
               assign
                  exru_ex_rate  = pRate1Step1
                  exru_ex_rate2 = pRate2Step1.
            when 2 then
               assign
                  exru_ex_rate  = pRate1Step2
                  exru_ex_rate2 = pRate2Step2.
         END CASE.
      end.

      /* Combine multiple steps into single, scaled working rate */
      if i > 1 then do:

         /* Changed proc name below from ip-combine-rates */
         {us/gp/gprunp.i "mcpl" "p" "mc-combine-ex-rates"
                   "(input  pConvertedRate1,
                     input  pConvertedRate2,
                     input  exru_ex_rate,
                     input  exru_ex_rate2,
                     output pConvertedRate1,
                     output pConvertedRate2)"}
      end.
   end.

   /* Make sure the order of the components of the working */
   /* Exchange rate match the order of the currencies      */
   if pInvert then
      assign
         tempRate        = pConvertedRate1
         pConvertedRate1 = pConvertedRate2
         pConvertedRate2 = tempRate.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateEnteredRates:
/*------------------------------------------------------------------------------
Purpose:     To Validate Rates Entered are not 0
Exceptions:  APP-ERROR-RESULT
Conditions:
        Pre:   None.
       Post:   None.
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pRate1 as decimal no-undo.
   define input parameter pRate2 as decimal no-undo.
   define input parameter pUnion as logical no-undo.

   if not pUnion and (pRate1 = 0 or pRate2 = 0) then do:
      /* MESSAGE #317 - ZERO NOT ALLOWED */
      {us/bbi/pxmsg.i &MSGNUM=317 &ERRORLEVEL={&APP-ERROR-RESULT}}
      return error {&APP-ERROR-RESULT}.
   end.

END PROCEDURE.
