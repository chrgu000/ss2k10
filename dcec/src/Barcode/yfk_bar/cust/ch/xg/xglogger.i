/*******************************************************************
 * author:jane wang
 *
 * create:2005/08/16
 * description: Ϊָ�����ļ�������־��Ϣ
 * paremeters:
 
 * description: ����־��Ϣ��¼�����ݿ��У���������־������xlog_det.
 * paremeters:
 * {1}		char	������
 * {2}    char  �����
 * {3}    char  ����
 * {4}		char	����(INFO/DEBUG/WARNING/ERROR)
 * {5}		char	��Ϣ
 ******************************************************************/
create xlog_det.
assign
  xlog_lnr       =	{1}
  xlog_date	 =	today
  xlog_time	 =	string(time,"HH:MM:SS")
  xlog_part	 =	{2}
  xlog_lot	 =	{3} 
  xlog_obj       =      {4}
  xlog_class     =      {5}	
  xlog_desc	 =	{6}.
