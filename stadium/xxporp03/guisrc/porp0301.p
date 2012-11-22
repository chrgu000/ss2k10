/* GUI CONVERTED from porp0301.p (converter v1.75) Sun Aug 13 13:42:17 2000 */
/* porp0301.p - PURCHASE ORDER PRINT MAIN SUBROUTINE                    */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 5.0     LAST MODIFIED: 03/28/90    BY: MLB *B615**/
/* REVISION: 6.0     LAST MODIFIED: 05/24/90    BY: WUG *D002**/
/* REVISION: 6.0     LAST MODIFIED: 06/14/90    BY: RAM *D030**/
/* REVISION: 6.0     LAST MODIFIED: 07/05/90    BY: WUG *D043**/
/* REVISION: 6.0     LAST MODIFIED: 08/17/90    BY: SVG *D058**/
/* REVISION: 6.0     LAST MODIFIED: 01/03/91    BY: MLB *D238**/
/* REVISION: 6.0     LAST MODIFIED: 01/18/91    BY: RAM *D306**/
/* REVISION: 6.0     LAST MODIFIED: 08/14/91    BY: RAM *D828**/
/* REVISION: 6.0     LAST MODIFIED: 11/05/91    BY: RAM *D913**/
/* REVISION: 7.3     LAST MODIFIED: 02/22/93    by: jms *G712**/
/* REVISION: 7.3     LAST MODIFIED: 04/09/93    BY: afs *G926**/
/* REVISION: 7.4     LAST MODIFIED: 07/20/93    BY: bcm *H033**/
/* REVISION: 7.4     LAST MODIFIED: 01/28/94    BY: dpm *FL36**/
/* REVISION: 7.4     LAST MODIFIED: 04/11/94    BY: bcm *H334**/
/* REVISION: 7.4     LAST MODIFIED: 06/17/94    BY: bcm *H382**/
/* REVISION: 7.4     LAST MODIFIED: 07/25/94    BY: dpm *FP50**/
/* REVISION: 7.4     LAST MODIFIED: 09/20/94    BY: jpm *GM74**/
/* REVISION: 7.4     LAST MODIFIED: 10/11/95    BY: jym *G0Z4**/
/* REVISION: 8.5     LAST MODIFIED: 10/03/95    BY: taf *J053**/
/* REVISION: 8.5     LAST MODIFIED: 02/14/96    BY: rxm *H0JJ**/
/* REVISION: 8.5     LAST MODIFIED: 07/18/96    BY: taf *J0ZS**/
/* REVISION: 8.6     LAST MODIFIED: 10/22/96    BY: *K004* Nadine Catry */
/* REVISION: 8.6     LAST MODIFIED: 11/21/96    BY: *K022* Tejas Modi   */
/* REVISION: 8.6     LAST MODIFIED: 04/02/97    BY: *K073* Kieu Nguyen  */
/* REVISION: 8.6     LAST MODIFIED: 04/08/97    BY: *J1MJ* Ajit Deodhar */
/* REVISION: 8.6     LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E    LAST MODIFIED: 06/16/98    BY: *L020* Charles Yen  */
/* REVISION: 9.1     LAST MODIFIED: 07/28/99    BY: *N01B* John Corda   */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00    BY: *N0KQ* myb              */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

         {mfdeclre.i}
         {gplabel.i} /* EXTERNAL LABEL INCLUDE */

/*N01B*/ /* PARAMETER TO FACILITATE DISPLAY OF "SIMULATION" */
/*N01B*/ /* TEXT IN REPORT HEADER                           */

/*N01B*/ define input parameter update_yn like mfc_logical no-undo.

/*L020*/ define variable mc-error-number like msg_nbr no-undo.

         define new shared variable convertmode as character no-undo.
         define new shared variable rndmthd like rnd_rnd_mthd.
         define new shared frame c.
         define new shared frame phead1.
         define new shared frame phead1-can.
         define new shared frame d.
         define shared variable ord_date like po_ord_date.
         define shared variable ord_date1 like po_ord_date.
         define shared variable nbr like po_nbr.
         define shared variable nbr1 like po_nbr.
         define shared variable vend like po_vend.
         define shared variable vend1 like po_vend.
         define shared variable buyer like po_buyer.
         define shared variable buyer1 like po_buyer.
         define shared variable msg as character format "X(60)".
         define shared variable print_bill like mfc_logical.
         define shared variable lang like so_lang.
         define shared variable lang1 like lang.
         define shared variable open_only like mfc_logical.
         define shared variable sort_by_site like poc_sort_by.
         define new shared variable po_recno as recid.
         define shared variable new_only like mfc_logical.
         define new shared variable pages as integer.
         define variable old_po_nbr like po_nbr.
         define variable location like pt_loc.
         define variable i as integer.
         define new shared variable billto as character
            format "x(38)" extent 6.
         define new shared variable vendor as character
            format "x(38)" extent 6.
         define new shared variable shipto as character
            format "x(38)" extent 6.
         define new shared variable poship like po_ship.
         define new shared variable duplicate as character
            format "x(11)" label "".
         define new shared variable vend_phone like ad_phone.
         define new shared variable terms like ct_desc.
         define new shared variable addr as character format "x(38)" extent 6.
         define variable dup-lbl as character format "x(10)".
         define variable prepaid-lbl as character format "x(17)".
         define variable signature-lbl as character format "x(34)".
         define variable by-lbl as character format "x(3)".
         define variable ext_cost like pod_pur_cost
            format "(z,zzz,zzz,zz9.99)".
         define variable desc1 like pod_desc.
         define variable desc2 like pt_desc2.
         define variable qty_open like pod_qty_ord format "->>>>>>9.9<<<<<<".
         define variable det_lines as integer.
         define variable tax_flag as character format "x(1)".
         define variable mfgr like vp_mfgr.
         define variable mfgr_part like vp_mfgr_part.
         define variable y-lbl as character format "x(1)".
         define variable n-lbl as character format "x(1)".
         define variable rev-lbl as character format "x(10)".
         define variable vpart-lbl as character format "x(15)".
         define variable manuf-lbl as character format "x(14)".
         define variable part-lbl as character format "x(6)".
         define variable site-lbl as character format "x(6)".
         define variable disc-lbl as character format "x(5)".
         define variable discdesc as character format "x(14)".
         define variable type-lbl as character format "x(6)".
         define variable typedesc as character format "x(11)".
         define variable cont-lbl as character format "x(12)".
         define variable vd-attn-lbl as character format "x(16)".
         define new shared variable vdattnlbl like vd-attn-lbl.
         define new shared variable vdattn like ad_attn.
         define variable nullstring as character initial "" format "x(1)".
         define variable new_po like mfc_logical initial no.
         define variable lot-lbl as character format "X(43)".
         define new shared variable maint     like mfc_logical.
         define shared variable include_sched like mfc_logical.
         /* MOVED EDI_PO TO POTRLDEF.I */
         define variable oldcurr like po_curr no-undo.
         define variable oldsession as character no-undo.
         define variable tmp_amt as decimal no-undo.
         define variable ext_cost_fmt as character no-undo.
         define variable ext_cost_old as character no-undo.
         define variable prepaiddesc as character format "x(40)" no-undo.
         define variable signatureline as character format "x(30)" no-undo.
         define variable disp_trail as logical no-undo.
         define shared variable incl_b2b_po like mfc_logical.
         define shared variable print_options like mfc_logical.

         signatureline = fill("_",30).

         FORM /*GUI*/ 
           prepaiddesc
           /*V8+*/
                 skip   
           by-lbl to 47
           signatureline to 78
           signature-lbl to 78
         with STREAM-IO /*GUI*/  frame potrail1 no-labels no-box width 80.

         FORM /*GUI*/ 
           prepaiddesc
           /*V8+*/
           by-lbl to 47
           signatureline to 78
           signature-lbl to 78
         with STREAM-IO /*GUI*/  frame potrail2 no-labels no-box width 80.

         /* DEFINE VARIABLES FOR CURRENCY DEPENDENT FORMATS */
         {pocurvar.i "NEW"}
         {txcurvar.i "NEW"}
         /* DEFINE SHARED PO TRAILER VARIABLES */
         {potrldef.i "new"}

         /* POTOTFRM.I IS NOW INCLUDED BY POTRLDEF.I */

         {po03d01.i}   /* DEFINE FRAME C*/

         /* DEFINE TRAILER VARS AS NEW, SO THAT CORRECT _OLD FORMATS */
         assign
                 nontax_old         = nontaxable_amt:format
                 taxable_old        = taxable_amt:format
                 lines_tot_old      = lines_total:format
                 tax_tot_old        = tax_total:format
                 order_amt_old      = order_amt:format
                 line_tax_old       = line_tax:format
                 line_tot_old       = line_total:format
                 tax_old            = tax_2:format
                 tax_amt_old        = tax_amt:format
                 ord_amt_old        = ord_amt:format
                 vtord_amt_old      = vtord_amt:format
                 line_pst_old       = line_pst:format
                 frt_old            = po_frt:format
                 spec_chg_old       = po_spec_chg:format
                 serv_chg_old       = po_serv_chg:format
                 ext_cost_old       = ext_cost:format.
         prepaid_old        = "->,>>>,>>>,>>9.99".
         oldcurr = "".

         /* SET LABEL VARIABLES */
         {po03b01.i}

         /* DEFINE VARIABLES FOR DISPLAY OF VAT REG NO & COUNTRY CODE */
         {gpvtepdf.i &var="new shared"}

         convertmode = "REPORT".

         disp_trail = true.

         find first gl_ctrl no-lock.

         pages = 0.
         old_po_nbr = ?.

         oldsession = SESSION:numeric-format.

         for each po_mstr where (po_nbr >= nbr) and (po_nbr <= nbr1)
         and (po_vend >= vend) and (po_vend <= vend1)
         and (po_buyer >= buyer and po_buyer <= buyer1)
         and (po_print or not new_only)
         and (po_ord_date >= ord_date) and (po_ord_date <= ord_date1)
         and (po_lang >= lang and po_lang <= lang1)
         and (po_stat = "" or not open_only)
         and (not po_sched or include_sched)
         and (not po_is_btb or incl_b2b_po)
         and po_type <> "B"      no-lock by po_nbr:

            if old_po_nbr <> ? then
               pages = page-number.

            old_po_nbr = po_nbr.

            if po_is_btb then do:
               find vd_mstr where vd_addr = po_vend no-lock no-error.
               if available vd_mstr and not vd_rcv_held_so and po_so_hold
                 then next.
            end.

            if (oldcurr <> po_curr) or (oldcurr = "") then do:
/*L020*        {gpcurmth.i */
/*L020*             "po_curr" */
/*L020*             "4" */
/*L020*             "next" */
/*L020*             "pause" } */
/*L020*/       if po_curr = gl_base_curr then
/*L020*/          rndmthd = gl_rnd_mthd.
/*L020*/       else do:
/*L020*/          /* GET ROUNDING METHOD FROM CURRENCY MASTER */
/*L020*/          {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                   "(input po_curr,
                     output rndmthd,
                     output mc-error-number)"}
/*L020*/          if mc-error-number <> 0 then do:
/*L020*/             {mfmsg.i mc-error-number 4}
/*L020*/             if c-application-mode <> "WEB":U then
/*L020*/                pause.
/*L020*/             next.
/*L020*/          end.
/*L020*/       end.

               /* DETERMINE CURRENCY DISPLAY AMERICAN OR EUROPEAN            */
               find rnd_mstr where rnd_rnd_mthd = rndmthd no-lock no-error.
               if not available rnd_mstr then do:
                  {mfmsg.i 863 4}    /* ROUND METHOD RECORD NOT FOUND */
                  next.
               end.
               /* IF RND_DEC_PT = COMMA FOR DECIMAL POINT */
               /* THIS IS A EUROPEAN STYLE CURRENCY */
               if (rnd_dec_pt = "," )
               then SESSION:numeric-format = "European".
               else SESSION:numeric-format = "American".

               /* SET THE CURRENCY DEPENDENT FORMAT FOR EXT_COST */
               ext_cost_fmt = ext_cost_old.
               {gprun.i ""gpcurfmt.p"" "(input-output ext_cost_fmt,
                                         input rndmthd)"}
               ext_cost:format = ext_cost_fmt.
               {pocurfmt.i}
               oldcurr = po_curr.
            end.

            terms = "".
            find ct_mstr where ct_code = po_cr_terms no-lock no-error.
            if available ct_mstr then terms = ct_desc.

            duplicate = "".
            if po_print = no then duplicate = dup-lbl.

            find ad_mstr where ad_addr = po_bill no-lock no-wait no-error.

            update billto = "".
            if available ad_mstr and print_bill then do:
               addr[1] = ad_name.
               addr[2] = ad_line1.
               addr[3] = ad_line2.
               addr[4] = ad_line3.
               addr[6] = ad_country.
               {mfcsz.i addr[5] ad_city ad_state ad_zip}
               {gprun.i ""gpaddr.p"" }

               billto[1] = addr[1].
               billto[2] = addr[2].
               billto[3] = addr[3].
               billto[4] = addr[4].
               billto[5] = addr[5].
               billto[6] = addr[6].
            end.

            vendor = "".
            vdattnlbl = "".
            vdattn = "".
            find ad_mstr where ad_addr = po_vend no-lock no-wait no-error.
            if available ad_mstr then do:
               addr[1] = ad_name.
               addr[2] = ad_line1.
               addr[3] = ad_line2.

               addr[4] = ad_line3.
               addr[6] = ad_country.
               vend_phone = ad_phone.
               {mfcsz.i   addr[5] ad_city ad_state ad_zip}
               {gprun.i ""gpaddr.p"" }
               vendor[1] = addr[1].
               vendor[2] = addr[2].
               vendor[3] = addr[3].
               vendor[4] = addr[4].
               vendor[5] = addr[5].
               vendor[6] = addr[6].
               if ad_attn <> "" then do:
                  vdattnlbl = vd-attn-lbl.
                  vdattn = ad_attn.
               end.
            end.

            if gl_can then do:
               {ct03a01.i}
            end.
            else do:
               {po03a01.i}
            end.

            po_recno = recid(po_mstr).
            /* Print Order Detail */

            if sort_by_site then do:
/*N01B**       {gprun.i ""porp3a01.p""} */
/*N01B*/       {gprun.i ""porp3a01.p"" "(input update_yn)"}
            end.
            else do:
/*N01B**       {gprun.i ""porp3b01.p""} */
/*N01B*/       {gprun.i ""porp3b01.p"" "(input update_yn)"}
            end.

            /* TRAILER */
            if {txnew.i} then do:
                maint = no.
                undo_trl2 = true.
                {gprun.i ""pomttrl2.p""}
                if undo_trl2 then undo, leave.
            end.
            else do: /* OLD TAXES */
               if gl_can then do:
                  if page-size - line-counter < 10 then page.
                  do while page-size - line-counter > 10:
                     put skip(1).
                  end.
               end.
               else do:
                  if page-size - line-counter < 8 then page.
                  do while page-size - line-counter > 8:
                     put skip(1).
                  end.
               end.
               put msg skip.
               put "-----------------------------------------"
                 + "-----------------------------------------" format "x(80)".

               if gl_vat then display with frame povttrl no-box STREAM-IO /*GUI*/ .
               else if gl_can then display with frame pocttrl  no-box STREAM-IO /*GUI*/ .
               else
               display with frame potrail column 3 no-box STREAM-IO /*GUI*/ .
               if gl_vat then do:
                  {povttrl.i}
                  {po03e01.i}
               end.
               else
               if not gl_can then /*U.S.*/
               do:
                  {mfpotrl.i}
               end.
               else if gl_can then do:
                  {pocttrla.i}
               end.
            end. /* OLD TAXES */

         /* ADDED THE ASSIGN PREPAID DISPLAY FIELD            */
            if po_prepaid <> 0 then
              do:
                 assign prepaiddesc = prepaid-lbl + " "
                            + string(po_prepaid, prepaid_fmt).
              end.
            else prepaiddesc = "".

            if not gl_can then
              display
                prepaiddesc
                by-lbl
                signatureline
                signature-lbl
                with frame potrail1 STREAM-IO /*GUI*/ .
            else
              display
                prepaiddesc
                by-lbl
                signatureline
                signature-lbl
                  with frame potrail2 STREAM-IO /*GUI*/ .

            {gprun.i ""poporp3a.p""}

         end.
         /* SET SESSION PARAMETER BACK BEFORE ENDING */
         SESSION:numeric-format = oldsession.
