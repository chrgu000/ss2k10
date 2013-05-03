/* batch delete current month forcase run in every first day of month         */
/* /apps/scripts/prod/bclient.Production /home/mfg/batch/60_22_1 yyfcdel.p    */
/* /apps/scripts/test/bclient.Test /home/mfg/batch/60_22_1 yyfcdel.p          */

session:date-format = "mdy".
define variable vdte as date.
define stream fc.
do transaction:
   assign vdte = today.
   assign vdte = date(month(today),1,year(today)).
   assign vdte = vdte + 33.
/*   assign vdte = date(month(vdte),1,year(vdte)).                           */
/*   assign vdte = vdte + 33.                                                */
   assign vdte = vdte - day(vdte).
end.

output stream fc to input.txt.
  find first usrw_wkfl no-lock where usrw_domain = "DCEC" and
              usrw_key1 = "xxusrpm.p_TESTENVUSRBAKREST-CTRL" no-error.
  put stream fc unformat trim(usrw_key2) ' '.
  find first dom_mstr no-lock where dom_domain = "DCEC" no-error.
  if available dom_mstr then do:
     if index(dom_name,"Test") > 0 then do:
        put stream fc unformat trim(usrw_key4) skip.
     end.
     else do:
        put stream fc unformat trim(usrw_key3) skip.
     end.
  end.
  put stream fc unformat 'dcec' skip.
  put stream fc unformat 'yyfcbtchdel.p' skip.
  put stream fc unformat string(year(vdte),"9999") ' '.
  put stream fc unformat '"" "" '.
  put stream fc unformat vdte - day(vdte) + 1 ' ' vdte ' '.
  put stream fc unformat '"" ""'.  
  put stream fc skip.
  put stream fc unformat 'Y' skip.
  put stream fc unformat '.' skip.
  put stream fc unformat '.' skip.
  put stream fc unformat 'Y' skip.
output stream fc close.

input from input.txt.
output to output.txt.
run mf.p.
output close.
input close.
/* os-delete("yyfcbtchdel.p.bpi").         */
/* os-delete("yyfcbtchdel.p.bpo").         */
quit.
