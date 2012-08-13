/**
 @File: zylib.p
 @Description: 智园公共库文件
 @Version: 1.0
 @Author: Zhi Yuan
 @Created: 2005-5-16
 @Functions: 
     CKSiteSecurity
     CKGLEffDate
     IsWCLocation
     GetWCLocation
     GetItemBOMCode
     GetItemRoutingCode
     GetFirstShiftStart
     GetDailyBOMCode
     GetDailyRoutingCode
     
 @Procedures:
     CKProgramSecurity
     
 @Todo: 
 @History: 
**/
{mfdeclre.i}
{gpglefdf.i}

function CKSiteSecurity returns logical
(input site as character):
   /**
    @Description: 判断用户是否有权限使用这个地点
    @Parameters: 
       @Param: site
           @Direction: Input
           @Type: Character
           @ParamDesc: 地点代码
    @Shared: 
    @Returns: 
       @Type: Logical
       @ReturnsDesc: Yes, 表示用户有权使用这个地点
    @Exception:    
    @BusinessLogic: 
    @Todo: 
    @History: 
   **/

  {gprun.i ""gpsiver.p"" "(input site, input ?, output return_int)"}

   if  return_int = 0 then 
      return FALSE .
   else
      return TRUE .

end function .

function CKGLEffDate returns logical
(input transtype as character,
 INPUT entity AS CHARACTER,
 INPUT effdate AS DATE):
   /**
    @Description: 判断某一模块该天的总帐日历是否开放
    @Parameters: 
       @Param: transtype
           @Direction: Input
           @Type: Character
           @ParamDesc: 总帐模块（AP,AR,FA,IC,SO,GL）
       @Param: entity           
           @Direction: Input
           @Type: Character
           @ParamDesc: 会计单位
       @Param: effdate           
           @Direction: Input
           @Type: Date
           @ParamDesc: 校验的有效日期                       
    @Shared: 
    @Returns: 
       @Type: Logical
       @ReturnsDesc: Yes, 表示总帐开放
    @Exception: 关闭的话，程序内有一个提示信息。   
    @BusinessLogic: 
    @Todo: 
    @History: 
   **/

  {gprun.i ""gpglef.p""
    "( input  transtype,
       input  entity,
       input  effdate,
       input  1,
       output gpglef
     )" }  

   if  gpglef > 0 then 
      return FALSE .
   else
      return TRUE .

end function .

function IsWCLocation returns logical
(input location as character):
   /**
    @Description: 判断给定库位是否是线边库位
    @Parameters: 
       @Param: location
           @Direction: Input
           @Type: Character
           @ParamDesc: 库位代码
    @Shared: 
    @Returns: 
       @Type: Logical
       @ReturnsDesc: Yes, 表示库位是一个线边库位
    @Exception:    
       Return ? means no suitable location.
    @BusinessLogic: 
    @Todo: 
    @History: 
   **/

   define buffer wcIsWCLocation for wc_mstr .
   find first wcIsWCLocation no-lock
   where wc_wkctr = location
   no-error .

   if available(wcIsWCLocation) then 
      return true .
   else
      return false .

end function .


function GetWCLocation returns character
(input routingCode as character,
 input operation as integer):
   /**
    @Description: 获取工序的线边库位代码
    @Parameters: 
       @Param: routingCode
           @Direction: Input
           @Type: Character
           @ParamDesc: 工艺流程
       @Param: operation
           @Direction: Input
           @Type: Integer
           @ParamDesc: 工序
    @Shared: 
    @Returns: 
       @Type: Character
       @ReturnsDesc: 指定工序的线边库位代码
    @Exception:    
       Return ? means no suitable location.
    @BusinessLogic: 
    @Todo: 
    @History: 
   **/
   
   define variable wcLoc as character .

   define buffer roGetWCLocation for ro_det .

   find first roGetWCLocation no-lock
   where ro_routing = routingCode
   and ro_op = operation
   no-error .

   if not available(roGetWCLocation) then
      return ? .

   wcLoc = ro_wkctr .

   return wcLoc .

end function .


function GetItemBOMCode returns character
(input site as character,
 input part as character):
   /**
    @Description: 获取零件的产品结构代码
    @Parameters: 
       @Param: site
           @Direction: Input
           @Type: Character
           @ParamDesc: 地点
       @Param: part
           @Direction: Input
           @Type: Character
           @ParamDesc: 零件号
    @Shared: 
    @Returns: 
       @Type: Character
       @ReturnsDesc: 零件在该地点的产品结构代码
    @Exception:         
    @BusinessLogic: 
    @Todo: 
    @History: 
   **/
   
   define variable BOMCode as character .

   find first ptp_det no-lock
   where ptp_site = site
   and ptp_part = part
   no-error .

   if available(ptp_det) then do:
      BOMCode = ptp_bom_code .

      if BOMCode = "" then do:
         find first pt_mstr no-lock
         where pt_part = part
         no-error .

	 BOMCode = pt_bom_code .
      end .
      
   end .
   else do:
      find first pt_mstr no-lock
      where pt_part = part
      no-error .

      if not available(pt_mstr) then
         return "" .
      else
         BOMCode = pt_bom_code .
   end .
   if BOMCode = "" then
      BOMCode = part .
   return BOMCode .
end function .

function GetItemRoutingCode returns character
(input site as character,
 input part as character):
   /**
    @Description: 获取零件的工艺流程代码
    @Parameters: 
       @Param: site
           @Direction: Input
           @Type: Character
           @ParamDesc: 地点
       @Param: part
           @Direction: Input
           @Type: Character
           @ParamDesc: 零件号
    @Shared: 
    @Returns: 
       @Type: Character
       @ReturnsDesc: 零件在该地点的工艺流程代码
    @Exception:         
    @BusinessLogic: 
    @Todo: 
    @History: 
   **/
   
   define variable routingCode as character .

   find first ptp_det no-lock
   where ptp_site = site
   and ptp_part = part
   no-error .

   if available(ptp_det) then do:
      routingCode = ptp_routing .

      if routingCode = "" then do:
         find first pt_mstr no-lock
         where pt_part = part
         no-error .

	 routingCode = pt_routing .
      end .

   end .
   else do:
      find first pt_mstr no-lock
      where pt_part = part
      no-error .

      if not available(pt_mstr) then
         return "" .
      else
         routingCode = pt_routing .
   end .
   if routingCode = "" then
      routingCode = part .
   return routingCode .
end function .

function GetFirstShiftStart returns integer
(input site as character,
 input productionLine as character,
 input produceDate as date):
   /**
    @Description: 获取第一班上班时间
    @Parameters: 
       @Param: site
           @Direction: Input
           @Type: Character
           @ParamDesc: 地点
       @Param: productionLine
           @Direction: Input
           @Type: Character
           @ParamDesc: 生产线
       @Param: produceDate
           @Direction: Input
           @Type: Date
           @ParamDesc: 日期
    @Returns:
       @Type: Integer
       @ReturnsDesc: 第一班上班时间
    @Exception:  
    @BusinessLogic: 
       如果不存在班次定义，默认早上8:00
    @Todo: 

    @History: 
   **/

   define variable startTime as integer .

   for first shop_cal no-lock
   where shop_site = site
   and shop_wkctr = productionLine:  end .
   
   if not available(shop_cal) then
   for first shop_cal no-lock
   where shop_site = site
   and shop_wkctr = "":  end .
   
   if not available(shop_cal) then
   for first shop_cal no-lock
   where shop_site = ""
   and shop_wkctr = "":  end .
   
   if not available(shop_cal) then
      startTime = 8 * 3600 .
   else do:
      for first shft_det no-lock
      where shft_site = shop_site
      and shft_wkctr = shop_wkctr:  end .

      if not available(shft_det) then
         startTime = 8 * 3600 .
      else
         startTime = shft_start1 * 3600 .
   end .

   return startTime .
end function .

FUNCTION CKProgramSecurity RETURNS LOGICAL
(INPUT pgm-name AS CHARACTER):
   /**
    @Description: 判断程序是否可运行
    @Parameters: 
       @Param: pgm-name
           @Direction: Input
           @Type: Character
           @ParamDesc: 要查找的程序                   
    @Shared: 
    @Returns: 
       @Type: Logical
       @ReturnsDesc: Yes, 表示可运行
    @Exception:   
    @BusinessLogic: 
    @Todo: 
    @History: 
   **/

    DEFINE VARIABLE pgm-label AS CHARACTER .
    DEFINE VARIABLE passed AS LOGICAL .
    DEFINE VARIABLE isProgram AS LOGICAL .

    {gprun.i ""gpusrpgm.p"" "(input pgm-name ,
        OUTPUT pgm-label ,
        OUTPUT passed ,
        OUTPUT isprogram)"
     }

    IF passed = NO OR isprogram = NO THEN RETURN FALSE .
    ELSE RETURN TRUE .

END FUNCTION .



