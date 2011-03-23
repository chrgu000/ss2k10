/*xxsorp002.p                                                                */
/* revision: 110314.1   created on: 20110314   by: zhang yun                 */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/
/*注意：cim-showa.xla vba project password:rogercimshowa                     */

{mfdtitle.i "110314"}
&SCOPED-DEFINE sosoiq_p_1 "Qty Open"

define variable effdate  like tr_effdate no-undo label "DUE_DATE".
define variable effdate1 like tr_effdate no-undo.
define variable vend     like po_vend no-undo.
define variable vend1    like po_vend no-undo.
define variable vprice   as   decimal.
define variable qty_open like pod_qty_ord label {&sosoiq_p_1}.
define variable qty_ord  like pod_qty_ord.
define variable qty_rcvd like pod_qty_rcvd.
/* Attention: xxsod_det 存的全是字符!!! */

/*由日期到字符格式,for output to excel*/
function xdate2c returns char (input v_ddate as date):
   define var v_cdate as char no-undo.

   if v_ddate = ?  then v_cdate = "" .
   else do:
       v_cdate = string(year(v_ddate),"9999") + "-"
               + string(month(v_ddate),"99") + "-"
               + string(day(v_ddate),"99").
   end.
   return (v_cdate).
end function.

form
   skip(.2)
   effdate  colon 15
   effdate1 colon 49  label {t001.i}
   vend     colon 15
   vend1    colon 49  label {t001.i}
skip(1)
with frame a  side-labels width 80 attr-space.
setframelabels(frame a:handle).

effdate = today.

{wbrp01.i}
repeat:

    if effdate  = low_date then effdate = ?.
    if effdate1 = hi_date  then effdate1 = ?.
    if vend1 = hi_char then vend1 = "".

    update
        effdate
        effdate1
        vend
        vend1
    with frame a.

    if effdate  = ? then effdate = low_date.
    if effdate1 = ? then effdate1 = hi_date.
    if vend1 = "" then vend1 = hi_char.

  /*excel报表专用,不用再改程式名*/
/*    if index(execname,".p") <> 0 then v_prgname = entry(1,execname,".p").  */
/*    else do:                                                               */
/*        message "错误:无效程式名格式" execname .                           */
/*        undo,retry.                                                        */
/*    end.                                                                   */

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
mainloop:
do on error undo, return error on endkey undo, return error:
export delimiter "~011" "生效日期" xdate2c(effdate) + "-" + xdate2c(effdate1) 
								 "供应商" vend + "-" + vend1.
export delimiter "~t" "供应商" "名称" "图号" "订单数量" "箱数" "保险价" skip.
for each pod_det no-lock where pod_due_date >= effdate and
         pod_due_date <= effdate1 and pod_stat <> "X" and pod_stat <> "C"
   ,each po_mstr no-lock where po_nbr = pod_nbr and
         po_vend >= vend and po_vend <= vend1
    break by po_vend by pod_part:
    if first-of(pod_part) then do:
       assign qty_ord = 0
              qty_rcvd = 0.
    end.
    assign qty_ord = qty_ord + pod_qty_ord
           qty_rcvd = qty_rcvd + pod_qty_rcvd.
    if last-of(pod_part) then do:
       assign vprice = 0.
       find first pt_mstr no-lock where pt_part = pod_part no-error.
       find first vd_mstr no-lock where vd_addr = po_vend no-error.
       find first vp_mstr no-lock where
                vp_vend = po_vend and vp_part = pod_part no-error.
       if available vp_mstr then do:
          assign vprice = vp__dec01.
       end.
       export Delimiter "~t" po_vend vd_sort pod_part qty_ord - qty_rcvd
              pt_ord_mult vprice.
    end.
end.
put unformatted skip(1) "报表结束"  skip .
end. /* mainloop: */
/* {mfrtrail.i}  *REPORT TRAILER  */
{mfreset.i}
{pxmsg.i &MSGNUM=9 &ERRORLEVEL=1}
end.  /* repeat */
{wbrp04.i &frame-spec = a}
