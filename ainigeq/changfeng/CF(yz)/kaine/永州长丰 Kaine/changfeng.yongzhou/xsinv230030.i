/* xsinv210030.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* 物料$批号 - 批号 */
lp0030:
repeat on endkey undo, retry:
    hide all.
    define variable s0030             as character format "x(50)".
    define variable s0030_1           as character format "x(50)".
    define variable s0030_2           as character format "x(50)".
    define variable s0030_3           as character format "x(50)".
    define variable s0030_4           as character format "x(50)".
    define variable s0030_5           as character format "x(50)".
    
    form
        sTitle
        s0030_1
        s0030_2
        s0030_3
        s0030_4
        s0030_5
        s0030
        sMessage
    with frame f0030 no-labels no-box.

    assign
        s0030_1 = "物料$批号"
        s0030_5 = sPromptMessage
        .
    
    s0030 = sLot.
    
    leave lp0030.
END.

