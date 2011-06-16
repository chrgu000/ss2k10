/*=====================================================*/
/*======   本程序用来对发票号维护数据的自动导入   =====*/
/*======   date: 07/12/04    designer: cary liu   =====*/
/*=====================================================*/
{mfdtitle.i "20100706 "}

DEF var str1 as character format "x(90)".   /*==存储读取文件中的内容==*/
def var str2 as character format "x(30)" .  /*==用来存储读取文件的路径==*/
str2 = "inv_load.txt".
&SCOPED-DEFINE PP_FRAME_NAME A

form
/*    RECT-FRAME       AT ROW 1 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1 */
    skip(1)
    str2 colon 20 label "导入文件路径" 
    skip(1)
    with frame a side-label width 80 attr-space  . /* NO-BOX THREE-D.

DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

*/
&UNDEFINE PP_FRAME_NAME

setframelabels(frame a:handle).

repeat:
update str2 with frame a.

if str2 = "" then do:
   message "文件导入路径不能为空，请重新输入" view-as alert-box error buttons OK.
   end.
else
if search(str2) <> str2 then do:
   message "找不到文件，请检查路径" view-as alert-box error buttons OK.
   end.
else leave.
end. /*end repeat*/

   input from value(str2).
   do while true:
      import unformatted str1.
      if length(str1) < 1 then leave.
      find xx_inv_mstr where xx_inv_no = entry(1,str1,"~t") no-error.
	   if not available xx_inv_mstr then do:
	   create xx_inv_mstr.
	   assign
		xx_inv_no = entry(1,str1,"~t")
                xx_inv_site = entry(2,str1,"~t")  
	        xx_inv_con = entry(3,str1,"~t")
                xx_refer = entry(4,str1,"~t")  
                xx_section = entry(5,str1,"~t")
                xx_inv_duedate = date(entry(6,str1,"~t"))
                xx_inv_date = date(entry(7,str1,"~t"))
                xx_inv_curr = entry(8,str1,"~t")
                xx_inv_value = int(entry(9,str1,"~t")).
	   end.
	   else 
	   assign
	        xx_inv_site = entry(2,str1,"~t")  
	        xx_inv_con = entry(3,str1,"~t")
                xx_refer = entry(4,str1,"~t")  
                xx_section = entry(5,str1,"~t")
                xx_inv_duedate = date(entry(6,str1,"~t"))
                xx_inv_date = date(entry(7,str1,"~t"))
                xx_inv_curr = entry(8,str1,"~t")
                xx_inv_value = int(entry(9,str1,"~t")).
 /*     find xx_ship_det where xx_ship_no = xx_inv_no no-error.
           if not available xx_ship_det then do:
	   create xx_ship_det.
	   assign
	        xx_ship_no = xx_inv_no
		xx_ship_line = int(entry(10,str1,"~t"))
		xx_ship_part = entry(11,str1,"~t")
		xx_ship_qty = int(entry(12,str1,"~t"))
                xx_ship_duedate = date(entry(13,str1,"~t"))
                xx_ship_etadate = date(entry(14,str1,"~t"))
                xx_ship_curr = entry(15,str1,"~t")
                xx_ship_rate = decimal(entry(16,str1,"~t"))
                xx_ship_price = int(entry(17,str1,"~t"))
                xx_ship_value = int(entry(18,str1,"~t"))
		xx_ship_site = entry(19,str1,"~t")                      
                xx_ship_vend = entry(20,str1,"~t")                           
                xx_ship_nbr = int(entry(21,str1,"~t"))                         
                xx_ship_case = int(entry(22,str1,"~t"))                         
                xx_ship_pkg = int(entry(23,str1,"~t"))                
                xx_ship_qty_unit = decimal(entry(24,str1,"~t"))                  
                xx_ship_status = entry(25,str1,"~t")             
                xx_ship_rcvd_date = date(entry(26,str1,"~t"))                
                xx_ship_type = entry(27,str1,"~t").
	   end.
	   else 
	   assign
	        xx_ship_line = int(entry(10,str1,"~t"))
		xx_ship_part = entry(11,str1,"~t")
		xx_ship_qty = int(entry(12,str1,"~t"))
                xx_ship_duedate = date(entry(13,str1,"~t"))
                xx_ship_etadate = date(entry(14,str1,"~t"))
                xx_ship_curr = entry(15,str1,"~t")
                xx_ship_rate = decimal(entry(16,str1,"~t"))
                xx_ship_price = int(entry(17,str1,"~t"))
                xx_ship_value = int(entry(18,str1,"~t"))
		xx_ship_site = entry(19,str1,"~t")                      
                xx_ship_vend = entry(20,str1,"~t")                           
                xx_ship_nbr = int(entry(21,str1,"~t"))                         
                xx_ship_case = int(entry(22,str1,"~t"))                         
                xx_ship_pkg = int(entry(23,str1,"~t"))                
                xx_ship_qty_unit = decimal(entry(24,str1,"~t"))                  
                xx_ship_status = entry(25,str1,"~t")             
                xx_ship_rcvd_date = date(entry(26,str1,"~t"))                
                xx_ship_type = entry(27,str1,"~t").
	*/	
   end. /* end do while true*/
   message "导入完成，请检查！".

