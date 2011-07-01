/* xssoiss10.p ---- */
/* Copyright 2011 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 110321.1 By: Kaine Zhang */

/* SS - 110317.1 - RNB
[110317.1]
条码程序,销售发运.
[110317.1]
SS - 110317.1 - RNE */

{xsbcvariable01.i}


{xsgetinputtimeout.i wtimeout execname}




    
mainloop:
repeat:

    /* START  LINE :0010  地点[SITE]  */
    lp0010:
    repeat on endkey undo, retry:
        hide all.
        
        {xsvarform0010.i}
        
        {xsdefaultsite.i
            s0010_1
            s0010_2
        }
        
        s0010 = s0010_1.
        
        /* *ss_20090701* 标题行内容 */
        sTitle = "[销售扫描发运]*" + s0010.
        
        leave lp0010.
    END.
    /* END    LINE :0010  地点[SITE]  */

    /* *ss_20090630* 销售订单编号 */
    {xssoiss100020.i}

    /* *ss_20110321* 销售订单项次 */
    {xssoiss100060.i}    
    
    /* *ss_20090701* 库位 */
    {xssoiss100050.i}
    
    
    
    detlp:
    repeat transaction on endkey undo, retry:
        /* *ss_20090701* 零件号-批序号 --物料 */
        {xssoiss100030.i}
        
        /* *ss_20090701* 零件号-批序号 --批号 */
        {xssoiss100040.i}

        
        /* 产生组装子件记录 */
        {xscreatecomponent.i
            s0030
            s0040
            sQadType[4]
            s0020
            i0060
        }
        
        assign
            sAssembleFlag = mfguser + string(today, "99999999") + string(time, "99999")
            bCanAssemble = no
            .
        
        if s0030 = sAssemblePart then do:
            find first xbcass_det
                where xbcass_part = s0030
                    and xbcass_lot = s0040
                    and xbcass_type = sQadType[4]
                    and xbcass_order = s0020
                    and xbcass_line = i0060
                no-error.
            if available(xbcass_det) then do:
                assign
                    xbcass_is_assembled = yes.
                    xbcass_flag = sAssembleFlag
                    .
            end.
            
            bCanAssemble = yes.
        end.
        else do:
            /* asm and flag. */
            {xswor10assemble.i
                sAssemblePart
                today
                sQadType[4]
                s0020
                i0060
                sAssembleFlag
                bCanAssemble
                "isssoassLoop"
            }
        end.
        
        if bCanAssemble then do:
            {xssoiss10trans.i}
            {xssoiss10transvalid.i}
            
            {xssoiss10componentmove.i}
        end.

    end.
end.


