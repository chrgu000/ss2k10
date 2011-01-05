/* ssardri1rp.p - 借贷通知单对应关系报表                                     */
/*V8:ConvertMode=Report                                                      */
/* REVISION: 0BYJ LAST MODIFIED: 12/30/10   BY: zy                           */
/* Environment: Progress:9.1D   QAD:eb21sp5    Interface:Character           */
/* REVISION END                                                              */

/* DISPLAY TITLE */
{mfdtitle.i "101230.1"}

define variable bill     like ar_bill.
define variable bill1    like ar_bill.
define variable ardate   like ar_date.
define variable ardate1  like ar_date.
define variable effdate  like ar_effdate.
define variable effdate1 like ar_effdate.
define variable batch    like ar_batch.
define variable batch1   like ar_batch.
define buffer ar for ar_mstr.
define temp-table tmpar
    fields tmpar_fbatch like ar_batch
    fields tmpar_fnbr   like ar_nbr
    fields tmpar_tbatch like ar_batch
    fields tmpar_tnbr   like ar_nbr.

form
  skip(.1)
   bill     colon 20
   bill1    colon 45 label "To"
   ardate   colon 20
   ardate1  colon 45 label "To"
   effdate  colon 20
   effdate1 colon 45 label "To"
   batch    colon 20
   batch1   colon 45 label "To" skip(1)
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

   if bill1 = hi_char then bill1 = "".
   if ardate1 = hi_date then ardate1 = ?.
   if effdate1 = hi_date then effdate1 = ?.
   if batch1 = hi_char then batch1 = "".
   if c-application-mode <> 'web' then
      update bill bill1 ardate ardate1 effdate effdate1 batch batch1
      with frame a.

   {wbrp06.i &command = update
             &fields = " bill bill1 ardate ardate1 effdate effdate1
                         batch batch1"
             &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      if bill1 = "" then bill1 = hi_char.
      if ardate1 = ? then ardate1 = hi_date.
      if effdate1 = ? then effdate1 = hi_date.
      if batch1 = "" then batch1 = hi_char.
   end.

   empty temp-table tmpar no-error.
   for each ar_mstr no-lock where ar_domain = global_domain
        and (ar_bill >= bill or bill = "") and ar_bill <= bill1
        and (ar_date >= ardate or ardate = ?) and ar_date <= ardate1
        and (ar_effdate >= effdate or effdate = ?) and ar_effdate <= effdate1
        and index("PAD",ar_type) = 0:
        find first ar where ar.ar_domain = global_domain and ar.ar_bill =
              ar_mstr.ar_bill and ar.ar_date = ar_mstr.ar_date  AND
             (ar.ar_type = "I" OR ar.ar_type = "M") and
              ar_mstr.ar_user2 = ar.ar_nbr no-lock no-error.
        if available ar then do:
             create tmpar.
             assign tmpar_fbatch = ar_mstr.ar_batch
                    tmpar_fnbr   = ar_mstr.ar_nbr
                    tmpar_tbatch = ar.ar_batch
                    tmpar_tnbr   = ar.ar_nbr.
        end.
        else do:
             create tmpar.
             assign tmpar_fbatch = ar_mstr.ar_batch
                    tmpar_fnbr   = ar_mstr.ar_nbr.
        end.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 160
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

   {mfphead.i}

   for each tmpar where (tmpar_fbatch >= batch and tmpar_fbatch <= batch1) or
       (tmpar_tbatch >= batch and tmpar_tbatch <= batch1),
       each ar_mstr no-lock where ar_domain = global_domain and
            ar_nbr = tmpar_fnbr and ar_batch = tmpar_fbatch
        with frame b width 160 no-attr-space:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).
      {mfrpchk.i}
    find first ar where ar.ar_domain = global_domain and ar.ar_bill =
         ar_mstr.ar_bill and ar.ar_date = ar_mstr.ar_date  AND
        (ar.ar_type = "I" OR ar.ar_type = "M") and
         ar_mstr.ar_user2 = ar.ar_nbr no-lock no-error.
    if available ar then do:
       display ar_mstr.ar_batch ar_mstr.ar_nbr ar_mstr.ar_bill ar_mstr.ar_date
            ar_mstr.ar_effdate ar_mstr.ar_entity
            ar_mstr.ar_type ar_mstr.ar_amt ar.ar_batch ar.ar_nbr
            ar.ar_bill ar.ar_date ar.ar_effdate ar.ar_entity
            ar.ar_type ar.ar_amt with frame b.
    end.
    else do:
        display ar_mstr.ar_batch ar_mstr.ar_nbr ar_mstr.ar_bill ar_mstr.ar_date
            ar_mstr.ar_effdate ar_mstr.ar_entity
            ar_mstr.ar_type ar_mstr.ar_amt with frame b.
    end.
   end.
   {mfrtrail.i}
end.
{wbrp04.i &frame-spec = a}
