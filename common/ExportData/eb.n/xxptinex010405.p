/*xxptinex.p ---- Program to DownLoad Item Inventory Data  Master (1.4.5) - Eb                */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/*This program Extracts the Item Inventory Master Data from Mfg/Pro EB  into  .CSV File       */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxptinex.p                                                      */
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
               
               &SCOPED-DEFINE xxptinex_p_1  "Extraction File Name"
               &SCOPED-DEFINE xxptinex_p_2  "ERROR: Blank Filename Not Allowed"   
               

               /* Variable Declaration */
               DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.

               /* form Definition */
               FORM
               SKIP(1)
               m_filename   VALIDATE( m_filename <> "", {&xxptinex_p_2} ) LABEL {&xxptinex_p_1}
               WITH FRAME a SIDE-LABELS TITLE "Item Inventory Data Master Extraction" WIDTH 80.

               {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

               /*Accepting File Name */
               UPDATE m_filename  WITH FRAME a.

               /*Extracting the Data into the File */
               OUTPUT TO VALUE(m_filename).
	       EXPORT DELIMITER ","
                "pt_part"	 "pt_abc"	 "pt_lot_ser"	 "pt_site"	 "pt_loc"	 "pt_loc_type"	 "pt_auto_lot"	 "pt_lot_grp"	 "pt_article"	 "pt_avg_int"	 "pt_cyc_int"	 "pt_shelflife"	 "pt_sngl_lot"	 "pt_critical"	 "pt_rctpo_stat"	 "pt_rctpo_acti"	 "pt_rctwo_stat"	 "pt_rctwo_acti"	 "comd_comm_cod"	 "pt_ship_wt"	 "pt_ship_wt_um"	 "pt_fr_class"	 "pt_net_wt"	 "pt_net_wt_um"	 "pt_size"	 "pt_size_um."

               .

               FOR EACH pt_mstr NO-LOCK :
                   FIND FIRST comd_Det WHERE comd_part = pt_part NO-LOCK NO-ERROR.
                   IF AVAILABLE comd_Det THEN 
                   DO:
                     EXPORT DELIMITER ","
                           pt_part
                           pt_abc
                           pt_lot_ser
                           pt_site
                           pt_loc
                           pt_loc_type
                           pt_auto_lot
                           pt_lot_grp
                           pt_article
                           pt_avg_int
                           pt_cyc_int
                           pt_shelflife
                           pt_sngl_lot
                           pt_critical
                           pt_rctpo_status
                           pt_rctpo_active
                           pt_rctwo_status
                           pt_rctwo_active
                           comd_comm_code 
                           pt_ship_wt
                           pt_ship_wt_um
                           pt_fr_class
                           pt_net_wt
                           pt_net_wt_um
                           pt_size
                           pt_size_um.
                   END.
                   ELSE
                   DO:
                     EXPORT DELIMITER ","    
                           pt_part
                           pt_abc
                           pt_lot_ser
                           pt_site
                           pt_loc
                           pt_loc_type
                           pt_auto_lot
                           pt_lot_grp
                           pt_article
                           pt_avg_int
                           pt_cyc_int
                           pt_shelflife
                           pt_sngl_lot
                           pt_critical
                           pt_rctpo_status
                           pt_rctpo_active
                           pt_rctwo_status
                           pt_rctwo_active
                           "  "
                           pt_ship_wt
                           pt_ship_wt_um
                           pt_fr_class
                           pt_net_wt
                           pt_net_wt_um
                           pt_size
                           pt_size_um.
                     END.
                END. /* for each pt_mstr*/
               OUTPUT CLOSE.
