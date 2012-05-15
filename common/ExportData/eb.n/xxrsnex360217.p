/*xxrsnex.p ---- Program to DownLoad Reason Code Master (36.2.17) -      Eb                   */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/* This program Extracts the Reason Code Master Data from Mfg/Pro EB  into  .CSV File         */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxrsnex.p                                                       */      
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : SACHIN P (TCSL)                            DATE:06/06/2005      */
/* REVISION                 : 01          LAST  MODIFIED BY: Sachin P    DATE:10/06/2005      */
/**********************************************************************************************/



        {mfdtitle.i}

        &SCOPED-DEFINE xxrsnex_p_1  "Extraction File Name"
        &SCOPED-DEFINE xxrsnex_p_2  "ERROR: Blank Filename Not Allowed"   

        /* Variable Declaration */
        DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.

        /* Form Definition */
        FORM
           SKIP(1)
           m_filename VALIDATE( m_filename <> "", {&xxrsnex_p_2} )  LABEL {&xxrsnex_p_1}
        WITH FRAME a SIDE-LABELS TITLE "Reason Code Extraction" WIDTH 80.

        {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

        /*Accepting the File Name */
        UPDATE m_filename  WITH FRAME a.
        /* Extracting the Data into the File */
        OUTPUT TO VALUE(m_filename).
        EXPORT DELIMITER ","
 "rsn_type"	 "rsn_code"	 "rsn_desc."

        .

	   FOR EACH rsn_ref NO-LOCK : 
                  EXPORT DELIMITER ","
                          rsn_type
                          rsn_code
                          rsn_desc.                     
           END. /* For Each rsn_ref */
        OUTPUT CLOSE.
