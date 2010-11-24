/*检查是否已下线
	checknumber = 1=上线
	checknumber = 2=下线
	checknumber = 3=检测
	checknumber = 4=包装
	checknumber = 5=入库
	checknumber = 6=装箱	loc 此时要为 装箱单号
	checknumber = 7=出库
	*/

checknumber = "1" .
{gprun.i ""xxddcheckvinhist.p""
"(input vin,
  input xxsovd_wolot ,
  input checknumber ,
  output cimError)"}


/*自动更新历史记录xxvind_det和汇总记录xxvin_mstr*/
/*检查是否已下线
	checknumber = 1=上线
	checknumber = 2=下线
	checknumber = 3=检测
	checknumber = 4=包装
	checknumber = 5=入库
	checknumber = 6=装箱	loc 此时要为 装箱单号
	checknumber = 7=出库
*/
checknumber = "1" .
{gprun.i ""xxddupdatevinhist.p""
 "(input vin,
   input motorvin ,    发动机号 只有checknumber = 1才有用，其它没用
   input xxsovd_wolot ,
   input loc,
   input checknumber ,
   output cimError)"}


/*新增xxvind_det and xxvin_mstr */
{gprun.i ""xxddcreatevinhist.p""
 "(input vin)"}

/*COPYCreate xxvind_det and xxvin_mstr */
/*动力VIN替换成机组工单ID时COPY原动力的VIN产生信息*/
{gprun.i ""xxddcopyvinhist.p""
 "(input vin,
   input wolot)"}

/*得到当前登入的条码用户名*/
{gprun.i ""xxddgetbarcodeuser.p"" 
"(output barcode_userid)"}

/*上线发料半成品如机组动力*/
{gprun.i ""xxddautowois.p""
"(input vin,
  input wolot,
  output cimError)"}

/*下线入库成品如机组，单机动力*/
{gprun.i ""xxddautoworc.p""
"(input vin,
  input site,
  input loc,
  output cimError)"}

/*
1.查询工单ID的出入库及下线包装数量

  input wolot    工单ID
  output qty_pack 包装量
  output qty_line 下线量
  output qty_ruku 入库量
  output qty_cuku 出库量
  */
 {gprun.i ""xxddgetxxsovdqty.p"" 
"(input wo_lot,
	output qty_pack,
	output qty_line,
	output qty_ruku,
	output qty_cuku)"
	}

/*字符自动截取*/
/*
input tmp_char ,	输入字符变量
input 108,		每行多少个字节
output tmp_char ,	输出字符变量 用^分隔
output k		总共有多少行
*/
 {gprun.i ""xxddgetstring.p"" 
"( input tmp_char ,
   input 108 ,
   output tmp_char ,
   output k 
)"}


/*得到VIN码所有流通信息在xxsovinck2.p里有用过*/
 {gprun.i ""xxddiqvindet.p"" 
  "(input xxsovd_id)"
	}	/*得到VIN码信息*/



/*取消xxvind_det xxvin_mstr 等表 下线，包装，入库，或者出库状态*/
/*
导入日期
工单ID
类别
*/
{gprun.i ""xxddcancelvinhist.p""
 "(input xxvinimport_date ,	
   input xxvinimport_wolot ,
   input vin ,
   input checknumber
   )"}

/*取消ISS-SO 转仓 入库等事务 */
/*
日期
工单ID
类别
*/
{gprun.i ""xxddcancelbarcode.p""
 "(input xxvinimport_date ,	
   input xxvinimport_wolot ,
   input checknumber
   )"}