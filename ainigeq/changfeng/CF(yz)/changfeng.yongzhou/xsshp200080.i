/* xsshp200080.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* 显示收货信息 */
lp0080:
repeat on endkey undo, retry:
    hide all.
    define variable s0080             as character format "x(50)".
    define variable s0080_1           as character format "x(50)".
    define variable s0080_2           as character format "x(50)".
    define variable s0080_3           as character format "x(50)".
    define variable s0080_4           as character format "x(50)".
    define variable s0080_5           as character format "x(50)".
    
    form
        sTitle
        s0080_1
        s0080_2
        s0080_3
        s0080_4
        s0080_5
        s0080
        sMessage
    with frame f0080 no-labels no-box.
    
    form
        sTitle
    with frame f0080_1 no-labels no-box.
    form
        s0020       column-label "订单"     format "x(8)"
        t1_line     column-label "项"       format ">>9"
        t1_qty      column-label "数量"     format ">>>>>9.9<<"
        t1_trnbr    column-label "事务"     format ">>>>>>>>9"
    with frame f0080_2 5 down no-box.
    form 
        s0080
        sMessage
    with frame f0080_3 no-labels no-box.
    
    if bSucceed then do:
        {xsshp200080v1.i}
    end.
    else do:
        {xsshp200080v2.i}
    end.
    
    leave lp0080.
END.

