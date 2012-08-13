/*******************************************************************
 * author:hou
 *
 * create:2006/03/06
 * description: 为指定的文件增加日志信息
 * paremeters:
 
 * description: 将日志信息记录到数据库中，该事务日志将操作xlog_det.
 * paremeters:
 * {1}		char	cim group id
 * {2}      char  program name
 * {3}      char  信息
 ******************************************************************/

create tt_log.
assign
  tt_obj  =	string({1})
  tt_date = today
  tt_time = string(time,"HH:MM:SS")
  tt_id   = {2}
  tt_desc =	{3}.
