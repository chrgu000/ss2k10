/*xxpop2ex.p ---- Program to DownLoad Po Price List  Master (1.10.2.1) -    Eb                */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/*This program Extracts the Po Price List  Master Data from Mfg/Pro EB  into  .CSV File       */
/* Parameters : Amount Type = "L"                                                             */              
/**********************************************************************************************/
/* PROCEDURE NAME           : xxpop2ex.p                                                      */
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : SACHIN P (TCSL)                            DATE:07/06/2005      */
/* REVISION                 : 01          LAST  MODIFIED BY: Sachin P    DATE:10/06/2005      */
/* REVISION                 : 02          LAST  MODIFIED BY: Mahesh K    DATE:13/06/2005      */
/**********************************************************************************************/




        {mfdtitle.i}
        
        &SCOPED-DEFINE xxpop2ex_p_1  "Extraction File Name"
        &SCOPED-DEFINE xxpop2ex_p_2  "ERROR: Blank Filename Not Allowed"   

        /* Variable Declaration */
        DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.

        /* Form Definition */
        FORM
           SKIP(1)
           m_filename VALIDATE( m_filename <> "", {&xxpop2ex_p_2} )  LABEL {&xxpop2ex_p_1}
        WITH FRAME a SIDE-LABELS TITLE "Po Price List Extraction" WIDTH 80.

        {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

        /*Accepting the File Name */
        UPDATE m_filename WITH FRAME a.

        /* Extracting the Data into the File */
        OUTPUT TO VALUE(m_filename).

        /* Amount Type = "L" */
           FOR EACH pc_mstr WHERE pc_amt_type = "L" NO-LOCK : 
                  EXPORT DELIMITER ","
                          pc_list
                          pc_curr
                          pc_prod_line
                          pc_part
                          pc_um
                          pc_start
                          pc_expire
                          pc_amt_type
                          pc_amt[1]
                          pc_min_price
                          pc_max_price[1].
                         
                          
           END. /* For Each pc_mstr */
        OUTPUT CLOSE.
