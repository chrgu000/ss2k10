/*   ·¢Æ±ÊıÁ¿Îª?µÄĞŞÕı                                                       */
/*   1. ÎÊÓÃ»§ÕıÈ·µÄ¿ª·¢Æ±ÊıÁ¿ĞŞ¸Äidh_qty_inv      36.25.5(¿Í»§Óà¶îµ÷Õû)     */



ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
?     »á¼Æµ¥Î»:                           ÖÁ:                             ?
?         ÏúÍù: 010001                        ÖÁ: 010001                      ?
?         ÕÊ»§: 11310100                      ÖÁ: 11310100                    ?
?       ·ÖÕÊ»§:                               ÖÁ:                             ?
?     ³É±¾ÖĞĞÄ:                               ÖÁ:                             ?
?     ÉúĞ§ÈÕÆÚ: 13/11/01                      ÖÁ: 13/12/30                    ?
?         »õ±Ò:                                                               ?
?     ±¨¸æ»õ±Ò: CNY                                                           ?
?                                                                             ?
?                                                              Êä³ö: PAGE1000 ?
?                                                        Åú´¦Àí±êÖ¾:          ?
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ




{mfdeclre.i}
for each idh_hist exclusive-lock where idh_domain = global_domain and
idh_inv_nbr = '06760449' and idh_nbr = "01200024" and idh_line = 151:
display idh_hist with 2 columns.
color display  input idh_qty_inv.
assign idh_qty_inv = 5475.
end.

for each glt_det no-lock where glt_domain = global_domain and glt_doc = '06760449'
and glt_curr_amt = ?
display glt_det with 2 columns.
end.

for each ard_det no-lock where ard_domain = global_domain and ard_nbr = '06760449':
display ard_det.
end.

for each ard_det no-lock where ard_domain = global_domain and ard_nbr = '06760449':
display ard_det with 2 columns.
color display message  ard_nbr ard_amt ard_cur_amt .
end.

for each ar_mstr exclusive-lock where ar_domain = global_domain and
ar_nbr = "06760449":
assign ar_amt  = 2395409.58 + 407219.64
 ar_base_amt = 2395409.58 + 407219.64.
end.

/*
×ÜË°½ğ  407219.64.
*/
/*
/*   /app/TMP/addar.i.    */

{mfdeclre.i} 
/* {gprun.i  ""arcsrp05.p""}       */
/* {gprun.i  ""ardriq.p""}         */
define buffer ar  for   ar_mstr.
define buffer ard for ard_det.
find first ard_det exclusive-lock where ard_domain = global_domain
           and ard_nbr = "06760449"
           and ard_acct = "21710111"   no-error.
           if available ard_det then do:
              delete ard_det.
           end.
for first ard_det no-lock where ard_domain = global_domain
      and ard_nbr = "06760404"
      and ard_acct = "21710111" :
      create ard.
      assign ard.ard_nbr           = "06760449"
             ard.ard_acct          = ard_det.ard_acct
             ard.ard_cc            = ard_det.ard_cc
             ard.ard_amt           = 407219.64
             ard.ard_desc          = ard_det.ard_desc
             ard.ard_ref           = ard_det.ard_ref
             ard.ard_disc          = ard_det.ard_disc
             ard.ard_type          = ard_det.ard_type
             ard.ard_user1         = ard_det.ard_user1
             ard.ard_user2         = ard_det.ard_user2
             ard.ard_tax           = ard_det.ard_tax
             ard.ard_tax_at        = ard_det.ard_tax_at
             ard.ard_entity        = ard_det.ard_entity
             ard.ard__qad02        = ard_det.ard__qad02
             ard.ard__qad01        = ard_det.ard__qad01
             ard.ard_project       = ard_det.ard_project
             ard.ard_cur_amt       = 407219.64
             ard.ard_cur_disc      = ard_det.ard_cur_disc
             ard.ard_ex_rate       = ard_det.ard_ex_rate
             ard.ard_tax_usage     = ard_det.ard_tax_usage
             ard.ard_taxc          = ard_det.ard_taxc
             ard.ard_dy_code       = ard_det.ard_dy_code
             ard.ard_dy_num        = ard_det.ard_dy_num
             ard.ard_ex_rate2      = ard_det.ard_ex_rate2
             ard.ard_ex_ratetype   = ard_det.ard_ex_ratetype
             ard.ard_ded_nbr       = ard_det.ard_ded_nbr
             ard.ard_exru_seq      = ard_det.ard_exru_seq
             ard.ard_sub           = ard_det.ard_sub
             ard.ard_domain        = ard_det.ard_domain.
end.


find first ar_mstr exclusive-lock where ar_domain = global_domain
       and ar_nbr = "06760449" and ar_batch = "14648" no-error.
if available ar_mstr then do:
   delete ar_mstr.
end.
for each ar_mstr no-lock where ar_domain = global_domain and ar_nbr = "06760404":
    create ar.
     assign  ar.ar_type            = ar_mstr.ar_type
         ar.ar_nbr                 = "06760449"
         ar.ar_cust                = ar_mstr.ar_cust
         ar.ar_so_nbr              = "01200024"
         ar.ar_xcomm_pct[1]        = ar_mstr.ar_xcomm_pct[1]
         ar.ar_xcomm_pct[2]        = ar_mstr.ar_xcomm_pct[2]
         ar.ar_effdate             = date(11,29,2013)
         ar.ar_date                = date(11,29,2013)
         ar.ar_cr_terms            = ar_mstr.ar_cr_terms
         ar.ar_po                  = ar_mstr.ar_po
         ar.ar_amt                 = 2395409.58 + 407219.64
         ar.ar_applied             = 0
         ar.ar_disc_date           = ar_mstr.ar_disc_date
         ar.ar_due_date            = ar_mstr.ar_due_date
         ar.ar_expt_date           = ar_mstr.ar_expt_date
         ar.ar_acct                = ar_mstr.ar_acct
         ar.ar_cc                  = ar_mstr.ar_cc
         ar.ar_sales_amt           = 0
         ar.ar_xslspsn1            = ar_mstr.ar_xslspsn1
         ar.ar_xslspsn2            = ar_mstr.ar_xslspsn2
         ar.ar_paid_date           = ar_mstr.ar_paid_date
         ar.ar_batch               = "14648" .
 assign  ar.ar_disc_acct           = ar_mstr.ar_disc_acct
         ar.ar_disc_cc             = ar_mstr.ar_disc_cc
         ar.ar_ship                = ar_mstr.ar_ship
         ar.ar_open                = ar_mstr.ar_open
         ar.ar_contested           = ar_mstr.ar_contested
         ar.ar_check               = ar_mstr.ar_check
         ar.ar_cmtindx             = ar_mstr.ar_cmtindx
         ar.ar_user1               = ar_mstr.ar_user1
         ar.ar_user2               = ar_mstr.ar_user2
         ar.ar_curr                = ar_mstr.ar_curr
         ar.ar_ex_rate             = ar_mstr.ar_ex_rate
         ar.ar_var_acct            = ar_mstr.ar_var_acct
         ar.ar_var_cc              = ar_mstr.ar_var_cc
         ar.ar_bank                = ar_mstr.ar_bank
         ar.ar_mrgn_amt            = 0
         ar.ar_entity              = ar_mstr.ar_entity
         ar.ar_ent_ex              = ar_mstr.ar_ent_ex
         ar.ar__chr01              = ar_mstr.ar__chr01
         ar.ar__chr02              = ar_mstr.ar__chr02
         ar.ar__chr03              = ar_mstr.ar__chr03
         ar.ar__chr04              = ar_mstr.ar__chr04
         ar.ar__chr05              = ar_mstr.ar__chr05
         ar.ar__dte01              = ar_mstr.ar__dte01
         ar.ar__dte02              = ar_mstr.ar__dte02
         ar.ar__dec01              = ar_mstr.ar__dec01
         ar.ar__dec02              = ar_mstr.ar__dec02
         ar.ar__log01              = ar_mstr.ar__log01
         ar.ar_draft               = ar_mstr.ar_draft
         ar.ar_ldue_date           = ar_mstr.ar_ldue_date
         ar.ar_print               = ar_mstr.ar_print
         ar.ar_inv_cr              = ar_mstr.ar_inv_cr
         ar.ar_fr_terms            = ar_mstr.ar_fr_terms
         ar.ar_comm_pct[1]         = ar_mstr.ar_comm_pct[1]
         ar.ar_comm_pct[2]         = ar_mstr.ar_comm_pct[2]
         ar.ar_comm_pct[3]         = ar_mstr.ar_comm_pct[3]
         ar.ar_comm_pct[4]         = ar_mstr.ar_comm_pct[4]
         ar.ar_slspsn[1]           = ar_mstr.ar_slspsn[1]
         ar.ar_slspsn[2]           = ar_mstr.ar_slspsn[2]
         ar.ar_slspsn[3]           = ar_mstr.ar_slspsn[3]
         ar.ar_slspsn[4]           = ar_mstr.ar_slspsn[4]
         ar.ar_bill                = ar_mstr.ar_bill
         ar.ar_tax_date            = date(11,29,2013).
assign   ar.ar_tax_env             = ar_mstr.ar_tax_env
         ar.ar__qad01              = ar_mstr.ar__qad01
         ar.ar__qad02              = ar_mstr.ar__qad02
         ar.ar__qad03              = ar_mstr.ar__qad03
         ar.ar_drft_sel            = ar_mstr.ar_drft_sel
         ar.ar_coll_mthd           = ar_mstr.ar_coll_mthd
         ar.ar_amt_chg             = ar_mstr.ar_amt_chg
         ar.ar_disc_chg            = ar_mstr.ar_disc_chg
         ar.ar_base_amt            = 2395409.58 + 407219.64
         ar.ar_fsm_type            = ar_mstr.ar_fsm_type
         ar.ar_comm_amt[1]         = ar_mstr.ar_comm_amt[1]
         ar.ar_comm_amt[2]         = ar_mstr.ar_comm_amt[2]
         ar.ar_comm_amt[3]         = ar_mstr.ar_comm_amt[3]
         ar.ar_comm_amt[4]         = ar_mstr.ar_comm_amt[4]
         ar.ar_dy_code             = ar_mstr.ar_dy_code
         ar.ar_dun_level           = ar_mstr.ar_dun_level
         ar.ar_ex_rate2            = ar_mstr.ar_ex_rate2
         ar.ar_ex_ratetype         = ar_mstr.ar_ex_ratetype
         ar.ar_base_amt_chg        = ar_mstr.ar_base_amt_chg
         ar.ar_base_applied        = ar_mstr.ar_base_applied
         ar.ar_base_comm_amt[1]    = ar_mstr.ar_base_comm_amt[1]
         ar.ar_base_comm_amt[2]    = ar_mstr.ar_base_comm_amt[2]
         ar.ar_base_comm_amt[3]    = ar_mstr.ar_base_comm_amt[3]
         ar.ar_base_comm_amt[4]    = ar_mstr.ar_base_comm_amt[4]
         ar.ar_exru_seq            = ar_mstr.ar_exru_seq
         ar.ar_dd_curr             = ar_mstr.ar_dd_curr
         ar.ar_dd_ex_rate          = ar_mstr.ar_dd_ex_rate
         ar.ar_dd_ex_rate2         = ar_mstr.ar_dd_ex_rate2
         ar.ar_dd_exru_seq         = ar_mstr.ar_dd_exru_seq
         ar.ar_app_owner            = ar_mstr.ar_app_owner
         ar.ar_sub                 = ar_mstr.ar_sub
         ar.ar_disc_sub            = ar_mstr.ar_disc_sub
         ar.ar_var_sub             = ar_mstr.ar_var_sub
         ar.ar_prepayment          = ar_mstr.ar_prepayment
         ar.ar_shipfrom            = ar_mstr.ar_shipfrom
         ar.ar_customer_bank       = ar_mstr.ar_customer_bank
         ar.ar_draft_disc_date     = ar_mstr.ar_draft_disc_date
         ar.ar_recon_date          = ar_mstr.ar_recon_date
         ar.ar_status              = ar_mstr.ar_status
         ar.ar_customer_initiated  = ar_mstr.ar_customer_initiated
         ar.ar_draft_submit_date   = ar_mstr.ar_draft_submit_date
         ar.ar_pay_method          = ar_mstr.ar_pay_method
         ar.ar_void_date           = ar_mstr.ar_void_date
         ar.ar_domain              = ar_mstr.ar_domain.
end.

 
*/