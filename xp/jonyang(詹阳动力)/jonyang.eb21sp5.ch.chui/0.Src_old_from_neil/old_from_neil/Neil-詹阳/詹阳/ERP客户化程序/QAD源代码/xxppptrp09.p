/* GUI CONVERTED from wowsrp.p (converter v1.71) Tue Oct  6 14:59:18 1998 */
/* wowsrp.p - WORK ORDER COMPONENT SHORTAGE BY ORDER REPORT             */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert wowsrp.p (converter v1.00) Fri Oct 10 13:57:25 1997 */
/* web tag in wowsrp.p (converter v1.00) Mon Oct 06 14:17:53 1997 */
/*F0PN*/ /*K0YQ*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 4.0    LAST MODIFIED: 04/26/89    BY: emb *A722**/
/* REVISION: 6.0    LAST MODIFIED: 04/16/91    BY: RAM *D530**/
/* REVISION: 8.5    LAST MODIFIED: 11/21/96    BY: *J196*  Russ Witt       */
/* REVISION: 8.6    LAST MODIFIED: 10/14/97    BY: ays *K0YQ* */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan      */
         /* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

         {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE wowsrp_p_1 "×ÓÁã¼þ"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


         define variable part   like pt_part.
         define variable part1  like pt_part.
         define variable buyer like pt_buyer.
         define variable buyer1 like pt_buyer.
         define variable added like pt_added.
         define variable added1 like pt_added.
         define variable pm like pt_pm_code.

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM /*GUI*/ 
           part      colon 15 part1      label {t001.i} colon 49 skip
           buyer      colon 15 buyer1      label {t001.i} colon 49 skip
           added      colon 15 added1     label {t001.i} colon 49 skip
            pm colon 15  skip
with frame a side-labels width 80 attr-space.

setFrameLabels(frame a:handle).

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/*J196*/ FORM /*GUI*/ pt_part pt_desc1 pt_desc2 pt_um pt_buyer pt_prod_line pt_part_type pt_loc pt_pm_code pt_ord_mult 
        pt_ord_per pt_pur_lead pt_mfg_lead pt_ord_pol pt_yield_pct pt_ord_min pt_vend ad_name pt_added
/*J196*/         
/*J196*/ with STREAM-IO /*GUI*/  down frame b width 300 no-attr-space.


/*K0YQ*/ {wbrp01.i}

repeat:

            if part1  = hi_char then  part1 = "".
            if BUYER1 = hi_char then BUYER1 = "".
            if added = low_date then added = ?.


			 update part part1 buyer buyer1 added added1 pm with frame a.

/*K0YQ*/ if (c-application-mode <> 'web':u) or
/*K0YQ*/ (c-application-mode = 'web':u and
/*K0YQ*/ (c-web-request begins 'data':u)) then do:


/*A175      CREATE BATCH INPUT STRING */
/*A175*/    bcdparm = "".
/*A175*/    {mfquoter.i part    }
/*A175*/    {mfquoter.i part1   }
/*A175*/    {mfquoter.i buyer   }
/*A175*/    {mfquoter.i buyer1  }
            {mfquoter.i added  }            
            {mfquoter.i added1  }


            if part1  = "" then part1  = hi_char.
            if BUYER1 = "" then BUYER1 = hi_char.
            if  added = ? then added = low_date.

/*K0YQ*/ end.

            /* SELECT PRINTER  */
/*A175*/    

					{mfselbpr.i "printer" 132}


define buffer wod_det1 for wod_det.


            {mfphead.i}

       
          
            /* FIND AND DISPLAY */
        for each pt_mstr where 
			 pt_domain = global_domain and /*---Add by davild 20090205.1*/
             (pt_added >= added and pt_added <= added1) 
            and (pt_buyer >= buyer and pt_buyer <= buyer1)
            and (pt_part >= part and pt_buyer <= part1)
            and (( pt_pm_code = pm and pm <> "" ) or pm = "")
           no-lock break by pt_part by pt_added
            with frame b width 310:

						setframelabels(frame b:handle).
            if pt_vend <> "" then find ad_mstr where 
					ad_domain = global_domain and /*---Add by davild 20090205.1*/
					ad_addr = pt_vend no-lock no-error.
               display
               pt_part  
               pt_desc1 
               pt_desc2 
               pt_um 
               pt_buyer 
               pt_prod_line 
               pt_part_type
               pt_loc 
               pt_pm_code 
               pt_ord_mult 
               pt_ord_per 
               pt_pur_lead 
               pt_mfg_lead 
               pt_ord_pol 
               pt_yield_pct 
               pt_ord_min 
               pt_vend 
               ad_name when pt_vend <> ""
               pt_added

               with frame b STREAM-IO /*GUI*/ .
/*J196*/       down 1.

               
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/
                
            end.   /* END FOR EACH pt_mstr...   */


            /* REPORT TRAILER  */
            
 {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .


         end.  /* END REPEAT LOOP   */

/*K0YQ*/ {wbrp04.i &frame-spec = a}
