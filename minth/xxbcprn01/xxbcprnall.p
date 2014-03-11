/* xxbcprnall.p 打印选择程序---根据传入参数选择运行对应的解析打印程序            */
/*
   使用@符号进行分割par1@par2@par3@par4@par5@par6@par7@.........
   par1是标签类型代码，决定调用的标签程序名
   整个参数会被传入调用的程序
*/
{mfdeclre.i}
define input parameter thpar as char.
define var mypro as char.

mypro ="".
if num-entries(thpar,"@") > 0 then
  mypro = "xxbcprn" + entry(1,thpar,"@") + ".p".
else mypro = "xxbcprn02.p".

{gprun.i mypro "(input thpar)"}
