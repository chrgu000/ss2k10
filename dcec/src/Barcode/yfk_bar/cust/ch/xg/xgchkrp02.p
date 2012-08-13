/****************************************************
** Program:xgchkrp01.p
** Author :Li Wei , AtosOrigin
** Date   :2005-8-15
****************************************************/

define variable part like xwck_part.
define variable part1 like xwck_part.
define variable lot like xwck_lot.
define variable lot1 like xwck_lot.
define variable lin like xwck_lnr.
define variable lin1 like xwck_lnr.
define variable dt like xwck_date.
define variable dt1 like xwck_date.
define variable pal like xwck_pallet.
define variable pal1 like xwck_pallet.

define variable flg like xwck_type.


{mfdtitle.i "b+ "}


FORM
    part    COLON 20
    part1   label {t001.i} colon 49 skip
    lot     COLON 20
    lot1    label {t001.i} colon 49 skip
    lin     COLON 20
    lin1    label {t001.i} colon 49 skip
    pal     COLON 20
    pal1    label {t001.i} colon 49 skip
    dt      COLON 20
    dt1     label {t001.i} colon 49 skip
    flg     colon 20  "  (1 合格; 2 次品)"
    skip(1)
with frame a side-labels width 80 attr-space.

    IF part1 = hi_char THEN part1 = "".
    IF lot1 = hi_char THEN lot1 = "".
    IF lin1 = hi_char THEN lin1 = "".
    if pal1 = hi_char then pal1 = "".
    IF dt = low_date THEN dt = ?.
    IF dt1 = hi_date THEN dt1 = ?.

    update
    part part1
    lot lot1
    lin lin1
    pal pal1
    dt dt1
    flg
    with frame a.


    {mfquoter.i part}
    {mfquoter.i part1}
    {mfquoter.i lot}
    {mfquoter.i lot1}
    {mfquoter.i lin}
    {mfquoter.i lin1}
    {mfquoter.i pal}
    {mfquoter.i pal1}
    {mfquoter.i dt}
    {mfquoter.i dt1}

    
    IF  part1 = ""  THEN part1 = hi_char .
    IF  lot1  = ""  THEN lot1  = hi_char .
    IF  lin1  = ""  THEN lin1  = hi_char .
    if  pal1  = ""  then pal1  = hi_char.

    IF  dt = ?      THEN dt = low_date.
    IF  dt1 = ?     THEN dt1 = hi_date.

    {mfselbpr.i "terminal" 132}
    {mfphead.i}

    for each xwck_mstr no-lock where xwck_part >= part and xwck_part <= part1
                         and xwck_lot >= lot and xwck_lot <= lot1
                         and xwck_lnr >= lin and xwck_lnr <= lin1
                         and xwck_pallet >= pal and xwck_pallet <= pal1
                         and xwck_date >= dt and xwck_date <= dt1
                         AND xwck_shipper = ""
                         and (xwck_type = flg or flg = "")
                         BREAK BY xwck_lot
                         BY xwck_date:
        display 
        xwck_pallet
        xwck_part
        xwck_lot
        xwck_cust
        xwck_date
        string(xwck_time,"HH:MM:SS") label "审核时间"
        xwck_lnr
        xwck_qty_chk
        xwck_shipper
        xwck_stat
        xwck_type
        xwck_blkflh
        with stream-io width 160.

    end.
                               
    {mfrtrail.i}
