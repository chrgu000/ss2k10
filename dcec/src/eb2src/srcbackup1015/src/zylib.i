/**
 @File: zylib.i
 @Description: 智园公共库文件定义头文件
 @Version: 1.0
 @Author: Zhi Yuan
 @Created: 2005-5-16
 @Functions: 
     CKProgramSecurity    
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

 @Todo: 
 @History: 
**/

DEFINE VARIABLE hf-zylib AS HANDLE .
run value(global_user_lang + "\zy\zylib.p") PERSISTENT SET hf-zylib .

FUNCTION CKProgramSecurity returns logical
(input pgm-name as character) in hf-zylib .

function CKSiteSecurity returns logical
(input site as character) in hf-zylib .

function CKGLEffDate returns LOGICAL
(input transtype as character,
 input entity as character,
 input effdate as DATE) in hf-zylib .

function IsWCLocation returns logical
(input location as character) in hf-zylib .

function IsWCLocation returns logical
(input location as character) in hf-zylib .

function GetWCLocation returns character
(input routingCode as character,
 input operation as integer) in hf-zylib .

function GetItemBOMCode returns character
(input site as character,
 input part as character
) in hf-zylib .

function GetItemRoutingCode returns character
(input site as character,
 input part as character
) in hf-zylib .

function GetFirstShiftStart returns integer
(input site as character,
 input productionLine as character,
 input produceDate as date
 ) in hf-zylib .

function GetDailyBOMCode returns character
(input site as character,
 input productionLine as character,
 input part as character,
 input effectiveDate as date
) in hf-zylib .

function GetDailyRoutingCode returns character
(input site as character,
 input productionLine as character,
 input part as character,
 input effectiveDate as date
) in hf-zylib .

function GetWOLot returns character
(input effDate as date,
 input site as character,
 input line as character,
 input part as character,
 input bom as character,
 input routing as character
)  in hf-zylib .
