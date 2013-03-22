output to input.txt.
find first usrw_wkfl no-lock where usrw_domain = "DCEC" and usrw_key1 = "xxusrpm.p_TESTENVUSRBAKREST-CTRL" no-error.
if available usrw_wkfl then do:
   put unformat '"' trim(usrw_key2) '" "' trim(usrw_key4) '"' skip.
end.
put unformat '"DCEC"' skip.
put unformat '"xxusrbk.p"' skip.
put unformat '.' skip.
put unformat 'Y' skip.
output close.

input from input.txt.
output to output.txt.
run mf.p.
output close.
input close.

os-delete "./input.txt".