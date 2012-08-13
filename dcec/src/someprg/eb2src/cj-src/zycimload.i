/**
 @File: zycimload.i
 @Description: eb2-cimload共享变量定义
 @Version: 1.0
 @Author: Cai Jing
 @Created: 2005-8-26
 @BusinessLogic: eb2-cimload共享变量定义
 @Todo: 
 @History: 
**/

DEFINE {1} SHARED TEMP-TABLE xxerrtb NO-UNDO
    FIELD xxerr AS CHARACTER
    FIELD xxmsg AS CHARACTER .

DEFINE {1} SHARED VARIABLE xxxfid LIKE bdld_id.
DEFINE {1} SHARED VARIABLE xxxlid LIKE bdld_id.
