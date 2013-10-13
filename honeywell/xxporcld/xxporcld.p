/* xxswotr.p -- PO自动收货                                                   */
/* Copyright 2013 SoftSpeed gz  create by:zy                                 */
/* REVISION END                                                              */

/**** test program **********************************************************

define variable i as integer.
define variable c as character.
assign i = 1.
for each pod_det no-lock where pod_stat <> "C" break by pod_nbr by pod_line:
if first-of(pod_nbr) then
i = i + 1.
if i modulo 2 = 0 then C = "I" else C = "O".
/*
display pod_nbr pod_part pod_line pod_qty_ord pod_qty_rcvd.
*/
create cknyh_hist .
assign cknyh_prt_nbr = i
       cknyh_prt_item = pod_line
       cknyh_order = pod_nbr
       cknyh_prt_date = today + i
       cknyh_stype = C
       cknyh_line = pod_line
       cknyh_part = pod_part
       cknyh_qty = pod_qty_ord - pod_qty_rcvd.
end.

**** test program **********************************************************/

{mfdtitle.i "test.3"}

{xxporcld.i "new"}
define variable nynbr  like cknyh_prt_nbr.
define variable v_sel  as   logical initial no.
define variable vfile  as character.
define variable trrecid as recid.
define variable errmsg as character.
define variable cfile as character.
/* DISPLAY SELECTION FORM */
form nynbr colon 24
     v_sel colon 46 label "Sel All"
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

form tpo_sel     column-label "sel"
     tpo_po      colon 3
     tpo_line    colon 12
     tpo_part    colon 16
     tpo_loc     colon 34 column-label "Loc" format "x(4)"
     tpo_qty_req colon 39 column-label "Ord" format ">>>>9.99"
     tpo_qty_rc  colon 48 column-label "Rcvd" format ">>>>9.99"
     tpo_stat    colon 58 format "x(18)"
With frame selny no-validate with title color
normal(getFrameTitle("PODETAIL",30)) 8 down width 80.
setFrameLabels(frame selny:handle).

function getLoc returns character(iType as character):
   define variable vLoc as character.
   assign vloc = "".
   find first code_mstr no-lock where code_fldname = "cknyh_stype_loc"
          and code_value = iType no-error.
   if available code_mstr then do:
      assign vLoc = code_cmmt.
   end.
   return vLoc.
end function.
/*日期限制*/
if today < date(10,1,2013) or today >  date(10,31,2013) then do:
   bell.
   if can-find(msg_mstr where msg_lang = global_user_lang
                          and msg_nbr = 2261)
   then do:
      /* Software version expired, please contact your dealer */
      {pxmsg.i &MSGNUM=2261 &ERRORLEVEL=1}
   end.
   else do:
      message
         "Software revision expired, please contact your dealer" +
         " for more information".
   end.
   repeat:
      pause.
      leave.
   end.
   leave.
end.
/* 日期限制 */
/* DISPLAY */
view frame a.
repeat with frame a:

   do on error undo,retry:
      update nynbr.
      /*po单和ID不可同时为空*/
      if nynbr = 0 or
         not can-find(first cknyh_hist no-lock where cknyh_prt_nbr = nynbr) then
      do:
         {pxmsg.i &MSGTEXT=""错误的NY_No"" &ERRORLEVEL=3}
         undo ,retry.
      end.
   end.

   ststatus = stline[2].
   status input ststatus.
   do on error undo,retry:
      update v_sel.
   end.
   scroll_loopb:
   do on error undo,retry:
      empty temp-table tmp_pod no-error.
      for each cknyh_hist no-lock where cknyh_prt_nbr = nynbr:
          create tmp_pod.
          assign  tpo_sel = if v_sel then "*" else ""
                  tpo_po  = cknyh_order
                  tpo_line = cknyh_line
                  tpo_part = cknyh_part
                  tpo_loc = getLoc (cknyh_stype)
                  tpo_id = integer(recid(cknyh_hist))
                  tpo_qty_req = cknyh_qty + cknyh_qty1 + cknyh_qty2 + cknyh_qty3.
         find first pod_det no-lock where pod_nbr = tpo_po and pod_line = tpo_line no-error.
          for each tmp_pod exclusive-lock:
          assign tpo_stat = "可收货".
          find first pod_det no-lock where pod_nbr = tpo_po and pod_line = tpo_line no-error.
          if available pod_det then do:
             assign tpo_qty_rc = min(pod_qty_ord - pod_qty_rcvd,tpo_qty_req).
             if pod_stat = "C" or pod_stat = "X" then do:
                assign tpo_stat = "采购单项状态为" + pod_stat.
                next.
             end.
             if tpo_qty_rc <= 0 then do:
                assign tpo_stat = "无可收货数量".
             end.
          end.
          else do:
             assign tpo_stat = "采购单项次不存在".
          end.
      end.
      /*     find first xxpr_det where xxpr_cknyhid = integer(recid(cknyh_hist)) no-lock no-error. */
      /*     if available xxpr_det then do:                                                        */
      /*        if xxpr_stat <> "C" then do:                                                       */
      /*           assign tpo_qty_rc = tpo_qty_req - xxpr_qty_rcvd.                                */
      /*        end.                                                                               */
      /*        else do:                                                                           */
      /*           assign tpo_qty_rc = xxpr_qty_rcvd.                                              */
      /*        end.                                                                               */
      /*     end.                                                                                  */
      /*     else do:                                                                              */
      /*        assign tpo_qty_rc = tpo_qty_req.                                                   */
      /*     end.                                                                                  */
      end.
      {xxswosel.i
         &detfile      = tmp_pod
         &scroll-field = tpo_po
         &framename = "selny"
         &framesize = 8
         &selectd   = yes
         &sel_on    = ""*""
         &sel_off   = """"
         &display1  = tpo_sel
         &display2  = tpo_po
         &display3  = tpo_line
         &display4  = tpo_part
         &display5  = tpo_loc
         &display6  = tpo_qty_req
         &display7  = tpo_qty_rc
         &display8  = tpo_stat
         &include2  = "update tpo_qty_rc with frame selny."
         &exitlabel = scroll_loopb
         &exit-flag = "true"
         &record-id = recid(tmp_pod)
         }
         setFrameLabels(frame selny:handle).
         if keyfunction(lastkey) = "END-ERROR" then do:
            hide frame selny.
            undo scroll_loopb, retry scroll_loopb.
         end.
   end.
   /*
   for each tmp_powoin exclusive-lock where tpwi_sel = "" or tpwi_qty_rc = 0:
       delete tmp_powoin.
   end.

   for each tmp_powoin no-lock with frame xx title color
   normal(getFrameTitle("TRANSFER_DETAIL",30)):
       display tpwi_po tpwi_part tpwi_qty_loc tpwi_qty_tr
               tpwi_floc tpwi_tloc.
       setFrameLabels(frame xx:handle).
   end.
*/
   if not can-find(first tmp_pod) then do:
      {mfmsg.i 1310 3}
      undo,retry.
   end.
   assign v_sel = no.
   {mfmsg01.i 9201 2 v_sel}
   if v_sel then do:
      for each tmp_pod exclusive-lock:
          assign tpo_stat = "可收货".
          find first pod_det no-lock where pod_nbr = tpo_po and pod_line = tpo_line no-error.
          if available pod_det then do:
             if pod_stat = "C" or pod_stat = "X" then do:
                assign tpo_stat = "采购单项状态为" + pod_stat.
                next.
             end.
             if pod_qty_ord - pod_qty_rcvd < tpo_qty_rc then do:
                assign tpo_stat = "未结数量不足".
                next.
             end.
          end.
          else do:
             assign tpo_stat = "采购单项次不存在".
          end.
      end.
      find first tmp_pod no-lock where tpo_sel = "*" and tpo_stat <> "可收货" no-error.
      if available tmp_pod then do:
         message "资料检查未通过,请确认资料!".
         leave.
      end.
      for each tmp_pod exclusive-lock where tpo_sel = "*" and tpo_stat = "可收货":
          assign vfile = trim(tpo_po) + "_" + trim(string(tpo_line)) + "." + string(tpo_id).
          output to value(vfile + ".bpi").
             put unformat '"' tpo_po '"' skip.
             put unformat '- - - - N N' skip.
             find first po_mstr no-lock where po_nbr = tpo_po no-error.
             if available po_mstr then do:
                find first vd_mstr no-lock where vd_addr = po_vend no-error.
                if available vd_mstr then do:
                   find first gl_ctrl no-lock no-error.
                   if available gl_ctrl then do:
                   if vd_curr <> gl_base_curr then do:
                      put unformat '-' skip.
                   end.
                   end.
                end.
             end.
             put unformat trim(string(tpo_line)) skip.
             put unformat trim(string(tpo_qty_rc)) ' - - - - - - "' tpo_loc '" - - - N N N' skip.
             put unformat '.' skip.
             put unformat 'N' skip.
             put unformat 'Y' skip.
             put unformat '.' skip.
          output close.
       do transaction on endkey undo, leave:
          assign trrecid = current-value(tr_sq01).
          input from value(vfile + ".bpi").
          output to value(vfile + ".bpo").
          batchrun = yes.
          {gprun.i ""poporc.p""}
          batchrun = no.
          output close.
          input close.

          find first tr_hist no-lock where tr_trnbr > integer(trrecid)
                 and tr_nbr = tpo_po and tr_line = tpo_line
                 and tr_type = "RCT-PO" and tr_part = tpo_part no-error.
          if available tr_hist then do:
             assign tpo_stat = "tr_nbr:" + trim(string(tr_trnbr)).
             find first cknyh_hist no-lock where int(recid(cknyh_hist)) = tpo_id no-error.
             if not available cknyh_hist then do:
                next.
             end.
             find first xxpr_det exclusive-lock where xxpr_cknyhid = tpo_id no-error.
                  if not available xxpr_det then do:
                     create xxpr_det.
                     assign xxpr_prt_nbr = nynbr
                            xxpr_po_nbr = cknyh_order
                            xxpr_line = cknyh_line
                            xxpr_qty_req = tpo_qty_req
                            xxpr_qty_rcvd = tpo_qty_rc
                            xxpr_stype = cknyh_stype
                            xxpr_status = "C"
                            xxpr_date = today
                            xxpr_user = global_userid
                            xxpr_cknyhid = tpo_id.
                  end.
                  xxpr_qty_rcvd = xxpr_qty_rcvd + tpo_qty_rc.
          end.
          else do:
                     errmsg  = "".
                     cfile = vfile + ".bpo".
                    {gprun.i ""xxgetcimerr.p"" "(input cfile,output errmsg)"}
                    assign tpo_stat = "CIM错误:" + errmsg.
          end.
        end.  /* do transaction on endkey undo, leave:  */
     end.  /* for each tmp_pod exclusive-lock:  */
   end.  /* if v_sel then do:                   */
end.   /* repeat with frame a:                  */
if can-find(first tmp_pod no-lock where tpo_sel = "*"  ) then
{gprun.i ""xxporcldrp.p""}
status input.