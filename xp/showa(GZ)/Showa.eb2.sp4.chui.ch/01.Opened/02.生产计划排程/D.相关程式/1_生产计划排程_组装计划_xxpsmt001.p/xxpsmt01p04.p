{mfdeclre.i}
{gplabel.i} 
{pxmaint.i}
{pxpgmmgr.i}


define input  parameter i_site      like sod_site   no-undo .
define input  parameter i_part      like sod_part   no-undo . 
define input  parameter i_is_mp     as logical      no-undo . 
define input  parameter i_qty_min   like tr_qty_loc no-undo . /*���ۿ������*/
define input  parameter i_qty_max   like tr_qty_loc no-undo . /*���ۿ������*/
define input  parameter i_qty_nr    like tr_qty_loc no-undo . /*����*/
define input  parameter i_qty_oh    like tr_qty_loc no-undo . /*�Ų�ǰ����,�������������Ų�����*/
define output parameter o_qty_ord   like tr_qty_loc no-undo . /*�����Ų�����*/


define var v_qty_lot               as decimal .
define var v_qty_tmp1              as decimal .
define var v_qty_tmp2              as decimal .
define var v_qty_tmp3              as decimal .



/*Ԥ�ų�����:
,SP��������
,MP��ƽ��ֵ=������׼����+����׼���ޣ�/2  +  �ų��ܽڵ��������� - �ų��ܽڵ����ۿ��*/
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

    /*�ų��������Ա���������*/
    if v_qty_tmp2 = v_qty_tmp1 then do:
        v_qty_tmp3 = v_qty_tmp2 * v_qty_lot .
        leave .
    end.
    else do:
        /*�ų����������Ա���������,��1��*/
        v_qty_tmp3 = (v_qty_tmp2 + 1) * v_qty_lot .
        
        /*sp�����㾭����������,���������׼����*/
        if i_is_mp = no then leave .

        /*�ų����������Ա���������,��1����,���ۿ�治������׼����*/
        if v_qty_tmp3 <= max(0, i_qty_max + i_qty_nr - i_qty_oh ) then do:
            leave .
        end.
        else do:
            /*�ų����������Ա���������,��1����,���ۿ�泬����׼����,��1��*/
            v_qty_tmp3 = max(1,(v_qty_tmp2 - 1)) * v_qty_lot .

            /*�ų�������1����,�����ڿ������*/
            if v_qty_tmp3 >= max(0, i_qty_min + i_qty_nr - i_qty_oh ) then do:
                leave .
            end.
            else do:
                /*�ų�������1����,���ڿ������,���ü�1��������*/
                v_qty_tmp3 = (v_qty_tmp2 + 1) * v_qty_lot .
            end.
        end.
    end.

leave .
end. /*mainloop:*/

o_qty_ord = v_qty_tmp3 .