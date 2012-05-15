/*xxcusbex.p ---- Program to DownLoad Customer  Master (2.1.1) - Eb                           */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/* This program Extracts the Customer Master Data from Mfg/Pro EB  into  .CSV File            */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxcusbex.p                                                      */  
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : MAHESH K (TCSL)                            DATE:07/06/2005      */
/* REVISION                 : 01          LAST  MODIFIED BY: Mahesh K    DATE:10/06/2005      */
/* REVISION                 : 02          LAST  MODIFIED BY: Mahesh K    DATE:13/06/2005      */
/* REVISION                 : 03          LAST  MODIFIED BY: Sachin P    DATE:13/07/2005      */ 
/*                          : ECO# SP001 Modified for Eb version Compatibility                */       
/**********************************************************************************************/



               {mfdtitle.i}

               &SCOPED-DEFINE xxcusbex_p_1  "Extraction File Name"
               &SCOPED-DEFINE xxcusbex_p_2  "ERROR: Blank Filename Not Allowed"   


               /* Variable Declaration */
               DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.

               /* form Definition */
               FORM
               SKIP(1)
               m_filename VALIDATE( m_filename <> "", {&xxcusbex_p_2} )  LABEL {&xxcusbex_p_1}
               WITH FRAME a SIDE-LABELS TITLE "Customer Master Extraction" WIDTH 80.

               {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}


               /*Accepting File Name */
               UPDATE m_filename  WITH FRAME a.

               /*Extracting the Data into the File */
               OUTPUT TO VALUE(m_filename).
                 EXPORT DELIMITER ","
 "cm_addr"	 "ad_name"	 "ad_line1"	 "ad_line2"	 "ad_line3"	 "ad_city"	 "ad_state"	 "ad_zip"	 "ad_format"	 "ad_ctry"	 "ad_county"	 "ad_attn"	 "ad_phone"	 "ad_ext"	 "ad_fax"	 "ad_attn2"	 "ad_phone2"	 "ad_ext2"	 "ad_fax2"	 "ad_date"	 "cm_sort"	 "cm_slspsn[1]"	 "cm_shipvia"	 "cm_ar_acct"	 "cm_ar_sub"	 "cm_ar_cc"	 "cm_resale"	 "cm_rmks"	 "cm_type"	 "cm_region"	 "cm_curr"	 "cm_site"	 "cm_lang"	 "cm_slspsn[2]"	 "cm_slspsn[3]"	 "cm_slspsn[4]"	 "cm_pr_list2"	 "cm_pr_list"	 "cm_fix_pr"	 "cm_class"	 "cm_partial"	 "cm__qadl01"	 "ad_taxable"	 "ad_tax_zone"	 "ad_taxc"	 "ad_tax_usage"	 "ad_tax_in"	 "ad_gst_id"	 "ad_pst_id"	 "ad_misc1_id"	 "ad_misc2_id"	 "ad_misc3_id"	 "ad__qad01"	 "cm_cr_limit"	 "cm_cr_terms"	 "cm_cr_hold"	 "cm_cr_rating"	 "cm_db"	 "cm_po_reqd"	 "cm_disc_pct"	 "cm_fin"	 "cm_stmt"	 "cm_stmt_cyc"	 "cm_dun"	 "cm_bill"	 "cm_cr_review"	 "cm_cr_update"	 "cm_fr_list"	 "cm_fr_min_wt"	 "cm_fr_terms"	 "cm_ship_lt"	 "cm_btb_mthd"	 "cm_btb_cr."

                 .
                 FOR EACH cm_mstr NO-LOCK,
                       EACH ls_mstr NO-LOCK WHERE ls_addr = cm_addr AND ls_type = "Customer" ,
                         EACH ad_mstr WHERE ad_addr = ls_addr NO-LOCK :

                      EXPORT DELIMITER ","
                              cm_addr
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
                              cm_sort
                              cm_slspsn[1]
                              cm_shipvia
                              cm_ar_acct
                              cm_ar_sub
                              cm_ar_cc
                              cm_resale
                              cm_rmks
                              cm_type
                              cm_region
                              cm_curr
                              cm_site
                              cm_lang
                              cm_slspsn[2]
                              cm_slspsn[3]
                              cm_slspsn[4]
                              cm_pr_list2
                              cm_pr_list
                              cm_fix_pr
                              cm_class
  /*SP001*/                   "" /* cm_sic */
                              cm_partial
                              cm__qadl01
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
                              IF ad__qad01 = "1" THEN "yes" ELSE "no"
                              cm_cr_limit
                              cm_cr_terms
                              cm_cr_hold
                              cm_cr_rating
                              cm_db
                              cm_po_reqd
                              cm_disc_pct
                              cm_fin
                              cm_stmt
                              cm_stmt_cyc
                              cm_dun
                              cm_bill
                              cm_cr_review
                              cm_cr_update
                              cm_fr_list
                              cm_fr_min_wt
                              cm_fr_terms
                              cm_ship_lt
                              cm_btb_mthd
                              cm_btb_cr.
                           END. /* for each cm_mstr */
               OUTPUT CLOSE.
