/* xxinrctrp02.p  - Inventroy Activity Report - Materials Receiving Financial Report                              */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.     */
/*                  Developped: 10/21/01      BY: kang jian          */
/*  ���ϳ�����������,ʹ��������ʱ�ı�׼�ɱ����� */
/*  ����xxinrctrp02.p �޸� */
/* V6 caculate the amount for iss-tr and iss-wo 03/09/02 By:kangjian  */
/* V7 caculate the 213,214 24/01/03 By:kangjian  */

{mfdtitle.i } 

define variable pr_detail like mfc_logical label "�����ϸ���ļ�'c:\detailrp.txt'" initial no.

/* ���ÿһ�����ͳ�Ʊ������� */
def var qty_iss_so as integer label "���۳�������".
def var sum_iss_so as integer label "���۳���ϼ�".
def var prod_iss_so as integer label "��Ʒ�����۳���ϼ�".
def var sum_iss_unp as integer label "�ƻ������ϼ�".
def var prod_iss_unp as integer label "��Ʒ��ƻ������ϼ�".
def var sum_iss_tr as integer label "�������Ϻϼ�".
def var prod_iss_tr as integer label "��Ʒ���������Ϻϼ�".
def var sum_iss_wo as integer label "�������ĺϼ�".
def var prod_iss_wo as integer label "��Ʒ���������ĺϼ�".

/* qty_iss_unpxxx �������۶��ƴ��붨��ͳ�Ƽƻ��������ϸ */
def var qty_iss_unp as integer label "�ƻ������ϼ�".
def var qty_iss_unp201 as integer label "�̵����".
def var qty_iss_unp203 as integer label "��Ʒ����".
def var qty_iss_unp204 as integer label "��������".
def var qty_iss_unp205 as integer label "���������".
def var qty_iss_unp206 as integer label "���������".
def var qty_iss_unp207 as integer label "��������".
def var qty_iss_unp208 as integer label "����".
def var qty_iss_unp209 as integer label "�豸����".
def var qty_iss_unp210 as integer label "��������".
def var qty_iss_unp211 as integer label "��������".
def var qty_iss_unp212 as integer label "�����".
def var qty_iss_unp213 as integer label "������".
def var qty_iss_unp214 as integer label "���ⱨ��".
def var qty_iss_unp299 as integer label "����".
def var qty_iss_tr as integer label "��������".
def var qty_iss_wo as integer label "��������".

def var qty_issue as integer.
def var lineno as integer.

define variable part like pt_part.
define variable part1 like pt_part.
define variable line like pt_prod_line.
define variable line1 like pt_prod_line.
define variable date like tr_effdate label "��ֹ����".
define variable date1 like tr_effdate.
define variable keeper like pt_article.
define variable keeper1 like pt_article.
define variable site like pt_site.
define variable site1 like pt_site.
define variable pldesc like pl_desc.

form         
skip(1)
     date           label "��ʼ����  "   at 48
     date1          label "��ֹ����  " at 48
     skip(1) 
     with no-box side-labels width 180 frame b.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

 FORM /*GUI*/ 
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
	     site           colon 18
	     site1          label {t001.i} colon 49
	     line           colon 18
	     line1          label {t001.i} colon 49
	     part           colon 18
	     part1          label {t001.i} colon 49 skip
             date            colon 18
             date1           label {t001.i} colon 49 skip
	     keeper            label "����Ա" colon 18
	     keeper1           label {t001.i} colon 49 skip
	     pr_detail		colon 50
  skip
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.


 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = " ѡ������ ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME
/*judy 05/08/05*/ /* SET EXTERNAL LABELS */
/*judy 05/08/05*/  setFrameLabels(frame a:handle).

/*K0ZX*/ {wbrp01.i}

	  /* REPORT BLOCK */

	  
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

	     if part1 = hi_char then part1 = "".
             if line1 = hi_char then line1 = "".
	     if keeper1 = hi_char then keeper1 = "".
	     if site1 = hi_char then site1 = "".
	     if date = low_date then date = ?.
	     if date1 = hi_date then date1 = ?.

	     
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


	     bcdparm = "".

	     {mfquoter.i part   }
	     {mfquoter.i part1   }
	     {mfquoter.i date   }
	     {mfquoter.i date1   }
	     {mfquoter.i keeper   }
	     {mfquoter.i keeper1   }
	     {mfquoter.i site   }
	     {mfquoter.i site1   }
	     {mfquoter.i line   }
	     {mfquoter.i line1   }
	     {mfquoter.i pr_detail   }
	     	     
	     if  part1 = "" then part1 = hi_char.
	     if  line1 = "" then line1 = hi_char.
	     if  keeper1 = "" then keeper1 = hi_char.
	     if  site1 = "" then site1 = hi_char.
	     if  date = ? then date = low_date.
	     if  date1 = ? then date1 = hi_date.
	     /* SELECT PRINTER */
	     
/*GUI*/ end procedure. /* p-report-quote */

/*GUI*/ procedure p-report:

/*GUI*/   {gpprtrpa.i  "printer" 132}
{mfphead.i}
lineno=0.
sum_iss_unp = 0.
sum_iss_so = 0.
sum_iss_tr =0.
sum_iss_wo=0.
for each pt_mstr no-lock where pt_prod_line >= line and pt_prod_line <= line1 and pt_part <= part1 and pt_part >= part and pt_article >= keeper and pt_article <= keeper1
	 and pt_site >= site and pt_site <= site1
	 ,each in_mstr no-lock where in_part = pt_part and in_site >=site and in_site <=site1
	  break by pt_prod_line by pt_part:
    if first-of (pt_prod_line) then do:
         lineno = lineno + 1.
         if lineno<>1 then page.
         find pl_mstr where pl_prod_line = pt_prod_line no-lock no-error.
         pldesc = pl_desc.
         if pr_detail = no then do:
            display date date1 with frame b.
            display pt_prod_line pldesc no-label with width 132 frame c side-labels STREAM-IO.
         end.
         else do:
            output to "c:\detailrp.txt" append.
            display date date1 with frame b.
            display pt_prod_line pldesc no-label with width 132 frame c side-labels STREAM-IO.
       put "�����;" at 1
	"������� ;" at 19 "�������� ;" at 50 "�ܼƻ��� ;" at 60  "�̵���� ;" at 70
	"��Ʒ���� ;" at 80 "�������� ;" at 90 "�����û� ;" at 100 "������� ;" at 110 
	"�������� ;" at 120 "����     ;" at 130 "�豸���� ;" at 140 "�������� ;" at 150
	"�������� ;" at 160 "�����   ;" at 170  "������ ;" at 180	"���ⱨ�� ;" at 190	"�������� ;" at 200   
	"�������� ;" at 210 "�������� " at 220 "���ڳ���ϼ�;"  at 230 skip.
        output close.
         end.
    end.


form header
skip(1)
pt_prod_line pldesc "  (��)" 
with stream-io frame a1 page-top side-labels width 132.
view frame a1.

/* �Ի�������ͳ�Ʊ������� */
qty_issue=0.

qty_iss_so=0.

qty_iss_unp=0.
qty_iss_unp201=0.
qty_iss_unp203=0.
qty_iss_unp204=0.
qty_iss_unp205=0.
qty_iss_unp206=0.
qty_iss_unp207=0.
qty_iss_unp208=0.
qty_iss_unp209=0.
qty_iss_unp210=0.
qty_iss_unp211=0.
qty_iss_unp212=0.
qty_iss_unp213=0.
qty_iss_unp214=0.
qty_iss_unp299=0.

qty_iss_tr=0.
qty_iss_wo=0.


/* ͳ�����۳������ */
for each tr_hist no-lock where tr_part=pt_part and tr_type="iss-so" and tr_effdate>=date and tr_effdate<=date1 and tr_site=in_site:
	qty_iss_so = qty_iss_so - tr_qty_loc.
end.

prod_iss_so = prod_iss_so + qty_iss_so.
sum_iss_so = sum_iss_so + qty_iss_so.


/* ͳ�Ƶ�һ�׶μƻ������ */
for each tr_hist where tr_part=pt_part and tr_type ="iss-UNP" and tr_effdate>=date and tr_effdate<=date1 and tr_site=in_site:
	if	tr_so_job = "201" then do:
		qty_iss_unp201 = qty_iss_unp201 - tr_qty_loc.
		end.
	else if tr_so_job = "203" then do:
		qty_iss_unp203 = qty_iss_unp203 - tr_qty_loc.
		end.
	else if tr_so_job = "204" then do:
		qty_iss_unp204 = qty_iss_unp204 - tr_qty_loc.
		end.
	else if tr_so_job = "205" then do:
		qty_iss_unp205 = qty_iss_unp205 - tr_qty_loc.
		end.
	else if tr_so_job = "206" then do:
		qty_iss_unp206 = qty_iss_unp206 - tr_qty_loc.
		end.
	else if tr_so_job = "207" then do:
		qty_iss_unp207 = qty_iss_unp207 - tr_qty_loc.
		end.
	else if tr_so_job = "208" then do:
		qty_iss_unp208 = qty_iss_unp208 - tr_qty_loc.
		end.
	else if tr_so_job = "209" then do:
		qty_iss_unp209 = qty_iss_unp209 - tr_qty_loc.
		end.
	else if tr_so_job = "210" then do:
		qty_iss_unp210 = qty_iss_unp210 - tr_qty_loc.
		end.
	else if tr_so_job = "211" then do:
		qty_iss_unp211 = qty_iss_unp211 - tr_qty_loc.
		end.
	else if tr_so_job = "212" then do:
		qty_iss_unp212 = qty_iss_unp212 - tr_qty_loc.
		end.
	else if tr_so_job = "213" then do:
		qty_iss_unp213 = qty_iss_unp213 - tr_qty_loc.
		end.
       else if tr_so_job = "214" then do:
		qty_iss_unp214 = qty_iss_unp214 - tr_qty_loc.
		end.
		
	else do:
		qty_iss_unp299 = qty_iss_unp299 - tr_qty_loc.
		end.
end.
qty_iss_unp = (qty_iss_unp201 + qty_iss_unp203 + qty_iss_unp204 + qty_iss_unp205 + qty_iss_unp206 + qty_iss_unp207 + qty_iss_unp208 + qty_iss_unp209 + qty_iss_unp210 + qty_iss_unp211 + qty_iss_unp212 +  qty_iss_unp213 +  qty_iss_unp214 + qty_iss_unp299).
prod_iss_unp = prod_iss_unp + qty_iss_unp.
sum_iss_unp = sum_iss_unp + qty_iss_unp.

/* ͳ�Ƶ�һ�׶β������ó��� */
for each tr_hist where tr_part=pt_part and tr_type ="iss-tr" and tr_effdate>=date and tr_effdate<=date1 and tr_site=in_site:
	qty_iss_tr = qty_iss_tr - tr_qty_loc.
end.
prod_iss_tr = prod_iss_tr + qty_iss_tr.
sum_iss_tr = sum_iss_tr + qty_iss_tr.

/* ͳ�Ƶ�һ�׶β������ĳ��� */
for each tr_hist where tr_part=pt_part and tr_type ="iss-wo" and tr_effdate>=date and tr_effdate<=date1 and tr_site=in_site:
	qty_iss_wo = qty_iss_wo - tr_qty_loc.
end.
prod_iss_wo = prod_iss_wo + qty_iss_tr.
sum_iss_wo = sum_iss_wo + qty_iss_tr.


/* ���ܵ�һ�׶�������� */
qty_issue = qty_iss_so + qty_iss_unp + qty_iss_wo .


if page-size - line-counter < 3 then page.

/* ��ʾ��� */
 if not (qty_iss_so =0 and  qty_iss_unp = 0 ) then do:
 if pr_detail = yes then do:
	output to "c:\detailrp.txt" append.
 	put pt_part
 	pt_desc2
 	qty_iss_so ";"
 	qty_iss_unp ";"
 	qty_iss_unp201 ";"
 	qty_iss_unp203 ";"
 	qty_iss_unp204 ";"
 	qty_iss_unp205 ";"
 	qty_iss_unp206 ";"
 	qty_iss_unp207 ";"
 	qty_iss_unp208 ";"
 	qty_iss_unp209 ";"
 	qty_iss_unp210 ";"
 	qty_iss_unp211 ";"
 	qty_iss_unp212 ";"
 	qty_iss_unp213 ";"
 	qty_iss_unp214 ";"
 	qty_iss_unp299 ";"
 	qty_iss_tr ";"
 	qty_iss_wo
 	qty_issue ";"
       skip.
 	output close.
 	end. 
 else 
 disp pt_part column-label "�����;" ";" pt_desc2 column-label "�������;" ";"  pt_um column-label "��λ;" ";"
 qty_iss_so column-label "��������;"  ";" 
 qty_iss_unp column-label "�ƻ������ϼ�;"  ";" 
 qty_iss_tr column-label "������������;" ";" 
 qty_iss_wo column-label "������������" ";" 
 qty_issue column-label "���ڳ���ϼ�;" ";" 

 with width 256  STREAM-IO  .
 end.
 
 if last-of(pt_prod_line) then do:
   if pr_detail = yes then do:
       output to "c:\detailrp.txt" append.
       display "��Ʒ��ϼƣ�" with frame z4 STREAM-IO.
       display prod_iss_so column-label "���۳�������;" ";"  prod_iss_unp column-label "�ƻ����������;" ";" 
       prod_iss_tr column-label "��������;" ";"  prod_iss_wo column-label "��������;" ";"  with width 200 frame z1 stream-io.
       output close.
   end.
   else do:
       display "��Ʒ��ϼƣ�" with frame z2 STREAM-IO.
       display prod_iss_so  column-label "���۳�������;" ";"  prod_iss_unp column-label "�ƻ����������;" ";" 
       prod_iss_tr column-label "��������;" ";" prod_iss_wo column-label "��������;" ";" with width 200 frame z  STREAM-IO .
   end.
   prod_iss_so=0.
   prod_iss_unp = 0.
   prod_iss_tr=0.
   prod_iss_wo=0.
 end.
end.

  if pr_detail = yes then do:
       output to "c:\detailrp.txt" append.
       display "�ڼ�ϼ�:" with frame y4 STREAM-IO .
       disp sum_iss_so column-label "���۳�������;" ";"  sum_iss_unp column-label "�ƻ����������;" ";"
       sum_iss_tr column-label "��������;" ";" sum_iss_wo column-label "��������;" ";"  with frame y1 stream-io .
       output close.
   end.
   else do:

       display "�ڼ�ϼ�:" with frame y2 STREAM-IO .
       disp sum_iss_so column-label "���۳�������;" ";"  sum_iss_unp column-label "�ƻ����������;" ";"
       sum_iss_tr column-label "��������;" ";" sum_iss_wo column-label "��������;" ";"  with frame y side-labels STREAM-IO WIDTH 200 .
   end.
 
/*judy 05/08/19*/   
   sum_iss_tr = 0.
   sum_iss_so = 0. 
   sum_iss_unp = 0.
   sum_iss_wo = 0.  
/*judy 05/08/19*/ 

{mfguitrl.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
 
end procedure.
/*K0ZX*/ {wbrp04.i &frame-spec = a} 


/*GUI*/ {mfguirpb.i &flds=" site site1 line line1 part part1 date date1 keeper keeper1  pr_detail "} /*Drive the Report*/



