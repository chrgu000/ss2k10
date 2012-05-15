/*xxcurex.p ---- Program to DownLoad Currency Master (26.1) Eb                                */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/* This program Extracts the Currency Master Data from Mfg/Pro EB2 into  .CSV File            */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxcurex.p                                                       */          
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : SACHIN P (TCSL)                            DATE:01/06/2005      */
/* REVISION                 : 01          LAST  MODIFIED BY: Sachin P    DATE:10/06/2005      */
/**********************************************************************************************/


        {mfdtitle.i}

        &SCOPED-DEFINE xxcurex_p_1  "Extraction File Name"
        &SCOPED-DEFINE xxcurex_p_2  "ERROR: Blank Filename Not Allowed"   

        /* Variable Declaration */
        DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.

        /* Form Definition */
        FORM
           SKIP(1)
           m_filename VALIDATE(m_filename <> " ", {&xxcurex_p_2}) LABEL {&xxcurex_p_1}
        WITH FRAME a SIDE-LABELS TITLE "Currency Master Extraction" WIDTH 80.

        {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

        /*Accepting File Name*/
        UPDATE m_filename  WITH FRAME a.

        /* Extracting the Data into the File */
        OUTPUT TO VALUE(m_filename).
	EXPORT DELIMITER ","
	 "cu_curr"	 "cu_desc"	 "cu_rnd_mthd"	 "cu_ugain_acct"	 "cu_ugain_sub"	 "cu_ugain_cc"	 "cu_uloss_acct"	 "cu_uloss_sub"	 "cu_uloss_cc"	 "cu_rgain_acct"	 "cu_rgain_sub"	 "cu_rgain_cc"	 "cu_rloss_acct"	 "cu_rloss_sub"	 "cu_rloss_cc"	 "cu_ex_rnd_acct"	 "cu_ex_rnd_sub"	 "cu_ex_rnd_cc"	 "cu_active."

	.
           FOR EACH cu_mstr NO-LOCK :
               EXPORT DELIMITER ","
                          cu_curr
                          cu_desc
                          cu_rnd_mthd
                          cu_ugain_acct
                          cu_ugain_sub
                          cu_ugain_cc
                          cu_uloss_acct
                          cu_uloss_sub
                          cu_uloss_cc
                          cu_rgain_acct
                          cu_rgain_sub
                          cu_rgain_cc
                          cu_rloss_acct
                          cu_rloss_sub
                          cu_rloss_cc
                          cu_ex_rnd_acct
                          cu_ex_rnd_sub
                          cu_ex_rnd_cc
                          cu_active.
           END. /* For Each cu_mstr */
        OUTPUT CLOSE.

       
