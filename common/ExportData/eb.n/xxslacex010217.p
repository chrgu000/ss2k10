/*xxslacex.p   Program to DownLoad Sales Account Master (1.2.17) Eb                           */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/* This program Extracts the Sales Account Master Data from Mfg/Pro EB  into  .CSV File       */
/**********************************************************************************************/
/* POCUDURE NAME            : xxslacex.p                                                      */  
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : MAHESH K (TCSL)                            DATE:03/06/2005      */
/* REVISION                 : 01            LAST  MODIFIED BY: Mahesk K  DATE:10/06/2005      */
/* REVISION                 : 02           LAST  MODIFIED BY: Sachin P   DATE:13/07/2005      */ 
/*                          : ECO# SP001 Modified for Eb version Compatibility                */       
/**********************************************************************************************/



               {mfdtitle.i}

               &SCOPED-DEFINE xxslacex_p_1  "Extraction File Name"
               &SCOPED-DEFINE xxslacex_p_2  "ERROR: Blank Filename Not Allowed"   

               /* Variable Declaration */
               DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.

               /* form Definition */
               FORM
               SKIP(1)
               m_filename VALIDATE( m_filename <> "", {&xxslacex_p_2} ) LABEL {&xxslacex_p_1}
               WITH FRAME a SIDE-LABELS TITLE "Sales Account Master Extraction" WIDTH 80.

               {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

               /*Accepting File Name */
               UPDATE m_filename  WITH FRAME a.
EXPORT DELIMITER ","
 "plsd_prodline"	 "plsd_site"	 "plsd_cmtype"	 "plsd_channel"	 "plsd_sls_acct"	 "plsd_sls_sub"	 "plsd_sls_cc"	 "plsd_dsc_acct"	 "plsd_dsc_sub"	 "plsd_dsc_cc"	 "plsd_cmtl_acct"	 "plsd_cmtl_sub"	 "plsd_cmtl_cc"	 "plsd_cbdn_acct"	 "plsd_cbdn_sub"	 "plsd_cbdn_cc"	 "plsd_clbr_acct"	 "plsd_clbr_sub"	 "plsd_clbr_cc"	 "plsd_covh_acct"	 "plsd_covh_sub"	 "plsd_covh_cc"	 "plsd_csub_acct"	 "plsd_csub_sub"	 "plsd_csub_cc"

.
               /*Extracting the Data into the File */
               OUTPUT TO VALUE(m_filename).
               FOR EACH plsd_det NO-LOCK:
                   EXPORT DELIMITER ","
                        plsd_prodline
                        plsd_site
                        plsd_cmtype
                        plsd_channel
                        plsd_sls_acct
                        plsd_sls_sub
                        plsd_sls_cc
                        plsd_dsc_acct
                        plsd_dsc_sub
                        plsd_dsc_cc
                        plsd_cmtl_acct
                        plsd_cmtl_sub
                        plsd_cmtl_cc
                        plsd_cbdn_acct
                        plsd_cbdn_sub
                        plsd_cbdn_cc
                        plsd_clbr_acct
                        plsd_clbr_sub
                        plsd_clbr_cc
                        plsd_covh_acct
                        plsd_covh_sub
                        plsd_covh_cc
                        plsd_csub_acct
                        plsd_csub_sub
                        plsd_csub_cc
  /*SP001*/             ""   /* pl_fsdef_acct  */
                        ""   /* pl_fsdef_sub   */
                        ""   /* pl_fsdef_cc    */ 
                        ""   /* pl_fsaccr_acct */
                        ""   /* pl_fsaccr_sub  */
                        "".  /* pl_fsaccr_cc.  */
               END. /* for each plsd_det */
               OUTPUT CLOSE.
