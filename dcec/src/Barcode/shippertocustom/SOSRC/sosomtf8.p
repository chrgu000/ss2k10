/* GUI CONVERTED from sosomtf8.p (converter v1.75) Thu Dec 14 03:15:47 2000 */
/* sosomtf8.p  - SALES ORDER MAINTENANCE - CONFIGURED ITEM              */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*H0CJ*/ /*V8:ConvertMode=Maintenance                                   */
/*V8:RunMode=Character,Windows                                          */
/* REVISION: 7.3      LAST MODIFIED: 09/09/94   BY: afs *H510*          */
/* REVISION: 7.3      LAST MODIFIED: 11/01/94   BY: ame *GN90*          */
/* REVISION: 7.3      LAST MODIFIED: 11/04/94   BY: afs *FT39*          */
/* REVISION: 7.3      LAST MODIFIED: 11/11/94   BY: qzl *FT43*          */
/* REVISION: 7.4      LAST MODIFIED: 02/10/95   BY: rxm *F0HM*          */
/* REVISION: 7.4      LAST MODIFIED: 02/17/95   BY: bcm *F0JJ*          */
/* REVISION: 7.4      LAST MODIFIED: 03/07/95   BY: kjm *F0LT*          */
/* REVISION: 7.4      LAST MODIFIED: 03/13/95   BY: jpm *H0BZ*          */
/* REVISION: 7.4      LAST MODIFIED: 03/21/95   BY: rxm *F0MV*          */
/* REVISION: 7.4      LAST MODIFIED: 04/17/95   BY: jpm *H0CJ*          */
/* REVISION: 8.5      LAST MODIFIED: 03/08/95   BY: DAH *J042*          */
/* REVISION: 7.4      LAST MODIFIED: 08/25/95   BY: jym *G0TW*          */
/* REVISION: 7.4      LAST MODIFIED: 11/01/95   BY: rxm *G1B4*          */
/* REVISION: 7.4      LAST MODIFIED: 12/07/95   BY: rxm *H0FS*          */
/* REVISION: 8.5      LAST MODIFIED: 04/02/96   BY: DAH *J0GT*          */
/* REVISION: 8.5      LAST MODIFIED: 04/11/96   BY: DAH *J0HR*          */
/* REVISION: 8.5      LAST MODIFIED: 05/22/96   BY: DAH *J0N2*          */
/* REVISION: 8.5      LAST MODIFIED: 07/05/96   BY: DAH *J0XR*          */
/* REVISION: 8.5      LAST MODIFIED: 07/11/96   BY: kxn *J0YR*          */
/* REVISION: 8.5      LAST MODIFIED: 07/16/96   BY: ajw *J0Z6*          */
/* REVISION: 8.5      LAST MODIFIED: 07/22/96   BY: *G29J* Suresh Nayak */
/* REVISION: 8.5      LAST MODIFIED: 07/24/96   BY: *J116* Dennis Henson*/
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   BY: *J12Q* Andy Wasilczuk*/
/* REVISION: 8.5      LAST MODIFIED: 08/21/96   BY: *F0X9* Tony Patel   */
/* REVISION: 8.5      LAST MODIFIED: 09/13/96   BY: *G2F4* Aruna P.Patil*/
/* REVISION: 8.6      LAST MODIFIED: 10/28/96   BY: flm *K003*          */
/* REVISION: 8.6      LAST MODIFIED: 03/06/97   BY: *H0TB* Jim Williams */
/* REVISION: 8.6      LAST MODIFIED: 09/12/97   BY: *H1F4* Aruna Patil  */
/* REVISION: 8.6      LAST MODIFIED: 10/03/97   BY: *K0H6* Joe Gawel    */
/* REVISION: 8.6      LAST MODIFIED: 10/23/97   BY: *K15N* Jerry Zhou   */
/* REVISION: 8.6      LAST MODIFIED: 12/08/97   by: *K1BN* Val Portugal */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton */
/* REVISION: 8.6E     LAST MODIFIED: 06/01/98   BY: *J2JJ* Niranjan R.  */
/* REVISION: 8.6E     LAST MODIFIED: 07/12/98   BY: *L024* Sami Kureishy*/
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *M017* Luke Pokic   */
/* REVISION: 9.0      LAST MODIFIED: 02/11/99   BY: *M07N* Abbas Hirkani*/
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan    */
/* REVISION: 9.0      LAST MODIFIED: 06/09/99   BY: *J3GV* Poonam Bahl   */
/* REVISION: 9.0      LAST MODIFIED: 12/12/00   BY: *M0X4* Seema Tyagi   */

     {mfdeclre.i}

         /* ********** Begin Translatable Strings Definitions ********* */

         &SCOPED-DEFINE sosomtf8_p_1 "检查清单"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosomtf8_p_2 "生效日期"
         /* MaxLen: Comment: */

         /* ********** End Translatable Strings Definitions ********* */

         define     shared variable sod_recno            as recid.
         define     shared variable new_line             like mfc_logical.
         define     shared variable prev_qty_ord         like sod_qty_ord.
         define     shared variable sngl_ln              like soc_ln_fmt.
         define     shared variable line                 like sod_line.
         define     shared variable clines               as integer.
         define     shared variable desc1                like pt_desc1.
         define     shared variable mult_slspsn          like mfc_logical
                             no-undo.
         define     shared variable sod-detail-all       like soc_det_all.
         define     shared variable sodcmmts             like soc_lcmmts.
         define     shared variable lineffdate           like so_due_date.
         define     shared variable undo_all2            like mfc_logical.

         define     shared frame    c.
         define     shared frame    d.

         define new shared variable cpex_prefix          as character.
         define new shared variable cpex_ordernbr        as character.
         define new shared variable cpex_orderline       as integer.
         define new shared variable cpex_rev_date        as date.
         define new shared variable cpex_order_due_date  as date.
         define new shared variable cpex_site            as character.
         define new shared variable cpex_ex_rate         like so_ex_rate.
/*L00Y*/ define new shared variable cpex_ex_rate2    like so_ex_rate2.
         define new shared variable cpex_mfg_lead        like ptp_mfg_lead.
         define new shared variable cpex_last_id         as integer.

         define variable cpex_sod_part like sod_part.

         define new shared variable config_changed       like mfc_logical
                                                         initial no.

         define            variable config_edited        like mfc_logical.
         define            variable created_by_new_software
                             like mfc_logical.
         define     shared variable old_price like sod_price.
         define     shared variable old_list_pr like sod_list_pr.
         define     shared variable old_disc like sod_disc_pct.
         define            variable modify_sob           like mfc_logical
                             initial no
                             label {&sosomtf8_p_1}.
         define            variable save_sod_price       like sod_price.
         define            variable yn                   like mfc_logical.
         define            variable pcqty                like sod_qty_ord.
         define            variable match_pt_um          like mfc_logical.
         define            variable minprice             like pc_min_price.
         define            variable maxprice             like pc_min_price.
         define            variable pc_recno             as recid.
         define            variable warning              like mfc_logical
                             initial no.
         define            variable warmess              like mfc_logical
                             initial yes.
         define            variable minmaxerr            like mfc_logical.
         define            variable par_absid            like abs_id no-undo.
         define            variable par_shipfrom         like abs_shipfrom
                                    no-undo.
         define            variable prev_qty_req         like sob_qty_req.
         define     shared variable picust               like cm_addr.
         define     shared variable pics_type            like pi_cs_type.
         define     shared variable part_type            like pi_part_type.
         define     shared variable discount             as decimal.
         define     shared variable line_pricing         like mfc_logical.
         define     shared variable reprice_dtl          like mfc_logical.
         define            variable sobparent            like sob_parent.
         define            variable sobfeature           like sob_feature.
         define            variable sobpart              like sob_part.
         define     shared variable new_order            like mfc_logical.
         define            variable update_accum_qty     like mfc_logical.
         define     shared variable soc_pt_req           like mfc_logical.
         define            variable err_flag             as integer.
         define new shared variable rfact                as integer.
         define            variable frametitle           as character.
         define            variable cfg like sod_cfg_type format "x(3)" no-undo.
         define            variable cfglabel as character format "x(24)"
                             label "" no-undo.
         define            variable cfgcode as character format "x(1)" no-undo.
         define            variable valid_mnemonic like mfc_logical no-undo.
         define            variable valid_lngd like mfc_logical no-undo.

         define            variable disc_pct_err         as decimal.
         define            variable disc_min_max         like mfc_logical.
         define     shared frame    bom.

         define buffer abs_tmp for abs_mstr.

         define shared variable cf_config like mfc_logical.
         define shared variable cf_error_bom like mfc_logical.
         define shared variable cf_rm_old_bom like mfc_logical.
         define new shared variable cf_um like sod_um.
         define new shared variable cf_um_conv like sod_um_conv.
/*L024*/ define variable mc-error-number like msg_nbr no-undo.
         {rcinvtbl.i new}  /* PRE-SHIPPER/SHIPPER VARIABLES */
         {rcinvcon.i}      /* INTERNAL PROCEDURES FOR PRE-SHIPPERS/SHIPPERS */
         {pppivar.i }  /*SHARED VARIABLES FOR PRICING ROUTINE*/
         {pppiwkpi.i } /*PRICING WORKFILE DEFINITIONS*/
         {pppiwqty.i } /*ACCUM QTY WORKFILES DEFINITIONS*/

         {solinfrm.i}  /* Define shared forms for line detail */

         if can-find(first lngd_det where
            lngd_lang = global_user_lang and
            lngd_dataset = "pt_mstr" and
            lngd_field = "pt_cfg_type") then
         valid_lngd = yes.
         else valid_lngd = no.

         FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
sod_sob_std colon 17
            sod_sob_rev colon 17 label {&sosomtf8_p_2}
            sod_fa_nbr  colon 17
            space(2)
            sod_lot     colon 17
            cfg         colon 17
          SKIP(.4)  /*GUI*/
with frame bom overlay attr-space side-labels row 9 column 25 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-bom-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame bom = F-bom-title.
 RECT-FRAME-LABEL:HIDDEN in frame bom = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame bom =
  FRAME bom:HEIGHT-PIXELS - RECT-FRAME:Y in frame bom - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME bom = FRAME bom:WIDTH-CHARS - .5.  /*GUI*/


         FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
modify_sob  colon 17
            sod_sob_rev colon 17 label {&sosomtf8_p_2}
            sod_fa_nbr  colon 17
            space(2)
            sod_lot     colon 17
            cfg         colon 17
             SKIP(.4)  /*GUI*/
with frame bom1 overlay attr-space side-labels row 9 column 25 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-bom1-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame bom1 = F-bom1-title.
 RECT-FRAME-LABEL:HIDDEN in frame bom1 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame bom1 =
  FRAME bom1:HEIGHT-PIXELS - RECT-FRAME:Y in frame bom1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME bom1 = FRAME bom1:WIDTH-CHARS - .5.  /*GUI*/


         find first pic_ctrl no-lock no-error.
         if pic_so_fact then
            rfact = pic_so_rfact.
         else
            rfact = pic_so_rfact + 2.
         find sod_det where recid(sod_det) = sod_recno exclusive-lock no-error.
         find so_mstr where so_nbr = sod_nbr no-lock no-error.

      assign
         cpex_prefix         = ""
         cpex_ordernbr       = sod_nbr
         cpex_orderline      = sod_line
         cpex_rev_date       = sod_sob_rev
         cpex_order_due_date = sod_due_date
         cpex_site           = sod_site
         cpex_ex_rate        = so_ex_rate
/*L024*/ cpex_ex_rate2       = so_ex_rate2
         cpex_mfg_lead       = 0
         cpex_sod_part       = sod_part
         cpex_last_id        = 0.

     /* GET LAST SOB_DET RECORD IDENTIFIER */
     {gprun.i ""sosomtf7.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


     find pt_mstr where pt_part = sod_part no-lock no-error.
     if available pt_mstr then cpex_mfg_lead = pt_mfg_lead.
     find ptp_det where ptp_part = sod_part and ptp_site = sod_site
        no-lock no-error.
     if available ptp_det then cpex_mfg_lead = ptp_mfg_lead.

/*M017*/ for first soc_ctrl
/*M017*/    fields (soc_apm) no-lock: end.
/*M017*/ if soc_apm then
/*M017*/    for first cm_mstr fields (cm_promo) no-lock
/*M017*/        where cm_addr = so_cust: end.

         /*If parameter is yes, then update "accum qty" workfiles
       before processing discount type price lists*/

         if line_pricing or not new_order then
            update_accum_qty = yes.
         else
            update_accum_qty = no.

     /* PROMPT FOR CONFIGURATION IF NEW LINE */
            /*For calico configured items the user is not to be prompted with*/
            /*Std. bill as the user has built the configuration they will be */
            /*Prompted if they wish to review the bill.                      */
            if (new sod_det or prev_qty_ord = 0)
            or (cf_config and cf_rm_old_bom) then do:
            sod_sob_rev = sod_due_date.
            cpex_rev_date = sod_due_date.

            /* Get the cost from remote db if necessary */
            {gprun.i ""gpsct05x.p""
                  "(pt_part, sod_site, 1,
                output glxcst, output curcst)" }
/*GUI*/ if global-beam-me-up then undo, leave.


        sod_std_cost = glxcst * sod_um_conv.

        if sod_qty_ord <> 0 then do:
           sod_sob_rev = sod_due_date.

           pause 0.
           sod_sob_std = yes.

/*M07N** BEGIN DELETE **
 *          if not cf_config then do:
 *             pause 0.
 *             sod_sob_std = yes.
 *             display
 *                   sod_sob_std colon 17
 *                   sod_sob_rev colon 17 label {&sosomtf8_p_2}
 *                   sod_fa_nbr  colon 17
 *                   sod_lot     colon 17
 *                with frame bom
 *                                                                    .
 *
 *             set sod_sob_std sod_sob_rev with frame bom.
 *             hide frame bom.
 *          end.
 *          else do:
 *M07N** END DELETE */

/*M07N*/    if cf_config then do:
               modify_sob = no.
               pause 0.
               display
                  modify_sob sod_sob_rev sod_fa_nbr sod_lot with frame bom1.
               set modify_sob with frame bom1.
               if (sod_fa_nbr > "" or sod_lot > "")
                  and ((prev_qty_ord <> sod_qty_ord * sod_um_conv
                  and prev_qty_ord <> 0)
                  or modify_sob)
               then do:
                  {mfmsg.i 420 2} /* Line item already released to FAS*/
               end.
               hide frame bom1.
            end.

               if new sod_det and available ptp_det then
               assign
              sod_cfg_type = ptp_cfg_type.
               else if new sod_det and available pt_mstr then
              assign
                 sod_cfg_type = pt_cfg_type.
               assign
              cfg = sod_cfg_type
              cfglabel = ""
              cfgcode = "".

               /* GET MNEMONIC cfg AND cfglabel FROM LNGD_DET */
               {gplngn2a.i &file     = ""pt_mstr""
               &field    = ""pt_cfg_type""
               &code     = sod_cfg_type
               &mnemonic = cfg
               &label    = cfglabel}

           display
          sod_sob_std colon 17
          sod_sob_rev colon 17 label {&sosomtf8_p_2}
                  cfg         colon 17
          sod_fa_nbr  colon 17
          sod_lot     colon 17
               with frame bom
                                                                   .

           set sod_sob_std
           sod_sob_rev
                   cfg
           with frame bom.

               /* VALIDATE CFG MNEMONIC AGAINST LNGD_DET */
               if valid_lngd then do:
              {gplngv.i &file     = ""pt_mstr""
                &field    = ""pt_cfg_type""
                &mnemonic = cfg
                &isvalid  = valid_mnemonic}

              if not valid_mnemonic then do:
                 /* INVALID CHARACTER */
                 {mfmsg.i 3093 3}
                 next-prompt cfg with frame bom.
                 undo, retry.
              end.

              /* GET cfgcode & cfglabel FROM LNGD_DET */
              {gplnga2n.i &file     = ""pt_mstr""
                  &field    = ""pt_cfg_type""
                  &mnemonic = cfg
                  &code     = cfgcode
                  &label    = cfglabel}
               end.
               if valid_lngd and available lngd_det then
              assign sod_cfg_type = cfgcode.
               else sod_cfg_type = cfg.

           hide frame bom.

               cpex_rev_date = sod_sob_rev.

           /* FOLLOWING 2 MESSAGE STATEMENTS CAUSE A PAUSE IF ANY
           MESSAGES ARE ON THE SCREEN ALREADY*/
           message.
           message.

           /*CREATE SO BILL RECORDS*/
                          if cf_config then
                 assign
                    cf_um = sod_um
                    cf_um_conv = sod_um_conv.
               if new sod_det or prev_qty_ord = 0 or cf_rm_old_bom then
                 {gprun.i ""sosomtf1.p""
                          "(input sod_part, input """",
                          input sod_qty_ord * sod_um_conv,
                          input 0,
                          input cpex_sod_part)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               if cf_config and cf_error_bom then do:
                  undo_all2 = true.
                  leave.
               end.

           /* Calculate the price of the resulting configuration */

               {gprun.i ""sopccala.p"" "(update_accum_qty, yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               /*CHECK IF CONFIGURATION NEEDS REPRICING DUE "ACCUM QTY"
         CAPABILITY OF BEST PRICING*/
               find first wrep_wkfl where wrep_line = sod_line and
                      wrep_part = sod_part and
                      wrep_parent          and
                      wrep_rep
                    exclusive-lock no-error.
           if available wrep_wkfl then do:
          config_edited  = yes.  /*forces repricing during reconfig*/
          config_changed = yes.
          wrep_rep       = no.
               end.

                 if not cf_config then do:
                 if sod_sob_std = no then do:
          /*EDIT SO BILL*/
                   {gprun.i ""sosomtf2.p""  "(input sod_part, input """",
                           input sod_qty_ord * sod_um_conv, input 0,
                           input cpex_sod_part)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                   config_edited = yes.
                  end.
               end.
               else do:
                  if modify_sob then do:
                     {gprun.i ""sosomtf2.p"" "(input sod_part, input """",
                           input sod_qty_ord * sod_um_conv, input 0,
                           input cpex_sod_part)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                     config_edited = yes.
                  end.
               end. /* if not cf_config */
            end.

        if sngl_ln then display sod_std_cost sod_um_conv with frame d.
     end.

     /* REVIEW CONFIGURATION IF OLD CONFIGURED PART */
     else do:
        if sod_qty_ord = 0 then do:
               for each sob_det exclusive-lock where sob_nbr = sod_nbr
               and sob_line = sod_line :
/*GUI*/ if global-beam-me-up then undo, leave.


                  /*UPDATE ACCUM QTY WORKFILES WITH REVERSAL*/
          if line_pricing or not new_order then do:
              /*Qualified the qty (sob_qty_req) and extended list   */
              /*(sob_qty_req * sob_tot_std) parameters to divide by */
              /*u/m conversion ratio since these include this factor*/
              /*already.                                            */
             {gprun.i ""gppiqty2.p"" "(sod_line,
                           sob_part,
                         - (sob_qty_req / sod_um_conv),
                         - (sob_qty_req * sob_tot_std
                                / sod_um_conv),
                           sod_um,
                           no,
                                               yes,
                           yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  end.
          {inmrp.i &part=sob_part &site=sob_site}
          {mfmrwdel.i "sob_det" sob_part sob_nbr
             "string(sob_line) + ""-"" + sob_feature" sob_parent }
          delete sob_det.
           end.
/*GUI*/ if global-beam-me-up then undo, leave.


               /* Get the cost from remote db if necessary */
               {gprun.i ""gpsct05x.p""
                  "(pt_part, sod_site, 1,
                output glxcst, output curcst)" }
/*GUI*/ if global-beam-me-up then undo, leave.


           sod_std_cost = glxcst * sod_um_conv.

               /* DELETE ALL RELATED PRICE LIST HISTORY AND CURRENT  */
               /* PRICE LIST WORKFILE ENTRIES FOR THIS SALES ORDER   */
               /* BILL.  SET sod_list_pr TO THE VALUE OF THE PARENT  */
               /* LIST PRICE AND UPON RETURN TO THE CALLING PROCEDURE*/
               /* SUBSEQUENT PROCESSING WILL RESULT IN NO DISCOUNTS  */
               /* AND LIST AND NET PRICES WILL BE THE SAME.          */

               sod_list_pr = 0.

               for each pih_hist where pih_doc_type = 1
                                   and pih_nbr      = sod_nbr
                                   and pih_line     = sod_line
                                 exclusive-lock:
                   if pih_amt_type = "1" and pih_option = "" then
                      sod_list_pr  = pih_amt.
                   else
                      delete pih_hist.
               end.

               for each wkpi_wkfl exclusive-lock:
                   if wkpi_amt_type = "1" and wkpi_option = "" then
                      sod_list_pr = wkpi_amt.
                   else
                      delete wkpi_wkfl.
               end.

               assign                      /*make sure nothing else happens*/
                  exclude_confg_disc = no  /*upon returning to the calling */
                  select_confg_disc  = no  /*procedure.                    */
                  found_confg_disc   = no
               .

           sod_disc_pct = 0.
           sod_price = sod_list_pr.
               /*DETERMINE DISCOUNT DISPLAY FORMAT*/
               {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}
               display sod_list_pr discount sod_price with frame c.
        end.
        else do:
           if prev_qty_ord <> sod_qty_ord * sod_um_conv
           and prev_qty_ord <> 0 then do:
          for each sob_det where sob_nbr = sod_nbr
                  and sob_line = sod_line exclusive-lock :
/*GUI*/ if global-beam-me-up then undo, leave.


                     /*UPDATE ACCUM QTY WORKFILES WITH DIFFERENCE*/
                     prev_qty_req = sob_qty_req.

                     assign

             sob_qty_req = sob_qty_req * sod_qty_ord
             * sod_um_conv / prev_qty_ord

                     substr(sob_serial,17,18) =
                           string(sob_qty_req,"-9999999.999999999").

                     if line_pricing or not new_order then do:
                        /*Qualified the qty (sob_qty_req) and extended list  */
                        /*(sob_qty_req * sob_tot_std) parameters to divide by */
                        /*u/m conversion ratio since these include this factor*/
                        /*already.                                            */
                        {gprun.i ""gppiqty2.p"" "(sod_line,
                          sob_part,
                          (sob_qty_req - prev_qty_req)
                                   / sod_um_conv,
                          (sob_qty_req - prev_qty_req)
                                   * sob_tot_std
                                   / sod_um_conv,
                          sod_um,
                          no,
                                                  yes,
                          yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                     end.
          end.
/*GUI*/ if global-beam-me-up then undo, leave.


                  config_changed = yes.
          config_edited  = yes.
           end.

/*!      *******************************************
     sob_serial subfield positions:
     1-4     operation number (old - now 0's)
     5-10    scrap percent
     11-14   id number of this record
     15-15   structure code
     16-16   "y" (indicates "new" format sob_det record)
     17-34   original qty per parent
     35-35   original mandatory indicator (y/n)
     36-36   original default indicator (y/n)
     37-39   leadtime offset
     40-40   price manually updated (y/n)
     41-46   operation number (new - 6 digits)
     *******************************************/

           find first sob_det where sob_nbr = sod_nbr
           and sob_line = sod_line no-lock no-error.
               if (available sob_det and substr(sob_serial,16,1) = "y") or
                   not available sob_det
           then created_by_new_software = yes.

           pause 0.
           modify_sob = no.

               /* ALLOW FOR CONFIGURATION MODIFICATION ONLY IF REPRICING  */
               /* IS YES.  OTHERWISE IF A CONFIGURATION CHANGE OCCURS (ADD*/
               /* AN OPTION, DELETE AN OPTION, SETTING QTY TO 0, WILL     */
               /* REFLECT IN A CHANGE TO THE LINE ITEM LIST AND NET PRICE */
               /* WHICH WILL NOT BE REFLECTED IN PRICE LIST HISTORY.  IF  */
               /* PRICE LIST HISTORY IS NOT MAINTAINED, THEN WHEN POSTING */
               /* TO THE G/L, DISCOUNTS WILL BE OUT OF BALANCE.           */

               if reprice_dtl or new_order then do:
                  assign
                 cfg = sod_cfg_type
                 cfglabel = ""
                 cfgcode = "".

                  /* GET MNEMONIC CFG AND cfglabel FROM LNGD_DET */
                  {gplngn2a.i &file     = ""pt_mstr""
                  &field    = ""pt_cfg_type""
                  &code     = sod_cfg_type
                  &mnemonic = cfg
                  &label    = cfglabel}

                  display
                     modify_sob
                 sod_sob_rev
                 cfg
                 sod_fa_nbr
                 sod_lot with frame bom1.

                  set modify_sob with frame bom1.

              /* UPDATE CONFIGURATION TYPE IF NOT CONFIRMED */
              if sod_confirm = no then do:

                 set cfg with frame bom1.

                 /* VALIDATE CFG MNEMONIC AGAINST LNGD_DET */
                 if valid_lngd then do:
                {gplngv.i &file     = ""pt_mstr""
                  &field    = ""pt_cfg_type""
                  &mnemonic = cfg
                  &isvalid  = valid_mnemonic}

                if not valid_mnemonic then do:
                   /* INVALID CHARACTER */
                   {mfmsg.i 3093 3}
                   next-prompt cfg with frame bom.
                   undo, retry.
                end.

                /* GET cfgcode & cfglabel FROM LNGD_DET */
                {gplnga2n.i &file     = ""pt_mstr""
                    &field    = ""pt_cfg_type""
                    &mnemonic = cfg
                    &code     = cfgcode
                    &label    = cfglabel}
                 end.
                 if valid_lngd and available lngd_det then
                assign sod_cfg_type = cfgcode.
                 else sod_cfg_type = cfg.
              end. /* if sod_confirm = no */

/*M0X4*/      /* MOVED WARNING MESSAGE# 420 TO sosomtla.p */

/*M0X4**      BEGIN DELETE
 *            if        (sod_fa_nbr > "" or sod_lot > "" )
 *               and ((prev_qty_ord <> sod_qty_ord * sod_um_conv
 *               and   prev_qty_ord <> 0)
 *                or   modify_sob )
 *            then do:
 *                /* LINE ITEM ALREADY RELEASED TO FAS */
 *                {mfmsg.i 420 2}
 *                pause.
 *            end. /* IF sod_fa_nbr > "" .. */
 *M0X4**      END DELETE */

              if modify_sob then do:
                 absloop:
                 for each abs_mstr no-lock where abs_shipfrom = sod_site
                 and abs_order = sod_nbr and abs_line = string(sod_line):
/*GUI*/ if global-beam-me-up then undo, leave.

                run get_abs_parent (input abs_mstr.abs_id,
                        input abs_mstr.abs_shipfrom,
                        output par_absid,
                        output par_shipfrom).
                if par_absid <> ? then do:
                   find abs_tmp where abs_tmp.abs_id = par_absid and
                   abs_tmp.abs_shipfrom = par_shipfrom no-lock no-error.
                   if available abs_tmp and
                   (abs_tmp.abs_canceled = no or
                   substring(abs_tmp.abs_status,2,1) <> "y")
                   then do:
                      /* Pre-shipper/shipper exists for for this line */
                      {mfmsg.i 5934 2}
                      pause.
                      leave absloop.
                   end.
                end.
                 end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* for each abs_mstr where abs_shipfrom = sod_site */
                  end. /* if modify_sob  */

          hide frame bom1.
               end.

           if modify_sob then do:
          if sngl_ln then hide frame d.

          config_edited = yes.

          if created_by_new_software then do:

                    {gprun.i ""sosomtf2.p"" "(input sod_part, input """",
                        input sod_qty_ord * sod_um_conv,  input 0,
                        input cpex_sod_part)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  end.
                  else do:
                     {gprun.i ""sosomte.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

                  end.

          if sngl_ln then view frame d.
           end.
               /*Reprice current configuration*/
               else if line_pricing or reprice_dtl then do:

                  /* Get the cost from remote db if necessary */
                  {gprun.i ""gpsct05x.p""
                  "(pt_part, sod_site, 1,
                output glxcst, output curcst)" }
/*GUI*/ if global-beam-me-up then undo, leave.


          sod_std_cost = glxcst * sod_um_conv.
                  /*Changed parameter from "update_accum_qty" to "no"*/
                  {gprun.i ""sopccala.p"" "(no, yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end.
        end.
     end.

         /*REPRICE COMPLETE CONFIGURATION*/

         if (line_pricing or reprice_dtl) and config_edited then do:

        /*INITIALIZE PRICING VARIABLES*/
        best_list_price = 0.
        best_net_price  = 0.
        min_price       = 0.
        max_price       = 0.

        /*INITIALIZE PRICING WORKFILE, RETAIN ANY MANUAL ENTRIES*/
        {gprun.i ""gppiwkdl.p"" "(1)"}
/*GUI*/ if global-beam-me-up then undo, leave.


        /*GET BEST LIST TYPE PRICE LIST, SET MIN/MAX FIELDS*/

        sobparent  = "".
        sobfeature = "".
        sobpart    = "".

/*M017* IF APM IS IN USE AND CUSTOMER AND ITEM ARE USED BY APM
 *M017* THEN CALL THE APM PRICE LIST SELECTION ROUTINE        */
/*M017*/    if soc_apm
/*M017*/       and available cm_mstr
/*M017*/       and cm_promo <> ""
/*M017*/       and pt_promo <> "" then do:
/*M017*/       {gprun.i ""gppiapm1.p"" "(pics_type,
                  picust,
                  part_type,
                  sod_part,
                  sobparent,
                  sobfeature,
                  sobpart,
                  1,
                  so_curr,
                  sod_um,
                  sod_pricing_dt,
                  soc_pt_req,
                  sod_site,
                  so_ex_rate,
                  so_ex_rate2,
                  sod_nbr,
                  sod_line,
                  sod_div,
                  output err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*M017*/    end. /* IF SOC_APM */
/*M017*/    else do: /* IF NOT SOC_APM */
/*L00Y*//* ADDED SECOND EXCHANGE RATE BELOW */
/*J2JJ*/ /* ADDED SOD_NBR, SOD_LINE TO PARAMETERS */
        {gprun.i ""gppibx.p"" "(pics_type,
                    picust,
                    part_type,
                    sod_part,
                    sobparent,
                    sobfeature,
                    sobpart,
                    1,
                    so_curr,
                    sod_um,
                    sod_pricing_dt,
                    soc_pt_req,
                    sod_site,
                    so_ex_rate,
                    so_ex_rate2,
                    sod_nbr,
                    sod_line,
                    output err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*M017*/    end. /* IF NOT SOC_APM */
        /*TEST FOR REQUIRED PRICE LIST BASED ON MATCHING PART# AND UM
         OR IF ANY LIST TYPE PRICE LIST WAS FOUND*/

        if soc_pt_req or best_list_price = 0 then do:
           find first wkpi_wkfl where wkpi_parent   = ""  and
                      wkpi_feature  = ""  and
                      wkpi_option   = ""  and
                      wkpi_amt_type = "1"
                    no-lock no-error.
           if soc_pt_req then do:
/*J3GV**      if (available wkpi_wkfl and wkpi_source = "1") or */
/*J3GV*/       if (available wkpi_wkfl and
/*J3GV*/           wkpi_source = "1"   and
/*J3GV*/           wkpi_list = "" ) or
               not available wkpi_wkfl then do:
             {mfmsg03.i 6231 3 sod_part sod_um """"}
             /*Price table for sod_part in sod_um not found*/
             if not batchrun then pause.
             undo, return.
          end.
           end.
           if best_list_price = 0 then do:
          if not available wkpi_wkfl then do:
             if available pt_mstr then do:
/*L024*         best_list_price = pt_price * so_ex_rate * sod_um_conv.  */
/*L024*/        {gprunp.i "mcpl" "p" "mc-curr-conv"
                   "(input base_curr,
                     input so_curr,
                     input so_ex_rate2,
                     input so_ex_rate,
                     input pt_price * sod_um_conv,
                     input false,
                     output best_list_price,
                     output mc-error-number)"}.
/*L024*/        if mc-error-number <> 0 then do:
/*L024*/           {mfmsg.i mc-error-number 2}
/*L024*/        end.

                /*Create list type price list record in wkpi_wkfl*/
                {gprun.i ""gppiwkad.p""
                   "(sod_um,
                     sobparent,
                     sobfeature,
                     sobpart,
                     ""4"",
                     ""1"",
                     best_list_price,
                     0,
                     no)"}
/*GUI*/ if global-beam-me-up then undo, leave.

             end.
             else do:
                /*Create list type price list record in wkpi_wkfl
                for memo type*/
                best_list_price = sod_list_pr.
                {gprun.i ""gppiwkad.p"" "(sod_um,
                          sobparent,
                          sobfeature,
                          sobpart,
                          ""7"",
                          ""1"",
                          best_list_price,
                          0,
                          no)"}
/*GUI*/ if global-beam-me-up then undo, leave.

             end.
          end.
          else
                     best_list_price = wkpi_amt.
           end.
        end.
        sod_list_pr = best_list_price.
        sod_price   = best_list_price.

        /*CALCULATE TERMS INTEREST*/

        if sod_crt_int <> 0 and (available pt_mstr or sod_type <> "")
        then do:
           sod_list_pr     = (100 + sod_crt_int) / 100 * sod_list_pr.
           sod_price       = sod_list_pr.
           best_list_price = sod_list_pr.
           /*Create credit terms interest wkpi_wkfl record*/
           {gprun.i ""gppiwkad.p"" "(sod_um,
                     sobparent,
                     sobfeature,
                     sobpart,
                     ""5"",
                     ""1"",
                     sod_list_pr,
                     0,
                     no)"}
/*GUI*/ if global-beam-me-up then undo, leave.

        end.

        parent_list_price = best_list_price. /*gppiwk02.p needs this*/

/*J2JJ**   if sod_list_pr <> 0 then do: */

           /*GET BEST DISCOUNT TYPE PRICE LISTS*/
/*M017* IF APM IS IN USE AND CUSTOMER AND ITEM ARE USED BY APM
 *M017* THEN CALL THE APM PRICE LIST SELECTION ROUTINE        */
/*M017*/    if soc_apm
/*M017*/       and available cm_mstr
/*M017*/       and cm_promo <> ""
/*M017*/       and pt_promo <> "" then do:
/*M017*/       {gprun.i ""gppiapm1.p"" "(pics_type,
                  picust,
                  part_type,
                  sod_part,
                  sobparent,
                  sobfeature,
                  sobpart,
                  2,
                  so_curr,
                  sod_um,
                  sod_pricing_dt,
                  no,
                  sod_site,
                  so_ex_rate,
                  so_ex_rate2,
                  sod_nbr,
                  sod_line,
                  sod_div,
                  output err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*M017*/    end. /* IF SOC_APM */
/*M017*/    else do: /* IF NOT SOC_APM*/
/*L00Y*/   /* ADDED SECOND EXCHANGE RATE BELOW */
/*J2JJ*/   /* ADDED SOD_NBR, SOD_LINE TO PARAMETERS */
           {gprun.i ""gppibx.p"" "(pics_type,
                       picust,
                       part_type,
                       sod_part,
                       sobparent,
                       sobfeature,
                       sobpart,
                       2,
                       so_curr,
                       sod_um,
                       sod_pricing_dt,
                       no,
                       sod_site,
                       so_ex_rate,
                       so_ex_rate2,
                       sod_nbr,
                       sod_line,
                       output err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*M017*/    end. /* IF NOT SOC_APM*/
           /*CALCULATE BEST PRICE*/

           {gprun.i ""gppibx04.p"" "(sobparent,
                     sobfeature,
                     sobpart,
                     no,
                     rfact)"}
/*GUI*/ if global-beam-me-up then undo, leave.


           sod_price    = best_net_price.

/*J2JJ**   end. */

        sod_disc_pct = if sod_list_pr <> 0 then
                  (1 - (sod_price / sod_list_pr)) * 100
               else
                  0.

            /* Get the cost from remote db if necessary */
            {gprun.i ""gpsct05x.p""
                  "(pt_part, sod_site, 1,
                output glxcst, output curcst)" }
/*GUI*/ if global-beam-me-up then undo, leave.


        sod_std_cost = glxcst * sod_um_conv.

            {gprun.i ""sopccala.p"" "(no, yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.


          if sngl_ln then display sod_std_cost with frame d.

     end. /*line_pricing or reprice_dtl and config_edited*/

     undo_all2 = false.  /* flag successful completion of this routine */
