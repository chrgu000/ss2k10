/* xxrepkrp0.p - REPETITIVE PICKLIST report                                  */
/*V8:ConvertMode=FullGUIReport                                               */
/* REVISION: 0CYH LAST MODIFIED: 05/30/11   BY: zy                           */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

{mfdtitle.i "110803.1"}
/* {xxtimestr.i}  */
define variable site   like si_site no-undo.
define variable site1  like si_site no-undo.
define variable line   like ln_line no-undo.
define variable line1  like ln_line no-undo.
define variable issue  as date no-undo initial today.
define variable nbr  as character format "x(10)" label "Picklist Number".
define variable nbr1 as character format "x(10)".
define variable cate as character format "x(1)" initial "A".
define variable vMultiple like pt_ord_mult label "Order_Multiple".
define variable vtype    as character label "ABC_ALLOCATE".
define variable pnbr like xxwa_nbr.
/* SELECT FORM */
form
   site   colon 20
   site1  label {t001.i} colon 50 skip
   line   colon 20
   line1  label {t001.i} colon 50 skip
   issue  colon 20
   nbr    colon 20
   nbr1   label {t001.i} colon 50 skip(1)
   cate   colon 20 skip(1)
with frame a side-labels width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   pnbr  colon 20 xxwa_date colon 50
   xxwa_site colon 20 xxwa_line colon 50
   xxwa_rtime colon 20
   xxwa_pstime colon 20 xxwa_petime colon 50
with frame p width 80 no-attr-space side-label.
setFrameLabels(frame p:handle).

form
   xxwa_recid
   xxwa_part
   vMultiple
   xxwa_qty_pln
   vtype
with frame pkdet width 80 no-attr-space down.
setframelabels(frame pkdet:handle).

form
   xxwa_nbr  colon 20 xxwa_date colon 50
   xxwa_site colon 20 xxwa_line colon 50
   xxwa_rtime colon 20
   xxwa_sstime colon 20 xxwa_setime colon 50
with frame s width 80 no-attr-space side-label.
setFrameLabels(frame s:handle).


/* REPORT BLOCK */
{wbrp01.i}
repeat:
    if site1 = hi_char then site1 = "".
    if line1 = hi_char then line1 = "".
    if issue = low_date then issue = ?.

if c-application-mode <> 'web' then
update site site1 line line1 issue nbr nbr1 cate
       with frame a.
if index("APS",cate) = 0 then do:
    {mfmsg.i 4212 3}
    undo,retry.
end.
{wbrp06.i &command = update
          &fields = " site site1 line line1 issue nbr nbr1 cate "
          &frm = "a"}

if (c-application-mode <> 'web') or
(c-application-mode = 'web' and
(c-web-request begins 'data')) then do:

   bcdparm = "".
   {mfquoter.i site}
   {mfquoter.i site1}
   {mfquoter.i line}
   {mfquoter.i line1}
   {mfquoter.i issue}

   line1 = line1 + hi_char.
   site1 = site1 + hi_char.
   if issue = ? then issue = low_date.

end.
        /* SELECT PRINTER  */
  {mfselbpr.i "printer" 80}
  {mfphead.i}
  if cate = "A" or cate = "P" then do:
   for each xxwa_det no-lock where
            xxwa_date = issue  and
            xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
            xxwa_line >= line and (xxwa_line <= line1 or line1 = "")
        break by xxwa_date by xxwa_site by xxwa_line by xxwa_nbr by xxwa_recid:
       find first pt_mstr no-lock where pt_mstr.pt_part = xxwa_part no-error.
       if available pt_mstr then do:
          assign vMultiple = pt_ord_mult
                 vtype = pt__chr10.
       end.
       else do:
          assign vMultiple = 0
                 vtype = "".
       end.
       if first-of(xxwa_nbr) then do:
          display "p" + xxwa_nbr @  pnbr xxwa_date
               xxwa_site xxwa_line
               string(xxwa_rtime,"hh:mm:ss") @ xxwa_rtime
               string(xxwa_pstime,"hh:mm:ss") @ xxwa_pstime
               string(xxwa_petime,"hh:mm:ss") @ xxwa_petime
                with frame p width 80 side-label
                .
       end.
       display xxwa_recid xxwa_part xxwa_qty_pln
               vMultiple when vtype = "C"
               vtype with frame pkdet down.
       down 1 with frame pkdet.
       for each xxwd_det no-lock where xxwd_nbr = xxwa_nbr
            and xxwd_recid = xxwa_recid:
            display xxwd_qty_plan @ xxwa_qty_pln
                    xxwd_loc @ vMultiple
                    xxwd_lot @ xxwa_part with frame pkdet down.
            down 1 with frame pkdet.
       end.
    end.
  end.
  if cate = "A" or cate = "S" then do:
   for each xxwa_det no-lock where
            xxwa_date = issue  and
            xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
            xxwa_line >= line and (xxwa_line <= line1 or line1 = "")
        break by xxwa_date by xxwa_site by xxwa_line by xxwa_nbr by xxwa_recid:
        assign vMultiple = 0
                 vtype = "".
       find first pt_mstr no-lock where pt_mstr.pt_part = xxwa_part no-error.
       if available pt_mstr then do:
          assign vMultiple = pt_ord_mult
                 vtype = pt__chr10.
       end.  
       if first-of(xxwa_nbr) then do:
          display "s" + xxwa_nbr @  xxwa_nbr xxwa_date
               xxwa_site xxwa_line
               string(xxwa_rtime,"hh:mm:ss") @ xxwa_rtime
               string(xxwa_sstime,"hh:mm:ss") @ xxwa_sstime
               string(xxwa_setime,"hh:mm:ss") @ xxwa_setime
                with frame s width 80 side-label.
       end.
       display xxwa_recid xxwa_part xxwa_qty_pln
               vMultiple when vtype = "C"
               vtype with frame pkdet down.
       down 1 with frame pkdet.
       for each xxwd_det no-lock where xxwd_nbr = xxwa_nbr
            and xxwd_recid = xxwa_recid:
            display xxwd_qty_plan @ xxwa_qty_pln
                    xxwd_loc @ vMultiple
                    xxwd_lot @ xxwa_part with frame pkdet down.
            down 1 with frame pkdet.
       end.
    end.
  end.
  /*  REPORT TRAILER  */
   {mfrtrail.i}

end.  /* repeat: */

{wbrp04.i &frame-spec = a}
