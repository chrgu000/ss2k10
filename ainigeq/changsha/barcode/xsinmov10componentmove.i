/* xsinmov10componentmove.i ---- */
/* Copyright 2011 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 110321.1 By: Kaine Zhang */


for each xbcass_det
    no-lock
    where xbcass_type = sQadType[2]
        and xbcass_order = sMoveNbr
        and xbcass_line = 0
        and xbcass_is_assembled
        and xbcass_flag = sAssembleFlag
    use-index xbcass_type_order_part
:
    {xsbcldtrans.i
        s0010
        sCscfLoc
        xbcass_part
        xbcass_lot
        -1
        s0050
    }
        
    {xsbctrhist.i
        s0010
        sCscfLoc
        xbcass_part
        xbcass_lot
        -1
        s0050
        sQadType[2]
        0
        sMoveNbr
        """"
        sBarcodeType[2]
    }
    
    {xsbcldtrans.i
        s0010
        sOutLoc
        xbcass_part
        xbcass_lot
        1
        s0060
    }
        
    {xsbctrhist.i
        s0010
        sOutLoc
        xbcass_part
        xbcass_lot
        1
        s0060
        sQadType[3]
        0
        sMoveNbr
        """"
        sBarcodeType[3]
    }
end.





