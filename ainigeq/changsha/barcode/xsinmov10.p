/* xsinmov10.p --                                                            */
/* Copyright 200908 Softspeed Inc., Guangzhou, China                         */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* SS - 110317.1 By: Kaine Zhang                                             */
/* SS - 110628.1 By: ZY                                               *Y16S* */
/* Environment: Progress:9.1D    QAD:eb2sp9     Interface:Character          */
/* SS - 110317.1 - RNB
[110317.1]
�������,���ת��.
[110317.1]
SS - 110317.1 - RNE */
/*Y16s  - 110628.1    ZY      *Y16S*
  Purpose:ˢ����ʱ���ظ�ˢ(�Ϻ�+����)�����ظ����
  Parameters:<none>
  Notes:��QAD_WKFL���¼ˢ���ļ�¼,��ˢ����ʱ4��Сʱ���ظ�������ͨ��
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

    /* START  LINE :0010  �ص�[SITE]  */
    lp0010:
    repeat on endkey undo, retry:
        hide all.

        {xsvarform0010.i}

        {xsdefaultsite.i
            s0010_1
            s0010_2
        }

        s0010 = s0010_1.

        /* *ss_20090701* ���������� */
        sTitle = "[���ɨ��ת��]*" + s0010.

        leave lp0010.
    END.
    /* END    LINE :0010  �ص�[SITE]  */

    /* *ss_20090630* �������� */
    {xsinmov100020.i}

    /* *ss_20090701* ��λ */
    {xsinmov100050.i}

    {xsinmov100060.i}




    detlp:
    repeat transaction on endkey undo, retry:
        /* *ss_20090701* �����-����� --���� */
        {xsinmov100030.i}

        /* *ss_20090701* �����-����� --���� */
        {xsinmov100040.i}


        /* ������װ�Ӽ���¼ */
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


