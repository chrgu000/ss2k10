/* wowoisa.p - WORK ORDER ISSUE WITH SERIAL NUMBERS SUBROUTINE           */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.          */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                    */
/* REVISION: 1.0      LAST MODIFIED: 07/28/86   BY: pml                  */
/* REVISION: 1.0      LAST MODIFIED: 06/30/86   BY: emb                  */
/* REVISION: 1.0      LAST MODIFIED: 10/30/86   BY: emb *39*             */
/* REVISION: 1.0      LAST MODIFIED: 03/03/87   BY: emb *A25*            */
/* REVISION: 1.0      LAST MODIFIED: 02/13/87   BY: pml *A26*            */
/* REVISION: 2.0      LAST MODIFIED: 03/20/87   BY: emb *A45*            */
/* REVISION: 2.1      LAST MODIFIED: 06/15/87   BY: wug *A66*            */
/* REVISION: 2.1      LAST MODIFIED: 11/20/87   BY: emb *A75*            */
/* REVISION: 2.1      LAST MODIFIED: 07/23/87   BY: wug *A77*            */
/* REVISION: 2.1      LAST MODIFIED: 08/31/87   BY: wug *A94*            */
/* REVISION: 2.1      LAST MODIFIED: 09/11/87   BY: wug *A94*            */
/* REVISION: 2.1      LAST MODIFIED: 11/04/87   BY: wug *A102*           */
/* REVISION: 2.1      LAST MODIFIED: 01/18/88   BY: wug *A151*           */
/* REVISION: 4.0      LAST MODIFIED: 02/01/88   BY: emb *A170*           */
/* REVISION: 4.0      LAST MODIFIED: 02/29/88   BY: flm *A179*           */
/* REVISION: 4.0      LAST MODIFIED: 03/14/88   BY: rl  *A171*           */
/* REVISION: 4.0      LAST MODIFIED: 03/28/88   BY: wug *A187*           */
/* REVISION: 4.0      LAST MODIFIED: 04/13/88   BY: emb *A198*           */
/* REVISION: 4.0      LAST MODIFIED: 05/24/88   BY: flm *A252*           */
/* REVISION: 4.0      LAST MODIFIED: 11/09/88   BY: emb *A527*           */
/* REVISION: 4.0      LAST MODIFIED: 02/09/89   BY: emb *A643*           */
/* REVISION: 5.0      LAST MODIFIED: 06/23/89   BY: mlb *B159*           */
/* REVISION: 4.0      LAST MODIFIED: 06/30/89   BY: emb *A755*           */
/* REVISION: 5.0      LAST MODIFIED: 07/05/89   BY: bjj *B106*           */
/* REVISION: 6.0      LAST MODIFIED: 04/03/90   BY: wug *D015*           */
/* REVISION: 5.0      LAST MODIFIED: 04/13/90   BY: emb *B664*           */
/* REVISION: 6.0      LAST MODIFIED: 04/03/90   BY: wug *D002*           */
/* REVISION: 6.0      LAST MODIFIED: 05/18/90   BY: emb *D025*           */
/* REVISION: 6.0      LAST MODIFIED: 07/06/90   BY: emb *D040*           */
/* REVISION: 6.0      LAST MODIFIED: 03/14/91   BY: wug *D472*           */
/* REVISION: 7.0      LAST MODIFIED: 10/18/91   BY: pma *F003*           */
/* REVISION: 6.0      LAST MODIFIED: 11/11/91   BY: wug *D887*           */
/* REVISION: 6.0      LAST MODIFIED: 11/29/91   BY: ram *D954*           */
/* REVISION: 7.0      LAST MODIFIED: 01/24/92   BY: pma *F003*           */
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: pma *F190*           */
/* REVISION: 7.0      LAST MODIFIED: 10/19/92   BY: emb *G208*           */
/* REVISION: 7.3      LAST MODIFIED: 09/27/93   BY: jcd *G247*           */
/* REVISION: 7.3      LAST MODIFIED: 10/19/92   BY: emb *G329*           */
/* REVISION: 7.3      LAST MODIFIED: 02/08/93   BY: emb *G656*           */
/* REVISION: 7.3      LAST MODIFIED: 03/04/93   BY: ram *G782*           */
/* REVISION: 7.3      LAST MODIFIED: 03/25/93   BY: emb *G872*           */
/* REVISION: 7.3      LAST MODIFIED: 04/21/93   BY: pma *GA01*           */
/* REVISION: 7.3      LAST MODIFIED: 04/27/93   BY: ram *GA50*           */
/* REVISION: 7.3      LAST MODIFIED: 09/15/93   BY: ram *GF19*           */
/* REVISION: 7.3      LAST MODIFIED: 02/15/94   BY: pxd *FL60*           */
/* REVISION: 7.2      LAST MODIFIED: 04/11/94   BY: ais *GJ31*           */
/* REVISION: 7.3      LAST MODIFIED: 09/15/94   by: slm *GM61*           */
/* REVISION: 7.3      LAST MODIFIED: 10/05/94   by: pxd *FR90*           */
/*           7.3                     10/29/94   BY: bcm *GN73*           */
/* REVISION: 7.3      LAST MODIFIED: 11/02/94   by: ame *FT23*           */
/* REVISION: 7.2      LAST MODIFIED: 01/18/95   by: ais *F0F2*           */
/* REVISION: 7.3      LAST MODIFIED: 06/06/95   by: kjm *G0P7*           */
/* REVISION: 7.2      LAST MODIFIED: 08/17/95   BY: qzl *F0TC*           */
/* REVISION: 8.5      LAST MODIFIED: 09/26/95   by: sxb *J053*           */
/* REVISION: 7.3      LAST MODIFIED: 10/24/95   by: jym *G19W*           */
/* REVISION: 7.2      LAST MODIFIED: 01/16/96   BY: ame *G1K4*           */
/* REVISION: 7.3      LAST MODIFIED: 01/22/96   BY: vrn *G1KQ*           */
/* REVISION: 7.2      LAST MODIFIED: 03/19/96   BY: rvw *F0X3*           */
/* REVISION: 7.3      LAST MODIFIED: 03/26/96   BY: rvw *G1R0*           */
/* REVISION: 8.5      LAST MODIFIED: 04/11/96   BY: *J04C* Sue Poland       */
/* REVISION: 8.5      LAST MODIFIED: 04/11/96   BY: *J04C* Markus Barone    */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke      */
/* REVISION: 8.6      LAST MODIFIED: 04/30/97   BY: *G2JJ* Murli Shastri    */
/* REVISION: 8.6      LAST MODIFIED: 09/29/97   BY: *J1PS* Felcy D'Souza    */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton     */
/* REVISION: 9.1      LAST MODIFIED: 06/04/99   BY: *J3DH* Satish Chavan    */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Vijaya Pakala    */
/* REVISION: 9.1      LAST MODIFIED: 07/22/99   BY: *J3J7* Sanjeev Assudani */
/* REVISION: 9.1      LAST MODIFIED: 08/02/99   BY: *J3K2* Sanjeev Assudani */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *N002* Bill Gates       */
/* REVISION: 9.1      LAST MODIFIED: 11/05/99   BY: *K244* Jyoti Thatte     */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* Mark Brown       */
/* REVISION: 9.1      LAST MODIFIED: 11/13/00   BY: *N0TN* Jean Miller      */
/* REVISION: 9.1      LAST MODIFIED: 10/05/00   BY: *N0W1* Mudit Mehta      */
/****************************************************************************/

         {mfdeclre.i}
/*N0TN*/ {gplabel.i}
/*N0W1*/ {cxcustom.i "WOWOISA.P"}
         /*********************************************************/
         /* NOTES:   1. Patch FL60 sets in_level to a value       */
         /*             of 99999 when in_mstr is created or      */
         /*             when any structure or network changes are */
         /*             made that affect the low level codes.     */
         /*          2. The in_levels are recalculated when MRP   */
         /*             is run or can be resolved by running the  */
         /*             mrllup.p utility program.                 */
         /*********************************************************/

/*J3DH*/ define input  parameter l_specific_wo       as logical NO-UNDO.
/*N002*/ define input parameter ophist_recid as recid no-undo.

         define shared variable wo_recno as recid.
         define shared var v_trchr01 like pt_part  .  /*davild-20051206*/
         define variable qty_left like tr_qty_chg.
         define variable trqty like tr_qty_chg.
         define shared variable wopart_wip_acct like pl_wip_acct.
/*N014*/ define shared variable wopart_wip_sub like pl_wip_sub.
         define shared variable wopart_wip_cc like pl_wip_cc.
         define shared variable eff_date like glt_effdate.
         define variable ref like glt_ref.
         define variable open_ref like mrp_qty.
         define variable site like sod_site.
         define variable location like sod_loc.
         define variable lotser like sod_serial.
         define variable lotref like sr_ref.
         define variable dr_acct like wopart_wip_acct.
/*N014*/ define variable dr_sub like wopart_wip_sub.
         define variable dr_cc like wopart_wip_cc.
/*N014*  define variable icx_acct like wopart_wip_acct.
         define variable icx_cc like wopart_wip_cc. */
         define variable wo_entity like en_entity.
         define variable from_entity like en_entity.
         define variable gl_amt like glt_amt.
         define new shared variable transtype as character format "x(7)".
         define variable var_amt like glt_amt.
         define variable glcost like sct_cst_tot.
         define variable assay like tr_assay.
         define variable grade like tr_grade.
         define variable expire like tr_expire.
         define variable glx_mthd like cs_method.
         define variable glx_set like cs_set.
         define variable cur_mthd like cs_method.
         define variable cur_set like cs_set.
         define variable gl_tmp_amt  as decimal no-undo.
         define variable inrecno  as recid no-undo.
/*N002*/ define shared variable h_wiplottrace_procs as handle no-undo.
/*N002*/ define shared variable h_wiplottrace_funcs as handle no-undo.
/*N002*/ {wlfnc.i} /* FUNCTION FORWARD DECLARATIONS */
/*N002*/ {wlcon.i} /* CONSTANTS DEFINITIONS         */
/*N0W1*/ {&WOWOISA-P-TAG1}

         find first gl_ctrl no-lock.
         /* THE LOCK HAS BEEN CHANGED TO EXCLUSIVE IN VERSIONS 85 & 86 ONLY */
         /* FOR SOLVING DEADLY EMBRACE SITUATION BETWEEN WOWOIS.P AND */
         /* WOCSWIPA.P. THIS CHANGE WAS REQUIRED FOR SOLVING THIS PROBLEM */
         /* IN ORACLE ENVIRONMENT ONLY. */

/*K244*/ /* THE LOCK HAS BEEN CHANGED TO NO-LOCK FROM EXCLUSIVE LOCK   */
/*K244*/ /* TO REMOVE THE PROCEDURE TRANSACTION BLOCK                  */

/*K244** find wo_mstr exclusive-lock where recid(wo_mstr) = wo_recno.  */

/*K244*/ for first wo_mstr
/*K244*/    fields (wo_site)
/*K244*/    no-lock where recid(wo_mstr) = wo_recno:
/*K244*/ end. /* FOR FIRST WO_MSTR */

         find si_mstr where si_site = wo_site no-lock.
         wo_entity = si_entity.

/*N0W1*/ {&WOWOISA-P-TAG2}
         for each wo_mstr exclusive-lock where recid(wo_mstr) = wo_recno,
         each wod_det exclusive-lock where wod_lot = wo_lot
         and can-find (first sr_wkfl where sr_userid = mfguser
             and sr_lineid = string(wod_part,"x(18)") + string(wod_op)):

            find pt_mstr no-lock where pt_part = wod_part no-error.
            qty_left = wod_qty_chg.

               /* GPINCR.P ROUTINE IS USED TO CREATE IN_MSTR RECORD */
               find si_mstr where si_site = wod_site no-lock no-error.
               {gprun.i ""gpincr.p"" "(input no,
                                       input wod_part,
                                       input wod_site,
                                       input if available si_mstr then
                                                 si_gl_set
                                             else """",
                                       input if available si_mstr then
                                                 si_cur_set
                                             else """",
                                       input if available pt_mstr then
                                                 pt_abc
                                             else """",
                                       input if available pt_mstr then
                                                 pt_avg_int
                                             else 0,
                                       input if available pt_mstr then
                                                 pt_cyc_int
                                             else 0,
                                       input if available pt_mstr then
                                                 pt_rctpo_status
                                             else """",
                                       input if available pt_mst then
                                                 pt_rctpo_active
                                             else no,
                                       input if available pt_mstr then
                                                 pt_rctwo_status
                                             else """",
                                       input if available pt_mstr then
                                                 pt_rctwo_active
                                             else no,
                                       output inrecno)" }

               find in_mstr where recid(in_mstr) = inrecno
               no-lock no-error.

            for each sr_wkfl where sr_userid = mfguser
            and sr_lineid = string(wod_part,"x(18)") + string(wod_op)
            and sr_qty <> 0 no-lock:

               /* FIND APPROPRIATE IN_MSTR FOR USE IN GPSCT03.I BELOW    */
               if in_part = wod_part and in_site <> sr_site then

           /* GPINCR.P ROUTINE IS USED TO CREATE IN_MSTR RECORD */
           find si_mstr where si_site = sr_site no-lock no-error.
               {gprun.i ""gpincr.p"" "(input no,
                               input wod_part,
                               input sr_site,
                               input if available si_mstr then
                         si_gl_set
                         else """",
                               input if available si_mstr then
                         si_cur_set
                         else """",
                                       input if available pt_mstr then
                             pt_abc
                                             else """",
                                       input if available pt_mstr then
                                 pt_avg_int
                                             else 0,
                                       input if available pt_mstr then
                             pt_cyc_int
                                             else 0,
                                       input if available pt_mstr then
                                 pt_rctpo_status
                                             else """",
                                       input if available pt_mstr then
                                                 pt_rctpo_active
                                             else no,
                                       input if available pt_mstr then
                                 pt_rctwo_status
                                             else """",
                                       input if available pt_mstr then
                                                 pt_rctwo_active
                                             else no,
                           output inrecno)" }

               find in_mstr where recid(in_mstr) = inrecno
           exclusive-lock.

               /* IF THIS WORK ORDER IS COMING FROM FSRMAREL.P (RMA RELEASE  */
               /* TO WORK ORDER), IT'S WO_FSM_TYPE = "RMA".  IN THIS CASE,   */
               /* WE MAY HAVE MULTIPLE SR_WKFL'S, EACH CONTAINING UNIQUE     */
               /* LOTSER'S, AND EACH LOTSER SHOULD BE ISSUED TO A SPECIFIC   */
               /* WORK ORDER, NOT ALL ISSUED TO ONE ORDER.  SO, ENSURE WE    */
               /* HAVE THE CORRECT LOTSER'S SR_WKFL.                         */
               /* COPIED FROM 85 PATCH J04C                                  */
/*J3DH*/       if l_specific_wo then
               if wo_fsm_type = "RMA" and wod_serial <> " " then
                    if sr_lotser <> wod_serial then next.

               assign
               site = sr_site
               location = sr_loc
               lotser = sr_lotser
               lotref = sr_ref
               trqty = sr_qty.

               assign v_trchr01 = sr__qadc01 .   /*add-by-davild20051206*/
               
               /*PARTS THAT ARE NOT ISSUED FROM THE WO SITE, MUST BE TRANSFERED
               TO THE WO SITE BEFORE THEY CAN BE ISSUED TO THE WORK ORDER*/
/*N014*/       assign
               glxcst = 0
               gl_amt = 0
               dr_acct = ""
/*N014*/       dr_sub = ""
               dr_cc = ""
               global_part = wod_part
               global_addr = ""
               transtype = "ISS-WO".
               if available pl_mstr then find pld_det no-lock
               where pld_prodline = pl_prod_line
               and pld_site = wo_site no-error.

               if available pt_mstr then do:
                  {gprun.i ""wowipmtl.p""
                           "(wo_nbr, wo_lot, trqty, site, wod_op,
                             output glx_set, output glx_mthd,
                             output cur_set, output cur_mthd)"}

                  if site <> wo_site then do:

                     /*INPUT PARAMETER ORDER:                             */
                     /*TR_LOT, TR_SERIAL, LOTREF_FROM, LOTREF_TO,         */
                     /*QUANTITY, TR_NBR, TR_SO_JOB, TR_RMKS,              */
                     /*PROJECT, TR_EFFDATE, SITE_FROM, LOC_FROM, SITE_TO, */
                     /*LOC_TO, TEMPID,                                    */
                     /*SHIP_NBR, SHIP_DATE, INV_MOV,                      */
                     /*GLCOST,                                            */
                     /*ASSAY, GRADE, EXPIRE                               */
/*N0W1*/             {&WOWOISA-P-TAG3}
                     {gprun.i ""icxfer.p"" "(input wo_lot,
                                             input lotser,
                                             input lotref,
                                             input lotref,
                                             input trqty,
                                             input wo_nbr,
                                             input wo_so_job,
                                             input """",
                                             input wo_project,
                                             input eff_date,
                                             input site,
                                             input location,
                                             input wo_site,
                                             input pt_loc,
                                             input no,
                                             """",
                                             ?,
                                             """",
                                             output glcost,
                                             input-output assay,
                                             input-output grade,
                                             input-output expire)"
                     }
/*N0W1*/             {&WOWOISA-P-TAG4}
                     glxcst = glcost.
                  end.
                  else do:
                     {gpsct03.i &cost=sct_cst_tot}
                  end.
/*N014*/          assign
                  dr_acct = wopart_wip_acct
/*N014*/          dr_sub = wopart_wip_sub
                  dr_cc = wopart_wip_cc
                  gl_amt = trqty * glxcst.
                  /* ROUND gl_amt TO BASE CURRENCY PRECISION */
                  {gprun.i ""gpcurrnd.p"" "(input-output gl_amt,
                                            input gl_rnd_mthd)"}
                  if glx_mthd = "AVG" then var_amt = 0.
                  else
                  do:
                     var_amt = (glxcst - wod_bom_amt) * trqty.
                     /* ROUND var_amt TO BASE CURRENCY PRECISION */
                     {gprun.i ""gpcurrnd.p"" "(input-output var_amt,
                                               input gl_rnd_mthd)"}
                  end. /* ELSE */
               end. /* IF AVAILABLE PT_MSTR */

/*L00Y*/       /* ADDED SECOND EXCHANGE RATE, TYPE, SEQUENCE */
/*N014*/       /* ADDED &crsub AND &drsub PARAMETERS TO ictrans.i        */
/*N0W1*/       {&WOWOISA-P-TAG5}
               {ictrans.i
                  &addrid=wo_vend
                  &bdnstd=0
                  &cracct="
                     if available pt_mstr then
                        if available pld_det then pld_inv_acct
                        else pl_inv_acct
                     else """""
                  &crsub="
                     if available pt_mstr then
                        if available pld_det then pld_inv_sub
                        else pl_inv_sub
                     else """""
                  &crcc="
                     if available pt_mstr then
                        if available pld_det then pld_inv_cc
                        else pl_inv_cc
                     else """""
                  &crproj="
                     if available pt_mstr then wo_project else """""
                  &curr=""""
                  &dracct=dr_acct
                  &drsub=dr_sub
                  &drcc=dr_cc
                  &drproj="
                     if available pt_mstr then wo_project else """""
                  &effdate=eff_date
                  &exrate=0
                  &exrate2=0
                  &exratetype=""""
                  &exruseq=0
                  &glamt=gl_amt
                  &lbrstd=0
                  &line=0
                  &location="(if site <> wo_site then pt_loc
                             else location)"
                  &lotnumber=wod_lot
                  &lotref=lotref
                  &lotserial=lotser
                  &mtlstd=0
                  &ordernbr=wod_nbr
                  &ovhstd=0
                  &part=wod_part
                  &perfdate=?
                  &price=glxcst
                  &quantityreq="wod_qty_req - wod_qty_iss"
                  &quantityshort=wod_bo_chg
                  &quantity="- trqty"
                  &revision=""""
                  &rmks=v_trchr01       /*add-by-davild20051206*/
                  &shiptype=""""
                  &site=wo_site
                  &slspsn1=""""
                  &slspsn2=""""
                  &sojob=wo_so_job
                  &substd=0
                  &transtype=""ISS-WO""
                  &msg=0
                  &ref_site=tr_site
               }
/*N0W1*/       {&WOWOISA-P-TAG6}
               tr_fsm_type = wo_fsm_type.

               /* UPDATE WORK ORDER WIP AMOUNT */

               /* CREDIT WIP FOR ANY MATERIAL RATE VARIANCE           */
               /* DUE TO CHANGE IN THE STD COST AT THE WORK ORDER SITE*/
               if var_amt <> 0 then do:
                  create trgl_det.
                  assign trgl_trnbr = tr_trnbr
                     trgl_type = "RATE VAR"
                     trgl_sequence = recid(trgl_det)
                     trgl_dr_acct = wo_mvrr_acct
/*N014*/             trgl_dr_sub = wo_mvrr_sub
                     trgl_dr_cc   = wo_mvrr_cc
/*J3J7**             trgl_dr_proj   = "" */
/*J3J7*/             trgl_dr_proj   = wo_project
                     trgl_cr_acct = dr_acct
/*N014*/             trgl_cr_sub  = dr_sub
                     trgl_cr_cc   = dr_cc
                     trgl_cr_proj = wo_project
                     trgl_gl_amt  = var_amt.

                  tr_gl_amt = tr_gl_amt - var_amt.
                  if recid(trgl_det) = -1 then .
/*N014*/        /* ADDED &dr-sub AND &cr-sub PARAMETERS TO mficgl02.i */
                  {mficgl02.i
                     &gl-amount=var_amt     &tran-type=tr_type
                     &order-no=tr_nbr       &dr-acct=trgl_dr_acct
             &dr-sub=trgl_dr_sub    &dr-cc=trgl_dr_cc
             &drproj=trgl_dr_proj   &cr-acct=trgl_cr_acct
             &cr-sub=trgl_cr_sub    &cr-cc=trgl_cr_cc
                     &crproj=trgl_cr_proj   &entity=wo_entity
                     &find="false"          &same-ref="icc_gl_sum"
                  }
               end.

               /*ASSAY, GRADE, EXPIRE */
               if site <> wo_site then do:
                  tr_assay = assay.
                  tr_grade = grade.
                  tr_expire = expire.
               end.

/*N002*/       if wo_fsm_type <> "RMA" then do:
/*N002*/          if is_wiplottrace_enabled()
/*N002*/          and is_operation_queue_lot_controlled
/*N002*/              (wod_lot, wod_op, OUTPUT_QUEUE)
/*N002*/          and is_wocomp_wiplot_traced(wod_lot, wod_part)
/*N002*/          then do:
/*N002*/             for first op_hist where recid(op_hist) = ophist_recid
/*N002*/             no-lock: end.
/*N002*/
/*N002*/             if available op_hist then do:
/*N002*/             /*REGISTER THE MATERIAL CONSUMED IN THE TRACING JOURNAL*/
/*N002*/
/*N002*/                run add_trace_record in h_wiplottrace_procs
/*N002*/                (
/*N002*/                input OPERATION_HISTORY,
/*N002*/                input op_trnbr,
/*N002*/                input CONSUMED_MTL,
/*N002*/                input ITEM_MTL,
/*N002*/                input '',
/*N002*/                input 0,
/*N002*/                input wod_part,
/*N002*/                input lotser,
/*N002*/                input
/*N002*/                   if is_wocomp_reference_traced(wod_lot, wod_part)
/*N002*/                      then lotref
/*N002*/                   else '',
/*N002*/                input trqty
/*N002*/                ).
/*N002*/             end. /* if available op_hist */
/*N002*/          end.
/*N002*/       end.
            end.

            for each sr_wkfl exclusive-lock where sr_userid = mfguser
            and sr_lineid = string(wod_part,"x(18)") + string(wod_op):

            /* IF THIS WORK ORDER IS COMING FROM FSRMAREL.P (RMA RELEASE     */
            /* TO WORK ORDER), IT'S WO_FSM_TYPE = "RMA".  IN THIS CASE,      */
            /* WE MAY HAVE MULTIPLE SR_WKFL'S, EACH CONTAINING UNIQUE        */
            /* LOTSER'S, AND EACH LOTSER SHOULD BE ISSUED TO A SPECIFIC      */
            /* WORK ORDER, NOT ALL ISSUED TO ONE ORDER.  SO, ENSURE WE       */
            /* HAVE THE CORRECT LOTSER'S SR_WKFL (I.E., THE LOTSER ISSUED    */
            /* TO THE CURRENT W.O. IN THE PREVIOUS SR_WKFL FOR-EACH LOOP)    */
            /* BEFORE WE RELIEVE THE INVENTORY ALLOCATION AND DELETE SR_WKFL */
            /* COPIED FROM 85 PATCH J04C                                     */
/*J3DH*/       if l_specific_wo then
               if wo_fsm_type = "RMA" and wod_serial <> " " then
                    if sr_lotser <> wod_serial then next.

               if sr_qty <> 0 then do:

                  find lad_det exclusive-lock where lad_dataset = "wod_det"
                  and lad_nbr = wod_lot and lad_line = string(wod_op)
                  and lad_part = wod_part
                  and lad_site = sr_site and lad_loc = sr_loc
                  and lad_lot = sr_lotser and lad_ref = sr_ref no-error.

                  if available lad_det then do:

                     open_ref = min(sr_qty,lad_qty_pick).
                     assign
                        sr_qty = sr_qty - open_ref
                        lad_qty_pick = lad_qty_pick - open_ref.

                     find ld_det exclusive-lock where ld_site = lad_site
                     and ld_part = lad_part and ld_loc = lad_loc
                     and ld_lot = lad_lot and ld_ref = lad_ref no-error.

                     if available ld_det
                     then ld_qty_all = ld_qty_all - open_ref.

                     open_ref = min(sr_qty,lad_qty_all).
                     assign
                        sr_qty = sr_qty - open_ref
                        lad_qty_all = lad_qty_all - open_ref.

                     if available ld_det
                     then ld_qty_all = ld_qty_all - open_ref.
                     {mflddel.i}
                     if lad_qty_all = 0 and lad_qty_pick = 0
                     then delete lad_det.
                  end.
               end.

               delete sr_wkfl.

            end.

            /* SUBTRACT QTY ALLOCATED FROM INVENTORY MASTER */
            find in_mstr where in_part = wod_part and in_site = wod_site
            exclusive-lock no-error.
            /* WO'S CREATED FROM RMA'S SHOULDN'T EFFECT IN_QTY_REQ */
            if wo_fsm_type <> "RMA" then do:
               if available in_mstr then do:
                  in_qty_all = in_qty_all - wod_qty_pick - wod_qty_all.
                  if wod_qty_req >= 0
                  then
                     in_qty_req = in_qty_req - max(wod_qty_req - wod_qty_iss,0).
                  else
                     in_qty_req = in_qty_req - min(wod_qty_req - wod_qty_iss,0).
               end.
            end.

            /* UPDATE WORK ORDER ALLOCATION */
            assign
               wod_qty_req = (if wod_qty_req >= 0
                  then max(
                       min(wod_qty_req,wod_qty_iss + wod_qty_chg + wod_bo_chg)
                       ,0)
                  else min(
                       max(wod_qty_req,wod_qty_iss + wod_qty_chg + wod_bo_chg)
                       ,0))
            wod_qty_iss = wod_qty_iss + wod_qty_chg
            wod_qty_all = 0
            wod_qty_pick = 0
            wod_qty_chg = 0
            wod_bo_chg = 0.

            /* ADD REMAINING QTY ALLOCATED BACK TO PART MASTER */
            if available in_mstr then do:
            /* WO'S CREATED FROM RMA'S SHOULDN'T EFFECT IN_QTY_REQ */
               if wo_fsm_type <> "RMA" then do:
                  if wod_qty_req >= 0
                  then
                     in_qty_req = in_qty_req + max(wod_qty_req - wod_qty_iss,0).
                  else
                     in_qty_req = in_qty_req + min(wod_qty_req - wod_qty_iss,0).
               end.
            end.

            /* MRP WORKFILE */
            if wod_qty_req >= 0
            then open_ref = max(wod_qty_req - max(wod_qty_iss,0),0).
            else open_ref = min(wod_qty_req - min(wod_qty_iss,0),0).

            {mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot """"}

            {mfmrw.i "wod_det" wod_part wod_nbr wod_lot string(wod_op)
             ? wod_iss_date open_ref "DEMAND" " " wod_site}

            for each lad_det exclusive-lock where
            lad_dataset = "wod_det"
            and lad_nbr = wod_lot and lad_line = string(wod_op)
            and lad_part = wod_part:

               if open_ref > 0 then do:

                  if open_ref >= lad_qty_pick then
                     assign
                        open_ref = open_ref - lad_qty_pick
                        wod_qty_pick = wod_qty_pick + lad_qty_pick.
                  else do:
                        wod_qty_pick = wod_qty_pick + open_ref.

                     find ld_det exclusive-lock where ld_site = lad_site
                     and ld_part = lad_part and ld_loc = lad_loc
                     and ld_lot = lad_lot and ld_ref = lad_ref no-error.
                     if available ld_det then
                        ld_qty_all = ld_qty_all - lad_qty_pick + open_ref.

                     assign
                        lad_qty_pick = open_ref
                        open_ref = 0.
                  end.

                  if open_ref >= lad_qty_all then
                     assign
                        open_ref = open_ref - lad_qty_all
                        wod_qty_all = wod_qty_all + lad_qty_all.
                  else do:
                     wod_qty_all = wod_qty_all + open_ref.

                     find ld_det exclusive-lock where ld_site = lad_site
                     and ld_part = lad_part and ld_loc = lad_loc
                     and ld_lot = lad_lot and ld_ref = lad_ref no-error.
                     if available ld_det then
                        ld_qty_all = ld_qty_all - lad_qty_all + open_ref.

                     assign
                        lad_qty_all = open_ref
                        open_ref = 0.
                  end.
                  if lad_qty_all = 0 and lad_qty_pick = 0 then delete lad_det.
               end.
               else do:
                  find ld_det exclusive-lock where ld_site = lad_site
                  and ld_part = lad_part and ld_loc = lad_loc
                  and ld_lot = lad_lot and ld_ref = lad_ref no-error.
                  if available ld_det then
                     ld_qty_all = ld_qty_all - (lad_qty_all + lad_qty_pick).

                  delete lad_det.
               end.
               {mflddel.i}
            end.  /* for each lad_det */

            /* wod_qty_all SHOULD ALWAYS BE >= 0 AND <= MIN OF QTY REQ OR OPEN */
            if wod_qty_req >= 0 and open_ref > 0 then
/*J3K2**       wod_qty_all = min(wod_qty_req,open_ref). */
/*J3K2*/       wod_qty_all = min(wod_qty_req, wod_qty_all + open_ref).
              if wod_qty_all < 0 then wod_qty_all = 0.

            find in_mstr exclusive-lock
            where in_part = wod_part
              and in_site = wod_site no-error.

            /* WO'S CREATED FROM RMA'S SHOULDN'T EFFECT IN_QTY_REQ */
            if wo_fsm_type <> "RMA" then do:
               if available in_mstr then
                  in_qty_all = in_qty_all + wod_qty_all + wod_qty_pick.
            end.

         end.  /* for each wod_det */

