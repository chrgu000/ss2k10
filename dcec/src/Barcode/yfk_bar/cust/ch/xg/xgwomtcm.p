/*************************************************
** Program:xgwomtcm.p
** Author :Li Wei 
** Date   :2005-11-28
** Desc   :WO Mt CimLoad format control
*************************************************/

{mfdeclre.i}

define input parameter part as character.
define input parameter site as character.
define input parameter proqty as decimal.

define shared stream source_str.
define shared variable source_file as character .
define shared variable inbr as character .
define shared variable iwolot as character .
/*lw01
DEFINE VARIABLE inbr   like wo_nbr.
DEFINE VARIABLE iwolot like wo_lot.
*/

output stream source_str to value(Source_file) append.
PUT stream source_str UNFORMATTED "@@batchload wowomt.p" skip.

PUT stream source_str UNFORMATTED
'"' inbr   '" ' '"' iwolot '"' skip
'"' part  '"'  " - " '"' site '"'   skip
'"' proqty  '"' " - - - "	'"' "R" '"' 	
 " - - - - - - - " '"' "No" '" ' skip.

for first pt_mstr where pt_part = part no-lock: end.
if available pt_mstr and pt_lot_ser <> "S" then do:
 PUT stream source_str UNFORMATTED skip(2).
end.     

PUT stream source_str UNFORMATTED skip.
PUT stream source_str "." SKIP "." skip "@@end" skip.
output stream source_str close.
