/* a6gllim1a.p - Àà±ðÎ¬»¤                      */

define shared variable usrw_recno as recid.

define variable fpos like usrw_key2.
define variable sums_into like usrw_key3.

find usrw_wkfl where recid(usrw_wkfl) = usrw_recno no-lock no-error.
if available usrw_wkfl then do:

   fpos = usrw_key2.
   sums_into = usrw_key3.

   if not can-find(first usrw_wkfl where usrw_key3 = fpos) then
      leave.

   repeat:
      find usrw_wkfl WHERE usrw_key1 = "glsum"
          AND usrw_key2 = sums_into no-lock no-error.
      if not available fm_mstr then leave.
      if usrw_key2 = fpos then do:
         usrw_recno = 0.
         leave.
      end.
      sums_into = usrw_key3.
   end.

end.
