/* xswor02trans.i -- */
/* Copyright 200908 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */



run pxgblmgr.p persistent set global_gblmgr_handle.



usection = string(year(TODAY), "9999")
    + string(MONTH(TODAY), "99")
    + string(DAY(TODAY), "99")
    + STRING(TIME, "99999")
    + string(RANDOM(0, 99), "99")
    + "wor02"
    .

assign
    ciminputfile = usection + ".i"
    cimoutputfile = usection + ".o"
    .

output to value(ciminputfile).
/* 工单*     */  {xxputcimvariable.i ""quote"" """"  "at 1"}
/* 标        */  {xxputcimvariable.i ""quote"" s0020}
/* 生效日期  */  {xxputcimvariable.i ""d"" ""-""}
/* 数量*     */  {xxputcimvariable.i ""d"" 1 "at 1"}
/* 单位      */  {xxputcimvariable.i ""d"" ""-""}
/* 换算      */  {xxputcimvariable.i ""d"" ""-""}
/* 废品      */  {xxputcimvariable.i ""d"" ""-""}
/* 单位      */  {xxputcimvariable.i ""d"" ""-""}
/* 换算      */  {xxputcimvariable.i ""d"" ""-""}
/* 地点      */  {xxputcimvariable.i ""quote"" s0010}
/* 库位      */  {xxputcimvariable.i ""quote"" s0050}
/* 批号      */  {xxputcimvariable.i ""quote"" """"}
/* 参考      */  {xxputcimvariable.i ""quote"" """"}
/* 多记录    */  {xxputcimvariable.i ""d"" ""N""}
/* 设置属性  */  {xxputcimvariable.i ""d"" ""N""}
/* 备注*     */  {xxputcimvariable.i ""quote"" mfguser "at 1"}
/* 结算      */  {xxputcimvariable.i ""d"" ""N""}
/* 显示信息* */  {xxputcimvariable.i ""d"" ""N"" "at 1"}
/* 确认*     */  {xxputcimvariable.i ""d"" ""Y"" "at 1"}
put "." at 1.
output close.

find last tr_hist use-index tr_trnbr.
iTrSeq = if available tr_hist then tr_trnbr else 0.

input from value(ciminputfile).
output to  value(cimoutputfile).
{gprun.i ""woworc.p""}
input close.
output close.

{xserrlg.i}
/*
os-delete value(ciminputfile).
os-delete value(cimoutputfile).
*/
