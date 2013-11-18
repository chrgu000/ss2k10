/* SS - 090608.1 By: Bill Jiang */

{mfdeclre.i}

DEFINE INPUT PARAMETER fpos_glrd LIKE glrd_fpos.

FIND FIRST mfc_ctrl 
   WHERE mfc_domain = GLOBAL_domain 
   AND mfc_field = "SoftspeedIC_glr_code_ie"
   NO-LOCK NO-ERROR.
IF NOT AVAILABLE mfc_ctr THEN DO:
   /* Control table error.  Check applicable control tables */
   {pxmsg.i &MSGNUM=594 &ERRORLEVEL=3}

   RETURN "no".
END.

FIND FIRST glrd_det
   WHERE glrd_domain = GLOBAL_domain
   AND glrd_code = mfc_char
   AND glrd_fpos = fpos_glrd
   AND glrd_line = 0
   AND glrd_sums = 0
   NO-LOCK NO-ERROR.
IF NOT AVAILABLE glrd_det THEN DO:
   /* INVALID FORMAT POSITION */
   {pxmsg.i &MSGNUM=3012 &ERRORLEVEL=3}

   RETURN "no".
END.

RETURN "yes".

