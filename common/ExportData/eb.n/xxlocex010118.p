/*xxlocex.p ---- Program to DownLoad Location  Master (1.1.18) Eb                             */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/* This program Extracts the Location Master Data from Mfg/Pro EB  into  .CSV File            */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxlocex.p                                                       */          
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : SACHIN P (TCSL)                            DATE:03/06/2005      */
/* REVISION                 : 01          LAST  MODIFIED BY: Sachin P    DATE:10/06/2005      */
/* REVISION                 : 03          LAST  MODIFIED BY: Sachin P    DATE:13/07/2005      */ 
/*                          : ECO# SP001 Modified for Eb version Compatibility                */       
/**********************************************************************************************/


        {mfdtitle.i}

        &SCOPED-DEFINE xxlocex_p_1  "Extraction File Name"
        &SCOPED-DEFINE xxlocex_p_2  "ERROR: Blank Filename Not Allowed"   


        /* Variable Declaration */
        DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.

        /* Form Definition */
        FORM
           SKIP(1)
           m_filename VALIDATE( m_filename <> "", {&xxlocex_p_2} ) LABEL {&xxlocex_p_1}
        WITH FRAME a SIDE-LABELS TITLE "Location Master Extraction" WIDTH 80.

        {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

        /* Accepting the File Name */
        UPDATE m_filename  WITH FRAME a.

        /* Extracting the Data into the File */
        OUTPUT TO VALUE(m_filename).
                  EXPORT DELIMITER ","
	 "loc_site"	 "loc_loc"	 "loc_desc"	 "loc_status"	 "loc_project"	 "loc_date"	 "loc_perm"	 "loc_type"	 "loc_single"	 "loc__qad01"	 "loc_cap"	 "loc_cap_um"
.

           FOR EACH loc_mstr NO-LOCK: 
               
/*SP001*/      /* FIND FIRST locc_det WHERE locc_site = loc_site 
                                     AND locc_loc  = loc_loc 
               NO-LOCK  NO-ERROR.
               IF AVAILABLE locc_det THEN DO :
               
                  FOR EACH locc_det WHERE locc_site = loc_site 
                                     AND  locc_loc  = loc_loc NO-LOCK :
                      EXPORT DELIMITER ","
                            loc_site
                            loc_loc
                            loc_desc
                            loc_status
                            loc_project
                            loc_date
                            loc_perm
                            loc_type
                            loc_single
                            loc__qad01
                            loc_cap
                            loc_cap_um
                            "Yes"
                            locc_addr
                            locc_primary_loc.
                  END. /* For Each locc_det */
               END. */  /* IF available locc_det */
              /* ELSE DO : */
                  EXPORT DELIMITER ","
                            loc_site
                            loc_loc
                            loc_desc
                            loc_status
                            loc_project
                            loc_date
                            loc_perm
                            loc_type
                            loc_single
                            loc__qad01
                            loc_cap
                            loc_cap_um
                            "No".
               /* END. */  /* IF NOT AVBL locc_det */
           END. /* For Each loc_mstr */
        OUTPUT CLOSE.
