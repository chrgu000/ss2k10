/*zzbmpsrp01 for product structure report by op or by work center*/

/*GN61*/
{mfdtitle.i "1301"}
  {yybmpsrp07x.i}
def var parent like bom_parent label "���ϵ�����".
def var op like opm_std_op label "��׼����".
def var op1 like opm_std_op.
def var wkctr like wc_wkctr label "��������".
def var wkctr1 like wc_wkctr.
/*Jch---*/
def var stdate like pc_start label "�ɱ�����".
def var endate like pc_start label "�ɱ�������" initial today.
def var site like pt_site initial "dcec-c".
def var effdate like tr_effdate LABEL "BOM��Ч����".
define variable record as integer extent 100.
define variable comp like ps_comp.
define variable level as integer.
define variable maxlevel as integer format ">>>" label "���".
def var datecost like pc_start.
def var partcost as   decimal.
DEFINE VAR v_pc_start LIKE pc_start.
DEFINE VAR v_pc_expire LIKE pc_expire.

DEFINE VAR v_per_price LIKE pc_amt[1].

/*
def var partcost like pc_amt.
*/
def var umcost   like pc_um.
datecost = 01/01/90.


FORM /*GUI*/

 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
           parent colon 25 site colon 50
            op     colon 25    op1 label {t001.i} colon 50
            wkctr colon 25     wkctr1 label {t001.i} colon 50
            effdate colon 25
         /*   effdate  colon 25*/
          SKIP(.4)  /*GUI*/
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

effdate = today.

repeat:

   if op1 = hi_char then op1 = "".
   if wkctr1 = hi_char then wkctr1 = "".

   update PARENT site op op1 wkctr wkctr1  effdate with frame a.

   if op1 = "" then op1 = hi_char.
   if wkctr1 = "" then wkctr1 = hi_char.

   find bom_mstr where bom_domain = global_domain and bom_parent = parent no-lock no-error.
   if not available bom_mstr then do:
        message "�ò�Ʒ�ṹ���벻����,����������!" view-as alert-box error.
        next-prompt parent with frame a.
        undo,retry.
   end.

   find first ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = parent
   no-lock no-error.
   if not available ps_mstr then do:
        message "�ø�����޲�Ʒ�ṹ,����������!" view-as alert-box error.
        undo,retry.
   end.

   if site = "" then do:
      {mfmsg.i 941 3}
      undo,retry.
   end.

   {mfselprt.i "printer" 132}

   for each xxwk:
        delete xxwk.
   end.

   assign
    level = 1
    comp = parent
    maxlevel = min(maxlevel,99).
/******************************************

   repeat: /*for expand the ps*/
         if not available ps_mstr then do:
      repeat:
         level = level - 1.
         if level < 1 then leave.
         find ps_mstr where recid(ps_mstr) = record[level]
         no-lock no-error.
         comp = ps_par.
         find next ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = comp
         no-lock no-error.
         if available ps_mstr then leave.
      end.
         end.
         if level < 1 then leave.

         if effdate = ? or (effdate <> ? and
         (ps_start = ? or ps_start <= effdate)
         and (ps_end = ? or effdate <= ps_end)) then do:

                find pt_mstr where pt_domain = global_domain and pt_part = ps_comp  no-lock no-error.
                find ptp_det where ptp_domain = global_domain
                               and ptp_part = ps_comp
                               and ptp_site = site no-lock no-error.

                /*if available pt_mstr /*and
                ((available ptp_det /*and not ptp_phantom*/)
                  or
                  (not available ptp_det /*and not pt_phantom*/ ))*/ then do:*/

                      create xxwk.
                      assign xxwk.parent = parent
                             xxwk.comp = ps_comp
                             xxwk.desc1 = IF AVAIL pt_mstr THEN pt_desc1 ELSE ""
                             xxwk.desc2 = IF AVAIL pt_mstr THEN pt_desc2 ELSE ""
                             xxwk.ref = ps_ref
                             xxwk.sdate = ps_start
                             xxwk.edate = ps_end
                             xxwk.op = ps_op
                             xxwk.qty = ps_qty_per
                             /*xxwk.wvend = IF AVAIL ptp_det THEN ptp_vend ELSE ""*/
                             xxwk.pmcode = IF AVAIL ptp_det THEN ptp_pm_code ELSE ""
                             xxwk.par = ps_par
                             xxwk.bomcode = IF AVAIL ptp_det THEN ptp_bom_code ELSE ""
                             xxwk.site = IF AVAIL ptp_det THEN ptp_site ELSE "".

                      find first opm_mstr where opm_domain = global_domain and opm_std_op = string(ps_op) no-lock no-error.
                      if available opm_mstr then do:
                            assign xxwk.wkctr = opm_wkctr.

                            find wc_mstr where wc_domain = global_domain and wc_wkctr = opm_wkctr and wc_mch = opm_mch no-lock no-error.
                            if available wc_mstr then
                                   assign xxwk.wcdesc = wc_desc.

                           /* FIND ad_mstr WHERE ad_domain = global_domain and ad_add = ptp_vend  no-lock no-error.
                            if available ad_mstr then
                                   ASSIGN xxwk.wadname =ad_name.*/
                      end.

               /* end.*/

      record[level] = recid(ps_mstr).

      if level < maxlevel or maxlevel = 0
      and ((available ptp_det /*and ptp_phantom*/ ) or (not available ptp_det and available pt_mstr /*and pt_phantom*/ )
            or not available pt_mstr)
      then do:
         comp = ps_comp.
         level = level + 1.
         find first ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = comp
         no-lock no-error.
         find first ptp_det where ptp_domain = global_domain and ptp_part = comp and ptp_site = site no-error.
         if available ptp_det and ptp_pm_code = "P" then do:
            leave.
         end.
      end.
      else do:
         find next ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = comp
         no-lock no-error.
         find first ptp_det where ptp_domain = global_domain and ptp_part = comp and ptp_site = site no-lock no-error.
         if available ptp_det and ptp_pm_code = "P" then do:
            leave.
         end.
      end.
         end.
         else do:
             find next ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = comp
             no-lock no-error.
             find first ptp_det no-lock where ptp_domain = global_domain and ptp_part = comp and ptp_site = site no-error.
             if available ptp_det and ptp_pm_code = "P" then do:
                leave.
             end.
         end.

   end. /*expand the ps*/
   ******************************/

    run process_report (input comp,input level).
   for each xxwk exclusive-lock:
       find pt_mstr where pt_domain = global_domain
                      and pt_part = xxwk.comp no-lock no-error.
       find first ptp_det use-index ptp_site where ptp_domain = global_domain and ptp_part = xxwk.comp
                      and ptp_site = site no-lock no-error.
       assign xxwk.desc1 = IF AVAIL pt_mstr THEN pt_desc1 ELSE ""
              xxwk.desc2 = IF AVAIL pt_mstr THEN pt_desc2 ELSE ""
              xxwk.pmcode = IF AVAIL ptp_det THEN ptp_pm_code ELSE ""
              xxwk.bomcode = IF AVAIL ptp_det THEN ptp_bom_code ELSE ""
              xxwk.site = IF AVAIL ptp_det THEN ptp_site ELSE "".
       /*���������ʾ*/
       if (available ptp_det and ptp_phantom) or not available ptp_det or substring(trim(xxwk.comp),length(xxwk.comp) - 1) = "ZZ" then do:
          assign xxwk.desc1 = "ɾ������Ŷ".
       end.
       xxwk.parent = parent.
   end.

   FOR EACH xxwk WHERE (string(xxwk.op) >= op and string(xxwk.op) <= op1)
       and (xxwk.wkctr >= wkctr and xxwk.wkctr <= wkctr1) NO-LOCK:
/*
       FIND FIRST ptp_det WHERE ptp_domain = global_domain and ptp_part = xxwk.comp AND ptp_pm_code <> "M" AND ptp_site >= "DCEC-B" AND ptp_site <= "DCEC-C"
            AND ptp_bom_code = "" AND ptp_phantom = NO NO-LOCK NO-ERROR.
       IF AVAIL ptp_det THEN DO:
*/


     FIND ptp_det use-index ptp_site WHERE ptp_domain = global_domain and ptp_site = site and (ptp_part = xxwk.par OR ptp_part = SUBSTRING(xxwk.par,1,LENGTH(ptp_part))) /* AND ptp_pm_code <> "P" */ NO-LOCK NO-ERROR.
     IF AVAIL ptp_det THEN DO:
       partcost = 0.
       FOR EACH pc_mstr where pc_domain = global_domain and pc_part = xxwk.comp BREAK BY pc_start:
        IF LAST-OF(pc_start) THEN DO:
           FIND FIRST ad_mstr WHERE ad_domain = global_domain and ad_addr = pc_list OR ad_addr = SUBSTRING(pc_list,1 ,LENGTH(ad_addr)) AND ad_type = "supplier"  NO-LOCK NO-ERROR.
           IF AVAIL ad_mstr THEN DO:
               xxwk.wvend = ad_addr.
               xxwk.wadname = ad_name.
           END.
           ELSE DO:
               xxwk.wvend = "DCEC".
               xxwk.wadname = "���翵��˹".

           END.
           partcost = pc_amt[1].
           monkind = pc_curr.
           umcost = pc_um.
           v_pc_start = pc_start.
           v_pc_expire = pc_expire.

        END.
        ELSE DO:
           partcost = 0.
           monkind = "".
           umcost = "".
           v_pc_start = ?.
           v_pc_expire = ?.
        END.
       END.
/*

       FOR EACH qad_wkfl WHERE qad_domain = global_domain and qad_key1 = "poa_det" AND qad_charfld[2] = xxwk.comp AND qad_datefld[1] <= effdate BREAK BY qad_decfld[1].
            /*BY qad_decfld[1].*/
            IF LAST-OF(qad_decfld[1]) THEN DO:
              FIND LAST pod_det WHERE pod_domain = global_domain and pod_part = xxwk.comp AND pod_nbr = qad_charfld[1] NO-LOCK NO-ERROR.
                  IF AVAIL pod_det THEN DO:
                      FIND LAST pc_mstr WHERE pc_domain = global_domain and pc_part =  xxwk.comp AND pc_list = pod_pr_list  NO-LOCK NO-ERROR.
                      IF AVAIL pc_mstr THEN DO:
                          IF pc_um = "KA" THEN v_per_price = pc_amt[1] / 1000.
                          ELSE v_per_price = pc_amt[1].
                      END.

                      ELSE v_per_price = partcost.

                  END.
                  ELSE v_per_price = partcost.
            END.
            ELSE v_per_price = partcost.
       END.
       IF v_per_price = 0 THEN v_per_price = partcost.

 */

/*
      find last qad_wkfl where qad_domain = global_domain and qad_key1 = "poa_det" and
          qad_charfld[3] = pod_site and qad_charfld[2] = pod_part
          and qad_charfld[1] = pod_nbr
          and qad_datefld[1] <= mend
          no-lock no-error.
          xxwk.supperc = if available qad_wkfl then qad_decfld[1] else 0 .
*/

    END.  /*END. end if ptp_det*/
     if  xxwk.pmcode <> "M" then do:

       partcost = 0.
       FOR EACH pc_mstr where pc_domain = global_domain and pc_part = xxwk.comp BREAK BY pc_start:
        IF LAST-OF(pc_start) THEN DO:
           FIND FIRST ad_mstr WHERE ad_domain = global_domain and ad_addr = pc_list OR ad_addr = SUBSTRING(pc_list,1 ,LENGTH(ad_addr)) AND ad_type = "supplier"  NO-LOCK NO-ERROR.
           IF AVAIL ad_mstr THEN DO:
               xxwk.wvend = ad_addr.
               xxwk.wadname = ad_name.
           END.
           ELSE DO:
               xxwk.wvend = "DCEC".
               xxwk.wadname = "���翵��˹".

           END.
           partcost = pc_amt[1].
           monkind = pc_curr.
           umcost = pc_um.
           v_pc_start = pc_start.
           v_pc_expire = pc_expire.

        END.
        ELSE DO:
           partcost = 0.
           monkind = "".
           umcost = "".
           v_pc_start = ?.
           v_pc_expire = ?.
        END.
       END.


      end.
   END.
   
FOR EACH xxwk WHERE (string(xxwk.op) >= op and string(xxwk.op) <= op1)
       and (xxwk.wkctr >= wkctr and xxwk.wkctr <= wkctr1) exclusive-LOCK:
       find first ptp_det no-lock where ptp_domain = global_domain and ptp_part = xxwk.comp and ptp_site = site no-error.
       if (available ptp_det and ptp_phantom) or not available ptp_det or substring(trim(xxwk.comp),length(xxwk.comp) - 1) = "ZZ" then do:
          delete xxwk.
       end.
       find first ptp_det no-lock where ptp_domain = global_domain and ptp_part = xxwk.par and ptp_site = site no-error.
       if (available ptp_det and ptp_pm_code = "P") then do:
          delete xxwk.
       end.
end.       
FOR EACH xxwk WHERE (string(xxwk.op) >= op and string(xxwk.op) <= op1)
       and (xxwk.wkctr >= wkctr and xxwk.wkctr <= wkctr1) NO-LOCK:
     disp xxwk.parent COLUMN-LABEL "����"
            xxwk.par COLUMN-LABEL "�����"
            xxwk.wkctr COLUMN-LABEL "��������"
            xxwk.wcdesc COLUMN-LABEL "������������"
            xxwk.comp COLUMN-LABEL "�����"
            xxwk.wvend COLUMN-LABEL "��Ӧ��"
            xxwk.wadname COLUMN-LABEL "��Ӧ������"
            xxwk.desc1 COLUMN-LABEL "���������"
            xxwk.desc2 COLUMN-LABEL "���������"
            xxwk.pmcode COLUMN-LABEL "P/M"
            partcost COLUMN-LABEL "�۸�"
            v_per_price COLUMN-LABEL "����������"
            monkind  COLUMN-LABEL "Cur"
            umcost   COLUMN-LABEL "��λ"
            xxwk.ref COLUMN-LABEL "�ο���"
            xxwk.qty COLUMN-LABEL "��������"
            xxwk.op COLUMN-LABEL "����"
            v_pc_start COLUMN-LABEL "��Ч����"
            v_pc_expire COLUMN-LABEL "��ֹ����"
            with width 280 stream-io.
end.

   {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


end. /*repeat*/
