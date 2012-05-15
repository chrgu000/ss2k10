/*xxusrex.p ---- Program to DownLoad User Code Master (36.3.18) -       Eb                    */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/*This program Extracts the User Code  Master from Mfg/Pro EB  into  .CSV File                */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxusrex.p                                                       */
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : Sachin P (TCSL)                            DATE:10/06/2005      */
/* REVISION                 : 01          LAST  MODIFIED BY: Sachin P    DATE:10/06/2005      */
/* REVISION                 : 02          LAST  MODIFIED BY: MAHESH K    DATE:05/08/2005      */
/*                          : ECO# MK001 Modified for Eb version Compatibility                */
/* REVISION                 : 02          LAST  MODIFIED BY: MAHESH K    DATE:31/08/2005      */
/*                          : ECO# MK002 Modified for Eb version Compatibility                */
/**********************************************************************************************/

        {mfdtitle.i}

        &SCOPED-DEFINE xxusrex_p_1  "Extraction File Name"
        &SCOPED-DEFINE xxusrex_p_2  "ERROR: Blank Filename Not Allowed" 
        DEFINE VARIABLE m_ctry_code  AS CHAR            FORMAT "X(3)"    NO-UNDO. 
        DEFINE VARIABLE m_timezone   AS CHAR            FORMAT "X(8)"    NO-UNDO.
        DEFINE VARIABLE m_product    AS CHAR            FORMAT "X(12)"   NO-UNDO.


        /* Variable Declaration */
        DEFINE VARIABLE m_filename   AS CHARACTER       FORMAT "x(40)"   NO-UNDO.
        DEFINE VARIABLE menusub      AS LOGICAL                          NO-UNDO. 
      
        /* Form Definition */
        FORM
           SKIP(1)
           m_filename VALIDATE(m_filename <> "", {&xxusrex_p_2} )  LABEL {&xxusrex_p_1}
        WITH FRAME a SIDE-LABELS TITLE "User Code Extraction" WIDTH 80.

        {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

        
        /*Accepting the File Name */
        UPDATE m_filename  WITH FRAME a.

        /*MK001*/
        FIND FIRST CODE_mstr WHERE CODE_FLDNAME = "xx_ctry" 
                                         AND CODE_VALUE   = "COUNTRY" 
                                         NO-LOCK NO-ERROR.
        IF NOT AVAILABLE CODE_mstr THEN DO: 
             {pxmsg.i &MSGNUM = 9011 &ERRORLEVEL = 1}
             UNDO,RETRY.
        END.

        FIND FIRST CODE_mstr WHERE CODE_FLDNAME = "xx_timezone" 
                                         AND CODE_VALUE   = "TIMEZONE" 
                                         NO-LOCK NO-ERROR.
        IF NOT AVAILABLE CODE_mstr THEN DO: 
             {pxmsg.i &MSGNUM = 9012 &ERRORLEVEL = 1}
             UNDO,RETRY.
        END.

        FIND FIRST CODE_mstr WHERE CODE_FLDNAME = "xx_product" 
                                         AND CODE_VALUE   = "PRODUCT" 
                                         NO-LOCK NO-ERROR.
        IF NOT AVAILABLE CODE_mstr THEN DO: 
             {pxmsg.i &MSGNUM = 9013 &ERRORLEVEL = 1}
             UNDO,RETRY.
        END.
        /*MK001*/


        /* Extracting the Data into the File */
        OUTPUT TO VALUE(m_filename).
           FOR EACH usr_mstr NO-LOCK,
               EACH uip_mstr WHERE uip_userid = usr_userid NO-LOCK 
/*MK001*/      /*,EACH usrl_det WHERE usrl_userid = usr_userid NO-LOCK */  :

/*MK001*/         FIND FIRST CODE_mstr WHERE CODE_FLDNAME = "xx_ctry" 
                                         AND CODE_VALUE   = "COUNTRY" 
                                         NO-LOCK NO-ERROR.
                  IF AVAILABLE CODE_mstr THEN m_ctry_code = CODE_cmmt.
                  

                  FIND FIRST   CODE_mstr WHERE CODE_FLDNAME = "xx_timezone" 
                                         AND CODE_VALUE   = "TIMEZONE" 
                                         NO-LOCK NO-ERROR.
                  IF AVAILABLE CODE_mstr THEN m_timezone  = CODE_cmmt.

                  FIND FIRST CODE_mstr WHERE CODE_FLDNAME = "xx_product" 
                                         AND CODE_VALUE   = "PRODUCT" 
                                         NO-LOCK NO-ERROR.
/*MK001*/         IF AVAILABLE CODE_mstr THEN m_product   = CODE_cmmt.

                 

                  IF uip__qad01 = "TRUE" THEN menusub = YES.
                  ELSE menusub = NO.

                  EXPORT DELIMITER ","
                          usr_userid
                          usr_name
                          usr_lang
/*MK001*/                 m_ctry_code  /*usr_ctry_code*/
/*MK001*/                 "  "         /*usr_variant_code*/
                          usr_passwd
/*MK001*/                 "employee"   /*usr_type*/
                          usr_restrict
/*MK001*/                 m_timezone   /*usr_timezone*/
/*MK001*/                 "primary"    /*usr_access_loc*/
                          usr_mail_address
                          usr__qad02
                          uip_style
                          uip_hypertext_help
                          menusub
                          usr_groups
/*MK001*/                 m_product    /*usrl_product*/
/*MK001*/                 "yes"        /*usrl_active.*/.
           END. /* For Each usr_mstr */
        OUTPUT CLOSE.
