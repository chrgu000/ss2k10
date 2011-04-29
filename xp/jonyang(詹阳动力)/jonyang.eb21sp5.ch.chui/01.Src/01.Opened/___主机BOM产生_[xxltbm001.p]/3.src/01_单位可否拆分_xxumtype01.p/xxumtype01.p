/*xxumtype01.p 主机BOM产生 配套程式: 单位是否可拆分成小数*/
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100907.1  By: Roger Xiao */

/*-Revision end---------------------------------------------------------------*/
{mfdtitle.i "100907.1"}


define variable fieldname like code_fldname no-undo.
define variable v_user1   as logical format "Yes/No".

form
   
   code_value     colon 25 label "单位"
   skip(1)
   v_user1        colon 25 label "可否拆分小数"
with frame a side-labels width 80 attr-space.

view frame a.

mainloop:
repeat with frame a:

    fieldname = "PT_UM" .

    prompt-for  code_value editing:

        {mfnp05.i code_mstr code_fldval
            " code_mstr.code_domain = global_domain and code_fldname  = fieldname " code_value
            "input code_value"}

        if recno <> ? then
            display code_value 
                    code_user1 @ v_user1.

    end. /* editing: */

   find code_mstr  
        where code_mstr.code_domain = global_domain 
        and  code_fldname = fieldname
        and  code_value   = input code_value
   no-error.

   if not available code_mstr then do:
       message "错误:此计量单位不存在,请先在通用代码维护" .
       undo,retry .
   end. /* if not available code_mstr then do: */

   ststatus = stline[2].
   status input ststatus.

   do on error undo,retry :
       v_user1 =  if code_user1 = "Y" then yes else no.
       update v_user1.
       assign code_user1 = if v_user1 = yes then "Y" else "". 
   end.


end. /* mainloop */

status input.
