/* xxbkrp.p - book report                                                     */
/*V8:ConvertMode=FullGUIReport                                                */

/* DISPLAY TITLE */
{mfdtitle.i "120115.1"}
{xxbkmg.i}
/* CONSIGNMENT INVENTORY VARIABLES */
{pocnvars.i}

define variable v_book like xxbk_id.
define variable v_book1 like xxbk_id.
define variable v_bktype as character format "x(20)".
define variable v_bkstat as character format "x(10)".
define variable v_lendcnt as integer.
define variable v_days as integer.
define variable v_avail like mfc_logical.
define variable v_start as date.
define variable v_start1 as date.
/* define variable v_bc like xxbc_id. */
define variable v_bcname like xxbc_name.
/* define variable v_blstart as date.           */
/* define variable v_end like xxbl_end.         */
define variable v_latecnt as integer.
define variable v_onhand  as integer.
define variable v_onlate  as integer.
/* define variable v_days as integer. */
define variable v_maxlate as integer.
define variable v_late like mfc_logical.
define variable report_detail like mfc_logical initial yes.
form
   v_book   colon 12
   v_book1  colon 40 label {t001.i}
   v_start  colon 12
   v_start1 colon 40  label {t001.i} skip(2)
   report_detail colon 30 skip
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


{wbrp01.i}
repeat:

   if v_book1 = hi_char then v_book1 = "".
   if v_start = low_date then v_start = ?.
   if v_start1 = hi_date then v_start1 = ?.
   if c-application-mode <> 'web' then
      update v_book v_book1 v_start v_start1 report_detail with frame a.

   {wbrp06.i &command = update
             &fields = " v_book v_book1 v_start v_start1 report_detail" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      if v_book1 = "" then v_book1 = hi_char.
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


   for each xxbk_lst no-lock
      where xxbk_id >= v_book and xxbk_id <= v_book1
   with frame b width 320 no-attr-space:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).
      assign v_bktype = ""
             v_bkstat = ""
             v_days  = 0
             v_avail = no
             v_lendcnt = 0
             v_latecnt = 0
             v_onhand  = 0
             v_onlate = 0
             v_maxlate = 0.
      find first usrw_wkfl no-lock where usrw_key1 = v_key_book01
                      and usrw_key2 = xxbk_type no-error.
      if available usrw_wkfl then do:
         assign v_bktype = usrw_key3
                v_days = usrw_intfld[1].
      end.
      find first usrw_wkfl no-lock where usrw_key1 = v_key_book02
                      and usrw_key2 = xxbk_stat no-error.
      if available usrw_wkfl then do:
         assign v_bkstat = usrw_key3
                v_avail = usrw_logfld[1].
      end.


      for each xxbl_hst no-lock use-index xxbl_bkstart where xxbl_bkid = xxbk_id
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
           if last-of(xxbl_bkid) and v_avail then do:
               if xxbl_ret = ? then v_avail = no.
           end.
      end.       /* xxbl_hst */

      display xxbk_id xxbk_name format "x(40)" xxbk_desc format "x(40)"
              xxbk_type v_bktype v_days
              xxbk_stat v_bkstat v_avail xxbk_price xxbk_reg_date
              v_avail v_lendcnt v_latecnt v_maxlate.

      if report_detail then do:
          for each xxbl_hst no-lock use-index xxbl_bkstart where xxbl_bkid = xxbk_id
               and xxbl_start >= v_start and xxbl_start <= v_start1
           break by xxbl_bkid by xxbl_start descending with frame b :
           assign v_bcname = "" v_late = no.
           if xxbl_ret > xxbl_end or (xxbl_ret = ? and xxbl_end < today) then do:
              assign v_late = yes.
           end.
                find first xxbc_lst no-lock where xxbc_id = xxbl_bcid no-error.
                if available xxbc_lst then do:
                   assign v_bcname = xxbc_name.
                end.
                display xxbl_bcid v_bcname xxbl_start xxbl_end xxbl_ret v_late.
                down 1.
         end.
        end.

      {mfrpchk.i}

   end.

   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
