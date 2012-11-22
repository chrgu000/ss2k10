/* xxundo.p - xxundo.p TestProgram and RollBack                              */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 24YP LAST MODIFIED: 04/24/12 BY: zy expand xrc length to 120    */
/* REVISION END                                                              */

{mfdtitle.i "27YC"}

define variable program as character format "x(40)"
                        label "Execute Program".
define variable prg as character.
define variable i as integer.
/* define variable offset  as integer. */

form
   space(1)
   program
with frame a width 80 attr-space side-labels no-underline.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

find first usrw_wkfl no-lock where {xxusrwdom.i} {xxand.i}
           usrw_key1 = execname + "-PROGRAM_NAME" no-error.
if available usrw_wkfl then do:
   assign program = usrw_key2.
end.
display program with frame a.
/*V8-*/

repeat:

   update program with frame a.

   DO i = 1 to length(program).
      If index("0987654321.", substring(program,i,1)) = 0 then do:
         assign i = -1.
         leave.
      end.
   end.

   if i > 0 then do:
      find first mnd_det no-lock where
                 mnd_nbr = substring(program,1,r-index(program,".") - 1) and
                 mnd_select = int(substring(program,r-index(program,".") + 1))
           no-error.
      if available mnd_det then do:
         assign prg = mnd_exec.
      end.
   end.
   else do:
        if index(program,".") = 0 then do:
            assign prg = global_user_lang_dir + substring(program,1,2) + '/' +
                         program + ".r".
        end.
        else if substring(program,r-index(program,".")) = ".p" then do:
            assign prg = global_user_lang_dir + substring(program,1,2) + '/' +
                         substring(program,1,r-index(program,".") - 1) + ".r".
        end.
        else if substring(program,r-index(program,".")) = ".r" then do:
            assign prg = global_user_lang_dir + substring(program,1,2) + '/' +
                        program.
        end.
   end.
   if search(prg) = ? then do:
      /* Program # not currently installed */
      {pxmsg.i &MSGNUM=5012 &ERRORLEVEL=3 &MSGARG1=program}
      undo, retry.
   end.
   find first usrw_wkfl exclusive-lock where {xxusrwdom.i} {xxand.i}
              usrw_key1 = execname + "-PROGRAM_NAME" no-error.
   if not available usrw_wkfl then do:
      create usrw_wkfl. {xxusrwdom.i}.
      assign usrw_key1 = execname + "-PROGRAM_NAME".
   end.
   assign usrw_key2 = program no-error.

   hide frame a.
   undoprog:
   do transaction:
      run value(prg).
      undo undoprog,leave.
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
