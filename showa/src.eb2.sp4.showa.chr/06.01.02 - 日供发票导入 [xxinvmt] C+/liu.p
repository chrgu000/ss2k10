{mfdtitle.i "C+ "}
define variable i as integer.
i = 0.
AA:
   REPEAT:
   if i < 2 then do:
   {gprun.i ""mgbdld.p""} .
   i = i + 1.
   end.
   IF I > 1 THEN
   LEAVE AA.
   END.
message "导入完成，请到相应菜单查询" view-as alert-box  buttons OK.
 