/* xxwowrrp.p - Work Routing  Print  for                            */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* REVISION: 8.6      LAST MODIFIED: 12/05/99   BY: jym *Jy001*         */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "f+ "}

define variable nbr  like wo_nbr label "加工单号".
define variable nbr1 like wo_nbr.
define variable lot  like wo_lot.
define variable lot1 like wo_lot.
define variable job  like wo_so_job.
define variable job1 like wo_so_job.
define variable part  like wo_part.
define variable part1 like wo_part.
define variable wkctr  like wr_wkctr.
define variable wkctr1 like wr_wkctr.
define variable desc1 like pt_desc1.
define variable first_pass like mfc_logical.
define variable site  like wo_site.
define variable site1 like wo_site.
define variable desc2 like pt_desc2.
define variable usrname like usr_name format "X(24)".
define variable open_ref like wo_qty_ord.
define variable mmmmm like wo_qty_ord.
define variable wcdesc like wc_desc.
define variable um like pt_um.
define variable ptloc like pt_loc.
define variable pline  as char format "x(215)".
define variable pline1 as char format "x(215)".
define variable mpart like pt_part label "子零件".

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
   wkctr          colon 20
   wkctr1         label {t001.i} colon 49 skip
   nbr            colon 20
   nbr1           label {t001.i} colon 49 skip
   lot            colon 20
   lot1           label {t001.i} colon 49 skip
   part           colon 20
   part1          label {t001.i} colon 49 skip
   site           colon 20
   site1          label {t001.i} colon 49 skip
   job            colon 20
   job1           label {t001.i} colon 49 skip (1)

/*IFP*   type           colon 20 skip*/

 SKIP(.4)  /*GUI*/
with frame a width 80 side-labels NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = " 选择条件 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


   if wkctr1 = hi_char then wkctr1 = "".
   if nbr1 = hi_char then nbr1 = "".
   if lot1 = hi_char then lot1 = "".
   if part1 = hi_char then part1 = "".
   if site1 = hi_char then site1 = "".
   if job1 = hi_char then job1 = "".   
   
run p-action-fields (input "display").
run p-action-fields (input "enable").
  
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:

   bcdparm = "".
   {mfquoter.i wkctr       }
   {mfquoter.i wkctr1      }
   {mfquoter.i nbr         }
   {mfquoter.i nbr1        }
   {mfquoter.i lot         }
   {mfquoter.i lot1        }
   {mfquoter.i part        }
   {mfquoter.i part1       }
   {mfquoter.i site        }
   {mfquoter.i site1       }
   {mfquoter.i job         }
   {mfquoter.i job1        }


   if  wkctr1 = "" then wkctr1 = hi_char.
   if  nbr1 = "" then nbr1 = hi_char.
   if  lot1 = "" then lot1 = hi_char.
   if  job1 = "" then job1 = hi_char.
   if  part1 = "" then part1 = hi_char.
   if  site1 = "" then site1 = hi_char.

   /* SELECT PRINTER */
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:


/*IFP***********
   "                    工    艺    流    程    单  (2)                                                 "
   "                                                                                                   "
   "   工作中心：        描述：                     雇员：                     下达日期：               子零件： "
   "                                                                                                   "
   "┌───┬──────┬──┬────┬───┬─────────┬──┬─┬──┬───────────────────────┐".
   "│加工单│123456789012│标志│01234567│零件号│012345678901234567│单位│12│描述│0123456789012345678901234567890123456789012345│".
   "├───┴──────┴──┴────┴───┴─────────┴──┴─┼──┴────┬───┬───────────┬──┤".
   "│加工单需求量：12345678.9 完成量：12345678.9 短缺量：12345678.9            │  实 际 工 时 │首  检│                      │完成│".
   "│ 工 序       描          述      准备工时 单件工时  需求量  短缺量  加工量│准  备  单  件│签  名│合格数  报废数  检查员│日期│".
   "├───┬────────────┬───┬────┬───┬───┬───┼───┬───┼───┼───┬───┬───┼──┤".
   "│>>>>>>│012345678901234567890123│>9.9<<│>>9.9<<<│>>>9.9│>>>9.9│>>>9.9│      │      │      │      │      │      │    │".
   "├───┼────────────┼───┼────┼───┼───┼───┼───┼───┼───┼───┼───┼───┼──┤".
   "│>>>>>>│012345678901234567890123│>9.9<<│>>9.9<<<│>>>9.9│>>>9.9│>>>9.9│      │      │      │      │      │      │    │".
   "├───┼────────────┼───┼────┼───┼───┼───┼───┼───┼───┼───┼───┼───┼──┤".
   "│>>>>>>│012345678901234567890123│>9.9<<│>>9.9<<<│>>>9.9│>>>9.9│>>>9.9│      │      │      │      │      │      │    │".
   "└───┴────────────┴───┴────┴───┴───┴───┴───┴───┴───┴───┴───┴───┴──┘".
    234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901 
             1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21

 请查看相对应的字段 
   "│  工序  │      描    述          │   准 备  │    单   件     │     需 求 量   │   短 缺 量     │    加 工 量    │   准 备  │    单   件     │  签 名   │   合格数   │  报废数  │  检查员  │ 日 期  │".
   "├────┼────────────┼─────┼────────┼────────┼────────┼────────┼─────┼────────┼─────┼──────┼─────┼─────┼────┤".
   "│ wr_op  │wr_desc                 │wr_setup  │wr_run          │wr_qty_ord      │                │->>,>>>,>>9.9<<<│          │                │          │            │          │          │        │ ".
   "├────┼────────────┼─────┼────────┼────────┼────────┼────────┼─────┼────────┼─────┼──────┼─────┼─────┼────┤".
   "│ >>>>>> │012345678901234567890123│>,>>9.9<< │>>,>>>,>>9.9<<<<│->>,>>>,>>9.9<<<│->>,>>>,>>9.9<<<│->>,>>>,>>9.9<<<│          │                │          │            │          │          │        │".
   "└────┴────────────┴─────┴────────┴────────┴────────┴────────┴─────┴────────┴─────┴──────┴─────┴─────┴────┘".
   open_ref = max(wr_qty_ord - wr_qty_comp - wr_qty_rjct , 0 ) .
   短 缺 量 = max(wr_qty_ord - wr_qty_comp - wr_qty_rjct , 0 ).
   
FOR EACH wr_route where  wr_nbr = "11161" and ( wr_wkctr >= '041-03' and wr_wkctr <= '041-04' ) use-index wr_part NO-LOCK break by wr_wkctr by wr_nbr by wr_part by wr_op:
  for each pt_mstr where pt_part = wr_part :
    for each ro_det where ro_routing = wr_part and ro_op = wr_op:
      put wr_nbr wr_part pt_desc1 wr_um wr_op "-" wr_wkctr ro_desc wr_setup wr_run wr_qty_ord wr_qty_comp wr_status ps_comp SKIP.
    end.   
  end.  
END  

**************/
 
      for each wc_mstr where (wc_wkctr >= wkctr and wc_wkctr <= wkctr1)
        use-index wc_wkctr by wc_wkctr by wc_mch :
/*          
          find first wr_route where ( wr_wkctr = wc_wkctr )
            and (wr_nbr >= nbr and wr_nbr <= nbr1)
            and (wr_lot >= lot and wr_lot <= lot1) use-index wr_nbrop no-lock no-error.
      
           if available wr_route then do:
         
              find first wo_mstr where wo_status = "R" and wo_lot = wr_lot
                and (wo_part >= part) and (wo_part <= part1 or part1 = "")
                and (wo_so_job >= job) and (wo_so_job <= job1 or job1 = "")
                and (wo_site >= site) and (wo_site <= site1 or site1 = "") use-index wo_lot no-lock no-error.
          
               if available wo_mstr then do:
                  put "  工    艺    流    程    单  (2) " at 50 skip(1).
                  put "   工作中心：" at 2  wc_wkctr at 15  "描述：" at 28  wc_desc at 33  " 雇员：___________ 下达日期：_________ 子零件：" at 60 . 
                 assign
                  mpart = " ".
                  find first ps_mstr where ps_par = wo_part.
                   if available ps_mstr then do:
                      mpart = ps_comp.
                   end.   

                  put mpart at 110 skip.
                  
               end.
           end.
          

           for each wr_route where ( wr_wkctr = wc_wkctr )
             and (wr_nbr >= nbr and wr_nbr <= nbr1)
             and (wr_lot >= lot and wr_lot <= lot1) ,
           each wo_mstr where wo_status = "R" and wo_lot = wr_lot
             and (wo_part >= part) and (wo_part <= part1 or part1 = "")
             and (wo_so_job >= job) and (wo_so_job <= job1 or job1 = "")
             and (wo_site >= site) and (wo_site <= site1 or site1 = ""),
           each wod_det where (wod_lot = wo_lot) 
             break by wr_wkctr by wr_part by wr_lot by wr_op with frame b1 down width 132:
*/
            for each wr_route where ( wr_wkctr = wc_wkctr )
             and (wr_nbr >= nbr and wr_nbr <= nbr1)
             and (wr_lot >= lot and wr_lot <= lot1),
            each wo_mstr where wo_status = "R" and wo_lot = wr_lot
             and (wo_part >= part) and (wo_part <= part1 or part1 = "")
             and (wo_so_job >= job) and (wo_so_job <= job1 or job1 = "")
             and (wo_site >= site) and (wo_site <= site1 or site1 = "")
            break by wr_wkctr by wr_part by wr_nbr by wr_lot by wr_op with frame b1 down width 132:

               desc1 = "".
               um = "".
               ptloc = "".            
               find first pt_mstr where pt_part = wo_part use-index pt_part no-lock no-error.
                 if available pt_mstr then 
                    assign ptloc = pt_loc
                    desc1 = pt_desc1 + pt_desc2 
                    um = pt_um
                    usrname = "".
                 if first-of(wr_nbr) and first-of(wr_lot) then do:
                   if page-size - line-count < 9 then page.
                    put "工艺流程单(2)   工作中心：" at 2  wc_wkctr at 28  "描述：" at 42  wc_desc at 48  " 雇员：_________________  下达日期：_________ " at 88 . 
                    pline =  "│加工单│" + string(wo_nbr,"x(12)" ) + "│标志│" + string(wo_lot,"x(8)") + "│零号件│" + string(wo_part,"x(18)") + "│单位│" + pt_um + "│描述│" + string(desc1,"x(46)") + "│" .
                    put "┌───┬──────┬──┬────┬───┬─────────┬──┬─┬──┬───────────────────────┐" at 2 skip.
                    put pline at 2  skip.
                    put "├───┴──────┴──┴────┴───┴─────────┴──┴─┼──┴────┬───┬───────────┬──┤" at 2.
                    put "│加工单需求量：" at 2 wo_qty_ord to 30 " 完成量：" at 32  wo_qty_comp to 54 " 短缺量：" at 56 wo_qty_ord - wo_qty_comp - wo_qty_rjct to 76.    
                    put "│  实 际 工 时 │首  检│                      │完成│" at 78.
                    put "│ 工 序       描          述      准备工时 单件工时  需求量  短缺量  加工量│准  备  单  件│签  名│合格数  报废数  检查员│日期│" at 2.
                    put "├───┬────────────┬───┬────┬───┬───┬───┼───┬───┼───┼───┬───┬───┼──┤" at 2.
                 end.
                 open_ref = max(wr_qty_ord - wr_qty_comp - wr_qty_rjct , 0 ) .
                 pline1 = "│" + string(wr_op,">>>>>>") + "│" + string(wr_desc,"x(24)") + "│" + string(wr_setup, ">9.999") 
                   + "│" + string(wr_run,">>9.9999") + "│" + string(wr_qty_ord,">>>9.9") + "│" + string(open_ref,">>>9.9") + "│      │      │      │      │      │      │      │    │".
         
                 put pline1 at 2 skip.

                 if last-of(wr_lot) then do:
                    put "└───┴────────────┴───┴────┴───┴───┴───┴───┴───┴───┴───┴───┴───┴──┘" at 2 skip.
                    put skip(2).
                 end.
                 else do:
                    if page-size - line-count <= 3 then do:
                       put "└───┴────────────┴───┴────┴───┴───┴───┴───┴───┴───┴───┴───┴───┴──┘" at 2 skip.
                       page.
                       put "工艺流程单(2)   工作中心：" at 2  wc_wkctr at 28  "描述：" at 42  wc_desc at 48  " 雇员：_________________  下达日期：_________ " at 88 . 
                       pline =  "│加工单│" + string(wo_nbr,"x(12)" ) + "│标志│" + string(wo_lot,"x(8)") + "│零号件│" + string(wo_part,"x(18)") + "│单位│" + pt_um + "│描述│" + string(desc1,"x(46)") + "│" .
                       put "┌───┬──────┬──┬────┬───┬─────────┬──┬─┬──┬───────────────────────┐" at 2 skip.
                       put pline at 2  skip.
                       put "├───┴──────┴──┴────┴───┴─────────┴──┴─┼──┴────┬───┬───────────┬──┤" at 2.
                       put "│加工单需求量：" at 2 wo_qty_ord to 30 " 完成量：" at 32  wo_qty_comp to 54 " 短缺量：" at 56 wo_qty_ord - wo_qty_comp - wo_qty_rjct to 76.    
                       put "│  实 际 工 时 │首  检│                      │完成│" at 78.
                       put "│ 工 序       描          述      准备工时 单件工时  需求量  短缺量  加工量│准  备  单  件│签  名│合格数  报废数  检查员│日期│" at 2.
                       put "├───┬────────────┬───┬────┬───┬───┬───┼───┬───┼───┼───┬───┬───┼──┤" at 2.
                    end.
                    else
                       put "├───┼────────────┼───┼────┼───┼───┼───┼───┼───┼───┼───┼───┼───┼──┤" at 2 skip. 
                 end. 
                 if last-of(wr_wkctr) then page.
                  
                 if page-size - line-count < 3 then page.
      
         end. /*for each wo_mstr*/
     
         /*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

     end.


/* REPORT TRAILER */
  
/*GUI*/ {mfreset.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

end.

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" wkctr wkctr1 nbr nbr1 lot lot1 part part1 site site1 job job1 "} /*Drive the Report*/
