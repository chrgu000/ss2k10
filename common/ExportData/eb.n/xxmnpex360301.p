/*xxmnpex.p ---- Program to DownLoad Menu Pasword Master (36.3.1) -     Eb                    */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/*This program Extracts the Menu Passwod  Master from Mfg/Pro EB  into  .CSV File             */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxmnpex.p                                                       */
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : Sachin P (TCSL)                            DATE:13/06/2005      */
/* REVISION                 : 01            LAST  MODIFIED BY:           DATE:14/06/2005      */
/**********************************************************************************************/


        {mfdtitle.i}
        
        &SCOPED-DEFINE xxmnpex_p_1  "Extraction File Name"
        &SCOPED-DEFINE xxmnpex_p_2  "ERROR: Blank Filename Not Allowed"   


        /* Variable Declaration */
        DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.

        /* Form Definition */
        FORM
           SKIP(1)
           m_filename  VALIDATE( m_filename <> "", {&xxmnpex_p_2} ) LABEL {&xxmnpex_p_1}
        WITH FRAME a SIDE-LABELS TITLE "Menu Password Extraction" WIDTH 80.

        {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

        /*Accepting the File Name */
        UPDATE m_filename  WITH FRAME a.

        /* Extracting the Data into the File */
        OUTPUT TO VALUE(m_filename).
	                  EXPORT DELIMITER ","
 "mnd_nbr"	 "mnd_select"	 "mnd_canrun."

.
           FOR EACH mnd_det NO-LOCK : 
                  EXPORT DELIMITER ","
                          mnd_nbr
                          mnd_select
                          mnd_canrun.                     
           END. /* For Each mnd_det */
        OUTPUT CLOSE.
