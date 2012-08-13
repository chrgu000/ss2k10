/*yyptmprp01.p, Based on the result of MRP, 
to calculate the actual distribution percentage of the item*/
/*Last modified: 12/11/2003, By: kevin*/

/* DISPLAY TITLE */
{mfdtitle.i "e+ "}

def var site like si_site.
def var effdate like tr_effdate.
def var effdate1 like tr_effdate.
def var part like pt_part.
def var part1 like pt_part.
def var buyer like ptp_buyer.
def var buyer1 like ptp_buyer.
def var line like pt_prod_line.
def var line1 like pt_prod_line.
def var type like pt_part_type.
def var type1 like pt_part_type.
def var ptgroup like pt_group.
def var ptgroup1 like pt_group.
def var detail_yn as logic initial no.
def var tot_qty like tr_qty_loc.
def var fix_qty like tr_qty_loc.
def var msg-nbr as inte.
def var lastdate like tr_effdate.

def workfile xxwk
    field part like pt_part
    field vend like vd_addr
    field qty like tr_qty_loc label "建议分配量"
    field std_per like tr_qty_loc format ">>9%" label "系统比例"
    field qty_per like tr_qty_loc format ">>9%" label "建议比例"
   field rmks as char format "x(40)" label "备注".

def buffer ptmstr for pt_mstr.

Form
/*GM65*/
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 site colon 22
 effdate colon 22       effdate1 colon 49 label {t001.i}
 part colon 22          part1 colon 49 label {t001.i}
 buyer colon 22         buyer1 colon 49 label {t001.i}
 line colon 22          line1 colon 49 label {t001.i}
 type colon 22          type1 colon 49 label {t001.i}
 ptgroup colon 22       ptgroup1 colon 49 label {t001.i} skip(1)
 detail_yn colon 22 label "是否打印明细" 
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

setFrameLabels(frame a:handle).


 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

view frame a.

repeat:
    if effdate = low_date then effdate = ?.
    if effdate1 = hi_date then effdate1 = ?.
    if part1 = hi_char then part1 = "".
    if buyer1 = hi_char then buyer1 = "".
    if line1 = hi_char then line1 = "".
    if type1 = hi_char then type1 = "".
    if ptgroup1 = hi_char then ptgroup1 = "".
    
    update site effdate effdate1 part part1 buyer buyer1 line line1
           type type1 ptgroup ptgroup1 
           detail_yn with frame a.

    bcdparm = "".
    {mfquoter.i site       }
    {mfquoter.i effdate      }
    {mfquoter.i effdate1        }
    {mfquoter.i part        }
    {mfquoter.i part1        }
    {mfquoter.i buyer        }
    {mfquoter.i buyer1        }
    {mfquoter.i line        }
    {mfquoter.i line1        }
    {mfquoter.i type        }
    {mfquoter.i type1        }
    {mfquoter.i ptgroup        }
    {mfquoter.i ptgroup1        }
    {mfquoter.i detail_yn }
        
    if effdate = ? then effdate = low_date.
    if effdate1 = ? then effdate1 = hi_date.
    if part1 = "" then part1 = hi_char.
    if buyer1 = "" then buyer1 = hi_char.
    if line1 = "" then line1 = hi_char.
    if type1 = "" then type1 = hi_char.
    if ptgroup1 = "" then ptgroup1 = hi_char.

       /*verify the input site*/ 
       find si_mstr no-lock where si_site = site no-error.
       if not available si_mstr or (si_db <> global_db) then do:
          if not available si_mstr then msg-nbr = 708.
          else msg-nbr = 5421.
          /*TFQ {mfmsg.i msg-nbr 3}*/
           {pxmsg.i
               &MSGNUM=msg-nbr
               &ERRORLEVEL=3
                          }

          undo, retry.
       end.
            
                    
                {gprun.i ""gpsiver.p""
                "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/        /*tfq     {mfmsg.i 725 3}  */
 {pxmsg.i
               &MSGNUM=725
               &ERRORLEVEL=3
                            }
   /* USER DOES NOT HAVE */
/*J034*/                                /* ACCESS TO THIS SITE*/
/*J034*/             undo,retry.
/*J034*/          end.
    
    {mfselbpr.i "printer" 132}
    {mfphead.i}
    
    for each pt_mstr where (pt_part >= part and pt_part <= part1) 
                      and (pt_prod_line >= line and pt_prod_line <= line1)
                      and (pt_part_type >= type and pt_part_type <= type1)
                      and (pt_group >= ptgroup and pt_group <= ptgroup1)
                         no-lock,
             each ptp_det where ptp_site = site and
                                ptp_part = pt_part and
                                (ptp_buyer >= buyer and ptp_buyer <= buyer1)
                                no-lock:
          
          tot_qty = 0.
          fix_qty = 0.
          
          find first pod_det where pod_sched and pod_part = pt_part no-lock no-error.
          if not available pod_det then next.
          
          for each xxwk:
              delete xxwk.
         end.
         
          for each mrp_det where mrp_site = site and
                                 mrp_part = pt_part and
                                 mrp_dataset = "wod_det" and
                                 mrp_type = "demand" and
                                 (mrp_due_date >= effdate and mrp_due_date <= effdate1) 
                   no-lock break by mrp_due_date:
                   
                   accumulate mrp_qty (total by mrp_due_date).
                   find wo_mstr where wo_nbr = mrp_nbr and wo_lot = mrp_line no-lock no-error.
                   if available wo_mstr then do:

                       /*vendor percentage calculate*/
                       find first xxptmp_mstr where xxptmp_site = mrp_site and
                                                    xxptmp_par = wo_part and
                                             xxptmp_comp = mrp_part no-lock no-error.
                    if available xxptmp_mstr then do:
                          fix_qty = fix_qty + mrp_qty.
                          
                          find first xxwk where xxwk.part = mrp_part and
                                                xxwk.vend = xxptmp_vend no-error.
                          if not available xxwk then do:
                              create xxwk.
                              assign xxwk.part = mrp_part
                                     xxwk.vend = xxptmp_vend
                                     xxwk.qty = mrp_qty
                                     xxwk.rmks = xxptmp_rmks. 
                          end.            
                          else assign xxwk.qty = xxwk.qty + mrp_qty.
                    end.                             
                      
                       find ptmstr where ptmstr.pt_part = wo_part no-lock no-error.
                   end.
                   
                   if detail_yn then
                        disp pt_mstr.pt_part pt_mstr.pt_desc2
                              mrp_qty label "需求量" mrp_due_date label "需求日期"
                              wo_part when available wo_mstr label "父零件"
                              ptmstr.pt_desc2 when available ptmstr                              
                            xxptmp_vend when available wo_mstr and available xxptmp_mstr
                         xxptmp_rmks when available wo_mstr and available xxptmp_mstr
                              with width 166 stream-io. 
                   
                   
                   if last(mrp_due_date) then do:
                      tot_qty = accum total mrp_qty. 
                      if detail_yn then do:
                          down.
                          underline pt_mstr.pt_desc2 mrp_qty.   
                          disp "Total:" @ pt_mstr.pt_desc2 tot_qty @ mrp_qty.
                      end.
                   else do:
                      disp pt_mstr.pt_part pt_mstr.pt_desc2 tot_qty @ mrp_qty.
                   end.
                   end.     
                  
          end. /*for each mrp_det*/
         
         /**************Calculate the vendor percetage**********************/
     if tot_qty <> 0 then do:    
         lastdate = ?.
         find last qad_wkfl where qad_key1 = "poa_det" and
                                  qad_charfld[3] = site and
                                  qad_charfld[2] = pt_mstr.pt_part no-lock no-error.
         if available qad_wkfl then lastdate = qad_datefld[1].
         
         if lastdate <> ? then do:
             for each qad_wkfl where qad_key1 = "poa_det" and
                                     qad_charfld[3] = site and
                                     qad_charfld[2] = pt_mstr.pt_part and
                                     qad_datefld[1] = lastdate no-lock:
         
                find po_mstr where po_sched and po_nbr = qad_charfld[1] no-lock no-error.
                if available po_mstr then do:
                    find first xxwk where xxwk.part = qad_charfld[2] and 
                                          xxwk.vend = po_vend no-error.
                    if not available xxwk then do:
                        create xxwk.
                        assign xxwk.part = qad_charfld[2]
                               xxwk.vend = po_vend
                               xxwk.qty = round((tot_qty - fix_qty) * qad_decfld[1] / 100,0).
                    end.
                    else 
                        assign xxwk.qty = xxwk.qty + round((tot_qty - fix_qty) * qad_decfld[1] / 100,0).                      

                    assign xxwk.std_per = qad_decfld[1].

                end.                       
             end.
         end.                     
          
          for each xxwk:
            xxwk.qty_per = xxwk.qty / tot_qty * 100.  
              disp xxwk with width 132 stream-io. 
         end. 
     
     end. /*if tot_qty <> 0*/
          
    end. /*for each pt_mstr*/
    
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/
        {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
               
end. /*repeat*/
