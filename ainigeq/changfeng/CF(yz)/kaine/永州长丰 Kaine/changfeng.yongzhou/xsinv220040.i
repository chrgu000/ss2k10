/* xsinv220040.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* ŒÔ¡œ.≈˙∫≈ */
lp0040:
repeat on endkey undo, retry:
    hide all.
    define variable s0040             as character format "x(50)".
    define variable s0040_1           as character format "x(50)".
    define variable s0040_2           as character format "x(50)".
    define variable s0040_3           as character format "x(50)".
    define variable s0040_4           as character format "x(50)".
    define variable s0040_5           as character format "x(50)".
    
    form
        sTitle
        s0040_1
        s0040_2
        s0040_3
        s0040_4
        s0040_5
        s0040
        sMessage
    with frame f0040 no-labels no-box.

    s0040 = sLot.
    
    leave lp0040.
END.

