/* xxrar0101.p - customer ar report reference --- arcsiq.p                   */
/* arcsiq.p - ACCOUNTS RECEIVABLE CUSTOMER INQUIRY                           */
/* revision: 110810.1   created on: 20110810   by: zhang yun                 */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1C04   QAD:eb2sp6    Interface:Character         */
/*-revision end--------------------------------------------------------------*/
{mfdeclre.i}
{gplabel.i}

define variable amt_open        like ar_amt.
define variable open_only       like mfc_logical.
define variable days_open       as integer  format "->>>" no-undo.
define variable base_amt        like ar_amt.
define variable base_applied    like ar_applied.
define variable disp_curr       as character.
define variable base_rate       like exr_rate no-undo.
define variable rpt_rate        like exr_rate no-undo.
define variable et_ar_amt       like ar_amt.
define variable et_base_amt     like ar_amt.
define variable et_base_applied like ar_applied.
define variable rpt_curr        like ar_curr INITIAL "".
define buffer armstr for ar_mstr.
{xxrar0101.i}
{etvar.i &new = "new"}
{etrpvar.i &new = "new"}
{eteuro.i}

define temp-table t_armstr no-undo
   field t_ar_check   like ar_check
   field t_ar_effdate like ar_effdate.

empty temp-table tmp_ar no-error.

for each ar_mstr
      where ar_mstr.ar_domain = global_domain
       and (ar_bill >= cust and ar_bill <= cust1 ) no-lock
    use-index ar_bill
      by ar_bill descending
      by ar_date descending:

   if ar_type = "D"
      and not ar_draft
      then next.

   assign
      base_amt     = ar_amt
      base_applied = ar_applied
      disp_curr    = "".

   if rpt_curr = base_curr
      and base_curr <> ar_curr
   then do:
      assign
         base_amt     = ar_base_amt
         base_applied = ar_base_applied
         disp_curr    = getTermLabel("YES",1).

      if ar_curr <> et_report_curr
         and et_report_curr <> base_curr
      then do:
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input base_curr,
              input et_report_curr,
              input base_rate,
              input rpt_rate,
              input base_amt,
              input true, /* ROUND */
              output et_base_amt,
              output mc-error-number)"}

         if mc-error-number <> 0
         then do:
 /*           {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}   */
         end. /* IF mc-error-number <> 0 */

         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input base_curr,
              input et_report_curr,
              input base_rate,
              input rpt_rate,
              input base_applied,
              input true, /* ROUND */
              output et_base_applied,
              output mc-error-number)"}

         if mc-error-number <> 0
         then do:
 /*           {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}   */
         end. /* IF mc-error-number <> 0 */

      end.  /* IF ar_curr <> et_report_curr ... */
      else
   if et_report_curr = base_curr
         then
      assign
         et_base_amt     = ar_base_amt
         et_base_applied = ar_base_applied.
      else
      assign
         et_base_amt     = ar_amt
         et_base_applied = ar_applied.

   end.  /* IF rpt_curr = base_curr AND base_curr <> ar_curr */

   /*DETERMINE CONVERTED AMOUNT*/

   else
if et_report_curr <> rpt_curr
   then do:
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input rpt_curr,
           input et_report_curr,
           input et_rate1,
           input et_rate2,
           input base_amt,
           input true, /* ROUND */
           output et_base_amt,
           output mc-error-number)"}

      if mc-error-number <> 0
      then do:
 /*        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}   */
      end. /* IF mc-error-number <> 0 */

      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input rpt_curr,
           input et_report_curr,
           input et_rate1,
           input et_rate2,
           input base_applied,
           input true, /* ROUND */
           output et_base_applied,
           output mc-error-number)"}

      if mc-error-number <> 0
      then do:
 /*       {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}   */
      end. /* IF mc-erro-number <> 0 */
   end.  /* IF et_report_curr <> rpt_curr */

   else
   assign
      et_base_amt = base_amt
      et_base_applied = base_applied.

   amt_open = et_base_amt - et_base_applied.

   if not open_only or amt_open <> 0
   then do:
      CREATE tmp_ar.
      ASSIGN ta_cust = ar_cust
             ta_date = ar_date
             ta_sub = ar_sub
             ta_so_nbr = ar_so_nbr
             ta_cc = ar_cc.
/*       display     */
/*          ar_date. */

      if ar_type <> "P"
         then
         ASSIGN ta_nbr = ar_nbr
                ta_type = ar_type
                ta_due_date = ar_due_date.
/*       display                             */
/*          ar_nbr label "Ref" format "X(8)" */
/*          ar_type                          */
/*          ar_due_date.                     */
      else
          ASSIGN ta_cust = ar_bill
                 ta_nbr = ar_check
                 ta_type = ar_type
                 ta_due_date = ?.
/*       display              */
/*          ar_check @ ar_nbr */
/*          ar_type           */
/*          "" @ ar_due_date. */
      ASSIGN
         ta_curr = disp_curr
         ta_amt = et_base_amt
         ta_open = amt_open.
/*       display        */
/*          disp_curr   */
/*          et_base_amt */
/*          amt_open.   */

      if ar_type <> "P"
      then do:

         for each ard_det
               fields( ard_domain ard_nbr ard_ref ard_type)
               where ard_det.ard_domain = global_domain and (ard_ref =
               ar_nbr
               and ((ard_type = "D" and ar_type = "D")
               or ar_type <> "D")
               ) no-lock:

            for first armstr
               fields( ar_domain ar_amt ar_applied ar_base_amt
               ar_base_applied ar_bill ar_check ar_curr
               ar_date ar_draft ar_due_date ar_effdate
               ar_nbr ar_open ar_paid_date ar_type)
               where armstr.ar_domain = global_domain and  armstr.ar_nbr =
               ard_nbr
            no-lock:
            end. /* FOR FIRST armstr */
            if available armstr
            then do:
               create t_armstr.
               assign
                  t_ar_check = if armstr.ar_type = "D"
                  then
                  armstr.ar_nbr
                  else
                  armstr.ar_check
                  t_ar_effdate   = armstr.ar_effdate.

            end. /* IF AVAILABLE armstr */
            else
                ASSIGN ar_nbr = "".
/*                display "" @ armstr.ar_check.  */


         end. /* FOR EACH ard_det */

         for each t_armstr
            no-lock
               break by t_ar_effdate:

            if last(t_ar_effdate)
               then
/*             display                                       */
/*                t_ar_check @ armstr.ar_check with frame b. */
                ASSIGN ta_check = t_ar_check.

         end. /* FOR EACH t_armstr */

         for each t_armstr
            exclusive-lock:
            delete t_armstr.
         end. /* FOR EACH t_armstr */

         days_open = ar_mstr.ar_paid_date - ar_mstr.ar_date.

/*          if days_open <> ?  */
/*             then            */
/*          display            */
/*             days_open.      */
/*          else               */
/*          display            */
/*             "" @ days_open. */

      end. /* IF ar_type <> "P" */
/*    else                       */
/*    .                          */
/*       display                 */
/*          "" @ armstr.ar_check */
/*          "" @ days_open.      */

   end.  /* IF NOT OPEN_ONLY */
end. /* FOR EACH ar_mstr */
