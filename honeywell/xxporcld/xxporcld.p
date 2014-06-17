/* xxswotr.p -- PO自动收货                                                   */
/* Copyright 2013 SoftSpeed GZ  create by:zy                                 */
/* REVISION END                                                              */
/* If cknyh_part <> pod_part, don’t allow to receive this line.  **t.140310.1*/
{mfdtitle.i "140530.1"}

{xxporcld.i "new"}
define variable nynbr  like cknyh_prt_nbr.
define variable v_sel  as   logical initial no.
define variable v_con  as   logical initial no.
define variable vfile  as character.
define variable trrecid as recid.
/* DISPLAY SELECTION FORM */
form nynbr colon 24
     v_sel colon 46 label "Sel All"
with frame a side-labels width 80 attr-space.
/* setFrameLabels(frame a:handle). */

form tpo_sel
     tpo_po      colon 2
     tpo_line    colon 11
     tpo_part    colon 15
     tpo_loc     colon 34
     tpo_qty_req colon 41
     tpo_qty_rc  colon 51
     tpo_stat colon 62 format "x(14)"
With frame selny /* no-validate with title color
normal(getFrameTitle("PODETAIL",30)) */ 16 down width 80.

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

repeat with frame a:
view frame a.

   do on error undo,retry:
/*************************
 *    prompt-for nynbr editing:
 *       /* FIND NEXT/PREVIOUS RECORD */
 *     if frame-field = "nynbr" then do:
 *        {mfnp05.i cknyh_hist cknyh_nbr_item " yes " cknyh_prt_nbr "input nynbr"}
 *        if recno <> ? then do:
 *             display cknyh_prt_nbr @ nynbr.
 *        end.
 *     end.
 *     else do:
 *          readkey.
 *          apply lastkey.
 *     end.
 *   end. /* editing: */
*************************/
       update nynbr.
      /*po单和ID不可同时为空*/
      if nynbr = 0 or
         not can-find(first cknyh_hist no-lock where cknyh_prt_nbr = nynbr) then
      do:
         message "错误的NY_NO" view-as alert-box.
         undo ,retry.
      end.
      find first code_mstr no-lock where code_fldname = "xxporcld.p.lynbr.ctrl"
             and code_value = "MinVal" no-error.
      if available code_mstr then do:
         if nynbr < integer(code_cmmt) then do:
            message "NY_NO不可小于" + code_cmmt view-as alert-box.
            undo ,retry.
         end.
      end.
   end.
   assign nynbr.
   ststatus = stline[2].
   status input ststatus.
   update v_sel.
   assign v_sel.

      for each tmp_pod exclusive-lock: delete tmp_pod. end.
      for each cknyh_hist no-lock where cknyh_prt_nbr = nynbr:
          create tmp_pod.
          assign  tpo_sel = if v_sel then "*" else ""
                  tpo_po  = cknyh_order
                  tpo_line = cknyh_line
                  tpo_part = cknyh_part
                  tpo_loc = getLoc (cknyh_stype)
                  tpo_stype = cknyh_stype
                  tpo_id = integer(recid(cknyh_hist))
                  tpo_qty_req = cknyh_qty + cknyh_qty1 + cknyh_qty2 + cknyh_qty3.
              find first prh_hist no-lock where prh_nbr = tpo_po
                     and prh_line = tpo_line and prh_ps_nbr = trim(string(nynbr)) no-error.
              if available prh_hist then do:
                 assign tpo_receive = prh_receiver
                        tpo_stat = prh_receiver
                        tpo_qty_rc = prh_rcvd.
              end.
              else do:
                  assign tpo_qty_rc = tpo_qty_req
                         tpo_stat = "可收货".
              end.
       end.       /* for each cknyh_hist no-lock where cknyh_prt_nbr = nynbr: */
      for each tmp_pod exclusive-lock where tpo_stat = "可收货":
               find first pod_det no-lock where pod_nbr = tpo_po and pod_line = tpo_line no-error.
              if available pod_det and tpo_part <> pod_part then do:
                 assign tpo_stat = "NY与pod料号不同".
                       tpo_qty_rc = 0.
                 next.
              end.
              find first pod_det no-lock where pod_nbr = tpo_po and pod_line = tpo_line no-error.
              if available pod_det then do:
                 if pod_stat = "C" or pod_stat = "X" then do:
                    assign tpo_stat = "状态:" + pod_stat
                           tpo_qty_rc = 0.
                    next.
                 end.
                 if tpo_qty_rc > min(pod_qty_ord - pod_qty_rcvd,tpo_qty_req) then do:
                    assign tpo_stat = "预收" + trim(string(tpo_qty_rc)) + ">可收"
                                    + trim(string(min(pod_qty_ord - pod_qty_rcvd,tpo_qty_req)))
                           tpo_qty_rc = 0.
                 end.
              end.
              else do:
                 assign tpo_stat = "项不存在"
                        tpo_qty_rc = 0.
              end.
           end.   /* for each tmp_pod exclusive-lock:   */
   scroll_loopb:
   do on error undo,retry:
      {xxswosel.i
         &detfile      = tmp_pod
         &scroll-field = tpo_po
         &framename = "selny"
         &framesize = 16
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
         &include2  = "update tpo_qty_rc when tpo_stat = '可收货' with frame selny."
         &exitlabel = scroll_loopb
         &exit-flag = "true"
         &record-id = recid(tmp_pod)
         }
          if keyfunction(lastkey) = "END-ERROR" then do:
            hide frame selny.
            undo scroll_loopb, retry scroll_loopb.
         end.
         if keyfunction(lastkey) = "F4" then do:
            hide frame selny.
            undo scroll_loopb, retry scroll_loopb.
         end.
   end.  /* scroll_loopb */

   view frame selny.
   if not can-find(first tmp_pod) then do:
      {mfmsg.i 1310 3}
      undo,retry.
   end.

   assign v_con = no.
   {mfmsg01.i 12 2 v_con}
   if v_con then do:
       for each tmp_pod exclusive-lock where tpo_sel = "*" and tpo_stat = "可收货":
          assign vfile = 'TMP_' + execname + trim(tpo_po) + "_" + trim(string(tpo_line)) + "." + string(tpo_id).
          output to value(vfile + ".bpi").
             put unformat '"' tpo_po '"' skip.
             put unformat '"' trim(string(nynbr)) '" - - N N' skip.
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
             put unformat trim(string(tpo_qty_rc)) ' - - - - - - "'.    /*~*/
                 put unformat tpo_loc '" - - - N N N' skip.
             put unformat '.' skip.
             put unformat 'N' skip.
             put unformat 'Y' skip.
             put unformat '.' skip.
          output close.
       do transaction:
          assign trrecid = current-value(tr_sq01).
          input from value(vfile + ".bpi").
          output to value(vfile + ".bpo").
          batchrun = yes.
          {gprun.i ""poporc.p""}
          batchrun = no.
          output close.
          input close.
          assign tpo_stat = "CIM错误".
          find first tr_hist no-lock where tr_trnbr > integer(trrecid)
                 and tr_nbr = tpo_po and tr_line = tpo_line
                 and tr_type = "RCT-PO" and tr_part = tpo_part no-error.
          if available tr_hist then do:
             os-delete value(vfile + ".bpi").
             os-delete value(vfile + ".bpo").
             assign tpo_stat = "tr:" + trim(string(tr_trnbr,">>>>>>>9"))
                    tpo_receive = tr_lot.
             find first xxpr_det exclusive-lock where xxpr_cknyhid = tpo_id no-error.
                  if not available xxpr_det  then do:
                     create xxpr_det.
                     assign xxpr_cknyhid = tpo_id.
                  end.
                     assign xxpr_prt_nbr = nynbr
                            xxpr_po_nbr = tpo_po
                            xxpr_line = tpo_line
                            xxpr_qty_req = tpo_qty_req
                            xxpr_qty_rcvd = tpo_qty_rc
                            xxpr_stype = tpo_stype
                            xxpr_status = "C"
                            xxpr_date = today
                            xxpr_user = global_userid
                            xxpr_qty_rcvd = tpo_qty_rc
                            xxpr__chr01 = tr_lot
                            xxpr__int01 = recid(tr_hist).
          end.
        end.  /* do transaction on endkey undo, leave:  */
     end.  /* for each tmp_pod exclusive-lock:  */
   end.  /* if v_sel then do:                   */
  clear frame selny.
  hide all.
    if can-find(first tmp_pod no-lock) then do:
      for each tmp_pod where tpo_sel = "*" with frame sel2 with width 80:
        display tpo_po
                tpo_line
                tpo_part
                tpo_loc
                tpo_qty_req
                tpo_qty_rc
                tpo_stat format "x(18)".
      end.
    end.  /* if can-find(first tmp_pod no-lock) then do: */
  /*   {gprun.i ""xxporcldrp.p""}   */
end.   /* repeat with frame a:                  */
status input.
