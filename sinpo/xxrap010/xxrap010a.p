/*V8:ConvertMode=Report                                                      */

{mfdeclre.i}
/* {gplabel.i} */
{xxrap010a.i}

DEFINE INPUT PARAMETER vend LIKE ap_vend.
DEFINE INPUT PARAMETER vend1 LIKE ap_vend.
DEFINE INPUT PARAMETER effdate LIKE ap_effdate.
DEFINE INPUT PARAMETER effdate1 LIKE ap_effdate.
DEFINE INPUT PARAMETER base_rpt LIKE ap_curr.

define variable cknbr as character no-undo.

FOR EACH ap_mstr NO-LOCK
   WHERE ap_vend >= vend
   AND ap_vend <= vend1
   AND ap_effdate >= effdate
   AND ap_effdate <= effdate1
   AND (ap_curr = base_rpt OR base_rpt = "")
   USE-INDEX ap_vend:

   IF ap_type = "RV" THEN NEXT.

   IF ap_type = "VO" THEN DO:
      FIND vo_mstr WHERE vo_ref = ap_ref AND
          (vo_curr = base_rpt OR base_rpt = "") NO-LOCK.
      IF NOT vo_confirmed THEN NEXT.
   END. /* IF ap_type = "VO" THEN DO: */

   CREATE tmpap.
   ASSIGN
      ta_ap_vend = ap_vend
      ta_ap_effdate = ap_effdate
      ta_ap_date = ap_date
      ta_ap_ref = ap_ref
      ta_ap_curr = ap_curr
      ta_ap_amt = ap_amt
      ta_ap_base_amt = ap_base_amt
      ta_ap_acct = ap_acct
      ta_ap_sub = ap_sub
      ta_ap_cc = ap_cc
      .
   IF ap_type = "CK" AND ap__qad01 > "" THEN DO:
      ASSIGN
         ta_ap_type = "D"
         .
   END.
   ELSE DO:
      ASSIGN
         ta_ap_type = SUBSTRING(ap_type,1,1)
         .
   END.
	 assign cknbr = "".
   IF ap_type = "VO" THEN DO:
      ASSIGN
         ta_vo_invoice = vo_invoice
         ta_vo_due_date = vo_due_date
         ta_vo_type = vo_type
         .
     for each ckd_det where ckd_domain = global_domain and
                            ckd_voucher = ap_ref:
         for each ck_mstr where ck_domain = global_domain and
                                     ck_ref = ckd_ref:
             if ck_status <> "Void" then do:
                if cknbr = "" then assign cknbr = ckd_ref.
                							else assign cknbr = cknbr + ";" + ckd_ref.
        	   end.
       	end.
     end.
     assign ta_ck_nbr = cknbr.
   END.
   ELSE DO:
         ASSIGN ta_vo_due_date = ap_date.
   END.
END. /* FOR EACH ap_mstr NO-LOCK */
