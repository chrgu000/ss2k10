{mfdtitle.i }
/*DEFINE VAR cst AS CHAR FORMAT "x(8)"
    VIEW-AS  combo-box sort inner-lines 2
list-items "Standard","Current" INITIAL "Current"
label "Cost set" .*/
/*DEFINE VAR msite AS CHAR VIEW-AS EDITOR SIZE 8 BY 1 LABEL "Site".*/
/*DEFINE VAR msite1 AS CHAR VIEW-AS EDITOR SIZE 8 BY 1 LABEL "To".*/
    DEFINE NEW SHARE VAR csset LIKE sct_sim.
    DEFINE NEW SHARE VAR site LIKE si_site.
define NEW SHARE variable frz_flag like mfc_logical initial NO
                         label  "Freeze/Unfreeze"
                        format "Freeze/Unfreeze" no-undo.
define NEW SHARE variable part     like pt_part      no-undo.
define NEW SHARE variable part1    like pt_part      no-undo.  
 
define variable pmcode   like pt_pm_code  INITIAL "P" no-undo.
DEFINE VAR pre-p_m LIKE pt_pm_code .
     DEFINE NEW SHARE VAR pre-freeze LIKE sct_rollup.
 
     /*DEFINE VAR part LIKE pt_part .
DEFINE VAR part1 LIKE pt_part .*/

/*DEFINE BUTTON b-done LABEL "Update" SIZE 8 BY 1. */

   
DEFINE FRAME pbody
   pt_part
   label "Item Number"
  pre-p_m
  
    label "pre_P/M"
    pt_pm_code
    label "P/M_Updated"
pre-freeze
    LABEL "Pre_Freeze"
    frz_flag
    LABEL " Freeze_updated"
     WITH WIDTH 80 NO-BOX DOWN USE-TEXT STREAM-IO.
    
FORM
    SKIP(1)
    csset COLON 24
    SKIP(1)
site COLON 24 
  
   SKIP(1)
  pmcode  COLON 24
 
    skip(1)
  frz_flag COLON 24
    WITH OVERLAY FRAME a WIDTH 80 THREE-D TITLE " Phantom Item Cost Freeze/unfreeze-P/M" SIDE-LABEL.
/*ON VALUE-CHANGED OF cst  
     DO:     
     cst =SELF:SCREEN-VALUE.    
       END.*/
/*DISPLAY cst b-done WITH  FRAME a.
ENABLE ALL WITH FRAME a.*/
/*APPLY "VALUE-CHANGED" TO cst IN FRAME a.
WAIT-FOR GO OF FRAME a.*/
setFrameLabels(frame a:handle).

{wbrp01.i}

/*ON 'choose':U OF b-done
DO:*/
repeat:
          seta1:
      do transaction on error undo, retry:
         set site with frame a editing:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i si_mstr site si_site site si_site si_site}

            if recno <> ? then do:
               site = si_site.
               display site with frame a.
               recno = ?.
            end.
         end.
        if site = "" then do:
            {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3} /*Blank not allowed*/
            next-prompt site.
            undo, retry.
         end.
         find si_mstr where si_site = site no-lock no-error.
         if not available si_mstr then do:
            {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3} /* Site does not exist */
            next-prompt site with frame a.
            undo, retry.
         end.

         
      end.

      seta2:
      do transaction on error undo, retry:
         set csset with frame a editing:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i cs_mstr csset cs_set csset cs_set cs_set}
            if recno <> ? then do:
               csset = cs_set.
               display csset with frame a.
              
               recno = ?.
            end.
         end.

         if csset = "" then do:
            {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3} /*Blank not allowed*/
            next-prompt csset.
            undo, retry.
         end.

         find cs_mstr where cs_set = csset no-lock no-error.
         if not available cs_mstr then do:
            {pxmsg.i &MSGNUM=5407 &ERRORLEVEL=3} /*Cost set does not exist*/
            next-prompt csset.
            undo, retry.
         end.
      END.
       
        if c-application-mode <> 'web' then
   update csset site pmcode frz_flag 
   with frame a.    
    
   {wbrp06.i &command = update &fields = " csset site pmcode frz_flag" &frm = "a"}    
       
if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i csset         }
      {mfquoter.i site        }
      
 {mfquoter.i pmcode       }
           {mfquoter.i frz_flag      }

        
     
     
    

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
   {mfphead.i}  
 /* FORM HEADER
    "Updated Phantom Item Cost Report" AT 30
    SKIP(2)
    PAGE-NUMBER AT 10
    TODAY AT 40
    WITH PAGE-TOP FRAME phead WIDTH 80 NO-BOX SIDE-LABEL.
OUTPUT TO TERMINAL PAGE-SIZE 30 PAGED.
VIEW FRAME phead.*/


/*cst = cst:SCREEN-VALUE.
msite = msite:SCREEN-VALUE.
msite1 = msite1:SCREEN-VALUE.
mpt_part = mpt_part:SCREEN-VALUE.
mpt_part1 = mpt_part1:SCREEN-VALUE.*/

 for each pt_mstr WHERE pt_mstr.pt_phantom = yes and pt_mstr.pt_pm_code = "M" 
     exclusive-lock :
 pre-p_m = pt_pm_code.
     pt_pm_code = pm_code.
     
     

 
 part = pt_part.
 part1 = pt_part.
 {gprun.i ""frzmt.p""}
 
 
   if page-size - line-counter < 2 then page.
  put skip.
display  pt_part
   label "Item Number"
  pre-p_m
  
    label "pre_P/M"
    pt_pm_code
    label "P/M_Updated"
pre-freeze
    LABEL "Pre_Freeze"
    frz_flag
    LABEL " Freeze_updated"
WITH FRAME pbody.

end.

{mfrtrail.i}
/*IF NOT isrecord THEN MESSAGE "No Item is updated!" VIEW-AS ALERT-BOX WARNING BUTTONS OK.*/

    
END.
{wbrp04.i &frame-spec = a}
/*WAIT-FOR GO OF FRAME a.
WAIT-FOR CHOOSE OF b-done.*/
/*WAIT-FOR WINDOW-CLOSE OF CURRENT-WINDOW.*/
