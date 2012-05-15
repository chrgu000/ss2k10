/*xxuomex.p ----  Program to DownLoad Unit Of Fixed Asset (32.1)     Eb                    */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/*This program Extracts the Unit of Measure Master from Mfg/Pro EB  into  .CSV File           */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxfaex3201.p                                                       */
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
        WITH FRAME a SIDE-LABELS TITLE "FIXED ASSET-01" WIDTH 80.

       {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

        /*Accepting the File Name */
        UPDATE m_filename  WITH FRAME a.

        /* Extracting the Data into the File */
        OUTPUT TO VALUE(m_filename).
          EXPORT DELIMITER ","
 "fa_id"	 "fa_desc"	 "fa_facls_id"	 "fa_faloc_id"	 "fa_startdt"	 "fa_mstr.fa_puramt"	 "fa_mstr.fa_salvamt"	 "fa_mstr.fa_replamt"	 "fa_mstr.fa_qty"	 "fa_mstr.fa_dep"	 "fa_mstr.fa_auth_number" "fab_fabk_id"	 "fab_ovramt"
  .
        for each fa_mstr no-lock ,
            each fab_det no-lock where fa_id = fab_fa_id :
            find last fabd_det where fabd_fa_id = fab_fa_id and fabd_fabk_id = fab_fabk_id and fab_fabk_id = "TRW" no-lock no-error.
            if available fabd_det then do:
               EXPORT DELIMITER ","

		fa_id
		fa_desc
		fa_facls_id
		fa_faloc_id
		fa_startdt
		fa_mstr.fa_puramt
		fa_mstr.fa_salvamt
		fa_mstr.fa_replamt
		fa_mstr.fa_qty
		fa_mstr.fa_dep
		fa_mstr.fa_auth_number   /*ADD*/
		fab_fabk_id
                fab_ovramt 
		fab_life.


            end.
        end.



        OUTPUT CLOSE.
