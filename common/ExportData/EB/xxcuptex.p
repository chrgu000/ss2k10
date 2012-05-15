/*xxcuptex.p ---- Program to Customer Item Maintenance - (1.16 )     Eb                       */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/*This program Extracts the Customer Item Master from Mfg/Pro EB  into  .CSV File             */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxcuptex.p                                                      */
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : Sachin P (TCSL)                            DATE:10/06/2005      */
/* REVISION                 : 01          LAST  MODIFIED BY: Mahesh K    DATE:10/06/2005      */
/**********************************************************************************************/


        {mfdtitle.i}

        &SCOPED-DEFINE xxcuptex_p_1  "Extraction File Name"
        &SCOPED-DEFINE xxcuptex_p_2  "ERROR: Blank Filename Not Allowed"   

        /* Variable Declaration */
        DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.

        /* Form Definition */
        FORM
           SKIP(1)
           m_filename VALIDATE( m_filename <> "", {&xxcuptex_p_2} ) LABEL {&xxcuptex_p_1}
        WITH FRAME a SIDE-LABELS TITLE "Customer Item Data Extraction" WIDTH 80.

        {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

        /*Accepting the File Name */
        UPDATE m_filename  WITH FRAME a.

        /* Extracting the Data into the File */
        OUTPUT TO VALUE(m_filename).
           FOR EACH cp_mstr NO-LOCK : 
               
                  EXPORT DELIMITER ","
                          cp_cust
                          cp_cust_part
                          cp_part
                          cp_comment
                          cp_cust_partd
                          cp_cust_eco.
                          
                            
           END. /* For Each cp_mstr */
        OUTPUT CLOSE.
