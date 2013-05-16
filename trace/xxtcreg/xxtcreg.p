/* xxtcreg.p - tracer regester                                               */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 11YK LAST MODIFIED: 01/20/11   BY: zy check xrcpath exists      */
/* REVISION END                                                              */

/* DISPLAY TITLE */
{mfdtitle.i "11YK"}
{gplabel.i}
define variable sfile like _file-name format "x(30)"
                label "Table" no-undo initial "".
define variable fieldname like _FIELD-NAME format "x(30)"
                 label "Field" no-undo initial "".
define variable sel-all as character no-undo format "x(3)".
define variable v_sel like mfc_logical.

define temp-table tab_list
       fields tab_sel as character label "Sel" format "x(4)"
       fields tab_name like _file-name label "Table" format "x(12)"
       fields tab_fld  like _field-name label "Field" format "x(12)"
       fields tab_type as   character format "x(1)" label "T"
       fields tab_desc as   character format "x(42)" label "Description".
/* DISPLAY SELECTION FORM */
form
  sfile colon 12 view-as fill-in size 14 by 1
  fieldname view-as fill-in size 14 by 1
  sel-all
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

form tab_sel      column-label "sel"
     tab_name     colon 5
     tab_fld      colon 18
     tab_type     colon 32
     tab_desc     colon 34
With frame selfld no-validate with title color
normal(getFrameTitle("FIELD",30)) 13 down width 80.
setFrameLabels(frame selfld:handle).

view frame a.
repeat with frame a:
   do on error undo,retry:
      update sfile fieldname sel-all with frame a
          editing:
             if frame-field = "sfile" then do:
                {mfnp.i _file sfile _file-name sfile _file-name _file-name}
                if recno <> ? then do:
                   sfile = _file-name.
                   display
                      sfile
                   with frame a.
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
   display sfile with frame a.

   scroll_loopb:
   do on error undo,retry:
      empty temp-table tab_list no-error.
      if fieldname = "" then do:
         for each qaddb._File no-lock where (_FILE-NAME = sfile) :
             create tab_list.
             assign tab_name = _FILE-NAME
                    tab_type = "D"
                    tab_desc = _File._desc.
              FOR EACH _FIELD OF _FILE BY _ORDER:
                  create tab_list.
                  assign tab_name = _FILE-NAME
                         tab_fld = _FIELD-NAME
                         tab_type = "W"
                         tab_desc = _Label.
              END.
         end.
      end.
      else do:
           for each qaddb._File no-lock where (_FILE-NAME = sfile) :
               FOR EACH _FIELD OF _FILE where _FIELD-Name = fieldname:
                  create tab_list.
                  assign tab_name = _FILE-NAME
                         tab_fld = _FIELD-NAME
                         tab_type = "W"
                         tab_desc = _Label.
               END.
               FOR EACH _FIELD OF _FILE,
                   EACH tcr_reg no-lock where tcr_table = _file-name
                    and tcr_field = _field-name BY _ORDER:
                  find first tab_list exclusive-lock where tab_name = _FILE-NAME
                         and tab_fld = _FIELD-NAME no-error.
                  if not available tab_list then do:
                     create tab_list.
                     assign tab_name = _FILE-NAME
                             tab_fld = _FIELD-NAME.
                  end.
                     assign tab_sel = ""
                            tab_type = "W"
                            tab_desc = _Label.
              END.
           end.
      end.

      for each tcr_reg no-lock where tcr_tab = sFile:
          find first tab_list no-lock where tab_name = tcr_table
                and tab_fld = tcr_field no-error.
          if not available tab_list then do:
             create tab_list.
             assign tab_name = tcr_table
                    tab_fld = tcr_field.
          end.
             assign tab_sel = "*"
                    tab_type = tcr_type
                    tab_desc = tcr_memo.
      end.

      if sel-all <> "" then do:
          for each tab_list exclusive-lock:
              if sel-all = "Y" or sel-all = "Yes" then
                 assign tab_sel = "*" when tab_sel = "".
              else if sel-all = "N" or sel-all = "No" then
                 assign tab_sel = "" when tab_sel = "*".
          end.
      end.
      {swselect.i
         &detfile      = tab_list
         &scroll-field = tab_fld
         &framename    = "selfld"
         &framesize    = 13
         &selectd      = yes
         &sel_on       = ""*""
         &sel_off      = """"
         &display1     = tab_sel
         &display2     = tab_name
         &display3     = tab_fld
         &display4     = tab_type
         &display5     = tab_desc
         &exitlabel    = scroll_loopb
         &exit-flag    = "true"
         &record-id    = recid(tab_list)
         }
         setFrameLabels(frame selfld:handle).
         if keyfunction(lastkey) = "END-ERROR" or keyfunction(lastkey) = "F4"  then do:
            hide frame selfld.
            undo scroll_loopb, retry scroll_loopb.
         end.
   end.
   for each tab_list no-lock with frame xx title color
   normal(getFrameTitle("FIELD",30)):
       if tab_sel = "*" then assign v_sel = yes. else  assign v_sel = no.
       display v_sel @ tab_sel tab_name tab_fld tab_type tab_desc format "x(45)".
       setFrameLabels(frame xx:handle).
   end.
   if not can-find(first tab_list) then do:
      {mfmsg.i 1310 3}
      undo,retry.
   end.
     assign v_sel = no.
     {mfmsg01.i 12 2 v_sel}
     if v_sel then do:
        for each tab_list no-lock:
           find first tcr_reg exclusive-lock where tcr_table = tab_name
                  and tcr_field = tab_fld no-error.
           if tab_sel = "*" then do:
              if not available tcr_reg then do:
                 create tcr_reg.
                 assign  tcr_table = tab_name
                         tcr_field = tab_fld
                         tcr_type = tab_type.
              end.
                 assign  tcr_userid = global_userid
                         tcr_date = today
                         tcr_memo = tab_desc.
           end. /* if tab_sel = "*" then do: */
           else do:
                if available tcr_reg then do:
                   delete tcr_reg.
                end.
           end.
        end. /* for each tab_list no-lock:*/ 
     end. /*  if v_sel then do: */
end.
