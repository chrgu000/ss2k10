/*xxprlnex.p ---- Program to DownLoad Product Line  Master (1.2.1) Eb                         */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxprlnex.p                                                      */          
/* This program Extracts the Product Line Master Data from Mfg/Pro EB  into  .CSV File        */
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : MAHESH K (TCSL)                            DATE:03/06/2005      */
/* REVISION                 : 01          LAST  MODIFIED BY: Mahesh K    DATE:10/06/2005      */
/* REVISION                 : 02          LAST  MODIFIED BY: Sachin P    DATE:13/07/2005      */ 
/*                          : ECO# SP001 Modified for Eb version Compatibility                */       
/**********************************************************************************************/


               {mfdtitle.i}

               &SCOPED-DEFINE xxprlnex_p_1  "Extraction File Name"
               &SCOPED-DEFINE xxprlnex_p_2  "ERROR: Blank Filename Not Allowed"   


               /* Variable Declaration */
               DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.

               /* form Definition */
               FORM
               SKIP(1)
               m_filename VALIDATE( m_filename <> "", {&xxprlnex_p_2} ) LABEL {&xxprlnex_p_1}
               WITH FRAME a SIDE-LABELS TITLE "Product Line Master Extraction" WIDTH 80.

               {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

               /* Accepting File Name */
               UPDATE m_filename  WITH FRAME a.

               /*Extracting the Data into the File*/
               OUTPUT TO VALUE(m_filename).
	        EXPORT DELIMITER  ","
		 "pl_prod_line"	 "pl_Desc"	 "pl_taxable"	 "pl_taxc"	 "pl_inv_acct"	 "pl_inv_sub"	 "pl_inv_cc"	 "pl_dscr_acct"	 "pl_dscr_sub"	 "pl_dscr_cc"	 "pl_scrp_acct"	 "pl_scrp_sub"	 "pl_scrp_cc"	 "pl_cchg_acct"	 "pl_cchg_sub"	 "pl_cchg_cc"	 "pl_sls_acct"	 "pl_sls_sub"	 "pl_sls_cc"	 "pl_dsc_acct"	 "pl_dsc_sub"	 "pl_dsc_cc"	 "pl_cmtl_acct"	 "pl_cmtl_sub"	 "pl_cmtl_cc"	 "pl_clbr_acct"	 "pl_clbr_sub"	 "pl_clbr_cc"	 "pl_cbdn_acct"	 "pl_cbdn_sub"	 "pl_cbdn_cc"	 "pl_covh_acct"	 "pl_covh_sub"	 "pl_covh_cc"	 "pl_csub_Acct"	 "pl_csub_sub"	 "pl_csub_cc"	 "pl_pur_acct"	 "pl_pur_sub"	 "pl_pur_cc"	 "pl_rcpt_acct"	 "pl_rcpt_sub"	 "pl_rcpt_cc"	 "pl_ovh_acct"	 "pl_ovh_sub"	 "pl_ovh_cc"	 "pl_ppv_acct"	 "pl_ppv_sub"	 "pl_ppv_cc"	 "pl_apvu_acct"	 "pl_apvu_sub"	 "pl_apvu_cc"	 "pl_apvr_acct"	 "pl_apvr_sub"	 "pl_apvr_cc"	 "pl_flr_Acct"	 "pl_flr_sub"	 "pl_flr_cc"	 "pl_mvar_acct"	 "pl_mvar_sub"	 "pl_mvar_cc"	 "pl_mvrr_acct"	 "pl_mvrr_sub"	 "pl_mvrr_cc"	 "pl_xvar_acct"	 "pl_xvar_sub"	 "pl_xvar_cc"	 "pl_cop_acct"	 "pl_cop_sub"	 "pl_cop_cc"	 "pl_svar_acct"	 "pl_svar_sub"	 "pl_svar_cc"	 "pl_svrr_acct"	 "pl_svrr_sub"	 "pl_svrr_cc"	 "pl_wip_acct"	 "pl_wip_sub"	 "pl_wip_cc"	 "pl_wvar_acct"	 "pl_wvar_sub"	 "pl_wvar_cc"	 "pl_fslbr_acct"	 "pl_fslbr_sub"	 "pl_fslbr_cc"	 "pl_fsbdn_acct"	 "pl_fsbdn_sub"	 "pl_fsbdn_cc"	 "pl_fsexp_acct"	 "pl_fsexp_sub"	 "pl_fsexp_cc"	 "pl_fsexd_acct"	 "pl_fsexd_sub"	 "pl_fsexd_cc"	 "pl_rmar_acct"	 "pl_rmar_sub"	 "pl_rmar_cc" "pl_fsdef_acct" "pl_fsdef_sub" "pl_fsdef_cc" "pl_fsaccr_acct" "pl_fsaccr_sub" "pl_fsaccr_cc"

		.
               FOR EACH pl_mstr NO-LOCK:
                  EXPORT DELIMITER  ","
                          pl_prod_line
                          pl_Desc
                          pl_taxable
                          pl_taxc
                          pl_inv_acct
                          "" /* pl_inv_sub */
                          pl_inv_cc
                          pl_dscr_acct
                          "" /* pl_dscr_sub */
                          pl_dscr_cc
                          pl_scrp_acct
                          "" /* pl_scrp_sub */
                          pl_scrp_cc
                          pl_cchg_acct
                          "" /*pl_cchg_sub */
                          pl_cchg_cc
                          pl_sls_acct
                          "" /* pl_sls_sub */
                          pl_sls_cc
                          pl_dsc_acct
                          "" /* pl_dsc_sub */
                          pl_dsc_cc
                          pl_cmtl_acct
                          "" /* pl_cmtl_sub */
                          pl_cmtl_cc
                          pl_clbr_acct
                          "" /* pl_clbr_sub */
                          pl_clbr_cc
                          pl_cbdn_acct
                          "" /* pl_cbdn_sub */
                          pl_cbdn_cc
                          pl_covh_acct
                          "" /* pl_covh_sub */
                          pl_covh_cc
                          pl_csub_Acct
                          "" /* pl_csub_sub */
                          pl_csub_cc
                          pl_pur_acct
                          "" /* pl_pur_sub */
                          pl_pur_cc
                          pl_rcpt_acct
                          "" /* pl_rcpt_sub */
                          pl_rcpt_cc
                          pl_ovh_acct
                          "" /* pl_ovh_sub */
                          pl_ovh_cc
                          pl_ppv_acct
                          "" /* pl_ppv_sub */
                          pl_ppv_cc
                          pl_apvu_acct
                          "" /* pl_apvu_sub */
                          pl_apvu_cc
                          pl_apvr_acct
                          "" /* pl_apvr_sub */
                          pl_apvr_cc
                          pl_flr_Acct
                          "" /* pl_flr_sub */
                          pl_flr_cc
                          pl_mvar_acct
                          "" /* pl_mvar_sub */
                          pl_mvar_cc
                          pl_mvrr_acct
                          "" /* pl_mvrr_sub */
                          pl_mvrr_cc
                          pl_xvar_acct
                          "" /* pl_xvar_sub */
                          pl_xvar_cc
                          pl_cop_acct
                          "" /* pl_cop_sub */
                          pl_cop_cc
                          pl_svar_acct
                          "" /* pl_svar_sub */
                          pl_svar_cc
                          pl_svrr_acct
                          "" /* pl_svrr_sub */
                          pl_svrr_cc
                          pl_wip_acct
                          "" /* pl_wip_sub */
                          pl_wip_cc
                          pl_wvar_acct
                          "" /* pl_wvar_sub */
                          pl_wvar_cc
                          pl_fslbr_acct
                          "" /* pl_fslbr_sub */
                          pl_fslbr_cc
                          pl_fsbdn_acct
                          "" /* pl_fsbdn_sub */
                          pl_fsbdn_cc
                          pl_fsexp_acct
                          "" /* pl_fsexp_sub */
                          pl_fsexp_cc
                          pl_fsexd_acct
                          "" /* pl_fsexd_sub */
                          pl_fsexd_cc
                          pl_rmar_acct
                          "" /* pl_rmar_sub */
                          pl_rmar_cc
/*SP001*/                 pl_fsdef_acct
                          "" /* pl_fsdef_sub */
                          pl_fsdef_cc 
			  pl_fsaccr_acct
			  "" /* pl_fsaccr_sub */
			  pl_fsaccr_cc.
                      END. /* for each pl_mstr   */
               OUTPUT CLOSE.
