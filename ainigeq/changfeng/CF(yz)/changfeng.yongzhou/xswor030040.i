/* xswor020040.i -- */
/* Copyright 200908 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* 物料$批号 -- 批号 */
lp0040:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0040.i}
    
    s0040 = sLot.
    
    /* SS - 090824.1 - B */
    /* *ss_20090824* 
     *  对于座椅,需要检查座椅号是否已在库存中存在.
     *  即检查在本地点/库位/物料/批号,是否已经有库存 
     */
    find first ld_det
        no-lock
        where ld_site = s0010
            and ld_loc = s0050
            and ld_part = s0030
            and ld_lot = s0040
            and ld_qty_oh > 0
        use-index ld_loc_p_lot
        no-error.
    if available(ld_det) then do:
        sMessage = "地点/库位/座椅号已存在".
        undo detlp, retry detlp.
    end.
    /* SS - 090824.1 - E */
    
    leave lp0040.
END.

