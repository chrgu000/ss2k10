/* xxsoivm1.p - INVOICE MAINTENANCE                                             */
/* Copyright 1996-2006 Softspeed, China.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.95.1.6 $                                                      */
/* REVISION: 1.0      LAST MODIFIED: 02/21/06   BY: Apple Tam *SS - 20060221*                  */
/* $Revision: 1.95.1.6 $    BY: Bill Jiang        DATE: 02/25/06  ECO: *SS - 20060225* */
/* $Revision: 1.95.1.6 $    BY: Micho Yang        DATE: 03/07/06  ECO: *SS - 20060307* */
/* $Revision: 1.95.1.6 $    BY: Bill Jiang        DATE: 03/11/06  ECO: *SS - 20060311* */
/* By: Neil Gao Date: 20070102 ECO: * ss 20070102.1 * */

define shared variable global_user_lang_dir like lng_mstr.lng_dir.
{gplabel.i}
{sssoivm1.i}
VIEW FRAME w.
VIEW FRAME match_maintenance .

DO:
   {windo1u.i
      tt1 
      "
      tt1_disp_id
      tt1_qty_inv
      "
      "tt1_disp_id"
      "use-index tt1_disp_id"     
      yes
      " "
      " "
      } 

   if keyfunction(lastkey) = "GO" then do:
      leave.
      ststatus = stline[2].
      status input ststatus.
   end.

/* ss 20070102.1 - b */
/*   
   {windo1u1.i tt1_id}
 */
   {windo1u1.i tt1_disp_id}
/* ss 20070102.1 - e */
END.
