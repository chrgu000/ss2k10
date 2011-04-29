/*xxmsgcrt01.p 客制化程式时,如无对应msg,随时新增,方便调用*/
/*此为公用子程式,不可随意修改*/  
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100524.1  By: Roger Xiao */

{mfdeclre.i}
{gplabel.i}
{pxmaint.i}



define input parameter v_lang like msg_lang no-undo.
define input parameter v_nbr  like msg_nbr  no-undo.
define input parameter v_desc like msg_desc no-undo.



find first msg_mstr where msg_lang = v_lang and msg_nbr = v_nbr no-lock no-error .
if not avail msg_mstr then do:
    create msg_mstr .
    assign msg_lang = v_lang
           msg_nbr  = v_nbr
           msg_desc = v_desc
           .
end.
release msg_mstr .



                                   
/*                                   
{gprun.i ""xxmsgcrt01.p""
        "(input ""CH"" ,
          input 90001 ,
          input ""采购成本与系统GL成本相差比例超出10%""
          )"}
*/