/**
 @File: yyburtur.i
 @Description: 生成总帐明细行记录
 @Version: 1.0
 @Author: Cai Jing
 @Created: 2005-8-26
 @BusinessLogic: 生成总帐明细行记录
 @Todo: 
 @History: 
**/

FIND FIRST xxgl WHERE xxgl_acct = {&acc}
    AND xxgl_sub = {&sub} 
    AND xxgl_cc = {&cc} 
    AND xxgl_entity = data_entity NO-ERROR .
IF NOT AVAILABLE xxgl THEN DO :
    CREATE xxgl .
    xxgl_acct = {&acc} .
    xxgl_sub = {&sub} .
    xxgl_cc = {&cc} .
    xxgl_entity = data_entity .
END.
xxgl_amt = xxgl_amt + {&amt} .
