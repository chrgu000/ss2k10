/* ictrrp03.p - Transfer location history REPORT                                 */
/* ss - 121011.1 by: Steven */ 

/*-Revision end---------------------------------------------------------------*/

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "1+ "}

/* ********** Begin Translatable Strings Definitions ********* */

define variable trdate     like tr_date        no-undo.
define variable trdate1    like tr_date        no-undo.
define variable glref      like trgl_gl_ref    no-undo.
define variable glref1     like trgl_gl_ref    no-undo.
define variable efdate     like tr_effdate     no-undo.
define variable efdate1    like tr_date        no-undo.
define variable part       like pt_part        no-undo.
define variable part1      like pt_part        no-undo.
define variable site       like si_site        no-undo.
define variable site1      like si_site        no-undo.
define variable tsfnbr     like tr_nbr         no-undo.
define variable tsfnbr1    like tr_nbr         no-undo.
define buffer trhist for tr_hist.

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
   tsfnbr         colon 20
   tsfnbr1        label {t001.i} colon 49 skip
   site           colon 20
   site1          label {t001.i} colon 49 skip
   
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
   if tsfnbr1   = hi_char then
      tsfnbr1   = "".
   if site1    = hi_char then
      site1    = "".
   
   if c-application-mode <> 'web' then
   update         
      part part1  
      efdate efdate1        
      tsfnbr tsfnbr1
      site site1        
   with frame a.


   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:
     
      {mfquoter.i part           }
      {mfquoter.i part1          }
      {mfquoter.i efdate         }
      {mfquoter.i efdate1        }      
      {mfquoter.i tsfnbr         }
      {mfquoter.i tsfnbr1        }
      {mfquoter.i site           }
      {mfquoter.i site1          }      
      
      if efdate = ? then
         efdate = low_date.
      if efdate1 = ? then
         efdate1 = hi_date.      
      if part1  = "" then
         part1  = hi_char.
      if tsfnbr1  = "" then
         tsfnbr1  = hi_char.
      if site1  = "" then
         site1  = hi_char.         

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
   
   for each tr_hist      
      where  tr_domain = global_domain and tr_type = "iss-tr" 
      and tr_part >= part and tr_part <= part1
      and (tr_effdate >= efdate and tr_effdate <= efdate1 or  tr_effdate  = ?)
      and (tr_nbr >= tsfnbr and tr_nbr <= tsfnbr1 )  no-lock
      by tr_domain by tr_effdate by tr_trnbr 
      with frame a1 down width 132 :
      
      find first trhist where trhist.tr_domain = tr_hist.tr_domain 
          and trhist.tr_trnbr =  tr_hist.tr_trnbr + 1
          and trhist.tr_trnbr > tr_hist.tr_trnbr
          and trhist.tr_type = 'rct-tr' and trhist.tr_part = tr_hist.tr_part
          and trhist.tr_effdate = tr_hist.tr_effdate 
          and abs(trhist.tr_qty_loc) = abs(tr_hist.tr_qty_loc) no-lock no-error.
      if avail trhist then do:     
         disp tr_hist.tr_part 
              tr_hist.tr_effdate
              tr_hist.tr_site label "From Site"
              trim(tr_hist.tr_loc)    label "From-Loc"
              trhist.tr_site label "To-Site"              
              trim(trhist.tr_loc)     label "To-Loc"
              abs(tr_hist.tr_qty_loc) label "Qty"
              tr_hist.tr_lot label "From-Lot"
              trhist.tr_lot  label "To-Lot"            
              tr_hist.tr_nbr label "Transfer Nbr"
              tr_hist.tr_userid          
         with frame a1 .
         down  with frame a1.  
      end.
      
      /* /*GUI*/ {mfguichk.i } /*Replace mfrpchk*/ */
      /*GUI*/ {mfrpchk.i } /*Replace mfrpchk*/

      
   end. /* FOR EACH tr_hist */
   
   /* REPORT TRAILER */

   {mfrtrail.i}


