/* GUI CONVERTED from sorp0501.p (converter v1.76) Tue May 27 23:52:10 2003 */
/* sorp0501.p  -  SALES ORDER PRINT                                           */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.35 $                                                          */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 5.0      LAST MODIFIED: 03/15/90   BY: MLB *B615**/
/* REVISION: 5.0      LAST MODIFIED: 03/30/90   BY: ftb *B642**/
/* REVISION: 5.0      LAST MODIFIED: 06/21/90   BY: MLB *B711**/
/* REVISION: 6.0      LAST MODIFIED: 07/05/90   BY: WUG *D043**/
/* REVISION: 6.0      LAST MODIFIED: 08/20/90   BY; MLB *B755**/
/* REVISION: 6.0      LAST MODIFIED: 12/13/90   BY: dld *D257**/
/* REVISION: 6.0      LAST MODIFIED: 12/27/90   BY: MLB *D238**/
/* REVISION: 6.0      LAST MODIFIED: 03/12/91   BY: afs *D425**/
/* REVISION: 6.0      LAST MODIFIED: 12/16/91   BY: MLV *D962**/
/* REVISION: 7.0      LAST MODIFIED: 04/02/92   BY: dld *F322**/
/* REVISION: 7.0      LAST MODIFIED: 04/09/92   BY: emb *F369**/
/* REVISION: 7.0      LAST MODIFIED: 04/10/92   BY: dld *F358**/
/* REVISION: 7.2      LAST MODIFIED: 11/13/92   BY: tjs *G191**/
/* REVISION: 7.3      LAST MODIFIED: 12/02/92   BY: WUG *G383**/
/* REVISION: 7.3      LAST MODIFIED: 02/19/93   by: jms *G712**/
/* REVISION: 7.4      LAST MODIFIED: 07/20/93   by: bcm *H032**/
/* REVISION: 7.2      LAST MODIFIED: 01/05/94   by: dpm *FL18**/
/* REVISION: 7.3      LAST MODIFIED: 06/22/94   BY: WUG *GK60**/
/* REVISION: 7.2      LAST MODIFIED: 02/25/95   BY: aep *F0KF**/
/* REVISION: 7.4      LAST MODIFIED: 03/27/95   BY: kjm *F0NZ**/
/* REVISION: 7.4      LAST MODIFIED: 04/27/95   BY: rxm *F0PD**/
/* REVISION: 8.5      LAST MODIFIED: 02/24/95   BY: NTE *J042**/
/* REVISION: 8.5      LAST MODIFIED: 10/05/95   BY: srk *J08B**/
/* REVISION: 8.5      LAST MODIFIED: 07/13/95   BY: taf *J053**/
/* REVISION: 8.5      LAST MODIFIED: 06/13/96   BY: DAH *J0T0**/
/* REVISION: 8.5      LAST MODIFIED: 07/19/96   BY: taf *J0ZZ**/
/* REVISION: 8.5      LAST MODIFIED: 09/16/96   BY: *G2FH* Aruna Patil        */
/* REVISION: 8.5      LAST MODIFIED: 08/25/97   BY: *J1YJ* Aruna Patil        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 04/23/98   BY: *L00L* EvdGevel           */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 07/05/98   BY: *L024* Sami Kureishy      */
/* REVISION: 8.6E     LAST MODIFIED: 08/18/98   BY: *L064* Russ Witt          */
/* REVISION: 9.0      LAST MODIFIED: 11/16/98   BY: *J34M* Manish K.          */
/* REVISION: 9.0      LAST MODIFIED: 02/01/99   BY: *L0D5* Robin McCarthy     */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 08/14/99   BY: *N01Q* Michael Amaladhas  */
/* REVISION: 9.1      LAST MODIFIED: 07/30/99   BY: *N01B* John Corda         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/23/00   BY: *N0ND* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/13/00   BY: *N0RW* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 11/07/00   BY: *L15K* Kaustubh K         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.27         BY: Katie Hilbert       DATE: 04/01/01  ECO: *P002* */
/* Revision: 1.28         BY: Ellen Borden        DATE: 07/09/01  ECO: *P007* */
/* Revision: 1.29         BY: Jean Miller         DATE: 12/05/01  ECO: *P039* */
/* Revision: 1.31         BY: Patrick Rowan       DATE: 03/15/01  ECO: *P00G* */
/* Revision: 1.34         BY: Jean Miller         DATE: 04/23/02  ECO: *P05M* */
/* $Revision: 1.35 $      BY: Kedar Deherkar      DATE: 05/27/03  ECO: *N2G0* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
 

/*GUI preprocessor directive settings */
 &SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */


/* PARAMETER TO FACILITATE DISPLAY OF "SIMULATION" */
/* TEXT IN REPORT HEADER                           */
define input parameter update_yn like mfc_logical no-undo.
define input parameter print_line_charges like mfc_logical no-undo.

define new shared variable rndmthd like rnd_rnd_mthd.
define new shared variable so_recno as recid.
define new shared variable disc_prnt_label as character format "x(8)".

define shared variable cust like so_cust.
define shared variable cust1 like so_cust.
define shared variable nbr like so_nbr.
define shared variable nbr1 like so_nbr.
define shared variable ord like so_ord_date.
define shared variable ord1 like so_ord_date.
define shared variable company as character format "X(38)" extent 6.
define shared variable print_options as logical initial no label
   "Print Features and Options".
define shared variable addr as character format "x(38)" extent 6.
define shared variable lang like so_lang.
define shared variable lang1 like so_lang.
define shared variable print_trlr like mfc_logical initial no
   label "Print Sales Order Trailer".

define variable qty_open like sod_qty_ord format "->>>>>>9.9<<<<<"
   label "Qty Open".
define variable ext_price like sod_price label "Ext Price"
   format "->>>,>>>,>>9.99".
define variable desc1 like pt_desc1.
define variable desc2 like pt_desc2.
define variable pages as integer.
define variable billto as character format "x(38)" extent 6.
define variable shipto as character format "x(38)" extent 6.
define variable ext_price_total like ext_price.
define variable termsdesc like ct_desc.
define variable billattn like ad_attn.
define variable shipattn like ad_attn.
define variable billphn like ad_phone.
define variable shipphn like ad_phone.
define variable first_line as logical.
define variable prepaid-lbl as character format "x(12)".
define variable total-lbl as character format "x(12)".
define variable resale like cm_resale format "x(20)".
define variable so_printso like mfc_logical.
define variable cont_lbl as character format "x(10)" no-undo.
define variable oldsession as character no-undo.
define variable ext_price_fmt as character no-undo.
define variable ext_price_old as character no-undo.
define variable prepaid_fmt as character no-undo.
define variable prepaid_old as character no-undo.
define variable oldcurr like so_curr no-undo.
define variable hdl_disc_lbl as handle.
define variable hdl_sum_disc_lbl as handle.
define variable pm_code like pt_pm_code.
define variable net_price like sod_price .
define variable ext_line_charge as decimal initial 0
                 format "->>>>>>>>>>9.99" no-undo.
define variable c-add-line-charges as character format "x(32)" no-undo.

/*judy 07/06/05*/  define variable saleattn like ad_attn.
/*judy 07/06/05*/ define variable salephn	 like ad_phone.
/*judy 07/06/05*/ define variable salephn2 like ad_phone2.
/*judy 07/06/05*/ define variable salefax	 like ad_fax.
/*judy 07/06/05*/ define variable saleqry	 like ad_fax2.		
/*judy 07/06/05*/  define    shared        variable comp_addr like soc_company.  
/*judy 07/06/05*/   define variable shipfax like ad_fax.	  
/*judy 07/06/05*/  define variable billfax like ad_fax. 
/*judy 07/06/05*/  DEFINE VARIABLE xxcucon AS CHAR .
/*judy 07/06/05*/  DEFINE VARIABLE xxdraf AS CHAR. 


/* CONSIGNMENT VARIABLES */
{socnvars.i}

define buffer ship for ad_mstr.
define buffer somstr for so_mstr.
define new shared frame c.

assign cont_lbl = dynamic-function('getTermLabelFillCentered' in h-label,
                                    input "CONTINUE", input 10, input '*').

/* Shared workfile for summary discounts */
{sodiscwk.i &new="new"}

{etvar.i}
{etrpvar.i &new="new"}
{etdcrvar.i "new"}
{etsotrla.i "NEW"}

/* VARIABLE DEFINITIONS FOR gpfile.i */
{gpfilev.i}

FORM /*GUI*/  with STREAM-IO /*GUI*/  frame ceuro width 132 down.

FORM /*GUI*/ 
   space(46)
   total-lbl
   space(4)
   ext_price_total
with STREAM-IO /*GUI*/  frame no_trailer down width 80 no-labels no-box.
		
 

/*judy 07/06/05*/ 
    FORM
    			"客户确认意见：" skip(2)
    			so_shipvia no-label skip
    			"火车零担/中铁到付/经济快件/汽运/自提" skip     /*DCEC*/
    			"汇款内容:"
    		with stream-io frame so_tr_add1 side-label width 80 no-box.
/*judy 07/06/05*/
/*judy 07/06/05*/     /* SET EXTERNAL LABELS */
/*judy 07/06/05*/     setFrameLabels(frame so_tr_add1:handle).


hdl_disc_lbl     = prnt_disc_amt:handle in frame disc_print.
hdl_sum_disc_lbl = prnt_sum_disc_amt:handle in frame disc_sum_print.

/* ASSIGN ORIGINAL FORMAT TO _OLD VARIABLES */
assign
   nontax_old = nontaxable_amt:format
   taxable_old = taxable_amt:format
   line_tot_old = line_total:format
   disc_old     = disc_amt:format
   trl_amt_old = so_trl1_amt:format
   tax_amt_old = tax_amt:format
   ord_amt_old = ord_amt:format
   container_old = container_charge_total:format
   line_charge_old = line_charge_total:format.

FORM /*GUI*/ 
   prepaid-lbl at 2
   so_prepaid
with STREAM-IO /*GUI*/  frame prepd width 80 no-labels.

oldsession = SESSION:numeric-format.
{so05f01.i}               /* INCLUDE FILE FOR FRAME C */
   
/* SET PREPAID OLD TO PREPAID:FORMAT AND EXT_PRICE:FORMAT */
assign
   prepaid_old = so_prepaid:format
   ext_price_old = ext_price:format.

/* DEFINE THE VARIABLES FOR DISPLAY OF VAT REG NO & COUNTRY CODE */
{gpvtecdf.i &var="shared"}
{gpvtepdf.i &var=" "}

/*DETERMINE IF CONTAINER AND LINE CHARGES ARE ENABLED*/
{cclc.i}

/* DETERMINE IF CUSTOMER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_CUSTOMER_CONSIGNMENT,
     input 10,
     input ADG,
     input CUST_CONSIGN_CTRL_TABLE,
     output using_cust_consignment)"}

assign
   c-add-line-charges = "*** " + getTermLabel("ADDITIONAL_LINE_CHARGES",24)
                        + " ***"
   container_charge_total = 0
   line_charge_total = 0
   ext_line_charge = 0
   pages = 0.

for each so_mstr where so_domain = global_domain and (so_nbr >= nbr)
   and (so_nbr <= nbr1)
   and (so_cust >= cust)
   and (so_cust <= cust1)
   and (so_print_so = yes)
   and (so_ord_date >= ord or ord = ?)
   and (so_ord_date <= ord1 or ord1 = ?)
   and (so_lang >= lang and so_lang <= lang1)
   and not so_sched
   and so_fsm_type = ""
no-lock by so_nbr with frame b no-box: 
 
 
   assign
      et_new_page = true
      so_recno = recid(so_mstr).

   /* DO LOOP ADDED TO SKIP LOCKED SO_MSTR RECORDS */
   do for somstr:

      find somstr where so_domain = global_domain and so_recno = recid(somstr)
      exclusive-lock no-wait no-error.

      if (available somstr and not locked somstr) then
         so_printso = yes.
      else
         so_printso = no.

   end.

   if so_printso = no then next.

   if (oldcurr <> so_curr) or (oldcurr = "") then do:
      /*** GET ROUNDING METHOD FROM CURRENCY MASTER **/
      {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
         "(input so_curr,
           output rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.

      /* DETERMINE CURRENCY DISPLAY AMERICAN OR EUROPEAN  */
      find rnd_mstr where rnd_domain = global_domain and 
      		 rnd_rnd_mthd = rndmthd no-lock no-error.
      if not available rnd_mstr then do:
         {pxmsg.i &MSGNUM=863 &ERRORLEVEL=4}
         /* ROUND METHOD RECORD NOT FOUND */
         next.
      end.

      /* IF RND_DEC_PT = COMMA FOR DECIMAL POINT */
      /* THIS IS THE EUROPEAN CURRENCY */
      if (rnd_dec_pt = ",") then
         SESSION:numeric-format = "European".
      else
         SESSION:numeric-format = "American".

      prepaid_fmt = prepaid_old.
      {gprun.i ""gpcurfmt.p""
         "(input-output prepaid_fmt,
           input rndmthd)"}

      /* SETUP THE FORMAT FOR DISPLAING EXT_PRICE_TOTAL - USE GPCURFMT.P */
      ext_price_fmt = ext_price_old.
      {gprun.i ""gpcurfmt.p"" "(input-output ext_price_fmt,
                                input rndmthd)"}

      {socurfmt.i} /* SET UP TRAILER FORMATS */

      assign oldcurr = so_curr.

   end. /* IF (OLDCURR <> SO_CURR) */

   first_line = yes.
   termsdesc = "".
   find ct_mstr where ct_domain = global_domain and 
   			ct_code = so_cr_terms no-lock no-error.
   if available ct_mstr then termsdesc = ct_desc.

   so_recno = recid(so_mstr).
 
   assign
      billto = ""
      shipto = "".

   find ad_mstr where ad_domain = global_domain and ad_addr = so_cust
   no-lock no-wait no-error.

   if available ad_mstr then do:
      assign
         addr[1] = ad_name
         addr[2] = ad_line1
         addr[3] = ad_line2
         addr[4] = ad_line3
         addr[6] = ad_country.
      {mfcsz.i addr[5] ad_city ad_state ad_zip}.
      {gprun.i ""gpaddr.p"" }
      assign
         billto[1] = addr[1]
         billto[2] = addr[2]
         billto[3] = addr[3]
         billto[4] = addr[4]
         billto[5] = addr[5]
         billto[6] = addr[6]
         billattn = ad_attn
         billphn = ad_phone.
/*judy 07/06/05*/        billfax = ad_fax.
   end.

   find ad_mstr where ad_domain = global_domain and ad_addr = so_ship
   no-lock no-wait no-error.

   if available ad_mstr then do:
      assign
         addr[1] = ad_name
         addr[2] = ad_line1
         addr[3] = ad_line2
         addr[4] = ad_line3
         addr[6] = ad_country.
      {mfcsz.i addr[5] ad_city ad_state ad_zip}.
      {gprun.i ""gpaddr.p"" }
      assign
         shipto[1] = addr[1]
         shipto[2] = addr[2]
         shipto[3] = addr[3]
         shipto[4] = addr[4]
         shipto[5] = addr[5]
         shipto[6] = addr[6]
         shipattn = ad_attn
         shipphn = ad_phone
/*judy 07/06/05*/      shipfax = ad_fax .
   end.

   
   /* GET VAT REG NO AND COUNTRY CODE FOR SHIP-TO */
   find ad_mstr where ad_domain = global_domain and 
   			ad_addr = so_ship no-lock no-wait no-error.
   if available ad_mstr then do:
      if ad_pst_id = "" then do:
         find ad_mstr where ad_domain = global_domain and ad_addr = so_bill
         no-lock no-wait no-error.
         if available ad_mstr then do:
            {gpvteprg.i}
         end.
      end.
      else do:
         {gpvteprg.i}
      end.
   end.

   /* GET SECOND CURRENCY FOR EURO DUAL CURRENCY PRINTING */
   /* CHANGED 2nd PARAMETER FROM so_cust TO so_bill */
   {etdcra.i so_curr so_bill}

   resale = "".
 
   find cm_mstr where cm_domain = global_domain and 
   		  cm_addr = so_cust no-lock no-error.
   if available cm_mstr then resale = cm_resale.

 
   /*judy 07/06/05*/  /*   {so05a01.i}
   /*judy 07/06/05*/      {so05c01.i}*/
   /*judy 07/06/05*/    {yyso05a01.i}
   /*judy 07/06/05*/      {yyso05c01.i} 
 

   hide frame phead1.
  view frame phead1.  

   pages = page-number - 1.

   hide frame phead2.

   do with frame phead2:
 
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame phead2:handle).
 
      display
          so_cust
         so_ship
         billto[1] shipto[1]
         billto[2] shipto[2]
         billto[3] shipto[3]
         billto[4] shipto[4]
         billto[5] shipto[5]
         billto[6] shipto[6]
      with frame phead2 STREAM-IO /*GUI*/ .
  end. /* do with */
 
 

   /* DISPLAY VAT REG NO & COUNTRY CODE */
   put
      covatreglbl to 15 space(1)
      covatreg
      vatreglbl   to 59 space(1)
      vatreg
      skip.

 /*judy 07/06/05*/     find first ad_mstr no-lock where ad_domain = global_domain and
 /*judy 07/06/05*/     ad_addr = so_slspsn[1] and ad_type = "SLSPRSN" no-error.
 /*judy 07/06/05*/     if available ad_mstr then
  /*judy 07/06/05*/        	assign
  /*judy 07/06/05*/				saleattn= ad_attn 
  /*judy 07/06/05*/  			salephn	= ad_phone
 /*judy 07/06/05*/   			salephn2= ad_phone2
  /*judy 07/06/05*/  			salefax	= ad_fax  
 /*judy 07/06/05*/   			saleqry	= ad_fax2.

   do:
 
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame phead3:handle).
      display
         billattn shipattn
         billphn shipphn
 /*judy 07/06/05*/           shipfax billfax
 /*judy 07/06/05*/ /*        so_slspsn[1]
/*judy 07/06/05*/         so_slspsn[2]
/*judy 07/06/05*/         so_slspsn[3]
/*judy 07/06/05*/         so_slspsn[4]*/
/*judy 07/06/05*/  	saleattn
/*judy 07/06/05*/    salephn	
/*judy 07/06/05*/  	salephn2
/*judy 07/06/05*/  	salefax	
/*judy 07/06/05*/  	saleqry	
         so_po
         so_cr_terms
         so_shipvia
         termsdesc
         so_fob
         resale
         so_rmks
      with frame phead3 STREAM-IO /*GUI*/ .
      hide frame phead3.
   end.
 
   if print_trlr then
      view frame continue.

   {gpcmtprt.i &type=SO &id=so_cmtindx &pos=3}

   put skip(1).

   /*Establish the label for the display of discounts*/
   if disc_det_key <> "1" then do:
      find first lngd_det where lngd_dataset begins "soprint"
         and lngd_field   = "det_disc_prnt"
         and lngd_lang    = global_user_lang
         and lngd_key1    = disc_det_key
      no-lock no-error.
      if available lngd_det then
         disc_prnt_label = lngd_translation.
   end.

   /* GET ORDER DETAIL*/
   assign
      et_ext_price_total = 0
      ext_price_total = 0.
     
   for each sod_det where sod_domain = global_domain 
   	    and sod_nbr = so_nbr and not sod_sched
   no-lock by sod_nbr by sod_line:
 
 
      assign
         desc1 = sod_desc
         desc2 = ""
         net_price = sod_price
         qty_open = sod_qty_ord - sod_qty_ship
         ext_price = qty_open * net_price.

  
      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output ext_price,
           input rndmthd,
           output mc-error-number)"}
  

      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.

      ext_price_total = ext_price_total + ext_price.

      /* SECOND CURRENCY EXTENDED PRICE CALCULATION */
      {etdcrg.i so_curr}

      desc1 = sod_desc.
      find pt_mstr where pt_domain = global_domain and pt_part = sod_part
      no-lock no-wait no-error.

      if available pt_mstr then do:

         if desc1 = "" then
         assign
            desc1 = pt_desc1
            desc2 = pt_desc2.
      end.
 
   
      first_line = no.

      if page-size - line-counter < 3 then page.
   
      ext_price:format = ext_price_fmt.
      {etdcrd.i so_curr 75 91} 
      {so05b01.i} /*Display Line*/
    


      if page-size - line-counter < 1 then do:
         page.
         {so05e01.i} 
    
      end.
      put desc1 at 5 skip.

      if desc2 > "" then do:
         if page-size - line-counter < 1 then do:
            page.
            {so05e01.i}
          end.
         put desc2 at 5 skip.
      end.
  

        if using_cust_consignment then do:
         consign_flag = no.
         {gprunmo.i
            &program = "socnsod1.p"
            &module = "ACN"
            &param = """(input so_nbr,
                         input sod_line,
                         output consign_flag,
                         output consign_loc,
                         output intrans_loc,
                         output max_aging_days,
                         output auto_replenish)"""}

         if consign_flag then do:
            if page-size - line-counter < 1 then do:
               page.
               {so05e01.i}
            end.
            put "Contract: Consignment Inventory" at 5 skip.
         end.
      end.  /* if using_cust_consignment */

      if using_line_charges and print_line_charges then do:

         line_charge_total = 0.

         for each sodlc_det where sodlc_domain = global_domain and
            sodlc_order = sod_nbr and sodlc_ord_line = sod_line
         no-lock break by sodlc_order:

            if sodlc_one_time and sodlc_times_charged > 0 then
               next.
            else do:
               ext_line_charge = sodlc_ext_price.

               /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
               {gprunp.i "mcpl" "p" "mc-curr-rnd"
                  "(input-output ext_line_charge,
                    input rndmthd,
                    output mc-error-number)"}
               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.

               assign
                  line_charge_total = line_charge_total + ext_line_charge
                  ext_price_total = ext_price_total + ext_line_charge
                  line_total = line_total + ext_line_charge.

               for first trl_mstr where trl_domain = global_domain and 
               					 trl_code = sodlc_trl_code
               no-lock: end.

               if available trl_mstr then do:
                  if trl_taxable then
                      taxable_amt = taxable_amt + ext_line_charge.
                  else
                      nontaxable_amt = nontaxable_amt + ext_line_charge.
               end. /*IF AVAILABLE TRL_MSTR*/

               if page-size - line-count < 1 then do:
                  page.
                  {so05e01.i}
               end.

               if first-of(sodlc_order) then do:
                  put c-add-line-charges at 19 skip.
               end. /* IF FIRST-OF(SODLC_ORDER)*/

               if last-of(sodlc_order) then do:
                  put trl_desc          at 15.
                  put ext_line_charge   at 47.
                  put line_charge_total at 65.
                  put skip(1).
               end. /* IF LAST-OF*/

               else do:
                  put trl_desc          at 15.
                  put ext_line_charge   at 47 skip.
               end. /*ELSE DO*/

            end. /*ELSE DO*/

         end. /* FOR EACH SODLC_DET*/

      end. /*IF USING_LINE_CHARGES*/

      /********************************************
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

      if print_options and
         can-find(first sob_det where sob_domain = global_domain 
                    and sob_nbr = so_nbr and sob_line = sod_line)
      then do:

         /*ADDED TILDE BEFORE CURLY BRACES SO FILE WOULD COMPILE*/
         /* Print discounts for parent item */
         {sopiprn1.i &doctype="1" &nbr=sod_nbr &line=sod_line
            &part=sod_part
            &parent="""" &feature="""" &opt=""""
            &qty=qty_open &list_price=sod_list_pr
            &net_price=sod_price
            &confg_disc="no"
            &command="~{so05e01.i~}"}

         find first sob_det where sob_domain = global_domain 
         				and sob_nbr = sod_nbr and sob_line = sod_line
         no-lock no-error.

         /* NEW STYLE sob_det CONTAIN A
            SYMBOLIC REFERENCE IDENTIFIED BY BYTES 11-14 IN sob_serial.
         */
  
         {gprun.i ""sorp5a01.p""
            "(input """", input 0,
              input sod_nbr, input sod_line)"}
      
      end.

      /*ADDED TILDE BEFORE CURLY BRACES SO FILE WOULD COMPILE*/
      /* Test for configured parent without components */
      if available pt_mstr then do:

         pm_code = pt_pm_code.

         find ptp_det where ptp_domain = global_domain and 
         			ptp_part = sod_part and ptp_site = sod_site
         no-lock no-error.
         if available ptp_det then
            pm_code = ptp_pm_code.
         if pm_code = "C" and
            not can-find(first sob_det where sob_domain = global_domain and 
                sob_nbr  = sod_nbr and sob_line = sod_line)
         then do:
            {sopiprn1.i &doctype="1" &nbr=sod_nbr &line=sod_line
               &part=sod_part
               &parent="""" &feature="""" &opt=""""
               &qty=qty_open &list_price=sod_list_pr
               &net_price=sod_price
               &confg_disc="no"
               &command="~{so05e01.i~}"}
         end.
      end.

      /* Print global discounts for item/configuration */
      {sopiprn1.i &doctype="1" &nbr=sod_nbr &line=sod_line
         &part=sod_part
         &parent="""" &feature="""" &opt=""""
         &qty=qty_open &list_price=sod_list_pr
         &net_price=sod_price
         &confg_disc="yes"
         &command="~{so05e01.i~}"}

      /*ADDED TILDE BEFORE CURLY BRACES SO FILE WOULD COMPILE*/
      {gpcmtprt.i &type=SO &id=sod_cmtindx &pos=5
         &command="~{so05e01.i~}"}

      
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
 
   end. /* for each sod_det */
 
   /*Establish the label for the display of discounts*/
   if disc_sum_key <> "1" and
      disc_sum_key <> disc_det_key
   then do:
      find first lngd_det where lngd_dataset begins "soprint"
         and lngd_field   = "det_disc_prnt"
         and lngd_lang    = global_user_lang
         and lngd_key1    = disc_sum_key
      no-lock no-error.
      if available lngd_det then
         disc_prnt_label = lngd_translation.
      else
         disc_prnt_label = "".
   end.

   /* Print discount summary, delete disc wkfl records */
   {sopiprn2.i}

   hide frame continue.
   if print_trlr then do:

      /*PRINT TRAILER*/
      {gprun.i ""sotr0501.p""}

      if so_prepaid <> 0
      then do with frame prepd:
         so_prepaid:format = prepaid_fmt.
         display prepaid-lbl so_prepaid with frame prepd STREAM-IO /*GUI*/ .
      end.
   end.

   else do:

      if not et_dc_print then do:
         if page-size - line-counter < 2 then page.
         underline ext_price_total with frame no_trailer.
         down 1 with frame no_trailer.
         display total-lbl ext_price_total
         with frame no_trailer STREAM-IO /*GUI*/ .
      end.
      else do:
         underline ext_price et_ext_price with frame ceuro no-box.
         down 1 with frame ceuro.
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame ceuro:handle).
         display
            total-lbl @ sod_price
            ext_price_total @ ext_price
            et_ext_price_total @ et_ext_price
         with frame ceuro no-box STREAM-IO /*GUI*/ .
      end.

   end.
 
   if et_dc_print then do:
      if page-size - line-counter < 3 then page.
      do while page-size - line-counter > 3:
         put skip(1).
      end.
      {etdcrh.i so_curr}
   end.
 
 /*judy 07/06/05*/     {yysorp05.i}		        
 /*judy 07/06/05*/    {gprun.i ""yysorp05t.p"" "(input comp_addr)"}

   {gprun.i ""sosorp5a.p""}
   page.

end.

SESSION:numeric-format = oldsession.
