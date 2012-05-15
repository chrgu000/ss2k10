/*xxacctex.p ---- Program to DownLoad Account  Master (25.3.13) Eb                           */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/* This program Extracts the Account  Master Data from Mfg/Pro EB2 into  .CSV File            */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxacctex.p                                                      */  
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : SACHIN P (TCSL)                            DATE: 01/06/2005     */
/* REVISION                 : 01          LAST  MODIFIED BY: Sachin P    DATE: 10/06/2005     */
/* REVISION                 : 02          LAST  MODIFIED BY: Sachin P    DATE: 24/06/2005     */
/* REVISION                 : 03  *MK03*  LAST  MODIFIED BY: Sachin P    DATE: 04/07/2005     */
/**********************************************************************************************/

        
        {mfdtitle.i}

        &SCOPED-DEFINE xxacctex_p_1  "Extraction File Name"
        &SCOPED-DEFINE xxacctex_p_2  "ERROR: Blank Filename Not Allowed"    
            
        /* Variable Declaration */
        DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.

        /* Form Definition */
        FORM
           SKIP(1)
           m_filename VALIDATE( m_filename <> "", {&xxacctex_p_2}) LABEL {&xxacctex_p_1}
        WITH FRAME a SIDE-LABELS TITLE "Account Master Extraction" WIDTH 80.

        {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

        /*Accepting the File Name */
        UPDATE m_filename  WITH FRAME a.

        /* Extracting the Data into the File */
        OUTPUT TO VALUE(m_filename).
               EXPORT DELIMITER ","
					 "ac_code"	 "ac_desc"	 "ac_type"	 "ac_curr"	 "ac_fpos"	 "ac__chr01"	 "ac__log01"	 "ac_modl_only"	 "ac_stat_acc"	 "ac_active"	 "ac_fx_index" .


           FOR EACH ac_mstr NO-LOCK :
               EXPORT DELIMITER ","
                                ac_code
                                ac_desc
                                ac_type
                                ac_curr
                                ac_fpos
                                ac__chr01                                                             /*MK03*/
                                ac__log01                                                             /*MK03*/                                                                        
                                ac_modl_only
                                ac_stat_acc
                                ac_active
                                ac_fx_index.

           END. /* For Each ac_mstr */
        OUTPUT CLOSE.
