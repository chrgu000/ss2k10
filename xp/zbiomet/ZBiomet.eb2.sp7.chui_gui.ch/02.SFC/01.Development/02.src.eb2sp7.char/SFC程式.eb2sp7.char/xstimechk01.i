/* xstimechk01.i  工序数量已完成,则本工序不允许再做时间反馈                */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/



if (v_lastwo  and v_qty_comp + v_qty_rjct >= v_qty_ord2 * (v_tol_pct / 100 ))
or (v_lastwo = no and v_qty_comp + v_qty_rjct >= v_qty_ord2)
then do:
        message "   数量已完成,指令不允许      " view-as alert-box title "" .
        undo,leave .
end.
