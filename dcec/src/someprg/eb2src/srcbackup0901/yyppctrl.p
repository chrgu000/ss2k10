/*Ctrl program  xxppctrl.p*/


/*usrw_wkfl*/
/*
usrw_key1 = "DCEC"
usrw_key2 = "ADVdate"
usrw_key3 = String(1).
*/
define variable mainkey like usrw_key2 label "Key".
define variable mainvalue like usrw_key3 label "Value".

form 
    mainkey    colon  20
    mainvalue  colon  20
with frame a width 80 side-label.
    
{mfdtitle.i "AO+"}
 
repeat:
   mainkey = "".
   mainvalue = "".
   update mainkey validate(mainkey <> "","key Type") with frame a editing:
        {mfnp10.i usrw_wkfl mainkey usrw_key2 mainkey usrw_key2 "and usrw_key1 = 'DCEC'"} 
        if recno <> ? then do:
            assign mainkey   = usrw_key2
                   mainvalue = usrw_key3.
            display mainkey mainvalue with frame a.
        end. 
   end.
   
   find first usrw_wkfl no-lock where  usrw_key1 = 'DCEC' and usrw_key2 = mainkey no-error.
   if available usrw_wkfl then do:
      assign mainkey   = usrw_key2
             mainvalue = usrw_key3.
      display mainkey mainvalue with frame a.
   end.
   else do:
      mainvalue = "".
      display mainvalue with frame a.
   end.
   loop1: do on error undo, retry  with frame a:
       update mainvalue  go-on("F5" "CTRL-D" ).
       find first usrw_wkfl where usrw_key2 = mainkey
                              and usrw_key1 = 'DCEC'
                              no-error. 
       if available usrw_wkfl then do:
          if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")  then do:
             message "delete record".
             delete usrw_wkfl.
             leave.
          end.
          else do:
             message "Modified record".
             assign usrw_key3 = mainvalue.
          end.
       end.
       else do:
               message "Create New Record".
               create usrw_wkfl.
               assign usrw_key1 = 'DCEC'
                      usrw_key2 = mainkey
                      usrw_key3 = mainvalue.
       end.
       
   end. /*loop1: repeat on endkey undo loop1, leave loop1: */
   
   
   
end.

