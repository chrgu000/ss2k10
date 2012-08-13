/* ppptmtc.p - ITEM MAINTENANCE SUBROUTINE -PLANNING DATA                     */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.27 $                                                 */
/*                                                                            */
/* Login to maintain Item Planning Data.                                      */
/*                                                                            */
/* REVISION: 7.0      LAST MODIFIED: 06/22/92   BY: emb *F687*                */
/* REVISION: 7.0      LAST MODIFIED: 07/29/92   BY: pma *F782*                */
/* REVISION: 7.0      LAST MODIFIED: 11/09/92   BY: pma *G299*                */
/* REVISION: 7.3      LAST MODIFIED: 06/15/93   BY: qzl *GC15*                */
/* REVISION: 7.3      LAST MODIFIED: 07/29/93   BY: emb *GD82*                */
/* REVISION: 7.3      LAST MODIFIED: 11/19/93   BY: pxd *GH42*                */
/* REVISION: 7.3      LAST MODIFIED: 02/14/94   BY: pxd *FM16*                */
/* REVISION: 7.3      LAST MODIFIED: 02/16/94   BY: pxd *FL60*                */
/* REVISION: 7.3      LAST MODIFIED: 05/20/94   BY: pxd *FO35*                */
/* REVISION: 7.3      LAST MODIFIED: 09/03/94   BY: bcm *GL93*                */
/* REVISION: 7.3      LAST MODIFIED: 10/24/94   BY: pxd *GN56*                */
/* REVISION: 7.3      LAST MODIFIED: 12/20/94   BY: ais *F0B7*                */
/* REVISION: 7.5      LAST MODIFIED: 03/07/95   BY: tjs *J005*                */
/* REVISION: 7.3      LAST MODIFIED: 03/19/95   BY: pxd *F0NB*                */
/* REVISION: 7.3      LAST MODIFIED: 01/24/96   BY: bcm *G1KV*                */
/* REVISION: 8.5      LAST MODIFIED: 03/09/96   BY: jxz *J078*                */
/* REVISION: 8.6      LAST MODIFIED: 10/10/96   BY: svs *K007*                */
/* REVISION: 8.6      LAST MODIFIED: 10/18/96   BY: jpm *K017*                */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Kurt De Wit        */
/* REVISION: 8.6      LAST MODIFIED: 10/11/96   BY: flm *K003*                */
/* REVISION: 8.6      LAST MODIFIED: 12/13/96   BY: *J1BZ* Russ Witt          */
/* REVISION: 8.6      LAST MODIFIED: 05/21/97   BY: *K0D8* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 06/23/97   BY: *K0DH* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 11/25/97   BY: *K1BL* Bryan Merich       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 11/20/98   BY: *M002* Mayse Lai          */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 06/07/99   BY: *N005* David Morris       */
/* REVISION: 9.1      LAST MODIFIED: 06/17/99   BY: *N00J* Russ Witt          */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *GD83*                    */
/* Revision: 1.22     BY: Satish Chavan       DATE: 03/28/00   ECO: *N03T*    */
/* Revision: 1.23     BY: Annasaheb Rahane    DATE: 05/08/00   ECO: *N0B0*    */
/* Revision: 1.25.1.1 BY: Satish Chavan       DATE: 05/16/00   ECO: *N0B9*    */
/* REVISION: 9.1      LAST MODIFIED: 08/17/00   BY: *N0LJ* Mark Brown         */
/* Revision: 1.26     BY: Russ Witt           DATE: 09/21/01   ECO: *P01H*    */
/* $Revision: 1.27 $       BY: Nishit V            DATE: 03/28/03   ECO: *P0PC*    */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*                                                                            */
/*V8:ConvertMode=Maintenance                                                  */

         /*********************************************************/
         /* NOTES:   1. Patch FL60 sets in_level to a value       */
         /*             of 99999 when in_mstr is created or       */
         /*             when any structure or network changes are */
         /*             made that affect the low level codes.     */
         /*          2. The in_levels are recalculated when MRP   */
         /*             is run or can be resolved by running the  */
         /*             mrllup.p utility program.                 */
/*********************************************************/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{pxmaint.i}
{pxsevcon.i}
{pxpgmmgr.i}

/* NEW  SHARED */
define new shared variable fname      like lngd_dataset no-undo initial "EMT".

/* SHARED */
define shared variable promo_old like pt_promo.
define shared variable new_part  like mfc_logical.
define shared variable ppform    as   character.
define shared frame c.

/* LOCAL BUFFER */
define buffer inmstra for in_mstr.
define buffer inmstr4 for in_mstr.

/* LOCAL VARIABLE */
define variable bom_code       like pt_bom_code.
define variable bomValue       like bom_batch.
define variable pt_bom_codesv  like pt_bom_code.
define variable pt_pm_codesv   like pt_pm_code.
define variable pt_networksv   like pt_network.
define variable pt_ord_polsv   like pt_ord_pol  initial "xyz".
define variable cfg            like pt_cfg_type format  "x(3)" no-undo.
define variable valid_mnemonic like mfc_logical no-undo.
define variable btb-type       like pt_btb_type format  "x(8)" no-undo.
define variable btb-type-desc  like glt_desc    no-undo.
define variable isvalid        like mfc_logical.
define variable atp-enforcement  like pt_atp_enforcement format "x(8)" no-undo.
define variable atp-enforce-desc like glt_desc  no-undo.
define variable cfexists       like mfc_logical.
define variable cfsite         like pt_site     initial "".
define variable error_flag     like mfc_logical no-undo.
define variable err_mess_no    like msg_nbr     no-undo.
define variable v_std_cost     like sct_cst_tot no-undo.
define variable v_std_cost_set like sct_sim     no-undo.

define variable err-flag       as   integer.
define variable ps-recno       as   recid.
define variable drp_mrp        as   logical     initial no.
define variable cfdel-yn       as   logical     initial no.
define variable cfglabel       as   character   format "x(24)" label "" no-undo.
define variable cfgcode        as   character   format "x(1)"  no-undo.
define variable apm-ex-prg     as   character   format "x(10)" no-undo.
define variable apm-ex-sub     as   character   format "x(24)" no-undo.

{gprun.i ""cfctrl.p"" "(""cf_w_mod"", output cfexists)"}

form 
RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
/*tfq{ppptmta4.i} */
/*tfq*/ {yyptmta4.i}
/*GL93*/  SKIP(.4)  /*GUI*/
with frame c 
/*GL93*/ side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-c-title AS CHARACTER.
 F-c-title = getFrameTitle("ITEM_PLANNING_DATA",26).
 RECT-FRAME-LABEL:SCREEN-VALUE in frame c = F-c-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame c =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame c + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame c =
  FRAME c:HEIGHT-PIXELS - RECT-FRAME:Y in frame c - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME c = FRAME c:WIDTH-CHARS - .5. /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

/*DISPLAY*/
find first soc_ctrl no-lock no-error.
loopc:
do transaction with frame c on endkey undo, leave:
   find pt_mstr exclusive-lock where recid(pt_mstr) = pt_recno
      no-error.
   if not available pt_mstr then leave.

   {pxrun.i &PROC  = 'getConfigTypeDesc' &PROGRAM = 'ppitxr.p'
      &PARAM = "(input  pt_cfg_type,
                       output cfg,
                       output cfglabel)"
      &NOAPPERROR = true
      &CATCHERROR = true
      }

   {pxrun.i &PROC  = 'defaultItemEMTType' &PROGRAM = 'ppitxr.p'
      &PARAM = "(input-output pt_btb_type)"
      &NOAPPERROR = true
      &CATCHERROR = true
      }

   {pxrun.i &PROC  = 'getEmtDescription' &PROGRAM = 'soemxr.p'
      &PARAM = "(input  pt_btb_type,
                       output btb-type,
                       output btb-type-desc)"
      &NOAPPERROR = true
      &CATCHERROR = true
      }
   {pxrun.i &PROC  = 'defaultATPEnforcement' &PROGRAM = 'soatpxr.p'
      &PARAM = "(input-output pt_atp_enforcement)"
      &NOAPPERROR = true
      &CATCHERROR = true
      }

   {pxrun.i &PROC  = 'getATPDescription' &PROGRAM = 'soatpxr.p'
      &PARAM = "(input  pt_atp_enforcement,
                       output atp-enforcement,
                       output atp-enforce-desc)"
      &NOAPPERROR = true
      &CATCHERROR = true
      }

   assign
      pt_ord_polsv  = pt_ord_pol
      pt_bom_codesv = pt_bom_code
      pt_pm_codesv  = pt_pm_code
      pt_networksv  = pt_network.

   {pxrun.i &PROC  = 'processRead' &PROGRAM = 'bmbmxr.p'
      &PARAM = "(input  (if pt_bom_code <> '' then
                                  pt_bom_code
                               else pt_part),
                       buffer bom_mstr,
                       input  {&NO_LOCK_FLAG},
                       input  {&NO_WAIT_FLAG})"
      &NOAPPERROR = true
      &CATCHERROR = true
      }

   ststatus = stline[3].
   status input ststatus.

   {pxrun.i &PROC  = 'processRead' &PROGRAM = 'icinxr.p'
      &PARAM = "(input  pt_part,
                       input  pt_site,
                       buffer inmstr4,
                       input  {&NO_LOCK_FLAG},
                       input  {&NO_WAIT_FLAG})"
      &NOAPPERROR = true
      &CATCHERROR = true
      }

   display inmstr4.in_mrp when (available inmstr4) @ pt_mrp
      pt_cum_lead with frame c.

   if new_part then do:
      {pxrun.i &PROC  = 'setInspectionRequired' &PROGRAM = 'ppitxr.p'
         &PARAM = "(buffer pt_mstr)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }
   end.

   {pxrun.i &PROC  = 'getBOMBatchValue' &PROGRAM = 'bmbmxr.p'
      &PARAM = "(buffer bom_mstr,
                       output bomValue)"
      &NOAPPERROR = true
      &CATCHERROR = true
      }

   display pt_ms pt_plan_ord
      pt_timefence
      pt_ord_pol pt_ord_qty
      bomValue @ pt_batch
      pt_ord_per pt_sfty_stk pt_sfty_time pt_rop
      pt_rev
      pt_buyer pt_vend
      pt_po_site
      pt_pm_code pt_mfg_lead
      cfg
      pt_pur_lead pt_insp_rqd pt_insp_lead
      pt_network pt_routing pt_bom_code
      pt_iss_pol
      pt_phantom pt_ord_min pt_ord_max pt_ord_mult
      pt_op_yield
      pt_yield_pct pt_run pt_setup /*roger*/ pt__dec01
      btb-type
      pt__qad15
      atp-enforcement
      pt_atp_family
      pt_run_seq1
      pt_run_seq2
   with frame c.
   next-prompt pt_ms.
   do on error undo, retry with frame c:

      set pt_ms pt_plan_ord
         pt_timefence
         pt_ord_pol pt_ord_qty
         pt_ord_per pt_sfty_stk  pt_sfty_time pt_rop
         pt_rev
         pt_iss_pol
         pt_buyer pt_vend
         pt_po_site
         pt_pm_code
         cfg
         pt_insp_rqd
         pt_insp_lead
         pt_mfg_lead  /*roger*/ pt__dec01
         pt_pur_lead
         atp-enforcement
         pt_atp_family
         pt_run_seq1
         pt_run_seq2
         pt_phantom pt_ord_min pt_ord_max pt_ord_mult
         pt_op_yield
         pt_yield_pct  pt_run pt_setup
         btb-type
         pt__qad15
         pt_network
         pt_routing
         pt_bom_code
      with frame c.

      /* do not allow unknown values (question mark) */
      {gpchkqst.i &fld=pt_ms &frame-name=c}
      {gpchkqst.i &fld=pt_plan_ord &frame-name=c}
      {gpchkqst.i &fld=pt_timefence &frame-name=c}
      {gpchkqst.i &fld=pt_ord_pol &frame-name=c}
      {gpchkqst.i &fld=pt_ord_qty &frame-name=c}
      {gpchkqst.i &fld=pt_ord_per &frame-name=c}
      {gpchkqst.i &fld=pt_sfty_stk &frame-name=c}
      {gpchkqst.i &fld=pt_sfty_time &frame-name=c}
      {gpchkqst.i &fld=pt_rop &frame-name=c}
      {gpchkqst.i &fld=pt_rev &frame-name=c}
      {gpchkqst.i &fld=pt_buyer &frame-name=c}
      {gpchkqst.i &fld=pt_vend &frame-name=c}
      {gpchkqst.i &fld=pt_po_site &frame-name=c}
      {gpchkqst.i &fld=pt_pm_code &frame-name=c}
      {gpchkqst.i &fld=pt_mfg_lead &frame-name=c}
      {gpchkqst.i &fld=pt_pur_lead &frame-name=c}
      {gpchkqst.i &fld=pt_insp_rqd &frame-name=c}
      {gpchkqst.i &fld=pt_insp_lead &frame-name=c}
      {gpchkqst.i &fld=pt_network &frame-name=c}
      {gpchkqst.i &fld=pt_routing &frame-name=c}
      {gpchkqst.i &fld=pt_bom_code &frame-name=c}
      {gpchkqst.i &fld=pt_iss_pol &frame-name=c}
      {gpchkqst.i &fld=pt_phantom &frame-name=c}
      {gpchkqst.i &fld=pt_ord_min &frame-name=c}
      {gpchkqst.i &fld=pt_ord_max &frame-name=c}
      {gpchkqst.i &fld=pt_ord_mult &frame-name=c}
      {gpchkqst.i &fld=pt_op_yield &frame-name=c}
      {gpchkqst.i &fld=pt_yield_pct &frame-name=c}
      {gpchkqst.i &fld=pt_run &frame-name=c}
      {gpchkqst.i &fld=pt_setup &frame-name=c}
      {gpchkqst.i &fld=pt_run_seq1 &frame-name=c}
      {gpchkqst.i &fld=pt_run_seq2 &frame-name=c}
      {gpchkqst.i &fld=pt_atp_family &frame-name=c}
/*roger*/                     {gpchkqst.i &fld=pt__dec01 &frame-name=c}
      {pxrun.i &PROC  = 'validateOrderPeriod' &PROGRAM = 'ppitxr.p'
         &PARAM = "(input pt_ord_per)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt pt_ord_per.
         undo, retry.
      end. /* if return-value <> {&SUCCESS-RESULT} then do: */

      {pxrun.i &PROC  = 'validateRevision' &PROGRAM = 'ppitxr.p'
         &PARAM = "(input  pt_rev)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt pt_rev.
         undo, retry.
      end. /* if return-value <> {&SUCCESS-RESULT} then do: */

      {pxrun.i &PROC  = 'validateBuyerPlanner' &PROGRAM = 'ppitxr.p'
         &PARAM = "(input pt_buyer)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt pt_buyer.
         undo, retry.
      end. /* if return-value <> {&SUCCESS-RESULT} then do: */

      {pxrun.i &PROC  = 'validateMfgLeadTime' &PROGRAM = 'ppitxr.p'
         &PARAM = "(input pt_mfg_lead)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt pt_mfg_lead.
         undo, retry.
      end. /* if return-value <> {&SUCCESS-RESULT} then do: */

      {pxrun.i &PROC  = 'validatePurchaseLeadTime' &PROGRAM = 'ppitxr.p'
         &PARAM = "(input pt_pur_lead)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt pt_pur_lead.
         undo, retry.
      end. /* if return-value <> {&SUCCESS-RESULT} then do: */

      {pxrun.i &PROC  = 'validateInspectionLeadTime' &PROGRAM = 'ppitxr.p'
         &PARAM = "(input pt_insp_lead)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt pt_insp_lead.
         undo, retry.
      end. /* if return-value <> {&SUCCESS-RESULT} then do: */

      {pxrun.i &PROC  = 'validateYieldPercent' &PROGRAM = 'ppitxr.p'
         &PARAM = "(input pt_yield_pct)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt pt_yield_pct.
         undo, retry.
      end. /* if return-value <> {&SUCCESS-RESULT} then do: */

      {pxrun.i &PROC  = 'validateNetwork' &PROGRAM = 'dnssxr.p'
         &PARAM = "(input pt_network)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt pt_network.
         undo, retry.
      end. /* then do: */

      if pt_pm_codesv = "c" and pt_pm_code <> "C"
         and cfexists then do:
         {pxrun.i &PROC  = 'processRead' &PROGRAM = 'ppcpxr.p'
            &PARAM = "(input  pt_part,
                             input  cfsite,
                             buffer qad_wkfl,
                             input  {&LOCK_FLAG},
                             input  {&WAIT_FLAG})"
            &NOAPPERROR = true
            &CATCHERROR = true
            }

         if return-value = {&SUCCESS-RESULT} then do:
            cfdel-yn = no.
            /* 1798 - MODEL NAME EXISTS FOR THE CONFIGURED ITEM. DELETE? */
            {pxmsg.i &MSGNUM     = 1798
               &ERRORLEVEL = {&WARNING-RESULT}
               &CONFIRM    = cfdel-yn
               }
            if cfdel-yn then do:
               delete qad_wkfl.
            end. /* if cfdel-yn then do: */
            else do:
               next-prompt pt_pm_code.
               undo, retry.
            end. /* else do: */
         end. /*available qad_wkfl*/
      end. /*if pt_pm_codesv...*/

      /* VALIDATE THE RUN SEQUENCES */
      /* VALIDATE RUN SEQUENCE 1 */
      {pxrun.i &PROC  = 'validateRunSequence' &PROGRAM = 'ppitxr.p'
         &PARAM = "(input pt_pm_code,
                          input 'pt_run_seq1',
                          input pt_run_seq1)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }

      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt pt_run_seq1.
         undo, retry.
      end. /* if return-value <> {&SUCCESS-RESULT} then do: */

      /* VALIDATE RUN SEQUENCE 2 */
      {pxrun.i &PROC  = 'validateRunSequence' &PROGRAM = 'ppitxr.p'
         &PARAM = "(input pt_pm_code,
                          input 'pt_run_seq2',
                          input pt_run_seq2)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt pt_run_seq2.
         undo, retry.
      end. /* if return-value <> {&SUCCESS-RESULT} then do: */

      {pxrun.i &PROC  = 'validatePurMfgCode' &PROGRAM = 'ppitxr.p'
         &PARAM = "(input pt_part,
                          input pt_pm_code,
                          input pt_pm_codesv,
                          input pt_joint_type)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt pt_pm_code.
         undo, retry.
      end.

      {pxrun.i &PROC  = 'updateItemPlanning' &PROGRAM = 'ppitxr.p'
         &PARAM = "(input pt_pm_code,
                          input pt_pm_codesv,
                          input pt_part)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }

      ps-recno = 1.

      err-flag = 0.
      if pt_routing > ""
      then do:
         /* VALIDATES ENTRY OF BLANK ROUTING AND ISSUES WARNING */
         {pxrun.i &PROC  = 'validateRoutingCode' &PROGRAM = 'rwroxr.p'
            &PARAM = "(input pt_routing ,
                       input 1)"
            &NOAPPERROR = true
            &CATCHERROR = true
            }

         if return-value <> {&SUCCESS-RESULT}
         then do:
            next-prompt pt_routing.
            err-flag = 1.
         end. /* then do: */
      end.

      {pxrun.i &PROC  = 'setReplanRequired' &PROGRAM = 'ppitxr.p'
         &PARAM = "(input pt_part,
                          input pt_bom_code,
                          input pt_bom_codesv,
                          input pt_pm_code,
                          input pt_pm_codesv,
                          input pt_network,
                          input pt_networksv)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }

      /* VALIDATE CFG MNEMONIC AGAINST LNGD_DET */

      {pxrun.i &PROC  = 'validateConfigType' &PROGRAM = 'ppitxr.p'
         &PARAM = "(input cfg,
                          input pt_pm_code)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt cfg.
         undo, retry.
      end. /* if return-value <> {&SUCCESS-RESULT} then do: */

      {pxrun.i &PROC  = 'getConfigType' &PROGRAM = 'ppitxr.p'
         &PARAM = "(input pt_pm_code,
                          input cfg,
                          output pt_cfg_type)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }

      {pxrun.i &PROC  = 'validateEmtType' &PROGRAM = 'soemxr.p'
         &PARAM = "(input btb-type)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt btb-type.
         undo,retry.
      end. /* if return-value <> {&SUCCESS-RESULT} then do: */

      {pxrun.i &PROC  = 'getEMTType' &PROGRAM = 'soemxr.p'
         &PARAM = "(input  btb-type,
                          output pt_btb_type,
                          output btb-type-desc)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }

      {pxrun.i &PROC  = 'validateATPEnforcement' &PROGRAM = 'soatpxr.p'
         &PARAM = "(input atp-enforcement)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt atp-enforcement.
         undo,retry.
      end. /* if return-value <> {&SUCCESS-RESULT} then do: */

      {pxrun.i &PROC  = 'getATPEnforcement' &PROGRAM = 'soatpxr.p'
         &PARAM = "(input  atp-enforcement,
                          output pt_atp_enforcement,
                          output atp-enforce-desc)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }

      /* ISSUE WARNING IF ATP ENFORCEMENT ACTIVATED HERE BUT NOT  */
      /* ACTIVE IN SALES ORDER CONTROL FILE                       */
      /* ONLY ISSUE ERROR IF TYPE SET TO WARN OR ERROR, OR        */
      /* FAMILY ATP SET TO YES..                                  */
      if available soc_ctrl and soc_atp_enabled = no then do:
         if ((atp-enforcement entered or new pt_mstr)
            and pt_atp_enforcement > "0")
            or ((pt_atp_family entered or new pt_mstr)
            and pt_atp_family = yes)
         then do:
            /* 4095 -ATP Enforcement not active in Sales Order Control file */
            {pxmsg.i &MSGNUM     = 4095
               &ERRORLEVEL = {&WARNING-RESULT}
               &PAUSEAFTER = true
               }
         end.
      end.   /* If available soc_ctrl... */

      {pxrun.i &PROC  = 'setJointType' &PROGRAM = 'ppitxr.p'
         &PARAM = "(input-output pt_joint_type,
                          input        pt_bom_code,
                          input        pt_bom_codesv,
                          input        pt_part)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }

      {pxrun.i &PROC  = 'validatePhantom' &PROGRAM = 'ppitxr.p'
         &PARAM = "(input pt_phantom,
                          input pt_joint_type)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt pt_phantom.
         undo, retry.
      end. /* if return-value <> {&SUCCESS-RESULT} then do: */

      {pxrun.i &PROC    = 'validateBomFormulaId' &PROGRAM = 'ppitxr.p'
         &PARAM   = "(input pt_part,
                            input pt_bom_code,
                            input pt_bom_codesv,
                            input pt_pm_code,
                            input pt_pm_codesv,
                            input pt_network,
                            input pt_networksv,
                            input pt_joint_type)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }
      if return-value = {&WARNING-RESULT} then do:
         if err-flag <> 1 then
            next-prompt pt_bom_code.

         err-flag = 2.
      end.
      else if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt pt_bom_code.
         undo, retry.
      end. /* if return-value <> {&SUCCESS-RESULT} then do: */

      if err-flag <> 0 then pause.
   end. /* do on error undo, retry with frame c: */

   {pxrun.i &PROC  = 'setLowerLevelCode' &PROGRAM = 'ppitxr.p'
      &PARAM = "(input        pt_part,
                       input        pt_bom_code,
                       input-output pt_ll_code)"
      &NOAPPERROR = true
      &CATCHERROR = true
      }

   {pxrun.i &PROC  = 'setMRPRequired' &PROGRAM = 'ppitxr.p'
      &PARAM = "(buffer pt_mstr,
                       input  pt_ord_pol)"
      &NOAPPERROR = true
      &CATCHERROR = true
      }

   /*@MODULE APM BEGIN*/
   if soc_apm and ppform <> "c" and
      (promo_old <> "" or pt_promo <> "") then do:
      /* Future logic will go here to determine subdirectory*/

      apm-ex-sub = "if/".

      for first si_mstr
            fields (si_cur_set si_gl_set si_site)
            where si_site = pt_site no-lock:
      end. /* for first si_mstr */
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
            &ERRORLEVEL = {&APP-ERROR-RESULT}
            }
         undo, return.
      end. /* if error_flag then do: */

   end. /* (promo_old <> "" or pt_promo <> "") then do: */
   /*@MODULE APM END*/
end. /* do transaction with frame c on endkey undo, leave: */
{pppstdcs.i} /* INTERNAL PROCEDURE TO OBTAIN COST SET AND COST */

