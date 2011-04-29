/* ppptmtb.p - ITEM MAINTENANCE SUBROUTINE INVENTORY DATA                     */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.44 $                                                          */
/*                                                                            */
/* Logic to maintain Item Inventory Data.                                     */
/*                                                                            */
/* REVISION: 7.0      LAST MODIFIED: 06/22/92   BY: emb *F687*                */
/* REVISION: 7.0      LAST MODIFIED: 07/23/92   BY: pma *F782*                */
/* REVISION: 7.3      LAST MODIFIED: 10/12/92   BY: tjs *G035*                */
/* REVISION: 7.0      LAST MODIFIED: 10/29/92   BY: pma *G249*                */
/* REVISION: 7.3      LAST MODIFIED: 02/13/93   BY: pma *G032*                */
/* REVISION: 7.4      LAST MODIFIED: 08/25/93   BY: dpm *H075*                */
/* REVISION: 7.2      LAST MODIFIED: 02/07/94   BY: ais *FL94*                */
/* REVISION: 7.4      LAST MODIFIED: 02/16/94   BY: pxd *FL60*                */
/* REVISION: 7.2      LAST MODIFIED: 06/06/94   BY: ais *FO63*                */
/* REVISION: 7.4      LAST MODIFIED: 09/01/94   BY: bcm *H501*                */
/* REVISION: 7.3      LAST MODIFIED: 09/03/94   BY: bcm *GL93*                */
/* REVISION: 7.3      LAST MODIFIED: 09/11/94   BY: rmh *GM19*                */
/* REVISION: 7.3      LAST MODIFIED: 11/01/94   BY: ame *GN83*                */
/* REVISION: 7.3      LAST MODIFIED: 11/08/94   BY: slm *GO36*                */
/* REVISION: 8.5      LAST MODIFIED: 01/06/95   BY: pma *J040*                */
/* REVISION: 8.5      LAST MODIFIED: 01/11/95   BY: taf *J041*                */
/* REVISION: 7.4      LAST MODIFIED: 01/31/95   BY: cpp *H0B1*                */
/* REVISION: 7.4      LAST MODIFIED: 02/23/95   BY: jzw *H0BM*                */
/* REVISION: 8.5      LAST MODIFIED: 03/30/95   BY: dpm *J044*                */
/* REVISION: 7.4      LAST MODIFIED: 05/30/95   BY: dzs *F0QY*                */
/* REVISION: 7.4      LAST MODIFIED: 11/28/95   BY: bcm *F0WC*                */
/* REVISION: 8.5      LAST MODIFIED: 07/02/96   BY: *G1Z6*  Russ Witt         */
/* REVISION: 8.5      LAST MODIFIED: 08/02/96   BY: *J13G* Andy Wasilczuk     */
/* REVISION: 8.6      LAST MODIFIED: 10/10/96   BY: svs *K007*                */
/* REVISION: 8.6      LAST MODIFIED: 10/18/96   BY: jpm *K017*                */
/* REVISION: 8.6      LAST MODIFIED: 01/14/97   BY: *H0R3*  Russ Witt         */
/* REVISION: 8.6      LAST MODIFIED: 03/07/97   BY: *J1HQ*  Russ Witt         */
/* REVISION: 8.6      LAST MODIFIED: 07/24/97   BY: *J1PS*  Felcy D'Souza     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/15/98   BY: *J2LM* Suresh Nayak       */
/* REVISION: 8.6E     LAST MODIFIED: 07/07/98   BY: *J2QV* Dana Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 11/20/98   BY: *M002* Mayse Lai          */
/* REVISION: 9.0      LAST MODIFIED: 12/16/98   BY: *J370*  Raphael T         */
/* REVISION: 9.0      LAST MODIFIED: 02/12/99   BY: *M087* Robert Jensen      */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 02/22/99   BY: *M08Y* Niranjan R.        */
/* REVISION: 9.1      LAST MODIFIED: 06/07/99   BY: *J3GR*  Niranjan R.       */
/* REVISION: 9.1      LAST MODIFIED: 11/09/99   BY: *N04Q* J. Fernando        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.41    BY: Satish Chavan       DATE: 03/03/00   ECO: *N03T*     */
/* Revision: 1.42    BY: Annasaheb Rahane    DATE: 05/08/00   ECO: *N0B0*     */
/* $Revision: 1.44 $      BY: Satish Chavan       DATE: 05/16/00   ECO: *N0B9*     */
/* REVISION: 9.1      LAST MODIFIED: 08/17/00   BY: *N0LJ* Mark Brown         */
/* REVISION: EB       LAST MODIFIED: 01/20/03   BY: *EAS003* Leemy Lee        */
/*                                                                            */
/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{pxmaint.i}
{pxsevcon.i}
{pxpgmmgr.i}

&GLOBAL-DEFINE GL_COST_SET 'GL'
&GLOBAL-DEFINE CURRENT_COST_SET 'CUR'

/* ********** Begin Translatable Strings Definitions ********* */

/*N0B0* ---------  BEGIN ADD COMMENT ---------------- *
 * &SCOPED-DEFINE ppptmtb_p_1 " Item Shipping Data "
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE ppptmtb_p_2 " Item Inventory Data "
 * /* MaxLen: Comment: */
 *N0B0* ---------  END ADD   COMMENT ---------------- */

/* ********** End Translatable Strings Definitions ********* */

/* SHARED */
define shared variable new_part  like mfc_logical.
define shared variable promo_old like pt_promo.
define shared variable inrecno   as   recid.
define shared variable sct1recno as   recid.
define shared variable sct2recno as   recid.

define shared frame b.
define shared frame b1.

/* LOCAL */
define variable old_site            like pt_site.
define variable msg-nbr             like msg_nbr.
define variable old_lot_ser         like pt_lot_ser.
define variable yn                  like mfc_logical.
define variable avail_first_dc_mstr like mfc_logical  no-undo     initial no.
define variable l_comm_code         like comd_comm_code           no-undo.
define variable returnData          like mfc_logical.
define variable error_flag          like mfc_logical              no-undo.
define variable err_mess_no         like msg_nbr                  no-undo.
define variable v_std_cost          like sct_cst_tot              no-undo.
define variable v_std_cost_set      like sct_sim                  no-undo.
define variable apm-ex-prg          as   character format "x(10)" no-undo.
define variable apm-ex-sub          as   character format "x(24)" no-undo.

define buffer inmstr for in_mstr.

/*EAS021*  form {ppptmta3.i}*/
form {xxppptmta3.i}
with frame b title color normal (getFrameTitle("ITEM_INVENTORY_DATA",28))
   side-labels width 80 attr-space.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame b:handle).

form {ppptmt10.i}
with frame b1 title color normal (getFrameTitle("ITEM_SHIPPING_DATA",26))
   side-labels width 80 attr-space.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame b1:handle).


find first soc_ctrl no-lock no-error.

loopb:
do transaction on endkey undo, return:
   find pt_mstr exclusive-lock
      where recid(pt_mstr) = pt_recno no-error.
   if not available pt_mstr then leave.

   ststatus = stline[3].
   status input ststatus.

   old_site = pt_site.

   display
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
   with frame b.

   do on error undo, retry with frame b:

      old_lot_ser = pt_lot_ser.

      {pxrun.i &PROC  = 'setSystemDefaultSite' &PROGRAM = 'icsixr.p'
               &PARAM = "(input pt_site:SCREEN-VALUE)"
               &NOAPPERROR = true
               &CATCHERROR = true
      }

      prompt-for
         pt_abc
         pt_lot_ser
         pt_site
         pt_loc
         pt_loc_type
         pt_auto_lot
         pt_lot_grp
/*EAS021*           pt_article*/
         pt_avg_int
         pt_cyc_int
         pt_shelflife
         pt_sngl_lot
         pt_critical
/*EAS021*/ pt_article         
         pt_rctpo_status
         pt_rctpo_active when ({gppswd3.i &field=""pt_rctpo_status""})
         pt_rctwo_status
         pt_rctwo_active when ({gppswd3.i &field=""pt_rctwo_status""})
      with frame b
      editing:
         readkey.
         apply lastkey.
         /* SITE VALUE IS STORED IN GLOBAL VARIABLE global_site   */
         /* AND PASSED TO BROWSE                                  */

         if frame-field = "pt_site" then do:
            {pxrun.i &PROC  = 'setSystemDefaultSite' &PROGRAM = 'icsixr.p'
                     &PARAM = "(input pt_site:SCREEN-VALUE)"
                     &NOAPPERROR = true
                     &CATCHERROR = true
            }
         end.

      end. /* editing: */

      assign
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
         pt_rctwo_active.

      {pxrun.i &PROC  = 'setSystemDefaultSite' &PROGRAM = 'icsixr.p'
               &PARAM = "(input pt_site:SCREEN-VALUE)"
               &NOAPPERROR = true
               &CATCHERROR = true
      }

      {pxrun.i &PROC  = 'validateSiteIDDefault' &PROGRAM = 'ppitxr.p'
               &PARAM = "(input pt_site)"
               &NOAPPERROR = true
               &CATCHERROR = true
      }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt pt_site with frame b.
         undo, retry.
      end. /* do: */

      if not new_part and old_site <> pt_site then
         inrecno = ?.

      {pxrun.i &PROC  = 'validateLotSerial' &PROGRAM = 'ppitxr.p'
               &PARAM = "(input pt_part,
                          input pt_lot_ser,
                          input old_lot_ser)"
               &NOAPPERROR = true
               &CATCHERROR = true
      }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt pt_lot_ser with frame b.
         undo, retry.
      end.

      {pxrun.i &PROC  = 'validateAutoLot' &PROGRAM = 'ppitxr.p'
               &PARAM = "(input pt_lot_ser,
                          input pt_auto_lot)"
               &NOAPPERROR = true
               &CATCHERROR = true
      }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt pt_auto_lot with frame b. /*CONTROLLED PARTS */
         undo, retry.
      end. /* if return-value <> {&SUCCESS-RESULT} then do: */

      /* LOT GROUP DOES NOT EXIST */
      {pxrun.i &PROC  = 'validateLotGroup' &PROGRAM = 'ppitxr.p'
               &PARAM = "(input pt_lot_grp,
                          input pt_site)"
               &NOAPPERROR = true
               &CATCHERROR = true
      }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt pt_lot_grp with frame b.
         undo, retry.
      end. /* if return-value <> {&SUCCESS-RESULT} */

      {pxrun.i &PROC  = 'validateAverageInterval' &PROGRAM = 'ppitxr.p'
               &PARAM = "(input pt_avg_int)"
               &NOAPPERROR = true
               &CATCHERROR = true
      }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt pt_avg_int with frame b.
         undo, retry.
      end. /* if return-value <> {&SUCCESS-RESULT} */

      {pxrun.i &PROC  = 'validateCycleCountInterval' &PROGRAM = 'ppitxr.p'
               &PARAM = "(input pt_cyc_int)"
               &NOAPPERROR = true
               &CATCHERROR = true
      }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt pt_cyc_int with frame b.
         undo, retry.
      end. /* if return-value <> {&SUCCESS-RESULT} */

      {pxrun.i &PROC  = 'validateReceiptStatus' &PROGRAM = 'ppitxr.p'
               &PARAM = "(input pt_rctpo_active,
                          input pt_rctpo_status)"
               &NOAPPERROR = true
               &CATCHERROR = true
      }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt pt_rctpo_status with frame b.
         undo, retry.
      end. /* if return-value <> {&SUCCESS-RESULT} then do: */

      {pxrun.i &PROC  = 'validateReceiptStatus' &PROGRAM = 'ppitxr.p'
               &PARAM = "(input pt_rctwo_active,
                          input pt_rctwo_status)"
               &NOAPPERROR = true
               &CATCHERROR = true
      }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt pt_rctwo_status with frame b.
         undo, retry.
      end. /* if return-value <> {&SUCCESS-RESULT} then do: */

      if new_part then do:
         {pxrun.i &PROC  = 'defaultPOSite' &PROGRAM = 'ppitxr.p'
                  &PARAM = "(input-output pt_po_site,
                             input        pt_site)"
                  &NOAPPERROR = true
                  &CATCHERROR = true
         }

         {pxrun.i &PROC  = 'siteUpdate' &PROGRAM = 'icinxr.p'
                  &PARAM = "(input pt_part,
                             input pt_site,
                             input old_site,
                             input pt_abc,
                             input pt_avg_int,
                             input pt_cyc_int,
                             input pt_rctpo_status,
                             input pt_rctpo_active,
                             input pt_rctwo_status,
                             input pt_rctwo_active)"
                  &NOAPPERROR = true
                  &CATCHERROR = true
         }

         {pxrun.i &PROC  = 'itemCostUpdate' &PROGRAM = 'ppicxr.p'
                  &PARAM = "(input pt_part,
                             input old_site,
                             input pt_site,
                             input {&GL_COST_SET})"
                  &NOAPPERROR = true
                  &CATCHERROR = true
         }

         {pxrun.i &PROC  = 'itemCostUpdate' &PROGRAM = 'ppicxr.p'
                  &PARAM = "(input pt_part,
                             input old_site,
                             input pt_site,
                             input {&CURRENT_COST_SET})"
                  &NOAPPERROR = true
                  &CATCHERROR = true
         }
      end. /* do: */

      {pxrun.i &PROC  = 'validateLocation' &PROGRAM = 'icloxr.p'
               &PARAM = "(input pt_site,
                          input pt_loc)"
               &NOAPPERROR = true
               &CATCHERROR = true
      }

      {pxrun.i &PROC  = 'processRead' &PROGRAM = 'icinxr.p'
               &PARAM = "(input  pt_part,
                          input  pt_site,
                          buffer in_mstr,
                          input  {&LOCK_FLAG},
                          input  {&WAIT_FLAG})"
               &NOAPPERROR = true
               &CATCHERROR = true
      }
      if return-value <> {&SUCCESS-RESULT} then do:
         {pxrun.i &PROC  = 'createInventory' &PROGRAM = 'ppitxr.p'
                  &PARAM = "(buffer pt_mstr,
                             buffer in_mstr)"
                  &NOAPPERROR = true
                  &CATCHERROR = true
         }

         /**lzg ** Should we obsolete this read */
         {pxrun.i &PROC  = 'processRead' &PROGRAM = 'icinxr.p'
                  &PARAM = "(input  pt_part,
                             input  pt_site,
                             buffer in_mstr,
                             input  {&NO_LOCK_FLAG},
                             input  {&NO_WAIT_FLAG})"
                  &NOAPPERROR = true
                  &CATCHERROR = true
         }

         inrecno = recid(in_mstr).
         recno = inrecno.
      end. /*if not available in_mstr*/
      else do:
         {pxrun.i &PROC  = 'updateInventory' &PROGRAM = 'ppitxr.p'
                  &PARAM = "(buffer pt_mstr,
                             buffer in_mstr,
                             input new_part)"
                  &NOAPPERROR = true
                  &CATCHERROR = true
         }
      end. /* else do: */

      yn = no.
      if not new_part and old_site <> pt_site then do:

         {pxrun.i &PROC  = 'createItemCost' &PROGRAM = 'ppitxr.p'
                  &PARAM = "(input  pt_part,
                             input  pt_site,
                             input  {&GL_COST_SET},
                             buffer in_mstr,
                             output yn)"
                  &NOAPPERROR = true
                  &CATCHERROR = true
         }

         {pxrun.i &PROC  = 'createItemCost' &PROGRAM = 'ppitxr.p'
                  &PARAM = "(input  pt_part,
                             input  pt_site,
                             input  {&CURRENT_COST_SET},
                             buffer in_mstr,
                             output yn)"
                  &NOAPPERROR = true
                  &CATCHERROR = true
         }

         if yn then do:
            /* 5429 - CREATING COST SETS AT SITE #.  INITIAL COST IS 0.00*/
            {pxmsg.i &MSGNUM     = 5429
                     &ERRORLEVEL = {&WARNING-RESULT}
                     &MSGARG1    = pt_site}

            if not batchrun then pause 3 no-message.
            hide message no-pause.
         end. /* if yn then do: */
      end. /* if not new_part and old_site <> pt_site then do: */
   end. /*do on error*/

   {pxrun.i &PROC  = 'processRead' &PROGRAM = 'icsixr.p'
            &PARAM = "(input  pt_site,
                       buffer si_mstr,
                       input  {&NO_LOCK_FLAG},
                       input  {&NO_WAIT_FLAG})"
            &NOAPPERROR = true
            &CATCHERROR = true
   }

   /*@MODULE APM BEGIN*/
   if soc_apm and
      (promo_old <> "" or pt_promo <> "") then do:
      /* Future logic will go here to determine subdirectory*/

      apm-ex-sub = "if/".

      /* RUN INTERNAL PROCEDURE TO OBTAIN COST SET AND COST */
      {pxrun.i &PROC  = 'get_std_cost'
               &PARAM = "(input  pt_part,
                          input  si_site,
                          output v_std_cost,
                          output v_std_cost_set)"
               &NOAPPERROR = true
               &CATCHERROR = true
      }

      /* UPDATE GENERIC ITEM RECORD IN APM */
      {gprunex.i
         &module   = 'APM'
         &subdir   = apm-ex-sub
         &program  = 'ifapm054.p'
         &params   = "(input  pt_part,
                       input  pt_desc1,
                       input  pt_desc2,
                       input  pt_net_wt,
                       input  pt_net_wt_um,
                       input  pt_price,
                       input  pt_promo,
                       input  pt_site,
                       input  pt_taxc,
                       input  pt_um,
                       input  v_std_cost,
                       input  v_std_cost_set,
                       input  pt_pm_code,
                       output error_flag,
                       output err_mess_no)"}

      if error_flag then do:
         /* ERROR RETURNED BY IFAPM054.P */
         {pxmsg.i &MSGNUM     = err_mess_no
                  &ERRORLEVEL = {&APP-ERROR-RESULT}}
         undo, return.
      end. /* if error_flag then do: */

   end. /* (promo_old <> "" or pt_promo <> "") then do: */
   /*@MODULE APM END*/
end.  /*loopb*/

/* DISPLAY & UPDATE SHIPPING DATA FRAME */
loopb1:
do transaction on endkey undo, leave:

   {pxrun.i &PROC  = 'processRead' &PROGRAM = 'ppitxr.p'
            &PARAM = "(input  pt_part,
                       buffer pt_mstr,
                       input  {&LOCK_FLAG},
                       input  {&WAIT_FLAG})"
            &NOAPPERROR = true
            &CATCHERROR = true
   }
   if not available pt_mstr then leave.

   assign l_comm_code = "".
   {pxrun.i &PROC  = 'processRead' &PROGRAM = 'ppccxr1.p'
            &PARAM = "(input  pt_part,
                       buffer comd_det,
                       input  {&LOCK_FLAG},
                       input  {&WAIT_FLAG})"
            &NOAPPERROR = true
            &CATCHERROR = true
   }

   if return-value = {&SUCCESS-RESULT} then
      assign l_comm_code = comd_comm_code.

   display l_comm_code pt_fr_class
      pt_net_wt pt_net_wt_um pt_size pt_size_um
      pt_ship_wt pt_ship_wt_um
   with frame b1.

   do on error undo, retry with frame b1:

      set l_comm_code     pt_ship_wt
          pt_ship_wt_um   pt_fr_class
          pt_net_wt       pt_net_wt_um
          pt_size         pt_size_um.

      {pxrun.i &PROC  = 'validateCommodityCode' &PROGRAM = 'ppccxr.p'
               &PARAM = "(input  l_comm_code)"
               &NOAPPERROR = true
               &CATCHERROR = true
      }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt l_comm_code.
         undo,retry.
      end. /* if return-value <> {&SUCCESS-RESULT} then do: */

      {pxrun.i &PROC  = 'commodityCodeUpdate' &PROGRAM = 'ppccxr1.p'
               &PARAM = "(input pt_part,
                          input l_comm_code)"
               &NOAPPERROR = true
               &CATCHERROR = true
      }

      {pxrun.i &PROC  = 'validateShipWeightUM' &PROGRAM = 'ppitxr.p'
               &PARAM = "(input pt_ship_wt_um)"
               &NOAPPERROR = true
               &CATCHERROR = true
      }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt pt_ship_wt_um.
         undo, retry.
      end. /* do: */

      {pxrun.i &PROC  = 'validateFreightClass' &PROGRAM = 'sofcxr.p'
               &PARAM = "(input pt_fr_class)"
               &NOAPPERROR = true
               &CATCHERROR = true
      }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt pt_fr_class.
         undo, retry.
      end. /* do: */

      {pxrun.i &PROC  = 'validateNetWeightUM' &PROGRAM = 'ppitxr.p'
               &PARAM = "(input pt_net_wt_um)"
               &NOAPPERROR = true
               &CATCHERROR = true
      }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt pt_net_wt_um.
         undo, retry.
      end. /* do: */

      {pxrun.i &PROC  = 'validateVolumeUM' &PROGRAM = 'ppitxr.p'
               &PARAM = "(input pt_size_um)"
               &NOAPPERROR = true
               &CATCHERROR = true
      }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt pt_size_um.
         undo, retry.
      end. /* do: */

   end. /* do on error undo, retry with frame b1: */

   /*@MODULE APM BEGIN*/
   if soc_apm  and
      (promo_old <> "" or pt_promo <> "") then do:
      /* Future logic will go here to determine subdirectory*/

      apm-ex-sub = "if/".

      /* RUN INTERNAL PROCEDURE TO OBTAIN COST SET AND COST */
      {pxrun.i &PROC  = 'get_std_cost'
               &PARAM = "(input  pt_part,
                          input  si_site,
                          output v_std_cost,
                          output v_std_cost_set)"
               &NOAPPERROR = true
               &CATCHERROR = true
      }

      /* UPDATE GENERIC ITEM RECORD IN APM */
      {gprunex.i
         &module   = 'APM'
         &subdir   = apm-ex-sub
         &program  = 'ifapm054.p'
         &params   = "(input  pt_part,
                       input  pt_desc1,
                       input  pt_desc2,
                       input  pt_net_wt,
                       input  pt_net_wt_um,
                       input  pt_price,
                       input  pt_promo,
                       input  pt_site,
                       input  pt_taxc,
                       input  pt_um,
                       input  v_std_cost,
                       input  v_std_cost_set,
                       input  pt_pm_code,
                       output error_flag,
                       output err_mess_no)"}

      if error_flag then do:
         /* ERROR RETURNED BY IFAPM054.P */
         {pxmsg.i &MSGNUM     = err_mess_no
                  &ERRORLEVEL = {&APP-ERROR-RESULT}}
         undo, return.
      end. /* if error_flag then do: */

   end. /* (promo_old <> "" or pt_promo <> "") then do: */
   /*@MODULE APM END*/
end. /* do transaction on endkey undo, leave: */

/*@MODULE APM BEGIN*/
{pppstdcs.i} /* INTERNAL PROCEDURE TO OBTAIN COST SET AND COST */
/*@MODULE APM END*/
