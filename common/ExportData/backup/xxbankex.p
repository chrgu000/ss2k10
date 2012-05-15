/*xxbankex.p ---- Program to DownLoad Bank Master (26.13) Eb                                  */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/* This program Extracts the Bank Master Data from Mfg/Pro EB into  .CSV File                 */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxbankex.p                                                      */  
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : MAHESH K (TCSL)                            DATE:02/06/2005      */
/* REVISION                 : 01          LAST  MODIFIED BY: Sachin P    DATE:10/06/2005      */
/* REVISION                 : 01          LAST  MODIFIED BY: Sachin P    DATE:24/06/2005      */
/* REVISION                 : 02          LAST  MODIFIED BY: Mahesh K    DATE:05/08/2005      */ 
/*                          : ECO# MK001 Modified for Eb version Compatibility                */       
/* REVISION                 : 03          LAST  MODIFIED BY: Mahesh K    DATE:30/08/2005      */ 
/*                          : ECO# MK002 Modified for Eb version Compatibility                */       
/**********************************************************************************************/

               {mfdtitle.i}

               &SCOPED-DEFINE xxbankex_p_1  "Extraction File Name"
               &SCOPED-DEFINE xxbankex_p_2  "ERROR: Blank Filename Not Allowed"   


               /* Variable Declaration */
               DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.

               /* form Definition */
               FORM
                 SKIP(1)
                 m_filename VALIDATE( m_filename <> "", {&xxbankex_p_2} ) LABEL {&xxbankex_p_1}
               WITH FRAME a SIDE-LABELS TITLE "Bank Master Extraction" WIDTH 80.

               {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

               /*Accepting File Name */
               UPDATE m_filename WITH FRAME a.

               /*Extracting the Data into the file */
               OUTPUT TO VALUE(m_filename).
               FOR EACH bk_mstr NO-LOCK ,
                   EACH ad_mstr NO-LOCK WHERE
                     ad_type = "our_bank" AND 
                      ad_addr = bk_code :
                      EXPORT DELIMITER ","
                           bk_code
                           bk_Desc
                           ad_sort
                           ad_date
                           ad_lang
                           ad_line1
                           ad_line2
                           ad_line3
                           ad_city
                           ad_state
                           ad_zip
                           ad_format
                           ad_ctry
                           ad_county
                           string(ad_attn)
                           string(ad_attn2)
                           string(ad_phone)
                           string(ad_ext)
                           string(ad_phone2)
                           string(ad_ext2)
                           string(ad_fax)
                           string(ad_fax2)
                           bk_check
                           bk_curr
                           bk_bk_acct1
                           bk_bk_acct2
                           bk_entity
                           bk_acct
                           bk_sub
                           bk_cc
                           bk_pip_acc
                           bk_pip_sub
                           bk_pip_cc
/*MK002*/                  bk_user1
                           bk_dftar_Acc
                           bk_dftar_sub
                           bk_dftar_cc
                           bk_bkchg_acc
                           bk_bkchg_sub
                           bk_bkchg_cc
                           bk_disc_acc
                           bk_disc_sub
                           bk_disc_cc
                           bk_ddft_acc
                           bk_ddft_sub
                           bk_ddft_cc
                           bk_dftap_acc
                           bk_dftap_sub
                           bk_dftap_cc
                           bk_bktx_acc
                           bk_bktx_sub
                           bk_bktx_cc
                           bk_cdft_acc
                           bk_cdft_sub
                           bk_cdft_cc
                           bk_edft_acc
                           bk_edft_sub
                           bk_edft_cc
                           ad_gst_id
                           ad_pst_id
                           ad_vat_reg
/*MK001*/                  ad_edi_std
/*MK001*/                  ad_edi_level
/*MK001*/                  ad_edi_id
/*MK001*/                  ad_edi_tpid.
                END.   /* for each bk_mstr*/
                OUTPUT CLOSE.
