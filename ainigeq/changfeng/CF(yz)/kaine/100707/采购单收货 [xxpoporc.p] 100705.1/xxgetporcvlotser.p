/* SS - 100706.1 By: Kaine Zhang */

define input parameter sMfgUser as character.
define input parameter iLine as integer.
define input parameter sVendor as character.
define output parameter sLotSerial as character.

for first sr_wkfl
    no-lock
    where sr_userid = sMfgUser
        and sr_line = string(iLine)
:
end.
if available(sr_wkfl) then do:
    sLotSerial = sr_lotser.
end.
else do:
    sLotSerial = string((year(today) modulo 100), "99")
        + string(month(today), "99")
        + string(day(today), "99")
        + sVendor + "01".
end.


