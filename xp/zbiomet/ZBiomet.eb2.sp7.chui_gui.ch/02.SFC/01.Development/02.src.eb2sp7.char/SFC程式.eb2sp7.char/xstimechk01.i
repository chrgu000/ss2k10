/* xstimechk01.i  �������������,�򱾹�����������ʱ�䷴��                */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/



if (v_lastwo  and v_qty_comp + v_qty_rjct >= v_qty_ord2 * (v_tol_pct / 100 ))
or (v_lastwo = no and v_qty_comp + v_qty_rjct >= v_qty_ord2)
then do:
        message "   ���������,ָ�����      " view-as alert-box title "" .
        undo,leave .
end.
