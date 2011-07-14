/* for each lad_det no-lock where  lad_dataset = "rps_det":              */
/*     display lad_part lad_lot lad_ref lad__qadc01 lad_user1 lad_user2. */
/* end.                                                                  */


/*load xxwk_det data.*/
DEFINE VARIABLE i AS INTEGER.
ASSIGN i = 1.
FOR EACH rps_mstr NO-LOCK WHERE rps_due_date = TODAY:
    CREATE xxwk_det.
    ASSIGN xxwk_date = rps_due_date
           xxwk_sn = i
           xxwk_part= rps_part
           xxwk_site = rps_site
           xxwk_line = rps_line
           xxwk_qty = rps_qty_req.
    i = i + 1.
END.
/*                                            */
/*  FOR EACH xxwk_det EXCLUSIVE-LOCK WHERE  : */
/*      display xxwk_det.                     */
/*      update .                              */
/*  END.                                      */
