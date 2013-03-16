/*xxcalex.p ----  Program to DownLoad Calender (25.3.4)     Eb                    */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/*This program Extracts the Unit of Measure Master from Mfg/Pro EB  into  .CSV File           */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxcalex250304.p                                                       */
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : Mahesh K (TCSL)                            DATE:10/06/2005      */
/* REVISION                 : 01          LAST  MODIFIED BY: Mahesh K    DATE:10/06/2005      */
/**********************************************************************************************/

        {mfdtitle.i}

        &SCOPED-DEFINE xxuomex_p_1  "Extraction File Name"
        &SCOPED-DEFINE xxuomex_p_2  "ERROR: Blank Filename Not Allowed"   
        
            
        /* Variable Declaration */
        DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.

        /* Form Definition */
        FORM
           SKIP(1)
           m_filename VALIDATE( m_filename <> "", {&xxuomex_p_2} ) LABEL {&xxuomex_p_1}
        WITH FRAME a SIDE-LABELS TITLE "Calender" WIDTH 80.

       {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

        /*Accepting the File Name */
        UPDATE m_filename  WITH FRAME a.

        /* Extracting the Data into the File */
        OUTPUT TO VALUE(m_filename).
          EXPORT DELIMITER ","
 "glc_year"  "glc_per" "glc_start"  "glc_end"
 .
        for each glc_cal :
	          EXPORT DELIMITER ","
                  glc_year glc_per glc_start  glc_end .
        end.




        OUTPUT CLOSE.