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
/* $Revision: 1.11 $ BY: Bill Jiang DATE: 08/13/07 ECO: *SS - 090910.1* */
/*-Revision end---------------------------------------------------------------*/

/* SS - 090910.1 - B */
/*
本程序兼容以下浏览:
  gp072 - 标准的通用代码主记录
  gp972 - 兼容的通用代码主记录,字段"code_cmmt"的值根据字段"code_desc"的值自动更新
  gp973 - 兼容的通用代码主记录,引用的字段名可以与这里的字段名不一致
*/
/* SS - 090910.1 - E */
           
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
{mfdtitle.i "090910.1"}

define variable del-yn   like mfc_logical initial no.
/* SS - 090910.1 - B */
/*
define variable fldname  like code_fldname initial "txt_tax_type".
*/
define variable fldname  like code_fldname initial "CIM_Temporary_Directory".
/* SS - 090910.1 - E */

/* DISPLAY SELECTION FORM */
form
   code_value label "Tax Type" colon 25 format "x(32)"
   skip(1)
   code_desc                   colon 25
with frame a side-labels width 80  attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* SS - 090910.1 - B */
/*
/* VERIFY THE EXISTENCE OF NON-TAXABLE TAX TYPE */
do transaction:
   {txtxtmt.i}
end.
*/
/* SS - 090910.1 - E */

/* DISPLAY */

view frame a.

mainloop:
repeat with frame a:

	/* SS - 090910.1 - B */
   /* gp973.p支持 */
	GLOBAL_addr = fldname.
	/* SS - 090910.1 - E */

   prompt-for code_value with frame a
   editing:
      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp01.i code_mstr code_value code_value
         fldname  " code_fldname "
         code_fldval}
      if recno <> ? then
         display code_value code_desc.
   end.

   /* SS - 090910.1 - B */
   /*
   /* VALIDATE TAX TYPE NOT BLANK */
   if not input code_value > "" then do:
      /* Blank tax type not allowed */
      {pxmsg.i &MSGNUM=945 &ERRORLEVEL=3}
      undo mainloop, retry.
   end.
   */
   /* SS - 090910.1 - E */

   /* ADD/MOD/DELETE  */
   find code_mstr  where 
   code_fldname = fldname and
                        code_value = input code_value
   exclusive-lock no-error.

   if not available code_mstr then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create code_mstr. 
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

         /* SS - 090910.1 - B */
         /*
         /* VERIFY THAT NONE OF THE FOLLOWING EXISTS */
         /* TAX ENVIRONMENT DETAIL */
         find first txed_det  where 
         txed_tax_type = code_value no-error.
         if available(txed_det) then do:
            /* Tax type exists in tax environment.  Cannot delete */
            {pxmsg.i &MSGNUM=895 &ERRORLEVEL=4}
            undo mainloop, retry.
         end.

         /* TAX BASE MASTER */
         find first txbd_det  where 
         txbd_tax_type = code_value no-error.
         if available(txbd_det) then do:
            /* Tax type exists in tax base.  Cannot delete */
            {pxmsg.i &MSGNUM=894 &ERRORLEVEL=4}
            undo mainloop, retry.
         end.

         /* TAX MASTER */
         find first tx2_mstr  where 
         tx2_tax_type = code_value no-error.
         if available(tx2_mstr) then do:
            /* Tax type exists in tax master.  Cannot delete */
            {pxmsg.i &MSGNUM=896 &ERRORLEVEL=4}
            undo mainloop, retry.
         end.

         /* TRAILER DETAIL */
         find first trld_det  where 
         trld_tax_type = code_value no-error.
         if available(trld_det) then do:
            /* Tax type exists in trailer tax .  Cannot delete */
            {pxmsg.i &MSGNUM=897 &ERRORLEVEL=4}
            undo mainloop, retry.
         end.
         */
         /* SS - 090910.1 - E */

         delete code_mstr.
         clear frame a.
         next mainloop.

      end.

      /* SS - 090910.1 - B */
      /* gp972.p支持 */
      ASSIGN
         CODE_cmmt = CODE_desc
         .
      /* SS - 090910.1 - E */

   end.    /* seta: */

   release code_mstr.

end.    /* mainloop: */
