{mfdeclre.i}
    def  shared temp-table xxwk
        field xxwk_ponbr like po_nbr
        field xxwk_vend like po_vend
        field xxwk_due_date as character
        field xxwk_curr as character
        field xxwk_buyer as character
        field xxwk_contract as character
        field xxwk_site as character
        field xxwk_part as character
        field xxwk_qty as character
        FIELD xxwk_prlist AS CHARACTER
        FIELD xxwk_line AS INTE
        field xxwk_err as character format "x(40)" .

  def  shared temp-table xxwk1
        field xxwk1_ponbr like po_nbr
        field xxwk1_vend like po_vend
        field xxwk1_due_date like po_due_date
        field xxwk1_curr like po_curr
        field xxwk1_buyer like po_buyer
        field xxwk1_contract like po_contract
        field xxwk1_site like pod_site
        field xxwk1_part like pod_part
        FIELD xxwk1_prlist AS CHARACTER
        FIELD xxwk1_line AS INTE
        FIELD xxwk1_newpo AS LOGICAL
        FIELD xxwk1_modline AS LOGICAL
        field xxwk1_qty like pod_qty_ord .

 define input parameter xxponbr as character .
 define input parameter xxvend as character .
 define input parameter xxsite as character .
 define input parameter xxcurr as character .
 define input parameter xxpart as character .
 define input parameter xxbuyer as character .
 define input parameter xxindate as character .
 define input parameter xxpricelist as character .
 define input parameter xxpoline as character .
 define input-output parameter ok_yn as logical .
 define output parameter errmsg as character format "x(40)" .
 define output parameter xxoutdate as character .
 define variable mc-error-number  like msg_nbr              no-undo.
 define variable unitcost         like pod_pur_cost         no-undo.
 define variable xxrate2 as decimal .
 define variable xxrate as decimal .
 define variable l_gl_set like  si_gl_set .
 DEFINE  VARIABLE xxnewpo as logical .
  DEFINE VARIABLE  xxmodline as logical .
/*
 {gprun.i ""xxchkdate.p"" "(input xxindate,
                          output xxoutdate,
                          output errmsg)"}
*/
 if errmsg <> ""   then
  assign ok_yn = no  .

 find first vd_mstr where vd_addr = xxvend no-lock no-error .
       if available vd_mstr then
       do:
/*   find first pc_mstr where pc_list = vd_pr_list2 no-lock no-error .
       if not available pc_mstr then
                        assign ok_yn = no
                               errmsg = "�۸񵥲�����" .        */
/*
       find first ct_mstr where ct_code = vd_cr_terms no-lock no-error .
          if not available ct_mstr then
                        assign ok_yn = no
                               errmsg = "��������������" .

*/
       end.
/*
   find first pc_mstr where pc_list = xxpricelist no-lock no-error .
       if not available pc_mstr then
                        assign ok_yn = no
                               errmsg = "�۸񵥲�����" .
*/
 if length(xxponbr) > 8 or length(xxbuyer) > 8 then
 assign ok_yn = no
        errmsg = "����/�ɹ�Ա���� ���ȴ���8" .

 find first code_mstr  where code_fldname = "po_buyer" and code_value = xxbuyer no-lock no-error .
  if not available code_mstr then
  assign ok_yn = no
         errmsg = "�ɹ�Ա������ͨ�ô����в�����" .

 if INTEGER(xxpoline) > 999 then
 assign ok_yn = no
         errmsg = "��β��ܴ���999" .

 find po_mstr where po_nbr = xxponbr  no-lock no-error .
 IF NOT available po_mstr THEN xxnewpo = YES.
 ELSE  DO:
     xxnewpo= NO.
     FIND FIRST pod_det WHERE pod_nbr = po_nbr AND pod_line = integer(xxpoline) NO-LOCK NO-ERROR.
     IF AVAIL pod_det THEN DO:
         IF pod_part <> xxpart THEN
             assign ok_yn = no
             errmsg = "�ɹ�������е�������ļ���ε������ͬ" .
         ELSE  xxmodline = YES.
         IF pod_site <> xxsite  THEN
              assign ok_yn = no
             errmsg = "�ɹ�������еĵص����ļ���εĵص㲻ͬ" .
     END.
     ELSE xxmodline = NO.

    if xxvend <> po_vend THEN
          assign ok_yn = no
            errmsg = "PO ��Ӧ�̴������ļ��в�ͬ " .
    if xxcurr <> po_curr then
            assign ok_yn = no
            errmsg = "PO ���Ҵ������ļ��в�ͬ " .

    IF xxpricelist <> po_pr_list2 THEN
               assign ok_yn = no
             errmsg = "PO �۸����ļ��в�ͬ " .
    IF xxbuyer <> po_buyer THEN
              assign ok_yn = no
               errmsg = "PO �ƻ�Ա���ļ��в�ͬ " .



 END.
/* find po_mstr where po_nbr = xxponbr no-lock no-error .
 if available po_mstr then do:
 ok_yn = no .
 errmsg = "PO �Ѵ���" .
 end.
 else do:     */
     find first xxwk1 where xxwk1_ponbr = xxponbr  no-lock no-error .
     if available xxwk1
     then do:
         if xxvend <> xxwk1_vend or xxcurr <> xxwk1_curr  or
            xxpricelist <> xxwk1_prlist
             then
         assign ok_yn = no  .
                if xxvend <> xxwk1_vend then
                errmsg = "PO �ظ���Ӧ�̴��벻ͬ " .
                if xxcurr <> xxwk1_curr then
                errmsg = "PO �ظ����Ҵ��벻ͬ " .
                IF xxpricelist <> xxwk1_prlist THEN
                 errmsg = "PO �ظ��۸񵥲�ͬ " .
                            IF xxbuyer <> xxwk1_buyer THEN
                 errmsg = "PO �ظ��ƻ�Ա��ͬ " .
     end.   /*if avail xxwk1*/

 find si_mstr where si_site = xxsite no-lock no-error .
 if not available si_mstr or (si_db <> global_db) then do:
     ok_yn = no .
     errmsg = "�ص㲻����" .
 end.
 else do:
     {gprun.i ""gpsiver.p""
                "(input si_site, input recid(si_mstr), output return_int)"}
    if return_int = 0
        then assign ok_yn = no
                errmsg = "�õص���Ȩ����" .
 end.

 /*LB01*.. Validate: Cost set needed.                         
def var gl_site like in_gl_cost_site.
find in_mstr where in_site = xxsite and in_part = xxpart no-lock no-error.
if avail in_mstr then do:
     l_gl_set = in_gl_set.
     gl_site = in_gl_cost_site.
 end.
 if l_gl_set = "" then do:
  find  first icc_ctrl no-lock no-error.
  if available icc_ctrl then
    l_gl_set = icc_gl_set.
 end.
 find sct_det where sct_sim = l_gl_set and sct_site = gl_site and sct_part = xxpart no-lock no-error.
 if (l_gl_set="") or (not available sct_det) or (sct_cst_tot <= 0) then do:
      ok_yn = no .
      errmsg = "����ɱ�������" .
  end.
   */
 /*************
/*LB01*/       find si_mstr where si_site = xxsite no-lock no-error.
                           IF AVAIL si_mstr THEN DO:

    /*LB01*/       l_gl_set = si_gl_set.
    /*LB01*/       if l_gl_set = "" then do:
    /*LB01*/        find icc_ctrl where icc_site = xxsite no-lock no-error.
    /*LB01*/        if available icc_ctrl then
    /*LB01*/          l_gl_set = icc_gl_set.
    /*LB01*/       end.
    /*LB01*/       find sct_det where sct_sim = l_gl_set and sct_site = xxsite and xxpart = sct_part no-lock no-error.
    /*LB01*/        if (l_gl_set="") or (not available sct_det) or (sct_cst_tot <= 0) then do:
    /*LB01*/             ok_yn = no .
                                    errmsg = "����ɱ�������" .
    /*LB01*/               end.
                        END.  /* if avail si_mstr  */
       *************/

     find first vd_mstr where vd_addr = xxvend no-lock no-error .
     if not available vd_mstr then
     do:
        ok_yn = no .
        errmsg = "��Ӧ�̲�����" .
     end.
     else do:
          if xxcurr <> base_curr then
          do:
                 find first exr_rate where (today >= exr_start_date and today <= exr_end_date) and
                 ((exr_curr1 = xxcurr and exr_curr2 = base_curr) or (exr_curr1 = base_curr and exr_curr2 = xxcurr)) no-lock no-error .
                 if not available  exr_rate then
                 do:
                   ok_yn = no .
                   errmsg = "���ʲ�����" .
                 end.    /*if not avail exr_rate*/
             else do:
                 find first pt_mstr where pt_part = xxpart no-lock no-error .
                 if not available pt_mstr then
                 do:
                   ok_yn = no .
                   errmsg = "����Ų�����" .
                 end.
               else do:
                 find first isd_det where isd_status = pt_status and (isd_tr_type = "add-po"
                 or isd_tr_type = "ord-po" ) no-lock no-error .
                 if available isd_det then
                 do:
                     ok_yn = no .
                     errmsg = "���״̬����" .
                 end.
                 else do:

                   create xxwk1 .
                    assign xxwk1_part = xxpart
                    xxwk1_ponbr = xxponbr
                    xxwk1_vend = xxvend
                    xxwk1_curr = xxcurr
                    xxwk1_site = xxsite
                    xxwk1_line = INTEGER(xxpoline)
                    xxwk1_prlist = xxpricelist
                     xxwk1_newpo = xxnewpo
                     xxwk1_modline = xxmodline
                        .
                 end.  /* else do*/
               end. /*else do*/
             end.
          end.  /*if xxcurr<> base_curr*/
          else do:
              find first pt_mstr where pt_part = xxpart no-lock no-error .
              if not available pt_mstr then
              do:
                  ok_yn = no .
                  errmsg = "����Ų�����" .
              end.
              else do:
                 find first isd_det where trim(substring(isd_status,1,8)) = trim(substring(pt_status,1,8)) and (isd_tr_type = "add-po"
                 or isd_tr_type = "ord-po" ) no-lock no-error .
                if available isd_det then
                do:
                  ok_yn = no .
                  errmsg = "���״̬����" .
                end.
                else do:
                     create xxwk1 .
                      assign xxwk1_part = xxpart
                             xxwk1_ponbr = xxponbr
                             xxwk1_vend = xxvend
                             xxwk1_curr = xxcurr
                             xxwk1_site = xxsite
                            xxwk1_line = integer(xxpoline)
                            xxwk1_prlist = xxpricelist
                            xxwk1_newpo = xxnewpo
                            xxwk1_modline = xxmodline
                         .
                end.
              end.
          end.
     end.

/* FOR EACH xxwk1.
    MESSAGE "xxwk1 "  xxwk1_ponbr xxwk1_line xxwk1_part .
END. */
