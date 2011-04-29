/* xxpsmt01p01.p */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110330.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/
{mfdeclre.i}
{gplabel.i} 
{pxmaint.i}
{pxpgmmgr.i}



define input  parameter i_site      like sod_site no-undo .
define input  parameter i_part      like sod_part no-undo .
define input  parameter i_date      like sod_due_date no-undo .
define output parameter o_qty_min   like sod_qty_ord no-undo .
define output parameter o_qty_max   like sod_qty_ord no-undo .

{xxpsmt01var.i}

define var v_ii            as integer .

define var v_date_min_dec  as decimal .
define var v_date_max_dec  as decimal .

define var v_date_min_int  as integer .
define var v_date_max_int  as integer .

define var v_date_further  as date  .
define var v_find_further  as integer .
v_find_further = 15 .  
/* 	
    ����ڿ���׼�趨���������Ҳ�����������
    ������˳�Ӳ�������15�죬����������������׼Ϊ0��
    ����ڵ�ǰʱ�㿪ʼ��15�����ҵ�����㲻Ϊ0�������һ�쿪ʼ�������տ���׼���㣬�����ܲ��ҵ�15�պ������
*/


mainloop:
repeat:

    o_qty_min = 0 .
    o_qty_max = 0 .
/*
    find first kc_det 
        where kc_site = i_site
        and   kc_part = i_part
    no-error .
    if not avail kc_det then leave .
*/

    v_date_min_int = truncate(v_date_min,0).
    v_date_max_int = truncate(v_date_max,0).

    v_date_min_dec = if v_date_min_int < v_date_min then v_date_min - v_date_min_int else 1.
    v_date_max_dec = if v_date_max_int < v_date_max then v_date_max - v_date_max_int else 1.

    v_date_min_int = if v_date_min_int < v_date_min then v_date_min_int + 1 else v_date_min_int .
    v_date_max_int = if v_date_max_int < v_date_max then v_date_max_int + 1 else v_date_max_int .


    /*�ҿ���׼������������*/
    {xxpsmt01p01i01.i &qty=o_qty_min &datei=v_date_min_int &dated=v_date_min_dec}
    {xxpsmt01p01i01.i &qty=o_qty_max &datei=v_date_max_int &dated=v_date_max_dec}


    leave .
end. /* mainloop */

