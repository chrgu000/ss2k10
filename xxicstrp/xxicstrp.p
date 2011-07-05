/* xxicstrp.p - LOCATION MASTER STATUS REPORT                                */
/* revision: 110624.1  created on: 20110624   by: zy                         */
/* REVISION: 0CYH LAST MODIFIED:   06/24/11   BY: zy                         */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

/* 2011-07-04:�޸ı�ṹ,add index xxmqp_part_serial                         */
/* ����Ӱ��ĳ����� .5.13.9   .28.1.3*                                       */
/* showa �ֿ��λ����
	 Check ����
	 P-2R -> P-CGRD  ����
	 S-HD -> S-ZXMP  ��Э
	 TEMP            �չ��ջ�
	 XA-1 -> XZZZ    ����
*/

/* DISPLAY TITLE */
{mfdtitle.i "110624.1"}

/* CONSIGNMENT INVENTORY VARIABLES */
{pocnvars.i}

define variable site like ld_site.
define variable site1 like ld_site.
define variable loc like ld_loc.
define variable loc1 like ld_loc.
define variable vfind as logical.
define variable vptstat as character.
/* SELECT FORM */
form
   site  colon 19
   site1 label {t001.i} colon 49 skip
   loc   colon 19
   loc1  label {t001.i} colon 49 skip
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat:

   if site1 = hi_char then site1 = "".
   if loc1 = hi_char then loc1 = "".

   if c-application-mode <> 'web' then
   update site site1 loc loc1
   with frame a.

   {wbrp06.i &command = update &fields = "site site1 loc loc1 " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i site }
      {mfquoter.i site1}
      {mfquoter.i loc  }
      {mfquoter.i loc1 }

      if site1 = "" then site1 = hi_char.
      if loc1 = "" then loc1 = hi_char.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = "nopage"
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

/*   {mfphead.i}   */

/* SET EXTERNAL LABELS */
export delimiter "~011"
       getTermLabel("site",12)
       getTermLabel("LOCATIONS",12)
       getTermLabel("GROUPS",12)
       getTermLabel("PARTS",12)
       getTermLabel("DESCRIPTION_1",12)
       getTermLabel("DESCRIPTION_2",12)
       getTermLabel("LOT/SERIAL",12)
       getTermLabel("PERMANENT ",12)
       getTermLabel("SINGLE_ITEM",12)
       getTermLabel("INVENTORY_STATUS",12)
       getTermLabel("ON_HAND",12)
       getTermLabel("SPECIFICATION_TESTS",12)
       .
/*              "�ص�" "��λ" "�Ϻ�" "����1" "����2"  "��/���"             */
/*              "����" "����" "���״̬" "�����" "����״̬"                */

for each loc_mstr no-lock
   where loc_site >= site and loc_site <= site1 and
         (loc_loc >= loc and loc_loc <= loc1) and
         index(loc_loc,"-") > 0
break by loc_site by loc_loc:
assign vfind = no.
  if can-find(first ld_det no-lock where ld_site = loc_site and
                    ld_loc = loc_loc and ld_qty_oh > 0) then do:
     for each ld_det no-lock where ld_site = loc_site and
                    ld_loc = loc_loc and ld_qty_oh > 0:
        find first pt_mstr no-lock where pt_part = ld_part no-error.
        assign vptstat = "3".
/*    ɸѡ���Ľ���������־���ϸ�Ϊ1�����ϸ�Ϊ2����Ϊδ������               */
        find first Xxmqp_det no-lock where xxmqp_part = ld_part and
                   xxmqp_serial = ld_lot no-error.
        if available xxmqp_det then do:
              assign vptstat = xxmqp_stat.
        end.
            if last-of(loc_loc) then do:
               export delimiter "~011" 
               			  loc_site
                      loc_loc
                      loc_user1
                      ld_part
                      pt_desc1
                      pt_desc2
                      ld_lot
                      loc_perm
                      loc_single
                      loc_status
                      ld_qty_oh
                      vptstat
                      .
            end.
            else do:
                 export delimiter "~011" 
                 			  loc_site
                        loc_loc
                        loc_user1
                        ld_part
                        pt_desc1
                        pt_desc2
                        ld_lot
                        loc_perm
                        loc_single
                        loc_status
                        ld_qty_oh
                        vptstat.
            end.
     end.  /*  if available xxmqp_det then do:  */
    end.
    else do:
          export delimiter "~011" loc_site
                  loc_loc
                  loc_user1
                  ""
                  ""
                  ""
                  ""
                  loc_perm
                  loc_single
                  loc_status
                  .
    end.  /* if can-find(first ld_det no-lock  else do:*/
/*      if page-size - line-counter < 2 then page.                           */
/*      {mfrpchk.i}                                                          */
  end.  /* for each loc_mstr no-lock*/

     /* REPORT TRAILER  */
/*  {mfrtrail.i}   */
 {mfreset.i}

end.
{wbrp04.i &frame-spec = a}
