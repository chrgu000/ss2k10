/* GUI CONVERTED from sosorp02.p (converter v1.71) Tue Aug 11 12:15:19 1998 */
/* sosorp02.p - SALES ORDER REPORT BY ITEM                                   */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*F0PN*/ /*K0KZ*/ /*V8#ConvertMode=WebReport                                 */
/*V8:ConvertMode=FullGUIReport                                               */
/* REVISION: 1.0      LAST MODIFIED: 06/03/86   BY: PML                      */
/* REVISION: 1.0      LAST MODIFIED: 08/29/86   BY: EMB *12*                 */
/* REVISION: 2.1      LAST MODIFIED: 10/20/87   BY: WUG *A94*                */
/* REVISION: 4.0      LAST MODIFIED: 02/12/88   BY: FLM *A175*               */
/* REVISION: 4.0      LAST MODIFIED: 12/07/88   BY: RL  *C0028               */
/* REVISION: 5.0      LAST MODIFIED: 01/04/88   BY: MLB *B006*               */
/* REVISION: 5.0      LAST MODIFIED: 09/21/89   BY: MLB *B286*               */
/* REVISION: 6.0      LAST MODIFIED: 04/05/90   BY: pml *D001*               */
/* REVISION: 6.0      LAST MODIFIED: 04/10/90   BY: ftb *D002* added site    */
/* REVISION: 6.0      LAST MODIFIED: 04/20/90   BY: ftb *                    */
/* REVISION: 6.0      LAST MODIFIED: 01/03/91   BY: dld *D284*               */
/* REVISION: 6.0      LAST MODIFIED: 02/28/91   BY: dld *D388*               */
/* REVISION: 6.0      LAST MODIFIED: 04/12/91   BY: bjb *D625*               */
/* REVISION: 6.0      LAST MODIFIED: 10/21/91   BY: afs *D903*               */
/* REVISION: 7.0      LAST MODIFIED: 02/06/92   BY: tjs *F184*               */
/* REVISION: 7.3      LAST MODIFIED: 12/02/92   BY: WUG *G383*               */
/* REVISION: 7.3      LAST MODIFIED: 11/01/93   BY: afs *GG83*               */
/* REVISION: 7.3      LAST MODIFIED: 11/04/93   BY: cdt *GG81*               */
/* REVISION: 7.3      LAST MODIFIED: 05/19/94   BY: afs *FO31*               */
/* REVISION: 7.3      LAST MODIFIED: 11/01/94   BY: ame *GN90*               */
/* REVISION: 8.5      LAST MODIFIED: 09/12/95   BY: taf *J053*               */
/* REVISION: 7.3      LAST MODIFIED: 05/11/95   BY: rxm *F0RK*               */
/* REVISION: 7.3      LAST MODIFIED: 10/10/95   BY: jym *G0YX*               */
/* REVISION: 8.5      LAST MODIFIED: 04/09/96   BY: jzw *G1P6*               */
/* REVISION: 8.5      LAST MODIFIED: 07/19/96   BY: taf *J0ZZ*               */
/* REVISION: 8.6      LAST MODIFIED: 10/04/97   BY: ckm *K0KZ*               */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 07/16/98   BY: *L024* Bill Reckard      */

         /* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

         {mfdtitle.i "e+ "}

         /* ********** Begin Translatable Strings Definitions ********* */

         &SCOPED-DEFINE sosorp02_p_1 "短缺量"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosorp02_p_2 "  报表合计:"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosorp02_p_3 "总价格"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosorp02_p_4 "包括已发货量"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosorp02_p_5 "包括已备料量"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosorp02_p_6 "包括未处理量"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosorp02_p_7 "包括已领料量"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosorp02_p_8 "  零件合计:"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosorp02_p_9 "零件: "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosorp02_p_10 "   基本零件合计:"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosorp02_p_11 "     基本报表合计:"
         /* MaxLen: Comment: */

         /* ********** End Translatable Strings Definitions ********* */

         define variable rndmthd like rnd_rnd_mthd no-undo.
         define variable oldcurr like so_curr no-undo.
         define variable part like sod_part.
         define variable part1 like sod_part.
         define variable nbr like so_nbr.
         define variable nbr1 like so_nbr.
         define variable due like so_due_date.
         define variable due1 like so_due_date.
         define variable name like ad_name format "x(20)".
         define variable desc1 like pt_desc1.
         define variable um like pt_um.
         define variable qty_open like sod_qty_ord label {&sosorp02_p_1}.
         define variable base_rpt like so_curr.
         define variable mixed_rpt like mfc_logical initial no
            label {gpmixlbl.i}.
         define variable disp_curr as character format "x(1)" label "C".
         define variable spsn like sp_addr.
         define variable spsn1 like spsn.
         define variable stat like so_stat.
         define variable stat1 like so_stat.
         define variable site like so_site.
         define variable site1 like so_site.
         define variable include_allocated like mfc_logical
             label {&sosorp02_p_5} initial yes.
         define variable include_picked like mfc_logical
             label {&sosorp02_p_7} initial yes.
         define variable include_shipped like mfc_logical
             label {&sosorp02_p_4} initial yes.
         define variable include_unprocessed like mfc_logical
             label {&sosorp02_p_6} initial yes.
         define variable base_price like sod_price.
         define variable curr_price like sod_price.
         define variable ext_base_price like sod_price
                         label {&sosorp02_p_3} format "->,>>>,>>>,>>9.99".
/*L024*/ define variable ext_base_price_unrnd like sod_price.
         define variable ext_curr_price like sod_price
                         label {&sosorp02_p_3} format "->,>>>,>>>,>>9.99".
/*L024*/ define variable ext_curr_price_unrnd like sod_price.
/*L024*/ define variable mc-error-number like msg_nbr no-undo.
/*L024*/ define variable LOC like SOD_LOC .
/*L024*/ define variable LOC1 like SOD_LOC .
/*L024*/ define variable LOC2 like SOD_LOC .

         {gpcurrp.i}

/*L024*/ {gprunpdf.i "mcpl" "p"}

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
part           colon 15
            part1          label {t001.i} colon 49 skip
            nbr            colon 15
            nbr1           label {t001.i} colon 49 skip
            due            colon 15
            due1           label {t001.i} colon 49 skip
            spsn           colon 15
            spsn1          label {t001.i} colon 49 skip
            stat           colon 15
            stat1          label {t001.i} colon 49 skip
            site           colon 15
            site1          label {t001.i} colon 49 skip
            LOC1           colon 15
            LOC2           label {t001.i} colon 49
                                                   skip(1)
                                                   
            base_rpt       colon 22 skip
            mixed_rpt      colon 22 skip(1)
            include_allocated   colon 22 skip
            include_picked      colon 22 skip
            include_shipped     colon 22 skip
            include_unprocessed colon 22 skip
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " 选择条件 "
  &ELSE {&SELECTION_CRITERIA}
  &ENDIF .
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



         FORM /*GUI*/ 
            sod_nbr
            so_cust
            name
            LOC
            sod_line
            sod_qty_all
            sod_qty_pick
            qty_open
            sod_um
            disp_curr
            sct_mtl_tl LABEL "单价"
           /* base_price*/
            ext_base_price
            sod_due_date
            sod_type
         with STREAM-IO /*GUI*/  frame c down width 132 no-box.

/*L024*  find first gl_ctrl no-lock.  */
         oldcurr = "".
/*K0KZ*/ {wbrp01.i}

         
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


            find first order_wkfl no-error.
            if available order_wkfl then
               for each order_wkfl exclusive-lock:
                  delete order_wkfl.
            end.
           
            if part1 = hi_char then part1 = "".
            if nbr1 = hi_char then nbr1 = "".
            if due = low_date then due = ?.
            if due1 = hi_date then due1 = ?.
            if spsn1 = hi_char then spsn1 = "".
            if stat1 = hi_char then stat1 = "".
            if site1 = hi_char then site1 = "".
            if loc2  = hi_char then loc2  = "".



/*K0KZ*/ if c-application-mode <> 'web':u then
            
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


/*K0KZ*/ {wbrp06.i &command = update &fields = "  part part1 nbr nbr1 due due1
            spsn spsn1 stat stat1 site site1  base_rpt  mixed_rpt
            include_allocated  include_picked include_shipped
            include_unprocessed" &frm = "a"}

/*K0KZ*/ if (c-application-mode <> 'web':u) or
/*K0KZ*/ (c-application-mode = 'web':u and
/*K0KZ*/ (c-web-request begins 'data':u)) then do:


            bcdparm = "".
            {gprun.i ""gpquote.p"" "(input-output bcdparm, 18,
             part, part1, nbr, nbr1, string(due), string(due1),
             spsn, spsn1, stat, stat1, site, site1, base_rpt,
             string(mixed_rpt),
             string(include_allocated), string(include_picked),
             string(include_shipped), string(include_unprocessed),
             null_char, null_char)"}
            IF LOC2 = "" THEN LOC2 = HI_CHAR. 
            if part1 = "" then part1 = hi_char.
            if nbr1 = "" then nbr1 = hi_char.
            if due = ? then due = low_date.
            if due1 = ? then due1 = hi_date.
            if spsn1 = "" then spsn1 = hi_char.
            if stat1 = "" then stat1 = hi_char.
            if site1 = "" then site1 = hi_char.

/*K0KZ*/ end.

            /* SELECT PRINTER  */
            
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:
find first order_wkfl no-error.




            {mfphead.i}

            FORM /*GUI*/ 
               skip(1)
            with STREAM-IO /*GUI*/  frame a1 page-top width 132.
            view frame a1.

            /* GET ORDER DETAIL  */
            for each sod_det where (sod_part >= part and sod_part <= part1)
            and not sod_sched            /*G383*/
            and ((sod_due_date >= due and sod_due_date <= due1)
            or  (sod_due_date = ? and (due = low_date or due1 = hi_date)))
            and (sod_nbr >= nbr and sod_nbr <= nbr1)
            and (sod_slspsn[1] >= spsn and sod_slspsn[1] <= spsn1)
            and (sod_site >= site and sod_site <= site1)
            AND (SOD_LOC >= LOC1 AND SOD_LOC <= LOC2)
            and ((include_allocated and sod_qty_all <> 0) or
                (include_picked and sod_qty_pick <> 0) or
                (include_shipped and sod_qty_ship <> 0) or
                (include_unprocessed and sod_qty_all = 0 and
                                        sod_qty_pick = 0 and
                                        sod_qty_ship = 0))
            no-lock,
            each so_mstr where so_nbr = sod_nbr
            and (so_stat >= stat and so_stat <= stat1)
            and (base_rpt = "" or base_rpt = so_curr),
            EACH SCT_DET WHERE SCT_PART = SOD_PART AND (sct_sim = "Standard" AND SCT_SITE = "10000")
            no-lock break by sod_part by sod_due_date with frame c
            no-attr-space:

               if (oldcurr <> so_curr) or (oldcurr = "") then do:

/*L024*           {gpcurmth.i   */
/*L024*              "so_curr"  */
/*L024*              "4"        */
/*L024*              "leave"    */
/*L024*              "pause" }  */
/*L024*/          /* GET ROUNDING METHOD FROM CURRENCY MASTER */
/*L024*/          {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                     "(input  so_curr,
                       output rndmthd,
                       output mc-error-number)" }
/*L024*/          if mc-error-number <> 0 then do:
/*L024*/             {mfmsg.i mc-error-number 4}
/*L024*/             if c-application-mode <> 'WEB':U then
/*L024*/                pause.
/*L024*/             undo, next.
/*L024*/          end. /* if mc-error-number <> 0 */
                  oldcurr = so_curr.
               end.

               qty_open = sod_qty_ord - sod_qty_ship.
               if sod_qty_ord > 0 and qty_open < 0 then qty_open = 0.
               if sod_qty_ord < 0 and qty_open > 0 then qty_open = 0.

               /* SET CURRENCY CONVERTED FLAG */
               disp_curr = "".
               if base_curr <> so_curr and base_rpt <> so_curr
               and not (base_rpt = "" and mixed_rpt)
               then disp_curr = "Y".

               /* SET PRICE FOR CURR AND BASE */
          /*     curr_price = sod_price.*/
        
          
          
          

/*L024*        base_price = sod_price / so_ex_rate.     */
/*L024*/       {gprunp.i "mcpl" "p" "mc-curr-conv"
                    "(input  so_curr,
                      input  base_curr,
                      input  so_ex_rate,
                      input  so_ex_rate2,
                      input  sod_price,
                      input  false,  /* DO NOT ROUND */
                      output base_price,
                      output mc-error-number)" }
/*L024*/       if mc-error-number <> 0 then do:
/*L024*/          {mfmsg.i mc-error-number 2}
/*L024*/       end. /* if mc-error-number <> 0 */

               /* CALCULATE EXTENDED PRICE AND BASE TOTAL */
               ext_curr_price = qty_open * sct_mtl_tl.
/* ROUND EXT_CURR_PRICE ACCORDING TO RNDMTHD*/
/*L024*        {gprun.i ""gpcurrnd.p"" "(input-output ext_curr_price, */
/*L024*                                  input rndmthd)"}             */

               /* BASE EQUALS EXT_CURR_PRICE CONVERTED USING SO_EX_RATE */
               /* AND ROUNDING PER BASE ROUND METHOD */

/*L024*        ext_base_price = ext_curr_price / so_ex_rate. */
/*L024*/       {gprunp.i "mcpl" "p" "mc-curr-conv"
                    "(input  so_curr,
                      input  base_curr,
                      input  so_ex_rate,
                      input  so_ex_rate2,
                      input  ext_curr_price,
                      input  false,  /* DO NOT ROUND */
                      output ext_base_price,
                      output mc-error-number)" }
/*L024*/       if mc-error-number <> 0 then do:
/*L024*/          {mfmsg.i mc-error-number 2}
/*L024*/       end.

/*L024*/       /* SAVE UNROUNDED VALUES */
/*L024*/       assign
/*L024*/          ext_curr_price_unrnd = ext_curr_price
/*L024*/          ext_base_price_unrnd = ext_base_price.

/*L024*/       {gprunp.i "mcpl" "p" "mc-curr-rnd"
                  "(input-output ext_curr_price,
                    input        rndmthd,
                    output       mc-error-number)" }
/*L024*/       if mc-error-number <> 0 then do:
/*L024*/          {mfmsg.i mc-error-number 2}
/*L024*/       end.

/*L024*/       {gprunp.i "mcpl" "p" "mc-curr-rnd"
                  "(input-output ext_base_price,
                    input        rndmthd,
                    output       mc-error-number)" }
  
/*L024*/       /* ROUNDING DONE IN mc-curr-conv */
/*L024*        {gprun.i ""gpcurrnd.p"" "(input-output ext_base_price, */
/*L024*                                  input gl_rnd_mthd)"}         */

               /* ACCUMULATE SUB-TOTALS */
               accumulate ext_curr_price (total by sod_part).
               accumulate ext_base_price (total by sod_part).
/*L024*/       accumulate ext_curr_price_unrnd (total by sod_part).
/*L024*/       accumulate ext_base_price_unrnd (total by sod_part).
               accumulate (sod_qty_all * sod_um_conv) (total by sod_part).
               accumulate (sod_qty_pick * sod_um_conv) (total by sod_part).
               accumulate (qty_open * sod_um_conv) (total by sod_part).
        
               
 
               name = "".
               find ad_mstr where ad_addr = so_cust no-lock no-wait no-error.
               if available ad_mstr then name = ad_name.

               desc1 = "".
               um = "".
               find pt_mstr where pt_part = sod_part no-lock no-wait no-error.
               if available pt_mstr then desc1 = pt_desc1 + " " + pt_desc2.
               if available pt_mstr then um = pt_um.


               if first-of(sod_part) then do with frame c:
                  if base_rpt = ""
                  and mixed_rpt
                  then do:
                     page.
                  end.
                  else do:
                     if page-size - line-counter < 3 then page.
                  end.
                  display WITH STREAM-IO /*GUI*/ .
                  put {&sosorp02_p_9} sod_part " " desc1 format "X(49)" skip(1).
               end.
                   LOC = "PF" + SUBSTRING(SOD_LOC,1,2).
               /* PRINT DETAIL LINE */
          /*  if base_curr = so_curr
               or (base_rpt = "" and not mixed_rpt)
          
               then do:*/
                  display sod_nbr so_cust name LOC sod_line sod_qty_all
                  sod_qty_pick qty_open sod_um disp_curr sct_mtl_tl 
                    ext_curr_price @ ext_base_price base_price
                  ext_base_price sod_due_date sod_type
                  with frame c STREAM-IO /*GUI*/ .
                  down with frame c.
              /* end.
               else do:
                  display sod_nbr so_cust name LOC sod_line sod_qty_all
                  sod_qty_pick qty_open sod_um disp_curr sct_mtl_tl /*curr_price @ base_price
                  ext_curr_price @ ext_base_price sod_due_date sod_type*/
                  with frame c STREAM-IO /*GUI*/ .
                  down with frame c.
               end.*/

               /*  STORE SALES ORDER TOTALS, BY CURRENCY, IN WORK FILE.    */
               if base_rpt = ""
               and mixed_rpt
               then do:
                  find first order_wkfl where so_curr = ordwk_curr no-error.
                  /* If a record for this currency doesn't exist, create one. */
                  if not available order_wkfl then do:
                      create order_wkfl.
                      ordwk_curr = so_curr.
                  end.
                  /* Accumulate individual currency totals in work file. */
/*L024*           ordwk_for = ordwk_for + ext_curr_price.   */
/*L024*           ordwk_base = ordwk_base + ext_base_price. */

/*L024*/          assign
/*L024*/             ordwk_for  = ordwk_for  + ext_curr_price_unrnd
/*L024*/             ordwk_base = ordwk_base + ext_base_price_unrnd.

               end.

               if last-of(sod_part) then do with frame c:

                  /* DISPLAY CURRENCY ITEM TOTAL */
                  if base_rpt <> "" then do:
                     if page-size - line-counter < 3 then page.
                     underline sod_qty_all sod_qty_pick qty_open ext_base_price.
                     display
                     so_curr + " " + {&sosorp02_p_8} @ name
                     accum total by sod_part(sod_qty_all * sod_um_conv)
                        @ sod_qty_all
                     accum total by sod_part(sod_qty_pick * sod_um_conv)
                        @ sod_qty_pick
                     accum total by sod_part(qty_open * sod_um_conv)
                        @ qty_open
                     um @ sod_um
                     accum total by sod_part (ext_curr_price) @ ext_base_price WITH STREAM-IO /*GUI*/ .
                     down with frame c.
                  end.

                  /* DISPLAY BASE ITEM TOTAL */
                  if base_rpt = "" and not mixed_rpt
                  then do:
                     if page-size - line-counter < 3 then page.
                     underline sod_qty_all sod_qty_pick qty_open ext_base_price.
                     display
                       {&sosorp02_p_10} @ name
                       accum total by sod_part(sod_qty_all * sod_um_conv)
                          @ sod_qty_all
                       accum total by sod_part(sod_qty_pick * sod_um_conv)
                          @ sod_qty_pick
                       accum total by sod_part(qty_open * sod_um_conv)
                          @ qty_open
                       um @ sod_um
                       accum total by sod_part (ext_base_price)
                          @ ext_base_price WITH STREAM-IO /*GUI*/ .
                     down with frame c.
                  end.

                  /* DISPLAY QTY ITEM TOTAL ONLY */
                  if base_rpt = ""
                  and mixed_rpt
                  then do:
                     if page-size - line-counter < 3 then page.
                     underline sod_qty_all sod_qty_pick qty_open.
                     display
                       {&sosorp02_p_8} @ name
                       accum total by sod_part(sod_qty_all * sod_um_conv)
                          @ sod_qty_all
                       accum total by sod_part(sod_qty_pick * sod_um_conv)
                          @ sod_qty_pick
                       accum total by sod_part(qty_open * sod_um_conv)
                          @ qty_open
                       um @ sod_um WITH STREAM-IO /*GUI*/ .
                     down with frame c.

                     /* IF ALL CURRENCIES, PRINT A SUMMARY REPORT */
                     /* BROKEN BY CURRENCY.*/
                     {gprun.i ""gpcurrp.p""}
                     
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

                     find first order_wkfl no-error.
                     if available order_wkfl then
                        for each order_wkfl exclusive-lock:
                           delete order_wkfl.
                     end.
                  end.

                  if last(sod_part) then do with frame c:
                     if page-size - line-counter < 3 then page.
                     if base_rpt = "" and not mixed_rpt
                     then do:
                        /* DISPLAY BASE TOTAL */
                        underline  ext_base_price.
                        display
                        {&sosorp02_p_11} @ name
                        accum total (ext_base_price) @ ext_base_price WITH STREAM-IO /*GUI*/ .
                        down with frame c.
                     end.

                     if base_rpt <> "" then do:
                        /* DISPLAY CURRENCY TOTAL */
                        underline  ext_base_price.
                        display
                        so_curr + " " + {&sosorp02_p_2} @ name
                        accum total (ext_curr_price) @ ext_base_price WITH STREAM-IO /*GUI*/ .
                        down with frame c.
                     end.
                  end. /* IF LAST(SOD_PART) */
               end. /* IF LAST-OF(SOD_PART) */
               
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

            end. /* FOR EACH SOD_DET */

            /* REPORT TRAILER  */
            
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


         end. /* REPEAT */

/*K0KZ*/ {wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" part part1 nbr nbr1 due due1 spsn spsn1 stat stat1 site site1 LOC1 LOC2 base_rpt mixed_rpt include_allocated include_picked include_shipped include_unprocessed "} /*Drive the Report*/
