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

     define input parameter nbr as character.
     define input parameter prod_site like lad_site.
     define input parameter loc-to like loc_loc.
     define input parameter picked like mfc_logical.
/*mage*/     define input parameter ponbr as character.

     define shared variable mfguser as character.  /* Avoid mfdeclre.i */

     define variable ord_max like pt_ord_max no-undo.
     define variable comp_max like lad_qty_chg no-undo.
     define variable tot_chg like lad_qty_chg no-undo.
     define variable ord_mult like pt_ord_mult no-undo.
     define variable desc1    like pt_desc1 no-undo.

/*mage*/ define  shared TEMP-TABLE trhist1 
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


     for each sr_wkfl exclusive-lock  where sr_wkfl.sr_domain = global_domain
     and  sr_userid = mfguser:
        delete sr_wkfl.
     end.

     for each trhist1
          where trhist1.tr1_domain = global_domain
      and tr1__log01 = no
       and tr1_qty_loc <> tr1__dec01 
         no-lock:

           find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
           tr1_part no-lock no-error.
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
/*mage           sr_user1 = xic_nbr.
           sr_rev = xic_loc_to. 
           sr_user2 = tr_part. */
/*mage */  sr_user1 = tr1_lot.
           sr_rev = string(tr1_line). 
           sr_user2 = tr1_part.
           if recid(sr_wkfl) = -1 then .

     end. /* For each xic_det */


/*ss-min001
     for each lad_det  where lad_det.lad_domain = global_domain and
     lad_dataset = "rps_det" and lad_nbr = nbr
      break by lad_dataset by lad_nbr by lad_line by lad_part:

        if first-of(lad_part) then do:
           ord_mult = 0.
           ord_max = 0.
           find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
           lad_part no-lock no-error.
           if available pt_mstr then
              assign ord_mult = pt_ord_mult
                 ord_max = pt_ord_max.
           find ptp_det  where ptp_det.ptp_domain = global_domain and  ptp_part
           = lad_part and ptp_site = prod_site
            no-lock no-error.
           if available ptp_det then
              assign ord_mult = ptp_ord_mult
                 ord_max = ptp_ord_max.
           tot_chg = 0.
           comp_max = 0.
           if lad_user2 <> "" then
              comp_max = decimal(lad_user2).
        end.

        lad_qty_chg = 0.
        if ord_max <> 0 then do:
           if alloc then
              lad_qty_chg = min(lad_qty_all,ord_max).
           if picked then
              lad_qty_chg = min(lad_qty_chg + lad_qty_pick,ord_max).
        end.
        else do:
           if alloc then
              lad_qty_chg = lad_qty_all.
           if picked then
              lad_qty_chg = lad_qty_chg + lad_qty_pick.
        end.

        if comp_max <> 0 then do:
           lad_qty_chg = min(lad_qty_chg,comp_max).
        end.

        if ord_max <> 0 or comp_max <> 0 then
           lad_qty_chg = min(lad_qty_chg, max(
              min(if ord_max <> 0 then ord_max else comp_max,
          if comp_max <> 0 then comp_max else ord_max)
          - tot_chg,0)).

        if ord_mult <> 0 then do:
           if lad_qty_chg / ord_mult <> truncate(lad_qty_chg / ord_mult,0)
           then lad_qty_chg = min(
              truncate(lad_qty_chg / ord_mult + .9999999999,0) * ord_mult,
              (if alloc then lad_qty_all else 0) +
              (if picked then lad_qty_pick else 0)).
        end.

        tot_chg = tot_chg + lad_qty_chg.

        if lad_qty_chg <> 0 then do:
           create sr_wkfl. sr_wkfl.sr_domain = global_domain.
           assign sr_userid = mfguser
           sr_lineid = string(lad_line,"x(8)") + "::" + lad_part
           sr_site = lad_site
           sr_loc = lad_loc
           sr_lotser = lad_lot
           sr_qty = lad_qty_chg.
           sr_ref = lad_ref.
           sr_user1 = lad_user1.
           sr_rev = lad_line.
           sr_user2 = lad_part.
           if recid(sr_wkfl) = -1 then . /* Oracle DataServer compat. */
        end.

     end. /* For each lad_det */
*/