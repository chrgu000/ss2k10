/* xxundo.p - xxundo.p TestProgram and RollBack                              */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 24YP LAST MODIFIED: 04/24/12 BY: zy expand xrc length to 120    */
/* REVISION END                                                              */
{mfdtitle.i "27YC"}

define variable program as character format "x(40)"
                        label "Execute Program" no-undo.
define variable prg as character.
define variable can_do_menu as logical.
define variable i as integer.
/* define variable offset  as integer. */

form
   space(1)
   program
with frame a width 80 attr-space side-labels no-underline.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

find first usrw_wkfl no-lock where {xxusrwdom.i} {xxand.i}
           usrw_key1 = global_userid and
           usrw_key2 = execname + "-PROGRAM_NAME" no-error.
if available usrw_wkfl then do:
   assign program = usrw_key3.
end.
display program with frame a.
/*V8-*/

repeat:

   update program with frame a.
   assign prg = program.
   DO i = 1 to length(program).
      If index("0987654321.", substring(program,i,1)) = 0 then do:
         assign i = -1.
         leave.
      end.
   end.
   if i > 0 then do:
      if substring(program,1,1) = "." then do:
         assign prg = substring(program,2,r-index(program,".") - 2).
      end.
      else do:
         assign prg = substring(program,1,r-index(program,".") - 1).
      end.
      find first mnd_det no-lock where
                 mnd_nbr = prg and
                 mnd_select = int(substring(program,r-index(program,".") + 1))
           no-error.
      if available mnd_det then do:
         assign prg = mnd_exec.
      end.
      else do:
          {pxmsg.i &MSGNUM=13 &ERRORLEVEL=3}
           undo, retry .
      end.
   end.
   else do:
     if index(prg,".") = 0 then do:
         find first mnd_det no-lock where mnd_exec = prg + ".p" no-error.
     end.
     else if substring(prg,r-index(prg,".")) = ".p" then do:
         find first mnd_det no-lock where mnd_exec = prg no-error.
     end.
     else if substring(prg,r-index(prg,".")) = ".r" then do:
         find first mnd_det no-lock where
              mnd_exec = substring(prg,1,r-index(prg,".") - 1) + ".p" no-error.
     end.
   end.
   if available mnd_det then do:
       {gprun1.i ""mfsec.p"" "(input mnd_det.mnd_nbr,
           input mnd_det.mnd_select,
           input true,
           output can_do_menu)"}

        if can_do_menu = false
           then undo, retry .
   end.
   find first usrw_wkfl exclusive-lock where {xxusrwdom.i} {xxand.i}
              usrw_key1 = global_userid and
              usrw_key2 = execname + "-PROGRAM_NAME" no-error.
   if not available usrw_wkfl then do:
      create usrw_wkfl. {xxusrwdom.i}.
      assign usrw_key1 = global_userid
             usrw_key2 = execname + "-PROGRAM_NAME".
   end.
   assign usrw_key3 = program no-error.

   hide frame a.
   undoprog:
   do transaction on stop undo undoprog,leave undoprog:
      {gprun.i prg}
      undo undoprog,leave undoprog.
   end.
   hide all no-pause.
   view frame dtitle.
end.
/*V8+*/
/*V8!
do:
/*Program not available in MFG/PRO V8*/
{pxmsg.i &MSGNUM=7735 &ERRORLEVEL=1 &MSGARG1=program-name(1)}
pause.
end.
*/
