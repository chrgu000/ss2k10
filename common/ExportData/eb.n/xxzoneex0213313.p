/*xxuomex.p ----  Program to DownLoad Zone Maintenance (2.13.3.13)     Eb                    */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/*This program Extracts the Unit of Measure Master from Mfg/Pro EB  into  .CSV File           */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxuomex.p                                                       */
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
        WITH FRAME a SIDE-LABELS TITLE "Zone Maintance" WIDTH 80.

       {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

        /*Accepting the File Name */
        UPDATE m_filename  WITH FRAME a.

        /* Extracting the Data into the File */
        OUTPUT TO VALUE(m_filename).
          EXPORT DELIMITER ","
           "txz_tax_zone"	 "txz_desc"	 "txz_ctry_code"

	  .
           FOR EACH txz_mstr NO-LOCK : 
                  EXPORT DELIMITER ","
                             txz_tax_zone
                             txz_desc
                             txz_ctry_code .               
           END. /* For Each uom_mstr */
        OUTPUT CLOSE.
