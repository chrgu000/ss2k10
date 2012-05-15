/*xxptdtex.p ---- Program to DownLoad Item Data Master (1.4.3)  -       Eb                    */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/*This program Extracts the Item Data  from Mfg/Pro EB  into  .CSV File                       */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxptdtex.p                                                      */
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : Sachin P (TCSL)                            DATE:08/06/2005      */
/* REVISION                 : 01          LAST  MODIFIED BY: Sachin P    DATE:10/06/2005      */
/**********************************************************************************************/



        {mfdtitle.i}

        &SCOPED-DEFINE xxptdtex_p_1  "Extraction File Name"
        &SCOPED-DEFINE xxptdtex_p_2  "ERROR: Blank Filename Not Allowed"   


        /* Variable Declaration */
        DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.

        /* Form Definition */
        FORM
           SKIP(1)
           m_filename VALIDATE( m_filename <> "", {&xxptdtex_p_2} ) LABEL {&xxptdtex_p_1}
        WITH FRAME a SIDE-LABELS TITLE "Item Data Extraction" WIDTH 80.

        {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

        /*Accepting the File Name */
        UPDATE m_filename  WITH FRAME a.

        /* Extracting the Data into the File */
        OUTPUT TO VALUE(m_filename).
           FOR EACH pt_mstr NO-LOCK : 
                  EXPORT DELIMITER ","
                          pt_part
                          pt_um
                          pt_desc1
                          pt_desc2
                          pt_prod_line
                          pt_added
                          pt_dsgn_grp
                          pt_promo    
                          pt_part_type
                          pt_status
                          pt_group 
                          pt_draw 
                          pt_rev
                          pt_drwg_loc
                          pt_drwg_size
                          pt_break_cat.
           END. /* For Each pt_mstr */
        OUTPUT CLOSE.
