{mfdeclre.i}
{gplabel.i} 
{pxmaint.i}
{pxpgmmgr.i}


define input  parameter i_site      like sod_site   no-undo .
define input  parameter i_part      like sod_part   no-undo . 
define input  parameter i_is_mp     as logical      no-undo . 
define input  parameter i_qty_min   like tr_qty_loc no-undo . /*理论库存下限*/
define input  parameter i_qty_max   like tr_qty_loc no-undo . /*理论库存上限*/
define input  parameter i_qty_nr    like tr_qty_loc no-undo . /*需求*/
define input  parameter i_qty_oh    like tr_qty_loc no-undo . /*排产前供给,含其他产线已排产数量*/
define output parameter o_qty_ord   like tr_qty_loc no-undo . /*本次排产数量*/


define var v_qty_lot               as decimal .
define var v_qty_tmp1              as decimal .
define var v_qty_tmp2              as decimal .
define var v_qty_tmp3              as decimal .



/*预排程数量:
,SP按纳入量
,MP按平均值=（库存基准下限+库存基准上限）/2  +  排程周节点销售纳入 - 排程周节点理论库存*/
if i_is_mp then 
     v_qty_tmp1 = max(0,(i_qty_min + i_qty_max) / 2 + i_qty_nr - i_qty_oh ).
else v_qty_tmp1 = i_qty_nr.


v_qty_tmp2 = 0.
v_qty_tmp3 = 0.
o_qty_ord  = 0 .



mainloop:
repeat:
    find first xxpbd_det
        where xxpbd_site = i_site
        and   xxpbd_part = i_part
    no-lock no-error.
    v_qty_lot = if avail xxpbd_det then xxpbd_qty_lot else 1.

    v_qty_lot = if v_qty_lot <> 0 then v_qty_lot else 1.


    v_qty_tmp2 = truncate(v_qty_tmp1 / v_qty_lot, 0 ) .

    /*排程数量可以被批量整除*/
    if v_qty_tmp2 = v_qty_tmp1 then do:
        v_qty_tmp3 = v_qty_tmp2 * v_qty_lot .
        leave .
    end.
    else do:
        /*排程数量不可以被批量整除,加1批*/
        v_qty_tmp3 = (v_qty_tmp2 + 1) * v_qty_lot .
        
        /*sp件满足经济批量即可,不参与库存基准计算*/
        if i_is_mp = no then leave .

        /*排程数量不可以被批量整除,加1批后,理论库存不超过基准上限*/
        if v_qty_tmp3 <= max(0, i_qty_max + i_qty_nr - i_qty_oh ) then do:
            leave .
        end.
        else do:
            /*排程数量不可以被批量整除,加1批后,理论库存超过基准上限,减1批*/
            v_qty_tmp3 = max(1,(v_qty_tmp2 - 1)) * v_qty_lot .

            /*排程数量减1批后,不低于库存下限*/
            if v_qty_tmp3 >= max(0, i_qty_min + i_qty_nr - i_qty_oh ) then do:
                leave .
            end.
            else do:
                /*排程数量减1批后,低于库存下限,则用加1批的数量*/
                v_qty_tmp3 = (v_qty_tmp2 + 1) * v_qty_lot .
            end.
        end.
    end.

leave .
end. /*mainloop:*/

o_qty_ord = v_qty_tmp3 .