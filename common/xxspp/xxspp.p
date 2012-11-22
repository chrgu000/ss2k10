/* xxspp.p - set temp work Propath                                           */
/* revision: 120712.1   created on: 20120712   by: zhang yun                 */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1C04  QAD:eb21sp7    Interface:Character         */
/*-Revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "120712.1"}
define variable vkey like usrw_key1 no-undo
                  initial "TEMP-WORK-PROPATH".
define variable del-yn like mfc_logical initial no.
define variable pathcnt as integer initial 1 no-undo.
define variable bpropath as character format "x(76)"
       view-as fill-in size 60 by 1 .
/* Variable added to perform delete during CIM.
* Record is deleted only when the value of this variable
* Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.
define variable temp_pro_path as character format "x(60)" no-undo.

form
  bpropath at 2 no-label font 0
with frame b 11 down width 80 no-labels bgcolor 8.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

/* DISPLAY */
view frame b.
run dispProPath.
/* DISPLAY SELECTION FORM */
form
   usrw_key1 colon 16 format "x(20)"
   temp_pro_path colon 16 view-as fill-in size 40 by 1
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

find first usrw_wkfl where {xxusrwdom.i} {xxand.i} usrw_key1 = vkey and
           usrw_key2 = vkey no-lock no-error.
if available usrw_wkfl then do:                        
   if opsys = "UNIX" then do:
      assign temp_pro_path = usrw_key3.
   end.
   else if opsys = "msdos" or opsys = "win32" then do:
   	 assign temp_pro_path = usrw_key4.
   end.
end.
/* DISPLAY */
display temp_pro_path with frame a.
view frame a.

mainloop:
repeat with frame a:

   /* Initialize delete flag before each display of frame */
   batchdelete = "".
   display vkey @ usrw_key1.
   /* Determine length of field as defined in db schema */

   find first usrw_wkfl where {xxusrwdom.i} {xxand.i} usrw_key1 = vkey and
              usrw_key2 = vkey exclusive-lock no-error.
   if not available usrw_wkfl then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create usrw_wkfl. {xxusrwdom.i} .
      assign usrw_key1 = vkey
             usrw_key2 = vkey.
   end. /* if not available usrw_wkfl then do: */
   recno = recid(usrw_wkfl).
   if opsys = "UNIX" then do:
	    display usrw_key3 @ temp_pro_path with frame a.
	 end.
	 else if opsys = "msdos" or opsys = "win32" then do:
	 	 display usrw_key4 @ temp_pro_path with frame a.
	 end.

   update temp_pro_path batchdelete no-label when (batchrun)
          go-on(F5 CTRL-D).
   /* Delete to be executed if batchdelete is set or
    * F5 or CTRL-D pressed */
    
    FILE-INFO:FILE-NAME = input temp_pro_path.
    IF FILE-INFO:FILE-TYPE = ? THEN DO:
         {mfmsg.i 3679 3}
         undo, retry.
    END.
		if index(propath,input temp_pro_path) > 0 then do:
       assign propath = replace(propath,temp_pro_path + ",","").
    end.
    if index(propath,input temp_pro_path) = 0 then do:
       assign propath = temp_pro_path + "," + propath.
       {mfmsg.i 5792 1}
    end.
		find first usrw_wkfl exclusive-lock where recid(usrw_wkfl) = recno no-error.
		if available usrw_wkfl then do:
		   if opsys = "UNIX" then do:
          assign usrw_key3 = temp_pro_path.
       end.
       else if opsys = "msdos" or opsys = "win32" then do:
       	 assign usrw_key4 = temp_pro_path.
       end.
    end.
    if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
               or input batchdelete = "x"
    then do:
      del-yn = yes.

      /* Please confirm delete */
      {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}

      if del-yn then do:
         if index(propath,input temp_pro_path) > 0 then do:
            assign propath = replace(propath,temp_pro_path + ",","").
         end.
         delete usrw_wkfl.
         {mfmsg.i 5792 1}
         clear frame a.
      end. /* if del-yn then do: */
   end. /* if lastkey = keycode("F5") then do: */

end.

status input.

procedure dispProPath.
    define variable i as integer.
    hide frame b no-pause.
    do i = 1 to 10:
       assign bpropath =  entry(i,propath,",") no-error.
       if bpropath <> "" then do:
          display bpropath with frame b.
          down 1 with frame b.
       end.
    end.
end.