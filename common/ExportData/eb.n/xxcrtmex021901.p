/*xxcrtmex.p ---- Program to DownLoad Cedit Tems Master (2.19.1) Eb                           */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/* This program Extracts the Credit Terms Master Data from Mfg/Pro EB2 into  .CSV File        */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxcrtmex.p                                                      */   
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : SACHIN P (TCSL)                            DATE:06/06/2005      */
/* REVISION                 : 01          LAST  MODIFIED BY: Sachin P    DATE:10/06/2005      */
/* REVISION                 : 02          LAST  MODIFIED BY: Mahesh K    DATE:13/06/2005      */
/**********************************************************************************************/


        {mfdtitle.i}

        &SCOPED-DEFINE xxcrtmex_p_1  "Extraction File Name"
        &SCOPED-DEFINE xxcrtmex_p_2  "ERROR: Blank Filename Not Allowed"   

        /* Variable Declaration */
        DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.

        /* Form Definition */
        FORM
           SKIP(1)
           m_filename VALIDATE( m_filename <> "", {&xxcrtmex_p_2} ) LABEL {&xxcrtmex_p_1}
        WITH FRAME a SIDE-LABELS TITLE "Credit Terms Extraction" WIDTH 80.

        {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

        /*Accepting the File Name */
        UPDATE m_filename  WITH FRAME a.

        /* Extracting the Data into the File */
        OUTPUT TO VALUE(m_filename).
        EXPORT DELIMITER ","
	 "ct_code"	 "ct_desc"	 "ct_dating"	 "ct_disc_pct"	 "ct_disc_days"	 "ct_from_inv"	 "ct_disc_date"	 "ct_due_days"	 "ct_min_days"	 "ct_due_inv"	 "ct_due_date"	 "ct_base_date"	 "ct_base_days"	 "ct_grace_days"	 "ct_terms_int"	 "ct_late_int"	 "ctd_seq"	 "ctd_date_cd"	 "ctd_pct_due ."

	.
           FOR EACH ct_mstr NO-LOCK :
               IF ct_dating = NO THEN 
               DO:
               EXPORT DELIMITER ","
                          ct_code
                          ct_desc
                          ct_dating
                          ct_disc_pct
                          ct_disc_days
                          ct_from_inv
                          ct_disc_date
                          ct_due_days
                          ct_min_days
                          ct_due_inv
                          ct_due_date
                          ct_base_date
                          ct_base_days
                          ct_grace_days
                          ct_terms_int
                          ct_late_int.                     
                END. /* if ct_dating = no */
                ELSE
                DO:
                   FOR EACH ctd_det NO-LOCK WHERE
                         ctd_code = ct_code :
                    EXPORT DELIMITER ","
                          ct_code
                          ct_desc
                          ct_dating
                          ct_disc_pct
                          ct_disc_days
                          ct_from_inv
                          ct_disc_date
                          ct_due_days
                          ct_min_days
                          ct_due_inv
                          ct_due_date
                          ct_base_date
                          ct_base_days
                          ct_grace_days
                          ct_terms_int
                          ct_late_int
                          ctd_seq
                          ctd_date_cd
                          ctd_pct_due .                     
                   END. /* for each ctd_det */
               END. /* Else */
           END. /*for each ct_mstr */
        OUTPUT CLOSE.

