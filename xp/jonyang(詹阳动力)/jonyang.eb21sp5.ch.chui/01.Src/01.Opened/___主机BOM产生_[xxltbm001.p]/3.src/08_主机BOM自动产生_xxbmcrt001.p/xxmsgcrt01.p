/*xxmsgcrt01.p ���ƻ���ʽʱ,���޶�Ӧmsg,��ʱ����,�������*/
/*��Ϊ�����ӳ�ʽ,���������޸�*/  
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
          input ""�ɹ��ɱ���ϵͳGL�ɱ�����������10%""
          )"}
*/