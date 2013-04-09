

def var file_dir   as char format "x(50)".
def var v_cimfile  as char format "x(50)".
def var v_output   as char format "x(50)".
def var v_debug    as logical.
def var v_haserror as log init no.
def var v_msg as char format "x(70)" init "".
def var global_user_lang_dir as char.
def var file_name as char format "x(50)".

global_user_lang_dir = "us/".

form
   file_dir  label "File Directory"
   skip(1)
   file_name label "File Name" 
   skip(1)
   v_debug label "Keep Cimoutfile"
   skip(2)
   v_cimfile label "Input File" 
   skip(1)
   v_output label "Output File" 
   with frame a width 80 side-label title "**Manual CIMLOAD**".

repeat:

file_dir = "/home/mfg/cimload/".

v_cimfile = file_dir.
v_output = file_dir.

disp file_name v_cimfile v_output with frame a .

update file_dir file_name with frame a .

v_cimfile = file_dir + file_name.

v_output = file_dir + file_name.

v_output = substr(v_output,1,length(v_output) - 3) + "log".

update v_debug v_cimfile v_output with frame a .

{gprun.i ""xxcimrun.p"" "(input v_cimfile, 
                        input v_output,
                        input v_debug,
			                  output v_haserror, 
			                  output v_msg)"}

if v_haserror then disp v_msg with frame b.
pause.

clear frame b.
hide frame b.
unix silent rm -f value(v_output) .
end.