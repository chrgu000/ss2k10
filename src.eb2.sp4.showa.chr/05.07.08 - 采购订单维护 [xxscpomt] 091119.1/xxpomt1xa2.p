/* SS - 090907.1 By: Neil Gao */

{mfdeclre.i}
{gplabel.i}

/*
�����޸�SCMͬ������
usrw_key1 : ����(scmftphist)
usrw_key2 : �����ļ���
usrw_charfld[1]: �ύ�û�
usrw_datefld[1]: ��������  usrw_decfld[1]: ����ʱ��
usrw_datefld[2]: �޸�����  usrw_decfld[2]: �޸�ʱ��
usrw_datefld[3]: ��������  usrw_decfld[3]: ����ʱ��
usrw_datefld[4]: �������  usrw_decfld[4]: ���ʱ��
*/

define input parameter iptf1 as char.
define input parameter iptf2 as char.

find first usrw_wkfl where usrw_key1 = "scmftphist" and usrw_key2 = iptf1 no-error.
if not avail usrw_wkfl then do:
	create 	usrw_wkfl.
	assign 	usrw_key1 = "scmftphist"
					usrw_key2 = iptf1
					usrw_key3 = iptf2
					usrw_charfld[1] = global_userid
					usrw_datefld[1] = today
					usrw_decfld[1]  = time
					. 
end.
	
	usrw_datefld[2] = today.
	usrw_decfld[2]  = time.
