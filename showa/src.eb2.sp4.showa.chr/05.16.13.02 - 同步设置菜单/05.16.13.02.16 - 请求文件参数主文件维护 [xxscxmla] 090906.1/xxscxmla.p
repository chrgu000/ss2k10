/* SS - 090906.1 By: Bill Jiang */

/* SS - 090906.1 - RNB
[090906.1]

�����ļ��������ļ�ά��

����������������:
  - gp072: ��׼��ͨ�ô�������¼
  - gp972: ���ݵ�ͨ�ô�������¼,�ֶ�"code_cmmt"��ֵ�����ֶ�"code_desc"��ֵ�Զ�����
  - gp973: ���ݵ�ͨ�ô�������¼,���õ��ֶ���������������ֶ�����һ��

[090906.1]
  
SS - 090906.1 - RNE */

/* DISPLAY TITLE */
{mfdtitle.i "090906.1"}

define variable del-yn   like mfc_logical initial no.
/* SS - 090906.1 - B */
/* TODO: �ֶ��� */
define variable fldname  like code_fldname initial "SoftspeedSCM.XML".
/* SS - 090906.1 - E */

/* DISPLAY SELECTION FORM */
form
   code_value label "Tax Type" colon 25 
   /* SS - 090906.1 - B
   /* TODO: ��ʽ�� */
   format "x(1)"
   SS - 090906.1 - E */
   skip(1)
   /* SS - 090906.1 - B */
   code_cmmt                   colon 25
   /* SS - 090906.1 - E */
   code_desc                   colon 25
   /* SS - 090906.1 - B
   /* TODO: ��ʽ�� */
   FORMAT "x(1)"
   SS - 090906.1 - E */
with frame a side-labels width 80  attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */

view frame a.

mainloop:
repeat with frame a:

	/* SS - 090906.1 - B */
   /* gp973.p֧�� */
	GLOBAL_addr = fldname.
	/* SS - 090906.1 - E */

   prompt-for code_value with frame a
   editing:
      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp01.i code_mstr code_value code_value
         fldname  " code_fldname "
         code_fldval}
      if recno <> ? then
         display 
         code_value 
         /* SS - 090906.1 - B */
         CODE_cmmt
         /* SS - 090906.1 - E */
         code_desc
         .
   end.

   /* SS - 090906.1 - B
   /* TODO: ��֤ */
   FIND FIRST pt_mstr
      WHERE pt_part = INPUT CODE_value
      NO-LOCK NO-ERROR.
   IF NOT AVAILABLE pt_mstr THEN DO:
      /* Invalid entry */
      {pxmsg.i &MSGNUM=4509 &ERRORLEVEL=3}
      undo mainloop, retry.
   END.
   SS - 090906.1 - E */

   /* ADD/MOD/DELETE  */
   find code_mstr  where code_fldname = fldname and
                        code_value = input code_value
   exclusive-lock no-error.

   if not available code_mstr then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create code_mstr. 
      assign
         code_value.
      code_fldname = fldname.
   end.

   /* SS - 090906.1 - B
   IF code_cmmt <> "" AND CODE_desc = "" THEN DO:
      ASSIGN
         CODE_desc = CODE_cmmt.
         .
   END.
   SS - 090906.1 - E */

   display 
      code_value 
      /* SS - 090906.1 - B */
      code_cmmt 
      /* SS - 090906.1 - E */
      code_desc
      .

   ststatus  =  stline[2].
   status input ststatus.
   del-yn = no.

   seta:
   do on error undo, retry:

      /* SS - 090906.1 - B
      /* TODO: Ĭ��ֵ */
      IF CODE_desc = "" THEN DO:
         ASSIGN
            CODE_desc = "T"
            .
         DISPLAY
            CODE_desc
            .
      END.
      SS - 090906.1 - E */

      set
         /* SS - 090906.1 - B */
         CODE_cmmt
         /* SS - 090906.1 - E */
         code_desc 
         go-on (F5 CTRL-D).

      /* SS - 090906.1 - B
      /* TODO: ��֤ */
      IF INDEX("T,;",CODE_desc) = 0 THEN DO:
         /* Invalid entry */
         {pxmsg.i &MSGNUM=4509 &ERRORLEVEL=3}
         UNDO,RETRY.
      END.
      SS - 090906.1 - E */

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

      /* SS - 090906.1 - B
      /* gp972.p֧�� */
      ASSIGN
         CODE_cmmt = CODE_desc
         .
      SS - 090906.1 - E */

   end.    /* seta: */

   release code_mstr.

end.    /* mainloop: */
