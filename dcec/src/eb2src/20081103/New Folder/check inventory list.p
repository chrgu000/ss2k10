output to c:\pandian200706.txt.
/*fm268 begin*/
DEF VAR tot_bd LIKE sct_cst_tot.  /*����*/
DEF VAR tot_lb LIKE sct_cst_tot.  /*ֱ���˹�*/
DEF VAR tot_rg like sct_cst_tot.  /*�˹�*/
DEF VAR tot_fj like sct_cst_tot.  /*����*/
DEF VAR tot_jj like sct_cst_tot.  /*ֱ��*/
DEF VAR tot_gs like sct_cst_tot.  /*��˰*/
DEF VAR tot_zb like sct_cst_tot.  /*ת��*/ 
DEF VAR tot_cl like sct_cst_tot. /*����*/
def var partcost as   decimal.
/*fm268 end*/
for each tag_mstr :
   find pt_mstr where pt_part = tag_part.
   if available pt_mstr then do:
     find ld_det where ld_part = tag_part and ld_site = tag_site and ld_loc = tag_loc and tag_serial=ld_lot.
     if available ld_det then do:
        find in_mstr where in_part = tag_part and in_site = tag_site.
        if available in_mstr then do :
          for each spt_det WHERE spt_part = tag_part AND spt_sim = "STD2007A" and spt_site = "DCEC-C" NO-LOCK  BREAK BY spt_part.
              CASE  spt_element:
              WHEN  "����"  THEN 
                    tot_cl = spt_cst_tl + spt_cst_ll.
              WHEN  "�������"  THEN 
                    tot_bd = spt_cst_tl + spt_cst_ll.
              WHEN  "ֱ���˹�"  THEN 
                    tot_lb = spt_cst_tl + spt_cst_ll.
              WHEN  "�˹�"  THEN 
                    tot_rg = spt_cst_tl + spt_cst_ll.
              WHEN  "����"  THEN  
                     tot_fj = spt_cst_tl + spt_cst_ll.
              WHEN  "���" THEN 
                    tot_jj = spt_cst_tl + spt_cst_ll.
              WHEN  "��˰�˷�"  THEN 
                    tot_gs = spt_cst_tl + spt_cst_ll.
              WHEN  "ת��"  THEN 
                    tot_zb = spt_cst_tl + spt_cst_ll.
              END CASE .
              partcost = tot_cl + tot_bd + tot_lb + tot_rg +  tot_fj  + tot_jj +  tot_gs + tot_zb.
              IF LAST-OF(spt_part) THEN DO:
	             PUT tag_nbr SPACE(2) tag_loc SPACE(2)tag_part SPACE(2) pt_prod_line SPACE(2) pt_desc2 SPACE(2) ld_qty_frz SPACE(2) tag_site SPACE(2) in_abc 
                     SPACE(2) in__qadc01 SPACE(2) partcost SKIP.
                 tot_cl = 0.
                 tot_bd = 0.
                 tot_lb = 0.
                 tot_rg = 0.
                 tot_fj = 0.
                 tot_jj = 0.
                 tot_gs = 0.
                 tot_zb = 0.
                 partcost = 0.
	          end.
         end.
      end.
     end.
   end.
end.
