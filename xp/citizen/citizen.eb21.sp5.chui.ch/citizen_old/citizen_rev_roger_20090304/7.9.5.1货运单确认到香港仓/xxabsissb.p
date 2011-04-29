/* repkisb.p - REPETITIVE PICKLIST ISSUE regen sr_wkfl subroutine.          */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=Maintenance                                                */
/*K1Q4*/
/* Revision: 7.4  Created: 05/01/96 after F0TC from repkis.p                */
/*                                                 05/01/96   BY: jzs *H0KR**/
/* Revision: 8.6 MODIFIED: 05/20/98 BY: *K1Q4* Alfred Tan                   */
/* Revision: 9.1 MODIFIED: 08/12/00 BY: *N0KP* myb                          */
/* $Revision: 1.3.1.3 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/* $Revision: 1.18.2.13 $ BY: Apple Tam DATE: 03/15/06 ECO: *SS-MIN001*     */
/*-Revision end---------------------------------------------------------------*/


{mgdomain.i}
     define shared variable mfguser as character.  /* Avoid mfdeclre.i */

     define variable desc1    like pt_desc1 no-undo.


     define  shared TEMP-TABLE trhist1 
       fields tr1_domain  like tr_domain  
       fields tr1_site    like tr_site    
       fields tr1_trnbr   like tr_trnbr 
       fields tr1_part    like tr_part
       fields tr1_nbr     like tr_nbr     
       fields tr1_line    like tr_line    
       fields tr1_lot     like tr_lot     
       fields tr1_serial  like tr_serial  
       fields tr1_ref     like tr_ref     
       fields tr1_loc     like tr_loc     
       fields tr1_qty_loc like tr_qty_loc 
       fields tr1__dec01  like tr__dec01  
       fields tr1__log01  like tr__log01
       fields tr1_chg     like tr_qty_loc
       fields tr1_loc_to     like tr_loc 
       INDEX tr1_nbr IS PRIMARY tr1_nbr tr1_line tr1_trnbr
       INDEX tr1_part  tr1_part tr1_nbr tr1_line.


     for each sr_wkfl exclusive-lock  where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser:
        delete sr_wkfl.
     end.

    for each trhist1
        where trhist1.tr1_domain = global_domain
        no-lock:

           find pt_mstr  
				where pt_mstr.pt_domain = global_domain 
				and  pt_part = tr1_part 
		   no-lock no-error.
           if available pt_mstr then
              assign desc1 = pt_desc1.


           create sr_wkfl. sr_wkfl.sr_domain = global_domain.
           assign sr_userid = mfguser
			   sr_lineid = string(tr1_line) + "::" + tr1_part
			   sr_site = tr1_site	
			   sr_loc = tr1_loc
			   sr_lotser = tr1_serial
			   sr_qty = tr1_chg.
			   sr_ref = tr1_ref.
			   sr_user1 = tr1_nbr.
			   sr_rev = string(tr1_line). 
			   sr_user2 = tr1_part.
           if recid(sr_wkfl) = -1 then .

     end. /* For each  */


