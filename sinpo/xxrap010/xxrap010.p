/* xxrap010.p - VENDOR AP REPORT                                             */
/* revision: 110810.1   created on: 20110810   by: zhang yun                 */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1C04   QAD:eb2sp6    Interface:Character         */
/*-revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "120105.1"}
{xxrap010a.i "new"}
define variable site like ld_site.
define variable site1 like ld_site.
define variable vend  like vd_addr.
define variable vend1 like vd_addr.
define variable changeuserid  as character.
define variable changeuserid1 as character.
define variable dates  as date.
define variable dates1 as date initial today.

define variable vvend like vd_addr.
define variable vdsort like vd_sort.
define variable vcost like pod_cost.
define variable vdesc like pt_desc1.
define variable usrname like usr_name.
/* SELECT FORM */
form
   site  colon 19
   site1 label {t001.i} colon 49 skip
   vend  colon 19
   vend1 label {t001.i} colon 49 skip
   changeuserid  colon 19
   changeuserid1 label {t001.i} colon 49 skip
   dates colon 19
   dates1 label {t001.i} colon 49 skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */
{wbrp01.i}

repeat:
   if dates = ? then assign dates = today - day(today) + 1.
   if site1 = hi_char then site1 = "".
   if vend1 = hi_char then vend1 = "".
   if changeuserid1 = hi_char then changeuserid1 = "".
   if dates1 = hi_date then dates1 = ?.


   if c-application-mode <> 'web' then
   update site site1 vend vend1 changeuserid changeuserid1 dates dates1
   with frame a.

   {wbrp06.i &command = update
             &fields = "site site1 vend vend1 changeuserid changeuserid1
                        dates dates1 "
             &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i site}
      {mfquoter.i site1}
      {mfquoter.i vend}
      {mfquoter.i vend1}
      {mfquoter.i changeuserid}
      {mfquoter.i changeuserid1}
      {mfquoter.i dates}
      {mfquoter.i dates1}

      if site1 = "" then site1 = hi_char.
      if vend1 = "" then vend1 = hi_char.
      if changeuserid1 = "" then changeuserid1 = hi_char.
      if dates1 = ? then dates1 = hi_date.
   end.

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
  EMPTY TEMP-TABLE tmpap.

   {gprun.i ""xxrap010a.p"" "(
       INPUT vend,
       INPUT vend1,
       INPUT dates,
       INPUT dates1,
       INPUT 'RMB'
      )"}

put unformat "" "~011" "" "~011" "" "~011" "" "~011" "" "~011" "" "~011"
             getTermLabel("AP_DETAIL",16) skip.
put unformat getTermLabel("SUPPLIER_CODE",12) "~011"
             getTermLabel("SUPPLIER",12) "~011"
             getTermLabel("OPORDER",12) "~011"
             getTermLabel("EFFECTIVE_DATE",12) "~011"
             getTermLabel("BY",12) "~011"
             getTermLabel("ITEM_NUMBER",12) "~011"
             getTermLabel("ITEM_DESCRIPTION",12) "~011"
             getTermLabel("QUANTITY",12) "~011"
             getTermLabel("UNIT_PRICE",12) "~011"
             getTermLabel("RECEIVED_TO_STOCK",12) "~011"
             getTermLabel("BILLED",12) "~011"
             getTermLabel("PAYMENT",12) "~011"
             getTermLabel("PAYMENT_BILL",12) "~011"
             getTermLabel("REMARK",12)
             skip.


for each tr_hist use-index tr_type no-lock where tr_domain = global_domain and
   (tr_type = "RCT-PO" or tr_type = "ISS-PRV") AND
    tr_effdate >= dates AND tr_effdate <= dates1 and
    tr_site >= site and tr_site <= site1:
/*    {mfphead.i} */
    assign vvend = "" vdsort = "" vdesc = "" usrname = "" vcost = 0.
    find first po_mstr where po_domain = global_domain and
               po_nbr = tr_nbr no-lock no-error.
    if availabl po_mstr then do:
       assign vvend = po_vend.
       find first usr_mstr where usr_userid = po_user_id no-lock no-error.
       if availabl usr_mstr then do:
          assign usrname = usr_name.
       end.
    end.
    find first vd_mstr where vd_domain = global_domain and
               vd_addr = vvend no-lock no-error.
    if availabl vd_mstr then do:
       assign vdsort = vd_sort.
    end.
    find first pod_det where pod_domain = global_domain and
               pod_nbr = tr_nbr and pod_part = tr_part no-lock no-error.
    if availabl pod_det then do:
       assign vcost = pod_pur_cost.
    end.
    find first pt_mstr where pt_domain = global_domain and
               pt_part = tr_part no-lock no-error.
    if available pt_mstr then do:
       assign vdesc = pt_desc1.
    end.
export delimiter "~011" vvend vdsort tr_nbr tr_effdate usrname
       tr_part vdesc tr_qty_loc vcost tr_qty_loc * vcost.
/*    {mfrpchk.i} */
end.

FOR EACH tmpap no-lock:
    assign vvend = "" vdsort = "" vdesc = "" usrname = "" vcost = 0.
    find first vd_mstr where vd_domain = global_domain and
               vd_addr = ta_ap_vend no-lock no-error.
    if availabl vd_mstr then do:
       assign vdsort = vd_sort.
    end.
    if ta_ap_type = "C" or ta_ap_type = "V" then do:
       find first code_mstr no-lock where code_domain = global_domain and
                  code_fldname = "vo_type" and code_value = ta_vo_type no-error.
       if availabl code_mstr then do:
          assign usrname = code_cmmt.
       end.
    end.
    if ta_ap_type = "c" then do:
    EXPORT DELIMITER "~011" ta_ap_vend vdsort ta_vo_invoice ta_vo_due_date
                      usrname "" "" "" "" "" "" ta_ap_base_amt "".
    end.
    if ta_ap_type = "v" then do:
    EXPORT DELIMITER "~011" ta_ap_vend vdsort ta_vo_invoice ta_vo_due_date
                      usrname "" "" "" "" "" ta_ap_base_amt "" "" ta_ck_nbr.
    end.
    if ta_ap_type = "d" then do:
    EXPORT DELIMITER "~011" ta_ap_vend vdsort ta_ap_ref ta_ap_effdate
                      "" "" "" "" "" "" "" "" ta_ap_base_amt.
    end.
END.
   /* REPORT TRAILER  */
/*    {mfrtrail.i}  */
{mfreset.i}

end.

{wbrp04.i &frame-spec = a}
