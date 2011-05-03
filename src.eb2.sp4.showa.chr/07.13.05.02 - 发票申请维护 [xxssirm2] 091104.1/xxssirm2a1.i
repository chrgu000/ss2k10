/* 下一个发票备注 */
FIND FIRST mfc_ctrl 
   WHERE /* mfc_domain = GLOBAL_domain
   AND */ mfc_field = 'SoftspeedIR_VAT'
   EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE mfc_ctrl THEN DO:
   /* Control table error.  Check applicable control tables */
   {pxmsg.i &MSGNUM=594 &ERRORLEVEL=3}
   RETURN.
END.
ELSE DO:
   SoftspeedIR_VAT = mfc_integer.
   mfc_integer = mfc_integer + 1.
END.
RELEASE mfc_ctrl.
