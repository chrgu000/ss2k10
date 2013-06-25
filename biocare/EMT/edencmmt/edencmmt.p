/* txtxtmt.p - TAX TYPE MASTER MAINTENANCE                                    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.11 $                                                           */
/*V8:ConvertMode=Maintenance                                                  */
/* Revision: 7.3      CREATED:       10/08/92   By: bcm *G403*                */
/* Revision: 7.4     MODIFIED:       08/06/93   By: bcm *H058*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/*                                   10/12/93   By: bcm *H171*                */
/*                                   11/30/93   By: bcm *H253*                */
/*                                   02/23/95   By: jzw *H0BM*                */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.9  BY: Jean Miller DATE: 04/16/02 ECO: *P05H* */
/* $Revision: 1.11 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00M* */
/*-Revision end---------------------------------------------------------------*/
/* SS - 121211.1 By: Randy Li */
/* SS - 121211.1 RNB
【 121211.1 】
1.按会计单位设定产生EMT SO的客户代码。
【 121211.1 】
SS - 121211.1 - RNE */

           
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*!
    txtxtmt.p   Tax Type Maintenance
                (code_mstr where code_fldname = "txt_tax_type")
*/

/* DISPLAY TITLE */
/*
{mfdtitle.i "2+ "}
*/
{mfdtitle.i "121211.1" }

define variable del-yn   like mfc_logical initial no.

/* SS - 121211.1 - B */
/*
define variable fldname  like code_fldname initial "txt_tax_type".
*/
define variable fldname  like code_fldname initial "EN-CMMT".
/* SS - 121211.1 - E */

/* DISPLAY SELECTION FORM */
form
   code_value label "ENTITY" colon 25 format "x(8)"
   skip(1)
   code_desc     colon 25 format "x(8)"
with frame a side-labels width 80  attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */

view frame a.

mainloop:
repeat with frame a:

	/* SS - 121211.1 - B */
   /* gp973.p支持 */
	GLOBAL_addr = fldname.
	/* SS - 121211.1 - E */

   prompt-for code_value with frame a
   editing:
      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp01.i code_mstr code_value code_value
         fldname  " code_mstr.code_domain = global_domain and code_fldname "
         code_fldval}
      if recno <> ? then
         display code_value code_desc.
   end.


   /* VALIDATE USER NOT BLANK */
   if not input code_value > "" then do:
      /* 无效的会计单位 */
      {pxmsg.i &MSGNUM=3061 &ERRORLEVEL=3}
      undo mainloop, retry.
   end.
 	find first en_mstr where en_domain = global_domain and en_entity = input code_value no-lock no-error.
	if not avail en_mstr then do:
	/*无效的会计单位*/
      {pxmsg.i &MSGNUM=3061 &ERRORLEVEL=3}
      undo mainloop, retry.	
	end.
	
   /* ADD/MOD/DELETE  */
   find code_mstr  where code_mstr.code_domain = global_domain and
   code_fldname = fldname and
                        code_value = input code_value
   exclusive-lock no-error.

   if not available code_mstr then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create code_mstr. code_mstr.code_domain = global_domain.
      assign
         code_value.
        code_fldname = fldname.
   end.

   display code_value code_desc .   
   ststatus  =  stline[2].
   status input ststatus.
   del-yn = no.

   seta:
   do on error undo, retry:

      set code_desc go-on (F5 CTRL-D).

      /* DELETE */
      if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
      then do:

         del-yn = yes.
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         if del-yn = no then undo, retry.
         delete code_mstr.
         clear frame a.
         next mainloop.

      end.
	  /* SS - 121211.1 - B */
	  find first cm_mstr where cm_domain = global_domain and cm_addr = code_desc no-lock no-error.
	  	if not avail cm_mstr then do:
	/*无效客户*/
      {pxmsg.i &MSGNUM=8111 &ERRORLEVEL=3}
      undo seta, retry.	
	  end.
	  /* SS - 121211.1 - E */
	  
      /* SS - 121211.1 - B */
	  
      /* gp972.p支持 */
      ASSIGN
         CODE_cmmt = CODE_desc
         .
      /* SS - 121211.1 - E */

   end.    /* seta: */

   release code_mstr.

end.    /* mainloop: */
