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

/* 以下为版本历史 */
/* SS - 090317.1 By: Bill Jiang */

/* SS - 090317.1 - B
/*GN91*/ {mfdtitle.i "b+ "}
SS - 090317.1 - E */

/* SS - 090317.1 - B */
/*GN91*/ {xxmfdtitle.i "b+ "}
/* SS - 090317.1 - E */

/* SS - 090317.1 - B */
define input parameter i_rdate           like prh_rcp_date.
define input parameter i_rdate1          like prh_rcp_date.
define input parameter i_vendor          like po_vend.
define input parameter i_vendor1         like po_vend.
define input parameter i_part            like pt_part.
define input parameter i_part1           like pt_part.
define input parameter i_site            like pt_site.
define input parameter i_site1           like pt_site.
define input parameter i_pj              like prj_nbr.
define input parameter i_pj1             like prj_nbr.
define input parameter i_fr_ps_nbr       like prh_ps_nbr .
define input parameter i_to_ps_nbr       like prh_ps_nbr .
define input parameter i_sel_inv         like mfc_logical.
define input parameter i_sel_sub         like mfc_logical.
define input parameter i_ers-only         like mfc_logical.
define input parameter i_sel_mem         like mfc_logical.
define input parameter i_uninv_only      like mfc_logical.
/* eB2
define input parameter i_supplier_consign as   character.
*/
define input parameter i_use_tot         like mfc_logical.
define input parameter i_show_sub        like mfc_logical.
define input parameter i_base_rpt        like po_curr.
define input parameter i_sort_by     as character.
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

/* SS - 090317.1 - B
/*H074*/ display sort_by_desc
         with frame a.
SS - 090317.1 - E */

/*K0KK*/ {wbrp01.i}
/* SS - 090317.1 - B
         repeat:
SS - 090317.1 - E */

/* SS - 090317.1 - B */
rdate = i_rdate.
rdate1 = i_rdate1.
vendor = i_vendor.
vendor1 = i_vendor1.
part = i_part.
part1 = i_part1.
site = i_site.
site1 = i_site1.
pj = i_pj.
pj1 = i_pj1.
fr_ps_nbr = i_fr_ps_nbr.
to_ps_nbr = i_to_ps_nbr.
sel_inv = i_sel_inv.
sel_sub = i_sel_sub.
ers-only = i_ers-only.
sel_mem = i_sel_mem.
uninv_only = i_uninv_only.
/* eB2
supplier_consign = i_supplier_consign.
*/
USE_tot = i_use_tot.
show_sub = i_show_sub.
base_rpt = i_base_rpt.
SORT_by = i_sort_by.
/* SS - 090317.1 - E */

/*GN91     do:*/
               if rdate = low_date then rdate = ?.
               if rdate1 = hi_date then rdate1 = today.
               if vendor1 = hi_char then vendor1 = "".
               if part1 = hi_char then part1 = "".
               if site1 = hi_char then site1 = "".
/*N05Q*/       if pj1   = hi_char then pj1 = "".
/*H074*/       if to_ps_nbr = hi_char then to_ps_nbr = "".


/* SS - 090317.1 - B
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
SS - 090317.1 - E */

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
/* SS - 090317.1 - B
/*H074*/       display sort_by_desc with frame a.
SS - 090317.1 - E */

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
/* SS - 090317.1 - B
{mfselbpr.i "printer" 132}
               {mfphead.i}
SS - 090317.1 - E */

/* SS - 090317.1 - B */
define variable l_textfile        as character no-undo.
/* SS - 090317.1 - E */

/*GN91      end. */

/*J053*/    oldcurr = "".
            /* SS - 090317.1 - B
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
         end.
            SS - 090317.1 - E */

            /* SS - 090317.1 - B */
/*J0CV*/          {gprun.i ""xxpoporp0601a.p"" "(input ers-only)" }
            /* SS - 090317.1 - E */

/*K0KK*/ /*V8-*/
/*K0KK*/ {wbrp04.i &frame-spec = a}
/*K0KK*/ /*V8+*/
