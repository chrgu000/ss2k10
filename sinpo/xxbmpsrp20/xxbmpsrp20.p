/* xxbmpsrp10.p - bom runtime report                                         */
/* REVISION:101020.2 LAST MODIFIED: 11/29/10 BY: zy                       *bt*/
/* REVISION:110217.1 LAST MODIFIED: 02/17/11 BY: zy                       *2h*/
/*-Revision end--------------------------------------------------------------*/
/* Environment: Progress:10.1C04   QAD:eb21sp6                               */
/*V8:ConvertMode=Report                                                      */
{mfdtitle.i "110217.1"}

define variable vpar     like pt_part initial "".
define variable vpar2    like pt_part initial "".
define variable vscrppct as decimal format "->>>>9.9<<<%" initial 101.35.
define variable vscrppca as decimal format "->>>>>>>9.9<<<<<<".
define variable vwopct   as decimal format "->>>>9.9<<<%" initial 110.22.
define variable vwopca   as decimal format "->>>>>>>9.9<<<<<<".
define variable vlbrpct  as decimal format "->>>>9.9<<<"  initial 0.08.
define variable vmfgpct  as decimal format "->>>>9.9<<<"  initial 0.13.
define variable vwc      like wc_wkctr extent 15.
define variable wcid as character extent 15.
define variable i           as integer.
define variable j           as integer.
define variable iwccnt      as integer.
define variable vwcset as decimal format "->>>>>>9.9<<<<<" extent 15 no-undo.
define variable vwcrun as decimal format "->>>>>>9.9<<<<<" extent 15 no-undo.
define variable v_wcset as decimal format "->>>>>>9.9<<<<<" extent 15 no-undo.
define variable v_wcrun as decimal format "->>>>>>9.9<<<<<" extent 15 no-undo.
define variable vmax as integer.
define BUFFER psmstr for ps_mstr.
define variable vcimfile as character.
define stream sf.

{xxbmpsrpt.i "new"}
{xxbmpsrpp.i}

form
    vpar     colon 15    vpar2 colon 40 label {t001.i}
    vscrppct colon 15
    vwopct   colon 15
    vlbrpct  colon 15
    vmfgpct  colon 15
    skip
with frame a side-labels width 80.
setframelabels(frame a:handle).
find first qad_wkfl no-lock where
           qad_wkfl.qad_domain = global_domain and
           qad_wkfl.qad_key1 = "xxbmpsrp10.p.param" and
           qad_wkfl.qad_key2 = global_userid
           no-error.
if available qad_wkfl then do:
    assign vscrppct = qad_wkfl.qad_decfld[1]
           vwopct   = qad_wkfl.qad_decfld[2]
           vlbrPct  = qad_wkfl.qad_decfld[3]
           vmfgpct  = qad_wkfl.qad_decfld[4].
end.

{wbrp01.i}
mainloop:
repeat with frame a
    on endkey undo, leave:
    if vpar2 = hi_char then vpar2 = "".
    update vpar vpar2 vscrppct vwopct vlbrpct vmfgpct.
    if (c-application-mode <> 'web')
        or (c-application-mode = 'web' and (c-web-request begins 'data'))
    then do:
        bcdparm = "".
        {mfquoter.i vpar    }
        {mfquoter.i vpar2   }
        {mfquoter.i vscrppct}
        {mfquoter.i vwopct  }
        {mfquoter.i vlbrpct }
        {mfquoter.i vmfgpct }
    end.
    if vpar2 = "" then vpar2 = hi_char.

  assign vcimfile = "xxbmps" + string(time) + ".cim".
  output stream sf to value(vcimfile).
  for each pt_mstr no-lock where pt_phantom:
  /*    put stream sf unformat "@@batchload ppptmt02.p" skip.   */
      put stream sf unformat '"' pt_part '"' skip.
      put stream sf unformat "- - - - - - - - - - - ".
      put stream sf unformat "- - - - - - - - - - - - - NO" skip.
  /*     put stream sf unformat "@@end" skip.                    */
  end.
  output stream sf close.

    batchrun  = yes.
    input from value(vcimfile).
    output to value(vcimfile + ".out") keep-messages.
    hide message no-pause.
    {gprun.i ""ppptmt02.p""}
    hide message no-pause.
    output close.
    input close.
    batchrun  = no.


    /* output destination selection */
    {gpselout.i
        &printtype = "page"
        &printwidth = 600
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
        &definevariables = "yes"}
{mfphead.i}
put unformat fill(" ",384).
assign iwccnt = 0.
for each code_mstr no-lock where code_domain = global_domain
     and code_fldname = "xxbmpsrp10-wkctr" break by code_fldname by code_user1:
     put unformat fill(" ",16 - int(length(code_value) / 2))
                  code_value.
     if not last-of(code_fldname) then
     put unformat  fill(" ",17 - int(length(code_value) / 2)) " ".
     assign iwccnt = iwccnt + 1.
     assign vwc[iwccnt] = code_value.
end.
put skip.
put unformat getTermLabel("ITEM_NBR",18).
put unformat getTermLabel("DESCRIPTION_1",16) at 19.
put unformat getTermLabel("DESCRIPTION_2",16) at 93.
put unformat getTermLabel("QUANTITY_PER",16) at 169.
put unformat getTermLabel("TBM_CQTY",16) at 169 + 17 * 1.
put unformat getTermLabel("TBM_COST",16) at 169 + 17 * 2.
put unformat getTermLabel("TBM_SET",16) at 169 + 17 * 3.
put unformat getTermLabel("TBM_RUN",16) at 169 + 17 * 4.
put unformat getTermLabel("RUN_TIME",16) at 169 + 17 * 5.
put unformat getTermLabel("TBM_MTL_CST",16) at 169 + 17 * 6.
put unformat getTermLabel("TBM_LBR_CST",16) at 169 + 17 * 7.
put unformat getTermLabel("TBM_BDN_CST",16) at 169 + 17 * 8.
put unformat getTermLabel("TBM_CST",16) at 169 + 17 * 9.
put unformat getTermLabel("TBM_UNIT_COST",16) at 169 + 17 * 10.
put unformat getTermLabel("TBM_SETDIF",16) at 169 + 17 * 11.
put unformat getTermLabel("TBM_RUNDIF",16) at 169 + 17 * 12.
do i = 1 to iwccnt:
   put unformat getTermLabel("TBM_SET",16) at 374 + 17 * (i * 2 - 1).
   put unformat getTermLabel("RUN_TIME",16) at 374 + 17 * (i * 2).
end.
put skip.
put unformat fill("-",18) " " fill("-",72) " " fill("-",72) " ".
do i = 1 to 13 + iwccnt * 2:
   put unformat fill("-",16) " ".
end.
put skip.
assign v_wcset = 0 v_wcrun = 0.
for each pt_mstr no-lock where pt_domain = global_domain and
         pt_part >= vpar and pt_part <= vpar2 and pt_pm_code = "M"
         with frame b width 600 no-attr-space:
    empty temp-table tmpbom no-error.
    assign wcid = "".
    run getTmpbom(input pt_part).
    run tmpb2tmpbom(input pt_part).
    vmax = 0.
    for each tempb no-lock:
        if tmpb_sort > vmax then assign vmax = tmpb_sort.
    end.
    assign vwcset = 0 vwcrun = 0 v_wcset = 0 v_wcrun = 0.
    for each tmpbom no-lock where:
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
       do i = 1 to vmax:
       assign vwcset[i] = vwcset[i] + tbm_wcset[i]
              vwcrun[i] = vwcrun[i] + tbm_wcrun[i] * tbm_pqty.
       end.
    end.
    do i = 1 to iwccnt:
       do j = 1 to vmax:
          if vwc[i] = wcid[j] then do:
             assign v_wcset[i] = vwcset[j]
                    v_wcrun[i] = vwcrun[j].
          end.
       end.
    end.
    put unformat pt_part
                 pt_desc1 at 19
                 pt_desc2 at 93.
    put unformat string(accum total(tbm_pqty),"->>>>>>>9.9<<<<")
                 at 167.
    put unformat string(accum total(tbm_cqty),"->>>>>>>9.9<<<<")
                 at 167 + 17 * 1.
    put unformat string(accum total(tbm_cost),"->>>>>>>9.9<<<<")
                 at 167 + 17 * 2.
    put unformat string(accum total(tbm_set),"->>>>>>>9.9<<<<")
                 at 167 + 17 * 3.
    put unformat string(accum total(tbm_run),"->>>>>>>9.9<<<<")
                 at 167 + 17 * 4.
    put unformat string(accum total(tbm_run * tbm_pqty),"->>>>>>>9.9<<<<")
                 at 167 + 17 * 5.
    put unformat string(accum total(tbm_mtl_cst),"->>>>>>>9.9<<<<")
                 at 167 + 17 * 6.
    put unformat string(accum total(tbm_lbr_cst),"->>>>>>>9.9<<<<")
                 at 167 + 17 * 7.
    put unformat string(accum total(tbm_bdn_cst),"->>>>>>>9.9<<<<")
                 at 167 + 17 * 8.
    put unformat string(accum total(tbm_cst),"->>>>>>>9.9<<<<")
                 at 167 + 17 * 9.
    put unformat string(accum total(tbm_unit_cost),"->>>>>>>9.9<<<<")
                 at 167 + 17 * 10.
    put unformat string(accum total(tbm_setdif),"->>>>>>>9.9<<<<")
                 at 167 + 17 * 11.
    put unformat string(accum total(tbm_rundif),"->>>>>>>9.9<<<<")
                 at 167 + 17 * 12.
    do i = 1 to iwccnt:
         put unformat string(v_wcset[i],"->>>>>>>9.9<<<<")
             at 374 + 17 * (i * 2 - 1).
         put unformat string(v_wcrun[i],"->>>>>>>9.9<<<<")
             at 374 + 17 * (i * 2).
    end.
    put skip.
/*     for each tmpbom no-lock with width 600:                    */
/*              display pt_part  tbm_sn                           */
/*                               tbm_wcrun[1]                     */
/*                               tbm_wcrun[2]                     */
/*                               tbm_wcrun[3]                     */
/*                               tbm_wcrun[4]                     */
/*                               tbm_wcrun[5]                     */
/*                               tbm_wcrun[6]                     */
/*                               tbm_wcrun[7]                     */
/*                               tbm_wcrun[8]                     */
/*                               tbm_wcrun[9]                     */
/*                               tbm_wcrun[10]                    */
/*                               tbm_wcrun[11]                    */
/*                               tbm_wcrun[12]                    */
/*                               tbm_wcrun[13] .                  */
/*     end.                                                       */
/*    put "next part" skip(3).                                    */
/*       do i = 1 to 15:                                          */
/*          put i " " wcid[i] " " vwcset[i] " " vwcrun[i] skip.   */
/*       end.                                                     */
/*       put skip.                                                */
    {mfrpchk.i}
end.
put skip.
/* setframelabels(frame b:handle). */
{mfrtrail.i}
/*  {mfreset.i}   */
/*  {mfgrptrm.i}  */
end.

{wbrp04.i &frame-spec = a}
