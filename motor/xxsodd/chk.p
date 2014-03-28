define variable i as integer initial 0.
for each usrw_wkfl where usrw_domain = "test2014" and usrw_key1 = "test2014" no-lock:
message "qadc01" usrw_key2 replace(usrw__qadc01,";",chr(10)) view-as alert-box.
message "key3"  usrw_key2 replace (usrw_key3,";",chr(10)) view-as alert-box.
message "key4"  usrw_key2  replace(usrw_key4,";",chr(10)) view-as alert-box.   message "key5"  usrw_key2 replace(usrw_key5,";",chr(10)) view-as alert-box.
message "key6"  usrw_key2 replace(usrw_key6,";",chr(10)) view-as alert-box.
assign i = i + 1.
end.
message i view-as alert-box.