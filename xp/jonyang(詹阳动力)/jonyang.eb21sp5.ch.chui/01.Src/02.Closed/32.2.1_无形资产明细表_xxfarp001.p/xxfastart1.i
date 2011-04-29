/*xxfastart1.i 计算折旧初始月份,折旧初始日期的下一个月*/
/*此为公用子程式,不可随意修改*/
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100521.1  By: Roger Xiao */

define var v_startdt as char format "x(12)" .

if famt_conv = "2" or  famt_conv = "3" then 
    v_startdt = 
        if month(fa_startdt) = 12 then  string(year(fa_startdt) + 1 ,"9999") + "/01/01" 
        else string(year(fa_startdt),"9999") + "/" + string(month(fa_startdt) + 1 ,"99") + "/01".
else 
    v_startdt = string(year(fa_startdt),"9999") + "/" + string(month(fa_startdt) ,"99") + "/" + string(day(fa_startdt) ,"99") .


/*此为公用子程式,不可随意修改*/
