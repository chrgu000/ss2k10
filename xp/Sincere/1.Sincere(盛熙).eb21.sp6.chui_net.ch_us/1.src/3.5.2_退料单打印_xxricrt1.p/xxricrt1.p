/*xxricrt1.p 退料单打印程式                                                      */
/*----rev history-------------------------------------------------------------------------------------*/
/* ss - 100611.1 by:jack */
/* ss - 100623.1 by: jack */
/* ss - 100714.1 by: jack */
/* ss - 100729.1 by: jack */
/* ss - 100809.1 by: jack */
/* ss - 100810.1 by: jack */
/* SS - 101208.1  By: Roger Xiao */  /*修改格式,同时将jack的3.5.1和本程式统一:使用公用子程式xxricrt11.p,以避免3.5.1和3.5.2打印版本不同 */
/*-Revision end---------------------------------------------------------------*/

{mfdtitle.i "101208.1"}

define var v-tmp-num as char .

{gprun.i ""xxricrt11.p"" "(input v-tmp-num)"}