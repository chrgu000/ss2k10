/* ictrrp03.p - Subcontract Transaction REPORT                                */
/* ss - 121012.1 by: Steven */ 

/*-Revision end---------------------------------------------------------------*/

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "1+ "}

/* ********** Begin Translatable Strings Definitions ********* */
define variable part       like pt_part        no-undo.
define variable part1      like pt_part        no-undo.
define variable efdate     like tr_effdate     no-undo.
define variable efdate1    like tr_effdate     no-undo.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/    
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
   part           colon 20
   part1          label {t001.i} colon 49 skip
   efdate         colon 20
   efdate1        label {t001.i} colon 49 skip   
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
 
setFrameLabels(frame a:handle).
 
{wbrp01.i}
    
   if efdate = low_date then
      efdate = ?.
   if efdate1 = hi_date then
      efdate1 = ?.   
   if part1   = hi_char then
      part1   = "".
   
   if c-application-mode <> 'web' then
   update         
      part part1  
      efdate efdate1     
   with frame a.


   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:
     
      {mfquoter.i part           }
      {mfquoter.i part1          }
      {mfquoter.i efdate         }
      {mfquoter.i efdate1        }      
           
      if efdate = ? then
         efdate = low_date.
      if efdate1 = ? then
         efdate1 = hi_date.      
      if part1  = "" then
         part1  = hi_char.
     
   end.
   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.

   {mfphead.i}

   FORM /*GUI*/  header
      skip(1)         
   with STREAM-IO /*GUI*/ frame a1 down width 132 .      
   
   for each tr_hist no-lock      
      where  tr_domain = global_domain and 
      (tr_type = 'rct-po' or tr_type = "iss-wo" or tr_type = 'rct-wo')
      and (tr_effdate >= efdate and tr_effdate <= efdate1 or  tr_effdate  = ?)
      break by tr_part by tr_effdate by tr_type 
      with frame a1 down width 132 :      
         find first pod_det where pod_domain = global_domain and pod_nbr = tr_nbr
         and pod_line = tr_line no-lock no-error. 
         disp tr_part 
              pod_wo_lot when avail pod_det
              tr_effdate
              tr_type tr_qty_loc tr_trnbr
              /*pod_wo_op  when avail pod_det*/
              tr_nbr label "Pur.Order"
              tr_lot label "Rec.Nbr"
         with frame a1 .
         down  with frame a1.  
         if last-of(tr_part) then do:
            for each op_hist where op_domain = global_domain
            and op_wo_lot = tr_lot no-lock :
                put op_wo_nbr space(1) op_wo_lot space(1) 
                    op_wo_op space(1) op_qty_comp space(1) 
                    op_qty_rjct space(1) op_qty_wip space(1)
                    op_sub_cost skip.
            end.    
         end.
      /* /*GUI*/ {mfguichk.i } /*Replace mfrpchk*/ */
      /*GUI*/ {mfrpchk.i } /*Replace mfrpchk*/

      
   end. /* FOR EACH tr_hist */
   
   /* REPORT TRAILER */

   {mfrtrail.i}


