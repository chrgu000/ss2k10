
/*V8-*/
{mfdeclre.i}

/* EXTERNALIZED LABEL INCLUDE */
{gplabel.i}

{a6apvniq0102.i}

DEFINE INPUT PARAMETER vend LIKE ap_vend.
DEFINE INPUT PARAMETER vend1 LIKE ap_vend.
DEFINE INPUT PARAMETER effdate LIKE ap_effdate.
DEFINE INPUT PARAMETER effdate1 LIKE ap_effdate.
DEFINE INPUT PARAMETER base_rpt LIKE ap_curr.
define variable ap_due_date like ap_date no-undo.

FOR EACH ap_mstr NO-LOCK
   WHERE ap_vend >= vend
   AND ap_vend <= vend1
   AND ap_effdate >= effdate
   AND ap_effdate <= effdate1
   AND (ap_curr = base_rpt OR base_rpt = "")
   USE-INDEX ap_vend
   :

   IF ap_type = "RV" THEN NEXT.

   IF ap_type = "VO" THEN DO:
      FIND vo_mstr WHERE vo_ref = ap_ref AND (vo_curr = base_rpt OR base_rpt = "") NO-LOCK.
      IF NOT vo_confirmed THEN NEXT.
   END. /* IF ap_type = "VO" THEN DO: */

   CREATE tta6apvniq0102.
   ASSIGN
      tta6apvniq0102_ap_vend = ap_vend
      tta6apvniq0102_ap_effdate = ap_effdate
      tta6apvniq0102_ap_date = ap_date
      tta6apvniq0102_ap_ref = ap_ref
      tta6apvniq0102_ap_curr = ap_curr
      tta6apvniq0102_ap_amt = ap_amt
      tta6apvniq0102_ap_base_amt = ap_base_amt
      tta6apvniq0102_ap_acct = ap_acct
      tta6apvniq0102_ap_sub = ap_sub
      tta6apvniq0102_ap_cc = ap_cc
      .
   IF ap_type = "CK" AND ap__qad01 > "" THEN DO:
      ASSIGN
         tta6apvniq0102_ap_type = "D"
         .
   END.
   ELSE DO:
      ASSIGN
         tta6apvniq0102_ap_type = SUBSTRING(ap_type,1,1)
         .
   END.

   IF ap_type = "VO" THEN DO:
      ASSIGN
         tta6apvniq0102_vo_invoice = vo_invoice
         tta6apvniq0102_vo_due_date = vo_due_date
         .
   END.
   ELSE DO:
      IF ap_type = "CK" AND ap__qad01 > "" THEN DO:
         /* CONVERT CHARACTER DATE TO DATE FORMAT */
         {gprun.i ""gpchtodt.p""
            "(input  ap__qad01,
                    output ap_due_date)"}
      END.
         ASSIGN
            tta6apvniq0102_vo_due_date = ap_due_date
            .
   END.
END. /* FOR EACH ap_mstr NO-LOCK */
