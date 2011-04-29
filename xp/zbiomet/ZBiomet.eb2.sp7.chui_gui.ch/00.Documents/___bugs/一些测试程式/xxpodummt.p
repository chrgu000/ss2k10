/* xxpodummt.p - Purchase Order UNIT OF MEASURE MAINTENANCE          */ 
/* REVISION: 1.0      LAST MODIFIED: 09/13/06   BY: Judy */

 
/* DISPLAY TITLE */
{mfdtitle.i "b+ "}

define variable del-yn like mfc_logical initial no.
define variable prev_um_conv like um_conv no-undo.

/* Variable added to perform delete during CIM.
 * Record is deleted only when the value of this variable
 * Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.
DEF VAR nbr LIKE pod_nbr.
DEF VAR LINE1 LIKE pod_line.
DEF VAR part LIKE pod_part.
DEF VAR podum LIKE pod_um.
DEF VAR dw  LIKE pod_um.

/* DISPLAY SELECTION FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
/* RECT-FRAME       AT ROW 1 COLUMN 1
  RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 */
 SKIP   /*GUI*/
   Pod_nbr          colon 25
   pod_line      colon 25
   validate(true,"")

   pod_part        colon 25 pt_desc1 at 50 no-label
   podum  COLON 25  LABEL "采购单位"
   dw    COLON 25     LABEL "库存单位"
   skip(1) 
   pod_um_conv        colon 25
 SKIp  /*GUI*/
with frame a side-labels width 80  /*GUI*/.

 /*DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
 */
/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */

view frame a.
repeat with frame a:
   /* nbr = "".
    LINE1 = 0.
    part = "".
*/
    CLEAR FRAME a NO-PAUSE.
/*GUI*/ if global-beam-me-up then undo, leave.


   /* Initialize delete flag before each display of frame */
   batchdelete = "".

   prompt-for pod_det.pod_nbr pod_line pod_part 
   editing:

      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp.i  pod_det pod_nbr pod_nbr pod_line pod_line pod_nbrln}

      if recno <> ? then do:
         clear frame a.
/*GUI RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.*/
         find pt_mstr no-lock where pt_part = pod_part no-error.
         display pod_nbr pod_line pod_part pod_um_conv
                   pod_um @ podum
            pt_desc1 when (available pt_mstr)
             pt_um when (available pt_mstr) @ dw .
      end.

   end.
   ASSIGN nbr = INPUT pod_nbr
              LINE1 = INPUT pod_line
              part = INPUT pod_part .
   FIND FIRST po_mstr  WHERE po_nbr = nbr
           NO-LOCK NO-ERROR.
   IF NOT AVAIL po_mstr THEN DO:
       MESSAGE "采购单" nbr "不存在，重新输入！".
       UNDO, RETRY.
   END.
   ELSE DO:
       IF po_stat <> "" THEN DO:
           MESSAGE "采购单" nbr "已结或取消，重新输入！".
           UNDO , RETRY.

       END.
   END.
   IF LINE1 <> 0 THEN DO:
       FIND FIRST pod_det WHERE pod_nbr = nbr AND pod_line = LINE1 NO-LOCK NO-ERROR.
       IF AVAIL pod_det  AND part = "" THEN  part = pod_part.
       DISP part  @ pod_part pod_um  WHEN AVAIL pod_det @ podum WITH FRAME a.

   END.
   IF part <> ""  THEN DO:
       FIND FIRST pod_det WHERE pod_nbr = nbr AND pod_part = part NO-LOCK NO-ERROR.
       IF AVAIL pod_det  AND LINE1= 0 THEN  LINE1 = pod_line.
       DISP LINE1 @ pod_line 
              pod_um  WHEN AVAIL pod_det @ podum WITH FRAME a.
   END.

   DISPLAY  part @ pod_part LINE1 @ pod_line nbr @ pod_nbr WITH FRAME a.
   FIND  pt_mstr no-lock where pt_part = part no-error.
   DISP pt_desc1 when (available pt_mstr) 
          pt_um WHEN AVAIL pt_mstr @ dw WITH FRAME a.

   find FIRST pod_det WHERE pod_nbr = nbr AND pod_line = LINE1 AND pod_part = part  no-error.
   recno = recid(pod_det). 
 
   if available pod_det THEN DO:
       /*MESSAGE nbr pod_nbr  LINE1 pod_LINE pod_part pod_um_conv. */
       prev_um_conv = pod_UM_conv.
   END.
   ELSE DO:
        MESSAGE "采购单项次不存在，重新输入！".
        UNDO, RETRY.
   END.
   DISP PREV_um_conv @ pod_um_conv.
   set pod_um_conv
      conv-loop:
   editing:

      readkey.
/***
      /* DELETE */
      if lastkey = keycode("F5")
         or lastkey = keycode("CTRL-D")
      then do:
         del-yn = yes.
         /* PLEASE CONFIRM DELETE */
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         if del-yn then leave.
      end.

      else***/
      if input pod_um_conv = 0 and
         lookup(keyfunction(lastkey),"GO,RETURN") > 0 then do:
         /* UM CONVERIONS MAY NOT BE 0 */
         {pxmsg.i &MSGNUM=7259 &ERRORLEVEL=3}
         pod_um_conv = prev_um_conv.
         DISPLAY pod_um_conv.
         apply lastkey.
         next-prompt pod_um_conv.
         next conv-loop.
      end.

      else apply lastkey.
   end.
     IF lookup(keyfunction(lastkey),"GO,RETURN") > 0 then do:
         MESSAGE "采购单" nbr  "项次" line1 "零件"part "的单位换算率为:" pod_um_conv . 
     END.
   /***
   if del-yn or
   /* Delete to be executed if batchdelete is set to "x" */
   batchdelete = "x":U
   then do:
      delete um_mstr.
      clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
      del-yn = no.
   end.
   ***/
end.
/*GUI*/ if global-beam-me-up then undo, leave.
   /* END REPEAT */
status input.

