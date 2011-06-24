/* xsgetpartlot.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/*
 *  由扫描的条码中,获取物料编码,批号,供应商.
 *  {1} -- 条码来源.
 *  {2} -- 物料编码
 *  {3} -- 批号
 *  {4} -- 消息显示变量
 *  {5} -- 显示在哪个frame中
 *  {6} -- 出错后,重来该loop
 *  {7} -- 供应商编码
 */  

/* *ss_20090730* 检查条码正确性,如果条码非长丰标准条码,则进行标准转换. */
if {1} = "" then do:
    display
        "条码不可留空" @ {4}
    with frame {5}.
    undo {6}, retry {6}.
end.
if substring({1}, length({1}, "RAW"), 1) = "+" then do:
    {1} = substring({1}, 4, length({1}, "RAW") - 4, "RAW").
    {1} = replace({1}, "-", "$").
end.

assign
    {2} = ""
    {3} = ""
    .

assign    
    {2} = entry(1, {1}, sDelimiter)
    {3} = entry(2, {1}, sDelimiter)
    no-error
    .
    
if error-status:error then do:
    display
        "输入物料与批号错误" @ {4}
    with frame {5}.
    undo {6}, retry {6}.
end.

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

{7} = substring({3}, 7, 4).
