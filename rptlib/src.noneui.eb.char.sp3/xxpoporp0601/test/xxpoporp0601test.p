/* poporp06.p - PURCHASE ORDER RECEIPTS REPORT                          */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*N05Q /*F0PN*/ /*K0KK*/ /*V*8*#Convert*Mode=WebReport        */ */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 4.0     LAST MODIFIED: 03/15/88    BY: FLM       */
/* REVISION: 4.0     LAST MODIFIED: 02/12/88    BY: FLM *A175**/
/* REVISION: 4.0     LAST MODIFIED: 11/01/88    BY: FLM *A508**/
/* REVISION: 5.0     LAST MODIFIED: 02/23/89    BY: RL  *B047**/
/* REVISION: 6.0     LAST MODIFIED: 05/24/90    BY: WUG *D002**/
/* REVISION: 6.0     LAST MODIFIED: 08/14/90    BY: RAM *D030**/
/* REVISION: 6.0     LAST MODIFIED: 11/06/90    BY: MLB *B815**/
/* REVISION: 5.0     LAST MODIFIED: 02/12/91    BY: RAM *B892**/
/* REVISION: 6.0     LAST MODIFIED: 06/26/91    BY: RAM *D676**/
/* REVISION: 7.0     LAST MODIFIED: 07/29/91    BY: MLV *F001**/
/* REVISION: 7.0     LAST MODIFIED: 03/18/92    BY: TMD *F261**/
/* REVISION: 7.3     LAST MODIFIED: 10/13/92    BY: tjs *G183**/
/* REVISION: 7.3     LAST MODIFIED: 01/05/93    BY: MPP *G481**/
/* REVISION: 7.3     LAST MODIFIED: 12/02/92    BY: tjs *G386**/
/* REVISION: 7.4     LAST MODIFIED: 12/17/93    BY: dpm *H074**/
/* REVISION: 7.3     LAST MODIFIED: 10/18/94    BY: jzs *GN91**/
/* REVISION: 8.5     LAST MODIFIED: 11/15/95    BY: taf *J053**/
/* REVISION: 8.5     LAST MODIFIED: 02/12/96    BY: *J0CV* Robert Wachowicz*/
/* REVISION: 8.6     LAST MODIFIED: 10/03/97    BY: mur *K0KK**/

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan      */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* David Morris    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/09/00   BY: *M0QW* Falguni Dalal   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb             */

/* ����Ϊ�汾��ʷ */
/* SS - 090317.1 By: Bill Jiang */

/*����Ϊ����˵�� */
/* SS - 090317.1 - RNB
��090317.1��

�޸������±�׼�˵�����:
  - �ɹ��ջ����� [poporp06.p]

��ο����ϱ�׼�˵��������ذ���

��ο����±�׼�˵����������֤:
  - �ɹ��ջ����� [poporp06.p]

˳������������ֶ�:
  - ��׼���: �ɹ���[prh_nbr]
  - ��׼���: ��Ӧ��[prh_vend]
  - ��׼���: ��Ӧ������[descname]
  - ��׼���: ��Ŀ[pj_project]
  - ��׼���: ��Ŀ˵��[pj_desc]
  - ��׼���: �ջ���[prh_receiver]
  - ��׼���: ��[prh_line]
  - ��׼���: �����[prh_part]
  - ��׼���: �ջ�����[prh_rcp_date]
  - ��׼���: �ջ���-����浥λ[qty_open]
  - ��׼���: ����[prh_rcp_type]
  - ��׼���: ���ʵ�λ�ɱ�-����浥λ�ͱ���[std_cost]
  - ��׼���: �Ƿ���ʾ����[disp_curr]
  - ��׼���: �ɹ���λ�ɱ�-����浥λ�ͱ���[base_cost]
  - ��׼���: ���ʳɱ��ϼ�-������[std_ext]
  - ��׼���: �ɹ��ɱ��ϼ�-������[pur_ext]
  - ��׼���: �ɹ�-���˳ɱ��ϼƲ���-������[std_var]
  - ��׼���: װ�䵥��[prh_ps_nbr]
  - ��׼���: װ�䵥��[prh_ps_qty]
  - ��׼���: poders[poders]
  - ��׼���: ��������[prh_ship_date]
  - ��׼���: ԭ��[prh_curr]
  - ��׼���: ����[base_curr]
  - ��׼���: ԭ�ҵ�λ[prh_ex_rate]
  - ��׼���: ���ҵ�λ[prh_ex_rate2]
  - ��׼���: �һ������[prh_exru_seq]
  - ��չ���: �ɹ���λ�ɱ�-����浥λ��ԭ��[prh_curr_amt]
  - ��չ���: ��λ��������[prh_um_conv]
  - ��չ���: �ɹ���λ�ɱ�-���ɹ���λ��ԭ��[prh_pur_cost]
  - ��չ���: �ջ���-���ɹ���λ[prh_rcvd]

��090317.1��

SS - 090317.1 - RNE */

/*
/*GN91*/ {mfdtitle.i "b+ "}
*/
/*GN91*/ {mfdtitle.i "090317.1"}

/* SS - 090317.1 - B */
{xxpoporp0601.i "new"}
/* SS - 090317.1 - E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE poporp06_p_1 "ERS Items Only"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp06_p_2 "Sort By"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


/* /*J0CV*/ define variable ers-only as logical no-undo.                **M0QW*/
define variable ers-only like mfc_logical no-undo.                      /*M0QW*/

/*H074*/ {poporp06.i new}

/*H074*/ /* PICK UP DEFAULTS FROM THE LNGD_DET FILED */
/*H074*/ /* DEFAULT FOR sort_by IS EFFECTIVE */
/*H074*/ {gplngn2a.i &file     = ""poporp06.p""
                     &field    = ""sort_by""
                     &code     = sort_by_code
                     &mnemonic = sort_by
                     &label    = sort_by_desc}

         /* DISPLAY TITLE */

         form
                rdate          colon 15
                rdate1         label {t001.i} colon 49 skip
                vendor         colon 15
                vendor1        label {t001.i} colon 49 skip
                part           colon 15
                part1          label {t001.i} colon 49 skip
                site           colon 15
                site1          label {t001.i} colon 49
/**J0CV**       skip (1) **/
/*N05Q*/        pj             colon 15
/*N05Q*/        pj1            label {t001.i} colon 49
/*H074*/        fr_ps_nbr      colon 15
/*H074*/        to_ps_nbr      label {t001.i} colon 49 skip (1)
                sel_inv        colon 20
                sel_sub        colon 20
/*J0CV*/        ers-only       colon 20 label {&poporp06_p_1}
                sel_mem        colon 20
/*N05Q*         skip (1)                */
                uninv_only     colon 20
                use_tot        colon 20
                show_sub       colon 20
                base_rpt       colon 20
/*H074*         sortbypo       colon 20 skip */
/*H074*/        sort_by        colon 20  label {&poporp06_p_2}
/*H074*/        sort_by_desc  colon 49 no-label
/**J0CV**       skip **/
         with frame a side-labels width 80 attr-space.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

/*H074*/ display sort_by_desc
         with frame a.

/*K0KK*/ {wbrp01.i}
         repeat:
/*GN91     do:*/
               if rdate = low_date then rdate = ?.
               if rdate1 = hi_date then rdate1 = today.
               if vendor1 = hi_char then vendor1 = "".
               if part1 = hi_char then part1 = "".
               if site1 = hi_char then site1 = "".
/*N05Q*/       if pj1   = hi_char then pj1 = "".
/*H074*/       if to_ps_nbr = hi_char then to_ps_nbr = "".


/*K0KK*/ if c-application-mode <> 'web':u then
update
                    rdate rdate1 vendor vendor1 part part1 site site1
/*N05Q*/            pj pj1
/*H074*/            fr_ps_nbr to_ps_nbr
                    sel_inv sel_sub
/*J0CV*/            ers-only
                    sel_mem uninv_only use_tot show_sub base_rpt
/*H074*/            sort_by
               with frame a.

/*N05Q*  **** BEGIN DELETE CODE ****
 * /*K0KK*/ {wbrp06.i &command = update &fields = "  rdate rdate1 vendor vendor1
 * part part1 site site1  fr_ps_nbr to_ps_nbr sel_inv sel_sub  ers-only sel_mem uninv_only
 * use_tot show_sub base_rpt  sort_by" &frm = "a"}
 *N05Q*  **** END DELETE CODE **** */

/*N05Q*/ {wbrp06.i &command = update
                   &fields = " rdate rdate1 vendor vendor1 part part1
                               site site1 pj pj1 fr_ps_nbr to_ps_nbr
                               sel_inv sel_sub  ers-only sel_mem uninv_only
                               use_tot show_sub base_rpt  sort_by"
                   &frm = "a"}

/*K0KK*/ if (c-application-mode <> 'web':u) or
/*K0KK*/ (c-application-mode = 'web':u and
/*K0KK*/ (c-web-request begins 'data':u)) then do:

/*H074*/       /* VALIDATE SORT_BY MNEMONIC AGAINST lngd_det */
/*H074*/       {gplngv.i &file     = ""poporp06.p""
                         &field    = ""sort_by""
                         &mnemonic = sort_by
                         &isvalid  = valid_mnemonic}
/*H074*/       if not valid_mnemonic then do:
/*H074*/          {mfmsg02.i 3169 3 sort_by} /* INVALID MNEMONIC sort_by */
/*H074*/
/*K0KK*/ if c-application-mode = 'web':u then return.
else next-prompt sort_by with frame a.
/*H074*/          undo , retry.
/*H074*/       end.

/*H074*/       /* GET CODES FROM lngd_det FOR MNEMONICS */
/*H074*/       {gplnga2n.i &file  = ""poporp06.p""
                           &field = ""sort_by""
                           &mnemonic = sort_by
                           &code = sort_by_code
                           &label = sort_by_desc}
/*H074*/       display sort_by_desc with frame a.

               bcdparm = "".
               {mfquoter.i rdate     }
               {mfquoter.i rdate1    }
               {mfquoter.i vendor    }
               {mfquoter.i vendor1   }
               {mfquoter.i part      }
               {mfquoter.i part1     }
               {mfquoter.i site      }
               {mfquoter.i site1     }
/*N05Q*/       {mfquoter.i pj        }
/*N05Q*/       {mfquoter.i pj1       }
/*H074*/       {mfquoter.i fr_ps_nbr }
/*H074*/       {mfquoter.i to_ps_nbr }
               {mfquoter.i sel_inv   }
               {mfquoter.i sel_sub   }
/*J0CV*/       {mfquoter.i ers-only }
               {mfquoter.i sel_mem   }
               {mfquoter.i uninv_only}
               {mfquoter.i use_tot   }
               {mfquoter.i show_sub  }
               {mfquoter.i base_rpt  }
               {mfquoter.i sort_by   }

               if rdate = ? then rdate = low_date.
               if rdate1 = ? then rdate1 = today.
               if vendor1 = "" then vendor1 = hi_char.
               if part1 = "" then part1 = hi_char.
               if site1 = "" then site1 = hi_char.
/*N05Q*/       if pj1   = "" then pj1   = hi_char.
/*H074*/       if to_ps_nbr = ""  then to_ps_nbr = hi_char.


/*K0KK*/ end.
{mfselbpr.i "printer" 132}
/* SS - 090317.1 - B
               {mfphead.i}
/*GN91      end. */

/*J053*/    oldcurr = "".
            loopb:
            do on error undo , leave:
/*H074*/       if sort_by_code = "1" then do on error undo , leave loopb:

/**J0CV** /*H074*/          {gprun.i ""poporp6a.p""} **/
/*J0CV*/          {gprun.i ""poporp6a.p"" "(input ers-only)" }

/*H074*/       end.
/*H074*/       if sort_by_code = "2" then do on error undo , leave loopb:

/**J0CV** /*H074*/          {gprun.i ""poporp6b.p""} **/
/*J0CV*/          {gprun.i ""poporp6b.p"" "(input ers-only)" }

/*H074*/       end.
/*H074*/       if sort_by_code = "3" then do on error undo , leave loopb:

/**J0CV** /*H074*/          {gprun.i ""poporp6c.p""} **/
/*J0CV*/          {gprun.i ""poporp6c.p"" "(input ers-only)" }

/*H074*/       end.
            end.
            {mfrtrail.i}
            hide message no-pause.
            {mfmsg.i 9 1}
SS - 090317.1 - E */
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

   FOR EACH ttxxpoporp0601:
      DELETE ttxxpoporp0601.
   END.

   {gprun.i ""xxpoporp0601.p"" "(
      INPUT rdate,
      INPUT rdate1,
      INPUT vendor,
      INPUT vendor1,
      INPUT part,
      INPUT part1,
      INPUT site,
      INPUT site1,
      INPUT pj,
      INPUT pj1,
      INPUT fr_ps_nbr,
      INPUT TO_ps_nbr,
      INPUT sel_inv,
      INPUT sel_sub,
      INPUT ers-only,
      INPUT sel_mem,
      INPUT uninv_only,
      /* eB2
      INPUT supplier_consign,
      */
      INPUT USE_tot,
      INPUT show_sub,
      INPUT base_rpt,
      INPUT SORT_by
      )"}

   EXPORT DELIMITER ";" "�ɹ���" "��Ӧ��" "��Ӧ������" "��Ŀ" "��Ŀ˵��" "�ջ���" "��" "�����" "�ջ�����" "�ջ���-����浥λ" "����" "���ʵ�λ�ɱ�-����浥λ�ͱ���" "�Ƿ���ʾ����" "�ɹ���λ�ɱ�-����浥λ�ͱ���" "���ʳɱ��ϼ�-������" "�ɹ��ɱ��ϼ�-������" "�ɹ�-���˳ɱ��ϼƲ���-������" "װ�䵥��" "װ�䵥��" "poders" "��������" "ԭ��" "����" "ԭ�ҵ�λ" "���ҵ�λ" "�һ������" "�ɹ���λ�ɱ�-����浥λ��ԭ��" "��λ��������" "�ɹ���λ�ɱ�-���ɹ���λ��ԭ��" "�ջ���-���ɹ���λ".
   EXPORT DELIMITER ";" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��չ���" "��չ���" "��չ���" "��չ���".
   EXPORT DELIMITER ";" "prh_nbr" "prh_vend" "descname" "pj_project" "pj_desc" "prh_receiver" "prh_line" "prh_part" "prh_rcp_date" "qty_open" "prh_rcp_type" "std_cost" "disp_curr" "base_cost" "std_ext" "pur_ext" "std_var" "prh_ps_nbr" "prh_ps_qty" "poders" "prh_ship_date" "prh_curr" "base_curr" "prh_ex_rate" "prh_ex_rate2" "prh_exru_seq" "prh_curr_amt" "prh_um_conv" "prh_pur_cost" "prh_rcvd".
   FOR EACH ttxxpoporp0601:
      EXPORT DELIMITER ";" ttxxpoporp0601.
   END.

   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

   {xxmfrtrail.i}
   /* SS - 090317.1 - E */

         end.

/*K0KK*/ /*V8-*/
/*K0KK*/ {wbrp04.i &frame-spec = a}
/*K0KK*/ /*V8+*/
