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
/* SS - YYMMDD.1 By: Randy Li */
/* SS - YYMMDD.1 RNB
�� YYMMDD.1 ��
1.ά���ɹ������û����޸Ķ�����Χ���ɹ�ά���û���Χ����
�� YYMMDD.1 ��
SS - YYMMDD.1 - RNE */

           
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
{mfdtitle.i "121206.1" }

define variable del-yn   like mfc_logical initial no.
define variable i   as INTEGER .
/* ss - 121206.2 -b */
define var j as INTEGER .
/* ss - 121206.2 -e */
/* SS - 121206.1 - B */
/*
define variable fldname  like code_fldname initial "txt_tax_type".
*/
define variable fldname  like code_fldname initial "PO-Jurisdiction".
/* SS - 121206.1 - E */

/* DISPLAY SELECTION FORM */
form
   code_value label "USER" colon 25 format "x(8)"
   skip(1)
   code_desc   label  "USER-USER"       colon 25 format "x(40)"
with frame a side-labels width 80  attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */

view frame a.

mainloop:
repeat with frame a:

	/* SS - 121206.1 - B */
   /* gp973.p֧�� */
	GLOBAL_addr = fldname.
	/* SS - 121206.1 - E */

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
      /* �û���־����Ϊ�� */
      {pxmsg.i &MSGNUM=6074 &ERRORLEVEL=3}
      undo mainloop, retry.
   end.
 	find first usr_mstr where usr_userid = input code_value no-lock no-error.
	if not avail usr_mstr then do:
      {pxmsg.i &MSGNUM=6069 &ERRORLEVEL=3}
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

   display code_value code_desc.   
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
/* ss - 121206.2 -b */
 j = NUM-ENTRIES(CODE_desc,",") .
	do i = 1 to j :
		/* ss - 121206.2 -e */
	find first usr_mstr where usr_userid = entry(i,code_desc,",")no-lock no-error.
		if not avail usr_mstr then do:
	      {pxmsg.i &MSGNUM=6069 &ERRORLEVEL=3}
	      undo seta, retry.	
		end.
	end.   

	  
      /* SS - 121206.1 - B */
      /* gp972.p֧�� */
      ASSIGN
         CODE_cmmt = CODE_desc
         .
      /* SS - 121206.1 - E */

   end.    /* seta: */

   release code_mstr.

end.    /* mainloop: */