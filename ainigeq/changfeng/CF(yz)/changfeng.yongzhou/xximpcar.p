/* SS - 091027.1 By: Kaine Zhang */

{mfdtitle.i "091027.1"}

define variable sFileName as character format "x(50)" no-undo.
define variable bConfirm as logical no-undo.

define variable sVin as character no-undo.
define variable sType as character no-undo.
define variable dteSaleDate as date no-undo.
define variable sShipTo as character no-undo.
define variable sCompany as character no-undo.
define variable sName as character no-undo.

define variable iErrorLine as integer no-undo.
define variable iSucceedLine as integer no-undo.


define variable sExample as character format "x(30)" initial "/home/mfg/200910.csv" no-undo.

form
    sFileName   colon 10        label "File"
    sExample    colon 10        label "Example"
    skip(1)
with frame a side-labels width 80.
setframelabels(frame a:handle).


view frame a.
display sExample with frame a.


repeat on endkey undo, leave:
    update
        sFileName
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
            sVin
            sType
            dteSaleDate
            sShipTo
            sCompany
            sName
            .
        if sVin = "" then next.

        if length(sVin) <> 17 then do:
            iErrorLine = iErrorLine + 1.
            next.
        end.

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
        assign
            xcar_type = sType
            xcar_sale_date = dteSaleDate
            xcar_ship_to = sShipTo
            xcar_company = sCompany
            xcar_name = sName
            .
        iSucceedLine = iSucceedLine + 1.
    end.
    input close.

    status default "".

    {pxmsg.i &msgnum=9028 &msgarg1=iSucceedLine &msgarg2=iErrorLine}
end.

