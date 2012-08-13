/**
 @File: zylib.p
 @Description: ��԰�������ļ�
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
    @Description: �ж��û��Ƿ���Ȩ��ʹ������ص�
    @Parameters: 
       @Param: site
           @Direction: Input
           @Type: Character
           @ParamDesc: �ص����
    @Shared: 
    @Returns: 
       @Type: Logical
       @ReturnsDesc: Yes, ��ʾ�û���Ȩʹ������ص�
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
    @Description: �ж�ĳһģ���������������Ƿ񿪷�
    @Parameters: 
       @Param: transtype
           @Direction: Input
           @Type: Character
           @ParamDesc: ����ģ�飨AP,AR,FA,IC,SO,GL��
       @Param: entity           
           @Direction: Input
           @Type: Character
           @ParamDesc: ��Ƶ�λ
       @Param: effdate           
           @Direction: Input
           @Type: Date
           @ParamDesc: У�����Ч����                       
    @Shared: 
    @Returns: 
       @Type: Logical
       @ReturnsDesc: Yes, ��ʾ���ʿ���
    @Exception: �رյĻ�����������һ����ʾ��Ϣ��   
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
    @Description: �жϸ�����λ�Ƿ����߱߿�λ
    @Parameters: 
       @Param: location
           @Direction: Input
           @Type: Character
           @ParamDesc: ��λ����
    @Shared: 
    @Returns: 
       @Type: Logical
       @ReturnsDesc: Yes, ��ʾ��λ��һ���߱߿�λ
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
    @Description: ��ȡ������߱߿�λ����
    @Parameters: 
       @Param: routingCode
           @Direction: Input
           @Type: Character
           @ParamDesc: ��������
       @Param: operation
           @Direction: Input
           @Type: Integer
           @ParamDesc: ����
    @Shared: 
    @Returns: 
       @Type: Character
       @ReturnsDesc: ָ��������߱߿�λ����
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
    @Description: ��ȡ����Ĳ�Ʒ�ṹ����
    @Parameters: 
       @Param: site
           @Direction: Input
           @Type: Character
           @ParamDesc: �ص�
       @Param: part
           @Direction: Input
           @Type: Character
           @ParamDesc: �����
    @Shared: 
    @Returns: 
       @Type: Character
       @ReturnsDesc: ����ڸõص�Ĳ�Ʒ�ṹ����
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
    @Description: ��ȡ����Ĺ������̴���
    @Parameters: 
       @Param: site
           @Direction: Input
           @Type: Character
           @ParamDesc: �ص�
       @Param: part
           @Direction: Input
           @Type: Character
           @ParamDesc: �����
    @Shared: 
    @Returns: 
       @Type: Character
       @ReturnsDesc: ����ڸõص�Ĺ������̴���
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
    @Description: ��ȡ��һ���ϰ�ʱ��
    @Parameters: 
       @Param: site
           @Direction: Input
           @Type: Character
           @ParamDesc: �ص�
       @Param: productionLine
           @Direction: Input
           @Type: Character
           @ParamDesc: ������
       @Param: produceDate
           @Direction: Input
           @Type: Date
           @ParamDesc: ����
    @Returns:
       @Type: Integer
       @ReturnsDesc: ��һ���ϰ�ʱ��
    @Exception:  
    @BusinessLogic: 
       ��������ڰ�ζ��壬Ĭ������8:00
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
    @Description: �жϳ����Ƿ������
    @Parameters: 
       @Param: pgm-name
           @Direction: Input
           @Type: Character
           @ParamDesc: Ҫ���ҵĳ���                   
    @Shared: 
    @Returns: 
       @Type: Logical
       @ReturnsDesc: Yes, ��ʾ������
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



