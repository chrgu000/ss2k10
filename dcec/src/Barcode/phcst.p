{mfdtitle.i }
/*DEFINE VAR cst AS CHAR FORMAT "x(8)"
    VIEW-AS  combo-box sort inner-lines 2
list-items "Standard","Current" INITIAL "Current"
label "Cost set" .*/
/*DEFINE VAR msite AS CHAR VIEW-AS EDITOR SIZE 8 BY 1 LABEL "Site".*/
/*DEFINE VAR msite1 AS CHAR VIEW-AS EDITOR SIZE 8 BY 1 LABEL "To".*/
    DEFINE VAR csset LIKE sct_sim.
    DEFINE VAR site LIKE pt_site.
DEFINE VAR part LIKE pt_part .
DEFINE VAR part1 LIKE pt_part .
DEFINE VAR isrecord AS LOGICAL. 
/*DEFINE BUTTON b-done LABEL "Update" SIZE 8 BY 1. */

    DEFINE VAR pre-cost like sct_cst_tot.
DEFINE FRAME pbody
   sct_det.sct_part
   label "Item Number"
 pre-cost
    label "Cost Before Updated"
    sct_det.sct_cst_tot
    label "Cost Updated"
     WITH WIDTH 80 NO-BOX DOWN USE-TEXT STREAM-IO.
    
FORM
    SKIP(1)
    csset COLON 24
    SKIP(1)
site COLON 24 
  
   SKIP(1)
  part colon 24
   part1 colon 53
    skip(1)
  
    WITH OVERLAY FRAME a WIDTH 80 THREE-D TITLE "Updated Phantom Item Cost" SIDE-LABEL.
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
    
        isrecord = NO.
        IF part1 = "" THEN part1 = hi_char.
        if c-application-mode <> 'web' then
   update csset site part part1 
   with frame a.    
    
   {wbrp06.i &command = update &fields = " csset site part part1" &frm = "a"}    
       
if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i csset         }
      {mfquoter.i site        }
      {mfquoter.i part     }
      {mfquoter.i part1     }
     

     
     
      IF part1 = ? then part1 = hi_char.

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

IF site = "" OR csset = "" THEN 
         MESSAGE "The Site or Cost set can't be empty,please re-enter!"  VIEW-AS ALERT-BOX  error BUTTONS OK.
        ELSE
        DO:
 for each pt_mstr WHERE pt_mstr.pt_phantom = yes and pt_mstr.pt_pm_code = "M" 
     and  pt_part >= part 
      
     and
         pt_part <= part1 exclusive-lock :
for each sct_det  where sct_sim = csset and sct_det.sct_part = pt_mstr.pt_part and sct_cst_tot <> 0
      and sct_site = site  AND (sct_mtl_ll <> 0 OR sct_ovh_ll <> 0 OR sct_sub_ll <> 0 OR sct_lbr_ll <> 0 OR sct_bdn_ll <> 0) exclusive-lock:

pre-cost = sct_cst_tot.
  sct_cst_tot = sct_mtl_tl + sct_ovh_tl + sct_sub_tl + sct_lbr_tl + sct_bdn_tl.
  ASSIGN sct_mtl_ll =0  sct_ovh_ll =0 sct_sub_ll=0 sct_lbr_ll =0 sct_bdn_ll=0.
  isrecord = YES.
  FOR EACH spt_det WHERE spt_det.spt_part = sct_det.sct_part AND spt_det.spt_sim = sct_det.sct_sim AND spt_det.spt_site = sct_det.sct_site AND spt_cst_ll <> 0:
      ASSIGN spt_cst_ll = 0.
  END.
   if page-size - line-counter < 2 then page.
  put skip.
display sct_det.sct_part
   label "Item Number"
  pre-cost
    label "Old CST"
    sct_det.sct_cst_tot
    label "Cst Updated"
WITH FRAME pbody.

end.
end.
{mfrtrail.i}
/*IF NOT isrecord THEN MESSAGE "No Item is updated!" VIEW-AS ALERT-BOX WARNING BUTTONS OK.*/

    end.
END.
{wbrp04.i &frame-spec = a}
/*WAIT-FOR GO OF FRAME a.
WAIT-FOR CHOOSE OF b-done.*/
/*WAIT-FOR WINDOW-CLOSE OF CURRENT-WINDOW.*/
