/* xswor10.p -- */
/* Copyright 200908 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 110317.1 By: Kaine Zhang */
/* SS - 110628.1 By: ZY                                               *Y16S* */
/* SS - 110317.1 - RNB
[110317.1]
条码程序,座椅入库.
[110317.1]
SS - 110317.1 - RNE */
/*Y16s  - 110628.1    ZY      *Y16S*
  Purpose:刷条码时会重复刷导致重复入库(WO+part+lot)
  Parameters:<none>
  Notes:在QAD_WKFL里记录刷过的记录,在刷条码时4个小时内重复则不允许通过
  Change List:
        xswor10.p
        xswor100030.i   (PS:与xswor20.p共用)
*/
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
        sTitle = "[座椅扫描入库]*" + s0010.
        
        leave lp0010.
    END.
    /* END    LINE :0010  地点[SITE]  */

    /* *ss_20090630* 工单ID */
    {xswor100020.i}
    
    /* *ss_20090701* 库位 */
    {xswor100050.i}

    /*
     * 本程序不进行转移
     * {xswor100060.i}
     */
    
    
    detlp:
    repeat transaction on endkey undo, retry:
        /* *ss_20090701* 零件号-批序号 --物料 */
        {xswor100030.i}
        
        /* *ss_20090701* 零件号-批序号 --批号 */
        {xswor100040.i}

        find first xbcld_det
            where xbcld_site     = s0010
                and xbcld_loc    = sWorkPlaceLoc
                and xbcld_part   = s0030
                and xbcld_lot    = s0040
                and xbcld_qty_oh >= 1
            no-error.
        if available(xbcld_det) then do:
            {xsbcldtrans.i
                s0010
                sWorkPlaceLoc
                s0030
                s0040
                -1
                s0050
            }
            
            {xsbctrhist.i
                s0010
                sWorkPlaceLoc
                s0030
                s0040
                -1
                s0050
                sQadType[1]
                0
                wo_nbr
                wo_lot
                sBarcodeType[11]
            }
        end.
        
        
        /* 产生组装子件记录 */
        {xscreatecomponent.i
            s0030
            s0040
            sQadType[1]
            wo_lot
            0
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
            
            /*
             * 本程序不进行库存转移
             * {xswor10move.i}
             * {xswor10movevalid.i}
             * 
             * {xswor10componentmove.i}
             */
        end.

    end.
end.


