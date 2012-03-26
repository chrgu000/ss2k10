/* xxgetrev.p - get program version number                                   */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 21YA LAST MODIFIED: 01/10/12 BY: zy save variable to usrw_wkfl  */
/* REVISION END                                                              */

{mfdeclre.i}
define variable version_nbr as character.
if opsys = "unix" then do:
   assign version_nbr = entry(2,dtitle," ").
end.
else if opsys = "msdos" or opsys = "win32" then do:
        version_nbr = global_program_rev.
        if version_nbr = "" then do:
             if global_usrc_right_hdr_disp < 2
             then version_nbr = substring(dtitle,index(dtitle," ")).
             else version_nbr = substring(dtitle,150).
        end.
end.
find first usrw_wkfl exclusive-lock where {xxusrwdomver.i} {xxand.i}
           usrw_key1 = execname and usrw_key2 = opsys no-error.
if not available usrw_wkfl then do:
   create usrw_wkfl.
   assign {xxusrwdomver.i}
          usrw_key1 = execname
          usrw_key2 = opsys.
end.
   assign usrw_key3 = version_nbr
          usrw_key4 = global_userid
          usrw_datefld[1] = today
          usrw_intfld[1] = time
          usrw_intfld[2] = usrw_intfld[2] + 1
          usrw_charfld[1] = PROGRAM-NAME(2).
