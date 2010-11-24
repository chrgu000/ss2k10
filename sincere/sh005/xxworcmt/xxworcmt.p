/* xxworcmt.p -- 进仓单开单                                                  */
/* Copyright 2010 SoftSpeed gz                                               */
/* SS - 101115.1 By: zhangyun                                                */
/* REVISION: 09$5 LAST MODIFIED: 09/20/10   BY: zy                           */
/* REVISION: 0A$1 LAST MODIFIED: 10/11/10   BY: zy                           */
/* REVISION: 0A$2 LAST MODIFIED: 10/26/10   BY: zy                           */
/* REVISION: 0BYI LAST MODIFIED: 11/18/10   BY: zy add expir ctrl         *bi*/
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */

{mfdtitle.i "101115.1"}
{gplabel.i}

&SCOPED-DEFINE xxworcmt_b_1 "Sel"
&SCOPED-DEFINE xxworcmt_c_1 "Item"

define variable v_wof like wo_nbr.
define variable v_wot like wo_nbr.
define variable v_idf like wo_lot.
define variable v_idt like wo_lot.
define variable v_sel  as logical initial yes.
define variable vi     as integer.
/*temp-table*/

/*xxworcmtsel.i variable list*/
define variable sym              as character.
define variable sw_new           as character.
define variable sw_i             as integer.
define variable sw_first_display as logical.
define variable sw_found_recs    as logical.
define variable sw_recid         as recid.
define variable sw_temp_recid    as recid.
define variable sw_frame_recid   as recid extent 25.
define variable sw_temp_new      like sw_new.
define variable ifui as logical.

{xxworcmt.i "new"}

form {xxworcfa.i} with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

form  tw_sel label {&xxworcmt_b_1}
      tw_wo
      tw_id
      tw_part
      tw_qty_ord
      tw_qty_comp
      tw_desc1
      tw_desc2
with frame b title color normal(getFrameTitle("OPEN_WO_DATA_SEL",30)) width 80.
/* attr-space */
setFrameLabels(frame b:handle).

form tw_line label {&xxworcmt_c_1}
     tw_id
     tw_part
     tw_qty_ord
     tw_qty_comp
     tw_qty_open
     tw_site
     tw_loc
     tw_ass_nbr
     tw_desc1
     tw_desc2
with frame c title color normal(getFrameTitle("OPEN_WO_DATA_CHG",30)) width 80.
setFrameLabels(frame c:handle).

hide frame b no-pause.
hide frame c no-pause.

if v_wot = hi_char then assign v_wot = "".
if v_idt = hi_char then assign v_idt = "".
display v_sel v_wof v_type v_nbr with frame a.

/*bi*/ DEFINE VARIABLE vdays AS INTEGER.
/*bi*/ DEFINE VARIABLE vLicCode as character.
/*bi*/ {gprunp.i "xxexctrl" "P" "setExpirDate" "(input date(11,12,2010))"}
/*bi*/ {gprunp.i "xxexctrl" "P" "getExpirDays" "(input today,output vdays)"}
/*bi*/ {gprunp.i "xxexctrl" "P" "getLicenseCode" "(output vLicCode)"}
/*bi*/ if vdays < 0 then do:
/*bi*/   {pxmsg.i &MSGNUM=9211 &MSGARG1=vLicCode &ERRORLEVEL=4}
/*bi*/ end.
/*bi*/ else if vdays <= 5 then do:
/*bi*/   {pxmsg.i &MSGNUM=9210 &MSGARG1=vLicCode &MSGARG2=vdays &ERRORLEVEL=2}
/*bi*/ end.

mainloop:
repeat:

   do on error undo, retry: /* retry 1 */
      update v_wof v_wot v_idf v_idt with frame a.
/*bi*/ if vdays < 0 then do:
/*bi*/   {pxmsg.i &MSGNUM=9211 &MSGARG1=vLicCode &ERRORLEVEL=4}
/*bi*/   undo,retry.
/*bi*/ end.
      if v_wof = "" and v_idf = "" then do:
         {mfmsg.i 9100 3}
         next-prompt v_wof with frame a.
         undo,retry.
      end.
      if v_wof <> "" and v_idf <> "" then do:
         find first wo_mstr no-lock where wo_domain = global_domain
                and wo_nbr = v_wof no-error.
         if available wo_mstr then do:
            if wo_lot <> v_idf then do:
               {mfmsg.i 508 3}
               next-prompt v_idf with frame a.
               undo,retry.
            end.
         end.
      end.
      if v_wot <> "" and v_idt <> "" then do:
         find first wo_mstr no-lock where wo_domain = global_domain
                and wo_nbr = v_wot no-error.
         if available wo_mstr then do:
            if wo_lot <> v_idt then do:
               {mfmsg.i 508 3}
               next-prompt v_idt with frame a.
               undo,retry.
            end.
         end.
      end.
      if v_wot = "" then assign v_wot = hi_char.
      if v_idt = "" then assign v_idt = hi_char.
   end. /* do on error undo, retry: */ /* retry 1 */

   do on error undo, retry: /* retry 2 */
      prompt-for v_type with frame a
      editing:
         {mfnp.i xdn_ctrl v_type  " xdn_ctrl.xdn_domain = global_domain and
            xdn_type " v_type xdn_type xdn_type}
         if recno <> ? then do:
            assign v_type = xdn_type.
            display v_type with frame a.
         end.
      end. /* editing: */
      assign v_type.
      if v_type = "" then do:
          {mfmsg.i 9102 3}
          next-prompt v_idt with frame a.
          undo,retry.
      end.
      if not can-find(first xdn_ctrl no-lock
             where xdn_domain = global_domain and xdn_type = v_type)
      then do:
          {pxmsg.i &MSGNUM=9104 &MSGARG1=v_type &ERRORLEVEL=3}
          undo,retry.
      end.
   end. /*    do on error undo, retry: */ /* retry 2 */

   do on error undo,retry: /* retry 3 */
      set v_nbr with frame a.
      if v_nbr = "" then do:
         find first xdn_ctrl exclusive-lock where xdn_domain = global_domain
                and xdn_type = v_type no-error.
         if not locked(xdn_ctrl) then do:
            assign v_nbr = xdn_prev + xdn_next.
            assign xdn_next = string(integer(xdn_next) + 1,"999999").
            display v_nbr with frame a.
         end.
         else do:
            {mfmsg.i 2243 3}
            undo, retry.
         end.
         update v_nbr with frame a.
      end.
      if v_nbr <> "" then do:
         find first xdn_ctrl exclusive-lock where xdn_domain = global_domain
                and xdn_type = v_type no-error.
         if available xdn_ctrl then do:
            if substring(v_nbr,1,length(xdn_prev)) <> xdn_prev then do:
               {pxmsg.i &MSGNUM=9106 &MSGARG1=v_nbr &ERRORLEVEL=3}
               undo,retry.
            end.
         end.
      end.
   end. /*    do on error undo, retry: */ /* retry 3 */

   do on error undo,retry: /* retry 4 */
      set v_sel with frame a.
   end. /*    do on error undo, retry: */ /* retry 4 */

   do on error undo,retry: /* retry 5 */
      empty temp-table tt_wo no-error.
      for each wo_mstr no-lock where wo_domain = global_domain
           and (wo_nbr >= v_wof or v_wof = "") and wo_nbr <= v_wot
           and (wo_lot >= v_idf or v_idf = "") and wo_lot <= v_idt
           and wo_qty_ord > wo_qty_comp:
           find first pt_mstr no-lock where pt_domain = global_domain
                  and pt_part = wo_part no-error.
           if not can-find (first tt_wo where tw_wo = wo_nbr) then do:
           create tt_wo.
           assign tw_wo       = wo_nbr
                  tw_id       = wo_lot
                  tw_part     = wo_part
                  tw_qty_ord  = wo_qty_ord
                  tw_qty_comp = wo_qty_comp
                  tw_qty_open = wo_qty_ord - wo_qty_comp
                  tw_desc1    = pt_desc1
                  tw_desc2    = pt_desc2
                  tw_sel      = "*" when v_sel.
           end.
      end.
      hide frame a.
      view frame b.
      scroll_loopb:
      do with frame b:
        {xxworcmtsel.i
            &detfile = tt_wo
            &scroll-field = tw_wo
            &selectd = no
            &framename = "b"
            &framesize = 8
            &display1  = tw_sel
            &display2  = tw_wo
            &display3  = tw_id
            &display4  = tw_part
            &display5  = tw_qty_ord
            &display6  = tw_qty_comp
            &display7  = tw_desc1
            &display8  = tw_desc2
            &sel_on    = ""*""
            &sel_off   = """"
            &exitlabel = scroll_loopb
            &exit-flag = true
            &record-id = recid(tt_wo)
        }

      hide frame a no-pause.
      hide frame b no-pause.
      end. /* do with frame b: */
   end. /* retry 5.*/
   assign vi = 1.
   for each tt_wo exclusive-lock:
       if tw_sel = "*" then do:
          find first pt_mstr no-lock where pt_domain = global_domain
                 and pt_part = tw_part no-error.
          assign tw_line = trim(string(vi,"->9")).
          assign vi = vi + 1.
          assign tw_site = pt_site when available pt_mstr
                 tw_loc  = pt_loc when available pt_mstr.
       end.
       else do:
            delete tt_wo.
       end.
   end.

   scroll_loopc:
   do with frame c:
      {xxworcmtsel.i
         &detfile = tt_wo
         &scroll-field = tw_sel
         &framename = "c"
         &selectd   = yes
         &framesize = 8
         &display1  = tw_line
         &display2  = tw_id
         &display3  = tw_part
         &display4  = tw_qty_ord
         &display5  = tw_qty_comp
         &display6  = tw_qty_open
         &display7  = tw_site
         &display8  = tw_loc
         &display9  = tw_ass_nbr
         &displaya  = tw_desc1
         &displayb  = tw_desc2
         &sel_on    = ""*""
         &sel_off   = """"
         &include1  = " update tw_qty_open tw_site tw_loc
                        tw_ass_nbr with frame c. "
         &exitlabel = scroll_loopc
         &exit-flag = true
         &record-id = recid(tt_wo)
        }
   end.
   hide frame a no-pause.
   hide frame b no-pause.
   hide frame c no-pause.
   if can-find (first tt_wo where tw_qty_open <> 0) then do:
      {gprun.i ""xxworcrp.p""}
   end.
   else do:
      {mfmsg.i 9110 3}
      undo,retry.
   end.
   leave.
end. /* Mainloop */

status input ststatus.
