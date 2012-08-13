/*******************************************************************
 * author:jane wang
 *
 * create:2005/08/16
 * description: 为指定的文件增加日志信息
 * paremeters:
 
 * description: 将日志信息记录到数据库中，该事务日志将操作xlog_det.
 * paremeters:
 * {1}		char	生产线
 * {2}    char  零件号
 * {3}    char  批号
 * {4}		char	类型(INFO/DEBUG/WARNING/ERROR)
 * {5}		char	信息
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
