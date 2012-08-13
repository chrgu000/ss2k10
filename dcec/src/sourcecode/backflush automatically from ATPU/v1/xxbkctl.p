/* xxbkctl.p  - BackFluch Interface Control File                           */
/* COPYRIGHT  AtosOrigin ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK         */
/* CREATE :          Date:2002.08.15     BY:SunnyZhou*Atos Origin SHA*   */


define buffer   bbusrwwkfl   for usrw_wkfl.
define variable emp_name like emp_fname format "x(20)" label " 姓名".
define variable yn like mfc_logic initial no .
define variable usrid like usr_userid format "x(8)".

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/* DISPLAY TITLE */
{mfdtitle.i "xx "}

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
    usrid            colon 15  label "操作用户"    format "x(8)"  emp_name skip
    usrw_charfld[1]  colon 15  label "密码"        format "x(16)"     skip
    usrw_charfld[10] colon 15  label "工作路径\文件"   format "x(60)" skip
    usrw_charfld[11] colon 15  label "输入路径\文件"   format "x(60)" skip
    usrw_charfld[12] colon 15  label "LOG 路径\文件"   format "x(60)" skip(1)
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN "回冲事务控制设置 "
  &ELSE {&SELECTION_CRITERIA}
  &ENDIF .
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/* DISPLAY SELECTION FORM */
FOR first usrw_wkfl where usrw_key1 = "BKFLH-CTRL" exclusive-lock: END.
IF available usrw_wkfl THEN
DO:
	usrid = usrw_key2.
        display
	usrid
	usrw_charfld[1]
	usrw_charfld[10]
        usrw_charfld[11]
        usrw_charfld[12]
        with frame a.
	
END.
mainloop:
repeat :
  
    prompt-for  usrid with frame a editing:
             {mfnp05.i  usr_mstr usr_userid yes usr_userid "input usrid"}

               if recno <> ? then do:
                  display
                  usr_userid @ usrid
                  usr_name @ emp_name with frame a .
               end.
    end.

           find usr_mstr where usr_userid = input usrid no-lock no-error.
            if not available usr_mstr then do:
               {mfmsg.i 5546 3}
               undo mainloop, retry.
            end.

           display
                  usr_userid @ usrid
                  usr_name @ emp_name with frame a .
 
    
    find first usrw_wkfl where usrw_key1 = "BKFLH-CTRL" exclusive-lock no-error.
      if not available usrw_wkfl then do:
        {mfmsg.i 1 1}
        create usrw_wkfl.
        assign 
            usrw_key1 = "BKFLH-CTRL"
            usrw_key2 = input usrid.
    	    usrw_charfld[10] = "D:\batch\bkflh\dat\xxbkflh.txt" .
            usrw_charfld[11] = "D:\batch\bkflh\dat\xxbkflh.cim" .
            usrw_charfld[12] = "D:\batch\bkflh\dat\xxbkflh.log" .

      end.
      else do:
	ASSIGN
		usrw_key2 = input usrid.
       end.

    subloopa:
    do on error undo, retry:
        display
	usrw_charfld[1]
	usrw_charfld[10]
        usrw_charfld[11]
        usrw_charfld[12]
        with frame a.
        
        update
        usrw_charfld[1]  validate(can-find(usr_mstr 
				  where usr_userid = usrw_key2 
				  and encode(usrw_charfld[1]) = usr_passwd), "Password not matched!")
	usrw_charfld[10] validate(usrw_charfld[10] <> "", "Blank not allowed!")
        usrw_charfld[11] validate(usrw_charfld[11] <> "", "Blank not allowed!")
        usrw_charfld[12] validate(usrw_charfld[12] <> "", "Blank not allowed!")
        go-on(F5 ctrl-d) with frame a.

     
        /* DELETE */
        if (lastkey = keycode("F5") or lastkey = keycode("CTRL-D")) then do:
            yn = yes.
            {mfmsg01.i 11 1 yn}
            if yn = no then undo .
  
            delete usrw_wkfl.
            clear frame a.
            yn = no.
            hide message no-pause.
            next mainloop.
        end. /* delete*/
      end. /*do on error*/
    end.   /* for repeat */
status input.
