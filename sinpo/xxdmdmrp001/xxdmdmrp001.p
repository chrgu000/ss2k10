/* xxdmdmrp001.p  -  dmdmrp.p - DRAFT MANAGEMENT REPORT                       */
{mfdtitle.i "121204.1"}
{gpacctp.i "new"}
{xxdmdmrp0001.i "NEW"}
define variable nbr               like ar_nbr                      no-undo.
define variable nbr1              like ar_nbr                      no-undo.
define variable bill              like ar_bill                     no-undo.
define variable bill1             like ar_bill                     no-undo.
define variable entity            like ar_entity   format "x(4)"   no-undo.
define variable entity1           like ar_entity   format "x(4)"   no-undo.
define variable batch             like ar_batch  initial ""        no-undo.
define variable batch1            like ar_batch  initial ""        no-undo.
define variable cc                like ar_cc.
define variable cc1               like ar_cc.
define variable ardate            like ar_date                     no-undo.
define variable ardate1           like ar_date                     no-undo.
define variable duedate           like ar_due_date                 no-undo.
define variable duedate1          like ar_due_date                 no-undo.
define variable effdate           like ar_effdate                  no-undo.
define variable effdate1          like ar_effdate                  no-undo.
define variable stat              as character      format "x(8)"
                                  label "Status"                   no-undo.
define variable disp_char1        as character      format "x(69)" no-undo.
define variable l_approved        as character      format "x(10)" no-undo.
define variable l_closed          as character      format "x(10)" no-undo.
define variable l_void            as character      format "x(10)" no-undo.
define variable l_proposed        as character      format "x(10)" no-undo.
define variable l_discount        as character      format "x(10)" no-undo.
define variable base_rpt          like ar_curr                     no-undo.
define variable mc-error-number   like msg_nbr                     no-undo.

form
   nbr                           colon 18
   nbr1           label {t001.i} colon 49 skip
   bill                          colon 18
   bill1          label {t001.i} colon 49 skip
   entity                        colon 18
   entity1        label {t001.i} colon 49 skip
   batch                         colon 18
   batch1         label {t001.i} colon 49 skip
   cc                            colon 18
   cc1            label {t001.i} colon 49 skip
   ardate                        colon 18
   ardate1        label {t001.i} colon 49 skip
   duedate                       colon 18
   duedate1       label {t001.i} colon 49 skip
   effdate                       colon 18
   effdate1       label {t001.i} colon 49 skip
   stat                          colon 18 skip
   disp_char1     no-label       at    10
   base_rpt                      colon 18
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

assign
   l_approved = getTermLabel("APPROVED",10)
   l_closed   = getTermLabel("CLOSED",8)
   l_void     = getTermLabel("VOID",6)
   l_proposed = getTermLabel("PROPOSED",10)
   l_discount = getTermLabel("DISCOUNT",10)
   disp_char1 = l_proposed + ", "  +
                l_approved + ", "  +
                l_discount + ", "  +
                l_closed   + ", "  +
                l_void     + ", (" +
                getTermLabel("BLANK_FOR_ALL",13) + ")".


{wbrp01.i}

repeat:

   if nbr1     = hi_char  then nbr1     = "".
   if bill1    = hi_char  then bill1    = "".
   if entity1  = hi_char  then entity1  = "".
   if batch1   = hi_char  then batch1   = "".
   if cc1      = hi_char  then cc1      = "".
   if ardate   = low_date then ardate   = ?.
   if ardate1  = hi_date  then ardate1  = ?.
   if duedate  = low_date then duedate  = ?.
   if duedate1 = hi_date  then duedate1 = ?.
   if effdate  = low_date then effdate  = ?.
   if effdate1 = hi_date  then effdate1 = ?.

   if c-application-mode <> 'web'
   then
      update
         nbr nbr1 bill bill1 entity entity1 batch batch1 cc cc1
         ardate ardate1 duedate duedate1 effdate effdate1
         stat base_rpt
      with frame a.

   {wbrp06.i &command = update
      &fields = "nbr nbr1 bill bill1 entity entity1
                 batch batch1 cc cc1 ardate ardate1
                 duedate duedate1 effdate effdate1 stat base_rpt"
      &frm    = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      if stat <> ""
      then
         {&DMDMRP-P-TAG2}

      if (stat <> l_approved and
          stat <> l_closed   and
          stat <> l_void     and
          stat <> l_proposed and
          stat <> l_discount)
      then do:
         {&DMDMRP-P-TAG3}
         {pxmsg.i &MSGNUM=19 &ERRORLEVEL=3}  /* INVALID STATUS */
         if c-application-mode = 'web'
         then
            return.
         else
            next-prompt stat with frame a.
         undo, retry.
      end. /* IF stat */

      if base_rpt <> ""
      then do:
         {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
            "(input base_rpt, output mc-error-number)"}
         if mc-error-number <> 0
         then do:
            {pxmsg.i &MSGNUM=3088 &ERRORLEVEL=3}  /* INVALID CURRENCY */
            if c-application-mode = 'web'
            then
               return.
            else
               next-prompt base_rpt with frame a.
            undo, retry.
         end. /* IF mc-error-number */
      end. /* IF base_rpt */

      bcdparm = "".
      {mfquoter.i nbr      }
      {mfquoter.i nbr1     }
      {mfquoter.i bill     }
      {mfquoter.i bill1    }
      {mfquoter.i entity   }
      {mfquoter.i entity1  }
      {mfquoter.i batch    }
      {mfquoter.i batch1   }
      {mfquoter.i cc       }
      {mfquoter.i cc1      }
      {mfquoter.i ardate   }
      {mfquoter.i ardate1  }
      {mfquoter.i duedate  }
      {mfquoter.i duedate1 }
      {mfquoter.i effdate  }
      {mfquoter.i effdate1 }
      {mfquoter.i stat     }
      {mfquoter.i base_rpt }

      if nbr1     = "" then nbr1     = hi_char.
      if bill1    = "" then bill1    = hi_char.
      if entity1  = "" then entity1  = hi_char.
      if batch1   = "" then batch1   = hi_char.
      if cc1      = "" then cc1      = hi_char.
      if ardate   = ?  then ardate   = low_date.
      if ardate1  = ?  then ardate1  = hi_date.
      if duedate  = ?  then duedate  = low_date.
      if duedate1 = ?  then duedate1 = hi_date.
      if effdate  = ?  then effdate  = low_date.
      if effdate1 = ?  then effdate1 = hi_date.
      {&DMDMRP-P-TAG29}
   end.  /* IF (c-application-mode <> 'web') */
   empty temp-table ttssdmdmrp0001_det no-error.
   {gprun.i ""xxdmdmrp0001.p"" "(
      INPUT nbr,
      INPUT nbr1,
      INPUT bill,
      INPUT bill1,
      INPUT entity,
      INPUT entity1,
      INPUT batch,
      INPUT batch1,
      INPUT cc,
      INPUT cc1,
      INPUT ardate,
      INPUT ardate1,
      INPUT duedate,
      INPUT duedate1,
      INPUT effdate,
      INPUT effdate1,
      INPUT stat,
      INPUT base_rpt
      )"}
   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.
   export delimiter ";"
          "ar_entity"
          "ar_bank"
          "ar_batch"
          "ar_bill"
          "name"
          "ar_nbr"
          "ar_acct"
          "ar_sub"
          "ar_cc"
          "ar_date"
          "ar_effdate"
          "ar_curr"
          "disp_curr"
          "base_amt"
          "ex_rate_relation1"
          "statl"
          "ar_due_date"
          "ard_nbr"
          "ard_acct"
          "ard_sub"
          "ard_cc"
          "base_open"
          "base_damt"
          "base_disc"
          "det_curr"
          "base_curr"
          "artotal"
          "ex_rate_relation2".

   export delimiter ";"
          getTermLabel("ENTITY",12)
          getTermLabel("BANK",12)
          getTermLabel("BATCH",12)
          getTermLabel("BILL_TO",12)
          getTermLabel("NAME",12)
          getTermLabel("REFERENCE",12)
          getTermLabel("ACCOUNT",12)
          getTermLabel("SUB-ACCOUNT",12)
          getTermLabel("COST_CENTER",12)
          getTermLabel("DATE",12)
          getTermLabel("EFFECTIVE_DATE",12)
          getTermLabel("CURRENCY",12)
          "C"
          getTermLabel("AMOUNT",12)
          getTermLabel("CURRENCY_EXCHANGE_RATE",12)
          getTermLabel("STATUS",12)
          getTermLabel("DUE_DATE",12)
          getTermLabel("REFERENCE",12)
          getTermLabel("ACCOUNT",12)
          getTermLabel("SUB-ACCOUNT",12)
          getTermLabel("COST_CENTER",12)
          getTermLabel("Open Amount",12)
          getTermLabel("AMOUNT",12)
          getTermLabel("DISCOUNT",12)
          getTermLabel("CURRENCY",12)
          getTermLabel("CURRENCY",12)
          getTermLabel("AMOUNT",12)
          getTermLabel("EXCH_RATE_2",12).

for each ttssdmdmrp0001_det no-lock:
         export delimiter ";" ttssdmdmrp0001_det.
end.
PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

   /* REPORT TRAILER */
   {mfreset.i}
end. /* REPEAT */

{wbrp04.i &frame-spec = a}
