/* reworp02.p - REPETITIVE                                                    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*F0PN*/ /*V8:ConvertMode=FullGUIReport                                       */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: WUG *GN77*                */
/* REVISION: 8.6      LAST MODIFIED: 10/14/97   BY: mzv *K0YF*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 11/17/99   BY: *N04H* Vivek Gogte        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb                */
/* REVISION: 9.1      LAST MODIFIED: 09/11/00   BY: *N0RQ* Mudit Mehta        */
/* $Revision: 1.5.1.6 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/* $Revision: 1.5.1.6 $ BY: Bill Jiang DATE: 07/20/08 ECO: *SS - 20080720.1* */
/*-Revision end---------------------------------------------------------------*/

/* SS - 20080720.1 - B */
define input parameter i_lot like wo_lot.
define input parameter i_lot1 like wo_lot.
define input parameter i_part like wo_part.
define input parameter i_part1 like wo_part.
define input parameter i_site like wo_site.
define input parameter i_site1 like wo_site.
define input parameter i_line like wo_line.
define input parameter i_line1 like wo_line.
define input parameter i_endeff as date.
define input parameter i_endeff1 as date.

DEFINE NEW SHARED VARIABLE ttssreworp0201_recid AS RECID.

{ssreworp0201.i}
/* SS - 20080720.1 - E */

/* CUM WORKORDER COST REPORT                                                  */

/* SS - 20080720.1 - B */
/*
/*K0YF*/ {mfdtitle.i "2+ "}
*/
/*K0YF*/ {ssmfdtitle.i "20080720.1"}
/* SS - 20080720.1 - E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE reworp02_p_1 "Extended"
/* MaxLen: Comment: */

&SCOPED-DEFINE reworp02_p_2 "Component Materials"
/* MaxLen: Comment: */

&SCOPED-DEFINE reworp02_p_3 "End Effective"
/* MaxLen: Comment: */

&SCOPED-DEFINE reworp02_p_4 "Move Next Op"
/* MaxLen: Comment: */

&SCOPED-DEFINE reworp02_p_5 "Report BOM"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


/*N04H* {rewrsdef.i}                                 */

         define variable line like wo_line.
         define variable line1 like wo_line label {t001.i}.
         define variable lot like wo_lot.
         define variable lot1 like wo_lot label {t001.i}.
         define variable part like wo_part.
         define variable part1 like wo_part label {t001.i}.
         define variable site like wo_site.
         define variable site1 like wo_site label {t001.i}.
         define variable endeff as date label {&reworp02_p_3}.
         define variable endeff1 as date label {t001.i}.
         define variable report_bom like mfc_logical label {&reworp02_p_5}
                                    initial yes.
         define variable ext_amt like iro_cost_tot column-label {&reworp02_p_1}.


         form
            lot                  colon 20
            lot1                 colon 45
            part                 colon 20
            part1                colon 45
            site                 colon 20
            site1                colon 45
            line                 colon 20
            line1                colon 45
            endeff               colon 20
            endeff1              colon 45
            skip(1)
            report_bom           colon 32
         with frame a side-labels width 80 attr-space.

         /* SS - 20080720.1 - B */
         /*
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).
         */
         lot = i_lot.
         lot1 = i_lot1.
         part = i_part.
         part1 = i_part1.
         site = i_site.
         site1 = i_site1.
         line = i_line.
         line1 = i_line1.
         endeff = i_endeff.
         endeff1 = i_endeff1.
         /* SS - 20080720.1 - E */

         find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.

/*K0YF*/ {wbrp01.i}

         /* SS - 20080720.1 - B */
         /*
         repeat:
         */
         /* SS - 20080720.1 - E */

            if lot1 = hi_char then lot1 = "".
            if part1 = hi_char then part1 = "".
            if site1 = hi_char then site1 = "".
            if line1 = hi_char then line1 = "".

            /* SS - 20080720.1 - B */
            /*
/*K0YF*/    if c-application-mode <> 'web':u then
            update
               lot lot1
               part part1
               site site1
               line line1
               endeff endeff1
               report_bom
            with frame a.

/*K0YF*/    {wbrp06.i &command = update
                      &fields = "lot lot1 part part1 site site1
                                 line line1 endeff endeff1 report_bom"
                      &frm = "a"}
            */
            /* SS - 20080720.1 - E */

/*K0YF*/    if (c-application-mode <> 'web') or
/*K0YF*/       (c-application-mode = 'web' and
/*K0YF*/       (c-web-request begins 'data'))
            then do:

               bcdparm = "".
               {mfquoter.i lot              }
               {mfquoter.i lot1             }
               {mfquoter.i part             }
               {mfquoter.i part1            }
               {mfquoter.i site             }
               {mfquoter.i site1            }
               {mfquoter.i line             }
               {mfquoter.i line1            }
               {mfquoter.i endeff           }
               {mfquoter.i endeff1          }
               {mfquoter.i report_bom       }

               if lot1 = "" then lot1 = hi_char.
               if part1 = "" then part1 = hi_char.
               if site1 = "" then site1 = hi_char.
               if line1 = "" then line1 = hi_char.

/*K0YF*/    end.

            /* SS - 20080720.1 - B */
            /*
            {mfselbpr.i "printer" 132}
            {mfphead.i}
            */
            define variable l_textfile        as character no-undo.
            /* SS - 20080720.1 - E */

            /*NOTE: LOOK AT ALL ORDERS CLOSED OR NOT*/
            mainloop:
            for each wo_mstr no-lock
             where wo_mstr.wo_domain = global_domain and (  wo_type = "c"
            and wo_lot >= lot and wo_lot <= lot1
            and wo_part >= part and wo_part <= part1
            and wo_site >= site and wo_site <= site1
            and wo_line >= line and wo_line <= line1
            and (wo_due_date >= endeff or endeff = ?)
            and (wo_due_date <= endeff1 or endeff1 = ?)
            and wo_nbr = ""
            ) use-index wo_type_part,
            each pt_mstr no-lock
             where pt_mstr.pt_domain = global_domain and  pt_part = wo_part,
            each pl_mstr no-lock
             where pl_mstr.pl_domain = global_domain and  pl_prod_line =
             pt_prod_line
            by substring(wo_type,1,1) by wo_site by wo_part
            by wo_line by wo_due_date by wo_lot:

               /* SS - 20080720.1 - B */
               /*
               {gprun.i ""rewodisp.p"" "(input wo_lot)"}
               */
               /* SS - 20080720.1 - E */

               for each wr_route no-lock
                where wr_route.wr_domain = global_domain and  wr_lot = wo_lot
                with frame frame1:

                  find iro_det  where iro_det.iro_domain = global_domain and
                  iro_part = wo_part
                  and iro_site = wo_site
                  and iro_cost_set = "cumorder"
                  and iro_routing = wo_lot
                  and iro_op = wr_op
                  no-lock.

/*N04H*           {rewrsget.i &lot=wr_lot &op=wr_op &lock=no-lock}          */

                  find wc_mstr  where wc_mstr.wc_domain = global_domain and
                  wc_wkctr = wr_wkctr and wc_mch = wr_mch
                  no-lock no-error.

                  /* SS - 20080720.1 - B */
                  /*
                  /* SET EXTERNAL LABELS */
                  setFrameLabels(frame frame1:handle).

                  display
                     skip(2)
                     wr_op             colon 20
                     wr_desc           at 31 no-label
                     wr_setup          colon 76
                     iro_mtl_ll        colon 114
                     wr_wkctr          colon 20
                     wc_desc           at 31 no-label when (available wc_mstr)
                     wr_setup_rte      colon 76
                     iro_mtl_tl        colon 114
                     wr_mch            colon 20
                     wr_run            colon 76
                     iro_lbr_ll        colon 114
                     wr_milestone      colon 20
                     wr_lbr_rate       colon 76
                     iro_lbr_tl        colon 114
                     wr_mv_nxt_op      colon 20 label {&reworp02_p_4}
                     wr_bdn_pct        colon 76
                     iro_bdn_ll        colon 114
                     wr_bdn_rate       colon 76
                     iro_bdn_tl        colon 114
                     wr_mch_bdn        colon 76
                     iro_sub_ll        colon 114
                     wr_mch_op         colon 76
                     iro_sub_tl        colon 114
                     wr_sub_cost       colon 76
                     iro_cost_tot      colon 114
                     wr_yield_pct      colon 76
                  with frame frame1 side-labels width 132.
                  */
                  {gprun.i ""ssreworp0201disp.p"" "(input wo_lot)"}

                  FIND FIRST ttssreworp0201 WHERE recid(ttssreworp0201) = ttssreworp0201_recid EXCLUSIVE-LOCK.
                  ASSIGN
                     ttssreworp0201_wr_op = wr_op
                     ttssreworp0201_wr_desc = wr_desc
                     ttssreworp0201_wr_setup = wr_setup
                     ttssreworp0201_iro_mtl_ll = iro_mtl_ll
                     ttssreworp0201_wr_wkctr = wr_wkctr
                     ttssreworp0201_wc_desc = wc_desc
                     ttssreworp0201_wr_setup_rte = wr_setup_rte
                     ttssreworp0201_iro_mtl_tl = iro_mtl_tl
                     ttssreworp0201_wr_mch = wr_mch
                     ttssreworp0201_wr_run = wr_run
                     ttssreworp0201_iro_lbr_ll = iro_lbr_ll
                     ttssreworp0201_wr_milestone = wr_milestone
                     ttssreworp0201_wr_lbr_rate = wr_lbr_rate
                     ttssreworp0201_iro_lbr_tl = iro_lbr_tl
                     ttssreworp0201_wr_mv_nxt_op = wr_mv_nxt_op
                     ttssreworp0201_wr_bdn_pct = wr_bdn_pct
                     ttssreworp0201_iro_bdn_ll = iro_bdn_ll
                     ttssreworp0201_wr_bdn_rate = wr_bdn_rate
                     ttssreworp0201_iro_bdn_tl = iro_bdn_tl
                     ttssreworp0201_wr_mch_bdn = wr_mch_bdn
                     ttssreworp0201_iro_sub_ll = iro_sub_ll
                     ttssreworp0201_wr_mch_op = wr_mch_op
                     ttssreworp0201_iro_sub_tl = iro_sub_tl
                     ttssreworp0201_wr_sub_cost = wr_sub_cost
                     ttssreworp0201_iro_cost_tot = iro_cost_tot
                     ttssreworp0201_wr_yield_pct = wr_yield_pct
                     .
                  /* SS - 20080720.1 - E */

                  /* SS - 20080720.1 - B */
                  /*
                  if report_bom then do:

                     for each wod_det no-lock
                      where wod_det.wod_domain = global_domain and  wod_lot =
                      wr_lot
                     and wod_op = wr_op,
                     each qad_wkfl no-lock
                      where qad_wkfl.qad_domain = global_domain and  qad_key1 =
                      "MFWORLA"
                     and qad_key2 = wod_lot + wod_part + string(wod_op)
                     and qad_charfld[1] = "s"
/*N0RQ*              by wod_part: */
/*N0RQ*/             by wod_part with frame f-a:

                        /* SET EXTERNAL LABELS */
/*N0RQ*/                setFrameLabels(frame f-a:handle).

                        ext_amt = wod_bom_qty * wod_bom_amt.

                        display
                           space(15)
                           wod_part
                           wod_bom_qty
                           wod_bom_amt
                           ext_amt (total)
                        with title (getFrameTitle("COMPONENT_MATERIALS",25))
                        width 90.

                        {mfrpchk.i &label=mainloop}

                     end.

                  end.
                  */
                  /* SS - 20080720.1 - E */

                  {mfrpchk.i &label=mainloop}

               end.

               /* SS - 20080720.1 - B */
               /*
               page.
               */
               /* SS - 20080720.1 - E */

               {mfrpchk.i}

            end.

         /* SS - 20080720.1 - B */
         /*
            {mfrtrail.i}

         end.
         */
         /* SS - 20080720.1 - E */

/*K0YF*/ {wbrp04.i &frame-spec = a}
