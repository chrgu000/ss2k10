/* xsgetpartlot.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */
/* SS - 110314.1 By: Kaine Zhang */

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

assign
    {2} = ""
    {3} = ""
    {7} = ""
    .

/*
 *  长沙条码最后一位,未使用"+"符号.
 *  if substring({1}, length({1}, "RAW"), 1) = "+" then do:
 *      iLastHyphen = r-index({1}, "-").
 *      {2} = substring({1}, 4, iLastHyphen - 4) .
 *      {3} = substring({1}, iLastHyphen + 1, length({1}) - iLastHyphen - 1) .
 *  end.
 */

iLastHyphen = r-index({1}, "-").
{2} = substring({1}, 4, iLastHyphen - 4) .
{3} = substring({1}, iLastHyphen + 1, length({1}) - iLastHyphen) .


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



