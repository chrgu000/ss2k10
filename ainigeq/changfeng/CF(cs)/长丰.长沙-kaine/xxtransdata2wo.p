/* SS - 091111.1 By: Kaine Zhang */
/* SS - 100203.1 By: Kaine Zhang */

/*
 *  20100202.email
 *  new work order's status: set to 'B'.
 */
 
define input parameter dteImport as date.
define input parameter iImport as integer.

{mfdeclre.i}

define temp-table t1_tmp no-undo
    field t1_part as character
    field t1_qty as decimal
    .

define variable sPartFromSerial as character no-undo.
define variable sPartFromColor as character no-undo.
define variable sWoNbr as character no-undo.
define variable sWoLot as character no-undo.
define variable sRmks as character no-undo.
define variable decOldQty as decimal no-undo.
define variable decTransQty as decimal no-undo.
define variable decNewQty as decimal no-undo.

define variable sInputFile as character no-undo.
define variable sOutputFile as character no-undo.

empty temp-table t1_tmp.

for each xcswo_mstr
    where not(xcswo_trans_to_sf)
    use-index xcswo_istrans_part_importtime
    break
    by xcswo_serial
    by xcswo_color
:
    if first-of(xcswo_serial) then do:
        {xxpartfromserial.i xcswo_serial sPartFromSerial}
    end.
    if first-of(xcswo_color) then do:
        {xxpartfromcolor.i xcswo_color sPartFromColor}

        /* todo start # here, hard code the rule of "IO" type. todo!!!! get common rules */
        {xxpartruleofio.i}
        /* todo finish # here, hard code the rule of "IO" type. todo!!!! get common rules */
    end.

    accumulate xcswo_qty (total by xcswo_color).

    if last-of(xcswo_color) then do:
        if xcswo_sf_part <> sPartFromSerial + sPartFromColor then do:
            {pxmsg.i &msgnum=9007 &msgarg1=xcswo_sf_part}
            xcswo_sf_part = sPartFromSerial + sPartFromColor.
        end.

        find first t1_tmp
            where t1_part = xcswo_sf_part
            no-error.
        if not(available(t1_tmp)) then do:
            create t1_tmp.
            t1_part = xcswo_sf_part.
        end.
        t1_qty = t1_qty + accum total by xcswo_color xcswo_qty .
    end.
end.


assign
    sInputFile = "Trans.WO." + mfguser + string(dteImport, "99999999") + ".in"
    sOutputFile = "Trans.WO." + mfguser + string(dteImport, "99999999") + ".out"
    sRmks = string(dteImport) + " " + string(iImport, "HH:MM:SS").
    .

for each t1_tmp 
    where t1_part <> ""
        and can-find(first pt_mstr no-lock where pt_part = t1_part):
    sWoNbr = "WO" + t1_part + string(year(dteImport) - 2000, "99")
        + string(month(dteImport), "99")
        + string(day(dteImport), "99")
        .
    
    {pxmsg.i &msgnum=9012 &msgarg1=sWoNbr}

    find first wo_mstr
        where wo_nbr = sWoNbr
        no-error.
    if available(wo_mstr) then
        assign
            sWoLot = wo_lot
            decOldQty = wo_qty_ord
            decTransQty = t1_qty + wo_qty_ord
            .
    else
        assign
            sWoLot = ""
            decOldQty = 0
            decTransQty = t1_qty
            .


    if sWoLot = "" then do:
        {xxtransdata2wonewid.i}
    end.
    else do:
        {xxtransdata2wooldid.i}
    end.

    batchrun = yes.
    input from value(sInputFile).
    output to value(sOutputFile).
    {gprun.i ""wowomt.p""}
    output close.
    input close.
    batchrun = no.

    if sWoLot = "" then do:
        find first wo_mstr
            no-lock
            where wo_nbr = sWoNbr
            no-error.
        if available(wo_mstr) then
            assign
                decNewQty = wo_qty_ord
                sWoLot = wo_lot
                .
    end.
    else do:
        find first wo_mstr
            no-lock
            where wo_nbr = sWoNbr
                and wo_lot = sWoLot
            no-error.
        if available(wo_mstr) then decNewQty = wo_qty_ord.
    end.
    if decNewQty <> decTransQty then do:
        {pxmsg.i &msgnum = 9008 &msgarg1 = t1_part}
        for each xcswo_mstr
            where not(xcswo_trans_to_sf)
                and xcswo_sf_part = t1_part
        :
            assign
                xcswo_trans_date = dteImport
                xcswo_trans_time = iImport
                xcswo_is_trans_error = yes
                .
        end.
    end.
    else do:
        {pxmsg.i &msgnum = 9009 &msgarg1 = t1_part}
        for each xcswo_mstr
            where not(xcswo_trans_to_sf)
                and xcswo_sf_part = t1_part
        :
            assign
                xcswo_trans_date = dteImport
                xcswo_trans_time = iImport
                xcswo_is_trans_error = no
                xcswo_trans_to_sf = yes
                xcswo_wo_id = sWoLot
                .
        end.
    end.
end.

os-delete value(sInputFile).
os-delete value(sOutputFile).


