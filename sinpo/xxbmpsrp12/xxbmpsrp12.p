/* xxbmpsrp10.p - bom runtime report                                         */
/* REVISION:101028.1 LAST MODIFIED: 10/28/10 BY: zy                          */
/* REVISION:110217.1 LAST MODIFIED: 02/17/11 BY: zy                      *2h**/
/*-Revision end--------------------------------------------------------------*/
/* Environment: Progress:10.1C04   QAD:eb21sp6                               */
/*V8:ConvertMode=Report                                                      */
/**2h
目的:将工时数据明细分别写到对应的工作中心上
说明:增加了临时表tempb用于记录工作中心的数据.
                                                                             */

{mfdtitle.i "110217.1"}
define variable i as integer.
define variable vmax as integer.
define VARIABLE vpar     LIKE pt_part initial "".
define VARIABLE vscrppct as DECIMAL format "->>>>9.9<<<%" INITIAL 101.35.
define VARIABLE vscrppca as DECIMAL format "->>>>>>>9.9<<<<<<".
define VARIABLE vwopct   as DECIMAL format "->>>>9.9<<<%" INITIAL 110.22.
define VARIABLE vwopca   as DECIMAL format "->>>>>>>9.9<<<<<<".
define VARIABLE vlbrpct  as DECIMAL format "->>>>9.9<<<"  INITIAL 0.08.
define VARIABLE vmfgpct  as DECIMAL format "->>>>9.9<<<"  INITIAL 0.13.
define variable vptdesc  like pt_desc1 format "x(72)" no-undo.
define variable vpsdesc  like pt_desc1 format "x(72)" no-undo.
define variable venddate as   date     no-undo.  /*program end date variable*/
define variable venddays as   integer  no-undo.  /*program end date variable*/
define variable v_wcset as decimal format "->>>>>>9.9<<<<<" extent 15.
define variable v_wcrun as decimal format "->>>>>>9.9<<<<<" extent 15.
define variable wcid as character extent 15.
define BUFFER psmstr  for ps_mstr.

{xxbmpsrpt.i "new"}
{xxbmpsrpp.i}

form
    vpar     colon 15
    vscrppct colon 15
    vwopct   colon 15
    vlbrpct  colon 15
    vmfgpct  colon 15 skip
with frame a side-labels width 80.
setframelabels(frame a:handle).
find first qad_wkfl no-lock where
           qad_wkfl.qad_domain = global_domain and
           qad_wkfl.qad_key1 = "xxbmpsrp10.p.param" and
           qad_wkfl.qad_key2 = global_userid
           no-error.
if available qad_wkfl then do:
    assign vpar     = qad_wkfl.qad_charfld[1]
           vscrppct = qad_wkfl.qad_decfld[1]
           vwopct   = qad_wkfl.qad_decfld[2]
           vlbrPct  = qad_wkfl.qad_decfld[3]
           vmfgpct  = qad_wkfl.qad_decfld[4].
end.
else do:
     if vscrppct <> 101.35 then vscrppct = 101.35.
     if vwopct <> 110.22 then vwopct = 110.22.
     if vlbrPct <> 0.08 then vlbrpct = 0.08.
     if vmfgpct <> 0.13 then vmfgpct = 0.13.
end.

{wbrp01.i}
mainloop:
repeat with frame a
    on endkey undo, leave:
    update vpar vscrppct vwopct vlbrpct vmfgpct.
    if (c-application-mode <> 'web')
        or (c-application-mode = 'web' and (c-web-request begins 'data'))
    then do:
        bcdparm = "".
        {mfquoter.i vpar    }
        {mfquoter.i vscrppct}
        {mfquoter.i vwopct  }
        {mfquoter.i vlbrpct }
        {mfquoter.i vmfgpct }
    end.
    find first qad_wkfl exclusive-lock where
               qad_wkfl.qad_domain = global_domain and
               qad_wkfl.qad_key1 = "xxbmpsrp10.p.param" and
               qad_wkfl.qad_key2 = global_userid
               no-error.
    if available qad_wkfl then do:
       if not locked(qad_wkfl) then do:
          assign qad_wkfl.qad_charfld[1] = vpar
                 qad_wkfl.qad_decfld[1] = vscrppct
                 qad_wkfl.qad_decfld[2] = vwopct
                 qad_wkfl.qad_decfld[3] = vlbrPct
                 qad_wkfl.qad_decfld[4] = vmfgpct.
       end.
    end.
    else do:
         create qad_wkfl.
         assign qad_wkfl.qad_domain = global_domain
                qad_wkfl.qad_key1 = "xxbmpsrp10.p.param"
                qad_wkfl.qad_key2 = global_userid
                qad_wkfl.qad_charfld[1] = vpar
                qad_wkfl.qad_decfld[1] = vscrppct
                qad_wkfl.qad_decfld[2] = vwopct
                qad_wkfl.qad_decfld[3] = vlbrPct
                qad_wkfl.qad_decfld[4] = vmfgpct.
    end.

    /* output destination selection */
    {gpselout.i
        &printtype = "page"
        &printwidth = 380
        &pagedflag = "nopage"
        &stream = " "
        &appendtofile = " "
        &streamedoutputtoterminal = " "
        &withbatchoption = "yes"
        &displaystatementtype = 1
        &withcancelmessAge = "yes"
        &pagebottommargin = 6
        &withemail = "yes"
        &withwinprint = "yes"
        &definevariables = "yes"
    }
empty temp-table tempb no-error.
assign v_wcset = 0 v_wcrun = 0 wcid = "".
run getTmpbom(input vpar).
run tmpb2tmpbom(input vpar).
vmax = 0.
for each tempb no-lock:
    if tmpb_sort > vmax then assign vmax = tmpb_sort.
end.
{mfphead.i}
put unformat fill(" ",315).
for each tempb no-lock break by tmpb_sort:
    if first-of(tmpb_sort) then do:
       put unformat fill(" ",14 - int(length(tmpb_wc) / 2))
                    tmpb_wc
                    fill(" ",15 - int(length(tmpb_wc) / 2)) " ".
    end.
end.
put skip.
put unformat getTermLabel("PRODUCT",18).
put unformat getTermLabel("ITEM_NBR",18) at 20.
put unformat getTermLabel("DESCRIPTION",72) at 39.
put unformat getTermLabel("QUANTITY_PER",17) at 118.
put unformat getTermLabel("TBM_COMP",18) at 130.
put unformat getTermLabel("DESCRIPTION",75) at 149.
put unformat getTermLabel("TBM_CQTY",14) at 231.
put unformat getTermLabel("TBM_SET",14) at 247.
put unformat getTermLabel("TBM_RUN",14) at 261.
put unformat getTermLabel("RUN_TIME",14)  at 277.
put unformat getTermLabel("TBM_SETDIF",14) at 291.
put unformat getTermLabel("TBM_RUNDIF",14) at 307.
put unformat fill(" ",3).
for each tempb no-lock break by tmpb_sort:
    if first-of(tmpb_sort) then do:
       put unformat fill(" ",3) getTermLabel("TBM_SET",14)
                    fill(" ",7) getTermLabel("RUN_TIME",14) fill(" ",4).
    end.
end.
put skip.
put unformat fill("-",18) " ".
put unformat fill("-",18) " ".
put unformat fill("-",72) " ".
put unformat fill("-",17) " ".
put unformat fill("-",18) " ".
put unformat fill("-",78) " ".
do i = 1 to 6 + vmax * 2:
put unformat fill("-",14) " ".
end.
put skip.
for each tmpbom no-lock break by vpar by tbm_part by tbm_sn
    with frame b width 360 no-attr-space:
    if first-of(tbm_part) then do:
       assign vptdesc= "".
       find first pt_mstr no-lock where pt_domain = global_domain
       and pt_part = tbm_part no-error.
       if avail pt_mstr then do:
          assign vptdesc = pt_desc1 + "/" + pt_desc2.
       end.
    end.
    assign vpsdesc= "".
    find first pt_mstr no-lock where pt_domain = global_domain
    and pt_part = tbm_comp no-error.
    if avail pt_mstr then do:
       assign vpsdesc = pt_desc1 + "/" + pt_desc2.
    end.
    put unformat vpar.
    put unformat tbm_part at 20.
    put unformat vptdesc at 39.
    put unformat string(tbm_pqty,"->>>>>>>9.9<<<<") at 118.
    put unformat tbm_comp at 130.
    put unformat vpsdesc at 149.
    put unformat string(tbm_cqty,"->>>>>>>9.9<<<<") at 229.
    put unformat string(tbm_set,"->>>>>>>9.9<<<<") at 244.
    put unformat string(tbm_run,"->>>>>>>9.9<<<<") at 259.
    put unformat string(tbm_run * tbm_pqty,"->>>>>>>9.9<<<<") at 274.
    put unformat string(tbm_setdif,"->>>>>>>9.9<<<<") at 289.
    put unformat string(tbm_rundif,"->>>>>>>9.9<<<<") at 304.
    do i = 1 to vmax:
       put unformat string(tbm_wcset[i],"->>>>>>>9.9<<<<")
                    at 320 + (i - 1) * 30.
       put unformat string(tbm_wcrun[i] * tbm_pqty,"->>>>>>>9.9<<<<")
                    at 335 + (i - 1) * 30.
       assign v_wcset[i] = v_wcset[i] + tbm_wcset[i]
              v_wcrun[i] = v_wcrun[i] + tbm_wcrun[i] * tbm_pqty.
    end.
    put skip.
    ACCUM tbm_pqty(total)
          tbm_cqty(total)
          tbm_cost(total)
          tbm_set(total)
          tbm_run(total)
          tbm_run * tbm_pqty(total)
          tbm_mtl_cst(total)
          tbm_lbr_cst(total)
          tbm_bdn_cst(total)
          tbm_cst(total)
          tbm_unit_cost(total)
          tbm_wcset(total)
          tbm_wcrun(total)
          tbm_setdif(total)
          tbm_rundif(total).
    if last-of(vpar) then do:
       put skip .
       put unformat getTermLabelRt("TOTAL",10) at 20.
       put unformat string(accum total(tbm_pqty),"->>>>>>>9.9<<<<") at 118.
       put unformat string(accum total(tbm_cqty),"->>>>>>>9.9<<<<") at 229.
       put unformat string(accum total(tbm_set),"->>>>>>>9.9<<<<") at 244.
       put unformat string(accum total(tbm_run),"->>>>>>>9.9<<<<") at 259.
       put unformat string(accum total(tbm_run * tbm_pqty),"->>>>>>>9.9<<<<")
                    at 274.
       put unformat string(accum total(tbm_setdif),"->>>>>>>9.9<<<<") at 289.
       put unformat string(accum total(tbm_rundif),"->>>>>>>9.9<<<<") at 304.
       do i = 1 to vmax:
           put unformat string(v_wcset[i],"->>>>>>>9.9<<<<")
               at 320 + (i - 1) * 30.
           put unformat string(v_wcrun[i],"->>>>>>>9.9<<<<")
               at 335 + (i - 1) * 30.
       end.
       put skip.
    end.
    {mfrpchk.i}
    setframelabels(frame b:handle).
end.
{mfrtrail.i}
/*  {mfreset.i}   */
/*  {mfgrptrm.i}  */
end.

{wbrp04.i &frame-spec = a}
