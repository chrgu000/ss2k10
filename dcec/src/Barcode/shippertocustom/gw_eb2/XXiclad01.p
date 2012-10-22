/* GUI CONVERTED from iclad01.p (converter v1.78) Fri Oct 29 14:33:29 2004 */
/* iclad01.p - PROGRAM TO UPDATE lad_det MULTI LINE ENTRY                     */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.13 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 6.0      LAST MODIFIED: 05/29/90   BY: emb *D025* */
/* REVISION: 6.0      LAST MODIFIED: 07/02/91   BY: emb *D744* */
/* REVISION: 6.0      LAST MODIFIED: 10/03/91   BY: alb *D887**/
/* REVISION: 6.0      LAST MODIFIED: 11/11/91   BY: emb *D920**/
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: pma *F190*                */
/* Revision: 7.3        Last edit: 09/27/93             By: jcd *G247*        */
/* REVISION: 7.3      LAST MODIFIED: 02/08/93   BY: emb *G656*                */
/* REVISION: 7.3      LAST MODIFIED: 04/11/94   BY: ais *FM98*                */
/* REVISION: 7.3      LAST MODIFIED: 06/20/94   BY: pxd *FP02*                */
/* REVISION: 7.3      LAST MODIFIED: 11/15/94   BY: pxd *FT72*                */
/* REVISION: 8.5      LAST MODIFIED: 11/22/94   BY: taf *J038*                */
/* REVISION: 7.3      LAST MODIFIED: 08/24/95   BY: dzs *G0SY*                */
/* REVISION: 7.2      LAST MODIFIED: 08/17/95   BY: qzl *F0TC*                */
/* REVISION: 8.5      LAST MODIFIED: 07/01/96   BY: *G1Z1* Julie Milligan     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/23/00   BY: *M0L8* Jyoti Thatte       */
/* REVISION: 9.1      LAST MODIFIED: 09/05/00   BY: *N0RF* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0K2* Phil DeRogatis     */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.13 $    BY: Jean Miller          DATE: 04/06/02  ECO: *P056*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define shared variable wod_recno as recid.
define shared variable total_lotserial_qty like wod_qty_chg.
DEF VAR MSTR AS CHAR.
DEF SHARED VAR PATH1 AS CHAR FORMAT "X(20)".
define variable lad_recno as recid.
define variable qty_entered like lad_qty_chg.
define variable um like pt_um.

define variable yn like mfc_logical.
define variable frametitle as character no-undo.

find wod_det no-lock where recid(wod_det) = wod_recno.

find wo_mstr no-lock where wo_lot = wod_lot.
find pt_mstr no-lock where pt_part = wod_part no-error.

if available pt_mstr then um = pt_um.

repeat:
/*GUI*/ if global-beam-me-up then undo, leave.
IF path1 <> '' THEN DO:
                                 
                  for each lad_det no-lock where
            lad_dataset = "wod_det"
        and lad_nbr = wod_lot and lad_line = string(wod_op)
        and lad_part = wod_part:
      LAD_QTY_CHG = 0.
   end.                        
    
    INPUT FROM VALUE(path1). 
                                       
                                       REPEAT:
                                           mstr = ''.
                                           IMPORT DELIMITER ";" mstr.
                                           IF mstr <> '' AND SUBSTR(mstr,17,18) = WOD_PART THEN DO:
                                          
                                          /* FIND FIRST sr_wkfl where sr_userid = mfguser
                                            and sr_lineid = cline
                                            and sr_site = SUBSTR(mstr,1,8)
                                            and sr_loc = SUBSTR(mstr,9,8)
                                            AND sr_lotser = SUBSTR(mstr,35,18)
                                               AND sr_ref = SUBSTR(mstr,53,8) AND sr_qty = DECIMAL(SUBSTR(mstr,61,8))
                                           
                                                NO-LOCK NO-ERROR.*/
                                           /*IF  NOT AVAILABLE sr_wkfl THEN DO:*/
                                         FIND FIRST LD_DET WHERE LD_SITE = SUBSTR(mstr,1,8) AND LD_LOC = SUBSTR(mstr,9,8) AND LD_LOT = SUBSTR(mstr,35,18)
                                             AND LD_REF = SUBSTR(mstr,53,8) AND LD_QTY_OH = DECIMAL(SUBSTR(mstr,61,8)) NO-LOCK NO-ERROR.
                                         IF AVAILABLE LD_DET THEN DO:
                                      
                                           FIND FIRST lad_det where lad_dataset = "wod_det"
/*G656*                       and lad_nbr = wod_nbr and lad_line = wod_lot */
/*G656*/                      and lad_nbr = wod_lot
/*G656*/                      and lad_line = string(wod_op)
                              and lad_part = wod_part  AND lad_lot = ld_lot AND lad_ref = ld_ref AND lad_site = ld_site AND lad_loc = ld_loc  EXCLUSIVE-LOCK NO-ERROR.
                                    IF NOT AVAILABLE lad_det THEN DO:  
                                        CREATE lad_det.
                                    
                                        
                                        lad_nbr = wod_lot.
                                 lad_dataset = "wod_det".
                                 lad_line = STRING(wod_op).
                                 lad_part = wod_part.
                                  lad_lot = SUBSTR(mstr,35,18).
                                      lad_ref = SUBSTR(mstr,53,8).     
                                   lad_site = SUBSTR(mstr,1,8).
                                 lad_loc = SUBSTR(mstr,9,8).      
                                        
                                 
                                 lad_qty_chg = DECIMAL(SUBSTR(mstr,61,8)).

                                      END.
                                    ELSE DO:
                                    
                                         
                                 lad_qty_chg = DECIMAL(SUBSTR(mstr,61,8)).

                                        
                                        END.
                                         END.
                                         ELSE     MESSAGE "���������Ų��ڿ���У�" view-AS ALERT-BOX  error BUTTONS OK.                                  

                                   END.
                                   /*
                                       END.*/
    
                                       
                                       
                                       
                                       END.
                                  END.

   qty_entered = 0.

   for each lad_det no-lock where
            lad_dataset = "wod_det"
        and lad_nbr = wod_lot and lad_line = string(wod_op)
        and lad_part = wod_part:
      qty_entered = qty_entered + lad_qty_chg.
   end.

   /* Total lot/serial quantity entered: */
   {pxmsg.i &MSGNUM=300 &ERRORLEVEL=1 &MSGARG1=qty_entered}

   frametitle = getTermLabelRtColon("ISSUE_DETAIL_ITEM",19) + " " +
                wod_part +
                getTermLabelRtColon("QUANTITY_TO_ISSUE",21) + " " +
                string(wod_qty_chg).





   {swindowb.i
      &file=lad_det
      &framename="c"
      &frame-attr="overlay col 1 row 10
        title color normal frametitle"
      &record-id=lad_recno
      &search=lad_part
      &equality=wod_part
      &other-search="and lad_dataset = ""wod_det"" and lad_nbr = wod_lot
        and lad_line = string(wod_op)"
      &scroll-field=lad_site
      &create-rec=yes
      &assign="lad_part = wod_part lad_dataset = ""wod_det""
        lad_nbr = wod_lot lad_line = string(wod_op)"
      &prompt-for2=lad_loc
      &prompt-for3=lad_lot
      &prompt-for1=lad_site
      &prompt-for4=lad_ref
      &s4="/*"
      &update-leave=yes
      &display2=lad_loc
      &display3=lad_lot
      &display1=lad_site
      &display5=lad_qty_all
      &display6=lad_qty_pick
      &display7="lad_qty_chg format ""->>>>>>9.9<<<<<<"" "
      &display4="lad_ref format ""x(8)"" column-label ""Ref"" "
      &update1=lad_qty_chg
      &global_exp1="global_site = input lad_site"
      &global_exp2="global_loc = input lad_loc"
      &global_exp3="global_lot = input lad_lot"
      &global_exp4="global_ref = input lad_ref"}

   pause 0.
   if keyfunction(lastkey) = "end-error" then leave.

   if (available lad_det and lad_qty_chg <> 0) then do:

      {gprun.i ""icedit.p""
         "(""ISS-WO"",
           lad_site,
           lad_loc,
           wod_part,
           lad_lot,
           lad_ref,
           lad_qty_chg,
           (if available pt_mstr then pt_um else um),
           """",
           """",
           output yn)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      if yn then undo, retry.

      if lad_site <> wo_site then do:

         {gprun.i ""icedit4.p""
            "(input ""ISS-WO"",
              input wo_site,
              input lad_site,
              input pt_loc,
              input lad_loc,
              input wod_part,
              input lad_lot,
              input lad_ref,
              input lad_qty_chg,
              input um,
              input wo_nbr,
              input wo_lot,
              output yn)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         if yn then undo, retry.
      end.

   end.

end.
/*GUI*/ if global-beam-me-up then undo, leave.


total_lotserial_qty = qty_entered.