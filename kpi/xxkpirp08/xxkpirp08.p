/* xxkpirp06.p - 物料采购执行绩效审核评估表                                  */
/* xxc.p - compile procedure                                                 */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION: 0BYJ LAST MODIFIED: 11/19/10   BY: zy                           */
/* REVISION: 0CYH LAST MODIFIED: 12/17/10   BY: zy language be lower case    */
/* REVISION: 0CYT LAST MODIFIED: 12/29/10   BY: zy def os def field rec path */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */

{mfdtitle.i "101221.1"}
{xxkpirp.i}
define variable prod   like pt_prod_line.
define variable prod1  like pt_prod_line.
define variable nbr  like so_nbr.
define variable nbr1 like so_nbr.
define variable per    as   character format "x(6)".
define variable per1   as   character format "x(6)".
define variable summary  like mfc_logical format "1)ProdLine/2)Summary".
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

define temp-table tmpkpi06
       fields k06_prod like pt_prod_line
       fields k06_issall as integer extent 24
       fields k06_issed  as integer extent 24
       fields k06_conf   as integer extent 24
       fields k06_issrt  as decimal extent 24 format "->,>>9.9<"
       fields k06_effrt  as decimal extent 24 format "->,>>9.9<"
       fields k06_avgrt  as decimal extent 24 format "->,>>9.9<"
       index k06_prod is primary k06_prod.

define variable v_issall as integer extent 24.
define variable v_issed  as integer extent 24.
define variable v_conf   as integer extent 24.
define variable v_issrt  as decimal extent 24 format "->,>>9.9<".
define variable v_effrt  as decimal extent 24 format "->,>>9.9<".
define variable v_avgrt  as decimal extent 24 format "->,>>9.9<".
/* SELECT FORM */
form
   prod    colon 19
   prod1   label "To" colon 49 skip
   nbr     colon 19
   nbr1    label "To" colon 49 skip
   per     colon 19
   per1    label "To" colon 49 skip(1)
   summary colon 32
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */
{wbrp01.i}

repeat:
   if prod1  = hi_char then prod1  = "".
   if nbr1 = hi_char then nbr1 = "".

    do on error undo,retry:
      if c-application-mode <> 'web' then
      update prod prod1 nbr nbr1 per per1 summary with frame a.
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
             &fields = "prod prod1 nbr nbr1 per per1 summary" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i prod   }
      {mfquoter.i prod1  }
      {mfquoter.i nbr  }
      {mfquoter.i nbr1 }
      {mfquoter.i per    }
      {mfquoter.i per1   }
      {mfquoter.i summary}
      if prod1  = "" then prod1 = hi_char.
      if nbr1 = "" then nbr1 = hi_char.
   end.
display prod prod1 nbr nbr1 per per1 summary with frame a.
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


empty temp-table tmpkpi06 no-error.
do i = 1 to maxi:
   assign datef = get1stdayofmonth(v_period[i]).
   for each tr_hist no-lock use-index tr_type where tr_domain = global_domain
        and tr_type = "RCT-WO" and tr_effdate >= datef
        and tr_effdate <= v_datet[i]
        and tr_nbr >= nbr and tr_nbr <= nbr1,
       each pt_mstr no-lock where pt_domain = global_domain
        and pt_part = tr_part
        and pt_prod_line >= prod and pt_prod_line <= prod1
        break by pt_prod_line by tr_nbr by tr_line:
       if first-of(pt_prod_line) then do:
          assign qtyissed = 0.
       end.

       assign qtyissed = qtyissed + tr_qty_loc.
       if last-of(tr_line) then do:
          assign v_conf[i] = v_conf[i] + 1.
          if tr_qty_req = abs(qtyissed) then do:
             assign v_issall[i] = v_issall[i] + 1.
          end.
          find first wo_mstr no-lock where wo_domain = global_domain and
                     wo_lot = tr_lot no-error.
          if available wo_mstr then do:
             if tr_effdate <= wo_due_date then do:
                assign v_issed[i] = v_issed[i] + 1.
             end.
          end.
          else do:
               assign v_issed[i] = v_issed[i] + 1.
          end.
       end.
       if last-of(pt_prod_line) then do:
          find first tmpkpi06 exclusive-lock where k06_prod = pt_prod_line no-error.
          if not available tmpkpi06 then do:
             create tmpkpi06.
             assign k06_prod = pt_prod_line
                    k06_issall[i] = v_issall[i]
                    k06_issed[i] = v_issed[i]
                    k06_conf[i] = v_conf[i].
          end.
       end.
   end. /*for each tr_hist*/
   for each wo_mstr no-lock where wo_domain = global_domain
        and wo_due_date >= datef and wo_due_date <= v_datet[i]
        and wo_qty_comp = 0:
        assign v_conf[i] = v_conf[i] + 1.
   end.
end.
for each tmpkpi06 exclusive-lock:
    do i = 1 to maxi:
       assign k06_issrt[i] = k06_issall[i] / k06_conf[i] when k06_conf[i] <> 0.
       assign k06_effrt[i] = k06_issed[i]  / k06_conf[i] when k06_conf[i] <> 0.
       assign k06_avgrt[i] = (k06_issrt[i] + k06_effrt[i]) / 2.
    end.
end.


{mfphead.i}

if summary then do:
   put unformat getTermLabel("PRODUCT_LINE",16) format "x(16)" skip.
   put unformat "数量执行率(%)" format "x(16)" skip.
   put unformat "按时执行率(%)" format "x(16)" skip.
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
   for each tmpkpi06 no-lock:
       put k06_prod format "x(12)".
       do i = 1 to maxi:
          put 100 * k06_issrt[i].
       end.
       put unformat skip fill(" ",12).
       do i = 1 to maxi:
          put 100 * k06_effrt[i].
       end.
       put unformat skip fill(" ",12).
       do i = 1 to maxi:
          put 100 * k06_avgrt[i].
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
   for each tmpkpi06 no-lock:
       do i = 1 to maxi:
          assign v_issall[i] = v_issall[i] + k06_issall[i]
                 v_issed[i]  = v_issed[i] + k06_issed[i]
                 v_conf[i]   = v_conf[i] + k06_conf[i].
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
   put unformat skip "按时执行率(%)" format "x(16)".
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
