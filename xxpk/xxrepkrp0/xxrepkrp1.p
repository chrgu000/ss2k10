/* xxrepkrp0.p - REPETITIVE PICKLIST report                                  */
/*V8:ConvertMode=FullGUIReport                                               */
/* REVISION: 0CYH LAST MODIFIED: 05/30/11   BY: zy                           */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

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
define variable part like pt_part no-undo initial "MHTA03-N60-0-CK".
define variable part1 like pt_part no-undo initial "MHTA03-N60-0-CK".
define variable cate as character format "x(1)" initial "A".
define variable vMultiple like pt_ord_mult label "Order_Multiple".
define variable vtype    as character label "ABC_ALLOCATE".
define variable pnbr like xxwa_nbr.
/* SELECT FORM */
assign issue = issue + 1
       issue1 = issue1 + 1.
form
   site   colon 20
   site1  label {t001.i} colon 50 skip
   line   colon 20
   line1  label {t001.i} colon 50 skip
   part  colon 20
   part1 label {t001.i} colon 50
   issue  colon 20
   issue1 label {t001.i} colon 50 skip(2)

with frame a side-labels width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */
{wbrp01.i}
repeat:
    if site1 = hi_char then site1 = "".
    if part1 = hi_char then part1 = "".
    if line1 = hi_char then line1 = "".
    if issue = low_date then issue = ?.
    if issue1 = hi_date then issue1 = ?.

if c-application-mode <> 'web' then
update site site1 line line1 part part1 issue issue1
       with frame a.

{wbrp06.i &command = update
          &fields = " site site1 line line1 part part1 issue issue1 "
          &frm = "a"}

if (c-application-mode <> 'web') or
(c-application-mode = 'web' and
(c-web-request begins 'data')) then do:

   bcdparm = "".
   {mfquoter.i site}
   {mfquoter.i site1}
   {mfquoter.i line}
   {mfquoter.i line1}
   {mfquoter.i part}
   {mfquoter.i part1}
   {mfquoter.i issue}
   {mfquoter.i issue1}

   line1 = line1 + hi_char.
   site1 = site1 + hi_char.
   part1 = part1 + hi_char.
   if issue = ? then issue = low_date.
   if issue1 = ? then issue1 = hi_date.

end.
        /* SELECT PRINTER  */
  {mfselbpr.i "printer" 200}
  {mfphead.i}

  for each qad_wkfl no-lock where qad_key1 = "xxrepkup0.p"
      break by qad_charfld[1] by qad_charfld[2] by qad_datefld[1]
            by qad_intfld[1]
      with frame x width 200:
  setFrameLabels(frame x:handle).
  display  qad_key3 format "x(18)" label "Item"
           qad_datefld[1] label "issue"
           qad_charfld[1] label "site"
           qad_charfld[2] label "line"
           string(qad_intfld[1],"hh:mm:ss") label "Stime"
           string(qad_intfld[2],"hh:mm:ss") label "Etime"
           qad_decfld[1] label "schUM"
           qad_decfld[2] label "qty"
           qad_decfld[3] label "req".
  end.

   for each xxwa_det no-lock where
            xxwa_date = issue and (xxwa_date <= issue1 or issue1 = ?) and
            xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
            xxwa_line >= line and (xxwa_line <= line1 or line1 = "") and
            xxwa_part >= part and (xxwa_part <= part1 or part1 = "")
        break by xxwa_date by xxwa_site by xxwa_line by xxwa_nbr by xxwa_recid
        with frame y width 200:
        setFrameLabels(frame y:handle).
        find first pt_mstr no-lock where pt_part = xxwa_part no-error.
        if available pt_mstr then do:
        display xxwa_date
                xxwa_ladnbr
                xxwa_site
                xxwa_line
                xxwa_part
                pt__chr10
                xxwa_ord_mult
                xxwa_qty_req
                xxwa_qty_pln
                string(xxwa_rtime,"hh:mm:ss") @ xxwa_rtime
                xxwa_qty_loc
                xxwa_qty_need
                xxwa__dec03.
        end.
       {mfrpchk.i}
  end.

  for each lad_det exclusive-lock where lad_dataset = "rps_det"
             and lad_site >= site and (lad_site <= site1 or site1 = "")
             and lad_line >= line and (lad_line <= line1 or line1 = "")
             and lad_part >= part and (lad_part <= part1 or part1 = "")
        AND can-find(first loc_mstr no-lock where loc_site = lad_site
                       and loc_loc = lad_loc and loc_user2 = "Y")
        by lad_lot    with frame y2 width 200:
        setFrameLabels(frame y2:handle).
        display lad_nbr lad_part lad_loc lad_lot lad_ref lad_qty_all lad_qty_pick.
   end.
  /*  REPORT TRAILER  */
   {mfrtrail.i}

end.  /* repeat: */

{wbrp04.i &frame-spec = a}
