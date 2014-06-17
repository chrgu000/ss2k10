/* xxpkltr3.p - Unplan issue from assembline                                 */
/* REVISION: 9.0 LAST MODIFIED: 05/14/14               BY: zy *SS-20140514.1 */
/*****************************************************************************
 * 转仓,退仓,报废的流程如下：
 * 1.转仓(只能在状态是空时才能做,做完转仓后状态为I,只能做退仓)
 * 2.退仓(只能在转仓之后状态为I时才能做,做完退仓后状态为R,只能做报废)
 * 3.报废(只能在退仓之后状态为R时才能做,做完报废后,这张单的状态变为C,
 *           不能再做转仓;退仓;报废中的任何动作.)
*****************************************************************************/
{mfdtitle.i "140530.1"}

define variable site  like ld_site init "PRC" no-undo.
define variable pklnbr like xxpkld_nbr no-undo.
define variable wkctr like xxpklm_wkctr no-undo.
define variable rknbr as char format "x(8)" no-undo.
define variable vqty  like xxpkld_qty_req no-undo.
define variable stat  as character format "x(1)" no-undo.
define variable i  as integer no-undo.
define variable fn as character no-undo.
define variable yn AS logical no-undo.
define variable sl as logical no-undo.
define variable acct LIKE pl_flr_acct no-undo.
define variable cc   LIKE pl_flr_CC no-undo.
define variable trrecid as recid no-undo.
define stream bf.
{xxpkltr0.i "new"}

form
  pklnbr colon 8 label "领料单" format "x(16)"
  stat   label "状态"
  wkctr  no-label
  rknbr  label "报废单"
  acct   colon 8 label "ACCT"
  cc     colon 32 label "CC"
  sl     colon 72 label "全选"
with frame a side-labels width 80 attr-space.


/* DISPLAY SELECTION FORM */
form
  tt1_sel          column-label "选"
  tt1_seq          column-label "项次"
  tt1_part         column-label "物料"
  tt1_loc_to       column-label "库位"
  tt1_qty1         column-label "报废量"
  tt1_qty_oh       column-label "库存量"
  tt1_qty_iss      column-label "调入量"
with frame c width 80 no-attr-space 12 down scroll 1.
/* DISPLAY SELECTION FORM */
form
  tt1_seq      column-label "项次"
  tt1_part     column-label "物料"
  tt1_loc_to   column-label "库位"
  tt1_qty1     column-label "报废量"
  tt1_qty_oh   column-label "库存量"
  tt1_qty_iss  column-label "调入量"
  tt1_chk      column-label "结果"
with frame d width 80 no-attr-space 12 down scroll 1.
find first pl_mstr no-lock no-error.
if available pl_mstr then do:
   assign acct = pl_flr_acct
            cc = pl_flr_cc.
end.
view frame a.
display pklnbr stat wkctr rknbr acct cc sl with frame a.

find first icc_ctrl where no-lock no-error.
if avail icc_ctrl then site = icc_site.
find first icc_ctrl where no-lock no-error.
     if available icc_ctrl then assign site = icc_site.
mainloop:
repeat with frame a:
  /* clear frame a all no-pause. */
    do on error undo,retry:
       prompt-for pklnbr editing:
           /* FIND NEXT/PREVIOUS RECORD */
         if frame-field = "pklnbr" then do:
            {mfnp05.i xxpklm_mstr xxpklm_index1 " yes " xxpklm_nbr "input pklnbr"}
            clear frame c.
            hide frame c.
            if recno <> ? then do:
                 assign wkctr = xxpklm_wkctr
                        stat = xxpklm_stat.
                 display stat xxpklm_nbr @ pklnbr wkctr.
                   find first xxpkld_det no-lock where xxpkld_nbr = pklnbr no-error.
                 if available xxpkld_det then do:
                    find pt_mstr no-lock where pt_part = xxpkld_part no-error.
                    if available pt_mstr  then do:
                       find first pl_mstr no-lock where pl_prod_line = pt_prod_line no-error.
                       if available pl_mstr then do:
                          if pt_iss_pol = no then do:
                             assign acct = pl_flr_acct
                                      cc = pl_flr_cc.
                          end.
                          else do:
                             assign acct = pl_cop_acct
                                      cc = pl_cop_cc.
                          end.
                       end. /* if available pl_mstr then do: */
                    end.    /* if available pt_mstr  then do: */
                 end.
            end.
         end.
         else do:
              readkey.
              apply lastkey.
         end.
       end. /* editing: */
    end.
  assign pklnbr .
  for each tt1 exclusive-lock where tt1_pkl <> pklnbr:  delete tt1. end.
  find xxpklm_mstr where xxpklm_nbr = pklnbr no-lock no-error.
  if available xxpklm_mstr then do:
     display xxpklm_nbr @ pklnbr xxpklm_wkctr @ wkctr.
     assign pklnbr wkctr.
  end.
  else do:
      message "领料单不存在,请重新输入!" .
      undo,retry  mainloop.
  end.
  if trim(xxpklm_status) <> "R" then do:
      message "领料单状态 " trim(xxpklm_status) ", 不能报废!" .
      undo,retry  mainloop.
  end.
   clear frame c.
   hide frame c.


  display rknbr acct cc sl with frame a.

   ststatus = stline[2].
   status input ststatus.
   do on error undo,retry:
      update rknbr acct cc sl.
      if rknbr = "" then do:
         message "报废单号不允许为空".
         next-prompt rknbr.
         undo,retry.
      end.
      if acct = "" then do:
         message "账户不允许为空".
         next-prompt acct.
         undo,retry.
      end.
      else do:
         find first ac_mstr no-lock where ac_code = acct no-error.
         if not available ac_mstr then do:
            message "账户不存在".
            next-prompt acct.
            undo,retry.
         end.
      end.
      if cc = "" then do:
         message "成本中心不允许为空".
         next-prompt cc.
         undo,retry.
      end.
      else do:
           find first cc_mstr no-lock where cc_ctr = cc no-error.
           if not available cc_mstr then do:
              message "成本中心不存在".
              next-prompt cc.
              undo,retry.
           end.
      end.
   end.
    for each xxpkld_det where xxpkld_nbr = pklnbr and xxpkld__chr01 = "R" no-lock by xxpkld_line:
       assign vqty = xxpkld_qty_iss.
       if vqty = 0 then next.
       lddetlabel:
       for each ld_det no-lock use-index ld_part_lot where
                ld_part = xxpkld_part and ld_site = site and
                ld_loc = wkctr and ld_qty_oh > 0:
              create tt1.
              assign tt1_sel = "*" when sl
                     tt1_seq = xxpkld_line
                     tt1_pkl = xxpkld_nbr
                     tt1_rknbr = rknbr
                     tt1_part = xxpkld_part
                     tt1_desc1 = xxpkld_desc
                     tt1_qty1 = 0 /* min(vqty,ld_qty_oh,xxpkld_qty_iss - xxpkld_qty_rej) */ /*默认退料拨量*/
                     tt1_qty_oh = ld_qty_oh
                     tt1_qty_req = vqty /*最大需求量*/
                     tt1_loc_to = xxpkld_loc_from
                     tt1_qty_iss = xxpkld_qty_iss
                     tt1_loc_from = ld_loc
                     tt1_site = ld_site
                     tt1_lot = ld_lot
                     tt1_ref = ld_ref
                     tt1_stat = ld_stat
                     tt1_recid =  recid(xxpkld_det).
            if vqty >= min(vqty,ld_qty_oh,xxpkld_qty_iss - xxpkld_qty_rej)
                   then assign vqty = vqty - min(vqty,ld_qty_oh,xxpkld_qty_iss - xxpkld_qty_rej).
                   else assign vqty = 0.
       end. /* for each ld_det */
   end. /* for each xxpkld_det */
   view frame c.
    scroll_loopb:
    do on error undo,retry:
        {xxswosel.i
         &detfile      = tt1
         &scroll-field = tt1_sel
         &framename = "c"
         &framesize = 12
         &selectd   = yes
         &sel_on    = ""*""
         &sel_off   = """"
         &display1  = tt1_sel
         &display2  = tt1_seq
         &display3  = tt1_part
         &display4  = tt1_loc_to
         &display5  = tt1_qty1
         &display6  = tt1_qty_oh
         &display7  = tt1_qty_iss
         &include2  = "{xxpkltr20.i}"
         &exitlabel = scroll_loopb
         &exit-flag = "true"
         &record-id = recid(tt1)
         }
         if keyfunction(lastkey) = "END-ERROR" then do:
            hide frame c.
            undo scroll_loopb, retry scroll_loopb.
         end.
   end.
   yn = yes.
   if not can-find(first tt1 where tt1_sel = "*") then do:
      {mfmsg.i 1310 3}
      undo,retry.
   end.
   assign yn = yes.
   {mfmsg01.i 12 2 yn}
   if yn then do:
      {xxpkltr3t.i}
   end. /* IF YN */
      for each tt1 no-lock where tt1_sel = "*" and tt1_chk = "ok"
                        break by tt1_recid:
          if first-of(tt1_recid) then do:
             assign vqty = 0.
          end.
          assign vqty = tt1_qty1.
          if last-of(tt1_recid) then do:
             find first xxpkld_det exclusive-lock where
                  recid(xxpkld_det) = tt1_recid no-error.
             if available xxpkld_det then do:
                assign xxpkld_qty_rej = xxpkld_qty_rej + vqty
                       xxpkld__chr01 = "C".
                find first xxpklm_mstr exclusive-lock
                     where xxpklm_nbr = xxpkld_nbr no-error.
                if available xxpklm_mstr then do:
                       assign xxpklm_stat = "C".
                end.
             end.
          end.
      end.
      for each tt1 no-lock where tt1_sel = "*" and tt1_qty1 > 0 with frame d:
          display tt1_seq
                  tt1_part
                  tt1_loc_to
                  tt1_qty1
                  tt1_qty_oh
                  tt1_qty_iss
                  tt1_chk.
                  down.
      end.
end. /* repeat with frame a: */
