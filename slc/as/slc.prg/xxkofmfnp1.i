/*!
Input Parameters:
{1} table
{2} index
{3} field
{4} variable
*/

ststatus = stline[1].
status input ststatus.
readkey.
hide message no-pause.

if lastkey = keycode("F10")
    or keyfunction(lastkey) = "CURSOR-DOWN"
then do:    /* FIND NEXT RECORD */
    find next {1} where {3} >= {4} use-index {2} no-lock no-error.

    if not available {1} then do:
        {pxmsg.i &MSGNUM=20 &ERRORLEVEL=2}  /* End of file */
        if recno = ? then
            find first {1} use-index {2}
                no-lock no-error.
        else if recno <> ? then
            find {1} where recno = recid({1}) no-lock no-error.
        input clear.
    end.
    recno = recid({1}).
end.
else if lastkey = keycode("F9")
    or keyfunction(lastkey) = "CURSOR-UP"
then do:    /* FIND PREVIOUS RECORD  */
    find prev {1} where {3} <= {4} use-index {2} no-lock no-error.

    if not available {1} then do:
        {pxmsg.i &MSGNUM=21 &ERRORLEVEL=2}  /* Beginning of file */
        if recno = ? then
            find last {1} use-index {2} no-lock no-error.
        else if recno <> ? then
            find {1} where recno = recid({1}) no-lock no-error.
        input clear.
    end.
    recno = recid({1}).
end.
else do:    /* INPUT PROMPT FIELD */
    recno = ?.
    if keyfunction(lastkey) = "end-error" then do:
        ststatus = stline[3].
        status input ststatus.
    end.
    apply lastkey.
end.
