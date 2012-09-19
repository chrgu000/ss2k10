/* xxxxcode.p  - cab gen code maintenance                             */
/* VER:          DATED:2001-03-13     BY:James Zou     MARK:AOCAB001 */

/* DISPLAY TITLE */
{mfdtitle.i "120918.1"}

define variable v_code        LIKE code_fldname.
define variable v_fldname     like code_fldname.
define variable v_tit         as character.
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
   RECT-FRAME       AT ROW 1.4 COLUMN 1.25
   RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
   SKIP(.1)
    v_code colon 10 LABEL "控制单元"
    SKIP(1)
with frame f-a side-labels width 80 attr-space NO-BOX THREE-D.
DEFINE VARIABLE F-a-title AS CHARACTER.
   F-a-title ="控制单元".
   RECT-FRAME-LABEL:SCREEN-VALUE in frame f-a = F-a-title.
   RECT-FRAME-LABEL:WIDTH-PIXELS in frame f-a =
   FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
   RECT-FRAME-LABEL:SCREEN-VALUE in frame f-a + " ", RECT-FRAME-LABEL:FONT).
   RECT-FRAME:HEIGHT-PIXELS in frame f-a =
   frame f-a:HEIGHT-PIXELS - RECT-FRAME:Y in frame f-a - 2.
   RECT-FRAME:WIDTH-CHARS IN frame f-a = frame f-a:WIDTH-CHARS - .5.
&UNDEFINE PP_FRAME_NAME
setFrameLabels(frame f-a:handle).

FORM
    code_value
    code_cmmt
    code_user1
    code_user2
    code_desc
    with row 6 centered title "[A] addd new data [D] delete [Entry] modify"
    overlay down frame f-b width 78.
setFrameLabels(frame f-b:handle).

FORM
    code_value
    code_cmmt
    code_user1
    code_user2
    code_desc
    with row 6 centered title "[A] addd new data [D] delete [Entry] modify"
    overlay down frame f-c width 78.
setFrameLabels(frame f-b:handle).

repeat with frame f-a:
   prompt-for v_code editing:

      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp.i code_mstr v_code
             " code_domain = global_domain and code_fldname = 'xx-system' and code_value "
             v_code code_value code_fldval}

      if recno <> ? then do:
         assign v_code = code_value
                v_fldname = code_cmmt
                v_tit = code_desc.
         display v_code with frame f-a.
      end.
   end. /* editing: */


    MainBlock:
    do on error undo,leave on endkey undo,leave:
     { tijscroll.i
          &file = "code_mstr"
          &where = "where (code_domain = global_domain and code_fldname = v_fldname)"
          &frame = "f-b"
          &fieldlist = " code_value
                         code_cmmt
                         code_user1
                         code_user2
                         code_desc
                        "
          &prompt     = "code_value"
          &index      = "use-index code_fldval"
          &midchoose  = "color mesages"
          &predisplay = "~ run xxcode_m-predisplay. ~ "
          &updkey     = "Enter"
          &updcode    = "~ run xxcode_m-update. ~"
          &inskey     = "A"
          &inscode    = "~ run xxcode_m-add. ~"
          &delkey     = "D"
          &delcode    = "~ run xxcode_m-delete. ~"
      }

    end. /*MAIN BLOCK */
end.


PROCEDURE xxcode_m-predisplay.
    hide message no-pause.
END PROCEDURE.

PROCEDURE xxcode_m-update.
    find code_mstr where recid(code_mstr) = w-rid[Frame-line(f-b)]
    exclusive-lock no-error.

    if not available code_mstr then leave .
    display
         code_value
         code_cmmt
         code_user1
         code_user2
         code_desc
    with frame f-b.
    UPDATE
        code_cmmt
        code_user1
        code_user2
        code_desc
    with frame f-b.
    ASSIGN code_domain   = GLOBAL_domain.
  /*  HIDE FRAME f-b NO-PAUSE. */
END PROCEDURE.

PROCEDURE xxcode_m-add.

    clear frame f-c ALL no-pause.

    REPEAT WITH FRAME f-c:
       prompt-for
          code_value
          code_cmmt
          code_user1
          code_user2
          code_desc
       WITH FRAME f-c.

       find first code_mstr where code_domain = global_domain
              and code_fldname = v_fldname
              and code_value = input frame f-c code_value no-lock no-error.

       if available code_mstr then do:
            message "ERR:data already Exists.".
            UNDO,RETRY.
       end.
       create code_mstr. code_domain = global_domain.
       assign
           code_fldname = v_fldname
           code_value = input frame f-c code_value
           code_cmmt  = input frame f-c code_cmmt
           code_user1 = input frame f-c code_user1
           code_user2 = input frame f-c code_user2
           code_desc  = input frame f-c code_desc
           .
       w-newrecid = recid(code_mstr).
       DOWN 1 WITH FRAME f-c.
   END.
   hide frame f-pop no-pause.
END PROCEDURE.

PROCEDURE xxcode_m-delete.
    define variable v_confirm as logical.
    find code_mstr where recid(code_mstr) = w-rid[Frame-line(f-b)]
    exclusive-lock no-error.
    if not available code_mstr THEN LEAVE.
/*  message "Confirm delete the record?" update v_confirm.   */
    {mfmsg01.i 11 2 v_confirm}
    if v_confirm and available code_mstr then do:
        delete code_mstr.
    end.
END PROCEDURE.

PROCEDURE xxcode_m-detail.
    find code_mstr where recid(code_mstr) = w-rid[Frame-line(f-b)]
    no-lock no-error.
    define variable v1 as character.
    define variable v2 as character.
    define variable v3 as character.
    define variable v4 as character.
    define variable v5 as character.

    assign v1 = entry(1 , v_tit ,"|")
           v2 = entry(2 , v_tit ,"|")
           v3 = entry(3 , v_tit ,"|")
           v4 = entry(4 , v_tit ,"|")
           v5 = entry(5 , v_tit ,"|") no-error.

    if not available code_mstr then leave .
    display
          code_value
          code_cmmt
          code_user1
          code_user2
          code_desc
    with frame f-b.
END PROCEDURE.
