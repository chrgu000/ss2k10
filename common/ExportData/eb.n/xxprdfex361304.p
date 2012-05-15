/*xxprdfex.p - Program to Extract Printer Default Maintenance  (36.13.4 ) Eb                  */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/*This program Extracts the Printer Default Master from Mfg/Pro EB  into  .CSV File           */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxprdfex.p                                                      */
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : Sachin P (TCSL)                            DATE:13/06/2005      */
/* REVISION                 : 01          LAST  MODIFIED BY: Mahesh K    DATE:14/06/2005      */
/**********************************************************************************************/


        {mfdtitle.i}

        &SCOPED-DEFINE xxprdefex_p_1  "Extraction File Name"
        &SCOPED-DEFINE xxprdefex_p_2  "ERROR: Blank Filename Not Allowed"   

        /* Variable Declaration */
        DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.

        /* Form Definition */
        FORM
           SKIP(1)
           m_filename VALIDATE( m_filename <> "", {&xxprdefex_p_2}) LABEL {&xxprdefex_p_1}
        WITH FRAME a SIDE-LABELS TITLE "Printer Default Data Extraction" WIDTH 80.

        {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

        /*Accepting the File Name */
        UPDATE m_filename  WITH FRAME a.

        /* Extracting the Data into the File */
        OUTPUT TO VALUE(m_filename).
	      EXPORT DELIMITER ","
	       "upd_userid"	 "upd_nbr"	 "upd_select"	 "upd_dev."

	      .
           FOR EACH upd_det NO-LOCK : 
                  EXPORT DELIMITER ","
                          upd_userid
                          upd_nbr
                          upd_select
                          upd_dev.
                          
                            
           END. /* For Each upd_det */
        OUTPUT CLOSE.
