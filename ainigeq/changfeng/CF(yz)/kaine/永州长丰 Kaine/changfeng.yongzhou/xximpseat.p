/* SS - 091027.1 By: Kaine Zhang */

{mfdtitle.i "091027.1"}

define variable sFileName as character format "x(50)" no-undo.
define variable sFlag as character format "x(4)" no-undo.
define variable bConfirm as logical no-undo.

define variable sBarcode as character no-undo.
define variable sVin as character no-undo.
define variable sType as character no-undo.

define variable iErrorLine as integer no-undo.
define variable iSucceedLine as integer no-undo.
define variable sPart as character no-undo.
define variable sLot as character no-undo.
define variable iSeq as integer no-undo.

define variable sExample as character format "x(30)" initial "/home/mfg/200910.csv" no-undo.
form
    sFileName   colon 10        label "File"
    sExample    colon 10        label "Example"
    skip(1)
    sFlag       colon 10        label "Flag"
with frame a side-labels width 80.
setframelabels(frame a:handle).



view frame a.
display sExample with frame a.

repeat on endkey undo, leave:
    update
        sFileName
        sFlag
    with frame a.

    /* block.001.start # check the file */
    file-info:file-name = sFileName.
    if file-info:full-pathname = ? then do:
        {pxmsg.i &msgnum=9025 &errorlevel=3}
        undo, retry.
    end.
    if substring(file-info:file-type, 1, 1) = "D" then do:
        {pxmsg.i &msgnum=9026 &errorlevel=3}
        undo, retry.
    end.
    if file-info:file-size = 0 then do:
        {pxmsg.i &msgnum=9027 &errorlevel=3}
        undo, retry.
    end.
    /* block.001.finish # check the file */

    {pxmsg.i
        &msgnum = 12
        &confirm = bConfirm
    }
    if not(bConfirm) then undo, retry.

    assign
        iErrorLine = 0
        iSucceedLine = 0
        .

    status default "Importing...".

    input from value(sFileName).
    repeat:
        import
            delimiter ","
            sBarcode
            sVin
            sType
            .
        if sBarcode = "" then next.

        /* block.002.start # check whether has error input */
        for first xcard_det
            no-lock
            where xcard_seat = sBarcode
            use-index xcard_seat
        :
        end.
        if available(xcard_det) then do:
            create xerr1_det.
            assign
                xerr1_date = today
                xerr1_flag = sFlag
                xerr1_barcode = sBarcode
                xerr1_reason = if xcard_vin = sVin then 1 else 2
                iErrorLine = iErrorLine + 1
                .
            next.
        end.

        if length(sVin) <> 17 then do:
            create xerr1_det.
            assign
                xerr1_date = today
                xerr1_flag = sFlag
                xerr1_barcode = sBarcode
                xerr1_reason = 3
                iErrorLine = iErrorLine + 1
                .
            next.
        end.

        assign
            sPart = entry(1, sBarcode, "-")
            sLot = entry(2, sBarcode, "-")
            no-error
            .
        if error-status:error then do:
            create xerr1_det.
            assign
                xerr1_date = today
                xerr1_flag = sFlag
                xerr1_barcode = sBarcode
                xerr1_reason = 4
                iErrorLine = iErrorLine + 1
                .
            next.
        end.

        if substring(sPart, 1, 3) <> "003" then do:
            create xerr1_det.
            assign
                xerr1_date = today
                xerr1_flag = sFlag
                xerr1_barcode = sBarcode
                xerr1_reason = 5
                iErrorLine = iErrorLine + 1
                .
            next.
        end.
        /* block.002.finish # check whether has error input */
        
        sPart = substring(sPart, 4).
        iSeq = 0.
        for first pt_mstr
            no-lock
            where pt_part = sPart
        :
        end.
        if available(pt_mstr) then do:
            iSeq = integer(pt_drwg_size) no-error.
        end.
        
        /* do not need, in txt file, the barcode hasnot the "+"
        sLot = substring(sLot, 1, length(sLot) - 1).
        */

        create xcard_det.
        assign
            xcard_vin        = sVin
            xcard_seat       = sBarcode
            xcard_seq        = iSeq
            xcard_part       = sPart
            xcard_lot        = sLot
            xcard_input_date = today
            xcard_input_time = time
            xcard_input_user = global_userid
            .
        iSucceedLine = iSucceedLine + 1.

        /* if there is not xcar_mstr exist, then create it */
        find first xcar_mstr
            where xcar_vin = sVin
            no-error.
        if not(available(xcar_mstr)) then do:
            create xcar_mstr.
            assign
                xcar_vin = sVin
                xcar_type = sType
                xcar_scan_date = today
                xcar_scan_user = global_userid
                .
        end.
    end.
    input close.

    status default "".

    {pxmsg.i &msgnum=9028 &msgarg1=iSucceedLine &msgarg2=iErrorLine}
end.

