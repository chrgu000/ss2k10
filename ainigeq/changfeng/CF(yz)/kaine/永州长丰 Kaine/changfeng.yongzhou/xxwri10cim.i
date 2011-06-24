for each t1_tmp:
    /* block.001.start # cim procedure */
    output to value(sInputFile).
    /* 工单*      */   {xxputcimvariable.i ""qq"" sWoNbr  "at 1"}
    /* 标         */   {xxputcimvariable.i ""qq"" sWoLot}
    /* 序         */   {xxputcimvariable.i ""d"" ""0""}
    /* 生效日期   */   {xxputcimvariable.i ""d"" ""-""}
    /* 发放备料   */   {xxputcimvariable.i ""d"" ""N""}
    /* 发放领料   */   {xxputcimvariable.i ""d"" ""N""}
    /* 物料*      */   {xxputcimvariable.i ""qq"" t1_part   "at 1"}
    /* 序         */   {xxputcimvariable.i ""d"" t1_op}
    /* 数量*      */   {xxputcimvariable.i ""d"" t1_qty "at 1"}
    /* 发放代用品 */   {xxputcimvariable.i ""d"" ""N""}
    /* 取消欠交   */   {xxputcimvariable.i ""d"" ""N""}
    /* 地点       */   {xxputcimvariable.i ""qq"" sSite}
    /* 库位       */   {xxputcimvariable.i ""qq"" sLocation}
    /* 批号       */   {xxputcimvariable.i ""qq"" t1_lot}
    /* 参考       */   {xxputcimvariable.i ""qq"" """"}
    /* 多记录     */   {xxputcimvariable.i ""d"" ""N""}
    /* 离开F4*    */   {xxputcimvariable.i ""d"" ""."" "at 1"}
    /* 显示信息*  */   {xxputcimvariable.i ""d"" ""Y"" "at 1"}
    /* 确认*      */   {xxputcimvariable.i ""d"" ""Y"" "at 1"}
    put "." at 1.
    output close.


    input from value(sInputFile).
    output to  value(sOutputFile).
    batchrun = yes.
    {gprun.i ""wowois.p""}
    batchrun = no.
    input close.
    /* block.001.finish # cim procedure */

    /* block.002.start # check wo issue trans */
    for first tr_hist
        no-lock
        where tr_trnbr > iTr
            and tr_type = "ISS-WO"
            and tr_site = sSite
            and tr_loc = sLocation
            and tr_part = t1_part
            and tr_serial = t1_lot
            and tr_lot = sWoLot
        use-index tr_trnbr
    :
    end.
    if available(tr_hist) then do:
        iTr = tr_trnbr.
    end.
    else do:
        {pxmsg.i &msgnum=9006 &msgarg1=t1_part &msgarg2=t1_lot}
        undo cimlp, leave cimlp.
    end.
    /* block.002.finish # check wo issue trans */
            
end.

os-delete value(sInputFile).
os-delete value(sOutputFile).
