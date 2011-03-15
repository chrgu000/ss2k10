/* xxtcgen.p - tracer program file generage     mgrnmt.p                     */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 11YK LAST MODIFIED: 01/20/11   BY: zy check xrcpath exists      */
/*-Revision end--------------------------------------------------------------*/

{mfdtitle.i "11YK"}
{xxtcgen.i}
define variable wkkey as character initial "xxtcgen.p-tracegenrecord".
define variable wkdom as character initial "xxtcgen.p-domain".
define variable yn like mfc_logical initial no.
define variable keyfield as character format "x(20)".
define variable tabname as character.
define variable tablename as character format "x(40)".
define variable file_name as character format "x(54)".
define variable filename as character format "x(54)" label "Archive File".
define variable domain as character format "x(12)".
define variable part like pt_part.
define variable site as character format "x(12)".
define variable nbr  like wo_nbr.
define variable key0 as character format "x(18)".
define variable key1 as character format "x(18)".
define variable key2 as character format "x(18)".
define variable key3 as character format "x(18)".
define variable key4 as character format "x(18)".
define variable key5 as character format "x(18)".
define variable key6 as character format "x(18)".
define variable key7 as character format "x(18)".
define variable key8 as character format "x(18)".
define variable key9 as character format "x(18)".
define variable dtrace like mfc_logical initial yes.
define variable wtrace like mfc_logical initial yes.
define variable bfldname as handle.
define variable bfld as handle.
define variable i as integer.
define variable dtfile as character.
define variable wtfile as character.
define variable vsrcfile as character.
define variable vfile as character.
define variable incdecl as integer.
define variable vcmd as character.

assign keyfield=getTermLabel("KEY_FIELD",20).
form
   tablename colon 16
   dtrace  colon 16 label "Write"
   wtrace  colon 40 label "Delete"
   file_name colon 16 skip(2)
   keyfield colon 24 no-label skip(1)
   domain colon 16    part colon 50
   site colon 16      nbr  colon 50
   key0 colon 16      key1 colon 50
   key2 colon 16      key3 colon 50
   key4 colon 16      key5 colon 50
   key6 colon 16      key7 colon 50
   key8 colon 16      key9 colon 50 skip(2)
   filename  colon 16
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

  display dtrace wtrace keyfield with frame a.

/* DISPLAY */
view frame a.
repeat with frame a:

   prompt-for tablename editing:
      {mfnp01.i qad_wkfl tablename qad_key2 wkkey
              " qad_domain = wkdom and qad_key1 " qad_index1}
      if recno <> ? then do:
         display qad_key2 @ tablename
              qad_logfld[1]    @ dtrace
              qad_logfld[2]    @ wtrace
              qad_charfld[1]   @ domain
              qad_charfld[2]   @ part
              qad_charfld[3]   @ site
              qad_charfld[4]   @ nbr
              qad_charfld1[10] @ key0
              qad_charfld1[1]  @ key1
              qad_charfld1[2]  @ key2
              qad_charfld1[3]  @ key3
              qad_charfld1[4]  @ key4
              qad_charfld1[5]  @ key5
              qad_charfld1[6]  @ key6
              qad_charfld1[7]  @ key7
              qad_charfld1[8]  @ key8
              qad_charfld1[9]  @ key9
              ""               @ filename
              with frame a.
      end.
   end.
  assign tablename dtrace wtrace domain part site nbr key0 key1
          key2 key3 key4 key5 key6 key7 key8 key9.
   if index(tablename,";") > 0 then
      assign tabname = substring(tablename,1,index(tablename,";") - 1).
   else
      assign tabname = tablename.
   if not can-find(first qaddb._file no-lock where _file-name = tabname)
       then do:
       {mfmsg.i 6098 3}
       undo,retry.
   end.
   if index(tablename,";") = 0 then do:
        assign tablename = tablename:screen-value + ";"
                         + string(today,"9999-99-99") + ";"
                         + string(time,"HH:MM:SS").
   end.
   display tablename with frame a.
   do on error undo, retry:
      update dtrace wtrace file_name.
      if not dtrace and not wtrace then do:
         message "删除/写至少要选中一项.".
         undo,retry.
      end.
   end.
   assign tablename dtrace wtrace domain part site nbr key0 key1
          key2 key3 key4 key5 key6 key7 key8 key9.
   do on error undo, retry:
      create buffer bfldname for table tabname.
      update domain part site nbr key0 key1
             key2 key3 key4 key5 key6 key7 key8 key9.

     bfld = bfldname:buffer-field(input domain) no-error.
     if bfld=? and input domain <> "" then do:
        {pxmsg.i &MSGNUM=2275 &ERRORLEVEL=3}
         next-prompt domain.
         undo, retry.
     end.

     bfld = bfldname:buffer-field(input part) no-error.
     if bfld=? and input part <> "" then do:
        {pxmsg.i &MSGNUM=2275 &ERRORLEVEL=3}
         next-prompt part.
         undo, retry.
     end.

     bfld = bfldname:buffer-field(input site) no-error.
     if bfld=? and input site <> "" then do:
        {pxmsg.i &MSGNUM=2275 &ERRORLEVEL=3}
         next-prompt site.
         undo, retry.
     end.

     bfld = bfldname:buffer-field(input nbr) no-error.
     if bfld=? and input nbr <> "" then do:
        {pxmsg.i &MSGNUM=2275 &ERRORLEVEL=3}
         next-prompt nbr.
         undo, retry.
     end.

     bfld = bfldname:buffer-field(input key0) no-error.
     if bfld=? and input key0 <> "" then do:
        {pxmsg.i &MSGNUM=2275 &ERRORLEVEL=3}
         next-prompt key0.
         undo, retry.
     end.

     bfld = bfldname:buffer-field(input key1) no-error.
     if bfld=? and input key1 <> "" then do:
        {pxmsg.i &MSGNUM=2275 &ERRORLEVEL=3}
         next-prompt key1.
         undo, retry.
     end.

     bfld = bfldname:buffer-field(input key2) no-error.
     if bfld=? and input key2 <> "" then do:
        {pxmsg.i &MSGNUM=2275 &ERRORLEVEL=3}
         next-prompt key2.
         undo, retry.
     end.

     bfld = bfldname:buffer-field(input key3) no-error.
     if bfld=? and input key3 <> "" then do:
        {pxmsg.i &MSGNUM=2275 &ERRORLEVEL=3}
         next-prompt key3.
         undo, retry.
     end.

     bfld = bfldname:buffer-field(input key4) no-error.
     if bfld=? and input key4 <> "" then do:
        {pxmsg.i &MSGNUM=2275 &ERRORLEVEL=3}
        assign key4.
         next-prompt key4.
         undo, retry.
     end.

     bfld = bfldname:buffer-field(input key5) no-error.
     if bfld=? and input key5 <> "" then do:
        {pxmsg.i &MSGNUM=2275 &ERRORLEVEL=3}
         next-prompt key5.
         undo, retry.
     end.

     bfld = bfldname:buffer-field(input key6) no-error.
     if bfld=? and input key6 <> "" then do:
        {pxmsg.i &MSGNUM=2275 &ERRORLEVEL=3}
         next-prompt key6.
         undo, retry.
     end.

     bfld = bfldname:buffer-field(input key7) no-error.
     if bfld=? and input key7 <> "" then do:
        {pxmsg.i &MSGNUM=2275 &ERRORLEVEL=3}
         next-prompt key7.
         undo, retry.
     end.

     bfld = bfldname:buffer-field(input key8) no-error.
     if bfld=? and input key8 <> "" then do:
        {pxmsg.i &MSGNUM=2275 &ERRORLEVEL=3}
         next-prompt key8.
         undo, retry.
     end.

     bfld = bfldname:buffer-field(input key9) no-error.
     if bfld=? and input key9 <> "" then do:
        {pxmsg.i &MSGNUM=2275 &ERRORLEVEL=3}
         next-prompt key9.
         undo, retry.
     end.

   end.
   assign tablename dtrace wtrace domain part site nbr key0 key1
          key2 key3 key4 key5 key6 key7 key8 key9.

   ststatus = stline[2].
   status input ststatus.
   yn = yes.
   {pxmsg.i &MSGNUM = 2000 &ERRORLEVEL=1 &CONFIRM=yn}
   if not yn then undo,retry.
        assign dtfile = getTrigname(input tabname,input "d") when dtrace
               wtfile = getTrigname(input tabname,input "w") when wtrace.
        if dtfile = "" and dtrace then do:
           if getConnCount() > 1 then do:
              message "连接数超过限制,此操作必须在单用户模式下执行." .
              undo,retry.
           end.
           run createTrigRecord(input tabname,input "d",output i).
           if i <> 0 then do:
              message i "写记录错误!请联系系统管理员!".
              undo,retry.
           end.
        end.
        if wtfile = "" and wtrace then do:
           if getConnCount() > 1 then do:
              message "连接数超过限制,此操作必须在单用户模式下执行." .
              undo,retry.
           end.
           run createTrigRecord(input tabname,input "w",output i).
           if i <> 0 then do:
              message i "写记录错误!请联系系统管理员!".
              undo,retry.
           end.
        end.
        assign dtfile = "" wtfile = "" filename = "".
        assign dtfile = getTrigname(input tabname, input "d") when dtrace
               wtfile = getTrigname(input tabname, input "w") when wtrace.
        assign dtfile = substring(dtfile,1,index(dtfile,".")) + "t" when dtrace
               wtfile = substring(wtfile,1,index(wtfile,".")) + "t" when wtrace.
  assign filename = dtfile when dtfile <> "".
  if filename = "" then assign filename = wtfile.
  else assign filename = filename + ";" + wtfile when wtfile <> "".
  display file_name @ filename with frame a.
  if dtfile <> "" then do:
     os-delete value(dtfile) no-error.
     assign vsrcfile = getSrcDir().
     if vsrcfile <> "" then assign vsrcfile = vsrcfile + "/".
     assign vsrcfile = vsrcfile + getTrigname(input tabname,input "d").
     assign incdecl = 0.
     if search(vsrcFile) <> ? then do:
        incdecl = 1.
        input from value(vsrcfile).
        repeat:
            import delimiter "(())(())" vfile.
            if index(vfile,"mfdeclre.i") > 0 then incdecl = 2.
        end.
        input close.
        if opsys = "unix" then do:
           assign vcmd = "cp " + search(vsrcfile) + " ./" + dtfile.
           unix silent value(vcmd).
        end.
        else
        if opsys = "msdos" or opsys = "win32" then do:
           assign vcmd ="copy " + search(vsrcfile) + " .\" + dtfile.
           dos silent value(vcmd).
        end.
     end.
     else assign incdecl = 0.
     RUN gentrig(input incdecl,
                 INPUT dtfile,
                 INPUT tabname,
                 INPUT "d",
                 INPUT domain,
                 INPUT part,
                 INPUT site,
                 INPUT nbr,
                 INPUT key0,
                 INPUT key1,
                 INPUT key2,
                 INPUT key3,
                 INPUT key4,
                 INPUT key5,
                 INPUT key6,
                 INPUT key7,
                 INPUT key8,
                 INPUT key9).
  end.
  if wtfile <> "" then do:
     os-delete value(wtfile) no-error.
     assign vsrcfile = getSrcDir().
     if vsrcfile <> "" then assign vsrcfile = vsrcfile + "/".
     assign vsrcfile = vsrcfile + getTrigname(input tabname,input "w").
     assign incdecl = 0.
     if search(vsrcFile) <> ? then do:
        incdecl = 1.
        input from value(vsrcfile).
        repeat:
            import delimiter "(())(())" vfile.
            if index(vfile,"mfdeclre.i") > 0 then incdecl = 2.
        end.
        input close.
        if opsys = "unix" then do:
           assign vcmd ="cp " + search(vsrcfile) + " ./" + wtfile.
           unix silent value(vcmd).
        end.
        else
        if opsys = "msdos" or opsys = "win32" then do:
           assign vcmd ="copy " + search(vsrcfile) + " .\" + wtfile.
           dos silent value(vcmd).
        end.
     end.
     else assign incdecl = 0.
     RUN gentrig(input incdecl,
                 INPUT wtfile,
                 INPUT tabname,
                 INPUT "w",
                 INPUT domain,
                 INPUT part,
                 INPUT site,
                 INPUT nbr,
                 INPUT key0,
                 INPUT key1,
                 INPUT key2,
                 INPUT key3,
                 INPUT key4,
                 INPUT key5,
                 INPUT key6,
                 INPUT key7,
                 INPUT key8,
                 INPUT key9).
  end.

      find first qad_wkfl exclusive-lock where qad_domain = wkdom
             and qad_key1 = wkkey and qad_key2 = tablename no-error.
      if not available qad_wkfl then do:
         create qad_wkfl.
         assign qad_domain = wkdom
                qad_key1 = wkkey
                qad_key2 = tablename.
     end.
     recno = recid(qad_wkfl).
     assign     qad_charfld[1]   = domain
                qad_charfld[2]   = part
                qad_charfld[3]   = site
                qad_charfld[4]   = nbr
                qad_logfld[1]    = dtrace
                qad_logfld[2]    = wtrace
                qad_charfld1[10] = key0
                qad_charfld1[1]  = key1
                qad_charfld1[2]  = key2
                qad_charfld1[3]  = key3
                qad_charfld1[4]  = key4
                qad_charfld1[5]  = key5
                qad_charfld1[6]  = key6
                qad_charfld1[7]  = key7
                qad_charfld1[8]  = key8
                qad_charfld1[9]  = key9.
     run dispDet(tablename).
     display file_name @ filename with frame a.
end.
status input.

procedure dispDet:
   define input parameter iKey2 as character.
   find first qad_wkfl no-lock where qad_domain = wkdom
          and qad_key1 = wkkey and qad_key2 = iKey2 no-error.
   if available qad_wkfl then do:
      display qad_key2 @ tablename
              qad_charfld[1]   @ domain
              qad_logfld[1]    @ dtrace
              qad_logfld[2]    @ wtrace
              qad_charfld[2]   @ part
              qad_charfld[3]   @ site
              qad_charfld[4]   @ nbr
              qad_charfld1[10] @ key0
              qad_charfld1[1]  @ key1
              qad_charfld1[2]  @ key2
              qad_charfld1[3]  @ key3
              qad_charfld1[4]  @ key4
              qad_charfld1[5]  @ key5
              qad_charfld1[6]  @ key6
              qad_charfld1[7]  @ key7
              qad_charfld1[8]  @ key8
              qad_charfld1[9]  @ key9
              with frame a.
   end.
end procedure.
