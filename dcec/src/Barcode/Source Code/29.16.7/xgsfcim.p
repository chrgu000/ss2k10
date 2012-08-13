/**********************************************
** Program: xgsfcim.p
** Author : Li Wei
** Date   : 2005-11-28
** Desc   : CimLoad format control for 17.1
***********************************************/

DEFINE VAR qt AS CHARACTER INIT '"'.
DEFINE VAR spc AS CHARACTER INIT " ".

DEFINE INPUT PARAMETER flname AS CHARACTER format "x(80)".
DEFINE INPUT PARAMETER wolot AS CHARACTER.
DEFINE INPUT PARAMETER proqty AS DECIMAL.
define input parameter part as character.
define input parameter site as character.


define shared stream source_str.
define variable routing as character.
define variable op      as integer.

/**** Get routing code ****/
   find first ptp_det no-lock
   where ptp_site = site
   and ptp_part = part
   no-error .

   if available(ptp_det) then
      routing = ptp_routing .
   else do:
      find first pt_mstr no-lock
      where pt_part = part
      no-error .

      if not available(pt_mstr) then
          routing = "" .
      else
         routing = pt_routing .
   end .

   if routing = "" then
      routing = part .

/**** Get Last OP ****/
FIND last ro_det NO-LOCK
      WHERE ro_routing = routing
      AND (ro_start <= today OR ro_start = ?)
      AND (ro_end >= today OR ro_end = ?) NO-ERROR .
if avail ro_det then op = ro_op.
                else do:
                    message "ERR:无法找到工序".
                    undo,leave.
                end.

output stream source_str to value(flname) append.
PUT stream source_str UNFORMATTED "@@batchload sfoptr01.p" SKIP
    "- " qt wolot qt spc qt op qt skip
    "-" skip
    qt proqty qt spc 
    "No No "
    qt today qt spc
    "-" skip
    /*"Yes" skip*/.
if opsys = "unix" then  PUT stream source_str UNFORMATTED "Yes" skip.   
PUT stream source_str UNFORMATTED "." skip "." skip "@@END" SKIP .
output stream source_str close.