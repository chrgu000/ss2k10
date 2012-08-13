/* so10c01.i -                                                          */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/*so10c01.i INVOICE PRINT include file */
/* REVISION: 5.0    LAST MODIFIED:  03/12/89   BY: MLB *B615*/

/*NOTE: to translate, change "continued"*/
/* this file compiles into sorp1001.p */

form header
  fill("-",77)   format "x(77)" skip
  space(31)
  "*** ¼Ì Ðø ***" skip(8)
with frame continue page-bottom width 80.
