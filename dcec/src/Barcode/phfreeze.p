{mfdtitle.i }
/*DEFINE VAR cst AS CHAR FORMAT "x(8)"
    VIEW-AS  combo-box sort inner-lines 2
list-items "Standard","Current" INITIAL "Current"
label "Cost set" .*/
/*DEFINE VAR msite AS CHAR VIEW-AS EDITOR SIZE 8 BY 1 LABEL "Site".*/
/*DEFINE VAR msite1 AS CHAR VIEW-AS EDITOR SIZE 8 BY 1 LABEL "To".*/
    DEFINE  VAR site LIKE si_site. 
DEFINE  VAR csset LIKE sct_sim.
   
DEFINE VAR frz_flag like mfc_logical initial NO
                         label  "Freeze/Unfreeze"
                        format "Freeze/Unfreeze" .
/*define  variable part     like pt_part      no-undo.
define  variable part1    like pt_part      no-undo.  */
 
 /*define variable pmcode   like pt_pm_code  INITIAL "P" no-undo.*/
DEFINE VAR pre-p_m AS CHAR FORMAT "x(1)" LABEL "Pre P/M" .
     DEFINE  VAR pre-freeze AS LOGICAL  LABEL "Pre Freeze" format "Freeze/Unfreeze".
 DEFINE VAR pmcode AS CHAR FORMAT "x(1)" LABEL "P/M Updated".
     /*DEFINE VAR part LIKE pt_part .
DEFINE VAR part1 LIKE pt_part .*/

/*DEFINE BUTTON b-done LABEL "Update" SIZE 8 BY 1. */

DEFINE FRAME b
   pt_part
   label "Item Number"
  pre-p_m
  
   
    pmcode
  
pre-freeze
   
    frz_flag
    LABEL " Freeze updated"
     WITH WIDTH 180  STREAM-IO.
    
FORM
    SKIP(1)
    site COLON 24 
   
     SKIP(1)
 csset COLON 24    
  
    skip(1)
  
frz_flag COLON 24
    WITH  FRAME a WIDTH 80 THREE-D TITLE " Phantom Item Cost Freeze/unfreeze" SIDE-LABEL.
/*ON VALUE-CHANGED OF cst  
     DO:     
     cst =SELF:SCREEN-VALUE.    
       END.*/
/*DISPLAY cst b-done WITH  FRAME a.
ENABLE ALL WITH FRAME a.*/
/*APPLY "VALUE-CHANGED" TO cst IN FRAME a.
WAIT-FOR GO OF FRAME a.*/
setFrameLabels(frame a:handle).

site = global_site.
{wbrp01.i}

/*ON 'choose':U OF b-done
DO:*/
    mainloop:
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
         
         find si_mstr where si_site = site no-lock no-error.
         if not available si_mstr then do:
            {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3} /* Site does not exist */
            next-prompt site with frame a.
            undo, retry.
         end.
      if si_db <> global_db then do:
            /* Site is not assigned to this database */
            {pxmsg.i &MSGNUM=5421 &ERRORLEVEL=3}
            next-prompt site with frame a.
            undo, retry.
         end.
         {gprun.i ""gpsiver.p""
            "(input site, input recid(si_mstr), output return_int)"}
         if return_int = 0 then do:

            /* USER DOES NOT HAVE ACCESS TO THIS SITE */
            {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
            next-prompt site with frame a.
            undo mainloop, retry mainloop.
         end.
        
      end.

      seta2:
      do transaction on error undo, retry:
          SET csset with frame a editing:
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
     
         
      end.
status input.
      update
         
          frz_flag
      with frame a.
    

      
       


      bcdparm = "".
      {mfquoter.i csset         }
      {mfquoter.i site        }
      

           {mfquoter.i frz_flag      }

        
     
     
    

   

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
/*FIND si_mstr WHERE si_site = site NO-LOCK.
   FIND cs_mstr WHERE cs_set = csset NO-LOCK.
   IF NOT AVAILABLE si_mstr OR NOT AVAILABLE cs_mstr THEN
       MESSAGE "The invalid site or cost set,please re-enter!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 
       ELSE DO:*/
      
       {mfphead.i} 
 for each pt_mstr WHERE pt_mstr.pt_phantom = yes and IF frz_flag THEN  pt_mstr.pt_pm_code = "P" ELSE  pt_mstr.pt_pm_code = "M" 
     EXCLUSIVE-LOCK  with frame b down width 180:
     
   pre-p_m = pt_pm_code.
 IF frz_flag THEN  pt_pm_code ="M". 
     ELSE 
         pt_pm_code = "P" .
FIND ptp_det WHERE ptp_part = pt_part  exclusive-lock no-error.

         if available sct_det then DO:
          IF frz_flag THEN  pt_pm_code ="M". 
     ELSE 
         pt_pm_code = "P" .
             
             END.
 pmcode = pt_pm_code.
   find sct_det
            where sct_part = pt_part
              and sct_site = site
              and sct_sim = csset
         exclusive-lock no-error.

         if available sct_det then do:
           /* if audit_yn then do:
               if sct_rollup <> frz_flag then
                  threeast = "***".
               else
                  threeast = "".
               display
                  pt_part
                  pt_desc1
                  sct_cst_date
                  sct_rollup
                  frz_flag
                  threeast
               with frame b STREAM-IO /*GUI*/ .
               down with frame b.
            end.*/ /* PRINT THE REPORT */
            pre-freeze = sct_rollup.
            sct_rollup = frz_flag.
         end.
 
 
   if page-size - line-counter < 2 then page.
 /* put skip.*/
display  pt_part
   label "Item Number"
  pre-p_m
  
   
    pmcode
  
pre-freeze
   
    frz_flag
    LABEL " Freeze updated".

end.
       /*END.*/
assign
      global_type = ""
      global_site = site.

   /* REPORT TRAILER  */
  
      {mftrl080.i}
  
/*IF NOT isrecord THEN MESSAGE "No Item is updated!" VIEW-AS ALERT-BOX WARNING BUTTONS OK.*/

    
END.
{wbrp04.i &frame-spec = a}
/*WAIT-FOR GO OF FRAME a.
WAIT-FOR CHOOSE OF b-done.*/
/*WAIT-FOR WINDOW-CLOSE OF CURRENT-WINDOW.*/
