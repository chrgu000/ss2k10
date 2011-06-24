/* xxb2sfm.p -- */
/* Copyright 200911 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 091110.1 By: Kaine Zhang */

/* SS - 091110.1 - RNB
[091110.1]
Get the Changfeng Base's VIN Date, and trans them to sofa's Work Order.  By manual.
[091110.1]
SS - 091110.1 - E */

{mfdtitle.i "091112.1"}

define variable bGo as logical initial yes no-undo.
define variable iLastTime as integer no-undo.
define variable dteNext as date no-undo.
define variable iNextTime as integer no-undo.
define variable bTrans as logical no-undo.
define variable iStepTime as integer no-undo.
define variable iBalanceTime as integer no-undo.

define variable s1 as character no-undo.
define variable s2 as character no-undo.
define variable s3 as character no-undo.

form
    skip(1)
    bGo colon 15    label "Trans Data"
    skip(1)
with frame a side-labels width 80.
setframelabels(frame a:handle).


update
    bGo
with frame a.
if not(bGo) then do:
    {pxmsg.i &msgnum=9002}
    return.
end.

assign
    iStepTime = 600
    iBalanceTime = iStepTime * 1.2
    iLastTime = time
    dteNext = low_date
    iNextTime = 0
    .
find first xgetdata_ctrl
    no-lock
    where xgetdata_time > iLastTime
    use-index xgetdata_time
    no-error.
if available(xgetdata_ctrl) then do:
    assign
        dteNext = today
        iNextTime = xgetdata_time
        bTrans = xgetdata_trans
        .
end.
else do:
    find first xgetdata_ctrl
        no-lock
        use-index xgetdata_time
        no-error.
    if available(xgetdata_ctrl) then
        assign
            dteNext = today + 1
            iNextTime = xgetdata_time
            bTrans = xgetdata_trans
            .
end.

if dteNext = low_date then do:
    {pxmsg.i &msgnum=9003}
    return.
end.




repeat on endkey undo, leave:

    find first xgetdata_ctrl
        no-lock
        where xgetdata_time > iLastTime
        use-index xgetdata_time
        no-error.
    if available(xgetdata_ctrl) then do:
        assign
            dteNext = today
            iNextTime = xgetdata_time
            bTrans = xgetdata_trans
            .
    end.
    else do:
        find first xgetdata_ctrl
            no-lock
            use-index xgetdata_time
            no-error.
        if available(xgetdata_ctrl) then
            assign
                dteNext = today + 1
                iNextTime = xgetdata_time
                bTrans = xgetdata_trans
                .
    end.
    assign
        s1 = string(time, "HH:MM:SS")
        s2 = string(iLastTime, "HH:MM:SS")
        s3 = string(dteNext) + " " + string(iNextTime, "HH:MM:SS")
        .
    {pxmsg.i
        &msgnum = 9001 
        &msgarg1 = s1
        &msgarg2 = s2
        &msgarg3 = s3
    }

    pause iStepTime message "Wait...".

    assign
        dteNext = today
        iNextTime = time.
        .

    status default "Get Data...".

    find first code_mstr
        where code_fldname = "ss_sofa_web_status"
            and code_value = "ss_sofa_web_status"
        no-error.
    if not(available(code_mstr)) then do:
        create code_mstr.
        assign
            code_fldname = "ss_sofa_web_status"
            code_value = "ss_sofa_web_status"
            .
    end.
    code_cmmt = "running...".
            
    {gprun.i
        ""xxgetbasedata.p""
        "(input dteNext, input iNextTime)"
    }

    status default "Trans WO...".
    {gprun.i
        ""xxtransdata2wo.p""
        "(input dteNext, input iNextTime)"
    }

    status default "Done.".
    status default "".

    iLastTime = iNextTime.

    code_cmmt = "ready".
    release code_mstr.

end.



