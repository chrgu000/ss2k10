/* xspor010080.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* ��ʾ�ջ���Ϣ */
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
        t1_nbr      column-label "�ɹ���"
        t1_line     column-label "��"
        t1_qty      column-label "����"
        t1_rct_nbr  column-label "�ջ���"
    with frame f0080_2 5 down no-box.
    form 
        s0080
        sMessage
    with frame f0080_3 no-labels no-box.
    
    if bSucceed then do:
        {xspor010080v1.i}
    end.
    else do:
        {xspor010080v2.i}
    end.
    
    leave lp0080.
END.

