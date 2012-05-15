/*xxsupmex.p ---- Program to DownLoad Supplier  Master (2.3.1) - Eb                           */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/*This program Extracts the Supplier  Master Data from Mfg/Pro EB  into  .CSV File            */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxsupmex.p                                                      */
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : MAHESH K (TCSL)                            DATE:08/06/2005      */
/* REVISION                 : 01          LAST  MODIFIED BY: Mahesh K    DATE:10/06/2005      */
/* REVISION                 : 02          LAST  MODIFIED BY: Mahesh K    DATE:16/06/2005      */
/**********************************************************************************************/



               {mfdtitle.i}

               &SCOPED-DEFINE xxsupmex_p_1  "Extraction File Name"
               &SCOPED-DEFINE xxsupmex_p_2  "ERROR: Blank Filename Not Allowed"  

               /* Variable Declaration */
               DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.
               DEFINE VARIABLE m_emt_auto AS LOGICAL                  NO-UNDO.

               /* form Definition */
               FORM
               SKIP(1)
               m_filename VALIDATE( m_filename <> "", {&xxsupmex_p_2})  LABEL {&xxsupmex_p_1}
               WITH FRAME a SIDE-LABELS TITLE "Supplier Master Extraction" WIDTH 80.

               {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

               /*Accepting File Name */
               UPDATE m_filename  WITH FRAME a.

               /*Extracting the Data into the File */
               OUTPUT TO VALUE(m_filename).
EXPORT DELIMITER ","
 "vd_addr"	 "ad_temp"	 "ad_name"	 "ad_line1"	 "ad_line2"	 "ad_line3"	 "ad_city"	 "ad_state"	 "ad_zip"	 "ad_format"	 "ad_ctry"	 "ad_county"	 "ad_attn"	 "ad_phone"	 "ad_ext"	 "ad_fax"	 "ad_attn2"	 "ad_phone2"	 "ad_ext2"	 "ad_fax2"	 "ad_date"	 "vd_sort"	 "vd_type"	 "vd_pur_acct"	 "vd_pur_sub"	 "vd_pur_cc"	 "vd_ap_acct"	 "vd_ap_sub"	 "vd_ap_cc"	 "vd_shipvia"	 "vd_rmks"	 "vd_bank"	 "vd_curr"	 "vd_pur_cntct"	 "vd_ap_cntct"	 "vd_promo"	 "vd_ckfrm"	 "vd_lang"	 "vd_misc_cr"	 "vd_buyer"	 "vd_pr_list2"	 "vd_pr_list"	 "vd_fix_pr"	 "vd_rcv_so_price"	 "vd_rcv_held_so"	 "m_emt_auto"	 "vd__qadl01"	 "vd_tp_pct"	 "vd_tp_use_pct"	 "vd_cr_terms"	 "vd_disc_pct"	 "ad_coc_reg"	 "vd_partial"	 "vd_hold"	 "vd_db"	 "vd_tid_notice"	 "vd_prepay"	 "vd_debtor"	 "vd_1099"	 "vd_pay_spec"	 "ad_taxable"	 "ad_tax_zone"	 "ad_taxc"	 "ad_tax_usage"	 "ad_tax_in"	 "ad_gst_id"	 "ad_pst_id"	 "ad_misc1_id"	 "ad_misc2_id"	 "ad_misc3_id"

.
                 FOR EACH vd_mstr NO-LOCK,
                       EACH ls_mstr NO-LOCK WHERE ls_addr = vd_addr AND ls_type = "Supplier" ,
                         EACH ad_mstr WHERE ad_addr = ls_addr NO-LOCK :

                     /*Get emt-auto Value */
                     FIND FIRST qad_wkfl WHERE  
                              qad_key1 = vd_addr AND
                              qad_key2  = "AUTO-EMT" NO-LOCK NO-ERROR.
                                    IF AVAILABLE qad_wkfl THEN
                                        m_emt_auto = YES.
                                    ELSE  m_emt_auto = NO.
                      
                      EXPORT DELIMITER ","
                           vd_addr
                           ad_temp
                           ad_name
                           ad_line1
                           ad_line2
                           ad_line3
                           ad_city
                           ad_state
                           ad_zip
                           ad_format
                           ad_ctry
                           ad_county
                           ad_attn
                           ad_phone
                           ad_ext
                           ad_fax
                           ad_attn2
                           ad_phone2
                           ad_ext2
                           ad_fax2
                           ad_date
                           vd_sort
                           vd_type
                           vd_pur_acct
                           vd_pur_sub
                           vd_pur_cc
                           vd_ap_acct
                           vd_ap_sub
                           vd_ap_cc
                           vd_shipvia
                           vd_rmks
                           vd_bank
                           vd_curr
                           vd_pur_cntct
                           vd_ap_cntct
                           vd_promo
                           vd_ckfrm
                           vd_lang
                           vd_misc_cr
                           vd_buyer
                           vd_pr_list2
                           vd_pr_list
                           vd_fix_pr
                           vd_rcv_so_price
                           vd_rcv_held_so
                           m_emt_auto
                           vd__qadl01
                           vd_tp_pct
                           vd_tp_use_pct
                           vd_cr_terms
                           vd_disc_pct
                           ad_coc_reg
                           vd_partial
                           vd_hold
                           vd_db
                           vd_tid_notice
                           vd_prepay
                           vd_debtor
                           vd_1099
                           vd_pay_spec
                           ad_taxable
                           ad_tax_zone
                           ad_taxc
                           ad_tax_usage
                           ad_tax_in
                           ad_gst_id
                           ad_pst_id
                           ad_misc1_id
                           ad_misc2_id
                           ad_misc3_id
                           IF ad__qad01 = "1" THEN "yes" ELSE "no".
                      END.      /* for each vd_mstr*/
               OUTPUT CLOSE.
