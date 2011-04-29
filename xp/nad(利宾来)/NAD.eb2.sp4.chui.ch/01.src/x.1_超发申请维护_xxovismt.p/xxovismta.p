/* xxovismta.p - 超发申请单维护子程式,查找累计已超发量  */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110120.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/

{mfdeclre.i}

define input  parameter v_part      as char no-undo .
define input  parameter v_nbr       as char no-undo .
define input  parameter v_wolot     as char no-undo .
define output parameter v_ii        as integer  no-undo.
define output parameter v_qty_total like tr_qty_loc no-undo.

v_qty_total = 0 .
v_ii = 0 .

for each xovd_det 
        use-index xovd_wolot
        where xovd_wolot = v_wolot
        and   xovd_part = v_part
        and   xovd_nbr  <> v_nbr 
        and index("AP",xovd_status) > 0
    no-lock:
    v_ii = v_ii + 1 . 
    v_qty_total = v_qty_total + xovd_iss_qty .
end.
