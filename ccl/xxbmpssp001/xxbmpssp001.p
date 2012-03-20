/*xxbmpssp001.p - BOM Lock/Unlock service pack 1                              */
/*V8:ConvertMode=Maintenance                                                  */
/**/
{mfdtitle.i "120319.1"}
define variable yn like mfc_logical no-undo.
{gpcdget.i "UT"}

Form yn colon 40
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

repeat with frame a:
update yn.
if yn then do:
   find first code_mstr exclusive-lock where code_fldname = "ps__log01" 
        no-error.
   if not available code_mstr then do:
   	 create code_mstr.
   	 assign code_fldname = "ps__log01".
   end. 
   	 assign code_cmmt = "luojj,ssuser,9liusf,9tseys,liusf,9zhouxf,9liumf".
end.
else do:
	find first code_mstr exclusive-lock where code_fldname = "ps__log01"
	     no-error.
	if available code_mstr then do:
		 delete code_mstr.
  end.
end.
      {mfmsg.i 1107 1}
       pause 5.
       leave.
end.  /* repeat with frame a: */
status input.
