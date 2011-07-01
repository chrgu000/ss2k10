/* xssoiss10componentmove.i ---- */
/* Copyright 2011 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 110321.1 By: Kaine Zhang */


for each xbcass_det
    no-lock
    where xbcass_type = sQadType[4]
        and xbcass_order = s0020
        and xbcass_line = i0060
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
        sQadType[4]
        0
        s0020
        s0060
        sBarcodeType[4]
    }
    
    {xsbcldtrans.i
        s0010
        sOutLoc
        xbcass_part
        xbcass_lot
        1
        s0050
    }
        
    {xsbctrhist.i
        s0010
        sOutLoc
        xbcass_part
        xbcass_lot
        1
        s0050
        sQadType[4]
        0
        s0020
        s0060
        sBarcodeType[13]
    }
end.





