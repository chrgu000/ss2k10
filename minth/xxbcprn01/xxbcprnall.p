/* xxbcprnall.p ��ӡѡ�����---���ݴ������ѡ�����ж�Ӧ�Ľ�����ӡ����            */
/*
   ʹ��@���Ž��зָ�par1@par2@par3@par4@par5@par6@par7@.........
   par1�Ǳ�ǩ���ʹ��룬�������õı�ǩ������
   ���������ᱻ������õĳ���
*/
{mfdeclre.i}
define input parameter thpar as char.
define var mypro as char.

mypro ="".
if num-entries(thpar,"@") > 0 then
  mypro = "xxbcprn" + entry(1,thpar,"@") + ".p".
else mypro = "xxbcprn02.p".

{gprun.i mypro "(input thpar)"}
