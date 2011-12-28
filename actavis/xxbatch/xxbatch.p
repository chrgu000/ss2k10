/* xxbmpsrp10.p - bom runtime report                                         */
/* REVISION:101020.2 LAST MODIFIED: 10/20/10 BY: zy                          */
/* REVISION:101028.1 LAST MODIFIED: 10/28/10 BY: zy                      *as**/
/* REVISION:101028.1 LAST MODIFIED: 11/29/10 BY: zy                      *bt**/
/*-Revision end--------------------------------------------------------------*/
/* Environment: Progress:10.1C04   QAD:eb21sp6                               */
/*V8:ConvertMode=NoConvert                                                   */

output to xxbatch.bpi.
  put unformat 'mfg ""' skip '-' skip.
  put unformat "mgbatch.p" skip.
  put unformat 'utldqty.p' skip '- - - - - - - - - - yes' skip 'utldqty' skip.
  put unformat 'utdsqty.p' skip '- - - - - - - - yes' skip 'utdsqty' skip.
  put unformat 'utptqty.p' skip '- - - - - - - - - - - - yes -' skip 'utptqty' skip.
output close.

input from xxbatch.bpi.
output to xxbatch.bpo.
   run mf.p.
input close.
output close.

os-delete xxbatch.bpi.
os-delete xxbatch.bpo.