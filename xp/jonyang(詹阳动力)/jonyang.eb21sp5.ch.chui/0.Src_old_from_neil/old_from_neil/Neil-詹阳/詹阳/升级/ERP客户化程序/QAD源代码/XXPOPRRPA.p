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

&SCOPED-DEFINE wowsrp_p_1 "子零件"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


          define variable part  like wod_part .
         define variable part1 like wod_part.
         define variable buyer like pt_buyer .
         define variable buyer1 like pt_buyer. 
         define variable nbr like req_nbr. 
         define variable nbr1 like req_nbr. 
         define variable rel_date like req_rel_date.
         define variable rel_date1 like req_rel_date.
         define variable due_date like req_need.
         define variable due_date1 like req_need.


         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
           
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
           part     colon 15 part1     label {t001.i} colon 49 skip
           buyer     colon 15 buyer1     label {t001.i} colon 49 skip
           nbr     colon 15 nbr1     label {t001.i} colon 49 skip
           rel_date     colon 15 rel_date1     label {t001.i} colon 49 skip
          due_date     colon 15 due_date1     label {t001.i} colon 49 skip
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

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



/*J196*/ FORM /*GUI*/  req_NBR req_part pt_desc1 pt_desc2 req_um pt_buyer pt_vend ad_name req_qty req_pur_cost tr_price req_rel_date req_need
/*J196*/ with STREAM-IO /*GUI*/  down frame b width 210 no-attr-space.


/*K0YQ*/ {wbrp01.i}
        
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


            if part1 = hi_char then part1 = "".
            if nbr1 = hi_char then nbr1 = "".
            if BUYER1 = hi_char then BUYER1 = "".
            if rel_date = low_date then rel_date = ?.
            if rel_date1 = hi_date then rel_date1 = ?.
            if due_date = low_date then due_date = ?.
            if due_date1 = hi_date then due_date1 = ?.


/*K0YQ*/ if c-application-mode <> 'web':u then
        
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


/*K0YQ*/ {wbrp06.i &command = update &fields = "   part part1  buyer buyer1 nbr nbr1 rel_date rel_date1 due_date due_date1" &frm = "a"}

/*K0YQ*/ if (c-application-mode <> 'web':u) or
/*K0YQ*/ (c-application-mode = 'web':u and
/*K0YQ*/ (c-web-request begins 'data':u)) then do:


/*A175      CREATE BATCH INPUT STRING */
/*A175*/    bcdparm = "".
/*A175*/    {mfquoter.i part   }
/*A175*/    {mfquoter.i part1  }
            {mfquoter.i nbr   }
            {mfquoter.i nbr1  }
            {mfquoter.i buyer  }            
            {mfquoter.i buyer1  }
            {mfquoter.i rel_date  }            
            {mfquoter.i rel_date1  }
            {mfquoter.i due_date  }            
            {mfquoter.i due_date1  }

            if part1 = "" then part1 = hi_char.
            if nbr1 = "" then nbr1 = hi_char.
            if BUYER1 = "" then BUYER1 = hi_char.
            if  rel_date = ? then rel_date = low_date.
            if  rel_date1 = ? then rel_date1 = hi_date.
            if  due_date = ? then due_date = low_date.
            if   due_date1 = ? then due_date1 = hi_date.
/*K0YQ*/ end.

            /* SELECT PRINTER  */
/*A175*/    
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:

define buffer wod_det1 for wod_det.


            {mfphead.i}

           
           
            /* FIND AND DISPLAY */
        for each req_det where (req_part >= part and req_part <= part1) 
            and (req_nbr >= nbr and req_nbr <= nbr1)
            and (req_rel_date >= rel_date and req_rel_date <= rel_date1)
            and (req_need >= due_date and req_need <= due_date1),
            each pt_mstr where pt_part = req_part and
            (pt_buyer >= buyer and pt_buyer <= buyer1)  
            no-lock by req_nbr by req_part
            with frame b width 200:
     find ad_mstr where ad_addr = pt_vend no-lock no-error.
     find last TR_HIST where TR_part = req_part AND TR_TYPE = "RCT-PO" no-lock no-error .
         if page-size - line-counter < 2
            then page.
          
               display 
               req_NBR 
               req_part 
               pt_desc1
               pt_desc2
               req_um
               pt_buyer
               pt_vend
               ad_name when available ad_mstr
               req_qty
               req_pur_cost
               TR_PRICE label "末次收货采购单价" when available TR_HIST
               req_rel_date
               req_need 
               with frame b STREAM-IO /*GUI*/ .
/*J196*/       down 1.

               
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/
            end.   /* END FOR EACH WOD_DET...   */


            /* REPORT TRAILER  */
            
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


         end.  /* END REPEAT LOOP   */

/*K0YQ*/ {wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds="  part part1  buyer buyer1 nbr nbr1 rel_date rel_date1 due_date due_date1"} /*Drive the Report*/
