/* xxwo2wp.p ---- */
/* Copyright 2011 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 110321.1 By: Kaine Zhang */


{mfdtitle.i "110321.1"}

define variable bDivide as logical no-undo.
define variable sQadType as character extent 4 no-undo.
define variable sBarcodeType as character extent 15 no-undo.
define variable bIsLess as logical no-undo.

define variable sCscfLoc as character initial "Cscf" no-undo.
define variable sOutLoc as character initial "Out" no-undo.
define variable sWorkPlaceLoc as character initial "Workplace" no-undo.

assign
    sQadType[1] = "RCT-WO"
    sQadType[2] = "ISS-TR"
    sQadType[3] = "RCT-TR"
    sQadType[4] = "ISS-SO"
    .

assign
    sBarcodeType[1]     = "RCT-WO"
    sBarcodeType[2]     = "ISS-TR"
    sBarcodeType[3]     = "RCT-TR"
    sBarcodeType[4]     = "ISS-SO"
    sBarcodeType[11]    = "ISS-X-WO"
    sBarcodeType[12]    = "RCT-X-WO"
    sBarcodeType[13]    = "RCT-X-SO"
    .


form
    wo_nbr          colon 15    
    wo_lot
    wo_status       no-labels
    wo_part         colon 15
    skip
    pt_desc1        no-label    at 17
    pt_desc2        no-label
    wo_site         colon 15
    wo_qty_ord      colon 15
    wo_qty_comp     colon 15
    wo_qty_rjct     colon 15
    bDivide         colon 15    label "Í£Ö¹×éºÏ"
with frame a side-labels width 80.
setframelabels(frame a:handle).
    
    



mainloop:
repeat with frame a
    on endkey undo, leave:

    {xxfindwo01.i}
    
    update
        bDivide
        .
    
    if bDivide then do:
        for each xbcass_det
            where xbcass_type = sQadType[1]
                and xbcass_order = wo_lot
                and xbcass_line = 0
                and not(xbcass_is_assembled)
                and xbcass_is_temp
        :
            find first xsborrow_det
                where xsborrow_wo_lot = xbcass_order
                    and xsborrow_part = xbcass_part
                    and xsborrow_lot = xbcass_lot
                no-error.
            if available(xsborrow_det) then do:
                delete xsborrow_det.
            end.
            delete xbcass_det.
        end.
        
        
        for each xbcass_det
            where xbcass_type = sQadType[1]
                and xbcass_order = wo_lot
                and xbcass_line = 0
                and not(xbcass_is_assembled)
                and not(xbcass_is_temp)
        :
            {xxvalidbcldless1.i
                wo_site 
                sCscfLoc 
                xbcass_part
                xbcass_lot
                bIsLess
            }
            if bIsLess then do:
                next.
            end.
            
            {xsbcldtrans.i
                wo_site
                sWorkplaceLoc
                xbcass_part
                xbcass_lot
                1
                """"
            }
                
            {xsbctrhist.i
                wo_site
                sWorkplaceLoc
                xbcass_part
                xbcass_lot
                1
                """"
                sQadType[1]
                0
                wo_nbr
                wo_lot
                sBarcodeType[12]
            }
            
            delete xbcass_det.
        end.
        
        
    end.
end.



