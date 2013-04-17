/* xxrepkrp0.p - REPETITIVE PICKLIST report                                  */
/*V8:ConvertMode=FullGUIReport                                               */
/* REVISION: 0CYH LAST MODIFIED: 05/30/11   BY: zy                           */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/
/*** 测试程序,查看同个料号同个时间点是否合并     *****************************/
{mfdtitle.i "111217.1"}
/* {xxtimestr.i}  */
define variable site   like si_site no-undo.
define variable site1  like si_site no-undo.
define variable line   like ln_line no-undo.
define variable line1  like ln_line no-undo.
define variable issue  as date no-undo initial today.
define variable issue1  as date no-undo initial today.
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
   issue1 label {t001.i} colon 50 skip(2)
with frame a side-labels width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */
{wbrp01.i}
repeat:
    if site1 = hi_char then site1 = "".
    if line1 = hi_char then line1 = "".
    if issue = low_date then issue = ?.
    if issue1 = hi_date then issue1 = ?.

if c-application-mode <> 'web' then
update site site1 line line1 issue issue1
       with frame a.

{wbrp06.i &command = update
          &fields = " site site1 line line1 issue issue1 "
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
   {mfquoter.i issue1}

   line1 = line1 + hi_char.
   site1 = site1 + hi_char.
   if issue = ? then issue = low_date.
   if issue1 = ? then issue1 = hi_date.

end.
        /* SELECT PRINTER  */
  {mfselbpr.i "printer" 200}
  {mfphead.i}
		for each xxwa_det no-lock break by xxwa_rtime by xxwa_part
				with frame xx width 200:
				  setFrameLabels(frame xx:handle).
			display xxwa_par xxwa_part xxwa_qty_req xxwa_qty_pln
						string(xxwa_rtime,"hh:mm:ss") @ xxwa_rtime.
		end.

  /*  REPORT TRAILER  */
   {mfrtrail.i}

end.  /* repeat: */

{wbrp04.i &frame-spec = a}
