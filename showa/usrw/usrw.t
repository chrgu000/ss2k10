TRIGGER PROCEDURE for write of usr_mstr old buffer OLD_usr_mstr.
define variable vlvl as integer no-undo.
/* {mfdeclre.i} */
define shared variable global_user_lang_dir like lng_mstr.lng_dir.
define shared variable global_userid as character.
define shared variable mfguser as character.
define shared variable execname as character.
if old_usr_mstr.usr_passwd <> usr_mstr.usr_passwd then do:
create qad_wkfl .
assign qad_key1 = "usr_mstr password change record"
       qad_key2 = global_userid + " " + mfguser + " " + string(today,"9999-99-99") + " " + string(time,"HH:MM:SS")
       qad_key3 = "usr_userid:" + usr_mstr.usr_userid
       qad_key4 = "usr_passwd Change From:[" + old_usr_mstr.usr_passwd + "]"
       qad_key5 = "Change To:[" + usr_mstr.usr_passwd + "]"
       qad_key6 = "RECID(usr_mstr)" + string(recid(usr_mstr))
       qad_user1 = "usr_userid:" + usr_mstr.usr_userid
       qad_user2 = "usr_usrname:" + usr_mstr.usr_name
       qad__qadc01 = "global_userid:" + global_userid
       qad_datefld[1] = today
       qad_intfld[1] = time
       qad_charfld[1] = "MFGPRO Operater:" + global_userid.

FOR EACH mon_mstr NO-LOCK WHERE mon_sid = mfguser,
    EACH qaddb._connect NO-LOCK WHERE mon__qadi01 = _Connect-Usr:
  assign qad_charfld[2] = "OS Operater:" + _connect-name
         qad_charfld[3] = "connect Device:" + _connect-device
         qad_charfld[4] = "connect Device:" + _connect-device
         qad_charfld[5] = "InterFace:" + mon_interface
         qad_charfld[6] = "program name:" + mon_program
         qad_charfld[7] = "ExecName:" + execName
         qad_charfld[8] = "date start:" + string(mon_date_start,"9999-99-99")
         qad_charfld[9] = "login date:" + string(mon_login_date,"9999-99-99")
         qad_charfld[10]= "login time:" + string(mon_login_time,"HH:MM:SS")
         qad_charfld[11]= "operat date:" + string(today,"9999-99-99")
         qad_charfld[12]= "operat time:" + string(time,"HH:MM:SS")
         qad_datefld[2] = mon_date_start
         qad_datefld[3] = mon_login_date
         qad_intfld[2]  = mon_login_time.
END.
 
vlvl = 2.
REPEAT WHILE (PROGRAM-NAME(vlvl) <> ?):
  qad_charfld[13] = qad_charfld[13] + string(vlvl - 1, "99")
                  + ":" + program-name(vlvl) + "; ".
  vlvl = vlvl + 1.
  if index(PROGRAM-NAME(vlvl),"mfnewa3.p") > 0 then leave.
END.


qad_charfld[13] = "call:" + qad_charfld[13].
end. /*if old_usr_mstr.usr_passwd <> usr_mstr.usr_passwd then do:*/