/* xssoiss10trans.i ---- */
/* Copyright 2011 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 110321.1 By: Kaine Zhang */



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
/* 订单*        */    {xxputcimvariable.i ""quote"" s0020 "at 1"}
/* 生效日期     */    {xxputcimvariable.i ""d"" ""-""}
/* 备料量       */    {xxputcimvariable.i ""d"" ""N""}
/* 领料量       */    {xxputcimvariable.i ""d"" ""N""}
/* 地点         */    {xxputcimvariable.i ""quote"" s0010}
/* 项*          */    {xxputcimvariable.i ""d"" i0060 "at 1"}
/* 取消欠交     */    {xxputcimvariable.i ""d"" ""N""}
/* 数量*        */    {xxputcimvariable.i ""d"" 1 "at 1"}
/* 地点         */    {xxputcimvariable.i ""quote"" s0010}
/* 库位         */    {xxputcimvariable.i ""quote"" s0050}
/* 批号         */    {xxputcimvariable.i ""quote"" """"}
/* 参考         */    {xxputcimvariable.i ""quote"" """"}
/* 多记录       */    {xxputcimvariable.i ""d"" ""N""}
/* 离开F4*      */    {xxputcimvariable.i ""d"" ""."" "at 1"}
/* 显示*        */    {xxputcimvariable.i ""d"" ""N"" "at 1"}
/* 确定*        */    {xxputcimvariable.i ""d"" ""Y"" "at 1"}
/* 10*          */    {xxputcimvariable.i ""d"" ""-"" "at 1"}
/* 101          */    {xxputcimvariable.i ""d"" ""-""}
/* 20           */    {xxputcimvariable.i ""d"" ""-""}
/* 201          */    {xxputcimvariable.i ""d"" ""-""}
/* 30           */    {xxputcimvariable.i ""d"" ""-""}
/* 301          */    {xxputcimvariable.i ""d"" ""-""}
/* 看税细节     */    {xxputcimvariable.i ""d"" ""N""}
/* 运输代理*    */    {xxputcimvariable.i ""d"" ""-"" "at 1"}
/* 发货日期     */    {xxputcimvariable.i ""d"" ""-""}
/* 提单         */    {xxputcimvariable.i ""d"" ""-""}
/* 备注         */    {xxputcimvariable.i ""d"" ""-""}
/* 发票号       */    {xxputcimvariable.i ""d"" ""-""}
/* 准备打印发票 */    {xxputcimvariable.i ""d"" ""-""}
/* 已开发票     */    {xxputcimvariable.i ""d"" ""-""}
put "." at 1.
output close.

find last tr_hist use-index tr_trnbr.
iTrSeq = if available tr_hist then tr_trnbr else 0.

input from value(ciminputfile).
output to  value(cimoutputfile).
{gprun.i ""sosois.p""}
input close.
output close.

{xserrlg.i}
/*
os-delete value(ciminputfile).
os-delete value(cimoutputfile).
*/
