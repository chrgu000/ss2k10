/* xssoiss10.p ---- */
/* Copyright 2011 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 110321.1 By: Kaine Zhang */

/* SS - 110317.1 - RNB
[110317.1]
�������,���۷���.
[110317.1]
SS - 110317.1 - RNE */

{xsbcvariable01.i}


{xsgetinputtimeout.i wtimeout execname}




    
mainloop:
repeat:

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
        sTitle = "[����ɨ�跢��]*" + s0010.
        
        leave lp0010.
    END.
    /* END    LINE :0010  �ص�[SITE]  */

    /* *ss_20090630* ���۶������ */
    {xssoiss100020.i}

    /* *ss_20110321* ���۶������ */
    {xssoiss100060.i}    
    
    /* *ss_20090701* ��λ */
    {xssoiss100050.i}
    
    
    
    detlp:
    repeat transaction on endkey undo, retry:
        /* *ss_20090701* �����-����� --���� */
        {xssoiss100030.i}
        
        /* *ss_20090701* �����-����� --���� */
        {xssoiss100040.i}

        
        /* ������װ�Ӽ���¼ */
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


