/* SS - 091223.1 By: Kaine Zhang */

/* block.001.start # cim procedure */
output to value(sInputFile).
/* �ӹ���     */    {xxputcimvariable.i ""qq"" sWoNbr "at 1"}
/* ID         */    {xxputcimvariable.i ""qq"" sWoLot}

/* ����       */    {xxputcimvariable.i ""d"" ""-"" "at 1"}
/* ��������   */    {xxputcimvariable.i ""d"" ""-""}
/* ��������   */    {xxputcimvariable.i ""d"" ""-""}
/* ��ֹ����   */    {xxputcimvariable.i ""d"" ""-""}
/* ״̬       */    {xxputcimvariable.i ""qq"" ""C""}
/* �ͻ���     */    {xxputcimvariable.i ""d"" ""-""}
/* ��Ӧ��     */    {xxputcimvariable.i ""d"" ""-""}
/* ������     */    {xxputcimvariable.i ""d"" ""-""}
/* �ص�       */    {xxputcimvariable.i ""d"" ""-""}
/* ��������   */    {xxputcimvariable.i ""d"" ""-""}
/* �����嵥   */    {xxputcimvariable.i ""d"" ""-""}
/* ��ע       */    {xxputcimvariable.i ""d"" ""-""}
/* ˵��       */    {xxputcimvariable.i ""d"" ""N""}
/* �������   */    {xxputcimvariable.i ""d"" ""-""}

/* ����       */    {xxputcimvariable.i ""d"" ""-"" "at 1"}

/* ����       */    {xxputcimvariable.i ""d"" ""-"" "at 1"}

/* �������1  */    {xxputcimvariable.i ""d"" ""-"" "at 1"}
/* �������2  */    {xxputcimvariable.i ""d"" ""-""}
/* �������3  */    {xxputcimvariable.i ""d"" ""-""}
/* �������4  */    {xxputcimvariable.i ""d"" ""-""}
/* �������5  */    {xxputcimvariable.i ""d"" ""-""}
/* �������6  */    {xxputcimvariable.i ""d"" ""-""}
/* �������7  */    {xxputcimvariable.i ""d"" ""-""}
/* �������8  */    {xxputcimvariable.i ""d"" ""-""}
/* �������9  */    {xxputcimvariable.i ""d"" ""-""}
/* �������10 */    {xxputcimvariable.i ""d"" ""-""}
/* �������11 */    {xxputcimvariable.i ""d"" ""-""}
/* �������12 */    {xxputcimvariable.i ""d"" ""-""}
/* �������13 */    {xxputcimvariable.i ""d"" ""-""}
/* �������14 */    {xxputcimvariable.i ""d"" ""-""}
/* �������15 */    {xxputcimvariable.i ""d"" ""-""}
/* �������16 */    {xxputcimvariable.i ""d"" ""-""}
/* �������17 */    {xxputcimvariable.i ""d"" ""-""}
/* �������18 */    {xxputcimvariable.i ""d"" ""-""}
/* �������19 */    {xxputcimvariable.i ""d"" ""-""}
/* �������20 */    {xxputcimvariable.i ""d"" ""-""}
/* �������21 */    {xxputcimvariable.i ""d"" ""-""}
/* �������22 */    {xxputcimvariable.i ""d"" ""-""}
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


