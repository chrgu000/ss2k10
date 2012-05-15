/*xxptsiex.p ---- Program to DownLoad Item Site Inventory Data (1.4.16)- Eb                   */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/*This program Extracts the Item site inventory  Data from Mfg/Pro EB into  .CSV File         */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxptsiex.p                                                      */
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : MAHESH K (TCSL)                            DATE:08/06/2005      */
/* REVISION                 : 01          LAST  MODIFIED BY: Mahesh K    DATE:10/06/2005      */
/**********************************************************************************************/



        {mfdtitle.i}

        &SCOPED-DEFINE xxptsiex_p_1  "Extraction File Name"
        &SCOPED-DEFINE xxptsiex_p_2  "ERROR: Blank Filename Not Allowed"   


        /* Variable Declaration */
        DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.

        /* Form Definition */
        FORM
           SKIP(1)
           m_filename  VALIDATE( m_filename <> "", {&xxptsiex_p_2} ) LABEL {&xxptsiex_p_1}
        WITH FRAME a SIDE-LABELS TITLE "Item Site Inventory Data Extraction" WIDTH 80.

        {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

        /*Accepting the File Name */
        UPDATE m_filename WITH FRAME a.

        /* Extracting the Data into the File */
        OUTPUT TO VALUE(m_filename).
           FOR EACH pt_mstr NO-LOCK , 
               EACH in_mstr WHERE in_part = pt_part NO-LOCK :
                  EXPORT DELIMITER ","
                            pt_part
                            in_site
                            in_abc
                            in_avg_int
                            in_cyc_int
                            in_rctpo_status
                            in_rctpo_active
                            in_rctwo_status
                            in_rctwo_active.                         
          END. /* For Each pt_mstr */
        OUTPUT CLOSE.
