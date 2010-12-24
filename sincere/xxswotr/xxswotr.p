/* xxswotr.p -- 委外加工单调拨                                               */
/* Copyright 2010 SoftSpeed gz                                               */
/* SS - 101223.1 By: zhangyun                                                */
/* REVISION: 09$5 LAST MODIFIED: 12/09/10   BY: zy                           */
/* REVISION END                                                              */

{mfdtitle.i "101222.1"}
{gplabel.i}

{xxswotrv.i "new"}
define variable ponbr  like po_nbr.
define variable wolot  like wo_lot.
define variable part   like pt_part.
define variable loc    like loc_loc.
define variable vdloc  like loc_loc.
define variable v_sel  as   logical initial no.
define variable icsite like si_site.
define variable vdsite like si_site.
define variable fname  as   character.
define variable qopen  like wod_qty_all.
define variable fstat  as   character.
define variable tstat  as   character.
/* DISPLAY SELECTION FORM */
form ponbr colon 30
     wolot colon 30
     part  colon 30 skip(1)
     loc   colon 30 icsite
     vdloc colon 30 vdsite skip(1)
     v_sel colon 30 label "sel"
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

form tpwi_sel     column-label "sel"
     tpwi_po      colon 6
     tpwi_lot     colon 18
     tpwi_part    colon 28
     tpwi_um      colon 48 format "x(2)"
     tpwi_qty_on  colon 50
     tpwi_qty_loc colon 64
     tpwi_desc1   colon 1 format "x(34)"
     tpwi_null    colon 48   label ""
     tpwi_qty_tr  colon 50
     tpwi_eff_dte colon 64
With frame selectwod no-validate with title color
normal(getFrameTitle("SUBCONTRACT_WOD_TRAN",30)) 8 down width 80.
setFrameLabels(frame selectwod:handle).

find first icc_ctrl no-lock where icc_domain = global_domain.
if available icc_ctrl then do:
   assign icsite = icc_site
          vdsite = icc_site.
end.

function getLocStat returns character(isite as character,iloc as character):
   define variable vstat as character.
   find first loc_mstr where loc_domain = global_domain and loc_site = isite
          and loc_loc = iloc no-error.
   if available loc_mstr then do:
      find is_mstr no-lock where is_status = loc_status no-error.
      if available is_mstr then do:
         if is_avail then assign vstat = "Y". else assign vstat = "N".
         if is_nettable then vstat = vstat + "Y". else vstat = vstat + "N".
         if is_overissue then vstat = vstat + "Y". else vstat = vstat + "N".
      end.
   end.
   return vstat.
end function.

/* DISPLAY */
view frame a.
repeat with frame a:

   do on error undo,retry:
      update ponbr wolot part.
      /*po单和ID不可同时为空*/
      if ponbr = "" and wolot = "" then do:
         {mfmsg.i 9200 3}
         undo ,retry.
      end.
      /*po单未找到*/
      if not can-find(first po_mstr where po_domain = global_domain and
         ponbr = po_nbr) and ponbr <> "" then do:
         {mfmsg.i 343 3}
         undo ,retry.
      end.

      /*工单未找到*/
      if not can-find(first wo_mstr where wo_domain = global_domain and
         wolot = wo_lot) and wolot <> "" then do:
         {mfmsg.i 509 3}
         undo ,retry.
      end.

      /*零件不存在*/
      if not can-find(first pt_mstr where pt_domain = global_domain and
         pt_part = part) and part <> "" then do:
         {mfmsg.i 16 3}
         undo ,retry.
      end.

      /*加工单项目与采购单项目不一致*/
      if ponbr <> "" and wolot <> "" then do:
         find first pod_det no-lock where pod_domain = global_domain and
            pod_nbr = ponbr and pod_wo = wolot no-error.
         if not available pod_det then do:
            {mfmsg.i 553 3}
            undo,retry.
         end.
      end.
   end.

   ststatus = stline[2].
   status input ststatus.
   display icsite vdsite with frame a.
   find first po_mstr no-lock where po_domain = global_domain and
              po_nbr = ponbr no-error.
   if available po_mstr then do:
      find first code_mstr no-lock where code_domain = global_domain and
              code_fldname = "SUPPLIER_LOCATION" and code_value = po_vend
              no-error.
      if available code_mstr then do:
           display code_cmmt @ vdloc with frame a.
           assign vdloc.
      end.
   end.
   do on error undo, retry:
      update loc vdloc.
      if loc = "" or not can-find(first loc_mstr where loc_domain =
         global_domain and loc_site = icsite and loc_loc = loc) then do:
         {mfmsg.i 709 3}
         apply "entry":U to loc.
         undo,retry.
      end.
      if vdloc = "" or not can-find(first loc_mstr where loc_domain =
         global_domain and loc_site = vdsite and loc_loc = vdloc) then do:
         {mfmsg.i 9202 3}
         APPLY "entry":U TO vdloc in frame a.
         undo,retry.
      end.
   end.
   do on error undo,retry:
      update v_sel.
   end.
   scroll_loopb:
   do on error undo,retry:
      empty temp-table tmp_powoin no-error.
      for each pod_det no-lock where pod_domain = global_domain and
              (pod_nbr = ponbr or ponbr = "") and
              (pod_part = part or part = ""):
          for each wod_det no-lock where wod_domain = global_domain and
              (wod_lot = pod_wo and (wod_lot = wolot or wolot = ""))
              and wod_qty_req - wod__dec01 <> 0:
              find first pt_mstr no-lock where pt_domain = global_domain
                 and pt_part = wod_part no-error.
              for each ld_det no-lock where ld_domain = global_domain
                   and ld_site = icsite and ld_loc = loc
                   and ld_part = wod_part:
                   accumulat ld_qty_oh(total).
              end.
              if wod_qty_req >= 0
              then
                 qopen = max(0, wod_qty_req - max(wod_qty_iss,0)).
              else
                 qopen = min(0, wod_qty_req - min(wod_qty_iss,0)).
              create tmp_powoin.
              assign tpwi_sel     = "*" when v_sel
                     tpwi_po      = pod_nbr
                     tpwi_podline = pod_line
                     tpwi_lot     = wod_lot
                     tpwi_part    = wod_part
                     tpwi_um      = pt_um
                     tpwi_fsite   = icsite
                     tpwi_floc    = loc
                     tpwi_tsite   = vdsite
                     tpwi_tloc    = vdloc
                     tpwi_eff_dte = today
                     tpwi_qty_loc = accum total(ld_qty_oh)
                     tpwi_qty_on  = max(0, wod_qty_req - max(wod__dec01,0))
                     tpwi_qty_tr  = max(0, wod_qty_req - max(wod__dec01,0)).
               if pt_desc2 = "" then tpwi_desc1   = trim(pt_desc1).
               else tpwi_desc1 = trim(pt_desc1) + " " + trim(pt_desc2).
          end.
      end. /*for each pod_det*/
      {xxswosel.i
         &detfile      = tmp_powoin
         &scroll-field = tpwi_po
         &framename = "selectwod"
         &framesize = 8
         &selectd   = yes
         &sel_on    = ""*""
         &sel_off   = tpwi_um
         &display1  = tpwi_sel
         &display2  = tpwi_po
         &display3  = tpwi_lot
         &display4  = tpwi_part
         &display5  = tpwi_um
         &display6  = tpwi_qty_on
         &display7  = tpwi_qty_loc
         &display8  = tpwi_desc1
         &display9  = tpwi_null
         &displaya  = tpwi_qty_tr
         &displayb  = tpwi_eff_dte
         &include2  = "update tpwi_qty_tr tpwi_eff_dte with frame selectwod."
         &exitlabel = scroll_loopb
         &exit-flag = "true"
         &record-id = recid(tmp_powoin)
         }
         setFrameLabels(frame selectwod:handle).
         if keyfunction(lastkey) = "END-ERROR" then do:
            hide frame selectwod.
            undo scroll_loopb, retry scroll_loopb.
         end.
   end.
   for each tmp_powoin exclusive-lock where tpwi_sel = "" or tpwi_qty_tr = 0:
       delete tmp_powoin.
   end.
   for each tmp_powoin no-lock with frame xx title color
   normal(getFrameTitle("TRANSFER_DETAIL",30)):
       display tpwi_po tpwi_part tpwi_qty_loc tpwi_qty_tr
               tpwi_floc tpwi_tloc.
       setFrameLabels(frame xx:handle).
   end.
   if not can-find(first tmp_powoin) then do:
      {mfmsg.i 1310 3}
      undo,retry.
   end.
   assign v_sel = no.
   {mfmsg01.i 9201 2 v_sel}
   if v_sel then do:
      assign fname = "xxswotr.p" + string(today,"99999999")
                   + string(time) + ".cim".
      output to value(fname).
      for each tmp_powoin no-lock where tpwi_sel = "*" and tpwi_qty_tr <> 0:
          assign fstat = getLocStat(tpwi_fsite,tpwi_floc)
                 tstat = getLocStat(tpwi_tsite,tpwi_tloc).
          put unformat '"' tpwi_part '"' skip.
          put unformat tpwi_qty_tr ' "' tpwi_eff_dte '" '.
          put unformat '"' tpwi_lot '" "' tpwi_po '"' skip.
          put unformat '"' tpwi_fsite '" "' tpwi_floc '"' skip.
          put unformat '"' tpwi_tsite '" "' tpwi_tloc '"' skip.
          if fstat <> tstat then do:
          put unformat 'yes' skip.
          end.
          put unformat 'yes' skip "." skip.
      end.
      output close.

      batchrun  = yes.
      input from value(fname).
      output to value(fname + ".out") keep-messages.
      hide message no-pause.
      {gprun.i ""iclotr02.p""}
      hide message no-pause.
      output close.
      input close.
      batchrun  = no.
      os-delete value(fname).
      os-delete value(fname + ".out").

      for each tmp_powoin exclusive-lock where tpwi_sel = "*":
          if can-find (first tr_hist no-lock where tr_nbr = tpwi_lot and
                tr_type = "iss-tr" and tr_effdate = tpwi_eff_dte and tr_nbr =
                tpwi_lot and tr_so_job = tpwi_po and tr_part = tpwi_part and
                tr_qty_loc = tpwi_qty_tr * -1) and
             can-find (first tr_hist no-lock where tr_nbr = tpwi_lot and
                tr_type = "rct-tr" and tr_effdate = tpwi_eff_dte and tr_nbr =
                tpwi_lot and tr_so_job = tpwi_po and tr_part = tpwi_part and
                tr_qty_loc = tpwi_qty_tr )  then do:
             assign tpwi_stat = yes.
             /*record trans qty to wod__dec01*/
             find first wod_det exclusive-lock where wod_domain = global_domain
                 and wod_lot = tpwi_lot and wod_part = tpwi_part no-error.
             if available wod_det then do:
                   assign wod__dec01 = wod__dec01 + tpwi_qty_tr.
             end.
          end.
      end.
      hide frame rpt.
/*      for each tmp_powoin no-lock with frame xy title color                */
/*      normal(getFrameTitle("TRANSFER_DETAIL_RETURN",30)):                  */
/*          display tpwi_part tpwi_qty_loc tpwi_qty_tr                       */
/*                  tpwi_floc tpwi_tloc tpwi_stat with stream-io.            */
/*          setFrameLabels(frame xy:handle).                                 */
/*      end.                                                                 */
   end.
end.
if can-find(first tmp_powoin no-lock where tpwi_sel = "*" and tpwi_stat) then
{gprun.i ""xxswotrrp.p""}
status input.