/* zzgt001.i - ingoral "                                                  */
/*                                                                         */
/* VERSION:          DATE:2000.04.17  BY:James Zou*ORIGIN SHA*BW0000       */


do i = 1 to length({1}):
  if substring({1},i,1) = '~~' then substring({1},i,1) = "#".
end.



