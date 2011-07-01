/* xsinmov10.p --                                                            */
/* Copyright 200908 Softspeed Inc., Guangzhou, China                         */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* SS - 110317.1 By: Kaine Zhang                                             */
/* SS - 110628.1 By: ZY                                               *Y16S* */
/* Environment: Progress:9.1D    QAD:eb2sp9     Interface:Character          */
/* SS - 110317.1 - RNB
[110317.1]
条码程序,库存转移.
[110317.1]
SS - 110317.1 - RNE */
/*Y16s  - 110628.1    ZY      *Y16S*
  Purpose:刷条码时会重复刷(料号+批号)导致重复入库
  Parameters:<none>
  Notes:在QAD_WKFL里记录刷过的记录,在刷条码时4个小时内重复则不允许通过
  Change List:
        xsinmov10.p
        xsinmov100030.i
*/

{xsbcvariable01.i}

{xsgetinputtimeout.i wtimeout execname}

define variable sMoveNbr as character no-undo.
sMoveNbr = mfguser + string(today, "99999999") + string(time, "99999").

mainloop:
repeat :

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
        sTitle = "[库存扫描转移]*" + s0010.

        leave lp0010.
    END.
    /* END    LINE :0010  地点[SITE]  */

    /* *ss_20090630* 配套座椅 */
    {xsinmov100020.i}

    /* *ss_20090701* 库位 */
    {xsinmov100050.i}

    {xsinmov100060.i}




    detlp:
    repeat transaction on endkey undo, retry:
        /* *ss_20090701* 零件号-批序号 --物料 */
        {xsinmov100030.i}

        /* *ss_20090701* 零件号-批序号 --批号 */
        {xsinmov100040.i}


        /* 产生组装子件记录 */
        {xscreatecomponent.i
            s0030
            s0040
            sQadType[2]
            sMoveNbr
            0
        }

        assign
            sAssembleFlag = mfguser + string(today, "99999999")
                          + string(time, "99999")
            bCanAssemble = no
            .

        if s0030 = sAssemblePart then do:
            find first xbcass_det
                where xbcass_part = s0030
                    and xbcass_lot = s0040
                    and xbcass_type = sQadType[2]
                    and xbcass_order = sMoveNbr
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
                sAssemblePart
                today
                sQadType[2]
                sMoveNbr
                0
                sAssembleFlag
                bCanAssemble
                "isstrassLoop"
            }
        end.

        if bCanAssemble then do:
            {xsinmov10move.i}
            {xsinmov10movevalid.i}

            {xsinmov10componentmove.i}
        end.

    end.
end.


