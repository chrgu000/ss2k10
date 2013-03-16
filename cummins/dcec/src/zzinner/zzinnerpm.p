/* GUI CONVERTED from xxvoimppm.p (converter v1.78) Thu Nov  8 15:26:41 2012 */
/*V8:ConvertMode=Maintenance                                                 */
/*-Revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "121111.1"}
define variable v_key like usrw_key1 no-undo initial "ZZINNER.P-CTRL".
define variable del-yn like mfc_logical initial no.
define variable i as integer.

/* Variable added to perform delete during CIM.
* Record is deleted only when the value of this variable
* Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.

{gpfieldv.i}      /* var defs for gpfield.i */

/* DISPLAY SELECTION FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/

 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
   usrw_key2 colon 25 format "x(28)" skip(1)
   usrw_key3 colon 25 format "x(120)" view-as fill-in size 40 by 1
   usrw_key4 colon 25 format "x(120)" view-as fill-in size 40 by 1
   usrw_key5 colon 25 format "x(120)" view-as fill-in size 40 by 1
   usrw_key6 colon 25 format "x(120)" view-as fill-in size 40 by 1 skip(1)

 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.


   /* Initialize delete flag before each display of frame */
   batchdelete = "".
   display v_key @ usrw_key2.

   do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


      /* Prompt for the delete variable in the key frame at the
       * End of the key field/s only when batchrun is set to yes */
      prompt-for
         usrw_key2
         batchdelete no-label when (batchrun)
      editing:

         {mfnp05.i usrw_wkfl
             usrw_index1
            " usrw_domain = global_domain and usrw_key1  = v_key "
             usrw_key2
            " input usrw_key2 "}
         if recno <> ? then do:
            display usrw_key2 usrw_key3 usrw_key4 usrw_key5 usrw_key6.
         end.
      end. /* editing: */

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* do on error undo, retry: */
   if input usrw_key2 <> v_key then do:
      undo,retry.
   end.
   /* ADD/MOD/DELETE  */

   find first usrw_wkfl exclusive-lock where usrw_domain = global_domain and
              usrw_key1 = v_key and
              usrw_key2 = input usrw_key2 no-error.

   if not available usrw_wkfl then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create usrw_wkfl. usrw_domain = global_domain.
      assign usrw_key1 = v_key usrw_key2.
   end. /* if not available usrw_wkfl then do: */

   ststatus = stline[2].
   status input ststatus.

  repeat with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.
         update usrw_key3 usrw_key4 usrw_key5 usrw_key6 go-on(F5 CTRL-D).

           if usrw_key3 = "" then do:
              {mfmsg.i 40 3}
              next-prompt usrw_key3.
              undo,retry.
           end.
           if usrw_key4 = "" then do:
              {mfmsg.i 40 3}
              next-prompt usrw_key4.
               undo,retry.
           end.
           if usrw_key5 = "" then do:
              {mfmsg.i 40 3}
              next-prompt usrw_key5.
              undo,retry.
           end.
           if usrw_key6 = "" then do:
              {mfmsg.i 40 3}
              next-prompt usrw_key6.
              undo,retry.
           end.
        leave.
  end.
/*GUI*/ if global-beam-me-up then undo, leave.

      FILE-INFO:FILE-NAME = usrw_key5.
      if substring(FILE-INFO:FILE-TYPE,1,1) <> "D" then do:
          dos silent value("mkdir " + usrw_key5).
      end.

   /* Delete to be executed if batchdelete is set or
    * F5 or CTRL-D pressed */
   if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
      or input batchdelete = "x"
   then do:

      del-yn = yes.

      /* Please confirm delete */
      {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}

      if del-yn then do:
         delete usrw_wkfl.
         clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
      end. /* if del-yn then do: */

   end. /* then do: */

end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* prompt-for usrw_key1 */

status input.
