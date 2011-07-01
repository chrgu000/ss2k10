/* xsgetpartlotkeepbc.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */
/* SS - 090903.1 By: Kaine Zhang */
/* SS - 110314.1 By: Kaine Zhang */

/*
 *  由扫描的条码中,获取物料编码,批号,供应商.
 *  {1} -- 条码来源.
 *  {2} -- 物料编码
 *  {3} -- 批号
 *  {4} -- 消息显示变量
 *  {5} -- 显示在哪个frame中
 *  {6} -- 出错后,重来该loop
 */  

/* *ss_20090730* 检查条码正确性,如果条码非长丰标准条码,则进行标准转换. */
if {1} = "" then do:
    display
        "条码不可留空" @ {4}
    with frame {5}.
    undo {6}, retry {6}.
end.

/* +标记判断 */
if substring({1}, length({1}, "RAW"), 1) <> "+" then do:
    {4} = "最后一位不是+,非座椅条码". 
    display {4} with frame {5}.
    undo {6}, retry {6}.
end.

/* -标记判断 */
assign
    {2} = ""
    {3} = ""
    .

/* SS - 110314.1 - B
assign    
    {2} = entry(1, {1}, "-")
    {3} = entry(2, {1}, "-")
    no-error
    .
SS - 110314.1 - E */
/* SS - 110314.1 - B */
assign
    {2} = substring({1}, 1, length({1}) - 11)
    {3} = substring({1}, length({1}) - 9, 10)
    no-error
    .
/* SS - 110314.1 - E */

if error-status:error then do:
    {4} = "条码错误,无法获取料号批号".
    display {4} with frame {5}.
    undo {6}, retry {6}.
end.

/* 003标记判断. (003是长丰沙发作为股份公司供应商的代码) */
if substring({2}, 1, 3) <> "003" then do:
    {4} = "条码错误,非003提供".
    display {4} with frame {5}.
    undo {6}, retry {6}.
end.
substring({2}, 1, 3) = "".

substring({3}, length({3}), 1) = "".
/* 为保证系统初期运行顺畅(历史数据,人为错误可能会在初期比较多),本段验证暂不启用
find first pt_mstr
    no-lock
    where pt_part = {2}
    no-error.
if not(available(pt_mstr)) then do:
    display
        "物料编码无效" @ {4}
    with frame {5}.
    undo {6}, retry {6}.
end.
*/

