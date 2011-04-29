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
define variable open_ref like wo_qty_ord.
define variable mmmmm like wo_qty_ord.
define variable wcdesc like wc_desc.
define variable um like pt_um.
define variable ptloc like pt_loc.
define variable pline  as char format "x(215)".
define variable pline1 as char format "x(215)".
define variable mpart like pt_part label "子零件".

define variable desc1-c like pt_desc1.
define variable desc2-c like pt_desc2.
define variable printline as character format "x(90)" extent 60.

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
 /*  mpart          colon 20 skip(2)*/

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


/*                           567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234 */        
/*                                1         2         3         4         5         6         7         8         9*/    
/*IFP*/     printline[1]  = "┌───┬────┬────┬─────┬──┬────┬──┬────────────┐".
/*IFP*/     printline[2]  = "│部  门│        │工作中心│          │设备│        │描述│                        │".
/*IFP*/     printline[3]  = "├───┼────┼────┼─────┼──┴─┬──┴──┴┬───┬───────┤".
/*IFP*/     printline[4]  = "│加工单│        │ 标  志 │          │下达日期│            │到期日│              │".
/*IFP*/     printline[5]  = "├───┼────┴────┼──┬──┴────┴──────┴───┴───────┤".
/*IFP*/     printline[6]  = "│零件号│                  │描述│                                                    │".
/*IFP*/     printline[7]  = "├───┼───┬──┬──┴──┴────┬───┬──────┬───┬──────┤".
/*IFP*/     printline[8]  = "│工  序│      │描述│                    │需求量│            │短缺量│            │".
/*IFP*/     printline[9]  = "├───┼───┼──┼─────┬───┬┴───┴──────┴───┴──────┤".
/*IFP*/     printline[10] = "│准  时│23.123│单时│123.123456│子零件│                                            │".
/*IFP*/     printline[11] = "├───┴┬──┴──┴─┬───┴┬──┴─┬──┬──────┬────┬─────┤".
/*IFP*/     printline[14] = "│父件用量│12345.12345678│沙型类别│        │定额│       箱/日│开始日期│          │". 
/*IFP*/     printline[15] = "├────┴───────┴────┴────┴──┴─┬────┴────┴─────┤".
/*IFP*/     printline[16] = "│                  造  型  记  录                      │       检  查  记  录         │".
/*IFP*/     printline[17] = "├───────────────────────────┼──┬──┬──┬──┬───┤".
/*IFP*/     printline[18] = "│操作者:                    操作者:                    │一沙│合沙│反沙│ 不 │  检  │".
/*IFP*/     printline[19] = "│员工编号:                  员工编号:                  │级型│格型│修型│ 合 │  查  │".
/*IFP*/     printline[20] = "├───┬────┬────┬──────┬──────┤品数│品数│品数│ 格 │  员  │".
/*IFP*/     printline[22] = "│日 期 │实作件数│浇铸件数│  停工原因  │  备     注 │    │    │    │ 数 │ 签字 │".
/*IFP*/     printline[23] = "├───┼────┼────┼──────┼──────┼──┼──┼──┼──┼───┤".
/*IFP*/     printline[24] = "│      │        │        │            │            │    │    │    │    │      │".
/*IFP*/     printline[25] = "├───┼────┼────┼──────┼──────┼──┼──┼──┼──┼───┤".
/*IFP*/     printline[26] = "│      │        │        │            │            │    │    │    │    │      │".
/*IFP*/     printline[27] = "├───┼────┼────┼──────┼──────┼──┼──┼──┼──┼───┤".
/*IFP*/     printline[28] = "│      │        │        │            │            │    │    │    │    │      │".
/*IFP*/     printline[29] = "├───┼────┼────┼──────┼──────┼──┼──┼──┼──┼───┤".
/*IFP*/     printline[30] = "│      │        │        │            │            │    │    │    │    │      │".
/*IFP*/     printline[31] = "├───┼────┼────┼──────┼──────┼──┼──┼──┼──┼───┤".
/*IFP*/     printline[32] = "│      │        │        │            │            │    │    │    │    │      │".
/*IFP*/     printline[33] = "├───┼────┼────┼──────┼──────┼──┼──┼──┼──┼───┤".
/*IFP*/     printline[34] = "│      │        │        │            │            │    │    │    │    │      │".
/*IFP*/     printline[35] = "├───┼────┼────┼──────┼──────┼──┼──┼──┼──┼───┤".
/*IFP*/     printline[36] = "│      │        │        │            │            │    │    │    │    │      │".
/*IFP*/     printline[37] = "├───┼────┼────┼──────┼──────┼──┼──┼──┼──┼───┤".
/*IFP*/     printline[38] = "│      │        │        │            │            │    │    │    │    │      │".
/*IFP*/     printline[39] = "├───┼────┼────┼──────┼──────┼──┼──┼──┼──┼───┤".
/*IFP*/     printline[40] = "│      │        │        │            │            │    │    │    │    │      │".
/*IFP*/     printline[41] = "├───┼────┼────┼──────┼──────┼──┼──┼──┼──┼───┤".
/*IFP*/     printline[42] = "│      │        │        │            │            │    │    │    │    │      │".
/*IFP*/     printline[43] = "├───┼────┼────┼──────┼──────┼──┼──┼──┼──┼───┤".
/*IFP*/     printline[44] = "│      │        │        │            │            │    │    │    │    │      │".
/*IFP*/     printline[45] = "├───┼────┼────┼──────┼──────┼──┼──┼──┼──┼───┤".
/*IFP*/     printline[46] = "│      │        │        │            │            │    │    │    │    │      │".
/*IFP*/     printline[47] = "├───┼────┼────┼──────┼──────┼──┼──┼──┼──┼───┤".
/*IFP*/     printline[48] = "│      │        │        │            │            │    │    │    │    │      │".
/*IFP*/     printline[49] = "├───┼────┼────┼──────┼──────┼──┼──┼──┼──┼───┤".
/*IFP*/     printline[50] = "│      │        │        │            │            │    │    │    │    │      │".
/*IFP*/     printline[51] = "├───┼────┼────┼──────┼──────┼──┼──┼──┼──┼───┤".
/*IFP*/     printline[52] = "│      │        │        │            │            │    │    │    │    │      │".
/*IFP*/     printline[53] = "├───┼────┼────┼──────┼──────┼──┼──┼──┼──┼───┤".
/*IFP*/     printline[54] = "│      │        │        │            │            │    │    │    │    │      │".
/*IFP*/     printline[55] = "├───┼────┼────┼──────┼──────┼──┼──┼──┼──┼───┤".
/*IFP*/     printline[56] = "│      │        │        │            │            │    │    │    │    │      │".
/*IFP*/     printline[57] = "└───┴────┴────┴──────┴──────┴──┴──┴──┴──┴───┘".

      for each wc_mstr where (wc_wkctr >= wkctr and wc_wkctr <= wkctr1)
        use-index wc_wkctr by wc_wkctr by wc_mch :

        for each wr_route where ( wr_wkctr = wc_wkctr )
             and (wr_nbr >= nbr and wr_nbr <= nbr1)
             and (wr_lot >= lot and wr_lot <= lot1),
            each wo_mstr where wo_status = "R" and wo_lot = wr_lot
             and (wo_part >= part) and (wo_part <= part1 or part1 = "")
             and (wo_so_job >= job) and (wo_so_job <= job1 or job1 = "")
             and (wo_site >= site) and (wo_site <= site1 or site1 = "")
             break by wr_wkctr by wr_part by wr_nbr by wr_lot by wr_op with frame b1 down width 132:

               desc1 = "".
               desc1 = "".
               desc1-c = "".
               um = "".
               mmmmm = 0.
               mpart = "".
               find first pt_mstr where pt_part = wo_part use-index pt_part no-lock no-error.
                 if available pt_mstr then 
                    assign ptloc = pt_loc
                    desc1 = pt_desc1 
                    desc2 = pt_desc2.
               
               find first wod_det where wod_lot = wo_lot use-index  wod_det no-lock no-error.
                 if available wod_det then 
                    assign mpart = wod_part
                    mmmmm = wod_qty_req / wo_qty_ord.
                    find first pt_mstr where pt_part = mpart use-index pt_part no-lock no-error.
                      if available pt_mstr then 
                         desc1-c = trim(pt_desc1) + " " + pt_desc2. 
                         um = pt_um.                             
 
               put "工   艺   流   程   单 ( 双  铸  造  型  工  作  票 )"  at 23 skip(1). 
               put "┌───┬────┬────┬─────┬──┬────┬──┬────────────┐" at 5 skip.
               put "│部  门│" at 5  wc_dept at 15 "│工作中心│" at 23 wr_route.wr_wkctr at 35 "│设备│" at 45 wr_route.wr_mch at 53 "│描述│" at 61 wc_desc at 69 "│" at 93.
               put "├───┼────┼────┼─────┼──┴─┬──┴──┴┬───┬───────┤" at 5.
               put "│加工单│" at 5 wo_nbr format "X(8)" at 15 "│ 标  志 │" at 23 wo_lot at 35 "│开始日期│" at 45 wr_route.wr_start format "99/99/9999" at 58 "│到期日│" at 69 wr_route.wr_due format "99/99/9999" at 80 "│" at 93.
               put "├───┼────┴────┼──┬──┴────┴──────┴───┴───────┤" at 5.
               put "│零件号│" at 5 wo_part at 15 "│描述│" at 33 desc1 format "x(24)" at 41 desc2 format "x(24)" to 92 "│" at 93 .
               put "├───┼───┬──┬──┴──┴────┬───┬──────┬───┬──────┤" at 5.
               open_ref = max(wr_qty_ord - wr_qty_comp , 0 ) .
               put "│工  序│" at 5 wr_route.wr_op at 15 "│描述│" at 21 wr_route.wr_desc format "x(20)" at 29 "│需求量│" at 49 wr_route.wr_qty_ord format ">>>>>>>9.99" to 70 "│短缺量│" at 71 open_ref format ">>>>>>>9.99" at 81  "│" at 93. 
               put "├───┼───┼──┼─────┬───┬┴───┴──────┴───┴──────┤" at  5.
               put "│准  时│" at 5 wr_route.wr_setup format ">9.99<" to 20 "│单时│" at 21 wr_route.wr_run format ">>>9.99<<<" to 38 "│子零件│" at 39 trim(mpart) + " " + desc1-c format "x(43)" at 49  "│" at 93.
               put "├───┴┬──┴──┴─┬───┴┬──┴─┬──┬──────┬────┬─────┤" at 5.                     
               put "│父件用量│" at 5 mmmmm format ">>>>9.99<" to 26 um at 29 "│沙型类别│        │定额│       箱/日│开始日期│          │" to 94.
               put printline[15] at 5. 
               put printline[16] at 5.               
               put printline[17] at 5.               
               put printline[18] at 5.              
               put printline[19] at 5.              
               put printline[20] at 5.  
               put printline[22] at 5.               
               put printline[23] at 5.               
               put printline[24] at 5.              
               put printline[25] at 5.              
               put printline[26] at 5.  
               put printline[27] at 5. 
               put printline[28] at 5.               
               put printline[29] at 5.               
               put printline[30] at 5.              
               put printline[31] at 5.              
               put printline[32] at 5.  
               put printline[33] at 5. 
               put printline[34] at 5.               
               put printline[35] at 5.               
               put printline[36] at 5.              
               put printline[37] at 5.              
               put printline[38] at 5.  
               put printline[39] at 5. 
               put printline[40] at 5.               
               put printline[41] at 5.               
               put printline[42] at 5.              
               put printline[43] at 5.              
               put printline[44] at 5.  
               put printline[45] at 5. 
               put printline[46] at 5.               
               put printline[47] at 5.               
               put printline[48] at 5.              
               put printline[49] at 5.              
               put printline[50] at 5.  
               put printline[51] at 5. 
               put printline[52] at 5.               
               put printline[53] at 5.               
               put printline[54] at 5.              
               put printline[55] at 5.              
               put printline[56] at 5.  
               put printline[57] at 5 skip(1). 
               page.
      
         end. /*for each wo_mstr*/
     
         /*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

     end.


/* REPORT TRAILER */
  
/*GUI*/ {mfreset.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

end.

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" wkctr wkctr1 nbr nbr1 lot lot1 part part1 site site1 job job1 "} /*Drive the Report*/
