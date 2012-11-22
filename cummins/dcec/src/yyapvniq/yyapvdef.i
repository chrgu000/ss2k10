/**
 @File: yyapvdef.i
 @Description: AP对帐单共享变量定义
 @Version: 1.0
 @Author: Cai Jing
 @Created: 2005-8-26
 @BusinessLogic: AP对帐单共享变量定义
 @Todo:
 @History:
**/

DEF {1} SHARED VARIABLE bh LIKE ap_batch .
DEF {1} SHARED VARIABLE bh1 LIKE ap_batch .
DEF {1} SHARED VARIABLE dt LIKE ap_date .
DEF {1} SHARED VARIABLE dt1 LIKE ap_date .
DEF {1} SHARED VARIABLE vd LIKE ap_vend .
DEF {1} SHARED VARIABLE vd1 LIKE ap_vend .
DEF {1} SHARED VARIABLE efdt LIKE ap_effdate .
DEF {1} SHARED VARIABLE efdt1 LIKE ap_effdate .
DEF {1} SHARED VARIABLE base_rpt LIKE ap_curr.
