/* xxbkrp.p - book report                                                     */
/*V8:ConvertMode=FullGUIReport                                                */

/* DISPLAY TITLE */
{mfdtitle.i "120115.1"}
{xxbkmg.i}
/* CONSIGNMENT INVENTORY VARIABLES */
{pocnvars.i}

define variable v_bc like xxbc_id.
define variable v_bc1 like xxbc_id.
define variable v_lendcnt as integer.
define variable v_latecnt as integer.
define variable v_onhand  as integer.
define variable v_onlate  as integer.
define variable v_days as integer.
define variable v_maxlate as integer.
define variable v_avail like mfc_logical.
define variable v_start as date.
define variable v_start1 as date.
define variable v_bctype as character format "x(10)".
define variable v_bcstat as character format "x(10)".
define variable v_bk like xxbk_id.
define variable v_bkname like xxbk_name.
define variable report_detail like mfc_logical initial yes.
define variable v_late like mfc_logical.
form
   v_bc   colon 12
   v_bc1  colon 40 label {t001.i}
   v_start  colon 12
   v_start1 colon 40  label {t001.i} skip (2)
   report_detail colon 30 skip
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

   if v_bc1 = hi_char then v_bc1 = "".
   if v_start = low_date then v_start = ?.
   if v_start1 = hi_date then v_start1 = ?.
   if c-application-mode <> 'web' then
      update v_bc v_bc1 v_start v_start1 report_detail with frame a.

   {wbrp06.i &command = update
             &fields = " v_bc v_bc1 v_start v_start1 report_detail " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      if v_bc1 = "" then v_bc1 = hi_char.
      if v_start = ? then v_start = low_date.
      if v_start1 = ? then v_start1 = hi_date.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 320
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


   for each xxbc_lst no-lock
      where xxbc_id >= v_bc and xxbc_id <= v_bc1
   with frame b width 320 no-attr-space:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).
      assign v_bctype = ""
             v_bcstat = ""
             v_lendcnt = 0
             v_latecnt = 0
             v_onhand  = 0
             v_onlate = 0
             v_maxlate = 0
             .
      find first usrw_wkfl no-lock where usrw_key1 = v_key_book03
                      and usrw_key2 = xxbc_type no-error.
      if available usrw_wkfl then do:
         assign v_bctype = usrw_key3.
      end.
      find first usrw_wkfl no-lock where usrw_key1 = v_key_book04
                      and usrw_key2 = xxbc_stat no-error.
      if available usrw_wkfl then do:
         assign v_bcstat = usrw_key3
                v_avail = usrw_logfld[1].
      end.
      for each xxbl_hst no-lock use-index xxbl_bcstart where xxbl_bcid = xxbc_id
           and xxbl_start >= v_start and xxbl_start <= v_start1
           break by xxbl_bkid by xxbl_start:
           assign v_lendcnt = v_lendcnt + 1.
           if xxbl_ret = ? then assign v_onhand = v_onhand + 1.
           if xxbl_ret > xxbl_end or (xxbl_ret = ? and xxbl_end < today) then do:
              assign v_latecnt = v_latecnt + 1.
              if xxbl_ret = ? then do:
                 if v_maxlate < today - xxbl_end then do:
                    assign v_maxlate = today - xxbl_end.
                    end.
              end.
              else do:
                 if v_maxlate < xxbl_ret - xxbl_end then do:
                    assign v_maxlate = xxbl_ret - xxbl_end.
                 end.
              end.
           end.
           if xxbl_ret = ? and xxbl_end < today then do:
              assign v_onlate = v_onlate + 1.
           end.
      end.       /* xxbl_hst */
      display xxbc_id xxbc_name xxbc_type v_bctype xxbc_amt xxbc_stat v_bcstat
              v_avail v_lendcnt v_latecnt v_onhand v_onlate v_maxlate.
         if report_detail then do:
          for each xxbl_hst no-lock use-index xxbl_bcstart where xxbl_bcid = xxbc_id
               and xxbl_start >= v_start and xxbl_start <= v_start1
           break by xxbl_bcid by xxbl_start descending with frame b :
           assign v_bkname = "" v_late = no.
           if xxbl_ret > xxbl_end or (xxbl_ret = ? and xxbl_end < today) then do:
              assign v_late = yes.
           end.
                find first xxbk_lst no-lock where xxbk_id = xxbl_bkid no-error.
                if available xxbk_lst then do:
                   assign v_bkname = xxbk_name.
                end.
                display xxbl_bkid v_bkname xxbl_start xxbl_end xxbl_ret v_late.
                down 1.
         end.
        end.
      {mfrpchk.i}
   end.

   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
