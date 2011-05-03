/* SS - 090906.1 By: Bill Jiang */
/* SS - 090922.1 By: Neil Gao */

/*
修改默认值为NO
*/

{mfdeclre.i}

DEFINE INPUT PARAMETER vend AS CHARACTER.
DEFINE OUTPUT PARAMETER sync AS LOGICAL.

FIND FIRST mfc_ctrl
   WHERE mfc_field = "SoftspeedSCM_VP_Part_Sync"
   NO-LOCK NO-ERROR.
IF NOT AVAILABLE mfc_ctrl THEN DO:
   create mfc_ctrl.
   assign
      mfc_field   = "SoftspeedSCM_VP_Part_Sync"
      mfc_type    = "C"
      mfc_module  = "SoftspeedSCM_VP_Part_Sync"
      mfc_seq     = 10
      mfc_char = "SoftspeedSCM.Sync"
      .
END.

FOR EACH vp_mstr NO-LOCK
   WHERE vp_part = mfc_char
   AND (vp_vend = vend OR vp_vend = "")
   AND (vp_vend_part = execname OR vp_vend_part = "")
   BY vp_vend
   BY vp_vend_part
   :
   sync = vp_tp_use_pct.

   IF vp_tp_use_pct = NO OR vp_ins_rqd = YES THEN DO:
      RETURN.
   END.

   {gprun.i ""xxsccomGetSyncOptionPopup.p"" "(
      INPUT-OUTPUT sync
      )"}

   RETURN.
END.

/* SS 090922.1 - B */
/*
sync = YES.
*/
/* SS 090922.1 - E */
