/*****************************************************************************/
/* xxmrppex.p --- MRP % Extraction Routine                                   */
/* COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/* V8:ConvertMode=Maintanance                                                */
/* V8:WebEnabled=Yes                                                         */
/* V8:RunMode=Character,Windows                                              */
/* This program is developed for Korea customized module. but this program   */
/* can be used in all the sites, as this is a master data extraction routine.*/
/* This program extract the MRP % of for PO.                                 */
/*****************************************************************************/
/* PROCEDURE NAME           : xxmrppex.p                                     */
/* PROCEDURE TYPE           : Process                                        */
/* DESCRIPTION              : Extraction Routine                             */
/* INCLUDE FILES            :                                    	     */
/* CALLED BY                :                                                */
/* CALLED PROCEDURES        :                                                */
/* USER DEFINED FUNCTIONS   :                                                */
/*****************************************************************************/
/* CREATED BY               : Anurag J (TCSL)            DATE: 27/02/2006    */
/* REVISION:  LAST MODIFIED :          ECO:              DATE:               */
/*****************************************************************************/

{mfdtitle.i}

&SCOPED-DEFINE xxmrppex_p_1  "Extraction File Name"
&SCOPED-DEFINE xxmrppex_p_2  "ERROR: Blank Filename Not Allowed"   

/*--Variable Declaration--*/
DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.
DEFINE VARIABLE m_adjtype  AS CHARACTER FORMAT "x(1)"  NO-UNDO.

/*--form Definition--*/
FORM
   SKIP(1)
   m_filename VALIDATE( m_filename <> "", {&xxmrppex_p_2} ) LABEL {&xxmrppex_p_1}
WITH FRAME a SIDE-LABELS TITLE "Schedule Order MRP % Extraction" WIDTH 80.

{pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

/*--Accepting File Name--*/
UPDATE 
   m_filename 
WITH FRAME a.

/*--Extracting the Data into the file--*/
OUTPUT TO VALUE(m_filename).
   EXPORT DELIMITER ","
 "qad_key1"	 "qad_key2"	 "qad_key3"	 "qad_key4"	 "qad_key5"	 "qad_charfld[1]"	 "qad_charfld[2]"	 "qad_charfld[3]"	 "qad_datefld[1]"	 "qad_decfld[1]."

   .
FOR EACH qad_wkfl NO-LOCK
   WHERE qad_key1 = "poa_det":

   EXPORT DELIMITER ","
      qad_key1           /*--Key1 "poa_det"--*/
      qad_key2           /*--site + part + YYYYMMDD + po nbr--*/
      qad_key3           /*--poa_det--*/
      qad_key4           /*--po nbr + part + site + YYYYMMDD(eff date)--*/
      qad_key5           /*--""--*/
      qad_charfld[1]     /*--PO Nbr--*/
      qad_charfld[2]     /*--Part--*/
      qad_charfld[3]     /*--Site--*/
      qad_datefld[1]     /*--Eff Date--*/
      qad_decfld[1].     /*--MRP %--*/
END.
OUTPUT CLOSE.

