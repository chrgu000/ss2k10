/* ssapmciarp.p - 手写支票对应关系报表                                       */
/*V8:ConvertMode=Report                                                      */
/* REVISION: 0BYJ LAST MODIFIED: 12/30/10   BY: zy                           */
/* Environment: Progress:9.1D   QAD:eb21sp5    Interface:Character           */
/* REVISION END                                                              */

/* DISPLAY TITLE */
{mfdtitle.i "101230.1"}

define variable vend     like ap_vend.
define variable vend1    like ap_vend.
define variable apdate   like ap_date.
define variable apdate1  like ap_date.
define variable effdate  like ap_effdate.
define variable effdate1 like ap_effdate.
define variable batch    like ar_batch.
define variable batch1   like ar_batch.
define variable cknbr    like ck_nbr.
define variable bank     like vd_bank.
define buffer ap for ap_mstr.
define TEMP-TABLE tmpap
    fields tmpap_fbatch like ap_batch
    fields tmpap_fref   like ap_ref
    fields tmpap_user2  as   character
    fields tmpap_tbatch like ap_batch
    fields tmpap_tref   like ap_ref.

form
  skip(.1)
   vend     colon 20
   vend1    colon 45 label "To"
   apdate   colon 20
   apdate1  colon 45 label "To"
   effdate  colon 20
   effdate1 colon 45 label "To"
   batch    colon 20
   batch1   colon 45 label "To" skip(1)
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

   if vend1 = hi_char then vend1 = "".
   if apdate1 = hi_date then apdate1 = ?.
   if effdate1 = hi_date then effdate1 = ?.
   if batch1 = hi_char then batch1 = "".
   if c-application-mode <> 'web' then
      update vend vend1 apdate apdate1 effdate effdate1 batch batch1
      with frame a.

   {wbrp06.i &command = update
             &fields = " vend vend1 apdate apdate1 effdate effdate1
                         batch batch1"
             &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      if vend1 = "" then vend1 = hi_char.
      if apdate1 = ? then apdate1 = hi_date.
      if effdate1 = ? then effdate1 = hi_date.
      if batch1 = "" then batch1 = hi_char.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 170
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

  empty temp-table tmpap no-error.
  for each ap_mstr use-index ap_vend_date no-lock where
           ap_domain = global_domain and ap_type = "CK"
      and ((ap_vend >= vend) and (ap_vend <= vend1)
       and (ap_date >= apdate or apdate = ?) and
           (ap_date <= apdate1 or apdate1 = ?)
       and (ap_effdate >= effdate or effdate = ?) and
           (ap_effdate <= effdate1 or effdate1 = ?)):
     create tmpap.
     assign tmpap_fbatch = ap_mstr.ap_batch
            tmpap_fref   = ap_mstr.ap_ref
            tmpap_user2  = ap_mstr.ap_user2.
     for each ap no-lock
          where ap.ap_domain = global_domain and ap.ap_type = "CK"
          and ap.ap_date = ap_mstr.ap_date and ap.ap_vend = ap_mstr.ap_vend,
          each ck_mstr no-lock where ck_domain = global_domain
           and ck_ref = ap_ref and ck_nbr = integer(ap_mstr.ap_user2):
         assign tmpap_tbatch = ap.ap_batch
                tmpap_tref   = ck_ref.
     end.
  end.

   {mfphead.i}
for each tmpap no-lock where (tmpap_fbatch >= batch and tmpap_fbatch <= batch1)
     or (tmpap_tbatch >= batch and tmpap_tbatch <= batch1)
with frame b width 170 no-attr-space:
     /* SET EXTERNAL LABELS */
     setFrameLabels(frame b:handle).
    {mfrpchk.i}
    find first ap_mstr no-lock where ap_domain = global_domain
           and ap_type = "CK" and ap_ref = tmpap_fref no-error.
    if available ap_mstr then do:
       display ap_mstr.ap_batch ap_mstr.ap_ref ap_mstr.ap_vend
               ap_mstr.ap_date ap_mstr.ap_effdate ap_mstr.ap_entity
               ap_mstr.ap_user2 ap_mstr.ap_amt with frame b.
    end.
    if tmpap_tref <> "" then do:
    find first ap no-lock where ap.ap_domain = global_domain and
               ap.ap_type = "CK" and ap.ap_ref = tmpap_tref no-error.
    if available ap_mstr then do:
       display ap.ap_batch ap.ap_ref ap.ap_vend ap.ap_date ap.ap_effdate
               ap.ap_entity ap.ap_amt with frame b.
    end.
    end.
end.
  {mfrtrail.i}
end.
{wbrp04.i &frame-spec = a}
