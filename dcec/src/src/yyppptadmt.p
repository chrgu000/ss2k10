{mfdtitle.i "2+ "}
{yyedcomlib.i}
IF f-howareyou("HAHA") = NO THEN LEAVE.

define shared variable global_recid as recid.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/

    pt_part  COLON 20
    pt_desc1 COLON 20 
    pt_desc2 NO-LABEL
    SKIP(1)
    pt__chr01 colon 20  LABEL "规格" FORMAT "x(50)"
    pt__chr02 colon 20  LABEL "FOB"  FORMAT "x(18)"
    pt__chr03 colon 20  LABEL "产地"
    pt__chr04 colon 20  LABEL "运输方式"
    pt__chr05 colon 20  LABEL "报关HS码"
    pt__dec01 colon 20  LABEL "报关税率"
    pt__dte01 colon 20
    pt__log01 colon 20 
    pt__chr06 COLON 20
    pt__chr07 COLON 20
    pt__chr08 COLON 20

    skip
    SKIP(.4)  /*GUI*/
    WITH FRAME a SIDE-LABELS WIDTH 80 NO-BOX THREE-D.

DEFINE VARIABLE F-a-title AS CHARACTER.
F-a-title = "自定义信息".
RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
                 FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
                 RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", 
                 RECT-FRAME-LABEL:FONT).
RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).




mainloop:
REPEAT WITH FRAME a:


      prompt-for 
          pt_part
      editing:

         if frame-field = "pt_part" then do:

            {mfnp05.i pt_mstr pt_part
               "yes = yes"
               pt_part
               "input pt_part"}

            if recno <> ? then do:

               display
                   pt_part
                   pt_desc1
                   pt_desc2
                   pt__chr01 
                   pt__chr02 
                   pt__chr03 
                   pt__chr04 
                   pt__chr05 
                   pt__dec01 
                   pt__dte01 
                   pt__log01 
                   pt__chr06
                   pt__chr07
                   pt__chr08

                   .
            end.
         end. /* if frame-field = abs_shipfrom */
         else do:
            status input.
            readkey.
            apply lastkey.
         end.
      end.

      FIND FIRST pt_mstr WHERE pt_part = INPUT pt_part NO-ERROR.
      IF AVAILABLE pt_mstr THEN DO:
          display
              pt_part
              pt_desc1
              pt_desc2
              pt__chr01 
              pt__chr02 
              pt__chr03 
              pt__chr04 
              pt__chr05 
              pt__dec01 
              pt__dte01 
              pt__log01 
              pt__chr06
              pt__chr07
              pt__chr08
              .
        UPDATE 
              pt__chr01 
              pt__chr02 
              pt__chr03 
              pt__chr04 
              pt__chr05 
              pt__dec01 
              pt__dte01 
              pt__log01 
            pt__chr06
            pt__chr07
            pt__chr08

              .
        RELEASE pt_mstr.
    END.
    ELSE DO:
        MESSAGE "Error: item not existed.".
        UNDO, RETRY.
    END.
END.
