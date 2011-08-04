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
define variable vtype    as character format "x(2)" label "ABC_ALLOCATE".
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
{gpselout.i &printtype = "printer"
            &printwidth = 132
            &pagedflag = "nopage"
            &stream = " "
            &appendtofile = " "
            &streamedoutputtoterminal = " "
            &withbatchoption = "yes"
            &displaystatementtype = 1
            &withcancelmessage = "yes"
            &pagebottommargin = 6
            &withemail = "yes"
            &withwinprint = "yes"
            &definevariables = "yes"}
/*     {mfphead.i}    */
mainloop:
do on error undo, return error on endkey undo, return error:
  export delimiter "~011" ""
         "xxrepkrp1.p" "" "" ""
         getTermLabel("P_I_C_K_U_P_S_E_N_D_P_R_I_N_T",30).
  export delimiter "~011"
  			 getTermLabel("Type",12)
         getTermLabel("NUMBER",12)
         getTermLabel("PRODUCTION_LINE",12)
         getTermLabel("PRODUCTION_HOURS",12)
         getTermLabel("START",12)
         getTermLabel("END",12)
         getTermLabel("Serial",12)
         getTermLabel("ITEM_NUMBER",12)
         getTermLabel("PLAN_CUM_QTY",12)
         getTermLabel("Order_Multiple",12)
         getTermLabel("ABC_CLASS",12)
         getTermLabel("QTY_PLANNED",12)
         getTermLabel("LOCATION",12)
         getTermLabel("LOT/SERIAL",12).
  if cate = "A" or cate = "P" then do:
    for each xxwa_det no-lock where
            xxwa_date = issue  and
            xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
            xxwa_line >= line and (xxwa_line <= line1 or line1 = "")
        break by xxwa_date by xxwa_site by xxwa_line by xxwa_nbr by xxwa_recid:
       find first pt_mstr no-lock where pt_mstr.pt_part = xxwa_part no-error.
       if available pt_mstr then do:
          assign vMultiple = if pt__chr10 = "C" Then pt_ord_mult else 0
                 vtype = pt__chr10.
       end.
       else do:
          assign vMultiple = 0
                 vtype = "".
       end.
       for each xxwd_det no-lock where xxwd_nbr = xxwa_nbr
            and xxwd_recid = xxwa_recid:
              export delimiter "~011"
              			 "P"
                     "p" + xxwa_nbr
                     xxwa_line
                     string(xxwa_rtime,"hh:mm:ss")
                     string(xxwa_pstime,"hh:mm:ss")
                     string(xxwa_petime,"hh:mm:ss")
                     xxwa_recid
                     xxwa_part
                     xxwa_qty_pln
                     vMultiple
                     vtype
                     xxwd_qty_plan
                     xxwd_loc
                     xxwd_lot.
       end.
    end.
  end.
  if cate = "A" or cate = "s" then do:
     for each xxwa_det no-lock where
            xxwa_date = issue  and
            xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
            xxwa_line >= line and (xxwa_line <= line1 or line1 = "")
        break by xxwa_date by xxwa_site by xxwa_line by xxwa_nbr by xxwa_recid:
       find first pt_mstr no-lock where pt_mstr.pt_part = xxwa_part no-error.
       if available pt_mstr then do:
          assign vMultiple = if pt__chr10 = "C" Then pt_ord_mult else 0
                 vtype = pt__chr10.
       end.
       else do:
          assign vMultiple = 0
                 vtype = "".
       end.
       for each xxwd_det no-lock where xxwd_nbr = xxwa_nbr
            and xxwd_recid = xxwa_recid:
              export delimiter "~011"
              			 "S"
                     "s" + xxwa_nbr
                     xxwa_line
                     string(xxwa_rtime,"hh:mm:ss")
                     string(xxwa_pstime,"hh:mm:ss")
                     string(xxwa_petime,"hh:mm:ss")
                     xxwa_recid
                     xxwa_part
                     xxwa_qty_pln
                     vMultiple
                     vtype
                     xxwd_qty_plan
                     xxwd_loc
                     xxwd_lot.
       end.
    end.
  end.
  /*  REPORT TRAILER  */
 end.
 {mfreset.i}
end.  /* repeat: */

{wbrp04.i &frame-spec = a}
