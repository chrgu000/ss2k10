
/* xxrepkrp0.p - REPETITIVE PICKLIST report                                  */
/*V8:ConvertMode=FullGUIReport                                               */
/* REVISION: 0CYH LAST MODIFIED: 05/30/11   BY: zy                           */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

/*注:产生取料单,配送单的excle宏文件在..\..\showa\xxicstrp\xxicstrp.xla       */

{mfdtitle.i "120327.1"}

/* {xxtimestr.i}  */
define variable site   like si_site no-undo.
define variable site1  like si_site no-undo.
define variable line   like ln_line no-undo.
define variable line1  like ln_line no-undo.
define variable part   like pt_part no-undo. /* initial "MHTA03-N60-0-CK". */
define variable part1  like pt_part no-undo. /* initial "MHTA03-N60-0-CK". */
define variable issue   as date no-undo initial today.
define variable issue1  as date no-undo initial today.
define variable nbr  as character format "x(12)" label "Picklist Number".
define variable nbr1 as character format "x(12)".
define variable cate as character format "x(1)" initial "A".
define variable vMultiple like pt_ord_mult label "Order_Multiple".
define variable vtype  as character format "x(2)" label "ABC_ALLOCATE".
define variable vdesc1 like pt_desc1.
define variable pnbr like xxwa_nbr.
define variable vqty  as decimal no-undo.
define variable tax_bonded as logical no-undo.
define variable del-yn   as logical no-undo.
define variable startTime as integer no-undo.
define variable endTime as integer no-undo.
find first usrw_wkfl no-lock where usrw_key1 = "xxrepkup0.p.param.ref" and
           usrw_key2 = global_userid no-error.
if available usrw_wkfl then do:
assign issue = usrw_datefld[1]
       issue1 = usrw_datefld[1].
end.

/* SELECT FORM */
form
   site   colon 20
   site1  label {t001.i} colon 50 skip
   line   colon 20
   line1  label {t001.i} colon 50 skip
   part   colon 20
   part1  label {t001.i} colon 50 skip
   issue  colon 20
   issue1  label {t001.i} colon 50 skip
   nbr    colon 20
   nbr1   label {t001.i} colon 50 skip(1)
   cate   colon 20 skip
   tax_bonded  colon 20 skip(1)
   del-yn    colon 20 skip(2)

with frame a side-labels width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */
{wbrp01.i}
repeat:
    if site1 = hi_char then site1 = "".
    if line1 = hi_char then line1 = "".
    if nbr1 = hi_char then nbr1 = "".
    if part1 = hi_char then part1 = "".
    if issue = low_date then issue = ?.
    if issue1 = hi_date then issue1 = ?.

if c-application-mode <> 'web' then
update site site1 line line1 part part1 issue issue1 nbr nbr1
       cate tax_bonded del-yn
       with frame a.
if index("APS",cate) = 0 then do:
    {mfmsg.i 4212 3}
    undo,retry.
end.
{wbrp06.i &command = update
          &fields = " site site1 line line1 part part1 issue issue1
                      nbr nbr1 cate tax_bonded del-yn"
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
   {mfquoter.i nbr}
   {mfquoter.i nbr1}
   {mfquoter.i issue}
   {mfquoter.i issue1}

   site1 = site1 + hi_char.
   line1 = line1 + hi_char.
   part1 = part1 + hi_char.
   nbr1 = nbr1 + hi_char.
   if issue = ? then issue = low_date.
   if issue1 = ? then issue1 = hi_date.

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
         "xxrepkrp0.p" "" "" ""
         getTermLabel("P_I_C_K_U_P_S_E_N_D_P_R_I_N_T",30).
  export delimiter "~011"
         getTermLabel("Type",12)
         getTermLabel("NUMBER",12)
         getTermLabel("PRODUCTION_LINE",12)
         getTermLabel("PRODUCTION_HOURS",12)
         getTermLabel("START",12)
         getTermLabel("END",12)
         getTermLabel("Serial",12)
         getTermLabel("PICKLIST_NUMBER",12)
         getTermLabel("ITEM_NUMBER",12)
         getTermLabel("DESCRIPTION",12)
         getTermLabel("PLAN_CUM_QTY",12)
         getTermLabel("Order_Multiple",12)
         getTermLabel("ABC_CLASS",12)
         getTermLabel("QTY_PLANNED",12)
         getTermLabel("LOCATION",12)
         getTermLabel("LOT/SERIAL",12)
         getTermLabel("ISSUED",12)
         getTermLabel("STATUS",12)
         getTermLabel("Date",12)
         .

 for each xxwd_det no-lock where
          xxwd_site >= site and xxwd_site <= site1 and
          xxwd_line >= line and xxwd_line <= line1 and
          xxwd_part >= part and xxwd_part <= part1 and
          xxwd_date >= issue and xxwd_date <= issue1 and
          xxwd_nbr >= nbr and xxwd_nbr <= nbr1 and
          ((substring(xxwd_part,1,1) = "P" and tax_bonded) or
           (tax_bonded = no and substring(xxwd_part,1,1)<> "P")) and
          (xxwd_type = cate or cate = "A")

          break by xxwd_type by xxwd_date by xxwd_time by xxwd_part:
       find first pt_mstr no-lock where pt_mstr.pt_part = xxwd_part no-error.
       if available pt_mstr then do:
          assign vMultiple = pt__qad19
                 vtype = pt__chr10
                 vdesc1 = pt_desc1.
       end.
       else do:
          assign vMultiple = 0
                 vtype = ""
                 vdesc1 = "".
       end.
       if first-of(xxwd_time) then do:
       run getSEtime(input xxwd_type,
       							 input xxwd_site,
       							 input xxwd_line,
       							 input xxwd_time,
       							 output startTime,
       							 output endTime).
       end.
     export delimiter "~011"
            xxwd_type
            lower(xxwd_type) + xxwd_nbr
            xxwd_line
            string(xxwd_time,"hh:mm:ss")
            string(startTime,"hh:mm:ss")
            string(endTime,"hh:mm:ss")
            xxwd_sn
            substring(xxwd_ladnbr,9)
            xxwd_part
            vdesc1
            truncate(xxwd_qty_plan,0)
            vMultiple
            vtype
            truncate(xxwd_qty_plan,0)
            if xxwd_type = "s" then "P-ALL" else xxwd_loc
            xxwd_lot
            if xxwd_type = "s" then xxwd_qty_siss else xxwd_qty_piss
            if xxwd_type = "s" then xxwd_sstat else xxwd_pstat
            xxwd_date.
end.

end.

 {mfreset.i}
end.  /* repeat: */

{wbrp04.i &frame-spec = a}

procedure getSEtime:
    define input parameter iType as character.
    define input parameter iSite as character.
    define input parameter iLine as character.
    define input parameter iRuntime as integer.
    define output parameter ostime as integer.
    define output parameter oetime as integer.
    find first xxlnw_det no-lock where xxlnw_site = isite and
              (xxlnw_line = iLine or iLine = "") and
               xxlnw_ptime = iRunTime no-error.
    if available xxlnw_det then do:
       if iType = "p" then do:
          assign ostime = xxlnw_pstime
                 oetime = xxlnw_petime.
       end.
       else do:
          assign ostime = xxlnw_sstime
                 oetime = xxlnw_setime.
       end.
    end.
end procedure.

/******************************************************************************
procedure printP:
   for each xxwa_det no-lock where
             xxwa_date >= issue and (xxwa_date <= issue1 or issue1 = ?) and
             xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
             xxwa_line >= line and (xxwa_line <= line1 or line1 = "") and
             xxwa_part >= part and (xxwa_part <= part1 or part1 = "") and
             xxwa_nbr >= nbr and (xxwa_nbr <= nbr1 or nbr1 = "") and
           ((tax_bonded = no and substring(xxwa_part,1,1)<> "P") or
            (tax_bonded and substring(xxwa_part,1,1)= "P")),
         each xxwd_det no-lock where xxwd_nbr = xxwa_nbr
          and xxwd_recid = xxwa_recid and xxwd_loc <> "P-ALL"
        break by xxwd_nbr by xxwd_sn:
       find first pt_mstr no-lock where pt_mstr.pt_part = xxwa_part no-error.
       if available pt_mstr then do:
          assign vMultiple = pt__qad19
                 vtype = pt__chr10
                 vdesc1 = pt_desc1.
       end.
       else do:
          assign vMultiple = 0
                 vtype = ""
                 vdesc1 = "".
       end.
              if (vtype = "A" or vtype = "C")
                        then assign vqty = xxwd_qty_plan.
                        else assign vqty = xxwa_qty_need.
              if vqty > 0 then do:
                 export delimiter "~011"
                        "P"
                        "p" + xxwa_nbr
                        xxwd_line
                        string(xxwa_rtime,"hh:mm:ss")
                        string(xxwa_pstime,"hh:mm:ss")
                        string(xxwa_petime,"hh:mm:ss")
                        xxwd_sn
                        substring(xxwd_ladnbr,9)
                        xxwa_part
                        vdesc1
                        truncate(xxwa_qty_need,0)
                        vMultiple
                        vtype
                        max(truncate(vqty,0),0)
                        xxwd_loc
                        xxwd_lot
                        truncate(xxwd_qty_piss,0)
                        xxwd_pstat
                        xxwa_date.
             end.
       end.
end procedure.


procedure printS:
 for each xxwa_det no-lock where
              xxwa_date >= issue and (xxwa_date <= issue1 or issue1 = ?) and
              xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
              xxwa_line >= line and (xxwa_line <= line1 or line1 = "") and
              xxwa_part >= part and (xxwa_part <= part1 or part1 = "") and
              xxwa_nbr >= nbr and (xxwa_nbr <= nbr1 or nbr1 = "")and
            ((tax_bonded = no and substring(xxwa_part,1,1)<> "P") or
             (tax_bonded and substring(xxwa_part,1,1)= "P")),
         each xxwd_det no-lock where xxwd_nbr = xxwa_nbr
          and xxwd_recid = xxwa_recid break by xxwd_nbr by xxwd_sn:
       find first pt_mstr no-lock where pt_mstr.pt_part = xxwa_part no-error.
       if available pt_mstr then do:
          assign vMultiple = pt__qad19
                 vtype = pt__chr10
                 vdesc1 = pt_desc1.
       end.
       else do:
          assign vMultiple = 0
                 vtype = ""
                 vdesc1 = "".
       end.
       if (vtype = "A" or vtype = "C")
                      then assign vqty = xxwd_qty_plan.
                      else assign vqty = xxwa_qty_need.
       if vqty > 0 then do:
           export delimiter "~011"
                  "S"
                  "s" + xxwa_nbr
                  xxwd_line
                  string(xxwa_rtime,"hh:mm:ss")
                  string(xxwa_sstime,"hh:mm:ss")
                  string(xxwa_setime,"hh:mm:ss")
                  xxwd_sn
                  substring(xxwd_ladnbr,9)
                  xxwa_part
                  vdesc1
                  truncate(xxwa_qty_need,0)
                  vMultiple
                  vtype
                  truncate(vqty,0)
                  "P-ALL"
                  xxwd_lot
                  truncate(xxwd_qty_siss,0)
                  xxwd_sstat
                  xxwa_date.
        end.
     end.
end procedure.
******************************************************************************/