/*LAST MODIFIED: HOU               2006.02.27               *H01* */
/*               HOU               2006.03.02               *H02* */
/*               HOU               2006.03.12               *H03* */

         	 /* DISPLAY TITLE */
                  {mfdeclre.i}
         
         define input parameter iLot   like xwck_lot.
         define input parameter iwoLot like xwo_wolot.
         
         DEFINE buffer xwosrt   for xwo_srt.
/*H01*/  define buffer bfxwosd  for xwosd_det.         

         DEFINE VARIABLE xsrtid as recid.
/*H01*/  define variable v_recid as recid.
         
         for first wo_mstr where wo_lot = iWoLot no-lock : end.
         IF not available wo_mstr THEN
         DO:
         	return.
         END. /* not available wo_mstr*/
         
         for each xwo_srt where xwo_srt.xwo_lot  = ilot
/*H03**                   no-lock  use-index xwo_lnr **/
/*H03*/            no-lock  use-index xwo_lot
/*H02*/            break by xwo_srt.xwo_lot :

/*H02*/    if first-of(xwo_srt.xwo_lot) then do:
             /*H01* *add by hou begin* */
             for each xwosd_det where xwosd_det.xwosd_lnr = xwo_srt.xwo_lnr 
                and xwosd_det.xwosd_date = xwo_srt.xwo_date
                and xwosd_det.xwosd_fg_lot = xwo_srt.xwo_lot no-lock:
                
                v_recid = recid(xwosd_det).
                
                find bfxwosd where recid(bfxwosd) = v_recid exclusive-lock no-error.
                bfxwosd.xwosd_bkflh = yes.
                
                release bfxwosd.
             end.
             /*H01* *add by hou end* */
/*H02*/    end. /* if first-of */
             
             xsrtid = recid(xwo_srt).
         
             for first xwosrt where recid(xwosrt) = xsrtid exclusive-lock: end.
             IF available xwosrt THEN DO:
                xwosrt.xwo_blkflh = yes.
                xwosrt.xwo_wolot  = iWoLot. /*lw01*/
                release xwosrt.    	
             END.
         end. /*xwo_srt*/
         
