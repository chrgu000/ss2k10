/* poporp06.p - PURCHASE ORDER RECEIPTS REPORT                                */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.8.3.9 $                                                       */
/*V8:ConvertMode=FullGUIReport                                                */
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
/* REVISION: 8.5     LAST MODIFIED: 02/12/96    BY: *J0CV* Robert Wachowicz   */
/* REVISION: 8.6     LAST MODIFIED: 10/03/97    BY: mur *K0KK**/
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane           */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan          */
/* REVISION: 9.1     LAST MODIFIED: 03/06/00   BY: *N05Q* David Morris        */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane    */
/* REVISION: 9.1     LAST MODIFIED: 08/09/00   BY: *M0QW* Falguni Dalal       */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00   BY: *N0KQ* Mark Brown          */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.8.3.7    BY: Jean Miller        DATE: 05/14/02  ECO: *P05V*  */
/* Revision: 1.8.3.8    BY: Narathip W.        DATE: 05/04/03  ECO: *P0R5*  */
/* $Revision: 1.8.3.9 $   BY: Deepak Rao         DATE: 05/29/03  ECO: *P0T9*  */
/* $Revision: 1.8.3.9 $   BY: Bill Jiang         DATE: 01/08/06  ECO: *SS - 20060108*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20060108 - B */
{a6poporp0601.i "new"}
/* SS - 20060108 - E */

{mfdtitle.i "2+ "}
{cxcustom.i "POPORP06.P"}

define variable ers-only         like mfc_logical           no-undo.
define variable l_use_sup_cnsg   like mfc_logical           no-undo.
define variable l_sup_cnsg_desc  as   character             no-undo.
define variable supplier_consign as   character
   label "Supplier Consigned" no-undo.
define variable l_sup_cnsg_code  as   character initial "1" no-undo.


{poporp06.i new}
{&POPORP06-P-TAG9}

/* PICK UP DEFAULTS FROM THE LNGD_DET FILED */
/* DEFAULT FOR sort_by IS EFFECTIVE */
{gplngn2a.i
   &file     = ""poporp06.p""
   &field    = ""sort_by""
   &code     = sort_by_code
   &mnemonic = sort_by
   &label    = sort_by_desc}

{&POPORP06-P-TAG1}

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input  ""enable_supplier_consignment"",
           input  11,
           input  ""adg"",
           input  ""cns_ctrl"",
           output l_use_sup_cnsg)"}

if l_use_sup_cnsg
then do:
   {gplngn2a.i &file     = ""cnsix_ref""
               &field    = ""report""
               &code     = l_sup_cnsg_code
               &mnemonic = supplier_consign
               &label    = l_sup_cnsg_desc}
end. /* IF l_use_sup_cnsg */

form
   rdate            colon 15
   rdate1           label "To" colon 49 skip
   vendor           colon 15
   vendor1          label "To" colon 49 skip
   part             colon 15
   part1            label "To" colon 49 skip
   site             colon 15
   site1            label "To" colon 49
   pj               colon 15
   pj1              label "To" colon 49
   fr_ps_nbr        colon 15
   to_ps_nbr        label "To" colon 49
   sel_inv          colon 20
   sel_sub          colon 20
   ers-only         colon 20 label "ERS Items Only"
   sel_mem          colon 20
   uninv_only       colon 20
   supplier_consign colon 20
   use_tot          colon 20
   show_sub         colon 20
   base_rpt         colon 20
   sort_by          colon 20 label "Sort By"
   sort_by_desc     colon 49 no-label
with frame a side-labels width 80 attr-space.
{&POPORP06-P-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

display
   sort_by_desc
with frame a.

{wbrp01.i}
repeat:

   {&POPORP06-P-TAG3}
   if rdate = low_date then rdate = ?.
   if rdate1 = hi_date then rdate1 = today.
   if vendor1 = hi_char then vendor1 = "".
   if part1 = hi_char then part1 = "".
   if site1 = hi_char then site1 = "".
   if pj1   = hi_char then pj1 = "".
   if to_ps_nbr = hi_char then to_ps_nbr = "".

   if c-application-mode <> 'web' then
   update
      {&POPORP06-P-TAG4}
      rdate rdate1 vendor vendor1 part part1 site site1
      pj pj1
      fr_ps_nbr to_ps_nbr
      sel_inv sel_sub
      ers-only
      sel_mem uninv_only
      supplier_consign
      use_tot show_sub base_rpt
      sort_by
   with frame a.

   {&POPORP06-P-TAG5}
   {wbrp06.i &command = update
      &fields = " rdate rdate1 vendor vendor1 part part1
        site site1 pj pj1 fr_ps_nbr to_ps_nbr
        sel_inv sel_sub  ers-only sel_mem uninv_only
        use_tot show_sub base_rpt  sort_by"
      &frm = "a"}

   {&POPORP06-P-TAG6}
   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      {gplngv.i
         &file     = ""cncix_ref""
         &field    = ""report""
         &mnemonic = supplier_consign
         &isvalid  = valid_mnemonic}

          /* SS - 20050913 - B */
          /*
      if not valid_mnemonic
      then do:
          */
      if (not valid_mnemonic) AND l_use_sup_cnsg
      then do:
          /* SS - 20050913 - E */
         /* INVALID MNEMONIC supplier_consign */
         {pxmsg.i &MSGNUM     = 712
                  &ERRORLEVEL = 3}
         if c-application-mode = 'web'
         then
            return.
         else
            next-prompt supplier_consign with frame a.
         undo , retry.
      end. /* IF NOT valid_mnemonic */

      /* GET CODES FROM lngd_det FOR MNEMONICS */
      {gplnga2n.i &file     = ""cncix_ref""
                  &field    = ""report""
                  &mnemonic = supplier_consign
                  &code     = l_sup_cnsg_code
                  &label    = l_sup_cnsg_desc}

      /* VALIDATE SORT_BY MNEMONIC AGAINST lngd_det */
      {gplngv.i
         &file     = ""poporp06.p""
         &field    = ""sort_by""
         &mnemonic = sort_by
         &isvalid  = valid_mnemonic}

      if not valid_mnemonic then do:
         /* Invalid Mnemonic sort_by */
         {pxmsg.i &MSGNUM=3169 &ERRORLEVEL=3 &MSGARG1=sort_by}
         if c-application-mode = 'web' then return.
         else next-prompt sort_by with frame a.
         undo , retry.
      end.

      /* GET CODES FROM lngd_det FOR MNEMONICS */
      {gplnga2n.i
         &file  = ""poporp06.p""
         &field = ""sort_by""
         &mnemonic = sort_by
         &code = sort_by_code
         &label = sort_by_desc}

      display sort_by_desc with frame a.

      {&POPORP06-P-TAG7}
      bcdparm = ""      .
      {mfquoter.i rdate           }
      {mfquoter.i rdate1          }
      {mfquoter.i vendor          }
      {mfquoter.i vendor1         }
      {mfquoter.i part            }
      {mfquoter.i part1           }
      {mfquoter.i site            }
      {mfquoter.i site1           }
      {mfquoter.i pj              }
      {mfquoter.i pj1             }
      {mfquoter.i fr_ps_nbr       }
      {mfquoter.i to_ps_nbr       }
      {mfquoter.i sel_inv         }
      {mfquoter.i sel_sub         }
      {mfquoter.i ers-only        }
      {mfquoter.i sel_mem         }
      {mfquoter.i uninv_only      }
      {mfquoter.i supplier_consign}
      {mfquoter.i use_tot         }
      {mfquoter.i show_sub        }
      {mfquoter.i base_rpt        }
      {mfquoter.i sort_by         }
      {&POPORP06-P-TAG8}

      if rdate = ? then rdate = low_date.
      if rdate1 = ? then rdate1 = today.
      if vendor1 = "" then vendor1 = hi_char.
      if part1 = "" then part1 = hi_char.
      if site1 = "" then site1 = hi_char.
      if pj1   = "" then pj1   = hi_char.
      if to_ps_nbr = ""  then to_ps_nbr = hi_char.

   end.
   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
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
   /* SS - 20060108 - B */            
   /*
   {mfphead.i}
   */
   /* SS - 20060108 - E */

   /* SS - 20060108 - B */
   /*
   oldcurr = "".
   loopb:
   do on error undo , leave:
      if sort_by_code = "1" then do on error undo , leave loopb:
         {gprun.i ""poporp6a.p""
                  "(input ers-only,
                    input l_sup_cnsg_code)" }
      end.
      if sort_by_code = "2" then do on error undo , leave loopb:
         {gprun.i ""poporp6b.p""
                  "(input ers-only,
                    input l_sup_cnsg_code)" }
      end.
      if sort_by_code = "3" then do on error undo , leave loopb:
         {gprun.i ""poporp6c.p""
                  "(input ers-only,
                    input l_sup_cnsg_code)" }
      end.
   end.

   {mfrtrail.i}
   hide message no-pause.
   {pxmsg.i &MSGNUM=9 &ERRORLEVEL=1}
   */
      PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

      FOR EACH tta6poporp0601:
           DELETE tta6poporp0601.
       END.
       {gprun.i ""a6poporp0601.p"" "(
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
           INPUT supplier_consign,
           INPUT USE_tot,
           INPUT show_sub,
           INPUT base_rpt,
           INPUT SORT_by
           )"}
       EXPORT DELIMITER ";" "prh_nbr" "prh_vend" "descname" "prh_receiver" "prh_line" "prh_part" "prh_rcp_date" "qty_open" "prh_rcp_type" "std_cost" "disp_curr" "base_cost" "std_ext" "pur_ext" "std_var" "prh_ps_nbr" "prh_ps_qty" "poders" "prh_ship_date" "tax_amt" "prh_curr" "ex_rate" "ex_rate2" "ex_rate_rmks" "pvo_id".
       FOR EACH tta6poporp0601:
        EXPORT DELIMITER ";" tta6poporp0601.
    END.

    PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.


   {a6mfrtrail.i}
   /* SS - 20060108 - E */
end.

/*V8-*/
{wbrp04.i &frame-spec = a}
/*V8+*/
