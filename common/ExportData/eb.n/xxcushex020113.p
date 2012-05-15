/*xxcushex.p ---- Program to DownLoad Customer Ship To Master (2.1.13) - Eb2                  */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/* This program Extracts the Customer Ship-to Master data from Mfg/Pro EB2 into  .CSV File    */
/**********************************************************************************************/
/* POCEDUE NAME             : xxcushex.p                                                      */          
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

        &SCOPED-DEFINE xxcushex_p_1  "Extraction File Name"
        &SCOPED-DEFINE xxcushex_p_2  "ERROR: Blank Filename Not Allowed"   

        /* Variable Declaration */
        DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.
        DEFINE VARIABLE m_incity   AS LOGICAL    NO-UNDO.

        /* Form Definition */
        FORM
           SKIP(1)
           m_filename VALIDATE( m_filename <> "", {&xxcushex_p_2}) LABEL {&xxcushex_p_1}
        WITH FRAME a SIDE-LABELS TITLE "Customer Ship To Code Extraction" WIDTH 80.

        {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

        /*Accepting the File Name */
        UPDATE m_filename  WITH FRAME a.

        /* Extracting the Data into the File */
        OUTPUT TO VALUE(m_filename).
                    EXPORT DELIMITER ","
 "cm_addr"	 "ad_addr"	 "ad_temp"	 "ad_name"	 "ad_line1"	 "ad_line2"	 "ad_line3"	 "ad_city"	 "ad_state"	 "ad_zip"	 "ad_format"	 "ad_ctry"	 "ad_county"	 "ad_attn"	 "ad_phone"	 "ad_ext"	 "ad_fax"	 "ad_attn2"	 "ad_phone2"	 "ad_ext2"	 "ad_fax2"	 "ad_lang"	 "ad_sort"	 "ad_taxable"	 "ad_tax_zone"	 "ad_taxc"	 "ad_tax_usage"	 "ad_tax_in"	 "ad_gst_id"	 "ad_pst_id"	 "ad_misc1_id"	 "ad_misc2_id"	 "ad_misc3_id"	 "m_incity."

.
           FOR EACH cm_mstr NO-LOCK ,
               EACH ad_mstr WHERE ad_ref = cm_addr 
                              AND ad_type = "ship-to" NO-LOCK :            
                    IF ad__qad01 = "1"  THEN m_incity = YES.
                    ELSE m_incity = NO.

                    EXPORT DELIMITER ","
                              cm_addr
		              ad_addr
		              ad_temp
                              ad_name
                              ad_line1
                              ad_line2
                              ad_line3
                              ad_city
                              ad_state
                              ad_zip
                              ad_format
                              ad_ctry
                              ad_county
                              ad_attn
                              ad_phone
                              ad_ext
                              ad_fax
                              ad_attn2
                              ad_phone2
                              ad_ext2
                              ad_fax2
                              ad_lang 
                              ad_sort 
                              ad_taxable
                              ad_tax_zone
                              ad_taxc
                              ad_tax_usage
                              ad_tax_in
                              ad_gst_id
                              ad_pst_id
                              ad_misc1_id
                              ad_misc2_id
                              ad_misc3_id
                              m_incity.                            	  			 
               END. /* For Each cm_mstr */
        OUTPUT CLOSE.
