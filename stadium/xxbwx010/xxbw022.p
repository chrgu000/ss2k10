/*V8:ConvertMode=Maintenance                                                  */
{mfdtitle.i "120918.1"}
define variable yn like mfc_logical no-undo.
{gpcdget.i "UT"}

Form yn colon 40
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

repeat with frame a:
update yn.
if not yn then leave.
 for each vp_mstr exclusive-lock where vp_mfgr <> "":
     find first ad_mstr no-lock where ad_addr = vp_mfgr
            and ad_type = "supplier" no-error.
     if available ad_mstr then do:
           assign vp__chr02 = ad_name.
     end.
  end.
       pause.
       {mfmsg.i 1107 1}
       return.
end.  /* repeat with frame a: */
status input.
