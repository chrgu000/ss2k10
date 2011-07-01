/* xswor10.p -- */
/* Copyright 200908 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 110317.1 By: Kaine Zhang */

/* SS - 110317.1 - RNB
[110317.1]
条码程序,暂用座椅.
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
        sTitle = "[暂用座椅扫描入库转移]*" + s0010.
        
        leave lp0010.
    END.
    /* END    LINE :0010  地点[SITE]  */

    /* *ss_20090630* 工单ID */
    {xswor100020.i}
    
    /* *ss_20090701* 库位 */
    {xswor100050.i}

    {xswor100060.i}
    
    
    detlp:
    repeat transaction on endkey undo, retry:
        /* *ss_20090701* 零件号-批序号 --物料 */
        {xsintmp100030.i}
        
        /* *ss_20090701* 零件号-批序号 --批号 */
        {xswor100040.i}

        
        
        /* 产生组装子件记录,并记录该子件是暂借的(tmp). */
        {xscreatetmpcomponent.i
            s0030
            s0040
            sQadType[1]
            wo_lot
            0
        }
        
        {xscreateintmp.i
            sWoLot
            s0030
            s0040
            -1
        }
        
        /* if input part=wo_part or ps_comp"X", then change xbcld_ and create xbctr_ */
        assign
            sAssembleFlag = mfguser + string(today, "99999999") + string(time, "99999")
            bCanAssemble = no
            .
        if s0030 = wo_part then do:
            find first xbcass_det
                where xbcass_part = s0030
                    and xbcass_lot = s0040
                    and xbcass_type = sQadType[1]
                    and xbcass_order = wo_lot
                    and xbcass_line = 0
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
                wo_part
                wo_rel_date
                sQadType[1]
                wo_lot
                0
                sAssembleFlag
                bCanAssemble
                "rctwoassLoop"
            }
        end.
        
        if bCanAssemble then do:
            {xswor10trans.i}
            {xswor10transvalid.i}
            
            {xswor10rctcomponentmove.i}
            
            {xswor10move.i}
            {xswor10movevalid.i}
            
            {xswor10componentmove.i}
        end.

    end.
end.


