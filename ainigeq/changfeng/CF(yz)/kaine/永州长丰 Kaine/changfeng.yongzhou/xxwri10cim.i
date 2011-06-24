for each t1_tmp:
    /* block.001.start # cim procedure */
    output to value(sInputFile).
    /* ����*      */   {xxputcimvariable.i ""qq"" sWoNbr  "at 1"}
    /* ��         */   {xxputcimvariable.i ""qq"" sWoLot}
    /* ��         */   {xxputcimvariable.i ""d"" ""0""}
    /* ��Ч����   */   {xxputcimvariable.i ""d"" ""-""}
    /* ���ű���   */   {xxputcimvariable.i ""d"" ""N""}
    /* ��������   */   {xxputcimvariable.i ""d"" ""N""}
    /* ����*      */   {xxputcimvariable.i ""qq"" t1_part   "at 1"}
    /* ��         */   {xxputcimvariable.i ""d"" t1_op}
    /* ����*      */   {xxputcimvariable.i ""d"" t1_qty "at 1"}
    /* ���Ŵ���Ʒ */   {xxputcimvariable.i ""d"" ""N""}
    /* ȡ��Ƿ��   */   {xxputcimvariable.i ""d"" ""N""}
    /* �ص�       */   {xxputcimvariable.i ""qq"" sSite}
    /* ��λ       */   {xxputcimvariable.i ""qq"" sLocation}
    /* ����       */   {xxputcimvariable.i ""qq"" t1_lot}
    /* �ο�       */   {xxputcimvariable.i ""qq"" """"}
    /* ���¼     */   {xxputcimvariable.i ""d"" ""N""}
    /* �뿪F4*    */   {xxputcimvariable.i ""d"" ""."" "at 1"}
    /* ��ʾ��Ϣ*  */   {xxputcimvariable.i ""d"" ""Y"" "at 1"}
    /* ȷ��*      */   {xxputcimvariable.i ""d"" ""Y"" "at 1"}
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
