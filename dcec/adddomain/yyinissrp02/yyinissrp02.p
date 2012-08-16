/* xxinrctrp02.p  - Inventroy Activity Report - Materials Receiving Financial Report                              */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.     */
/*                  Developped: 10/21/01      BY: kang jian          */
/*  ���ϳ�����������,ʹ��������ʱ�ı�׼�ɱ����� */
/*  ����xxinrctrp02.p �޸� */
/* V5 caculate the amount of  standart cost adjust 08/08/02 By:kangjian  var:amt_cst */
/* V6 caculate the amount for iss-tr  03/09/02 By:kangjian  var:qty_iss_tr,amt_iss_tr,prod_iss_tr,sum_iss_tr */
/* V7 caculate the amount for iss-tr  03/09/02 By:kangjian  var: 213�����Ʊ��� 214���ⷶΧ�ı��� */
/* V7 caculate the amount for iss-tr  26/04/03 By:Zhang weihua  var: ����������Ʒ����*/
{mfdtitle.i "120816.1"} 

define variable pr_detail like mfc_logical label "�����ϸ���ļ�'c:\detailrp.txt'" initial no.

/* ���ÿһ�����ͳ�Ʊ������� */
def var qty_iss_so as integer label "���۳�������".
def var amt_iss_so as decimal format "->>>,>>>,>>9.99" label "���۳�����".
def var sum_iss_so as decimal format "->>>,>>>,>>9.99" initial 0 label "���۳�����ϼ�".
def var prod_iss_so as decimal format "->>>,>>>,>>9.99" initial 0 label "��Ʒ�����۳�����ϼ�".
def var sum_iss_unp as decimal format "->>>,>>>,>>9.99" initial 0 label "�ƻ��������ϼ�".
def var prod_iss_unp as decimal format "->>>,>>>,>>9.99" initial 0 label "��Ʒ��ƻ��������ϼ�".

def var sum_iss_tr as decimal format "->>>,>>>,>>9.99" initial 0 label "�������Ͻ��".
def var prod_iss_tr as decimal format "->>>,>>>,>>9.99" initial 0 label "��Ʒ���������Ϻϼ�".

def var sum_iss_wo as decimal format "->>>,>>>,>>9.99" initial 0 label "���������ܶ�".
def var sum_iss_wt as decimal format "->>>,>>>,>>9.99" initial 0 label "ί�м����".
def var sum_iss_pl as decimal format "->>>,>>>,>>9.99" initial 0 label "��ί�м����".
def var prod_iss_wo as decimal format "->>>,>>>,>>9.99" initial 0 label "��Ʒ���������ĺϼ�".
def var prod_iss_wt as decimal format "->>>,>>>,>>9.99" initial 0 label "��Ʒ��ί�м����".
def var prod_iss_pl as decimal format "->>>,>>>,>>9.99" initial 0 label "��Ʒ���ί�м����".
def var prod_issue as decimal format "->>>,>>>,>>9.99" initial 0 label "��Ʒ�������ϼ�".
def var prod_iss as decimal format "->>>,>>>,>>9.99" initial 0 label "��Ʒ�������ϼ�".
def var prod_iss_201 as decimal format "->>>,>>>,>>9.99" initial 0 label "��Ʒ��201���ϼ�".
def var prod_iss_203 as decimal format "->>>,>>>,>>9.99" initial 0 label "��Ʒ��203���ϼ�".
def var prod_iss_204 as decimal format "->>>,>>>,>>9.99" initial 0 label "��Ʒ��204���ϼ�".
def var prod_iss_205 as decimal format "->>>,>>>,>>9.99" initial 0 label "��Ʒ��205���ϼ�".
def var prod_iss_206 as decimal format "->>>,>>>,>>9.99" initial 0 label "��Ʒ��206���ϼ�".
def var prod_iss_207 as decimal format "->>>,>>>,>>9.99" initial 0 label "��Ʒ��207���ϼ�".
def var prod_iss_208 as decimal format "->>>,>>>,>>9.99" initial 0 label "��Ʒ��208���ϼ�".
def var prod_iss_209 as decimal format "->>>,>>>,>>9.99" initial 0 label "��Ʒ��209���ϼ�".
def var prod_iss_210 as decimal format "->>>,>>>,>>9.99" initial 0 label "��Ʒ��210���ϼ�".
def var prod_iss_211 as decimal format "->>>,>>>,>>9.99" initial 0 label "��Ʒ��211���ϼ�".
def var prod_iss_212 as decimal format "->>>,>>>,>>9.99" initial 0 label "��Ʒ��212���ϼ�".
def var prod_iss_213 as decimal format "->>>,>>>,>>9.99" initial 0 label "��Ʒ��213���ϼ�".
def var prod_iss_214 as decimal format "->>>,>>>,>>9.99" initial 0 label "��Ʒ��214���ϼ�".
def var prod_iss_215 as decimal format "->>>,>>>,>>9.99" initial 0 label "��Ʒ��215���ϼ�".   /*zwh*/
def var prod_iss_299 as decimal format "->>>,>>>,>>9.99" initial 0 label "��Ʒ��299���ϼ�".
def var prod_iss_fas as decimal format "->>>,>>>,>>9.99" initial 0 label "�׼����۽��ϼ�".
def var sum_iss_fas as decimal format "->>>,>>>,>>9.99" initial 0 label "�׼����۽��ϼ�".
/* qty_iss_unpxxx �������۶��ƴ��붨��ͳ�Ƽƻ��������ϸ */
def var qty_iss_unp as integer label "�ƻ������ϼ�".
def var amt_iss_unp as decimal format "->>>,>>>,>>9.99" label "���".
def var qty_iss_unp201 as integer label "�̵����".
def var amt_iss_unp201 as decimal format "->>>,>>>,>>9.99" label "���".
def var qty_iss_unp203 as integer label "��Ʒ����".
def var amt_iss_unp203 as decimal format "->>>,>>>,>>9.99" label "���".
def var qty_iss_unp204 as integer label "�����������".
def var amt_iss_unp204 as decimal format "->>>,>>>,>>9.99" label "���".
def var qty_iss_unp205 as integer label "�����û�����".
def var amt_iss_unp205 as decimal format "->>>,>>>,>>9.99" label "���".
def var qty_iss_unp206 as integer label "���������".
def var amt_iss_unp206 as decimal format "->>>,>>>,>>9.99" label "���".
def var qty_iss_unp207 as integer label "��������".
def var amt_iss_unp207 as decimal format "->>>,>>>,>>9.99" label "���".
def var qty_iss_unp208 as integer label "����".
def var amt_iss_unp208 as decimal format "->>>,>>>,>>9.99" label "���".
def var qty_iss_unp209 as integer label "�豸����".
def var amt_iss_unp209 as decimal format "->>>,>>>,>>9.99" label "���".
def var qty_iss_unp210 as integer label "��������".
def var amt_iss_unp210 as decimal format "->>>,>>>,>>9.99" label "���".
def var qty_iss_unp211 as integer label "��������".
def var amt_iss_unp211 as decimal format "->>>,>>>,>>9.99" label "���".
def var qty_iss_unp212 as integer label "�����".
def var amt_iss_unp212 as decimal format "->>>,>>>,>>9.99" label "���".
def var qty_iss_unp213 as integer label "��������-ATPU".
def var amt_iss_unp213 as decimal format "->>>,>>>,>>9.99" label "���".
def var qty_iss_unp214 as integer label "��������-����".
def var amt_iss_unp214 as decimal format "->>>,>>>,>>9.99" label "���".
def var qty_iss_unp215 as integer label "������Ʒ��ʧ". /*zwh*/
def var amt_iss_unp215 as decimal format "->>>,>>>,>>9.99" label "���". /*zwh*/
def var qty_iss_unp299 as integer label "����".
def var amt_iss_unp299 as decimal format "->>>,>>>,>>9.99" label "���".

def var qty_iss_tr as integer label "�������Ϻϼ�".
def var amt_iss_tr as decimal format "->>>,>>>,>>9.99" label "���".


def var qty_iss_wo as integer label "�������ĺϼ�".
def var amt_iss_wo as decimal format "->>>,>>>,>>9.99" label "���".
def var qty_iss_wt as integer label "ί������".
def var amt_iss_wt as decimal format "->>>,>>>,>>9.99" label "���".
def var qty_iss_pl as integer label "��������".
def var amt_iss_pl as decimal format "->>>,>>>,>>9.99" label "���".

def var qty_iss_fas as integer label "�׼�����".
def var amt_iss_fas as decimal format "->>>,>>>,>>9.99" label "���".

def var amt_cst as decimal format "->>>,>>>,>>9.99" label "�ɱ��������".
def var prod_cst as decimal format "->>>,>>>,>>>,>>9.99" initial 0 label "�ɱ��������".
def var sum_cst as decimal format "->>>,>>>,>>>,>>9.99" initial 0 label "�ɱ��������".

def var qty_issue as integer.
def var amt_issue as decimal format "->>>,>>>,>>9.99".

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
for each pt_mstr no-lock where pt_domain = global_domain 
		 and pt_prod_line >= line and pt_prod_line <= line1 
		 and pt_part <= part1 and pt_part >= part 
		 and pt_article >= keeper and pt_article <= keeper1
	 and pt_site >= site and pt_site <= site1
	 ,each in_mstr no-lock where in_domain = global_domain 
	 	 and in_part = pt_part and in_site >=site and in_site <=site1
	  break by pt_prod_line by pt_part:
    if first-of (pt_prod_line) then do:
         lineno = lineno + 1.
         if lineno<>1 then page.
         find pl_mstr where pl_domain = global_domain 
          and pl_prod_line = pt_prod_line no-lock no-error.
         assign pldesc = "".
         if available pl_mstr then do:
         		pldesc = pl_desc.
         end.
         if pr_detail = no then do:
            display date date1 with frame b.
            display pt_prod_line pldesc no-label with width 132 frame c side-labels STREAM-IO.
         end.
         else do:
            output to "c:\detailrp.txt" append.
           display date date1 with frame b.
            display pt_prod_line pldesc no-label with width 132 frame c side-labels STREAM-IO.         
              put "�����" at 1
	     ";�������" at 19 ";��������" at 50 	";���" at 64 	";�ƻ���ϼ�" at 69 ";���" at 89
	      ";�̵����" at 96 ";���" at 114  ";��Ʒ����" at 120 ";���" at 139 ";�����������" at 145
	      ";���" at 164 ";�����û�����" at 170 ";���" at 189 ";���������" at 195 ";���" at 215
	     ";��������" at 220 ";���" at 239 ";����" at 250 ";���" at 264 ";�豸����" at 270 ";���" at 289
	      ";��������" at 295 ";���" at 314  ";��������" at 319 ";���" at 339 ";�����" at 348 ";���" at 364
	       ";��������-ATPU" at 370 ";���" at 389    ";��������-����" at 394 ";���" at 414   
     /*zwh*/   ";������Ʒ��ʧ" at 419  ";���" at 439  ";�����ƻ���" at 446  ";���" at 464 
	       ";�������ĺϼ�" at 475 ";���"  at 489 
	       ";ί�м�����"  at 496 ";���" at 514 ";��ί�м�����" at 520 ";���" at 535
	       ";��������" at 555 ";���" at 570 
	      ";�׼�����" at 590 ";���" at 605 ";���ںϼ�" at 625 ";���" at 645 ";�ɱ�������" at 665 skip.
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
qty_iss_unp215=0. /*zwh*/
qty_iss_unp299=0.


qty_iss_wo=0.
qty_iss_pl=0.
qty_iss_wt=0.
qty_iss_fas=0.
amt_iss_fas=0.
qty_iss_tr=0.
amt_iss_tr=0.

/* �Ի��ܽ��������� */
amt_issue=0.

amt_iss_so=0.

amt_iss_unp=0.
amt_iss_unp201=0.
amt_iss_unp203=0.
amt_iss_unp204=0.
amt_iss_unp205=0.
amt_iss_unp206=0.
amt_iss_unp207=0.
amt_iss_unp208=0.
amt_iss_unp209=0.
amt_iss_unp210=0.
amt_iss_unp211=0.
amt_iss_unp212=0.
amt_iss_unp213=0.
amt_iss_unp214=0.
amt_iss_unp215=0. /*zwh*/
amt_iss_unp299=0.

amt_iss_wo=0.
amt_iss_pl=0.
amt_iss_wt=0.
amt_cst=0.


/* ͳ���׼����۳������ */
for each tr_hist no-lock where tr_domain = global_domain 
		 and tr_part=pt_part and tr_type="iss-fas" 
		 and tr_effdate>=date and tr_effdate<=date1 and tr_site=in_site:
	qty_iss_fas = qty_iss_fas - tr_qty_loc.
	amt_iss_fas = amt_iss_fas - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
end. 

prod_iss_fas = prod_iss_fas + amt_iss_fas.
sum_iss_fas = sum_iss_fas + amt_iss_fas. 

/* ͳ�����۳������ */
for each tr_hist no-lock where tr_domain = global_domain 
		 and tr_part=pt_part and (tr_type="iss-so" and tr_ship_type<>"m") 
		 and tr_effdate>=date and tr_effdate<=date1 and tr_site=in_site:
	qty_iss_so = qty_iss_so - tr_qty_loc.
	amt_iss_so = amt_iss_so - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
end.

prod_iss_so = prod_iss_so + amt_iss_so .
sum_iss_so = sum_iss_so + amt_iss_so .


/* ͳ�Ƶ�һ�׶μƻ������ */
for each tr_hist where tr_domain = global_domain 
		 and tr_part=pt_part and tr_type ="iss-UNP" 
		 and tr_effdate>=date and tr_effdate<=date1 and tr_site=in_site:
	if	tr_so_job = "201" then do:
		qty_iss_unp201 = qty_iss_unp201 - tr_qty_loc.
		amt_iss_unp201 = amt_iss_unp201 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else if tr_so_job = "203" then do:
		qty_iss_unp203 = qty_iss_unp203 - tr_qty_loc.
		amt_iss_unp203 = amt_iss_unp203 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else if tr_so_job = "204" then do:
		qty_iss_unp204 = qty_iss_unp204 - tr_qty_loc.
		amt_iss_unp204 = amt_iss_unp204 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else if tr_so_job = "205" then do:
		qty_iss_unp205 = qty_iss_unp205 - tr_qty_loc.
		amt_iss_unp205 = amt_iss_unp205 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else if tr_so_job = "206" then do:
		qty_iss_unp206 = qty_iss_unp206 - tr_qty_loc.
		amt_iss_unp206 = amt_iss_unp206 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else if tr_so_job = "207" then do:
		qty_iss_unp207 = qty_iss_unp207 - tr_qty_loc.
		amt_iss_unp207 = amt_iss_unp207 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else if tr_so_job = "208" then do:
		qty_iss_unp208 = qty_iss_unp208 - tr_qty_loc.
		amt_iss_unp208 = amt_iss_unp208 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else if tr_so_job = "209" then do:
		qty_iss_unp209 = qty_iss_unp209 - tr_qty_loc.
		amt_iss_unp209 = amt_iss_unp209 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else if tr_so_job = "210" then do:
		qty_iss_unp210 = qty_iss_unp210 - tr_qty_loc.
		amt_iss_unp210 = amt_iss_unp210 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else if tr_so_job = "211" then do:
		qty_iss_unp211 = qty_iss_unp211 - tr_qty_loc.
		amt_iss_unp211 = amt_iss_unp211 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else if tr_so_job = "212" then do:
		qty_iss_unp212 = qty_iss_unp212 - tr_qty_loc.
		amt_iss_unp212 = amt_iss_unp212 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else if tr_so_job = "213" then do:
		qty_iss_unp213 = qty_iss_unp213 - tr_qty_loc.
		amt_iss_unp213 = amt_iss_unp213 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
       else if tr_so_job = "214" then do:
		qty_iss_unp214 = qty_iss_unp214 - tr_qty_loc.
		amt_iss_unp214 = amt_iss_unp214 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
/*add unplan reject issue  --zwh*/     
       else if tr_so_job = "215" then do:
		qty_iss_unp215 = qty_iss_unp215 - tr_qty_loc.
		amt_iss_unp215 = amt_iss_unp215 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
/* --zwh*/		
	else do:
		qty_iss_unp299 = qty_iss_unp299 - tr_qty_loc.
		amt_iss_unp299 = amt_iss_unp299 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
end.
qty_iss_unp = (qty_iss_unp201 + qty_iss_unp203 + qty_iss_unp204 + qty_iss_unp205 + qty_iss_unp206 + qty_iss_unp207 + qty_iss_unp208 + qty_iss_unp209 + qty_iss_unp210 + qty_iss_unp211 + qty_iss_unp212 + qty_iss_unp213 + qty_iss_unp214 + qty_iss_unp215 + qty_iss_unp299).
amt_iss_unp = (amt_iss_unp201 + amt_iss_unp203 + amt_iss_unp204 + amt_iss_unp205 + amt_iss_unp206 + amt_iss_unp207 + amt_iss_unp208 + amt_iss_unp209 + amt_iss_unp210 + amt_iss_unp211 + amt_iss_unp212 + amt_iss_unp213 + amt_iss_unp214 + amt_iss_unp215 + amt_iss_unp299).
prod_iss_unp = prod_iss_unp + amt_iss_unp.
sum_iss_unp = sum_iss_unp + amt_iss_unp.
prod_iss_201 = prod_iss_201 + amt_iss_unp201.
prod_iss_203 = prod_iss_203 + amt_iss_unp203.
prod_iss_204 = prod_iss_204 + amt_iss_unp204.
prod_iss_205 = prod_iss_205 + amt_iss_unp205.
prod_iss_206 = prod_iss_206 + amt_iss_unp206.
prod_iss_207 = prod_iss_207 + amt_iss_unp207.
prod_iss_208 = prod_iss_208 + amt_iss_unp208.
prod_iss_209 = prod_iss_209 + amt_iss_unp209.
prod_iss_210 = prod_iss_210 + amt_iss_unp210.
prod_iss_211 = prod_iss_211 + amt_iss_unp211.
prod_iss_212 = prod_iss_212 + amt_iss_unp212.
prod_iss_213 = prod_iss_213 + amt_iss_unp213.
prod_iss_214 = prod_iss_214 + amt_iss_unp214.
prod_iss_215 =prod_iss_215 + amt_iss_unp215. /*zwh*/
prod_iss_299 = prod_iss_299 + amt_iss_unp299.
prod_iss = prod_iss + prod_iss_unp + prod_iss_so .
/* ͳ�Ƶ�һ�׶��������ĳ��� */
for each tr_hist where tr_domain = global_domain 
		 and tr_part=pt_part and tr_type ="iss-wo" 
		 and tr_effdate>=date and tr_effdate<=date1 and tr_site=in_site:
	qty_iss_wo = qty_iss_wo - tr_qty_loc.
	amt_iss_wo = amt_iss_wo - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
	if substring(tr_nbr,1,1)="S" then do:
          qty_iss_wt = qty_iss_wt - tr_qty_loc.
	   amt_iss_wt = amt_iss_wt - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
	end.
	else do:
          qty_iss_pl = qty_iss_pl - tr_qty_loc.
	   amt_iss_pl = amt_iss_pl - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
	end.
end.
prod_iss_wo = prod_iss_wo + amt_iss_wo.
sum_iss_wo = sum_iss_wo + amt_iss_wo.
prod_iss_wt=prod_iss_wt + amt_iss_wt.
sum_iss_wt = sum_iss_wt + amt_iss_wt.
prod_iss_pl=prod_iss_pl + amt_iss_pl.
sum_iss_pl = sum_iss_pl + amt_iss_pl.



/* ͳ�Ƶ�һ�׶��������ϳ��� */
for each tr_hist where tr_domain = global_domain 
	   and tr_part=pt_part and tr_type ="iss-tr" 
	   and tr_effdate>=date and tr_effdate<=date1 and tr_site=in_site:
	qty_iss_tr = qty_iss_tr - tr_qty_loc.
	amt_iss_tr = amt_iss_tr - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
end.
prod_iss_tr = prod_iss_tr + amt_iss_tr.
sum_iss_tr = sum_iss_tr + amt_iss_tr.


/*��׼�ɱ�����*/
for each tr_hist where tr_domain = global_domain 
		 and tr_part=pt_part and tr_type ="cst-adj" 
		 and tr_effdate>=date and tr_effdate<=date1 and tr_site=in_site:
	amt_cst = amt_cst + tr_price * tr_loc_begin.
end.
prod_cst=prod_cst + amt_cst.
sum_cst=sum_cst + amt_cst.


/* ���ܵ�һ�׶�������� */
qty_issue = qty_iss_so + qty_iss_unp + qty_iss_wo + qty_iss_fas .
amt_issue = amt_iss_so + amt_iss_unp + amt_iss_wo + amt_iss_fas.
prod_issue = prod_issue + amt_issue.


if page-size - line-counter < 3 then page.

/* ��ʾ��� */
 if not (qty_iss_so =0 and  qty_iss_unp = 0  and qty_iss_wo = 0 and amt_cst=0 ) then do:
 if pr_detail = yes then do:
	output to "c:\detailrp.txt" append.
 	put pt_part ";"
 	pt_desc2 ";"
 	qty_iss_so ";"
 	amt_iss_so ";"
 	qty_iss_unp ";"
 	amt_iss_unp ";"
 	qty_iss_unp201 ";"
 	amt_iss_unp201 ";"
 	qty_iss_unp203 ";"
 	amt_iss_unp203 ";"
 	qty_iss_unp204 ";"
 	amt_iss_unp204 ";"
 	qty_iss_unp205 ";"
 	amt_iss_unp205 ";"
 	qty_iss_unp206 ";"
 	amt_iss_unp206 ";"
 	qty_iss_unp207 ";"
 	amt_iss_unp207 ";"
 	qty_iss_unp208 ";"
 	amt_iss_unp208 ";"
 	qty_iss_unp209 ";"
 	amt_iss_unp209 ";"
 	qty_iss_unp210 ";"
 	amt_iss_unp210 ";"
 	qty_iss_unp211 ";"
 	amt_iss_unp211 ";"
 	qty_iss_unp212 ";"
 	amt_iss_unp212 ";"
 	qty_iss_unp213 ";"
 	amt_iss_unp213 ";"
 	qty_iss_unp214 ";"
 	amt_iss_unp214 ";"
 	qty_iss_unp215 ";"  /*zwh*/
 	amt_iss_unp215 ";"  /*zwh*/
 	qty_iss_unp299 ";"
 	amt_iss_unp299 ";"
 	qty_iss_wo ";"
 	amt_iss_wo ";"
 	qty_iss_wt ";"
 	amt_iss_wt ";"
 	qty_iss_pl ";"
 	amt_iss_pl ";"
 	qty_iss_tr ";"
 	amt_iss_tr ";"
 	qty_iss_fas ";"
 	amt_iss_fas ";"
       qty_issue  ";"
       amt_issue  ";"
       amt_cst
  	skip.
 	output close.
 end. 
 else 
 disp pt_part column-label "�����" ";" pt_desc2 column-label ";�������" ";" pt_um column-label ";��λ" ";"
 qty_iss_so column-label ";��������" ";" amt_iss_so column-label ";���" ";"
 qty_iss_fas column-label ";�׼�����" ";" amt_iss_fas column-label ";���" ";"
 qty_iss_unp column-label ";�ƻ������ϼ�" ";" amt_iss_unp column-label ";���"  ";"
 qty_iss_wo column-label ";�������ĺϼ�" ";" amt_iss_wo column-label ";���" ";"
 qty_iss_wt column-label ";ί�м�����" ";" amt_iss_wt column-label ";���" ";"
 qty_iss_pl column-label ";��ί�м�����" ";" amt_iss_pl column-label ";���" ";"
 qty_iss_tr column-label ";��������" ";" amt_iss_tr column-label ";���" ";"
 qty_issue column-label ";���ڳ���ϼ�" ";" amt_issue column-label ";������" ";" amt_cst column-label ";�ɱ�������"
 with width 350  STREAM-IO .
 end.
 if last-of(pt_prod_line) then do:
   if pr_detail = yes then do:
       output to "c:\detailrp.txt" append.
       put "��Ʒ��ϼ�:" at 1       
	";�������۽��" at 57 	";�ƻ����ܶ�" at 83 ";�̵�������" at 107	
	";��Ʒ���ͽ��" at 132 ";����������Ͻ��" at 157 ";�����û������" at 181 ";������������" at 204
	";�����������" at 231 ";���ͽ��" at 260 ";�豸���Խ��" at 281 ";�������ý��" at 306
	";�������۽��" at 331 ";��������" at 358 ";��������-ATPU" at 379 ";��������-����" at 406
        ";������Ʒ��ʧ" at 431  ";�����������" at 456
        ";���������ܽ��" at 481 
	";ί�м�����" at 506  ";��ί�м�����" at 531	
	";�������Ͻ��" at 556
	";�׼����۽��" at 581
	";���ڳ����ܶ�" at 606  ";�ɱ�������" at 631 skip.
       put pt_prod_line at 1 ";" 
       prod_iss_so  at 53 ";" prod_iss_unp at 78  ";"
	prod_iss_201 at 103	 ";"
	prod_iss_203 at 128   ";" 
	prod_iss_204 at 153   ";" 
	prod_iss_205 at 178  ";"
	prod_iss_206 at 203  ";"
	prod_iss_207 at 228  ";"
	prod_iss_208 at 253  ";"
	prod_iss_209 at 278  ";"
	prod_iss_210 at 303  ";"
	prod_iss_211 at 328  ";"
	prod_iss_212 at 353  ";"
	prod_iss_213 at 378  ";"
	prod_iss_214 at 403  ";"
	prod_iss_215 at 428  ";"                   /*zwh*/
	prod_iss_299 at 453  ";"
	prod_iss_wo at 478  ";"
	prod_iss_wt at 503  ";"
	prod_iss_pl at 528  ";"
	prod_iss_tr at 553 ";"
	prod_iss_fas at 578  ";"
	prod_issue at 593 ";"
	prod_cst at 618 skip.
       output close.
   end.
   else do:
       display "��Ʒ��ϼ�:" with frame z2.
       display prod_iss_so  column-label "���۳�����" ";" prod_iss_fas column-label ";�׼����۽��" ";"
        prod_iss_unp column-label ";�ƻ��������" ";" prod_iss_wo column-label ";�������ĺϼƽ��" ";" 
        prod_iss_wt column-label ";ί�м�����" ";"  prod_iss_pl column-label ";��ί�м�����" ";" 
        prod_iss_tr column-label ";�������Ͻ��" ";"
        prod_issue column-label ";�����ܼƽ��" ";" prod_cst column-label ";�ɱ�������" with width 320 frame z  STREAM-IO .
   end.
   prod_issue=0.
   prod_iss_so=0.
   prod_iss_fas=0.
   prod_iss_unp = 0.
   prod_iss_wo = 0.
   prod_iss_wt=0.
   prod_iss_pl=0.
   prod_iss_tr=0.
   prod_iss = 0.
   prod_iss_201 = 0.
   prod_iss_203 = 0.
   prod_iss_204 = 0.
   prod_iss_205 = 0.
   prod_iss_206 = 0.
   prod_iss_207 = 0.
   prod_iss_208 = 0.
   prod_iss_209 = 0.
   prod_iss_210 = 0.
   prod_iss_211 = 0.
   prod_iss_213 = 0.
   prod_iss_214 = 0.
   prod_iss_215 = 0. /*zwh*/
   prod_iss_212 = 0.
   prod_iss_299 = 0.
   prod_cst=0.   
 end.
end.

  if pr_detail = yes then do:
       output to "c:\detailrp.txt" append.
       display "�ڼ�ϼ�:" with frame y4 .
       disp sum_iss_so column-label "���۳�����" ";" sum_iss_fas column-label ";�׼����۽��" ";" 
        sum_iss_unp column-label ";�ƻ��������" ";" sum_iss_wo column-label ";�������ĺϼ�" ";" 
         sum_iss_wt column-label ";ί�м�����" ";" sum_iss_pl column-label ";��ί�м�����" ";"
         sum_iss_tr column-label ";�������Ͻ��" ";"
         sum_cst column-label ";�ɱ�������"
         with width 320 frame y1  STREAM-IO .
       output close.
   end.
   else do:
       display "�ڼ�ϼ�:" with frame y2 .
       disp sum_iss_so column-label "���۳�����" ";" sum_iss_fas column-label ";�׼����۽��" ";"
        sum_iss_unp column-label ";�ƻ��������" ";" sum_iss_wo column-label ";�������ĺϼ�" ";"
          sum_iss_wt column-label ";ί�м�����" ";" sum_iss_pl column-label ";��ί�м�����" ";"
          sum_iss_tr column-label ";�������Ͻ��" ";" sum_cst column-label ";�ɱ�������"
         with width 320 frame y  STREAM-IO .
   end.
 
/*judy 05/08/19*/   
   sum_iss_tr = 0.
   sum_iss_so = 0.
   sum_iss_fas = 0.
   sum_iss_unp = 0.
   sum_iss_wo = 0.
   sum_iss_wt = 0.
   sum_iss_pl = 0.
   sum_cst = 0. 
/*judy 05/08/19*/ 

{mfguitrl.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
 
end procedure.



/*GUI*/ {mfguirpb.i &flds=" site site1 line line1 part part1 date date1 keeper keeper1  pr_detail "} /*Drive the Report*/



