/* xxwowkrp.p - Work Order Receipt Print                                    */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* REVISION: 8.6      LAST MODIFIED: 12/05/99   BY: jym *Jy001*         */
/*By: Neil Gao 09/02/07 ECO: *SS 20090207* */


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "f+ "}

define variable nbr  like wo_nbr label "�ӹ�����".
define variable nbr1 like wo_nbr.
define variable lot  like wo_lot.
define variable lot1 like wo_lot.
define variable job  like wo_so_job.
define variable job1 like wo_so_job.
define variable part  like wo_part.
define variable part1 like wo_part.
define variable wkctr  like wr_wkctr.
define variable wkctr1 like wr_wkctr.
define variable desc1 AS  CHARACTER FORMAT "x(48)".
define variable first_pass like mfc_logical.
define variable site  like wo_site.
define variable site1 like wo_site.
define variable usrname like usr_name format "X(24)".
define variable open_ref like wo_qty_ord.
define variable wcdesc like wc_desc.
define variable um like pt_um.
define variable ptloc like pt_loc.
define variable line like pt_prod_line.
define variable line1 like pt_prod_line.
define variable due_date like wo_due_date.
define variable due_date1 like wo_due_date.
define variable rel_date like wo_rel_date.
define variable rel_date1 like wo_rel_date.
define variable XZ AS  CHARACTER FORMAT "x" label "�ӹ���״̬".
XZ = "R".

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   wkctr          colon 20
   wkctr1         label {t001.i} colon 49 skip
   nbr            colon 20
   nbr1           label {t001.i} colon 49 skip
   lot            colon 20
   lot1           label {t001.i} colon 49 skip
   part           colon 20
   part1          label {t001.i} colon 49 skip
   line           colon 20
   line1          label {t001.i} colon 49 skip
   site           colon 20
   site1          label {t001.i} colon 49 skip
   due_date           colon 20
   due_date1          label {t001.i} colon 49 skip
   rel_date           colon 20
   rel_date1          label {t001.i} colon 49 skip
   job            colon 20
   job1           label {t001.i} colon 49 skip 
   XZ            colon 20 SKIP(1)
/*IFP*   type           colon 20 skip*/
 SKIP(.4)  /*GUI*/
with frame a width 80 side-labels.

setFrameLabels(frame a:handle).

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


repeat : 
	
   if wkctr1 = hi_char then wkctr1 = "".
   if nbr1 = hi_char then nbr1 = "".
   if lot1 = hi_char then lot1 = "".
   if line1 = hi_char then line1 = "".
   if part1 = hi_char then part1 = "".
   if site1 = hi_char then site1 = "".
   if job1 = hi_char then job1 = "".   
   if rel_date1 = hi_date then rel_date1 = ?.
   if due_date1 = hi_date then due_date1 = ?.
   if rel_date = low_date then rel_date = ?.
   if due_date = low_date then due_date = ?.

		update wkctr wkctr1 nbr nbr1 lot lot1 part part1 line line1 site site1 due_date due_date1 rel_date rel_date1 job job1 XZ
		with frame a.

   bcdparm = "".
   {mfquoter.i wkctr       }
   {mfquoter.i wkctr1      }
   {mfquoter.i nbr         }
   {mfquoter.i nbr1        }
   {mfquoter.i lot         }
   {mfquoter.i lot1        }
   {mfquoter.i part        }
   {mfquoter.i part1       }
   {mfquoter.i line        }
   {mfquoter.i line1       }
   {mfquoter.i site        }
   {mfquoter.i site1       }
   {mfquoter.i job         }
   {mfquoter.i job1        }
   {mfquoter.i rel_date    }
   {mfquoter.i rel_date1   }
   {mfquoter.i due_date    }
   {mfquoter.i due_date1   }


   if  wkctr1 = "" then wkctr1 = hi_char.
   if  nbr1 = "" then nbr1 = hi_char.
   if  lot1 = "" then lot1 = hi_char.
   if  line1 = "" then line1 = hi_char.
   if  job1 = "" then job1 = hi_char.
   if  part1 = "" then part1 = hi_char.
   if  site1 = "" then site1 = hi_char.
   if  rel_date1 = ? then rel_date1 = hi_date.
   if  due_date1 = ? then due_date1 = hi_date.
   if  rel_date = ? then rel_date = low_date.
   if  due_date = ? then due_date = low_date.

   /* SELECT PRINTER */

					{mfselbpr.i "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:
if xz <> "p" then
   for each wr_route where wr_domain = global_domain
   and (wr_nbr >= nbr and wr_nbr <= nbr1)
   and (wr_lot >= lot and wr_lot <= lot1) 
   use-index wr_nbrop break by wr_lot by wr_op with frame b down width 132:
			setFrameLabels(frame b:handle).
      if last-of(wr_lot) and last-of(wr_op) and (wr_wkctr >= wkctr and wr_wkctr <= wkctr1)
      then do:
           
         find first wo_mstr where wo_domain = global_domain
         and (wo_status = XZ OR (WO_STATUS <> "C" AND XZ = ""))  and wo_lot = wr_lot
         and (wo_part >= part) and (wo_part <= part1 or part1 = "")
         and (wo_so_job >= job) and (wo_so_job <= job1 or job1 = "")
         and (wo_site >= site) and (wo_site <= site1 or site1 = "")
         and (wo_rel_date >= rel_date and wo_rel_date <= rel_date1)
         and (wo_due_date >= due_date and wo_due_date <= due_date1)	
         use-index wo_lot no-lock no-error.

         if available wo_mstr then do:

            desc1 = "".
            um = "".
            ptloc = "".            
            find first pt_mstr where pt_domain = global_domain and  pt_part = wo_part and (pt_prod_line >= line) and (pt_prod_line <= line1 or line1 = "")
                 use-index pt_part no-lock no-error.
            if available pt_mstr then do:
            assign ptloc = pt_loc
                   desc1 = trim(pt_desc1) + trim(pt_desc2) 
                   um = pt_um.

            usrname = "".
      
            find first wc_mstr where wc_domain = global_domain and wc_wkctr = wr_wkctr and wc_mch = wr_mch use-index wc_wkctr no-lock no-error.
            if available wc_mstr then assign wcdesc = wc_desc.
            else wcdesc = "".
      
            open_ref = wo_qty_ord - wo_qty_comp - wo_qty_rjct.
     if open_ref > 0 then do:
/*IFP***********
   "   �������ģ�       ������                     �ӹ����ţ�           ��־��              "
   "�����������Щ������������������Щ������Щ���������������������������������������������������".
   "�� ����� ��                  �� ���� ��                                                  ��".
   "�����������੤�����������������੤�����੤���Щ��������Щ������������Щ����������Щ���������".
   "�� ������ ��                  �� ��λ ��    �� ������ ��            ���´�����  ��        ��".
   "�����������੤�����������������੤�����੤���ة��������ة��Щ��������ة��Щ������ة���������".
   "�� ����� ��                  ����Ʒ����                  ��  ��ȱ����  ��                ��".
   "�����������੤���������Щ������੤�����ة��������Щ��������੤�����������੤���Щ�����������".
   "�� ������ ��          ������ũ�                �� �ο��� ��            ����λ��          ��". 
   "�����������੤���������੤�����੤�������Щ����Щة������Щة��Щ��������੤���ة��Щ�������".
   "�� ǩ  �� ��          ��ʵ������        ��ǩ�թ�        �����驦        ���������ک�      ��". 
   "�����������ة����������ة������ة��������ة����ة��������ة����ة��������ة��������ة�������".
**************/
            
         put "�� �� ղ �� �� �� �� �� �� �� �� ��" at 37 skip.
         if pt_prod_line = "350" or pt_prod_line = "360" or pt_prod_line = "361" then
         put "��������:" at 3 trim(wr_wkctr) space(1) wcdesc space(2)  "�ӹ�����           ��־:         ����:" today   skip.
         if pt_prod_line <> "350" and pt_prod_line <> "360" and pt_prod_line <> "361" then
         put "��������:" at 3 trim(wr_wkctr) space(1) wcdesc space(2) "�ӹ���: " TRIM(wr_nbr) space(2) "��־: " trim(wr_lot) space(2) "����:" today  skip.
         put "�����������Щ������������������Щ������Щ�������������������������������������----��������������" at 2 skip.
         put "�� ����� ��" at 2 wo_part at 14 "������  ��" at 32 desc1 "��" to 97 skip.
         put "�����������੤�����������������੤�����੤���Щ��������Щ������������Щ����������Щ�----��������" at 2 skip.
         if pt_prod_line = "350" or pt_prod_line = "360" or pt_prod_line = "361" then 
         put "�� ������ ��" at 2 wo_qty_ord to 28 "�� ��λ ��" at 32 um at 44 "�� ������ ��            ���´�����  ��            ��"  skip.
          if pt_prod_line <> "350" and pt_prod_line <> "360" and pt_prod_line <> "361" then
         put "�� ������ ��" at 2 wo_qty_ord to 28 "�� ��λ ��" at 32 um "�� ������ ��"at 46 wo_due_date "���´�����  ��" at 70 wo_rel_date "��" to 97 skip.
         put "�����������੤�����������������੤�����੤���ة��������ة��Щ��������ة��Щ������ة���----������"at 2 skip.
         put "�� ����� ��" at 2 wo_qty_comp to 28 "����Ʒ����" at 32 wo_qty_rjct to 57 "�� ��ȱ����   ��" at 60 open_ref to 91 "��" to 97 skip .
         put "�����������੤���������Щ���--�ةЩ����ة�--���Щ�����----�ةЩ�--------��-----------��-----����" at 2 skip.
         put "�� ������ ��          ���������ک�            ���ֳ�������驦                                ��" at 2 skip.
         put "�����������੤���������੤����--�੤������----�ة�����------��------����------------��------����" at 2 skip.
         put "�� ʵ���� ��          ����/��� ��                                                            �� "  at 2  skip.
         put "�����������੤���������੤����--�੤������------�����Щ�--------��------����----------------����" at 2 skip.
         put "�� ��λ   ��" at 2 ptloc to 23 "������(Kg)��" at 24 pt_net_wt to 46 "�� �ߴ�(MM) ��" at 54 pt_article to 86 "��" to 97 skip .
         put "�����������ة����������ة���--���ة�����----------���ة����������ة���--------------��----������" at 2 skip.
         put " �ֳ����⣺                                           ǩ�գ�                    " at 2 skip(1).  
         put "-------------------------------------------------------------------------------------------------" at 1 skip(1).

         if page-size - line-count < 13 then page.
         end. /*end for open_ref <> 0 */
      end. 
      end.  /* last0of(wr_lot0 and last-of(wr_op) */
    end.
    
   end.
    if xz = "p" then 
    for each wo_mstr where  wo_domain = global_domain 
    		 and (wo_status = "p")  and (wo_lot >= lot and wo_lot <= lot1)
         and (wo_part >= part) and (wo_part <= part1 or part1 = "")
         and (wo_so_job >= job) and (wo_so_job <= job1 or job1 = "")
         and (wo_site >= site) and (wo_site <= site1 or site1 = "")
         and (wo_rel_date >= rel_date and wo_rel_date <= rel_date1)
         and (wo_due_date >= due_date and wo_due_date <= due_date1)	:
         
         find last ro_det where ro_domain = global_domain and ro_routing = wo_part no-lock no-error.
         if available ro_det and (ro_wkctr >= wkctr and ro_wkctr <= wkctr1) then do:
            find first wc_mstr where wc_domain = global_domain and wc_wkctr = ro_wkctr  use-index wc_wkctr no-lock no-error.
            if available wc_mstr then assign wcdesc = wc_desc.
            else wcdesc = "".
            find first pt_mstr where pt_domain = global_domain and pt_part = wo_part and (pt_prod_line >= line) and (pt_prod_line <= line1 or line1 = "")
                 use-index pt_part no-lock no-error.
            if available pt_mstr then do:
            assign ptloc = pt_loc
                   desc1 = pt_desc1 + pt_desc2 
                   um = pt_um.

            usrname = "".

             open_ref = wo_qty_ord - wo_qty_comp - wo_qty_rjct.
            put "�� �� �� �� �� ��" at 37 skip.
         if pt_prod_line = "350" or pt_prod_line = "360" or pt_prod_line = "361" then
         put "��������:" at 5 trim(ro_wkctr) space(1) wcdesc space(3)  "�ӹ�����           ��־:         ����:" today   skip.
         if pt_prod_line <> "350" and pt_prod_line <> "360" and pt_prod_line <> "361" then
         put "��������:" at 5 trim(ro_wkctr) space(1) wcdesc space(3) "�ӹ���: " TRIM(wo_nbr) space(3) "��־: " trim(wo_lot) space(3) "����:" today  skip.
         put "�����������Щ������������������Щ������Щ�������������������������������������----��������������" at 2 skip.
         put "�� ����� ��" at 2 wo_part at 14 "������  ��" at 32 desc1 "��" to 97 skip.
         put "�����������੤�����������������੤�����੤���Щ��������Щ������������Щ����������Щ�----��������" at 2 skip.
         if pt_prod_line = "350" or pt_prod_line = "360" or pt_prod_line = "361" then 
         put "�� ������ ��" at 2 wo_qty_ord to 28 "�� ��λ ��" at 32 um at 44 "�� ������ ��            ���´�����  ��            ��"  skip.
          if pt_prod_line <> "350" and pt_prod_line <> "360" and pt_prod_line <> "361" then
         put "�� ������ ��" at 2 wo_qty_ord to 28 "�� ��λ ��" at 32 um "�� ������ ��"at 46 wo_due_date "���´�����  ��" at 70 wo_rel_date "��" to 97 skip.
         put "�����������੤�����������������੤�����੤���ة��������ة��Щ��������ة��Щ������ة���----������"at 2 skip.
         put "�� ����� ��" at 2 wo_qty_comp to 28 "����Ʒ����" at 32 wo_qty_rjct to 57 "�� ��ȱ����   ��" at 60 open_ref to 91 "��" to 97 skip .
         put "�����������੤���������Щ���--�ةЩ����ة�--���Щ�����----�ةЩ�--------��-----------��-----����" at 2 skip.
         put "�� ������ ��          ���������ک�            ���ֳ�������驦                                ��" at 2 skip.
         put "�����������੤���������੤����--�੤������----�ة�����------��------����------------��------����" at 2 skip.
         put "�� ʵ���� ��          ����/��� ��                                                            �� "  at 2  skip.
         put "�����������੤���������੤����--�੤������------�����Щ�--------��------����----------------����" at 2 skip.
         put "�� ��λ   ��" at 2 ptloc to 23 "������(Kg)��" at 24 pt_net_wt to 46 "�� �ߴ�(MM) ��" at 54 pt_article to 86 "��" to 97 skip .
         put "�����������ة����������ة���--���ة�����----------���ة����������ة���--------------��----������" at 2 skip.
         put " �ֳ����⣺                                             ǩ�գ�                    " at 2 skip(1).  
         put "-------------------------------------------------------------------------------------------------" at 1 skip(1).

         if page-size - line-count < 13 then page.
      end. 
     end.
 
 end.

  {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .


end.

/*GUI*/ end.
