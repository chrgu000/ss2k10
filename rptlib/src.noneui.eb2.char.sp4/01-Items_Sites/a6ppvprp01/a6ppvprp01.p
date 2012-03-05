/* ppvprp.p - VENDOR ITEMS REPORT                                            */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*F0PN*/ /*K0VT*/ /*                                                         */
/*V8:ConvertMode=FullGUIReport                                               */
/* REVISION: 1.0      LAST MODIFIED: 01/20/86   BY: PML                      */
/* REVISION: 1.0      LAST MODIFIED: 08/29/86   BY: EMB *12*                 */
/* REVISION: 2.1      LAST MODIFIED: 10/16/87   BY: WUG *A94*                */
/* REVISION: 4.0      LAST MODIFIED: 12/04/87   BY: pml                      */
/* REVISION: 4.0      LAST MODIFIED: 02/16/88   BY: FLM *A175*               */
/* REVISION: 4.0      LAST MODIFIED: 06/08/88   BY: flm *A268*               */
/* REVISION: 4.0      LAST MODIFIED: 10/10/88   BY: flm *A478*               */
/* REVISION: 5.0      LAST MODIFIED: 02/03/89   BY: pml *C0028*              */
/* REVISION: 7.0      LAST MODIFIED: 08/10/92   BY: afs *F841*               */
/* REVISION: 7.0      LAST MODIFIED: 08/30/94   BY: rxm *GL58*               */
/* REVISION: 8.6      LAST MODIFIED: 09/05/97   BY: Joe Gawel    *K0HL*      */
/* REVISION: 8.6      LAST MODIFIED: 10/13/97   BY: mzv *K0VT*               */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: *L00M*  DS               */
/* REVISION: 8.6E     LAST MODIFIED: 06/24/98   BY: *L01G* R. McCarthy       */
/* REVISION: 8.6E     LAST MODIFIED: 06/25/98   BY: *L03V* Brenda Milton     */
/* REVISION: 8.6E     LAST MODIFIED: 12/01/98   BY: *L0CN* Steve Goeke       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 05/03/00 BY: *N09M* Peter Faherty       */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KQ* myb                 */
/* REVISION: 9.1      LAST MODIFIED: 04/05/06 BY: *SS - 20060405* Bill Jiang                 */

/* SS - 20060405 - B */
define INPUT PARAMETER i_part  like vp_part.
define INPUT PARAMETER i_part1 like vp_part.
define INPUT PARAMETER i_vend  like vp_vend.
define INPUT PARAMETER i_vend1 like vp_vend.
define INPUT PARAMETER i_et_report_curr  like exr_curr1.

/*
/* DISPLAY TITLE */
{mfdtitle.i "b+ "} /*L00M*/
*/
{a6mfdtitle.i "b+ "} /*L00M*/

{a6ppvprp01.i}
/* SS - 20060405 - E */

         /* ********** Begin Translatable Strings Definitions ********* */

         &SCOPED-DEFINE ppvprp_p_1 "Supplier Item! "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE ppvprp_p_2 "UM! "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE ppvprp_p_3 "Quote!Use Trans Price"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE ppvprp_p_4 "Quote Qty!Ext%"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE ppvprp_p_5 "Quote Price!List"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE ppvprp_p_6 "Cur! "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE ppvprp_p_7 "LT! "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE ppvprp_p_9 "Manufacturer Item! "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE ppvprp_p_10 "Mfg! "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE ppvprp_p_11 "!Supplier! "
         /* MaxLen: Comment: */

/*N09M* --------- COMMENTED PREPROCESSOR DEFINITIONS ------ *
 *
 *       &SCOPED-DEFINE ppvprp_p_8 "Item: "
 *       /* MaxLen: Comment: */
 *
 *N09M* --------------------------------------------------- */
         /* ********** End Translatable Strings Definitions ********* */

/*L03V*/ /* Definitions needed for Full GUI reports */
/*L03V*/ {gprunpdf.i "mcpl" "p"}

         define variable part  like vp_part.
         define variable part1 like vp_part.
         define variable vend  like vp_vend.
         define variable vend1 like vp_vend.
         define variable desc1 like pt_desc1 format "x(49)".

/*L03V*/ define variable base_rate1 like exr_rate no-undo.
/*L03V*/ define variable base_rate2 like exr_rate no-undo.
/*L03V*/ define variable data_rate  like exr_rate no-undo.
/*L03V*/ define variable rpt_rate   like exr_rate no-undo.

/*L00M*/ /* BEGIN ADD */
         {etvar.i &new = "new"}        /* Common euro variables */
         {etrpvar.i &new = "new"}      /* Common euro report variables*/
         {eteuro.i}                    /* Get common used euro information*/

         define variable et_pt_price like pt_price no-undo.
/*L00M*/ /* END ADD */

/*L03V*/ define variable mc-seq2 like mc-seq no-undo.

         /* SELECT FORM */
         form
            part           colon 15
            part1          label {t001.i} colon 49 skip
            vend           colon 15
            vend1          label {t001.i} colon 49 skip
/*L00M*/    skip (1)
/*L03V*/    et_report_curr colon 30
/*L03V* /*L00M*/    et_report_txt    at 1  format "x(19)" no-label */
/*L03V* /*L00M*/    et_report_curr   no-label */
/*L03V* /*L00M*/    et_rate_txt      at 11 format "x(09)" no-label */
/*L03V* /*L00M*/    et_report_rate   no-label                      */
         with frame a side-labels width 80.

         /* SS - 20060405 - B */
         /*
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).
         */
         part = i_part.
         part1 = i_part1.
         vend = i_vend.
         vend1 = i_vend1.
         et_report_curr = i_et_report_curr.
         /* SS - 20060405 - E */

         /* SS - 20060405 - B */
         /*
         /* OUTPUT FORM */
         form
            space(4)
            vp_vend         column-label {&ppvprp_p_11}
            vp_vend_part    column-label {&ppvprp_p_1}
            vp_um           column-label {&ppvprp_p_2}
            vp_mfgr         column-label {&ppvprp_p_10}
            vp_mfgr_part    column-label {&ppvprp_p_9}
            vp_vend_lead    column-label {&ppvprp_p_7}
            vp_q_price      column-label {&ppvprp_p_5}
            vp_q_date       column-label {&ppvprp_p_3}
            vp_q_qty        column-label {&ppvprp_p_4}
            vp_cur          column-label {&ppvprp_p_6}
         with frame b down width 132.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).
         */
         /* SS - 20060405 - E */

         /* REPORT BLOCK */

         {wbrp01.i}
            /* SS - 20060405 - B */
            /*
         repeat:
            */
            /* SS - 20060405 - E */

            if part1 = hi_char then part1 = "".
            if vend1 = hi_char then vend1 = "".

/*L03V* /*L00M*/    display et_report_txt /* when et_tk_active */ */
/*L03V* /*L00M*/    et_rate_txt   /* when et_tk_active */ with frame a. */

            /* SS - 20060405 - B */
            /*
            if c-application-mode <> 'web' then
               update part part1 vend vend1
/*L00M*/          et_report_curr /* when (et_tk_active) */
/*L03V* /*L00M*/  et_report_rate /* when (et_tk_active) */ */
               with frame a.

            {wbrp06.i &command = update &fields = "part part1 vend vend1
/*L00M*/       et_report_curr /* when (et_tk_active) */
/*L03V* /*L00M*/ et_report_rate /* when (et_tk_active) */ */
             " &frm = "a"}
               */
               /* SS - 20060405 - E */

            if (c-application-mode <> 'web') or
               (c-application-mode = 'web' and
               (c-web-request begins 'data')) then do:

               bcdparm = "".
               {mfquoter.i part   }
               {mfquoter.i part1  }
               {mfquoter.i vend   }
               {mfquoter.i vend1  }
/*L03V*/       {mfquoter.i et_report_curr}

/*L01G* /*L00M*/  if et_tk_active then do:        */
/*L03V* /*L00M*/     {mfquoter.i et_report_curr } */
/*L03V* /*L00M*/     {mfquoter.i et_report_rate } */
/*L01G* /*L00M*/  end.                            */

/*L03V*/    end.  /* if (c-application-mode <> 'web') ... */

               /* SS - 20060405 - B */
               /*
/*L03V*/    if et_report_curr <> "" then do:
/*L03V*/       {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
                  "(input  et_report_curr,
                    output mc-error-number)"}

               /* Check to see if there is a valid exchange rate */
               /* between the reporting and base currencies      */
/*L03V*/       if mc-error-number = 0 and
/*L03V*/          et_report_curr <> base_curr then do:
/*L03V*/          {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                     "(input  base_curr,
                       input  et_report_curr,
                       input  "" "",
                       input  et_eff_date,
                       output base_rate1,
                       output rpt_rate,
                       output mc-error-number)"}

/*L03V*/       end.  /* if mc-error-number = 0 and not base_curr */

/*L03V*/       if mc-error-number <> 0 then do:
/*L03V*/          {mfmsg.i mc-error-number 3}
/*L03V*/          if c-application-mode = 'web' then return.
/*L03V*/          else next-prompt et_report_curr with frame a.
/*L03V*/          undo, retry.
/*L03V*/       end.  /* if mc-error-number <> 0 */
/*L03V*/    end.  /* if et_report_curr <> "" */
/*L03V*/    if et_report_curr = "" or et_report_curr = base_curr then
/*L03V*/       assign
/*L03V*/          et_report_curr = base_curr
/*L03V*/          rpt_rate       = 1
/*L03V*/          base_rate1     = 1.
*/
/* SS - 20060405 - E */

/* SS - 20060405 - B */
/*
            /* SELECT PRINTER  */
            {mfselbpr.i "printer" 132}
            {mfphead.i}
               */
               /* SS - 20060405 - E */

            if part1 = "" then part1 = hi_char.
            if vend1 = "" then vend1 = hi_char.

/*L03V*     end.   */

/*L00M*/    /* BEGIN ADD */
/*L03V*     {etcurval.i &curr     = "et_report_curr"  */
/*L03V*                 &errlevel = "4"               */
/*L03V*                 &action   = "next"            */
/*L03V*                 &prompt   = "pause"}          */
/*L03V*     assign  et_eff_date = TODAY.              */
/*L00M*/    /* END ADD */

            for each vp_mstr where
               (vp_part >= part and vp_part <= part1) and
               (vp_vend >= vend and vp_vend <= vend1)
               no-lock 
               /* SS - 20060405 - B */
               /*
               break by vp_part 
               with frame b width 132
               no-box
               */
               /* SS - 20060405 - E */
               :

               /* SS - 20060405 - B */
               /*
/*L03V* /*L00M*/ {gprun.i ""etrate.p"" "(vp_curr)"}  */
/*L03V* /*L00M*/ {etrpconv.i vp_q_price et_pt_price} */

/*L03V*/       /* Check to see if there is a direct exchange */
/*L03V*/       /* between the reporting and data currencies  */
/*L03V*/       {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                  "(input  vp_curr,
                    input  et_report_curr,
                    input  "" "",
                    input  et_eff_date,
                    output et_rate1,
                    output et_rate2,
                    output mc-error-number)"}

/*L03V*/       /* Get the exchange rate between the data and  */
/*L03V*/       /* base currencies if no direct rate exists    */
/*L03V*/       if mc-error-number <> 0 then do:
/*L03V*/          if et_report_curr <> vp_curr then do:
/*L03V*/             {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                        "(input  vp_curr,
                          input  base_curr,
                          input  "" "",
                          input  et_eff_date,
                          output data_rate,
                          output base_rate2,
                          output mc-error-number)"}

/*L03V*/             /* Derive the exchange rate between the  */
/*L03V*/             /* reporting and data currencies through */
/*L03V*/             /* the base currency                     */
/*L03V*/             if mc-error-number = 0 then
/*L0CN*/                do:
/*L0CN*/                {gprunp.i "mcpl" "p" "mc-combine-ex-rates"
                           "(input  data_rate,
                             input  rpt_rate,
                             input  base_rate1,
                             input  base_rate2,
                             output et_rate1,
                             output et_rate2)" }
/*L0CN*/             end.  /* if mc-error-number */

/*L0CN* /*L03V*/        assign
 *L0CN* /*L03V*/           et_rate1 = data_rate * base_rate1
 *L0CN* /*L03V*/           et_rate2 = rpt_rate * base_rate2.
 *L0CN*/
                     /* If a rate cannot be derived then */
                     /* do not convert amounts in report */
/*L03V*/             else do:
/*L03V*/                {mfmsg.i mc-error-number 2}
/*L03V*/                assign
/*L03V*/                   et_rate1 = 1
/*L03V*/                   et_rate2 = 1.
/*L03V*/             end.
/*L03V*/          end.  /* if et_report_curr <> vp_curr */
/*L03V*/       end.  /* if mc-error-number <> 0 */

               /* Convert the quote price */
/*L03V*/       {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input  vp_curr,
                    input  et_report_curr,
                    input  et_rate1,
                    input  et_rate2,
                    input  vp_q_price,
                    input  true,    /* ROUND */
                    output et_pt_price,
                    output mc-error-number)"}
/*L03V*/       if mc-error-number <> 0 then do:
/*L03V*/          {mfmsg.i mc-error-number 2}
/*L03V*/       end.
                  */
                  /* SS - 20060405 - E */

               /* SS - 20060405 - B */
               /*
               desc1 = "".
               find pt_mstr where pt_part = vp_part no-lock no-error.
               if available pt_mstr then desc1 = pt_desc1 + " " + pt_desc2.
               if first-of (vp_part) then do:
                  if page-size - line-counter < 6 then page.
                  display
                     with frame b.
/*N09M*           put skip {&ppvprp_p_8} vp_part space(1) desc1. */
/*N09M*/          put skip getTermLabel("ITEM",8) + ": "
              format "x(10)" vp_part space(1) desc1.
               end.

               display
                  vp_vend
                  vp_vend_part
                  vp_um
                  vp_mfgr
                  vp_mfgr_part
                  vp_vend_lead
/*L00M*           vp_q_price      */
/*L03V* /*L00M*/  et_pt_price @ vp_q_price */
                  vp_q_date
                  vp_q_qty
/*L00M            vp_cur   */
/*L03V* /*L00M*/  et_disp_curr /* when (et_tk_active) */ */
               with frame b.
               */
               CREATE tta6ppvprp01.
               ASSIGN
                  tta6ppvprp01_vend = vp_vend
                  tta6ppvprp01_vend_part = vp_vend_part
                  tta6ppvprp01_um = vp_um
                  tta6ppvprp01_mfgr = vp_mfgr
                  tta6ppvprp01_mfgr_part = vp_mfgr_part
                  tta6ppvprp01_vend_lead = vp_vend_lead
                  tta6ppvprp01_q_date = vp_q_date
                  tta6ppvprp01_q_qty = vp_q_qty
                  tta6ppvprp01_q_price = vp_q_price
                  tta6ppvprp01_curr = vp_curr
                  tta6ppvprp01_pr_list = vp_pr_list
                  tta6ppvprp01_tp_use_pct = vp_tp_use_pct
                  tta6ppvprp01_tp_pct = vp_tp_pct
                  .

               /*
               find pt_mstr where pt_part = vp_part no-lock no-error.
               IF AVAILABLE pt_mstr WHERE pt_part = vp_part THEN DO:
                  ASSIGN
                     tta6ppvprp01_desc1 = pt_desc1
                     tta6ppvprp01_desc2 = pt_desc2
                     .
               END.
               */
               /* SS - 20060405 - E */

               /* SS - 20060405 - B */
               /*
/*L03V*/       if et_report_curr <> vp_curr then
/*L03V*/          display
/*L03V*/             et_pt_price @ vp_q_price
/*L03V*/             et_report_curr @ vp_cur
/*L03V*/          with frame b.
/*L03V*/       else
/*L03V*/          display
/*L03V*/             vp_q_price
/*L03V*/             vp_cur
/*L03V*/          with frame b.

               down 1 with frame b.
               display
                  vp_pr_list    @ vp_q_price
                  vp_tp_use_pct @ vp_q_date
                  vp_tp_pct     @ vp_q_qty
               with frame b.

               down 1 with frame b.
               */
               /* SS - 20060405 - E */
               {mfrpexit.i}
            end.  /* for each vp_mstr */

               /* SS - 20060405 - B */
               /*
            /* Report trailer  */
            {mfrtrail.i}

         end.  /* repeat */
            */
            /* SS - 20060405 - E */

         {wbrp04.i &frame-spec = a}
