/* SS - 091223.1 By: Kaine Zhang */

/* block.001.start # cim procedure */
output to value(sInputFile).
/* 加工单     */    {xxputcimvariable.i ""qq"" sWoNbr "at 1"}
/* ID         */    {xxputcimvariable.i ""qq"" sWoLot}

/* 数量       */    {xxputcimvariable.i ""d"" ""-"" "at 1"}
/* 订货日期   */    {xxputcimvariable.i ""d"" ""-""}
/* 发放日期   */    {xxputcimvariable.i ""d"" ""-""}
/* 截止日期   */    {xxputcimvariable.i ""d"" ""-""}
/* 状态       */    {xxputcimvariable.i ""qq"" ""C""}
/* 客户单     */    {xxputcimvariable.i ""d"" ""-""}
/* 供应商     */    {xxputcimvariable.i ""d"" ""-""}
/* 产出率     */    {xxputcimvariable.i ""d"" ""-""}
/* 地点       */    {xxputcimvariable.i ""d"" ""-""}
/* 工艺流程   */    {xxputcimvariable.i ""d"" ""-""}
/* 物料清单   */    {xxputcimvariable.i ""d"" ""-""}
/* 备注       */    {xxputcimvariable.i ""d"" ""-""}
/* 说明       */    {xxputcimvariable.i ""d"" ""N""}
/* 车间差异   */    {xxputcimvariable.i ""d"" ""-""}

/* 单批       */    {xxputcimvariable.i ""d"" ""-"" "at 1"}

/* 批号       */    {xxputcimvariable.i ""d"" ""-"" "at 1"}

/* 会计数据1  */    {xxputcimvariable.i ""d"" ""-"" "at 1"}
/* 会计数据2  */    {xxputcimvariable.i ""d"" ""-""}
/* 会计数据3  */    {xxputcimvariable.i ""d"" ""-""}
/* 会计数据4  */    {xxputcimvariable.i ""d"" ""-""}
/* 会计数据5  */    {xxputcimvariable.i ""d"" ""-""}
/* 会计数据6  */    {xxputcimvariable.i ""d"" ""-""}
/* 会计数据7  */    {xxputcimvariable.i ""d"" ""-""}
/* 会计数据8  */    {xxputcimvariable.i ""d"" ""-""}
/* 会计数据9  */    {xxputcimvariable.i ""d"" ""-""}
/* 会计数据10 */    {xxputcimvariable.i ""d"" ""-""}
/* 会计数据11 */    {xxputcimvariable.i ""d"" ""-""}
/* 会计数据12 */    {xxputcimvariable.i ""d"" ""-""}
/* 会计数据13 */    {xxputcimvariable.i ""d"" ""-""}
/* 会计数据14 */    {xxputcimvariable.i ""d"" ""-""}
/* 会计数据15 */    {xxputcimvariable.i ""d"" ""-""}
/* 会计数据16 */    {xxputcimvariable.i ""d"" ""-""}
/* 会计数据17 */    {xxputcimvariable.i ""d"" ""-""}
/* 会计数据18 */    {xxputcimvariable.i ""d"" ""-""}
/* 会计数据19 */    {xxputcimvariable.i ""d"" ""-""}
/* 会计数据20 */    {xxputcimvariable.i ""d"" ""-""}
/* 会计数据21 */    {xxputcimvariable.i ""d"" ""-""}
/* 会计数据22 */    {xxputcimvariable.i ""d"" ""-""}
put "." at 1.
output close.


input from value(sInputFile).
output to  value(sOutputFile).
batchrun = yes.
{gprun.i ""wowomt.p""}
batchrun = no.
input close.
/* block.001.finish # cim procedure */

os-delete value(sInputFile).
os-delete value(sOutputFile).


