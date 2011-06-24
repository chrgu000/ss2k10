/* SS - 091110.1 By: Kaine Zhang */

define input parameter dteImport as date.
define input parameter iImport as integer.

{mfdeclre.i}

define variable sPathSet as character initial "ss_sofa_vin_webfile" no-undo.
define variable sFilePath as character no-undo.
define variable sExecName as character initial "getRemoteData.bat" no-undo.
define variable sResult as character initial "resultData.txt" no-undo.

define variable sVin as character no-undo.
define variable sX1 as character no-undo.
define variable sX2 as character no-undo.
define variable sSerial as character no-undo.
define variable sColor as character no-undo.
define variable sID as character no-undo.
define variable sCar as character no-undo.
define variable sLoc as character no-undo.
define variable sDatetime as character no-undo.

define variable sPartFromSerial as character no-undo.
define variable sPartFromColor as character no-undo.

define variable i as integer no-undo.
define variable j as integer no-undo.
define variable sCharacterTime as character.
sCharacterTime = replace(string(iImport, "HH:MM:SS"), ":", "").


find first code_mstr
    no-lock
    where code_fldname = sPathSet
        and code_value = sPathSet
    no-error.
if available(code_mstr) then sFilePath = code_cmmt.

os-delete value(sFilePath + sResult).

os-command silent value(sExecName). 

file-info:file-name = sFilePath + sResult.
if file-info:full-pathname = ? then do:
    {pxmsg.i &msgnum=9004 &errorlevel=3}
    return.
end.
if substring(file-info:file-type, 1, 1) = "D" then do:
    {pxmsg.i &msgnum=9005 &errorlevel=3}
    return.
end.
if file-info:file-size = 0 then do:
    {pxmsg.i &msgnum=9006 &errorlevel=3}
    return.
end.


input from value(sFilePath + sResult)
    convert target SESSION:CHARSET source "UTF-8".
output to value(sFilePath + string(dteImport, "99999999") + "." + sCharacterTime + ".txt").
put
    unformatted
    "VIN号" at 1    "~t"
    "车型"  "~t"
    "车身颜色"  "~t"
    "生产批次号"  "~t"
    "整车编码"  "~t"
    "备注" "~t"
    "当前位置"  "~t"
    "通过时间"
    .
assign
    i = 0
    j = 0
    .
repeat:
    import
        delimiter "~t"
        sVin
        sX1
        sSerial
        sColor
        sID
        sCar
        sX2
        sLoc
        sDatetime
        .
    if sLoc = "A-01" then do:
        find first xvin_det
            where xvin_vin = sVin
            use-index xvin_vin
            no-error.
        if not(available(xvin_det)) then do:
            i = i + 1.
            create xvin_det.
            assign
                xvin_vin = sVin
                xvin_serial = sSerial
                xvin_color = substring(sCar, max(0, length(sCar) - 1))
                xvin_base_wo_id = sID
                xvin_car = sCar
                xvin_location = sLoc
                xvin_pass_time = sDatetime
                xvin_import_date = dteImport
                xvin_import_time = iImport
                .
        end.
        else do:
            j = j + 1.
        end.
    end.
    else if sLoc <> "" then
        j = j + 1.

    put
        unformatted
        sVin   at 1     "~t"
        sSerial "~t"
        sColor "~t"
        sID "~t"
        sCar "~t"
        sX2 "~t"
        sLoc "~t"
        sDatetime
        .
end.
output close.
input close.

os-delete value(sFilePath + sResult).

{pxmsg.i &msgnum=9010 &msgarg1=i &msgarg2=j}

i = 0.
for each xvin_det
    no-lock
    where xvin_import_date = dteImport
        and xvin_import_time = iImport
    use-index xvin_import_datetime
    break
    by xvin_serial
    by xvin_color
:
    if first-of(xvin_serial) then do:
        {xxpartfromserial.i xvin_serial sPartFromSerial}
    end.
    if first-of(xvin_color) then do:
        {xxpartfromcolor.i xvin_color sPartFromColor}

        /* todo start # here, hard code the rule of "IO" type. todo!!!! get common rules */
        {xxpartruleofio.i}
        /* todo finish # here, hard code the rule of "IO" type. todo!!!! get common rules */
    end.
    
    accumulate xvin_vin (count by xvin_color).

    if last-of(xvin_color) then do:
        find first xcswo_mstr
            where xcswo_import_date = dteImport
                and xcswo_import_time = iImport
                and xcswo_serial = xvin_serial
                and xcswo_color = xvin_color
            no-error.
        if not(available(xcswo_mstr)) then do:
            i = i + 1.
            create xcswo_mstr.
            assign
                xcswo_import_date = dteImport
                xcswo_import_time = iImport
                xcswo_serial = xvin_serial
                xcswo_color = xvin_color
                .
        end.
        assign
            xcswo_sf_part = sPartFromSerial + sPartFromColor
            xcswo_qty = accum count by xvin_color xvin_vin
            .
    end.
end.
{pxmsg.i &msgnum=9011 &msgarg1=i}

