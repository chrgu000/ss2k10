/*******************************************************************
 * author:hou
 *
 * create:2006/03/06
 * description: Ϊָ�����ļ�������־��Ϣ
 * paremeters:
 
 * description: ����־��Ϣ��¼�����ݿ��У���������־������xlog_det.
 * paremeters:
 * {1}		char	cim group id
 * {2}      char  program name
 * {3}      char  ��Ϣ
 ******************************************************************/

create tt_log.
assign
  tt_obj  =	string({1})
  tt_date = today
  tt_time = string(time,"HH:MM:SS")
  tt_id   = {2}
  tt_desc =	{3}.
