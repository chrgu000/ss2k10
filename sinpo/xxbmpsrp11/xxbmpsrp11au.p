/* xxbmpsrp10.p - bom runtime report                                         */
/* REVISION:101020.2 LAST MODIFIED: 10/20/10 BY: zy                          */
/* REVISION:101028.1 LAST MODIFIED: 10/28/10 BY: zy                      *as**/
/* REVISION:101028.1 LAST MODIFIED: 11/29/10 BY: zy                      *bt**/
/*-Revision end--------------------------------------------------------------*/
/* Environment: Progress:10.1C04   QAD:eb21sp6                               */
/*V8:ConvertMode=NoConvert                                                   */
output to xxbmpsrp10.in.
  put unformat 'mfg mfgpro' skip '-' skip.
  put unformat "xxbmpsrp11.p" skip.
  put unformat '"" ""' skip.
  put unformat "bmpsrp" skip.
  put unformat '""' skip.
  put "." skip.
  put "." skip.
  put "Y" skip.
output close.

input from xxbmpsrp10.in.
output to xxbmpsrp10.out.
   run mf.p.
input close.
output close.
