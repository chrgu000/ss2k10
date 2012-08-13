/*{mfdtitle.i "2+"}*/
DEFINE VAR cst AS CHAR FORMAT "x(8)"
    VIEW-AS  combo-box sort inner-lines 2
list-items "Standard","Current" INITIAL "Current"
label "Cost set" .
DEFINE VAR msite LIKE pt_site.
DEFINE VAR msite1 AS CHAR VIEW-AS EDITOR SIZE 8 BY 1 LABEL "To".
DEFINE VAR mpt_part AS CHAR VIEW-AS EDITOR SIZE 8 BY 1 LABEL "Item Number".
DEFINE VAR mpt_part1 AS CHAR VIEW-AS EDITOR SIZE 8 BY 1 LABEL "To".
DEFINE BUTTON b-done LABEL "Update" SIZE 8 BY 1. 

    DEFINE VAR pre-cost like sct_cst_tot.
DEFINE FRAME pbody
   sct_det.sct_part
   label "Item Number"
  pre-p_m
  
    label "pre_P/M"
    pt_pm_code
    label "P/M_Updated"
pre_freeze
    LABEL "Pre_Freeze"
    sct_roll_up
    LABEL " Freeze_updated"
     WITH WIDTH 80 NO-BOX DOWN USE-TEXT STREAM-IO.
    
FORM
    SKIP(1)
    cst COLON 27
    SKIP(1)
   msite COLON 27
   /*SKIP(1)
   mpt_part colon 27
   mpt_part1 colon 47*/
    skip(1)
    b-done COLON 65 LABEL "Update"
    WITH FRAME a WIDTH 80 THREE-D TITLE "Updated Phantom Item Cost" SIDE-LABEL.
/*ON VALUE-CHANGED OF cst  
     DO:     
     cst =SELF:SCREEN-VALUE.    
       END.*/
/*setFrameLabels(frame a:handle).*/
/*{wbrp01.i}*/
DISPLAY cst b-done WITH  FRAME a.
ENABLE ALL WITH FRAME a.
/*APPLY "VALUE-CHANGED" TO cst IN FRAME a.
WAIT-FOR GO OF FRAME a.*/
/*{wbrp04.i &frame-spec = a}*/

                
ON 'choose':U OF b-done
DO:

  
  FORM HEADER
    " Phantom Item Status unfreeze(M->P)" AT 30
    SKIP(2)
    PAGE-NUMBER AT 10
    TODAY AT 40
    WITH PAGE-TOP FRAME phead WIDTH 80 NO-BOX SIDE-LABEL.
OUTPUT TO TERMINAL PAGE-SIZE 30 PAGED.
VIEW FRAME phead.
/*MESSAGE cst.*/

cst = cst:SCREEN-VALUE.
msite = msite:SCREEN-VALUE.
/*mpt_part = mpt_part:SCREEN-VALUE.
mpt_part1 = mpt_part1:SCREEN-VALUE.*/
FIND si_mstr WHERE si_site = msite NO-LOCK.
IF NOT AVAILABLE si_mstr THEN
 

    MESSAGE "The Site can't be empty or invalid site,please re-enter!"  VIEW-AS ALERT-BOX  error BUTTONS OK.
.
ELSE DO:
END.
 for each pt_mstr WHERE pt_mstr.pt_phantom = yes and pt_mstr.pt_pm_code = "M" 
      exclusive-lock :
   pre-p_m = pt_pm_code.
     pt_pm_code = "P".
     for each sct_det  where sct_sim = cst and sct_det.sct_part = pt_mstr.pt_part and sct_cst_tot <> 0
      and sct_site = msite  AND sct_roll_up = YES exclusive-lock:
   pre_freeze = sct_roll_up.
         sct_roll_up = NO.
/*pre-cost = sct_cst_tot.
  sct_cst_tot = sct_mtl_tl + sct_ovh_tl + sct_sub_tl + sct_lbr_tl + sct_bdn_tl.
  ASSIGN sct_mtl_ll =0  sct_ovh_ll =0 sct_sub_ll=0 sct_lbr_ll =0 sct_bdn_ll=0.
  FOR EACH spt_det WHERE spt_det.spt_part = sct_det.sct_part AND spt_det.spt_sim = sct_det.sct_sim AND spt_det.spt_site = sct_det.sct_site :
      ASSIGN spt_cst_ll = 0.
  END.*/
put skip.
display sct_det.sct_part
   label "Item Number"
  pre-p_m
  
    label "pre_P/M"
    pt_pm_code
    label "P/M_Updated"
pre_freeze
    LABEL "Pre_Freeze"
    sct_roll_up
    LABEL " Freeze_updated"
    WITH FRAME pbody.

end.
end.
END.
end.
output close.

/*WAIT-FOR GO OF FRAME a.
WAIT-FOR CHOOSE OF b-done.*/
WAIT-FOR WINDOW-CLOSE OF CURRENT-WINDOW.
