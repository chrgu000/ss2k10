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
/* 物料                 */    {xxputcimvariable.i ""quote"" sAssemblePart  "at 1"}    
/* 数量                 */    {xxputcimvariable.i ""d"" 1 "at 1"}     
/* 生效日期             */    {xxputcimvariable.i ""d"" ""-""}                
/* 订单                 */    {xxputcimvariable.i ""quote"" mfguser}                
/* 客户单               */    {xxputcimvariable.i ""d"" ""-""}             
/* 备注                 */    {xxputcimvariable.i ""d"" ""-""}             
/* 转移备料库存         */    {xxputcimvariable.i ""d"" ""-""   "at 1"}             
/* 库存状态冲突(自/至)  */    {xxputcimvariable.i ""d"" ""-""}                
/* 使用缺省状态         */    {xxputcimvariable.i ""d"" ""-""}
/* 新的状态             */    {xxputcimvariable.i ""d"" ""-""}         
/* from地点             */    {xxputcimvariable.i ""quote"" s0010  "at 1"}                
/* from库位             */    {xxputcimvariable.i ""quote"" s0050}                
/* from批号             */    {xxputcimvariable.i ""quote"" """"}                
/* from参考             */    {xxputcimvariable.i ""d"" ""-""}             
/* to地点               */    {xxputcimvariable.i ""quote"" s0010  "at 1"}                
/* to库位               */    {xxputcimvariable.i ""quote"" s0060}                
/* to批号               */    {xxputcimvariable.i ""quote"" """"}                
/* to参考               */    {xxputcimvariable.i ""d"" ""-""}                
/* 确定                 */    {xxputcimvariable.i ""d"" ""Y"" "at 1"}
put "." at 1.
output close.

find last tr_hist use-index tr_trnbr.
iTrSeq = if available tr_hist then tr_trnbr else 0.

input from value(ciminputfile).
output to  value(cimoutputfile).
{gprun.i ""iclotr04.p""}
input close.
output close.

/* {xserrlg.i} */
/*
os-delete value(ciminputfile).
os-delete value(cimoutputfile).
*/
