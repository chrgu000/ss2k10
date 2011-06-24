/* SS - 100203.1 By: Kaine Zhang */

/*
 *  20100202.email
 *  new work order's status: set to 'B'.
 */
 
output to value(sInputFile).
/* 工单*    */   {xxputcimvariable.i ""qq"" sWoNbr  "at 1"}
/* 标       */   {xxputcimvariable.i ""qq"" sWoLot}

/* 物料     */   {xxputcimvariable.i ""qq"" t1_part "at 1"}
/* 类型     */   {xxputcimvariable.i ""d"" ""-""}
/* 地点     */   {xxputcimvariable.i ""d"" ""-""}

/* 数量     */   {xxputcimvariable.i ""d"" decTransQty "at 1"}
/* 日期1    */   {xxputcimvariable.i ""d"" ""-""}
/* 日期2    */   {xxputcimvariable.i ""d"" ""-""}
/* 日期3    */   {xxputcimvariable.i ""d"" ""-""}
/* SS - 100203.1 - B
/* 状态     */   {xxputcimvariable.i ""d"" ""-""}
SS - 100203.1 - E */
/* SS - 100203.1 - B */
/* 状态     */   {xxputcimvariable.i ""qq"" ""B""}
/* SS - 100203.1 - E */
/* -        */   {xxputcimvariable.i ""d"" ""-""}
/* -        */   {xxputcimvariable.i ""d"" ""-""}
/* -        */   {xxputcimvariable.i ""d"" ""-""}
/* -        */   {xxputcimvariable.i ""d"" ""-""}
/* -        */   {xxputcimvariable.i ""d"" ""-""}
/* -        */   {xxputcimvariable.i ""d"" ""-""}
/* 备注     */   {xxputcimvariable.i ""d"" ""-""}
/* 说明     */   {xxputcimvariable.i ""d"" ""N""}
/* 差异     */   {xxputcimvariable.i ""d"" ""-""}

/* 单批     */   {xxputcimvariable.i ""d"" ""N"" "at 1"}

/* 批号     */   {xxputcimvariable.i ""qq"" """" "at 1"}

/* 尾巴一块 */   {xxputcimvariable.i ""d"" ""-"" "at 1"}
put "." at 1.
output close.
