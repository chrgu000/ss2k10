/*************************************************
** Program: xgpalrp01.p
** Author : Li Wei , AtosOrigin
** Date   : 2006-2-21
** Description: Finish Goods pallet iq
*************************************************/

{mfdtitle.i}
define variable pal1 like xwck_pallet.
define variable pal2 like xwck_pallet.
define variable pt1 like xwck_part.
define variable pt2 like xwck_part.
define variable lotfm like xwck_lot LABEL "批号".
define variable lotto like xwck_lot.
define variable dtfm  like xwck_prd_date LABEL "生产日期".
define variable dt2  like xwck_prd_date.
define variable shpdtfm  like xwck_prd_date LABEL "发运日期".
define variable shpdt2  like xwck_prd_date.
DEFINE VARIABLE shipyn AS CHAR INITIAL "A". 
DEFINE VARIABLE shipperfm LIKE xwck_shipper.
DEFINE VARIABLE shipperto LIKE xwck_shipper.
DEFINE VARIABLE qtytotal AS INTEGER. 
DEFINE VARIABLE nobackflh AS LOGICAL. 


form
    pal1    colon  10 
    pal2    colon  40  label {t001.i}
    pt1     colon  10 
    pt2     colon  40  label {t001.i}
    lotfm    colon  10 LABEL "批号"
    lotto    colon  40  label {t001.i}
    dtfm     colon  10  LABEL "生产日期"
    dt2     colon  40  label {t001.i}
    shpdtfm     colon  10  LABEL "发运日期"
    shpdt2     colon  40  label {t001.i}
    shipperfm     colon  10  LABEL "发运单"
    shipperto     colon  40  label {t001.i}
    shipyn COLON 30 LABEL "发运(A-all,S-ship,N-unship)"
    nobackflh COLON 20 LABEL "只显示未回冲"
with frame a side-labels width 80 attr-space.

mainloop:
repeat:

    if pal2 = hi_char  then pal2 = "".
    if lotto = hi_char  then lotto = "".
    if pt2  = hi_char  then pt2 = "".
    IF shipperto = hi_char THEN shipperto = "". 
    if dt2  = hi_date  then dt2 = ?.
    if shpdt2  = hi_date  then shpdt2 = ?.
    if dtfm  = low_date then dtfm = ?.
    if shpdtfm  = low_date then shpdtfm = ?.

    update
    pal1
    pal2
    pt1 
    pt2 
    lotfm
    lotto
    dtfm 
    dt2
    shpdtfm
    shpdt2
    shipperfm
    shipperto
    shipyn
    nobackflh
    with frame a.

    {mfquoter.i pal1   }
    {mfquoter.i pal2   }
    {mfquoter.i pt1    }
    {mfquoter.i pt2    }
    {mfquoter.i lotfm   }
    {mfquoter.i lotto   }
    {mfquoter.i dtfm    }
    {mfquoter.i dt2    }
    {mfquoter.i shpdtfm    }
    {mfquoter.i shpdt2    }
    {mfquoter.i shipperfm    }
    {mfquoter.i shipperto    }
    {mfquoter.i shipyn    }
    {mfquoter.i nobackflh    }

    if pal2 = "" then pal2 = hi_char.
    if lotto = "" then lotto = hi_char.
    if pt2 = ""  then pt2  = hi_char.
    IF shipperto = "" THEN shipperto = hi_char.
    if dt2 = ?   then dt2  = hi_date.
    if dtfm = ?   then dtfm  = low_date.
    if shpdt2 = ?   then shpdt2  = hi_date.
    if shpdtfm = ?   then shpdtfm  = low_date.

    /* PRINTER SELECTION */
    {mfselbpr.i "printer" 132}
    {mfphead.i}


    for each xwck_mstr where xwck_pallet >= pal1
                         and xwck_pallet <= pal2
                         and xwck_part >= pt1
                         and xwck_part <= pt2
                         and xwck_lot >= lotfm
                         and xwck_lot <= lotto
                         and xwck_prd_date >= dtfm
                         and xwck_prd_date <= dt2
                         and (xwck_shp_date >= shpdtfm OR xwck_shp_date = ?)
                         and (xwck_shp_date <= shpdt2 OR xwck_shp_date = ?)
                         AND xwck_shipper >= shipperfm
                         AND xwck_shipper <= shipperto
                         AND (IF nobackflh THEN xwck_blkflh = NO ELSE YES )
                        AND (IF shipyn = 's' THEN xwck_shipper <> '' ELSE ( IF shipyn = 'n' THEN xwck_shipper = '' ELSE YES)) 
                        USE-INDEX xwck_pal
                        break 
                        by xwck_part 
                        by xwck_pallet
                        by xwck_prd_date
                        by xwck_lot:
        IF FIRST-OF(xwck_part) THEN qtytotal = 0.
        qtytotal = qtytotal + xwck_qty_chk.

        display
        xwck_lnr
        xwck_part
        xwck_lot
        xwck_pallet
        xwck_qty_chk
        xwck_cust
        xwck_shipper
        xwck_loc_des
        xwck_prd_date
        xwck_shp_date
        xwck_wolot
        WITH width 200 stream-io.
        IF LAST-OF(xwck_part) THEN DO:
            DOWN 2 WITH STREAM-IO.
            PUT "subtotal-------------"   qtytotal .
        END.
    end.
    {mfreset.i}
end.

