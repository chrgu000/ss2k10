/* xxxxcode.p  - cab gen code maintenance                             */
/* VER:          DATED:2001-03-13     BY:James Zou     MARK:AOCAB001 */

/* DISPLAY TITLE */
{mfdtitle.i "e+ "}

define variable pop-tit        as character no-undo.
define variable v_confirm      as logical   format "Yes/No" no-undo.
DEFINE VARIABLE v_err          AS CHARACTER FORMAT "X(30)".
define variable i              as integer.
define variable v_code         as character.
define variable v_name        as character.
define variable v_key          as character.
DEF    VAR      v_label        AS CHAR EXTENT 7.

&SCOPED-DEFINE PP_FRAME_NAME A
FORM
   RECT-FRAME       AT ROW 1.4 COLUMN 1.25
   RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
   SKIP(.1)
    v_code colon 10 LABEL "控制单元"
    SKIP(1)
with frame a side-labels width 80 attr-space NO-BOX THREE-D.
DEFINE VARIABLE F-a-title AS CHARACTER.
   F-a-title ="控制单元".
   RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
   RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
   FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
   RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
   RECT-FRAME:HEIGHT-PIXELS in frame a =
   frame a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
   RECT-FRAME:WIDTH-CHARS IN frame a = frame a:WIDTH-CHARS - .5.
&UNDEFINE PP_FRAME_NAME
setFrameLabels(frame a:handle).

/*  form                                                                     */
/*      v_code         format "x(20)"   label "控制单元"                     */
/*      /*v_name         FORMAT "x(26)" NO-LABEL*/                           */
/*  with frame a side-label width 80.                                        */
/*  setFrameLabels(frame a:handle).                                          */

form
    code_value      format "x(12)"
    code_cmmt       format "x(24)"
    code_user1      format "x(8)"
    code_user2      format "x(8)"
    code_desc       FORMAT "x(100)" VIEW-AS FILL-IN SIZE 20 BY 1
with  centered /*overlay*/ TITLE "[A] add new data [D] delete [Enter] modify" down frame f-main width 80.
setFrameLabels(frame f-main:handle).

form
    code_value      format "x(12)"
    code_cmmt       format "x(24)"
    code_user1      format "x(8)"
    code_user2      format "x(8)"
    code_desc       FORMAT "x(100)" VIEW-AS FILL-IN SIZE 20 BY 1
with width 80 title pop-tit overlay DOWN center frame f-pop .
setFrameLabels(frame f-pop:handle).


find first code_mstr where code_domain = global_domain and code_fldname = "xx-system" no-lock no-error.
if not available code_mstr then do:
  create code_mstr. code_domain = global_domain.
  assign code_fldname  = "xx-system"
         code_value = "system"
         code_cmmt  = "xx-system"
         code_user1 = ""
         code_user2 = ""
         code_desc = "名称|KEY|未使用|未使用|标签"
         .
  RELEASE code_mstr.
end.


repeat:


    view frame a.
    VIEW FRAME f-main.
    CLEAR FRAME f-main ALL NO-PAUSE.

    prompt-for v_code with frame a editing:
        /* FIND NEXT/PREVIOUS RECORD */
        {mfnp01.i code_mstr
                  v_code
                  code_value
                  code_fldname
                  'xx-system'
                  code_fldval}
        if recno <> ? then do:
            display code_value @ v_code
                    /*code_cmmt  @ v_name */
                    with frame a.
        end. /* IF RECNO <> ? */
    end. /* EDITING */
    find first code_mstr
         where code_domain = global_domain and code_fldname = "xx-system"
         and code_value = input frame a v_code
         no-lock no-error.
    if not available code_mstr then do:
        message "ERR:Name invalid.".
        next-prompt v_code with frame a.
        undo, retry.
    end.
    display code_value @ v_code
            /*code_cmmt  @ v_name */
            with frame a.
    v_key = code_cmmt.

    DO i = 1 TO 5:
        ASSIGN v_label[i] = "".
    END.
    DO i = 1 TO NUM-ENTRIES(code_desc,"|"):
        ASSIGN v_label[i] = entry(i,code_desc, "|").
    END.

    ASSIGN
        code_value:LABEL IN FRAME f-main = v_label[1]
        code_cmmt:LABEL IN FRAME f-main = v_label[2]
        code_user1:LABEL IN FRAME f-main = v_label[3]
        code_user2:LABEL IN FRAME f-main = v_label[4]
        code_desc:LABEL IN FRAME f-main = v_label[5]
        .
    ASSIGN
        code_value:LABEL IN FRAME f-pop = v_label[1]
        code_cmmt:LABEL IN FRAME f-pop = v_label[2]
        code_user1:LABEL IN FRAME f-pop = v_label[3]
        code_user2:LABEL IN FRAME f-pop = v_label[4]
        code_desc:LABEL IN FRAME f-pop = v_label[5]
        .

    MainBlock:
    do on error undo,leave on endkey undo,leave:

        { tijscroll.i
          &file = "code_mstr"
          &where = " where (code_domain = global_domain and code_fldname = v_key) "
          &frame = "f-main"
          &fieldlist = "
            code_value
            code_cmmt
            code_user1
            code_user2
            code_desc "
          &prompt     = "code_value"
          &index      = "use-index code_fldval"
          &midchoose  = "color mesages"
        &updkey     = "Enter"
        &updcode    = "~ run xxpro-mt-update. ~"
        &inskey     = "A"
        &inscode    = "~ run xxpro-mt-add. ~"
        &delkey     = "D"
        &delcode    = "~ run xxpro-mt-delete. ~"
        }

    end. /*MAIN BLOCK */
end.

PROCEDURE xxpro-mt-update.
    find code_mstr where recid(code_mstr) = w-rid[Frame-line(f-main)]
    no-lock no-error.

    if not available code_mstr then leave .

    find code_mstr where recid(code_mstr) = w-rid[Frame-line(f-main)] no-error.
    display
        code_value
        code_cmmt
        CODE_user1
        CODE_user2
        CODE_desc
    with frame f-main.
    UPDATE
        code_cmmt
        CODE_user1
        CODE_user2
        CODE_desc
        with frame f-main.
END PROCEDURE.

PROCEDURE xxpro-mt-add.
    pop-tit = ' Input New Data '.

    clear frame f-pop ALL no-pause.

    REPEAT WITH FRAME f-pop:
       prompt-for
           code_value
           code_cmmt
           CODE_user1
           CODE_user2
           CODE_desc
       WITH FRAME f-pop.

       find first code_mstr where code_domain = global_domain and code_fldname = v_key
           and code_value = input frame f-pop code_value
       no-lock no-error.

       if available code_mstr then do:
            message "ERR:data already Exists.".
            UNDO,RETRY.
       end.
       create code_mstr. code_domain = global_domain.
       assign
           code_fldname  = v_key
           code_value = input frame f-pop code_value
           code_cmmt  = input frame f-pop code_cmmt
           code_user1 = input frame f-pop code_user1
           code_user2 = input frame f-pop code_user2
           code_desc = input frame f-pop code_desc
           .
       w-newrecid = recid(code_mstr).
       DOWN 1 WITH FRAME f-pop.
   END.
   hide frame f-pop no-pause.
END PROCEDURE.

PROCEDURE xxpro-mt-delete.
    find code_mstr where recid(code_mstr) = w-rid[Frame-line(f-main)] no-lock no-error.
    if not available code_mstr THEN LEAVE.

    find code_mstr where recid(code_mstr) = w-rid[Frame-line(f-main)] no-error.
    message "Confirm delete the record?" update v_confirm.
    if v_confirm and available code_mstr then  do:
       delete code_mstr.
    end.
END PROCEDURE.

