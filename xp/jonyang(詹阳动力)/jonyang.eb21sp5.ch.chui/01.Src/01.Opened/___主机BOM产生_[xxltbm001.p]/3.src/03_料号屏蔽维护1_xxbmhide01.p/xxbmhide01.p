/*xxbmhide01.p 主机BOM配套程式: 屏蔽料号*/
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100907.1  By: Roger Xiao */

/*-Revision end---------------------------------------------------------------*/
{mfdtitle.i "100907.1"}

define var v_yn as logical format "Yes/No".

form
   
   pt_part        colon 25    label "零件编号"
   pt_desc1       at 47       no-label
   pt_um          colon 25    label "单位"
   pt_desc2       at 47       no-label
                  skip(1)
   v_yn           colon 25    label "主机BOM不显示"
                  skip(1)

with frame a side-labels width 80 attr-space.

view frame a.

mainloop:
repeat with frame a:


    prompt-for  pt_part editing:

        {mfnp05.i pt_mstr pt_part "pt_domain = global_domain " pt_part "input pt_part"}

        if recno <> ? then
            display pt_part pt_um pt_desc1 pt_desc2
                    pt__chr01 @ v_yn .

    end. /* editing: */

   find pt_mstr  
        where pt_mstr.pt_domain = global_domain 
        and pt_part = input pt_part
   no-error.

   if not available pt_mstr then do:
       message "错误:零件编号不存在,请重新输入" .
       undo,retry .
   end. /* if not available code_mstr then do: */

   ststatus = stline[2].
   status input ststatus.

   do on error undo,retry :
       v_yn =  if pt__chr01 = "Y" then yes else no.
       update v_yn.
       assign pt__chr01 = if v_yn = yes then "Y" else "". 
   end.


end. /* mainloop */

status input.
