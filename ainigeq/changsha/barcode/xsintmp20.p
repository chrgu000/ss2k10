/* xsintmp20.p ---- */
/* Copyright 2011 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 110322.1 By: Kaine Zhang */


/* SS - 110317.1 - RNB
[110317.1]
�������,�����������.
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
        sTitle = "[�����������]*" + s0010.
        
        leave lp0010.
    END.
    /* END    LINE :0010  �ص�[SITE]  */

    /* *ss_20090630* ����ID */
    {xswor100020.i}
    
    /* *ss_20090701* ��λ */
    {xswor100050.i}

    
    detlp:
    repeat transaction on endkey undo, retry:
        /* *ss_20090701* �����-����� --���� */
        {xsintmp100030.i}
        
        /* *ss_20090701* �����-����� --���� */
        {xswor100040.i}

        
        
        {xscreateintmp.i
            sWoLot
            s0030
            s0040
            1
        }
        
        /* �ı��߼���� */
        {xsbcldtrans.i
            s0010
            sCscfLoc
            s0030
            s0040
            1
            s0050
        }
        
        /* �����߼��������� */
        {xsbctrhist.i
            s0010
            sCscfLoc
            s0030
            s0040
            1
            s0050
            sQadType[1]
            0
            wo_nbr
            wo_lot
            sBarcodeType[1]
        }
        

    end.
end.


