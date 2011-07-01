/* xswor10rctcomponentmove.i ---- */
/* Copyright 2011 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 110321.1 By: Kaine Zhang */


for each xbcass_det
    no-lock
    where xbcass_type = sQadType[1]
        and xbcass_order = s0020
        and xbcass_line = 0
        and xbcass_is_assembled
        and xbcass_flag = sAssembleFlag
        and not(xbcass_is_temp)
    use-index xbcass_type_order_part
:
    
    /* �ı��߼���� */
    {xsbcldtrans.i
        s0010
        sCscfLoc
        xbcass_part
        xbcass_lot
        1
        s0050
    }
    
    /* �����߼��������� */
    {xsbctrhist.i
        s0010
        sCscfLoc
        xbcass_part
        xbcass_lot
        1
        s0050
        sQadType[1]
        0
        wo_nbr
        wo_lot
        sBarcodeType[1]
    }
        
end.
