/*xxmscmex.p ---- Program to DownLoad Master Comments(1.12) Eb                                */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/* This program Extracts the Master Comments Data from Mfg/Pro EB  into  .CSV File            */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxmscmex.p                                                      */          
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : SACHIN P (TCSL)                            DATE:02/06/2005      */
/* REVISION                 : 01          LAST  MODIFIED BY: Sachin P    DATE:10/06/2005      */
/**********************************************************************************************/



        {mfdtitle.i}

        &SCOPED-DEFINE xxmscmex_p_1  "Extraction File Name"
        &SCOPED-DEFINE xxmscmex_p_2  "ERROR: Blank Filename Not Allowed"   

        /* Variable Declaration */
        DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.

        /* Form Definition */
        FORM
           SKIP(1)
           m_filename VALIDATE( m_filename <> "", {&xxmscmex_p_2} ) LABEL {&xxmscmex_p_1}
        WITH FRAME a SIDE-LABELS TITLE "Master Commnets Extraction" WIDTH 80.

        {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

        /*Accepting the File Name */
        UPDATE m_filename  WITH FRAME a.

        /* Extracting the Data into the File */
        OUTPUT TO VALUE(m_filename).
           FOR EACH cd_det NO-LOCK :
               EXPORT DELIMITER ","
                           cd_ref
                           SUBSTRING(cd_type,1,2)
                           cd_lang
                           cd_seq
                           cd_cmmt.
            END. /* For Each cd_det */
        OUTPUT CLOSE.
