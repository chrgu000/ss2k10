/*V8:ConvertMode=Maintenance                                                 */
/* REVISION END                                                              */

/* DISPLAY TITLE */
{mfdtitle.i "131021.1"}
define variable part     like pt_part.
define variable part1    like pt_part.
define variable added    like pt_added.
define variable added1   like pt_added.
define variable dsgngrp  like pt_dsgn_grp.
define variable dsgngrp1 like pt_dsgn_grp.
define variable stat     like pt_stat initial "new".
define variable stat1    like pt_stat initial "new".
define variable sel-all  like mfc_logical.
define variable v_sel    like mfc_logical.
define variable vpt1     as   character.
define temp-table tab_list
       fields tab_sel     as character label "sl" format "x(2)"
       fields tab_part    like pt_part
       fields tab_site    like pt_site
       fields tab_dsgngrp like pt_dsgn_grp
       fields tab_desc1   like pt_desc1
       fields tab_pm      like pt_pm_code
       fields tab_um      like pt_um
       fields tab_draw    like pt_draw
       fields tab_added   like pt_added.
/* DISPLAY SELECTION FORM */
form
  part    colon 16 part1    colon 40 label {t001.i}
  added   colon 16 added1   colon 40 label {t001.i}
  dsgngrp colon 16 dsgngrp1 colon 40 label {t001.i}
  stat    colon 16 stat1    colon 40 label {t001.i}
  sel-all colon 20
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).
assign added = today - 7.
form  tab_sel     column-label "sl"
      tab_part    colon 3
      tab_site    colon 22
      tab_dsgngrp colon 31
      tab_pm      colon 39
      tab_um      colon 42
      tab_draw    colon 45
      tab_added   colon 64
      tab_desc    colon 3
With frame selitem no-validate with title color
normal(getFrameTitle("DETAIL",30)) 7 down width 80.
setFrameLabels(frame selitem:handle).

view frame a.
repeat with frame a:
   do on error undo,retry:
      update part part1 added added1 dsgngrp dsgngrp1 stat stat1 sel-all with frame a
          editing:
             if frame-field = "part" then do:
                {mfnp.i pt_mstr part pt_part part pt_part pt_part}
                if recno <> ? then do:
                   display pt_part @ part with frame a.
                end.
             end.
             else if frame-field = "part1" then do:
                {mfnp.i pt_mstr part1 pt_part part1 pt_part pt_part}
                if recno <> ? then do:
                   display pt_part @ part1 with frame a.
                end.
             end.
             else do:
                status input.
                readkey.
                apply lastkey.
             end.
          end.
   end.

   ststatus = stline[2].
   status input ststatus.

   scroll_loopb:
   do on error undo,retry:
      empty temp-table tab_list no-error.
      for each pt_mstr no-lock where pt_part >= part and (pt_part <= part1 or part1 = "")
           and (pt_added >= added or added = ?) and (pt_added <= added1 or added1 = ?)
           and pt_dsgn_grp >= dsgngrp and (pt_dsgn_grp >= dsgngrp1 or dsgngrp1 = "")
           and pt_stat >= stat and (pt_stat <= stat1 or stat1 = ""):
           find first xapt_aud no-lock where xapt_part = pt_part no-error.
           if not available xapt_aud then do:
              create tab_list.
              assign tab_sel = if sel-all then "*" else ""
                     tab_part = pt_part
                     tab_site = pt_site
                     tab_dsgngrp = pt_dsgn_grp
                     tab_desc1 = pt_desc1
                     tab_pm = pt_pm_code
                     tab_um = pt_um
                     tab_draw = pt_draw
                     tab_added = pt_added.
           end.
      end.
      {swselect.i
         &detfile      = tab_list
         &scroll-field = tab_part
         &framename    = "selitem"
         &framesize    = 7
         &selectd      = yes
         &sel_on       = ""*""
         &sel_off      = """"
         &display1     = tab_sel
         &display2     = tab_part
         &display3     = tab_site
         &display4     = tab_dsgngrp
         &display5     = tab_desc1
         &display6     = tab_pm
         &display7     = tab_um
         &display8     = tab_draw
         &display9     = tab_added
         &exitlabel    = scroll_loopb
         &exit-flag    = "true"
         &record-id    = recid(tab_list)
         }
         setFrameLabels(frame selitem:handle).
         if keyfunction(lastkey) = "END-ERROR" or keyfunction(lastkey) = "F4"  then do:
            hide frame selitem.
            undo scroll_loopb, retry scroll_loopb.
         end.
   end.

   if not can-find(first tab_list where tab_sel = "*") then do:
      {mfmsg.i 1310 3}
      undo,retry.
   end.
   else do:
     assign v_sel = yes.
     {mfmsg01.i 12 2 v_sel}
     if v_sel then do:
        for each tab_list no-lock:
            find first xapt_aud no-lock where xapt_part = tab_part no-error.
            if not available xapt_aud then do:
               create xapt_aud.
               assign xapt_part = tab_part
                      xapt_added = today
                      xapt_stat = "N".
/*802*********************************************************************
4.0----0 至 4字頭以及80字頭料號，R&D確認/工藝確認不需維護,確認欄位默認為"Y"(排除3411字头)。
4.1---物料編碼為"Q"字頭的:R&D/工藝/PMC三個部門不需維護,確認欄位默認為"Y",只需採購/財務二個部門維護.
4.2--- 5字頭、6字頭，7字頭，9字頭不需採購維護，採購確認欄位默認為"Y。
4.3--A至Z字頭（除Q字頭外）不需採購維護，採購確認欄位默認為"Y。
4.4 --8字頭（除80開頭外），不需採購維護，採購確認欄位默認為"Y".
****/
/*802*/      assign vpt1 = substring(trim(tab_part),1,1).
/*802*/      if vpt1 >= "0" and vpt1 <= "4"
/*1021*/                    and not(index(vpt1,"3411") = 1)
/*802*/      then do:
/*802*/         assign xapt_eng_date = today
/*802*/                xapt_eng_days = 0
/*802*/                xapt_doc_date = today
/*802*/                xapt_doc_days = 0.
/*802*/      end.
/*802*/      else if vpt1 = "Q" then do:
/*802*/          assign xapt_eng_date = today
/*802*/                 xapt_eng_days = 0
/*802*/                 xapt_doc_date = today
/*802*/                 xapt_doc_days = 0
/*802*/                 xapt_pur_date = today
/*802*/                 xapt_pur_days = 0.
/*802*/      end.
/*802*/      else if (vpt1 >= "5" and vpt1 <= "7") or vpt1 = "9" then do:
/*802*/         assign xapt_pur_date = today
/*802*/                xapt_pur_days = 0.
/*802*/      end.
/*802*/      else if vpt1 = "8" then do:
/*802*/           if substring(trim(tab_part),1,2) = "80" then do:
/*802*/               assign xapt_eng_date = today
/*802*/                      xapt_eng_days = 0
/*802*/                      xapt_doc_date = today
/*802*/                      xapt_doc_days = 0.
/*802*/           end.
/*802*/           else do:
/*802*/                assign xapt_pur_date = today
/*802*/                       xapt_pur_days = 0.
/*802*/           end.
/*802*/      end.
/*802*/      else if vpt1 >= "A" and vpt1 <= "Z" and vpt1 <> "Q" then do:
/*802*/           assign xapt_pur_date = today
/*802*/                  xapt_pur_days = 0.
/*802*/      end.
            end.  /* if not available xapt_aud then do: */
        end. /* for each tab_list */
     end. /*  if v_sel then do: */
  end.
     for each tab_list no-lock  where tab_sel = "*" with frame x width 80:
         display  tab_part
                  tab_site
                  tab_dsgngrp
                  tab_pm
                  tab_um
                  tab_draw
                  tab_added.
          down.
          display tab_desc1 @ tab_part.
          setframelabels(frame x:handle).
     end.
end.
