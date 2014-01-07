/*V8:ConvertMode=Maintenance                                                 */
/* REVISION END                                                              */

/* DISPLAY TITLE */
{mfdtitle.i "130720.1"}
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

define temp-table tab_list
       fields tab_sel     as character label "sl" format "x(2)"
       fields tab_part    like pt_part
       fields tab_site    like pt_site
       fields tab_dsgngrp like pt_dsgn_grp
       fields tab_desc1   like pt_desc1
       fields tab_pm      like pt_pm_code
       fields tab_um      like pt_um
       fields tab_draw    like pt_draw
       fields tab_added   like pt_added
       fields tab_stat    like pt_stat.
/* DISPLAY SELECTION FORM */
form
  part    colon 16 part1    colon 40 label {t001.i}
  added   colon 16 added1   colon 40 label {t001.i}
  dsgngrp colon 16 dsgngrp1 colon 40 label {t001.i}
  stat    colon 16 stat1    colon 40 label {t001.i}
  sel-all colon 20
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

form  tab_sel     column-label "sl"
      tab_part    colon 3
      tab_site    colon 22
      tab_dsgngrp colon 31
      tab_pm      colon 39
      tab_um      colon 42
      tab_draw    colon 45
      tab_added   colon 64
      tab_stat    colon 1
      tab_desc1   colon 10
With frame selitem no-validate with title color
normal(getFrameTitle("DETAIL",30)) 7 down width 80.
setFrameLabels(frame selitem:handle).

view frame a.
repeat with frame a:
   do on error undo,retry:
      update part part1 added added1 dsgngrp dsgngrp1 stat stat1 sel-all with frame a
          editing:
             if frame-field = "part" then do:
                {mfnp.i xapt_aud part xapt_part part xapt_part xapt_part}
                if recno <> ? then do:
                   display xapt_part @ part with frame a.
                end.
             end.
             else if frame-field = "part1" then do:
                {mfnp.i xapt_aud part1 xapt_part part1 xapt_part xapt_part}
                if recno <> ? then do:
                   display xapt_part @ part1 with frame a.
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
      for each xapt_aud no-lock where xapt_part >= part and (xapt_part <= part1 or part1 = "")
               and (xapt_added >= added or added = ?) and (xapt_added <= added1 or added1 = ?)
               and xapt_pmc_date <> ? and xapt_pur_date <> ? and xapt_eng_date <> ?
               and xapt_doc_date <> ? and xapt_fin_date <> ? and xapt_stat <> "C",
          each pt_mstr no-lock where pt_part = xapt_part
           and pt_dsgn_grp >= dsgngrp and (pt_dsgn_grp >= dsgngrp1 or dsgngrp1 = "")
           and pt_stat >= stat and (pt_stat <= stat1 or stat1 = ""):
              create tab_list.
              assign tab_sel = if sel-all then "*" else ""
                     tab_part = pt_part
                     tab_site = pt_site
                     tab_dsgngrp = pt_dsgn_grp
                     tab_desc1 = pt_desc1
                     tab_pm = pt_pm_code
                     tab_um = pt_um
                     tab_draw = pt_draw
                     tab_added = pt_added
                     tab_stat = pt_stat.
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
        for each tab_list exclusive-lock where tab_sel = "*":
            output to value(tab_part + ".bpi").
               put unformat '"' tab_part '"' skip.
               put unformat '-' skip.
               put unformat '- - - - - AC' skip.
            output close.
            
            batchrun = yes.
            input from value(tab_part + ".bpi").
            output to value(tab_part + ".bpo").
            {gprun.i ""ppptmt04.p""}
            output close.
            input close.
            batchrun = no.
            find first pt_mstr no-lock where tab_part = pt_part no-error.
            if available pt_mstr then do:
               assign tab_stat = pt_stat.
               if pt_stat = "AC" then do:
                  find first xapt_aud exclusive-lock where xapt_part = tab_part. 
                       if available xapt_aud then do:
                          assign xapt_adm_date = today
                                 xapt_adm_days = today - xapt_added
                                 xapt_adm_user = global_userid
                                 xapt_stat = "C".
                          os-delete value(tab_part + ".bpi").
                          os-delete value(tab_part + ".bpo").
                       end.
               end.
            end.
        end.
     end. /*  if v_sel then do: */
  end.
     for each tab_list no-lock where tab_sel = "*" with frame x width 80:
         display tab_part
                 tab_stat
                 tab_site
                 tab_dsgngrp
                 tab_pm
                 tab_um
                 tab_draw
                 tab_added 
                 tab_desc1.
          setframelabels(frame x:handle).
     end.
end.
