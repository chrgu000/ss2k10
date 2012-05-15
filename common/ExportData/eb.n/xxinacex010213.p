/*xxinacex.p ---- Program to DownLoad Inventory Account Master (1.2.13) Eb                    */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/* This program Extracts the Inventory Account Master Data from Mfg/Pro EB  into  .CSV File   */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxinacex.p                                                      */          
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : SACHIN P (TCSL)                            DATE:03/06/2005      */
/* REVISION                 : 01            LAST  MODIFIED BY:Sachin P   DATE:10/06/2005      */
/**********************************************************************************************/

    

      
        {mfdtitle.i}

        &SCOPED-DEFINE xxinacex_p_1  "Extraction File Name"
        &SCOPED-DEFINE xxinacex_p_2  "ERROR: Blank Filename Not Allowed"   

        /* Variable Declaration */
        DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.
        
        /* Form Definitions */
        FORM
           SKIP(1)
           m_filename VALIDATE (m_filename <> "", {&xxinacex_p_2} ) LABEL {&xxinacex_p_1}
        WITH FRAME a SIDE-LABELS TITLE "Inventory Account Extraction" WIDTH 80.

        {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

        /* Accepting the File Name */
        UPDATE m_filename  WITH FRAME a.

        /* Extracting Data into File */
        OUTPUT TO VALUE(m_filename).
	EXPORT DELIMITER ","
	 "pld_prodline"	 "pld_site"	 "pld_loc"	 "pld_inv_acct"	 "pld_inv_sub"	 "pld_inv_cc"	 "pld_scrpacct"	 "pld_scrp_sub"	 "pld_scrp_cc"	 "pld_dscracct"	 "pld_dscr_sub"	 "pld_dscr_cc"	 "pld_cchg_acc"	 "pld_cchg_sub"	 "pld_cchg_cc."

	.
           FOR EACH pld_det NO-LOCK :
               EXPORT DELIMITER ","
                      pld_prodline
                      pld_site
                      pld_loc
                      pld_inv_acct
                      pld_inv_sub
                      pld_inv_cc
                      pld_scrpacct
                      pld_scrp_sub
                      pld_scrp_cc
                      pld_dscracct
                      pld_dscr_sub
                      pld_dscr_cc
                      pld_cchg_acc
                      pld_cchg_sub
                      pld_cchg_cc.
                          
           END. /* For Each pld_det */
        OUTPUT CLOSE.
