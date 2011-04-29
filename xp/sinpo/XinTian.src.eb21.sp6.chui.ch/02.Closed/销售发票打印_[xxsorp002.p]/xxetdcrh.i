/* etdcrh.i - Dual Currency Report Include                                    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.7.3.5 $                                                       */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 8.6E           CREATED: 04/29/98   BY: *L00L* AJH                */
/* REVISION: 8.6E     LAST MODIFIED: 05/18/98   BY: *L012* CPD/EJ             */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 06/04/98   BY: *L01M* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 04/13/00   BY: *N08H* Rajesh Thomas      */
/* REVISION: 9.1      LAST MODIFIED: 06/30/00   BY: *N009* Ken Balmy          */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0KW* Jacolyn Neder      */
/* $Revision: 1.7.3.5 $  BY: Jean Miller         DATE: 12/14/01  ECO: *P03Q*  */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100726.1  By: Roger Xiao */



/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

define variable msg_txt1 as character format "x(90)" no-undo.
define variable msg_txt2 as character format "x(90)" no-undo.
define variable l_msgdesc like msg_desc extent 2     no-undo.

/* PRICES ARE SHOWN FOR REFERENCE ONLY, AND MAY NOT ADD UP CORRECTLY */
{pxmsg.i &MSGNUM=3768 &ERRORLEVEL=1 &MSGBUFFER=l_msgdesc[1]}

/* THE ONLY VALID PRICES AND AMOUNTS ARE STATED IN */
{pxmsg.i &MSGNUM=3600 &ERRORLEVEL=1 &MSGBUFFER=l_msgdesc[2]}

if et_dc_print then do:

   if {1} <> et_euro_curr then
   assign
      msg_txt1 = et_euro_curr + " " + l_msgdesc[1]
      msg_txt2 = l_msgdesc[2] + " " + {1} + ".".
   else
   assign
      msg_txt1 = et_sec_curr + " " + l_msgdesc[1]
      msg_txt2 = l_msgdesc[2] + " " + et_euro_curr + ".".

/* SS - 100726.1 - B 
   put
      skip(1)
      msg_txt1
      skip
      msg_txt2.
   SS - 100726.1 - E */

   assign
      et_line_total = 0
      et_ext_price_total = 0
      et_disc_amt = 0
      et_tax_amt = 0
      et_ord_amt = 0
      et_trl1_amt = 0
      et_trl2_amt = 0
      et_trl3_amt = 0.

end. /* if et_dc_print */
