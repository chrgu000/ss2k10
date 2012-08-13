/* GUI CONVERTED from sosomtf8.p (converter v1.69) Wed Sep 10 15:19:52 1997 */
/* sosomtf8.p  - SALES ORDER MAINTENANCE - CONFIGURED ITEM              */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*H0CJ*/ /*V8:ConvertMode=Maintenance                                   */
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
/* REVISION: 8.5      LAST MODIFIED: 03/06/97   BY: *H0TB* Jim Williams */
/* REVISION: 8.5      LAST MODIFIED: 05/27/97   BY: *J1RY* Tim Hinds    */
/* REVISION: 8.5      LAST MODIFIED: 11/14/03   BY: *LB01* Long Bo         */

         {mfdeclre.i}

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
         define new shared variable cpex_mfg_lead        like ptp_mfg_lead.
         define new shared variable cpex_last_id         as integer.
/*F0LT*/ define new shared variable config_changed       like mfc_logical
/*F0LT*/                                                 initial no.

         define            variable config_edited        like mfc_logical.
         define            variable created_by_new_software
                                                         like mfc_logical.
/*F0HM   define            variable old_price like sod_price.
 *       define            variable old_list_pr like sod_list_pr.
 *       define            variable old_disc like sod_disc_pct. */
/*F0HM*/ define     shared variable old_price like sod_price.
/*F0HM*/ define     shared variable old_list_pr like sod_list_pr.
/*F0HM*/ define     shared variable old_disc like sod_disc_pct.
         define            variable modify_sob           like mfc_logical
                                                         initial no
                                                         label "检查清单".
/*F0MV*/ define            variable save_sod_price       like sod_price.
         define            variable yn                   like mfc_logical.
         define            variable pcqty                like sod_qty_ord.
         define            variable match_pt_um          like mfc_logical.
         define            variable minprice             like pc_min_price.
         define            variable maxprice             like pc_min_price.
         define            variable pc_recno             as recid.
/*J042*  define            variable soc_pt_req           like mfc_logical.*/
         define            variable warning              like mfc_logical
                                                         initial no.
         define            variable warmess              like mfc_logical
                                                         initial yes.
         define            variable minmaxerr            like mfc_logical.

/*J042*/ define            variable prev_qty_req         like sob_qty_req.
/*J042*/ define     shared variable picust               like cm_addr.
/*J042*/ define     shared variable pics_type            like pi_cs_type.
/*J042*/ define     shared variable part_type            like pi_part_type.
/*J042*/ define     shared variable discount             as decimal.
/*J042*/ define     shared variable line_pricing         like mfc_logical.
/*J042*/ define     shared variable reprice_dtl          like mfc_logical.
/*J042*/ define            variable sobparent            like sob_parent.
/*J042*/ define            variable sobfeature           like sob_feature.
/*J042*/ define            variable sobpart              like sob_part.
/*J042*/ define     shared variable new_order            like mfc_logical.
/*J042*/ define            variable update_accum_qty     like mfc_logical.
/*J042*/ define     shared variable soc_pt_req           like mfc_logical.
/*J042*/ define            variable err_flag             as integer.
/*J042*/ define new shared variable rfact                as integer.
/*J0HR*/ define            variable frametitle           as character.
/*J0N2*/ define            variable disc_pct_err         as decimal.
/*J0N2*/ define            variable disc_min_max         like mfc_logical.
/*J0YR*/ define     shared frame    bom.

/*J1RY*/ define shared variable cf_config like mfc_logical.
/*J1RY*/ define shared variable cf_error_bom like mfc_logical.
/*J1RY*/ define shared variable cf_rm_old_bom like mfc_logical.
/*J1RY*/ define new shared variable cf_um like sod_um.
/*J1RY*/ define new shared variable cf_um_conv like sod_um_conv.

/*J042*/ {pppivar.i }  /*SHARED VARIABLES FOR PRICING ROUTINE*/
/*J042*/ {pppiwkpi.i } /*PRICING WORKFILE DEFINITIONS*/
/*J042*/ {pppiwqty.i } /*ACCUM QTY WORKFILES DEFINITIONS*/

/*LB01*/ {zzsolinfrm.i}  /* Define shared forms for line detail */

/*H0BZ*/ FORM /*GUI*/ 
/*H0BZ*/    
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
sod_sob_std colon 17
/*H0BZ*/    sod_sob_rev colon 17 label "生效日期"
/*H0BZ*/    sod_fa_nbr  colon 17
/*H0BZ*/    space(2)
/*H0BZ*/    sod_lot     colon 17
/*H0BZ*/  SKIP(.4)  /*GUI*/
with frame bom overlay attr-space side-labels row 9 column 25 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-bom-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame bom = F-bom-title.
 RECT-FRAME-LABEL:HIDDEN in frame bom = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame bom =
  FRAME bom:HEIGHT-PIXELS - RECT-FRAME:Y in frame bom - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME bom = FRAME bom:WIDTH-CHARS - .5.  /*GUI*/


/*H0CJ*/ FORM /*GUI*/ 
/*H0CJ*/    
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
modify_sob  colon 17
/*H0CJ*/    sod_sob_rev colon 17 label "生效日期"
/*H0CJ*/    sod_fa_nbr  colon 17
/*H0CJ*/    space(2)
/*H0CJ*/    sod_lot     colon 17
/*H0CJ*/     SKIP(.4)  /*GUI*/
with frame bom1 overlay attr-space side-labels row 9 column 25 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-bom1-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame bom1 = F-bom1-title.
 RECT-FRAME-LABEL:HIDDEN in frame bom1 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame bom1 =
  FRAME bom1:HEIGHT-PIXELS - RECT-FRAME:Y in frame bom1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME bom1 = FRAME bom1:WIDTH-CHARS - .5.  /*GUI*/


/*J042*/ find first pic_ctrl no-lock no-error.
/*J042*/ if pic_so_fact then
/*J042*/    rfact = pic_so_rfact.
/*J042*/ else
/*J042*/    rfact = pic_so_rfact + 2.
/*H0CJ*/ find sod_det where recid(sod_det) = sod_recno exclusive-lock no-error.
/*H0CJ*/ find so_mstr where so_nbr = sod_nbr no-lock no-error.

         assign
            cpex_prefix         = ""
            cpex_ordernbr       = sod_nbr
            cpex_orderline      = sod_line
            cpex_rev_date       = sod_sob_rev
            cpex_order_due_date = sod_due_date
            cpex_site           = sod_site
            cpex_ex_rate        = so_ex_rate
            cpex_mfg_lead       = 0
            cpex_last_id        = 0.

         /*FQ14 GET LAST SOB_DET RECORD IDENTIFIER*/
         {gprun.i ""sosomtf7.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


         find pt_mstr where pt_part = sod_part no-lock no-error.
         if available pt_mstr then cpex_mfg_lead = pt_mfg_lead.
         find ptp_det where ptp_part = sod_part and ptp_site = sod_site
            no-lock no-error.
         if available ptp_det then cpex_mfg_lead = ptp_mfg_lead.

/*J042*/ /*If parameter is yes, then update "accum qty" workfiles
           before processing discount type price lists*/

/*J042*/ if line_pricing or not new_order then
/*J042*/    update_accum_qty = yes.
/*J042*/ else
/*J042*/    update_accum_qty = no.

         /* PROMPT FOR CONFIGURATION IF NEW LINE */
/*J1RY      if new sod_det or prev_qty_ord = 0 then do: */
/*J1RY*/    /*for calico configured items the user is not to be prompted with*/
/*J1RY*/    /*std. bill as the user has built the configuration they will be */
/*J1RY*/    /*prompted if they wish to review the bill.                      */
/*J1RY*/    if (new sod_det or prev_qty_ord = 0)
/*J1RY*/    or (cf_config and cf_rm_old_bom) then do:
            sod_sob_rev = sod_due_date.
            cpex_rev_date = sod_due_date.
/*F0X9*     {gpsct05.i &part=pt_part &site=sod_site &cost=                    */
/*F0X9*     "sct_bdn_tl + sct_lbr_tl + sct_mtl_tl + sct_ovh_tl + sct_sub_tl"} */
/*F0X9*/    {gpsct05.i &part=pt_part &site=sod_site &cost=sct_cst_tot}

            sod_std_cost = glxcst * sod_um_conv.
/*J042**    sod_list_pr = pt_price * so_ex_rate * sod_um_conv.
**          sod_disc_pct = 0.
**          sod_price = sod_list_pr.
**J042***   disp sod_list_pr sod_disc_pct sod_price with frame c.*/

            if sod_qty_ord <> 0 then do:
               sod_sob_rev = sod_due_date.

/*J1RY*/    if not cf_config then do:
               pause 0.
               sod_sob_std = yes.
/*J1RY***         disp  */
/*J1RY*/       display
                     sod_sob_std colon 17
                     sod_sob_rev colon 17 label "生效日期"
                     sod_fa_nbr  colon 17
                     sod_lot     colon 17
/*H0BZ*/          with frame bom
/*H0BZ*/          /* overlay attr-space side-labels row 9 column 25 */.

               set sod_sob_std sod_sob_rev with frame bom.
               hide frame bom.
/*J1RY*/    end.
/*J1RY*/    else do:
/*J1RY*/       modify_sob = no.
/*J1RY*/       pause 0.
/*J1RY*/       display
/*J1RY*/          modify_sob sod_sob_rev sod_fa_nbr sod_lot with frame bom1.
/*J1RY*/       set modify_sob with frame bom1.
/*J1RY*/       if (sod_fa_nbr > "" or sod_lot > "")
/*J1RY*/          and ((prev_qty_ord <> sod_qty_ord * sod_um_conv
/*J1RY*/          and prev_qty_ord <> 0)
/*J1RY*/          or modify_sob)
/*J1RY*/       then do:
/*J1RY*/          {mfmsg.i 420 2} /* Line item already released to FAS*/
/*J1RY*/       end.
/*J1RY*/       hide frame bom1.
/*J1RY*/    end.

/*FT39**       cpex_rev_date = sod_due_date. **/
/*FT39*/       cpex_rev_date = sod_sob_rev.

               /* FOLLOWING 2 MESSAGE STATEMENTS CAUSE A PAUSE IF ANY
               MESSAGES ARE ON THE SCREEN ALREADY*/
               message.
               message.

               /*CREATE SO BILL RECORDS*/

/*J1RY*/       if cf_config then
/*J1RY*/         assign
/*J1RY*/            cf_um = sod_um
/*J1RY*/            cf_um_conv = sod_um_conv.
/*J1RY*/       if new sod_det or prev_qty_ord = 0 or cf_rm_old_bom then
/*LB01*/          {gprun.i ""zzsosomtf1.p""
                          "(input sod_part, input """",
                          input sod_qty_ord * sod_um_conv,
                          input 0)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J1RY*/       if cf_config and cf_error_bom then do:
/*J1RY*/          undo_all2 = true.
/*J1RY*/          leave.
/*J1RY*/       end.

               /* Calculate the price of the resulting configuration */
/*J042**
** /*F0MV*/       save_sod_price = sod_price.
** /*F0HM*/       sod_price = old_price.
** /*F0MV*/       if pt_price = 0 and sod_list_pr = 0 then
** /*F0MV*/          sod_list_pr = sod_price.
**                {gprun.i ""sopccala.p""}
**J042*/


/*J12Q* /*J042*/{gprun.i ""sopccala.p"" "(update_accum_qty)"}             */
/*LB01*//*J12Q*/       {gprun.i ""zzsopccala.p"" "(update_accum_qty, yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J042**
** /*F0MV      if sod_price <> old_price or sod_list_pr <> old_list_pr then*/
** /*F0MV*/    if (save_sod_price <> old_price or sod_list_pr <> old_list_pr)
** /*F0MV*/    and sod_list_pr <> 0 then
**                sod_disc_pct = (1 - (sod_price / sod_list_pr)) * 100.
**
**             old_price   = sod_price.
**             old_list_pr = sod_list_pr.
**             old_disc    = sod_disc_pct.
**J042*/

/*J042**
**             display sod_list_pr sod_disc_pct
** /*FT43*/    when (sod_disc_pct > -99999.99 and sod_disc_pct < 99999.99)
**             sod_price with frame c.
**J042*/

/*J042*/       /*CHECK IF CONFIGURATION NEEDS REPRICING DUE "ACCUM QTY"
                 CAPABILITY OF BEST PRICING*/
/*J042*/       find first wrep_wkfl where wrep_line = sod_line and
                                          wrep_part = sod_part and
                                          wrep_parent          and
                                          wrep_rep
                                    exclusive-lock no-error.
               if available wrep_wkfl then do:
                  config_edited  = yes.  /*forces repricing during reconfig*/
                  config_changed = yes.
                  wrep_rep       = no.
/*J042*/       end.

/*J1RY*/       if not cf_config then do:
                 if sod_sob_std = no then do:
                    /*EDIT SO BILL*/
/*G2F4**                {gprun.i ""sosomtf2.p""
 *G2F4**               "(input sod_part, input """", input sod_qty_ord, input 0)"} */
/*LB01*//*G2F4*/        {gprun.i ""zzsosomtf2.p"" "(input sod_part, input """",
                           input sod_qty_ord * sod_um_conv, input 0)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                   config_edited = yes.
                  end.
/*J1RY*/       end.
/*J1RY*/       else do:
/*J1RY*/          if modify_sob then do:
/*LB01*//*J1RY*/     {gprun.i ""zzsosomtf2.p"" "(input sod_part, input """",
/*J1RY*/                   input sod_qty_ord * sod_um_conv, input 0)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J1RY*/             config_edited = yes.
/*J1RY*/          end.
/*J1RY*/       end. /* if not cf_config */
            end.

/*J042**
**          display sod_list_pr sod_disc_pct
** /*FT43*/ when (sod_disc_pct > -99999.99 and sod_disc_pct < 99999.99)
**          sod_price with frame c.
**J042*/
/*LB01*/        if sngl_ln then display /*sod_std_cost*/ sod_um_conv with frame d.
         end.

         /* REVIEW CONFIGURATION IF OLD CONFIGURED PART */
         else do:
            if sod_qty_ord = 0 then do:
/*GN90*        for each sob_det where sob_nbr = sod_nbr*/
/*GN90*/       for each sob_det exclusive-lock where sob_nbr = sod_nbr
/*H0CJ*/       and sob_line = sod_line :
/*GUI*/ if global-beam-me-up then undo, leave.


/*J042*/          /*UPDATE ACCUM QTY WORKFILES WITH REVERSAL*/
                  if line_pricing or not new_order then do:
/*J0XR*/             /*Qualified the qty (sob_qty_req) and extended list   */
/*J0XR*/             /*(sob_qty_req * sob_tot_std) parameters to divide by */
/*J0XR*/             /*u/m conversion ratio since these include this factor*/
/*J0XR*/             /*already.                                            */
/*LB01*/             {gprun.i ""zzgppiqty2.p"" "(sod_line,
                                               sob_part,
                                             - (sob_qty_req / sod_um_conv),
                                             - (sob_qty_req * sob_tot_std
                                                            / sod_um_conv),
                                               sod_um,
                                               no,
/*J0Z6*/                                       yes,
                                               yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J042*/          end.
/*G29J*/ {mfmrwdel.i "sob_det" sob_part sob_nbr
                     "string(sob_line) + ""-"" + sob_feature" sob_parent }
                  delete sob_det.
               end.
/*GUI*/ if global-beam-me-up then undo, leave.


/*F0X9*        {gpsct05.i &part=pt_part &site=sod_site &cost=                 */
/*F0X9*     "sct_bdn_tl + sct_lbr_tl + sct_mtl_tl + sct_ovh_tl + sct_sub_tl"} */
/*F0X9*/       {gpsct05.i &part=pt_part &site=sod_site &cost= sct_cst_tot}

               sod_std_cost = glxcst * sod_um_conv.

/*J0N2*/       /* DELETE ALL RELATED PRICE LIST HISTORY AND CURRENT  */
/*J0N2*/       /* PRICE LIST WORKFILE ENTRIES FOR THIS SALES ORDER   */
/*J0N2*/       /* BILL.  SET sod_list_pr TO THE VALUE OF THE PARENT  */
/*J0N2*/       /* LIST PRICE AND UPON RETURN TO THE CALLING PROCEDURE*/
/*J0N2*/       /* SUBSEQUENT PROCESSING WILL RESULT IN NO DISCOUNTS  */
/*J0N2*/       /* AND LIST AND NET PRICES WILL BE THE SAME.          */

/*J0N2*/       sod_list_pr = 0.

/*J0N2*/       for each pih_hist where pih_doc_type = 1
/*J0N2*/                           and pih_nbr      = sod_nbr
/*J0N2*/                           and pih_line     = sod_line
/*J0N2*/                         exclusive-lock:
/*J0N2*/           if pih_amt_type = "1" and pih_option = "" then
/*J0N2*/              sod_list_pr  = pih_amt.
/*J0N2*/           else
/*J0N2*/              delete pih_hist.
/*J0N2*/       end.

/*J0N2*/       for each wkpi_wkfl exclusive-lock:
/*J0N2*/           if wkpi_amt_type = "1" and wkpi_option = "" then
/*J0N2*/              sod_list_pr = wkpi_amt.
/*J0N2*/           else
/*J0N2*/              delete wkpi_wkfl.
/*J0N2*/       end.

/*J0N2*/       assign                      /*make sure nothing else happens*/
/*J0N2*/          exclude_confg_disc = no  /*upon returning to the calling */
/*J0N2*/          select_confg_disc  = no  /*procedure.                    */
/*J0N2*/          found_confg_disc   = no
/*J0N2*/       .

/*J0N2**       sod_list_pr = pt_price * so_ex_rate * sod_um_conv. */
               sod_disc_pct = 0.
               sod_price = sod_list_pr.
/*J042*/       /*DETERMINE DISCOUNT DISPLAY FORMAT*/
/*J042*/       {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}
/*J042***      disp sod_list_pr sod_disc_pct sod_price with frame c.*/
/*J042*/       display sod_list_pr discount sod_price with frame c.
            end.
            else do:
               if prev_qty_ord <> sod_qty_ord * sod_um_conv
               and prev_qty_ord <> 0 then do:
                  for each sob_det where sob_nbr = sod_nbr
/*H0CJ*/          and sob_line = sod_line exclusive-lock :
/*GUI*/ if global-beam-me-up then undo, leave.


/*J042*/             /*UPDATE ACCUM QTY WORKFILES WITH DIFFERENCE*/
/*J042*/             prev_qty_req = sob_qty_req.

/*F0JJ*/             assign

                     sob_qty_req = sob_qty_req * sod_qty_ord
                     * sod_um_conv / prev_qty_ord

/*F0JJ*/             substr(sob_serial,17,18) =
/*F0JJ*/                   string(sob_qty_req,"-9999999.999999999").

/*J042*/             if line_pricing or not new_order then do:
/*J0XR*/                /*Qualified the qty (sob_qty_req) and extended list  */
/*J0XR*/                /*(sob_qty_req * sob_tot_std) parameters to divide by*/
/*J0XR*/                /*u/m conversion ratio since these include this      */
/*J0XR*/                /*factor already.                                    */
/*LB01*//*J042*/        {gprun.i ""zzgppiqty2.p"" "(sod_line,
                                                  sob_part,
                                                  (sob_qty_req - prev_qty_req)
                                                               / sod_um_conv,
                                                  (sob_qty_req - prev_qty_req)
                                                               * sob_tot_std
                                                               / sod_um_conv,
                                                  sod_um,
                                                  no,
/*J0Z6*/                                          yes,
                                                  yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J042*/             end.
                  end.
/*GUI*/ if global-beam-me-up then undo, leave.


/*F0LT*/          config_changed = yes.
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
/*H0TB         if available sob_det and substr(sob_serial,16,1) = "y"  */
/*H0TB*/       if (available sob_det and substr(sob_serial,16,1) = "y") or
/*H0TB*/           not available sob_det
               then created_by_new_software = yes.

               pause 0.
               modify_sob = no.

/*H0CJ***** moved to form statement*****************************
 *             disp
 *             modify_sob  colon 17
 *             sod_sob_rev colon 17 label "Effective"
 *             sod_fa_nbr  colon 17
 *             sod_lot     colon 17
 *             with frame bom1.
 *
 *             set modify_sob
 *             with frame bom1 overlay attr-space
 *             side-labels row 9 column 25.
 **************************************************************/

/*J0N2*/       /* ALLOW FOR CONFIGURATION MODIFICATION ONLY IF REPRICING  */
/*J0N2*/       /* IS YES.  OTHERWISE IF A CONFIGURATION CHANGE OCCURS (ADD*/
/*J0N2*/       /* AN OPTION, DELETE AN OPTION, SETTING QTY TO 0, WILL     */
/*J0N2*/       /* REFLECT IN A CHANGE TO THE LINE ITEM LIST AND NET PRICE */
/*J0N2*/       /* WHICH WILL NOT BE REFLECTED IN PRICE LIST HISTORY.  IF  */
/*J0N2*/       /* PRICE LIST HISTORY IS NOT MAINTAINED, THEN WHEN POSTING */
/*J0N2*/       /* TO THE G/L, DISCOUNTS WILL BE OUT OF BALANCE.           */

/*J116** /*J0N2*/ if reprice_dtl then do: */
/*J116*/       if reprice_dtl or new_order then do:
/*H0CJ*/          display
/*H0CJ*/             modify_sob sod_sob_rev sod_fa_nbr sod_lot with frame bom1.

/*H0CJ*/          set modify_sob with frame bom1.

                  if (sod_fa_nbr > "" or sod_lot > "" )
                     and ((prev_qty_ord <> sod_qty_ord * sod_um_conv
                     and prev_qty_ord <> 0)
                     or modify_sob ) then do:
                     {mfmsg.i 420 2} /* Line item already released to FAS */
                  end.

                  hide frame bom1.
/*J0N2*/       end.

               if modify_sob then do:
                  if sngl_ln then hide frame d.

                  config_edited = yes.

                  if created_by_new_software then do:
                     /*GK86 MODIFIED CALL TO FOLLOWING*/
/*G2F4**            {gprun.i ""sosomtf2.p""
 *G2F4**             "(input sod_part, input """", input sod_qty_ord,
 *G2F4**                     input 0)"} */
/*LB01*//*G2F4*/    {gprun.i ""zzsosomtf2.p"" "(input sod_part, input """",
                        input sod_qty_ord * sod_um_conv,  input 0)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  end.
                  else do:
/*LB01*/             {gprun.i ""zzsosomte.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

                  end.

                  if sngl_ln then view frame d.
               end.
/*J042*/       /*Reprice current configuration*/
/*J042*/       else if line_pricing or reprice_dtl then do:
/*F0X9*           {gpsct05.i &part=pt_part &site=sod_site &cost=
*                  "sct_bdn_tl + sct_lbr_tl + sct_mtl_tl +
*                   sct_ovh_tl + sct_sub_tl"}
*F0X9*/
/*F0X9*/          {gpsct05.i &part=pt_part &site=sod_site &cost=sct_cst_tot}
                  sod_std_cost = glxcst * sod_um_conv.
/*J0XR*/          /*Changed parameter from "update_accum_qty" to "no"*/
/*J12Q*           {gprun.i ""sopccala.p"" "(no)"}     */
/*LB01*//*J12Q*/          {gprun.i ""zzsopccala.p"" "(no, yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J042*/       end.
            end.
         end.

/*J042*/ /*REPRICE COMPLETE CONFIGURATION*/

/*J042*/ if (line_pricing or reprice_dtl) and config_edited then do:

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

/*J0XR*/    /*Added sod_site, so_ex_rate to parameters*/
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
                                    output err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            /*TEST FOR REQUIRED PRICE LIST BASED ON MATCHING PART# AND UM
             OR IF ANY LIST TYPE PRICE LIST WAS FOUND*/

            if soc_pt_req or best_list_price = 0 then do:
               find first wkpi_wkfl where wkpi_parent   = ""  and
                                          wkpi_feature  = ""  and
                                          wkpi_option   = ""  and
                                          wkpi_amt_type = "1"
                                    no-lock no-error.
               if soc_pt_req then do:
                  if (available wkpi_wkfl and wkpi_source = "1") or
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
                        best_list_price = pt_price * so_ex_rate * sod_um_conv.
                        /*Create list type price list record in wkpi_wkfl*/
/*LB01*/                {gprun.i ""zzgppiwkad.p"" "(sod_um,
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
/*LB01*/                {gprun.i ""zzgppiwkad.p"" "(sod_um,
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
/*J0GT**             best_list_price = sod_list_pr. */
/*J0GT*/             best_list_price = wkpi_amt.
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
/*LB01*/        {gprun.i ""zzgppiwkad.p"" "(sod_um,
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

/*J0HR*/    if sod_list_pr <> 0 then do:

/*J0GT*/       /*FIND THE ITEM COST BEFORE CALLING gppibx.p FOR DISCOUNTS*/

/*J0XR**       *NOW PERFORMED IN gppibx03.p*
** /*J0GT*/    {gpsct05.i &part=sod_part &site=sod_site &cost=sct_cst_tot}
**J0XR*/

               /*GET BEST DISCOUNT TYPE PRICE LISTS*/

/*J0GT**       item_cost = 0. */
/*J0XR** /*J0GT*/ item_cost = glxcst. **Now performed in gppibx03.p*/
/*J0XR*/       /*Added sod_site, so_ex_rate to parameters*/
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
                                       output err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               /*CALCULATE BEST PRICE*/

/*LB01*/       {gprun.i ""zzgppibx04.p"" "(sobparent,
                                         sobfeature,
                                         sobpart,
                                         no,
                                         rfact)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               sod_price    = best_net_price.

/*J0HR*/    end.

            sod_disc_pct = if sod_list_pr <> 0 then
                              (1 - (sod_price / sod_list_pr)) * 100
                           else
                              0.

/*F0X9*     {gpsct05.i &part=pt_part &site=sod_site &cost=
*            "sct_bdn_tl + sct_lbr_tl + sct_mtl_tl + sct_ovh_tl + sct_sub_tl"}
*F0X9*/
/*F0X9*/    {gpsct05.i &part=pt_part &site=sod_site &cost=sct_cst_tot}
            sod_std_cost = glxcst * sod_um_conv.

/*J12Q*     {gprun.i ""sopccala.p"" "(no)"}     */
/*LB01**J12Q*/    {gprun.i ""zzsopccala.p"" "(no, yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J042**
** /*F0LT   if config_edited then do:  **/
** /*F0LT*/ if config_edited and config_changed then do:
**          find pt_mstr where pt_part = sod_part no-lock no-error.
**
**          if available pt_mstr then do:
**             {mfmsg01.i 640 1 yn}
**
**                if yn then do:
**
**                /* Cost tl + ll for Markup P.List */
**                {gpsct05.i &part=pt_part &site=sod_site &cost=sct_cst_tot}
**                assign
**
**                 pt_recno = recid(pt_mstr)
**                 pcqty    = sod_qty_ord
**                 sod_std_cost = glxcst * sod_um_conv
**                 sod_list_pr  = pt_price * sod_um_conv * so_ex_rate
**                 sod_price    = sod_list_pr
**                 sod_list_pr  = sod_price.
**                 old_list_pr  = sod_list_pr.
**                 old_price    = sod_list_pr.
**
**                 /*H086 PRICE TABLE FOR sod_part */
**                 if so_pr_list2 <> "" then do:
** /*H510*/              /* Added parameters for price table required, recid */
**                    {gprun.i ""gppclst.p""
**                             "(input        so_pr_list2,
**                               input        sod_part,
**                               input        sod_um,
**                               input        sod_um_conv,
**                               input        lineffdate,
**                               input        so_curr,
**                               input        yn,
**                               input        soc_pt_req,
**                               input-output sod_list_pr,
**                               input-output sod_price,
**                               output       minprice,
**                               output       maxprice,
**                               output       pc_recno
**                              )" }
**                end.
**
**                /* CALC TERMS INTEREST FOR CONFIGURED ITEM */
**                if sod_crt_int <> 0 then do:
**                   assign
**                     sod_list_pr = (100 + sod_crt_int) / 100 * sod_list_pr
**                     sod_price   = (100 + sod_crt_int) / 100 * sod_price.
**                end.
**
**                /* DISCOUNT TABLE FOR sod_part */
**                if so_pr_list <> "" then do:
** /*G0TW*/          /* Added supplier discount percent as input 10 */
**                   {gprun.i ""gppccal.p""
**                            "(input        sod_part,
**                              input        pcqty,
**                              input        sod_um,
**                              input        sod_um_conv,
**                              input        so_curr,
**                              input        so_pr_list,
**                              input        lineffdate,
**                              input        sod_std_cost,
**                              input        match_pt_um,
**                              input        0,
**                              input-output sod_list_pr,
**                              output       sod_disc_pct,
**                              input-output sod_price,
**                              output       pc_recno
**                             )" }
**  /*F0MV*/         if pt_price = 0 and sod_list_pr = 0 then
**  /*F0MV*/            sod_list_pr = sod_price.
**                end.
**
**                /* MIN/MAX PRICE PLUG FOR sod_part */
**                if so_pr_list2 <> "" then do:
**                   assign
**                      warmess = no
**                      warning = yes.
** /*H0FS*/          /* ADDED sod_part & REMOVED sod_um_conv PARAMETERS BELOW */
**                   {gprun.i ""gpmnmx.p""
**                            "(input        warning,
**                              input        warmess,
**                              input        minprice,
**                              input        maxprice,
**                              output       minmaxerr,
**                              input-output sod_list_pr,
**                              input-output sod_price,
**                              input        sod_part
**                             )" }
**                end.
**
**                /* sod_part cost set to tl, cum sob_det costs */
**
**                {gpsct05.i &part=pt_part &site=sod_site
**       &cost="sct_bdn_tl + sct_lbr_tl + sct_mtl_tl + sct_ovh_tl + sct_sub_tl"}
**
**                sod_std_cost = glxcst * sod_um_conv.
**                /* Price list of sob_part(s) */
**                {gprun.i ""sopccala.p""}
**
**  /*F0LT*       if sod_price <> old_price
**                or sod_list_pr <> old_list_pr then   ***/
** /*G1B4*/       if sod_list_pr = 0 then
** /*G1B4*/          sod_disc_pct = 0.
** /*G1B4*/       else
**                   sod_disc_pct = (1 - (sod_price / sod_list_pr)) * 100.
**
**                assign
**                old_price   = sod_price
**                old_list_pr = sod_list_pr
**                old_disc    = sod_disc_pct.
**
**                display sod_price sod_disc_pct
** /*FT43*/       when (sod_disc_pct > -99999.99 and sod_disc_pct < 99999.99)
**                with frame c.
**J042*/
/*LB01*                 if sngl_ln then display sod_std_cost with frame d. */

         end. /*line_pricing or reprice_dtl and config_edited*/

         undo_all2 = false.  /* flag successful completion of this routine */
