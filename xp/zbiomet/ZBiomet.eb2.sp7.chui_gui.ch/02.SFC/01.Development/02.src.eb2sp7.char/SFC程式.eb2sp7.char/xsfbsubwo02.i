/* xsfbsubwo02.i 外协工单不允许时间反馈                                     */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/



if v_sub then do:
    message "      外协工序" v_wolot "+" v_op ",不允许时间反馈         " view-as alert-box title "".
    undo,leave.
end.