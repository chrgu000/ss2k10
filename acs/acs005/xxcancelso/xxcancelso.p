/* xxcancelso.p - deleted so report                                          */
/* REVISION: 1.0      LAST MODIFIED: 10/03/10   BY: zy                       */
/*-Revision end--------------------------------------------------------------*/

&SCOPED-DEFINE amt_p_1 "amt".
/* DISPLAY TITLE */
{mfdtitle.i "101003.1"}

define variable nbr      like so_nbr no-undo.
define variable nbr1     like so_nbr no-undo.
define variable cust     like so_cust no-undo.
define variable cust1    like so_cust no-undo.
define variable conf     as logical initial no no-undo.
define variable custname like ad_sort no-undo.
define variable prodline like pt_prod_line no-undo.
define variable candel   as logical no-undo.
define variable msgnbr   as integer no-undo.
define variable adname     like ad_name no-undo.
define variable adctry     like ad_ctry no-undo.
define variable ptprodline like pt_prod_line no-undo.
define variable msgtxt     as character format "x(16)" no-undo.
define variable amt        as decimal
       format "->,>>>,>>>,>>9.9<" label "amt".
define variable amtsel     as decimal
       format "->,>>>,>>>,>>9.9<" label "amtsel".
define variable slspsn     as character format "x(15)" no-undo.

/* SELECT FORM */
form
   nbr   colon 19
   nbr1  colon 49 label "To" skip
   cust  colon 19
   cust1 colon 49 label "To" skip(1)
   conf  colon 19 skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */
{wbrp01.i}

repeat:

   if nbr1 = hi_char then nbr1 = "".
   if cust1 = hi_char then cust1 = "".

   if c-application-mode <> 'web' then
   update nbr nbr1 cust cust1 conf with frame a.

   {wbrp06.i &command = update &fields = " nbr nbr1 cust cust1 conf "
             &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i nbr  }
      {mfquoter.i nbr1 }
      {mfquoter.i cust }
      {mfquoter.i cust1}
      {mfquoter.i conf }

      if nbr1 = "" then nbr1 = hi_char.
      if cust1 = "" then cust1 = hi_char.
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

   {mfphead.i}
/* SET EXTERNAL LABELS */

for each xxso_mstr no-lock where xxso_domain = global_domain
     and xxso_nbr >= nbr and xxso_nbr <= nbr1
     and xxso_cust >= cust and xxso_cust <= cust1
    with frame b width 240 no-attr-space:
         {mfrpchk.i}
          setFrameLabels(frame b:handle).
          assign adname = ""
                 adctry = "".
          find first ad_mstr no-lock where ad_domain = global_domain
                 and ad_addr = xxso_cust and ad_type= "customer" no-error.
          if available ad_mstr then do:
             assign adname = ad_name
                    adctry = ad_ctry.
          end.
        if can-find (first xxsod_det no-lock
             where xxsod_domain = global_domain
            and xxsod_nbr = xxso_nbr) then do:
        for each xxsod_det no-lock where xxsod_domain = global_domain
              and xxsod_nbr = xxso_nbr break by xxsod_nbr by xxsod_line:
            assign ptprodline = "".
            find first pt_mstr no-lock where pt_domain = global_domain
                   and pt_part = xxsod_part no-error.
            if available pt_mstr then do:
               assign ptprodline = pt_prod_line.
            end.
            assign amt    = xxsod_qty_ord * xxsod_price
                   amtsel = xxsod_qty_ord * xxsod_price
                          * xxso_ex_rate2 / xxso_ex_rate.
       assign slspsn = "".
       if xxsod_slspsn[1] <> "" then do:
          assign slspsn= xxsod_slspsn[1].
       end.
       if xxsod_slspsn[2] <> "" then do:
          if slspsn = "" then
             assign slspsn = xxsod_slspsn[2].
          else
             assign slspsn = slspsn + "," + xxsod_slspsn[2].
       end.
       if xxsod_slspsn[3] <> "" then do:
          if slspsn = "" then
             assign slspsn = xxsod_slspsn[3].
          else
             assign slspsn = slspsn + "," + xxsod_slspsn[3].
       end.
       if xxsod_slspsn[4] <> "" then do:
          if slspsn = "" then
             assign slspsn = xxsod_slspsn[4].
          else
             assign slspsn = slspsn + "," + xxsod_slspsn[4].
       end.
       display xxso_nbr
               xxso_ord_date
               adctry
               xxso_cust
               adname
               slspsn
               xxsod_line
               ptprodline
               xxsod_part
               xxsod_qty_ord
               xxso_curr
               xxsod_price
               amt
               amtsel
               with frame b stream-io.
               if not last-of(xxsod_nbr) then
               down 1 with fram b.
     end.
   end. /*can-find (first sod_det no-lock */
   ELSE DO:
       assign slspsn = "".
       if xxso_slspsn[1] <> "" then do:
          assign slspsn= xxso_slspsn[1].
       end.
       if xxso_slspsn[2] <> "" then do:
          if slspsn = "" then
             assign slspsn = xxso_slspsn[2].
          else
             assign slspsn = slspsn + "," + xxso_slspsn[2].
       end.
       if xxso_slspsn[3] <> "" then do:
          if slspsn = "" then
             assign slspsn = xxso_slspsn[3].
          else
             assign slspsn = slspsn + "," + xxso_slspsn[3].
       end.
       if xxso_slspsn[4] <> "" then do:
          if slspsn = "" then
             assign slspsn = xxso_slspsn[4].
          else
             assign slspsn = slspsn + "," + xxso_slspsn[4].
       end.
      display  xxso_nbr
               xxso_ord_date
               adctry
               xxso_cust
               adname
               slspsn
               "" @ xxsod_line
               "" @ ptprodline
               "" @ xxsod_part
               "" @ xxsod_qty_ord
               xxso_curr
               "" @ xxsod_price
               "" @ amt
               "" @ amtsel
               with frame b stream-io.
   END.
  END.
   /* REPORT TRAILER  */
   {mfrtrail.i}
if conf then do:
  for each xxso_mstr exclusive-lock where xxso_domain = global_domain
       and xxso_nbr >= nbr and xxso_nbr <= nbr1
       and xxso_cust >= cust and xxso_cust <= cust1:
       for each xxsod_det exclusive-lock where xxsod_domain = global_domain
            and xxsod_nbr = xxso_nbr:
            delete xxsod_det.
       end.
       delete xxso_mstr.
  end.
end.
end.
{wbrp04.i &frame-spec = a}
