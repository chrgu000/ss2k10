/* DISPLAY TITLE */
{mfdtitle.i "e+ "}
{yyedcomlib.i}
IF f-howareyou("HAHA") = NO THEN LEAVE.

define variable v_key          as character.
define variable del-yn like mfc_logical initial no.
DEFINE VARIABLE v_confirm AS LOGICAL NO-UNDO.
DEFINE VARIABLE v_recid AS RECID.


define TEMP-TABLE ttt1
    fields ttt1_i as integer
    FIELDS ttt1_desc AS CHAR FORMAT "x(20)"
    fields ttt1_cmmt as char format "x(50)"
    INDEX  ttt1_idx1 IS PRIMARY UNIQUE ttt1_i.
    .

form
    usrw_key2               FORMAT "x(8)"   label "传输控制码"
    usrw_charfld[1]         FORMAT "x(50)"  LABEL "描述"         
    usrw_charfld[2]         FORMAT "x(50)"  LABEL "传输工作路径"
    usrw_charfld[3]         FORMAT "x(50)"  LABEL "备份文件路径"
    usrw_charfld[4]         FORMAT "x(50)"  LABEL "传输日志路径"
    usrw_charfld[5]         FORMAT "x(50)"  LABEL "传输命令"
with frame a THREE-D side-label 1 COLUMN width 80 .
setFrameLabels(frame a:handle).


v_key = "XXEDADDPM".

/* DISPLAY */
view frame a.

mainloop:
REPEAT:
      prompt-for 
          usrw_key2
      WITH FRAME a editing:

         if frame-field = "usrw_key2" then do:

            {mfnp05.i usrw_wkfl usrw_index1
               "usrw_key1 = v_key"
               usrw_key2
               "input usrw_key2"}

            if recno <> ? then do:

               display
                   usrw_key2
                   usrw_charfld[1]
                   usrw_charfld[2]
                   usrw_charfld[3]
                   usrw_charfld[4]
                   usrw_charfld[5]
                WITH FRAME a.
            end.
         end. 
         else do:
            status input.
            readkey.
            apply lastkey.
         end.
      end.

    /* ADD/MOD/DELETE  */
    FIND FIRST usrw_wkfl WHERE usrw_key1 = v_key AND usrw_key2 = INPUT FRAME a usrw_key2 NO-ERROR.
    IF NOT AVAILABLE usrw_wkfl THEN DO:
        {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
        create usrw_wkfl.
        assign usrw_key1 = v_key
               usrw_key2 = INPUT FRAME a usrw_key2.
    END.
    ststatus = stline[2].
    status input ststatus.

    DISPLAY
        usrw_key2
        usrw_charfld[1]
        usrw_charfld[2]
        usrw_charfld[3]
        usrw_charfld[4]
        usrw_charfld[5]
        WITH FRAME a.
    v_recid = RECID(usrw_wkfl).

    UPDATE
        usrw_charfld[1]
        usrw_charfld[2]
        usrw_charfld[3]
        usrw_charfld[4]
        usrw_charfld[5]
    go-on(F5 CTRL-D) WITH FRAME a.
              
    if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
    then do:
        del-yn = yes.
        /* Please confirm delete */
        {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
        if del-yn then do:
            delete usrw_wkfl.
            clear frame a.
            CLEAR frame f-main ALL.
        end. /* if del-yn then do: */
    end. /* then do: */

end. 

status input.

