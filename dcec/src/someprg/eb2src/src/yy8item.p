/*八大件报表-分解生产计划-分解BOM*/
{mfdtitle.i "d+ "}

def var parent like bom_parent.
def var op like opm_std_op.
def var op1 like opm_std_op.
def var wkctr like wc_wkctr.
def var wkctr1 like wc_wkctr.
def var effdate like tr_effdate.
define variable record as integer extent 100.
define variable comp like ps_comp.
define variable level as integer.
define variable maxlevel as integer format ">>>" label "层次".


def workfile xxwk
    field parent like bom_parent
    field comp like ps_comp
    field desc1 like pt_desc1
    field desc2 like pt_desc2
    field ref like ps_ref
    field sdate like ps_start
    field edate like ps_end
    field qty like ps_qty_per
    field op like ps_op
    field monkind like pc_curr
    field wkctr like opm_wkctr
    field wcdesc like opm_desc.
def workfile item8
    field part_i8      like rps_part
    field item8_i8     like rps_part
    field desc_i8      like pt_desc2
    field qty_i8       like ps_qty_per.
def var site1 like rps_site initial "DCEC-B".
def var site2 like rps_site initial "DCEC-B".    
def var datemonth as integer format ">9" .    
datemonth = month(today).
def var qty_flag       like ps_qty_per.    
def var sum_flag       as   int.
def var part_flag      as   char.
def var date_flag      like rps_due_date.
def workfile parttable
    field part_t       like rps_part
    field qty_t        like rps_qty_req
    field bomcode_t    like rps_bom_code
    field date_t       like rps_due_date
    field item8_t      like rps_part
    field qtyi8_t      like rps_qty_req.

def workfile item_table
    field partno8 like mrp_part
    field site8   like mrp_site
    field partna8 like pt_desc2 format "x(10)"
    field sum8     like mrp_qty     format "->>>>>9" 
    field d1       like mrp_qty     format "->>>>>9"
    field d2       like mrp_qty     format "->>>>>9"
    field d3       like mrp_qty     format "->>>>>9"
    field d4       like mrp_qty     format "->>>>>9"
    field d5       like mrp_qty     format "->>>>>9"
    field d6       like mrp_qty     format "->>>>>9"
    field d7       like mrp_qty     format "->>>>>9"
    field d8       like mrp_qty     format "->>>>>9"
    field d9       like mrp_qty     format "->>>>>9"
    field d10      like mrp_qty     format "->>>>>9"
    field d11      like mrp_qty     format "->>>>>9"
    field d12      like mrp_qty     format "->>>>>9"
    field d13      like mrp_qty     format "->>>>>9"
    field d14      like mrp_qty     format "->>>>>9"
    field d15      like mrp_qty     format "->>>>>9"
    field d16      like mrp_qty     format "->>>>>9"
    field d17      like mrp_qty     format "->>>>>9"
    field d18      like mrp_qty     format "->>>>>9"
    field d19      like mrp_qty     format "->>>>>9"
    field d20      like mrp_qty     format "->>>>>9"
    field d21      like mrp_qty     format "->>>>>9"
    field d22      like mrp_qty     format "->>>>>9"
    field d23      like mrp_qty     format "->>>>>9"
    field d24      like mrp_qty     format "->>>>>9"
    field d25      like mrp_qty     format "->>>>>9"
    field d26      like mrp_qty     format "->>>>>9"
    field d27      like mrp_qty     format "->>>>>9"
    field d28      like mrp_qty     format "->>>>>9"
    field d29      like mrp_qty     format "->>>>>9"
    field d30      like mrp_qty     format "->>>>>9"
    field d31      like mrp_qty     format "->>>>>9".
    
    
FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
           site1     colon 25 label "地点"
           site2     colon 49 label "至"
           skip(.1) 
           datemonth colon 25 label "月份"

          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

  DEFINE VARIABLE F-a-title AS CHARACTER.
  F-a-title = " 选择条件 ".
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
  RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
  RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
  RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

update site1 site2 datemonth with frame a.     

for each rps_mstr where month(rps_due_date ) = datemonth  /*expend the schedule*/
                        and year(rps_due_date) = year(today)
                        and rps_site >= site1 
                        and rps_site <= site2
                  break by rps_due_date by rps_part:
                  if date_flag <> rps_due_date then do:
                        date_flag = rps_due_date.
                        part_flag = rps_part.
                        create parttable.
                               part_t    = rps_part.
                               bomcode_t = rps_bom_code.
                               qty_t     = rps_qty_req.
                               date_t    = rps_due_date.
                  end.
                  else do:
                        if part_flag <> rps_part then do:
                           create parttable.
                               part_t    = rps_part.
                               bomcode_t = rps_bom_code.
                               qty_t     = rps_qty_req.
                               date_t    = rps_due_date.
                        end.
                        else do:
                               qty_t     = rps_qty_req.
                        end.
                        
                  end.
                  
 
end.    

part_flag = "0".
   {mfselprt.i "printer" 132}
for each parttable break by part_t:
    if part_flag = part_t then do:
        undo,retry.
    end.   
    else do:
       part_flag = part_t.
       parent    = bomcode_t.
    end.   
   
   if op1 = hi_char then op1 = "".
   if wkctr1 = hi_char then wkctr1 = "".
   
  
   
   if op1 = "" then op1 = hi_char.
   if wkctr1 = "" then wkctr1 = hi_char.
   

   find bom_mstr where bom_parent = parent no-lock no-error.
   if not available bom_mstr then do:
        next-prompt parent.
        undo,retry.
   end.

   find first ps_mstr use-index ps_parcomp where ps_par = parent
   no-lock no-error.
   if not available ps_mstr then do:
        undo,retry.
   end.
   

   
   for each xxwk:
        delete xxwk.
   end.
   
   assign
         level = 1
	  comp = parent
	  maxlevel = min(maxlevel,99).   
   
   repeat: /*for expand the ps*/
	       if not available ps_mstr then do:
		  repeat:
		     level = level - 1.
		     if level < 1 then leave.
		     find ps_mstr where recid(ps_mstr) = record[level]
		     no-lock no-error.
		     comp = ps_par.
		     find next ps_mstr use-index ps_parcomp where ps_par = comp
		     no-lock no-error.
		     if available ps_mstr then leave.
		  end.
	       end.
	       if level < 1 then leave.

	       if effdate = ? or (effdate <> ? and
	       (ps_start = ? or ps_start <= effdate)
	       and (ps_end = ? or effdate <= ps_end)) then do:

                find pt_mstr where pt_part = ps_comp no-lock no-error.
                find ptp_det where ptp_site = ps__chr01 and ptp_part = ps_comp no-lock no-error.
                
                if available pt_mstr and 
                ((available ptp_det and not ptp_phantom)
                  or
                  (not available ptp_det and not pt_phantom)) then do:
                
                      create xxwk.
                      assign xxwk.parent = parent
                             xxwk.comp = ps_comp
                             xxwk.desc1 = pt_desc1
                             xxwk.desc2 = pt_desc2
                             xxwk.ref = ps_ref
                             xxwk.sdate = ps_start
                             xxwk.edate = ps_end
                             xxwk.op = ps_op
                             xxwk.qty = ps_qty_per.
                      
                      find first opm_mstr where opm_std_op = string(ps_op) no-lock no-error.
                      if available opm_mstr then do:
                            assign xxwk.wkctr = opm_wkctr.
                            
                            find wc_mstr where wc_wkctr = opm_wkctr and wc_mch = opm_mch no-lock no-error.
                            if available wc_mstr then
                                   assign xxwk.wcdesc = wc_desc.
                      end. 

                end.        
                       
		  record[level] = recid(ps_mstr).

		  if level < maxlevel or maxlevel = 0 
		  and ((available ptp_det and ptp_phantom) or (not available ptp_det and available pt_mstr and pt_phantom)
		        or not available pt_mstr) 
		  then do:
		     comp = ps_comp.
		     level = level + 1.
		     find first ps_mstr use-index ps_parcomp where ps_par = comp
		     no-lock no-error.
		  end.
		  else do:
		     find next ps_mstr use-index ps_parcomp where ps_par = comp
		     no-lock no-error.
		  end.
	       end.
	       else do:
		     find next ps_mstr use-index ps_parcomp where ps_par = comp
		     no-lock no-error.
	       end.
   
   end. /*expand the ps*/

   for each xxwk no-lock 
       where (string(xxwk.op) >= op and string(xxwk.op) <= op1)
       and (xxwk.wkctr >= wkctr and xxwk.wkctr <= wkctr1)
       break by xxwk.wkctr by xxwk.comp:
       find first pt_mstr no-lock where pt_part = xxwk.comp no-error.
       if pt_group = "m" then do:
          find first ptp_det no-lock where ptp_part = xxwk.comp no-error.
          if ptp_phantom = no and ptp_pm_code = "m" then do:
             create item8.
                    part_i8 = xxwk.parent.
                    item8_i8 = xxwk.comp.
                    desc_i8  = xxwk.desc2.
                    qty_i8   = xxwk.qty.
          end.   
       end. 
   end. /*for each xxwk*/
   
       
end. /*repeat*/
part_flag = "0".
for each item8 ,
    each parttable 
         where bomcode_t = part_i8
         break by item8_i8 by date_t:
         if part_flag <> item8_i8 then do:
            part_flag = item8_i8.
            create item_table.
                   partno8 = item8_i8.
                   partna8 = desc_i8.
                   sum8    = qty_i8 * qty_t.
                   if day(date_t) = 1 then d1 =  qty_i8 * qty_t.
                   if day(date_t) = 2 then d2 =  qty_i8 * qty_t.  
                   if day(date_t) = 3 then d3 =  qty_i8 * qty_t.
                   if day(date_t) = 4 then d4 =  qty_i8 * qty_t.  
                   if day(date_t) = 5 then d5 =  qty_i8 * qty_t.
                   if day(date_t) = 6 then d6 =  qty_i8 * qty_t.  
                   if day(date_t) = 7 then d7 =  qty_i8 * qty_t.
                   if day(date_t) = 8 then d8 =  qty_i8 * qty_t.  
                   if day(date_t) = 9 then d9 =  qty_i8 * qty_t.
                   if day(date_t) = 10 then d10 =  qty_i8 * qty_t.
                   if day(date_t) = 11 then d11 =  qty_i8 * qty_t.
                   if day(date_t) = 12 then d12 =  qty_i8 * qty_t.  
                   if day(date_t) = 13 then d13 =  qty_i8 * qty_t.
                   if day(date_t) = 14 then d14 =  qty_i8 * qty_t.  
                   if day(date_t) = 15 then d15 =  qty_i8 * qty_t.
                   if day(date_t) = 16 then d16 =  qty_i8 * qty_t.  
                   if day(date_t) = 17 then d17 =  qty_i8 * qty_t.
                   if day(date_t) = 18 then d18 =  qty_i8 * qty_t.  
                   if day(date_t) = 19 then d19 =  qty_i8 * qty_t.
                   if day(date_t) = 20 then d20 =  qty_i8 * qty_t.
                   if day(date_t) = 21 then d21 =  qty_i8 * qty_t.                       
                   if day(date_t) = 22 then d22 =  qty_i8 * qty_t.  
                   if day(date_t) = 23 then d23 =  qty_i8 * qty_t.
                   if day(date_t) = 24 then d24 =  qty_i8 * qty_t.  
                   if day(date_t) = 25 then d25 =  qty_i8 * qty_t.
                   if day(date_t) = 26 then d26 =  qty_i8 * qty_t.  
                   if day(date_t) = 27 then d27 =  qty_i8 * qty_t.
                   if day(date_t) = 28 then d28 =  qty_i8 * qty_t.  
                   if day(date_t) = 29 then d29 =  qty_i8 * qty_t.  
                   if day(date_t) = 30 then d30 =  qty_i8 * qty_t.  
                   if day(date_t) = 31 then d31 =  qty_i8 * qty_t.  
         end.
         else do:
                   sum8    = sum8 + qty_i8 * qty_t.
                   if day(date_t) = 1 then d1 = d1  +  qty_i8 * qty_t.
                   if day(date_t) = 2 then d2 = d2 +  qty_i8 * qty_t.  
                   if day(date_t) = 3 then d3 =   d3  +  qty_i8 * qty_t.
                   if day(date_t) = 4 then d4 =   d4  +  qty_i8 * qty_t.  
                   if day(date_t) = 5 then d5 =   d5  +  qty_i8 * qty_t.
                   if day(date_t) = 6 then d6 =   d6  +  qty_i8 * qty_t.  
                   if day(date_t) = 7 then d7 =   d7  +  qty_i8 * qty_t.
                   if day(date_t) = 8 then d8 =   d8  +  qty_i8 * qty_t.  
                   if day(date_t) = 9 then d9 =   d9  +  qty_i8 * qty_t.
                   if day(date_t) = 10 then d10 =   d10  +  qty_i8 * qty_t.
                   if day(date_t) = 11 then d11 =   d11  +  qty_i8 * qty_t.
                   if day(date_t) = 12 then d12 =   d12  +  qty_i8 * qty_t.  
                   if day(date_t) = 13 then d13 =   d13  +  qty_i8 * qty_t.
                   if day(date_t) = 14 then d14 =   d14  +  qty_i8 * qty_t.  
                   if day(date_t) = 15 then d15 =   d15  +  qty_i8 * qty_t.
                   if day(date_t) = 16 then d16 =   d16  +  qty_i8 * qty_t.  
                   if day(date_t) = 17 then d17 =   d17  +  qty_i8 * qty_t.
                   if day(date_t) = 18 then d18 =   d18  +  qty_i8 * qty_t.  
                   if day(date_t) = 19 then d19 =   d19  +  qty_i8 * qty_t.
                   if day(date_t) = 20 then d20 =   d20  +  qty_i8 * qty_t.
                   if day(date_t) = 21 then d21 =   d21  +  qty_i8 * qty_t.                       
                   if day(date_t) = 22 then d22 =   d22 +  qty_i8 * qty_t.  
                   if day(date_t) = 23 then d23 =   d23  +  qty_i8 * qty_t.
                   if day(date_t) = 24 then d24 =   d24  +  qty_i8 * qty_t.  
                   if day(date_t) = 25 then d25 =   d25  +  qty_i8 * qty_t.
                   if day(date_t) = 26 then d26 =   d26  +  qty_i8 * qty_t.  
                   if day(date_t) = 27 then d27 =   d27  +  qty_i8 * qty_t.
                   if day(date_t) = 28 then d28 =   d28  +  qty_i8 * qty_t.  
                   if day(date_t) = 29 then d29 =   d29  +  qty_i8 * qty_t.  
                   if day(date_t) = 30 then d30 =   d30  +  qty_i8 * qty_t.  
                   if day(date_t) = 31 then d31 =   d31 +  qty_i8 * qty_t.  

         end.
end.

disp "八大件计划" year(today) "年" datemonth no-label "月份" .       
         for each item_table break by partno8 :
             disp partno8 no-label partna8 no-label  sum8 label "总数" 
                  d1 label "1"  d2 label "2"  d3  label "3"  d4  label "4" d5 label "5"  d6 label "6"  d7 label "7"  d8 label "8"  d9 label "9"   d10 label "10" skip
             with width 500 with stream-io.
         end.
         
         
         for each item_table break by partno8 :
             disp partno8 no-label  partna8 no-label  
                  d11  label "11" d12 label "12"  d13  label "13" d14 label "14"  d15 label "15"  d16 label "16"  d17 label "17"  d18 label "18"  d19 label "19"  d20 label "20" skip
             with width 500 with stream-io.
         end.
         
         
         for each item_table break by partno8 :
             disp partno8 no-label  partna8 no-label  
                  d21  label "21" d22 label "22"  d23 label "23"  d24 label "24"  d25 label "25"  d26 label "26"  d27 label "27"  d28 label "28"  d29 label "29"  d30 label "30"  d31 label "31" skip
             with width 500 with stream-io.
         end.
{mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
