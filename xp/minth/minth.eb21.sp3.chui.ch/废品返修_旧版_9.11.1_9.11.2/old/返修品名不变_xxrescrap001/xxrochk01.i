/*xxrochk01.i  检查工艺流程是否存在                                        */
/* REVISION: 1.0         Last Modified: 2009/03/25   By: Roger             */
/*-Revision end------------------------------------------------------------*/

/*{xxretrforscrap002.i}
site 默认
eff_date 输入
op ?


{xxrochk01.i 
     &line    = pdln
     &part    = v_part
}
*/


assign
    routing   = ""
    bom_code  = "" .

for first pt_mstr
    fields( pt_domain pt_bom_code pt_routing)
    where pt_mstr.pt_domain = global_domain 
    and  pt_part = {&part}
    no-lock:
end. /* FOR FIRST pt_mstr */

/*GET THE DEFAULT BOM-CODE AND ROUTING CODE */
for first ptp_det
    fields( ptp_domain ptp_bom_code ptp_routing)
    where ptp_det.ptp_domain = global_domain 
    and   ptp_part = {&part}
    and   ptp_site = site
    no-lock:
        assign 
        bom_code = ptp_bom_code
        routing  = ptp_routing.
end. /* FOR FIRST ptp_det */

if not available ptp_det then
   assign
      bom_code = pt_bom_code
      routing  = pt_routing.

for first rps_mstr
    fields( rps_domain rps_routing rps_bom_code)
    where rps_mstr.rps_domain = global_domain 
    and  rps_part     = {&part}
    and   rps_site     = site
    and   rps_line     = {&line}
    and   rps_due_date = eff_date
    no-lock:

    if rps_routing  > ""  then routing = rps_routing.
    if rps_bom_code > ""  then bom_code = rps_bom_code.
end. /* FOR FIRST rps_mstr */


assign
    routing   = (if routing = ""  then {&part}  else routing)
    bom_code  = (if bom_code = "" then {&part} else bom_code) .

find first ro_det 
    where ro_det.ro_domain = global_domain 
     and ro_routing  = routing 
     and ((ro_start <= eff_date or ro_start = ?)
     and (ro_end   >= eff_date or ro_end   = ?)) 
no-lock no-error.
op = if available ro_det then ro_op else  0.  


if routing > "" then
    find ro_det  where ro_det.ro_domain = global_domain and (
         ro_routing = routing and
         ro_op      = op and
        (ro_start = ? or ro_start  <= eff_date) and
        (ro_end = ? or ro_end    >= eff_date)
    ) no-lock no-error.

else
    find ro_det  where ro_det.ro_domain = global_domain and (
         ro_routing = {&part} and
         ro_op      = op and
        (ro_start = ? or ro_start  <= eff_date) and
        (ro_end = ? or ro_end    >= eff_date)
    ) no-lock no-error.
if not available ro_det then do:

   if routing > "" then
           find first ro_det  where ro_det.ro_domain = global_domain and (
                      ro_routing = routing and
                     (ro_start = ? or ro_start  <= eff_date) and
                     (ro_end = ? or ro_end    >= eff_date)
           ) no-lock no-error.

   else
           find first ro_det  where ro_det.ro_domain = global_domain and (
                      ro_routing = {&part} and
                     (ro_start = ? or ro_start  <= eff_date) and
                     (ro_end = ? or ro_end    >= eff_date)
           ) no-lock no-error.
   if not available ro_det then do:
      /* ROUTING DOES NOT EXIST */
      {pxmsg.i &MSGNUM=126 &ERRORLEVEL=3}
      undo, retry.
   end.

   else do:
      /* OPERATION IS NOT VALID */
      {pxmsg.i &MSGNUM=106 &ERRORLEVEL=3}
      undo, retry.
   end.

end.
