/* bmpkrpa.p - SIMULATED PICKLIST REPORT                                */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.0       LAST MODIFIED: 05/12/86      BY: EMB             */
/* REVISION: 1.0       LAST MODIFIED: 08/29/86      BY: EMB *12 *       */
/* REVISION: 1.0       LAST MODIFIED: 01/29/87      BY: EMB *A19*       */
/* REVISION: 2.1       LAST MODIFIED: 09/02/87      BY: WUG *A94*       */
/* REVISION: 4.0       LAST MODIFIED: 02/24/88      BY: WUG *A175*      */
/* REVISION: 4.0       LAST MODIFIED: 04/06/88      BY: FLM *A193*      */
/* REVISION: 4.0       LAST MODIFIED: 07/11/88      BY: flm *A318*      */
/* REVISION: 4.0       LAST MODIFIED: 08/03/88      BY: flm *A375*      */
/* REVISION: 4.0       LAST MODIFIED: 11/04/88      BY: flm *A520*      */
/* REVISION: 4.0       LAST MODIFIED: 11/15/88      BY: emb *A535*      */
/* REVISION: 4.0       LAST MODIFIED: 02/21/89      BY: emb *A654*      */
/* REVISION: 5.0       LAST MODIFIED: 06/23/89      BY: MLB *B159*      */
/* REVISION: 6.0       LAST MODIFIED: 07/11/90      BY: WUG *D051*      */
/* REVISION: 6.0       LAST MODIFIED: 10/31/90      BY: emb *D145*      */
/* REVISION: 6.0       LAST MODIFIED: 02/26/91      BY: emb *D376*      */
/* REVISION: 6.0       LAST MODIFIED: 08/02/91      BY: bjb *D811*      */
/* REVISION: 7.2       LAST MODIFIED: 10/26/92      BY: emb *G234*      */
/* REVISION: 7.2       LAST MODIFIED: 11/04/92      BY: pma *G265*      */
/* REVISION: 7.4       LAST MODIFIED: 09/01/93      BY: dzs *H100*      */
/* REVISION: 7.4       LAST MODIFIED: 12/20/93      BY: ais *GH69*      */
/* REVISION: 7.2       LAST MODIFIED: 03/18/94      BY: ais *FM19*      */
/* REVISION: 7.2       LAST MODIFIED: 03/23/94      BY: qzl *FM31*      */
/* REVISION: 7.4       LAST MODIFIED: 04/18/94      BY: ais *H357*      */
/* REVISION: 7.4       LAST MODIFIED: 10/18/94      BY: jzs *GN61*      */
/* REVISION: 7.4       LAST MODIFIED: 02/03/95      by: srk *H09T       */
/* REVISION: 7.2       LAST MODIFIED: 02/09/95      BY: qzl *F0HQ*      */
/* REVISION: 8.5       LAST MODIFIED: 05/18/94      BY: dzs *J020*      */
/* REVISION: 7.4       LAST MODIFIED: 12/20/95      BY: bcm *G1H5*      */
/* REVISION: 7.4       LAST MODIFIED: 01/22/96      BY: jym *G1JF*      */
/* REVISION: 8.6       LAST MODIFIED: 09/27/97      BY: mzv *K0J *      */
/* REVISION: 8.6       LAST MODIFIED: 10/15/97      BY: ays *K10Y*      */
/* REVISION: 7.4       LAST MODIFIED: 02/04/98      BY: jpm *H1JC*      */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan    */
/* REVISION: 9.0       LAST MODIFIED: 10/16/98      BY: *J32L* Felcy D'Souza */
/* REVISION: 9.0       LAST MODIFIED: 03/13/99      BY: *M0BD* Alfred Tan    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 07/04/00 BY: *N0F3* Rajinder Kamra   */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00 BY: *N0KK* jyn                 */
/* ss - 100415.1 By: Randy Li */


/*GN61*/ {mfdtitle.i "100415 "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE bmpkrpa_p_1 "As of Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpkrpa_p_2 "Op"
/* MaxLen: Comment: */

/*N0F3
 * &SCOPED-DEFINE bmpkrpa_p_3 "(BOM)"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE bmpkrpa_p_4 "(PARENT)"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE bmpkrpa_p_5 " BOM = "
 * /* MaxLen: Comment: */
 *N0F3*/

&SCOPED-DEFINE bmpkrpa_p_6 "Quantity"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         define new shared workfile pkdet no-undo
/*G1H5*     field pkpart like pk_part */
/*G1H5*/    field pkpart like ps_comp
/*H100*/    field pkop as integer
/*G1H5*/       format ">>>>>9"
            field pkstart like pk_start
            field pkend like pk_end
            field pkqty like pk_qty
/*F0HQ*/    field pkbombatch like bom_batch
            field pkltoff like ps_lt_off.

         define new shared variable comp like ps_comp.
/*GH69*  define new shared variable eff_date like tr_effdate.           */
/*GH69*/ define new shared variable eff_date as date label {&bmpkrpa_p_1}.
         define variable level as integer no-undo.
         define variable qty like pk_qty label {&bmpkrpa_p_6} no-undo.
/*G1H5*  define variable part like pt_part. */
/*G1H5*  define variable part1 like pt_part.*/
/*G1H5*/ define variable part  like ps_par       no-undo.
/*G1H5*/ define variable part1 like ps_par       no-undo.
         define variable line  like pt_prod_line no-undo.
         define variable line1 like pt_prod_line no-undo.

/*G234*/ define new shared variable site like in_site no-undo.
/*G234*/ define new shared variable parent_bom like pt_bom_code.
/*G265/*G234*/ define variable ord_qty like pt_ord_qty */
/*G265*/ define variable ord_qty like qty no-undo.
/*G265*/ define shared variable transtype as character format "x(4)".
/*H100*/ define variable op  like ro_op format ">>>>>>" no-undo.
/*H100*/ define variable op1 like ro_op format ">>>>>>" no-undo.
/*G1H5*/ define variable item-code as character no-undo.
/*G1H5*/ define variable bom-code  as character no-undo.
/*G1H5*/ define variable is-item   as logical   no-undo.

/*FM19*/ define new shared variable phantom like mfc_logical initial yes.
         define buffer ptmstr for pt_mstr.

/*J32L*/ define variable um like bom_batch_um no-undo.
/*J32L*/ define variable batchdesc1 like pt_desc2 no-undo.
/*J32L*/ define variable batchdesc2 like pt_desc2 no-undo.
/*J32L*/ define variable aval as logical no-undo.
/*J32L*/ define variable batchqty like pt_batch no-undo.
/* ss lambert 2010-1-26 Begin */
         define variable myprice like pt_price no-undo.         
/* ss lambert 2010-1-26 End */
/* SS - 100415.1 - B */
		 DEFINE VARIABLE fromset like cs_set .
/* SS - 100415.1 - E */


/*H100*/ {gpxpld01.i "new shared"}

         eff_date = today.
/*G234*/ site = global_site.
		 qty  =  1 .

         form
/*G234*/    site           colon 15
/*G265*/    si_desc        no-label
/* SS - 100415.1 - B */
			fromset			colon 15
/* SS - 100415.1 - E */

            part           colon 15 part1 label {t001.i} colon 49
/*H100*/    op             colon 15 op1   label {t001.i} colon 49
            line           colon 15 line1 label {t001.i} colon 49
            skip(1)
            qty            colon 15
            eff_date       colon 15
         with frame a side-labels width 80 attr-space.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

/*H09T*/ /*MOVED FROM ABOVE - MISPLACED*/
/*GN61*/ find si_mstr where si_site = site  no-lock no-error.
/*GN61*/ if available si_mstr then display si_desc with frame a.

/*K10Y*/ {wbrp02.i}

         repeat:

            if part1 = hi_char then part1 = "".
/*G1H5*     if op1 = 999999 then op1 = 0.  */
            if line1 = hi_char then line1 = "".

/*K10Y*/    if c-application-mode <> "WEB" then
            update
/*G234*/       site
			   /* SS - 100415.1 - B */
			   fromset
			   /* SS - 100415.1 - E */
               part part1
/*H100*/       op op1
               line line1
               qty eff_date
            with frame a.
/* SS - 100415.1 - B

    {wbrp06.i &command = update &fields = " part part1  op op1
             line line1  site qty eff_date    " &frm = "a"}
SS - 100415.1 - E */
/* SS - 100415.1 - B */		
		  {wbrp06.i &command = update &fields = " part part1  op op1
             line line1  site fromset qty eff_date    " &frm = "a"}
/* SS - 100415.1 - E */

/*K10Y*/    if (c-application-mode <> "WEB") or
/*K10Y*/       (c-application-mode = "WEB" and
/*K10Y*/       (c-web-request begins "DATA")) then do:

/*GN61 MOVED SECTION BELOW BATCHING **************************************
 * /*G234*/ /* Added section */
 *          find si_mstr no-lock where si_site = site no-error.
 *          if not available si_mstr then do:
 *             {mfmsg.i 708 3}
 *             undo, retry.
 *          end.
 * /*G265*/ display si_desc with frame a.
 * /*G234*/ /* End of added section */
 *END OF MOVED SECTION ************************************** */ /*GN61*/

               bcdparm = "".
               {mfquoter.i part   }
               {mfquoter.i part1  }
/*H100*/       {mfquoter.i op     }
/*H100*/       {mfquoter.i op1    }
               {mfquoter.i line   }
               {mfquoter.i line1  }
/*G234*/       {mfquoter.i site   }
               {mfquoter.i qty    }
               {mfquoter.i eff_date}

               if part1 = "" then part1 = hi_char.
/*G1H5*        if op1 = 0 then op1 = 999999.  */
               if line1 = "" then line1 = hi_char.

/*H1JC*/       /* Add do loop to prevent converter from creating on leave of */
/*H1JC*/       do:

/*GN61*/          if not can-find(si_mstr where si_site = site) then do:
                     {mfmsg.i 708 3} /* SITE DOES NOT EXIST. */
                     display "" @ si_desc with frame a.
/*K10Y*/             if c-application-mode = "WEB" then return.
/*K10Y*/             else
                        next-prompt site with frame a.
                     undo, retry.
/*GN61*/          end.
/*GN61*/          else do:
/*GN61*/             find si_mstr where si_site = site  no-lock no-error.
/*GN61*/             if available si_mstr then display si_desc with frame a.
/*GN61*/          end.

/*H1JC*/       end.

/*K10Y*/    end. /* if c-application-mode */

            /* SELECT PRINTER */
            
/*SS 20080623 - B*/
						{mfselprt.i "printer" 132}
/*
/*G1H5*/    {mfselbpr.i "printer" 132}
/*G1H5*/    {mfphead.i}
*/
/*SS 20080623 - E*/

/*G1H5*     {mfselbpr.i "printer" 80} */
/*G1H5*     {mfphead2.i}              */

/*G265/*G234*/ display site si_desc no-label with side-labels width 80   */
/*G265/*G234*/ frame c page-top.                                         */

/*G265*     for each pt_mstr no-lock                            */
/*G265*     where pt_part >= part and pt_part <= part1          */
/*G265*     and pt_prod_line >= line and pt_prod_line <= line1  */
/*G234*     and can-find (first ps_mstr where ps_par = pt_part) */
/*G265*     with frame b width 80 no-attr-space down:           */

/*G1H5** DELETED SECTION*****************************
 * /*G265*/ for each bom_mstr no-lock
 * /*G265*/ where bom_parent >= part and bom_parent <= part1
 * /*G265*/ with frame b width 80 no-attr-space down:
 *
 * /*G265*/    find pt_mstr no-lock where pt_part = bom_parent no-error.
 * /*G265*/    if (not available pt_mstr and (line = "" or line1 = hi_char))
 * /*G265*/    or (available pt_mstr and
 * /*G265*/        (pt_prod_line >= line and pt_prod_line <= line1))
 * /*G265*/    then do:
 **G1H5**/

/*G1H5*/    /* FIND FIRST MATCHING RECORDS */
/*G1H5*/    find first pt_mstr where pt_part >= part and
/*G1H5*/                             pt_part <= part1 and
/*G1H5*/                             pt_prod_line >= line and
/*G1H5*/                             pt_prod_line <= line1
/*G1H5*/    no-lock no-error.

/*G1H5*/    find first bom_mstr where bom_parent >= part and
/*G1H5*/                              bom_parent <= part1
/*G1H5*/    no-lock no-error.

/*G1H5*/    itemloop:
/*G1H5*/    repeat with frame b width 132 no-attr-space down:

               /* SET EXTERNAL LABELS */
               setFrameLabels(frame b:handle).
/*G1H5*/       /* DETERMINE WHETHER WE WANT TO EXPLODE THE ITEM OR THE BOM */
/*G1H5*/       if available pt_mstr and available bom_mstr then do:
/*G1H5*/          if pt_part <= bom_parent then do:
/*G1H5*/             is-item = yes.
/*G1H5*/             item-code = pt_part.
/*G1H5*/          end.
/*G1H5*/          else do:
/*G1H5*/             is-item = no.
/*G1H5*/             item-code = bom_parent.
/*G1H5*/          end.
/*G1H5*/       end.
/*G1H5*/       else if available pt_mstr then do:
/*G1H5*/          is-item = yes.
/*G1H5*/          item-code = pt_part.
/*G1H5*/       end.
/*G1H5*/       else if available bom_mstr then do:
/*G1H5*/          is-item = no.
/*G1H5*/          item-code = bom_parent.
/*G1H5*/       end.
/*G1H5*/       /* IF NO MORE ITEMS OR BOMS ARE AVAILABLE THEN WE ARE DONE. */
/*G1H5*/       else leave itemloop.

/*G1H5*/       if is-item then do:
/*G1H5*/           if pt_bom_code > "" then
/*G1H5*/             find bom_mstr where bom_parent = pt_bom_code
/*G1H5*/             no-lock no-error.
/*G1H5*/          else
/*G1H5*/             find bom_mstr where bom_parent = pt_part
/*G1H5*/             no-lock no-error.
/*G1H5*/       end.

/*G1H5*/       /* EXPLODE ALL PRODUCT STRUCTURES FOR ITEMS.  ONLY EXPLODE  *
                * PRODUCT STRUCTURES FOR BOMS IF NO PRODUCT LINE SELECTION *
                * CRITERIA HAS BEEN ENTERED.                               */
/*G1H5*/       if (available bom_mstr and
/*G1H5*/           (is-item or
/*G1H5*/            (not is-item and (line = "" and line1 = hi_char))
/*G1H5*/          ))
/*G1H5*/       then
/*G1H5*/       bomblock:
/*G1H5*/       do:

/*G265*           comp = pt_part.  */
/*G265*/          comp = bom_parent.

/*G234*/          /* Added section */
/*G1H5* /*G265*/  if available pt_mstr then do: **/
/*G1H5*/          if is-item then do:
                     find ptp_det where ptp_part = pt_part
                                    and ptp_site = site
                     no-lock no-error.
                     if available ptp_det then do:
/*J020*/                if index("1234",ptp_joint_type) > 0 then next.
                        if ptp_bom_code > "" then comp = ptp_bom_code.
                     end.
                     else do:
/*J020*/                if index("1234",pt_joint_type) > 0 then next.
                        if pt_bom_code > "" then comp = pt_bom_code.
                        if pt_site <> site then do:
                           find in_mstr where in_part = pt_part
                                          and in_site = site
                           no-lock no-error.
/*G1H5*/                   if not available in_mstr then leave bomblock.
/*G1H5*                    if not available in_mstr then next.          */
                        end.
                     end.
/*G265*/          end.
                  parent_bom = comp.
/*G234*/          /* End of added section*/

                  /* explode part by standard picklist logic */
/*H100*           {gprun.i ""woworla2.p""}                   */
/*H357* /*H100*/  {gprun.i ""woworla.p""}                    */
/*H357*/          {gprun.i ""woworla2.p""}

/*G234*/          /* Added section */
                  find first pkdet where eff_date = ? or (eff_date <> ?
                                    and (pkstart = ? or pkstart <= eff_date)
/*H100*           and (pkend = ? or eff_date <= pkend)) no-error. */
/*H100*/                            and (pkend = ? or eff_date <= pkend)
/*G1H5*/          and (pkop >= op and (pkop <= op1 or op1 = 0)))
/*G1H5*/          no-error.
/*G1H5* /*H100*/  and (pkop >= op and pkop <= op1)) no-error. */
/*G1H5*/          if not available pkdet then leave bomblock.
/*G1H5*           if not available pkdet then next.           */
/*G234*/          /* End of added section */

                  if page-size - line-counter < 4 then page.

                  display
/*G265*               string(pt_part,"x(18)") + " " + "(PARENT)"  */
/*N0F3 /*G265*/       string(bom_parent,"x(18)") + " " + {&bmpkrpa_p_4} */
/*N0F3*/              string(bom_parent,"x(18)") + " (":U + getTermLabel("PARENT",6) + ")":U
                     @ pt_part format "x(27)"
/*G265*              pt_desc1 qty pt_um                          */
                  with frame b.

/*G1H5*/          if is-item then
/*N0F3 /*G1H5*/     display string(pt_part,"x(18)") + " " + {&bmpkrpa_p_4} */
/*N0F3*/            display string(pt_part,"x(18)") +  " (":U + getTermLabel("PARENT",6) + ")":U
/*G1H5*/             @ pt_part
/*G1H5*/             with frame b.
/*G1H5*/          else

/*N0F3 /*G1H5*/    display string(bom_parent,"x(18)") + " " + {&bmpkrpa_p_3}*/
/*N0F3*/           display string(bom_parent,"x(18)") + " (":U + getTermLabel("BOM",6) + ")":U
/*G1H5*/             @ pt_part
/*G1H5*/             with frame b.

/*G234*/          /* Added section */

                  ord_qty = qty.

/*G1H5* /*G265*/  if transtype = "BM" and available pt_mstr then do:*/

/*J32L** BEGIN OF ADDED SECTION **
 * /*G1H5*/          if transtype = "BM" and is-item then do:
 *                   if ord_qty = 0 then do:
 *                      find ptp_det where ptp_part = pt_part
 *                                     and ptp_site = site
 *                      no-lock no-error.
 *                      if available ptp_det
 *                      then
 *                         ord_qty = ptp_ord_qty.
 *                      else
 *                         ord_qty = pt_ord_qty.
 *                      if ord_qty = 0 then ord_qty = 1.
 * /*G265*                 display ord_qty @ qty with frame b.    */
 *                   end.
 * /*G265*/             display
 * /*G265*/                pt_desc1 ord_qty @ qty pt_um
 *                   with frame b.
 *                end. /* if transtype = "BM" */
 * /*G265*/          else do:
 * /*G265*/             if ord_qty = 0 then do:
 * /*G265*/                if transtype = "FM" and bom_batch <> 0
 * /*G265*/                then ord_qty = bom_batch.
 * /*G265*/                else ord_qty = 1.
 * /*G265*/             end.
 * /*G265*/             display
 * /*G265*/                bom_desc @ pt_desc1
 * /*G265*/                ord_qty @ qty
 * /*G265*/                bom_batch_um @ pt_um.
 * /*G265*/          end.
 *J32L** END OF DELETED SECTION */

/*J32L*/ /*  BEGIN OF ADDED SECTION */

                  /* GET DESCRIPTION,UM,BATCH QTY */
          if ((transtype = "FM" )  or
              (transtype = "BM" and not is-item)) then do:
                     {gprun.i ""fmrodesc.p"" "(input parent_bom,
                                               output batchdesc1,
                                               output batchdesc2,
                                               output batchqty,
                                               output um,
                                               output aval)"}
                  end. /* IF transtype = FM */

          if is-item then do:
                     assign batchdesc1 = pt_desc1
                batchdesc2 = pt_desc2.

                     if transtype = "BM" then
            um = pt_um.
          end. /* IF is_item */

                  if ord_qty = 0 then do:
                     if transtype = "BM" then do:
                        if available pt_mstr then do:

                           for first ptp_det
                               fields (ptp_bom_code ptp_joint_type ptp_ord_qty
                                       ptp_part ptp_site) no-lock
                               where ptp_part = pt_part
                               and   ptp_site = site:
                           end. /* FOR FIRST ptp_det */

                           if available ptp_det then
                              ord_qty = ptp_ord_qty.
                           else
                              ord_qty = pt_ord_qty.

                        end. /* IF AVAILABLE pt_mstr */
                     end. /* IF TRANSTYPE = "BM" */
                     else do:
                        assign ord_qty = batchqty.
                     end. /* IF TRANSTYPE = "FM" */

                     if ord_qty = 0 then ord_qty = 1.

                  end. /* IF ord_qty = 0 THEN DO */
                  display batchdesc1 @ pt_desc1
                          ord_qty    @ qty
                          um         @ pt_um
				          with frame b.

/*J32L*/ /*  END OF ADDED SECTION */

/*G1H5*/          /* IF A BOM IS SPECIFIED FOR THE ITEM, THEN DISPLAY *
                   * THE BOM CODE USED.                               */
/*G1H5*/          if is-item and parent_bom <> item-code then do:
/*G1H5*/             down with frame b.

/*N0F3 /*G1H5*/      display {&bmpkrpa_p_5} + parent_bom @ pt_part */
/*N0F3*/             display " ":U + getTermLabel("BOM",5) + " = ":U + parent_bom @ pt_part
/*G1H5*/             with frame b.
/*G1H5*/          end.

/*G234*/          /* End of added section */
/*G234*           if qty = 0 then display pt_ord_qty @ qty with frame b. */
/* ss lambert 2010-1-26 Begin */
                  myprice = 0 .
                  for each sc_mstr no-lock where (sc_category = "1" or sc_category = "5") and sc_sim = fromset :
                  	for each spt_det no-lock where spt_site = site and spt_sim = sc_sim 
                  	                           and spt_part = pt_part and spt_element = sc_element:
                  	  myprice = myprice + spt_cst_tl + spt_cst_ll.
										end.
                  end.
                  
                 	disp myprice @ pt_mstr.pt_price with frame b.
                 	disp ord_qty * myprice @ ar_amt with frame b.
/* ss lambert 2010-1-26 End */

/*G1H5* /*G265*/  if available pt_mstr then do:*/
/*G1H5*/          if is-item then do:

/*J32L**             if pt_desc2 > "" then down 1 with frame b. */
/*J32L**             if pt_desc2 > "" then display pt_desc2 @ pt_desc1 */

/*J32L*/             if batchdesc2 > "" then down 1 with frame b.
/*J32L*/             if batchdesc2 > "" then display batchdesc2 @ pt_desc1
                     with frame b.
/*G265*/          end.
                  down 1 with frame b.

                  for each pkdet where eff_date = ? or (eff_date <> ?
                                  and (pkstart = ? or pkstart <= eff_date)
/*H100*                           and (pkend = ? or eff_date <= pkend))    */
/*H100*/                          and (pkend = ? or eff_date <= pkend)
/*G1H5*/                          and (pkop >= op and (pkop <= op1 or op1 = 0)))
/*G1H5* /*H100*/                  and (pkop >= op and pkop <= op1)) **/
                  break by pkpart
/*G1JF*/          by pkop
                  with frame b:

/*F0HQ*/             pkqty = pkqty * ord_qty / pkbombatch.
/*G1JF*              accumulate pkqty (total by pkpart). */
/*G1JF*/             accumulate pkqty (total by pkop).

/*G1JF*              if last-of(pkpart) then do: */
/*G1JF*/             if last-of(pkop) then do:
                        find ptmstr where ptmstr.pt_part = pkpart
                        no-lock no-error.

                        if page-size - line-counter < 2 then page.

/* ss lambert 2010-1-26 Begin */
/*SS 20080504 - B*/
/*
									find first spt_det where spt_site = site and spt_sim = "standard" and spt_part = pkpart
										and spt_element = "ÎïÁÏ" no-lock no-error.
*/
/*SS 20080504 - E*/
                  myprice = 0 .
                  for each sc_mstr no-lock where (sc_category = "1"  or sc_category = "5" )and sc_sim = fromset:
                  	for each spt_det no-lock where spt_site = site and spt_sim = sc_sim 
                  	                           and spt_part = pt_part and spt_element = sc_element:
                  	  myprice = myprice + spt_cst_tl + spt_cst_ll.
										end.
                  end.
/* ss lambert 2010-1-26 End */

                        display
                           "   " + pkpart @ pt_mstr.pt_part
                           ptmstr.pt_desc1
                              when (available ptmstr) @ pt_mstr.pt_desc1
                           ptmstr.pt_um
                              when (available ptmstr) @ pt_mstr.pt_um
/*F0HQ*                    (accum total by pkpart pkqty) */
/*F0HQ* /*G234*/           ord_qty */
/*G1JF* /*F0HQ*/           (accum total by pkpart pkqty) */
/*G1JF*/ /*F0HQ*/          (accum total by pkop pkqty)
/*G234*                    if qty <> 0 then qty else pt_mstr.pt_ord_qty */
                           @ qty
/* ss lambert 2010-1-26 Begin */
													myprice @ pt_mstr.pt_price 
/* ss lambert 2010-1-26 End */
/* ss lambert 2010-1-26 Begin */
													(accum total by pkop pkqty) * myprice @ ar_amt
/* ss lambert 2010-1-26 End */
                        with frame b.

/*SS 20080623 - B*/
/*
                        if available ptmstr and ptmstr.pt_desc2 > "" then do:
                           down 1 with frame b.
                           display
                              ptmstr.pt_desc2 @ pt_mstr.pt_desc1
                           with frame b.
                        end.

/*G234*                 for each ps_mstr no-lock where ps_par = part */
/*G234*/                for each ps_mstr no-lock where ps_par = parent_bom
                            and ps_comp = pkpart
                            and (ps_start = ? or ps_start <= eff_date)
                            and (ps_end = ? or ps_end >= eff_date)
/*G1H5*/                    and (ps_op >= op and (ps_op <= op1 or op1 = 0))
/*G1H5* /*H100*/            and (ps_op >= op and ps_op <= op1) */
                        and ps_rmks <> "":
                            down 1 with frame b.
                            display
                               ps_rmks @ pt_mstr.pt_desc1
                            with frame b.
/*G265*/                    {mfrpexit.i "false"}
                        end.
*/
/*SS 20080623 - E*/
/*FM31*/                down 1 with frame b.
                     end. /* if last-of(pkop) */

/*FM31*              down 1 with frame b. */
                     {mfrpexit.i "false"}

                  end. /*for each pkdet*/
                  down 1 with frame b.

               end.  /*if line = ""...*/

/*G1H5*/       /* FIND NEXT MATCHING RECORDS */

/*G1H5*/       /* CHECK TO SEE IF THE BOM AND ITEM CODES ARE THE SAME, BUT
                * THE ITEM USES A DIFFERENT BOM CODE.  IF SO, THEN EXPLODE
                * THE BOM CODE */
/*G1H5*/       if is-item then do:
/*G1H5*/          if pt_bom_code > "" and pt_part = bom-code then
/*G1H5*/             find first bom_mstr where bom_parent = bom-code
/*G1H5*/             no-lock no-error.
/*G1H5*/          else
/*G1H5*/             find first bom_mstr where bom_parent > item-code
/*G1H5*/                                   and bom_parent <= part1
/*G1H5*/             no-lock no-error.
/*G1H5*/          find first pt_mstr where pt_part > item-code
/*G1H5*/                               and pt_part <= part1
/*G1H5*/                               and pt_prod_line >= line
/*G1H5*/                               and pt_prod_line <= line1
/*G1H5*/          no-lock no-error.
/*G1H5*/       end.
/*G1H5*/       else do:
/*G1H5*/          find first bom_mstr where bom_parent > item-code and
/*G1H5*/                                    bom_parent <= part1
/*G1H5*/          no-lock no-error.
/*G1H5*/       end.
/*G1H5*/       if available bom_mstr then bom-code = bom_parent.

               {mfrpexit.i}

            end. /* itemloop: repeat: */

/*SS 20080623 - B*/
						{mfreset.i}
						{mfgrptrm.i}
/*
/*G1H5*/    {mfrtrail.i}
/*G1H5*     {mftrl080.i} */
*/
/*SS 20080623 - E*/

         end. /* repeat */

/*K10Y*/ {wbrp04.i &frame-spec = a}
