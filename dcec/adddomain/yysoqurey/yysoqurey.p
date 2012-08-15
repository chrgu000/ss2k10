/* xxunrp.p  - UNPLANNED RECEIPTS PRINT                               */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* V1                 Developped: 07/19/01      BY: Kang Jian          */

{mfdtitle.i}
define temp-table soqry field soqry_cust like so_cust
                        field soqry_name like pt_desc2
                         field soqry_nbr like so_nbr
                         field soqry_line like sod_line
                         field soqry_part like sod_part
                         field soqry_qty_ord like sod_qty_ord
                         field soqry_short like sod_qty_ord
                         field soqry_um like sod_um
                         field soqry_due_date like sod_due_date
                         field soqry_ord_date like so_ord_date
                         field soqry_site like sod_site
                         field soqry_rmks like so_rmks   
                         field soqry_usr like so_userid                      
                         index soqry_ord_date is primary soqry_ord_date descending .  

/*start of define the value */
def var cust like so_cust.
def var cust1 like so_cust.
def var sonbr_from as char .
def var sonbr_to     as char .
def var duedate_from as date . /*到期日*/
def var duedate_to     as date .
def  var indate_from as date.  /*进单日*/
def var indate_to as date.
def var site1 like sod_site.
def var site2 like sod_site.
def var pageno as integer.
def var pdate  as date initial today.    /*打印日期*/
def var i          as integer.
def var qty like sod_qty_ord label "短缺量" .
/*end of define the value*/

/*start report title*/
form "客户订单报表"      at  48    skip(2)
     pageno        label "页号"       at 1
     pdate         label "打印日期   "   at 60 skip(2)
     "客户订单   销往客户      序  零件号                   订货量    短缺量UM    到期日   地点        进单日     创建" at 1 skip
      "--------------------------------------------------------------------------------------------------------------"
     with no-box side-labels width 180 frame b.
/*end of report title*/     
     
/*start soqry  preference */

/*start format of soqry screen*/
&SCOPED-DEFINE PP_FRAME_NAME A
FORM      
RECT-FRAME       AT ROW 1.4 COLUMN 1.25
RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
SKIP(.1)  
cust  colon 30 label "客户代码" 
cust1  colon 50 label "至" skip
sonbr_from  colon 30 label "客户定单" 
sonbr_to  colon 50 label "至" skip
duedate_from colon 30 label "到期日"
duedate_to colon 50 label "至" skip
/*--Jch040608
indate_from colon 30 label "进单日"
indate_to colon 50 label "至" skip
*/
site1 colon 30 label "地点"
site2 colon 50 label "至" skip
with frame a side-labels width 80 attr-space NO-BOX THREE-D.
 

DEFINE VARIABLE F-a-title AS CHARACTER.
F-a-title = " 选择条件 ".
RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
RECT-FRAME:HEIGHT-PIXELS in frame a =
FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.
&UNDEFINE PP_FRAME_NAME	  
{mfguirpa.i true  "window" 132 }
/*end format of soqry screen*/

/*start soqry preference initialize*/
/*start procefuer p-enable-ui*/
procedure p-enable-ui:
if cust1    = hi_char  then cust1 = "". 
if sonbr_to    = hi_char  then sonbr_to = "". 
if duedate_from  = low_date then duedate_from = ?. 
if duedate_to    = hi_date  then duedate_to = ?.
if indate_from = low_date then indate_from = ?.
if indate_to = hi_date then indate_to = ?.
     
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. 
/*end procefuer p-enable-ui*/
/*end soqry preference initialize*/

/*start procedure of p-report-quote*/
/*start receive soqry preference*/
procedure p-report-quote:
bcdparm = "".
{mfquoter.i cust1} 
{mfquoter.i sonbr_from} 
{mfquoter.i sonbr_to} 
{mfquoter.i duedate_from} 
{mfquoter.i duedate_to} 
{mfquoter.i indate_from} 
{mfquoter.i indate_to} 
/*end receive soqry preference*/

/*start check the validity of soqry preference*/
if cust1     = ""  then cust1 = hi_char. 
if sonbr_to     = ""  then sonbr_to = hi_char. 
if duedate_from  = ?   then duedate_from = low_date. 
if duedate_to    = ?   then duedate_to = hi_date.
if indate_from  = ?   then indate_from = low_date. 
if indate_to    = ?   then indate_to = hi_date.
/*end check the validity of soqry preference*/
end procedure. 
/*end procedure of p-report-quote*/

/*end soqry  preference */

/*start procedure of p-report*/
/*start report out put*/
procedure p-report:
  {gpprtrpa.i  "window" 132}                               
  pageno = 1.
  i = 1.
  for each so_mstr no-lock where so_nbr >= sonbr_from and so_nbr <= sonbr_to  
                         /*and (so_ord_date >= indate_from) and (so_ord_date <= indate_to)*/
                         and so_cust >= cust and so_cust <= cust1
                         use-index so_nbr ,
       each sod_det no-lock where sod_nbr = so_nbr 
                         and (sod_due_date >= duedate_from)
                         and (sod_due_date <= duedate_to)
                         and (sod_site >= site1)
                         and (sod_site <= site2)
                         use-index sod_nbr
                         with width 132 no-attr-space:
      create soqry.
      soqry_usr=so_userid.
      soqry_nbr=so_nbr.
      soqry_cust=so_cust.
      soqry_part=sod_part.
      soqry_line=sod_line.
      soqry_qty_ord=sod_qty_ord.
      soqry_short=sod_qty_ord.
      soqry_due_date=sod_due_date.
      soqry_um=sod_um.
      soqry_ord_date=so_ord_date.
      soqry_site=sod_site.
      soqry_rmks=so_rmks.
      soqry_short=sod_qty_ord - sod_qty_ship.         
      find first pt_mstr where pt_part=sod_part.
      if available pt_mstr then  soqry_name = pt_desc2 .
  end.             
 
/*start of for each*/
            
  for each soqry use-index soqry_ord_date break by soqry_cust by soqry_due_date :
           if i=1 then do:
                display pageno pdate with frame b STREAM-IO .
                i=i + 4.
           end.
           
           disp soqry_nbr soqry_cust soqry_line soqry_part soqry_qty_ord  soqry_short soqry_um soqry_due_date soqry_site format "x(7)" soqry_ord_date soqry_usr with no-box no-labels width 132 frame c DOWN STREAM-IO .
           if soqry_rmks <> "" then 
                disp space(20) soqry_name "备注:" soqry_rmks  with width 132 frame ff no-labels STREAM-IO.
           else
                disp space(20) soqry_name with width 132 frame ff no-labels STREAM-IO .                    
           disp "--------------------------------------------------------------------------------------------------------------"
                with width 132 no-box frame f1 STREAM-IO .  
           i=i + 2.                                         
           if line-counter >= (page-size - 7) then do:
              display "计划员：                                        经理："   at 1
                  with width 132 no-box frame d STREAM-IO .  
              page.
              i=1.
              pageno = pageno + 1.
           end.
  end.
  for each  soqry:
      delete soqry.
  end.


  {mfphead.i}
 
/* reset variable */
{mfreset.i} 
{mfgrptrm.i}
end procedure.  
/* end report out put */

/* cycle drive the soqry output */
{mfguirpb.i &flds="cust cust1 sonbr_from sonbr_to duedate_from duedate_to /*indate_from indate_to*/ site1 site2"}

