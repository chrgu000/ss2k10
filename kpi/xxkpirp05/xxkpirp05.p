/* xxkpirp05.p - 销售订单执行绩效审核评估表                                  */
/* xxc.p - compile procedure                                                 */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION: 0BYJ LAST MODIFIED: 11/19/10   BY: zy                           */
/* REVISION: 0CYH LAST MODIFIED: 12/17/10   BY: zy language be lower case    */
/* REVISION: 0CYT LAST MODIFIED: 12/29/10   BY: zy def os def field rec path */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */

{mfdtitle.i "101221.1"}
{xxkpirp.i}
define variable cust   like cm_addr.
define variable cust1  like cm_addr.
define variable sonbr  like so_nbr.
define variable sonbr1 like so_nbr.
define variable per    as   character format "x(6)".
define variable per1   as   character format "x(6)".
define variable summary  like mfc_logical format "1)Cust/2)Summary".
define variable i        as integer.
define variable maxI     as integer.
define variable datef    as date.
define variable qtyissed like tr_qty_loc.
define variable v_period as character extent 24.
define variable v_datet  as date    extent 24.
/* define variable v_issall as integer extent 24. */
/* define variable v_issed  as integer extent 24. */
/* define variable v_conf   as integer extent 24. */
define variable qtyissrate as decimal.
define variable effissrate as decimal.
define variable avgissrate as decimal.

define temp-table tmpkpi05
       fields k05_addr like tr_addr
       fields k05_issall as integer extent 24
       fields k05_issed  as integer extent 24
       fields k05_conf   as integer extent 24
       fields k05_issrt  as decimal extent 24 format "->,>>9.9<"
       fields k05_effrt  as decimal extent 24 format "->,>>9.9<"
       fields k05_avgrt  as decimal extent 24 format "->,>>9.9<"
       index k05_addr is primary k05_addr.

define variable v_issall as integer extent 24.
define variable v_issed  as integer extent 24.
define variable v_conf   as integer extent 24.
define variable v_issrt  as decimal extent 24 format "->,>>9.9<".
define variable v_effrt  as decimal extent 24 format "->,>>9.9<".
define variable v_avgrt  as decimal extent 24 format "->,>>9.9<".
/* SELECT FORM */
form
   cust    colon 19
   cust1   label "To" colon 49 skip
   sonbr   colon 19
   sonbr1  label "To" colon 49 skip
   per     colon 19
   per1    label "To" colon 49 skip(1)
   summary colon 32
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */
{wbrp01.i}

repeat:
   if cust1  = hi_char then cust1  = "".
   if sonbr1 = hi_char then sonbr1 = "".

    do on error undo,retry:
      if c-application-mode <> 'web' then
      update cust cust1 sonbr sonbr1 per per1 summary with frame a.
/*    if per = "" then do:                                                   */
/*       {mfmsg.i 495 3}                                                     */
/*       next-prompt per with frame a.                                       */
/*       undo,retry.                                                         */
/*    end.                                                                   */
/*    if per1 = "" then assign per1 = getPeriod().                           */
/*    i = chkPeriod(per1).                                                   */
/*    if i <> 0 then do:                                                     */
/*       {mfmsg.i i 3}                                                       */
/*       next-prompt per1 with frame a.                                      */
/*       undo,retry.                                                         */
/*    end.                                                                   */
/*    if per >= per1 then do:                                                */
/*       {mfmsg.i 3927 3}                                                    */
/*       next-prompt per1 with frame a.                                      */
/*       undo,retry.                                                         */
/*    end.                                                                   */
 end.
   {wbrp06.i &command = update
             &fields = "cust cust1 sonbr sonbr1 per per1 summary" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i cust   }
      {mfquoter.i cust1  }
      {mfquoter.i sonbr  }
      {mfquoter.i sonbr1 }
      {mfquoter.i per    }
      {mfquoter.i per1   }
      {mfquoter.i summary}
      if cust1  = "" then cust1 = hi_char.
      if sonbr1 = "" then sonbr1 = hi_char.
   end.
display cust cust1 sonbr sonbr1 per per1 summary with frame a.
do i = 1 to 24:
   if i = 1 then  assign v_period[i] = per.
   if i <> 1 then assign v_period[i] = getNextPeriod(v_period[i - 1]).
   v_datet[i] = getenddayofmonth(v_period[i]).
   assign maxi = i.
   if v_period[i] >= per1 then leave.
end.
   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 440
               &pagedFlag = "nopage"
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


empty temp-table tmpkpi05 no-error.
do i = 1 to maxi:
   assign datef = get1stdayofmonth(v_period[i]).
   for each tr_hist no-lock use-index tr_type where tr_domain = global_domain
        and tr_type = "ISS-SO" and tr_effdate >= datef
        and tr_effdate <= v_datet[i]
        and tr_addr >= cust and tr_addr <= cust1
        and tr_nbr >= sonbr and tr_nbr <= sonbr1
        break by tr_addr by tr_nbr by tr_line:
       if first-of(tr_line) then do:
          assign qtyissed = 0.
       end.

       assign qtyissed = qtyissed + tr_qty_loc.
       if last-of(tr_line) then do:
          assign v_conf[i] = v_conf[i] + 1.
          if tr_qty_req = abs(qtyissed) then do:
             assign v_issall[i] = v_issall[i] + 1.
          end.
          find first sod_det no-lock where sod_domain = global_domain and
                     sod_nbr = tr_nbr and sod_line = tr_line no-error.
          if available sod_det then do:
             if tr_effdate <= sod_due_date then do:
                assign v_issed[i] = v_issed[i] + 1.
             end.
          end.
          else do:
               assign v_issed[i] = v_issed[i] + 1.
          end.
       end.
       if last-of(tr_addr) then do:
          find first tmpkpi05 exclusive-lock where k05_addr = tr_addr no-error.
          if not available tmpkpi05 then do:
             create tmpkpi05.
             assign k05_addr = tr_addr
                    k05_issall[i] = v_issall[i]
                    k05_issed[i] = v_issed[i]
                    k05_conf[i] = v_conf[i].
          end.
       end.
   end. /*for each tr_hist*/
   for each sod_det no-lock where sod_domain = global_domain
        and sod_due_date >= datef and sod_due_date <= v_datet[i]
        and sod_qty_ship = 0:
        assign v_conf[i] = v_conf[i] + 1.
   end.
end.
for each tmpkpi05 exclusive-lock:
    do i = 1 to maxi:
       assign k05_issrt[i] = k05_issall[i] / k05_conf[i] when k05_conf[i] <> 0.
       assign k05_effrt[i] = k05_issed[i]  / k05_conf[i] when k05_conf[i] <> 0.
       assign k05_avgrt[i] = (k05_issrt[i] + k05_effrt[i]) / 2.
    end.
end.


{mfphead.i}

if summary then do:
   put unformat getTermLabel("CUSTOMER",16) format "x(16)" skip.
   put unformat "数量执行率(%)" format "x(16)" skip.
   put unformat "交货期执行率(%)" format "x(16)" skip.
   put unformat "平均执行率(%)" format "x(16)".
end.
else do:
   put unformat getTermLabel("EXTENDED",20) format "x(20)".
end.
put unformat v_period[1].
do i = 2 to maxi:
   put unformat fill(" ",4) v_period[i].
end.
put skip.
if summary then do:
   put unformat fill("-",12 + 10 * maxi) skip.
end.
else do:
   put unformat fill("-",16 + 10 * maxi) skip.
end.
if summary then do:
   for each tmpkpi05 no-lock:
       put k05_addr format "x(12)".
       do i = 1 to maxi:
          put 100 * k05_issrt[i].
       end.
       put unformat skip fill(" ",12).
       do i = 1 to maxi:
          put 100 * k05_effrt[i].
       end.
       put unformat skip fill(" ",12).
       do i = 1 to maxi:
          put 100 * k05_avgrt[i].
       end.
       put skip.
        {mfrpchk.i}
   end.
end. /*if summary*/
else do:
   assign v_issall = 0
          v_issed  = 0
          v_conf   = 0
          v_issrt  = 0
          v_effrt  = 0
          v_avgrt  = 0.
   for each tmpkpi05 no-lock:
       do i = 1 to maxi:
          assign v_issall[i] = v_issall[i] + k05_issall[i]
                 v_issed[i]  = v_issed[i] + k05_issed[i]
                 v_conf[i]   = v_conf[i] + k05_conf[i].
       end.
   end.
   do i = 1 to maxi:
       assign v_issrt[i] = v_issall[i] / v_conf[i] when v_conf[i] <> 0
              v_effrt[i] = v_issed[i]  / v_conf[i] when v_conf[i] <> 0
              v_avgrt[i] = (v_issrt[i] + v_effrt[i]) / 2.
    end.
   put unformat "数量执行率(%)" format "x(16)" .
   do i = 1 to maxi:
      put 100 * v_issrt[i].
   end.
   put unformat skip "交货期执行率(%)" format "x(16)".
   do i = 1 to maxi:
      put 100 * v_effrt[i].
   end.
   put unformat skip "平均执行率(%)" format "x(16)".
   do i = 1 to maxi:
      put 100 * v_avgrt[i].
   end.
   put skip.
    {mfrpchk.i}
end.
{mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
