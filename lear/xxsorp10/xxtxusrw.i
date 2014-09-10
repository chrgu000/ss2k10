
/*roger*/

/*roger update usrw_wkfl*/
 for each tx2d_det where tx2d_domain = global_domain
                   and tx2d_det.tx2d_ref = so_nbr
                   and tx2d_det.tx2d_nbr = ""
                   and tx2d_det.tx2d_tr_type = "13":
     IF tx2d_det.tx2d_line = 0 THEN
         ASSIGN
            tx2d_det.tx2d_abs_ret_amt = 0
            tx2d_det.tx2d_cur_abs_ret_amt = 0
            tx2d_det.tx2d_cur_nontax_amt = 0
            tx2d_det.tx2d_cur_recov_amt = 0
            tx2d_det.tx2d_cur_tax_amt = 0
            tx2d_det.tx2d_ent_abs_ret_amt = 0
            tx2d_det.tx2d_ent_nontax_amt = 0
            tx2d_det.tx2d_ent_recov_amt = 0
            tx2d_det.tx2d_ent_tax_amt = 0
            tx2d_det.tx2d_nontax_amt = 0
            tx2d_det.tx2d_recov_amt = 0
            tx2d_det.tx2d_taxable_amt = 0
            tx2d_det.tx2d_tax_amt = 0
            tx2d_det.tx2d_totamt = 0
            tx2d_det.tx2d_tottax = 0.

         FIND FIRST usrw_wkfl WHERE usrw_domain = global_domain and usrw_key1 = "so-tx2ddet"
             AND usrw_key3 = so_nbr AND usrw_key4 = string(tx2d_line) USE-INDEX usrw_index2 NO-ERROR.
         IF NOT AVAIL usrw_wkfl THEN DO:
             CREATE usrw_wkfl. usrw_domain = global_domain.
             ASSIGN
                 usrw_key1 = "so-tx2ddet"
                 usrw_key2 = tx2d_det.tx2d_ref + "/" + tx2d_det.tx2d_nbr + "/" +
                 string(tx2d_det.tx2d_line) + "/" + tx2d_det.tx2d_trl + "/" + tx2d_det.tx2d_tr_type
                 + "/" + tx2d_det.tx2d_tax_code
                 usrw_key3 = so_nbr
                 usrw_key4 = string(tx2d_det.tx2d_line)
                 usrw_key5 = ""
                 usrw_charfld[1] = tx2d_det.tx2d_carrier
                 usrw_charfld[2] = tx2d_det.tx2d_curr
                 usrw_charfld[3] = tx2d_det.tx2d_line_site_ent
                /*usrw_charfld[4] = tx2d_det.tx2d_nbr*/
                /*usrw_charfld[5] = tx2d_det.tx2d_ref*/
                 usrw_charfld[6] = tx2d_det.tx2d_taxc
                 usrw_charfld[7] = tx2d_det.tx2d_tax_code
                 usrw_charfld[8] = tx2d_det.tx2d_tax_env
                 usrw_charfld[9] = tx2d_det.tx2d_tax_type
                 usrw_charfld[10] = tx2d_det.tx2d_tax_usage
                 usrw_charfld[11] = tx2d_det.tx2d_trans_ent
                 usrw_charfld[12] = tx2d_det.tx2d_trl
                 usrw_charfld[13] = tx2d_det.tx2d_tr_type
                 usrw_charfld[14] = tx2d_det.tx2d_user1
                 usrw_charfld[15] = tx2d_det.tx2d_user2
                 usrw_charfld[4] = tx2d_det.tx2d_zone_from
                 usrw_charfld[5] = tx2d_det.tx2d_zone_to

                 usrw_logfld[1] = tx2d_det.tx2d_by_line
                 usrw_logfld[2] = tx2d_det.tx2d_edited
                 usrw_logfld[3] = tx2d_det.tx2d_rcpt_tax_point
                 usrw_logfld[4] = tx2d_det.tx2d_tax_in
                 usrw_logfld[5] = tx2d_det.tx2d_usage_tax_point

                 usrw_intfld[1] = tx2d_det.tx2d_line.
        END. /*if not avail usrw_wkfl*/
        ASSIGN
            usrw_decfld[1] = usrw_decfld[1] + tx2d_det.tx2d_abs_ret_amt
            usrw_decfld[2] = usrw_decfld[2] + tx2d_det.tx2d_cur_abs_ret_amt
            usrw_decfld[3] = usrw_decfld[3] + tx2d_det.tx2d_cur_nontax_amt
            usrw_decfld[4] = usrw_decfld[4] + tx2d_det.tx2d_cur_recov_amt
            usrw_decfld[5] = usrw_decfld[5] + tx2d_det.tx2d_cur_tax_amt
            usrw_decfld[6] = usrw_decfld[6] + tx2d_det.tx2d_ent_abs_ret_amt
            usrw_decfld[7] = usrw_decfld[7] + tx2d_det.tx2d_ent_nontax_amt
            usrw_decfld[8] = usrw_decfld[8] + tx2d_det.tx2d_ent_recov_amt
            usrw_decfld[9] = usrw_decfld[9] + tx2d_det.tx2d_ent_tax_amt
            usrw_decfld[10] = usrw_decfld[10] + tx2d_det.tx2d_nontax_amt
            usrw_decfld[11] = usrw_decfld[11] + tx2d_det.tx2d_recov_amt
            usrw_decfld[12] = usrw_decfld[12] + tx2d_det.tx2d_taxable_amt
            usrw_decfld[13] = usrw_decfld[13] + tx2d_det.tx2d_tax_amt
            usrw_decfld[14] = usrw_decfld[14] + tx2d_det.tx2d_totamt
            usrw_decfld[15] = usrw_decfld[15] + tx2d_det.tx2d_tottax.
        DELETE tx2d_det.
 END. /*for each tx2d_det*/
 /*roger update usrw_wkfl*/

 /*roger update tx2d_det*/
 ASSIGN vap-amt = 0.
 for each sod_det where sod_domain = global_domain and sod_nbr = so_nbr
                  and (/*roger*/ (sod_qty_inv + sod__dec01) <> 0 or not inv_only)
/*roger*/          AND ((np_fp = YES AND sod_user1 = "NP") OR (np_fp = NO AND sod_user1 = "FP"))
:
     FIND FIRST usrw_wkfl WHERE usrw_domain = global_domain and usrw_key1 = "so-tx2ddet"
             AND usrw_key3 = so_nbr AND usrw_key4 = string(sod_line) USE-INDEX usrw_index2 NO-ERROR.
     IF AVAIL usrw_wkfl THEN DO:
         ASSIGN vap-amt = vap-amt + usrw_decfld[14].
         CREATE tx2d_det. tx2d_domain = global_domain.
         ASSIGN
             tx2d_det.tx2d_carrier = usrw_charfld[1]
             tx2d_det.tx2d_curr = usrw_charfld[2]
             tx2d_det.tx2d_line_site_ent = usrw_charfld[3]
             tx2d_det.tx2d_nbr = usrw_key5
             tx2d_det.tx2d_ref = usrw_key3
             tx2d_det.tx2d_taxc = usrw_charfld[6]
             tx2d_det.tx2d_tax_code = usrw_charfld[7]
             tx2d_det.tx2d_tax_env = usrw_charfld[8]
             tx2d_det.tx2d_tax_type = usrw_charfld[9]
             tx2d_det.tx2d_tax_usage = usrw_charfld[10]
             tx2d_det.tx2d_trans_ent = usrw_charfld[11]
             tx2d_det.tx2d_trl = usrw_charfld[12]
             tx2d_det.tx2d_tr_type = usrw_charfld[13]
             tx2d_det.tx2d_user1 = usrw_charfld[14]
             tx2d_det.tx2d_user2 = usrw_charfld[15]
             tx2d_det.tx2d_zone_from = usrw_charfld[4]
             tx2d_det.tx2d_zone_to = usrw_charfld[5]

             tx2d_det.tx2d_line = usrw_intfld[1]

             tx2d_det.tx2d_by_line = usrw_logfld[1]
             tx2d_det.tx2d_edited = usrw_logfld[2]
             tx2d_det.tx2d_rcpt_tax_point = usrw_logfld[3]
             tx2d_det.tx2d_tax_in = usrw_logfld[4]
             tx2d_det.tx2d_usage_tax_point = usrw_logfld[5].
          ASSIGN
             tx2d_det.tx2d_abs_ret_amt = usrw_decfld[1]
             tx2d_det.tx2d_cur_abs_ret_amt = usrw_decfld[2]
             tx2d_det.tx2d_cur_nontax_amt = usrw_decfld[3]
             tx2d_det.tx2d_cur_recov_amt = usrw_decfld[4]
             tx2d_det.tx2d_cur_tax_amt = usrw_decfld[5]
             tx2d_det.tx2d_ent_abs_ret_amt = usrw_decfld[6]
             tx2d_det.tx2d_ent_nontax_amt = usrw_decfld[7]
             tx2d_det.tx2d_ent_recov_amt = usrw_decfld[8]
             tx2d_det.tx2d_ent_tax_amt = usrw_decfld[9]
             tx2d_det.tx2d_nontax_amt = usrw_decfld[10]
             tx2d_det.tx2d_recov_amt = usrw_decfld[11]
             tx2d_det.tx2d_taxable_amt = usrw_decfld[12]
             tx2d_det.tx2d_tax_amt = usrw_decfld[13]
             tx2d_det.tx2d_totamt = usrw_decfld[14]
            tx2d_det.tx2d_tottax = usrw_decfld[15].
        DELETE usrw_wkfl.
     END.
 END.

 FIND FIRST tx2d_det where tx2d_domain = global_domain and tx2d_det.tx2d_ref = so_nbr
                   and tx2d_det.tx2d_nbr = ""
                   and tx2d_det.tx2d_tr_type = "13"
                   AND tx2d_det.tx2d_line = 0 NO-ERROR.
 IF NOT AVAIL tx2d_det THEN DO:
     FIND FIRST usrw_wkfl WHERE usrw_domain = global_domain and usrw_key1 = "so-tx2ddet"
         AND usrw_key3 = so_nbr AND usrw_key4 = "0" USE-INDEX usrw_index2 NO-ERROR.
     CREATE tx2d_det. tx2d_domain = global_domain.
         ASSIGN
             tx2d_det.tx2d_carrier = usrw_charfld[1]
             tx2d_det.tx2d_curr = usrw_charfld[2]
             tx2d_det.tx2d_line_site_ent = usrw_charfld[3]
             tx2d_det.tx2d_nbr = usrw_key5
             tx2d_det.tx2d_ref = usrw_key3
             tx2d_det.tx2d_taxc = usrw_charfld[6]
             tx2d_det.tx2d_tax_code = usrw_charfld[7]
             tx2d_det.tx2d_tax_env = usrw_charfld[8]
             tx2d_det.tx2d_tax_type = usrw_charfld[9]
             tx2d_det.tx2d_tax_usage = usrw_charfld[10]
             tx2d_det.tx2d_trans_ent = usrw_charfld[11]
             tx2d_det.tx2d_trl = usrw_charfld[12]
             tx2d_det.tx2d_tr_type = usrw_charfld[13]
             tx2d_det.tx2d_user1 = usrw_charfld[14]
             tx2d_det.tx2d_user2 = usrw_charfld[15]
             tx2d_det.tx2d_zone_from = usrw_charfld[4]
             tx2d_det.tx2d_zone_to = usrw_charfld[5]
             tx2d_det.tx2d_line = usrw_intfld[1]
             tx2d_det.tx2d_by_line = usrw_logfld[1]
             tx2d_det.tx2d_edited = usrw_logfld[2]
             tx2d_det.tx2d_rcpt_tax_point = usrw_logfld[3]
             tx2d_det.tx2d_tax_in = usrw_logfld[4]
             tx2d_det.tx2d_usage_tax_point = usrw_logfld[5].
 END.
 ASSIGN
 tx2d_det.tx2d_taxable_amt = vap-amt
 tx2d_det.tx2d_totamt = vap-amt
 tx2d_det.tx2d_tottax = vap-amt.

 /*roger update tx2d_det*/
