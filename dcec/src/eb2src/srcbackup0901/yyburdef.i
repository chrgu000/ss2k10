/**
 @File: yyburdef.i
 @Description: 费用处理共享变量定义
 @Version: 1.0
 @Author: Cai Jing
 @Created: 2005-8-26
 @BusinessLogic: 费用处理共享变量定义
 @Todo: 
 @History: 
**/

DEF {1} SHARED VAR ent LIKE gl_entity .
DEF {1} SHARED VAR ent1 LIKE gl_entity .
DEF {1} SHARED VAR glyear LIKE acd_year .
DEF {1} SHARED VAR glper LIKE acd_per .
DEF {1} SHARED VAR expense AS LOG .
DEF {1} SHARED VAR bsales AS DEC .
DEF {1} SHARED VAR csales AS DEC .
DEF {1} SHARED VAR bdiscount AS DEC .
DEF {1} SHARED VAR cdiscount AS DEC .

DEF {1} SHARED TEMP-TABLE data
    FIELD data_acc LIKE acd_acc
    FIELD data_sub LIKE acd_sub
    FIELD data_cc LIKE acd_cc
    FIELD data_entity LIKE acd_entity
    FIELD data_amt LIKE acd_amt .


