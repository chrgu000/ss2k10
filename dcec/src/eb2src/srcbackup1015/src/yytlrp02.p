/*zztlrp01.p , report of transfer list*/
/*Last modified: 11/18/2003, By: Kevin, Atos Origin*/
/*Last modified: 08/18/2005, By: judy liu, Atos Origin*/

         /* DISPLAY TITLE */
         {mfdtitle.i "++ "} /*FN07*/

def var site like si_site.
DEF VAR site1 LIKE si_site LABEL "移入地点". 
def var effdate like tr_effdate.
def var effdate1 like tr_effdate.
def var nbr like xxtl_nbr.
def var nbr1 like xxtl_nbr.
def var part like pt_part.
def var part1 like pt_part.
def var locfr like loc_loc.
def var locfr1 like loc_loc.
def var locto like loc_loc.
def var locto1 like loc_loc.
def var rmks as char.
def var open_only like mfc_logical initial "Yes".
def var untr_only like mfc_logical initial "No".
def var msg-nbr as inte.
def var qty_open like xxtl_qty_tr label "短缺量".

def buffer b1 for xxtl_det.

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
site colon 22
site1 COLON 22
effdate colon 22        effdate1 colon 49 label {t001.i}
nbr colon 22            nbr1 colon 49 label {t001.i}
part colon 22           part1 colon 49 label {t001.i}
locfr colon 22 label "移出库位"     locfr1 colon 49 label {t001.i}
locto colon 22 label "车间库位"     locto1 colon 49 label {t001.i} skip(1)
open_only colon 22 label "只打印短缺的移仓单"
untr_only colon 22 label "只打印未确认移仓单"
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
setframelabels(frame a:handle) .

repeat:

     if effdate = low_date then effdate = ?.
     if effdate1 = hi_date then effdate1 = ?.
     if nbr1 = hi_char then nbr1 = "".
     if part1 = hi_char then part1 = "".
     if locfr1 = hi_char then locfr1 = "".
     if locto1 = hi_char then locto1 = "".
     
     update site site1 effdate effdate1 nbr nbr1 part part1 locfr locfr1 locto locto1 
            open_only untr_only with frame a.

       /*verify the input site*/ 
       find si_mstr no-lock where si_site = site no-error.
       if not available si_mstr or (si_db <> global_db) then do:
          if not available si_mstr then msg-nbr = 708.
          else msg-nbr = 5421.
          {mfmsg.i msg-nbr 3}
          undo, retry.
       end.
            
            if available si_mstr then disp si_site @ site with frame a.
                    
                {gprun.i ""gpsiver.p""
                "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/             {mfmsg.i 725 3}    /* USER DOES NOT HAVE */
/*J034*/                                /* ACCESS TO THIS SITE*/
/*J034*/             undo,retry.
/*J034*/          end.   

     
     if effdate = ? then effdate = low_date.
     if effdate1 = ? then effdate1 = hi_date.
     if nbr1 = "" then nbr1 = hi_char.
     if part1 = "" then part1 = hi_char.
     if locfr1 = "" then locfr1 = hi_char.
     if locto1 = "" then locto1 = hi_char.

     bcdparm = "".
     {mfquoter.i site       }
     {mfquoter.i site1      }
     {mfquoter.i effdate    }
     {mfquoter.i effdate1    }
     {mfquoter.i nbr    }
     {mfquoter.i nbr1    }
     {mfquoter.i part    }
     {mfquoter.i part1    }
     {mfquoter.i locfr    }
     {mfquoter.i locfr1    }
     {mfquoter.i locto    }
     {mfquoter.i locto1    }
     {mfquoter.i open_only    }
     {mfquoter.i untr_only}
     
    {mfselbpr.i "printer" 132}
    {mfphead.i}
     
     for each xxtl_det where (xxtl_site = site OR site = "") and
                             (xxtl_site1 = site1 OR site1 = "") AND
                             (xxtl_effdate >= effdate and xxtl_effdate <= effdate1) and
                             (xxtl_nbr >= nbr and xxtl_nbr <= nbr1) and
                             (xxtl_part >= part and xxtl_part <= part1) and
                             (xxtl_loc_fr >= locfr and xxtl_loc_fr <= locfr1) and
                             (xxtl_loc_to >= locto and xxtl_loc_to <= locto1) and
                             (open_only = no or (open_only and xxtl_qty_req > xxtl_qty_tr AND
                               xxtl_status = "" )) no-lock:
            
            find first b1 where b1.xxtl_nbr = xxtl_det.xxtl_nbr AND b1.xxtl_part = xxtl_det.xxtl_part AND
                                (b1.xxtl_qty_tr <> 0 OR   b1.xxtl_status <> "")no-lock no-error.
            
            if (untr_only = no or (untr_only and not available b1)) then do:                   
                    qty_open = max(xxtl_det.xxtl_qty_req - xxtl_det.xxtl_qty_tr,0).
                    
                    disp xxtl_det.xxtl_nbr 
                      xxtl_det.xxtl_site LABEL "移出地点" 
                      xxtl_det.xxtl_site1 LABEL "移入地点"  
                      xxtl_det.xxtl_effdate xxtl_det.xxtl_part
                      xxtl_det.xxtl_loc_fr xxtl_det.xxtl_loc_to
                      xxtl_det.xxtl_qty_req 
                      xxtl_det.xxtl_qty_pick 
                      xxtl_det.xxtl_qty_tr 
                      qty_open
                      xxtl_det.xxtl_status
                      xxtl_det.xxtl_type  with width 160 stream-io.
                    
                  IF NOT AVAIL b1 THEN disp "未移仓" @ rmks label "说明".
                  ELSE if available b1 AND b1.xxtl_status = "x" then disp "已取消" @ rmks label "说明".
                  ELSE disp "已移仓" @ rmks label "说明".
                  
            end.

     end. /*for each xxtl_det*/  
     
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/
        {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/    
     
end. /*repeat*/

 
