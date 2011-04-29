/* poporp06.p - PURCHASE ORDER RECEIPTS REPORT                                */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.8.3.8.1.3 $                                                       */
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
/* Revision: 1.8.3.8.1.1  BY: Narathip W.        DATE: 05/04/03  ECO: *P0R5*  */
/* Revision: 1.8.3.8.1.2  BY: Deepak Rao         DATE: 07/31/03  ECO: *P0T9*  */
/* $Revision: 1.8.3.8.1.3 $ BY: Manish Dani        DATE: 01/27/04  ECO: *P1LD*  */



/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2007/12/04  ECO: *xp001*  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "1+ "}
{cxcustom.i "POPORP06.P"}

{xxpoporp06xp.i new} /*xp001*/

define var v_desc1 like pt_desc1 column-label "说明1".
define var v_desc2 like pt_desc2 column-label "说明2".
define var v_amt   as decimal format "->>>>>>>>>>9.99<<<"  column-label "收货金额" .
define var v_shipping as char column-label "交运地" .
define var v_from	 as char column-label "发货自" .



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
   v_shipto         colon 15 /*xp001*/
   v_shipto1        colon 49 label "To" /*xp001*/
   v_shipfrom       colon 15 /*xp001*/
   v_shipfrom1      colon 49 label "To" /*xp001*/ 
   sel_inv          colon 20
   sel_sub          colon 20
   sel_mem          colon 20
   base_rpt         colon 20

with frame a side-labels width 80 attr-space.
{&POPORP06-P-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


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
   if v_shipto1 = hi_char then v_shipto1 = "". /*xp001*/
   if v_shipfrom1 = hi_char then v_shipfrom1 = "". /*xp001*/

   if c-application-mode <> 'web' then
   update
      {&POPORP06-P-TAG4}
      rdate rdate1 vendor vendor1 part part1 site site1
      pj pj1
      fr_ps_nbr to_ps_nbr
      v_shipto  v_shipto1  /*xp001*/
	  v_shipfrom  v_shipfrom1  /*xp001*/
      sel_inv sel_sub sel_mem base_rpt

   with frame a.

   {&POPORP06-P-TAG5}
   {wbrp06.i &command = update
      &fields = " rdate rdate1 vendor vendor1 part part1
        site site1 pj pj1 fr_ps_nbr to_ps_nbr v_shipto  v_shipto1 v_shipfrom  v_shipfrom1  /*xp001*/
        sel_inv sel_sub  sel_mem base_rpt "
      &frm = "a"}

   {&POPORP06-P-TAG6}
   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:



      {&POPORP06-P-TAG7}
      bcdparm = "".
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
       /*xp001*/{mfquoter.i v_shipto      }
       /*xp001*/{mfquoter.i v_shipto1       }
       /*xp001*/{mfquoter.i v_shipfrom      }
       /*xp001*/{mfquoter.i v_shipfrom1       }
      {mfquoter.i sel_inv         }
      {mfquoter.i sel_sub         }
      {mfquoter.i sel_mem         }
     
      {mfquoter.i base_rpt        }
      {&POPORP06-P-TAG8}

      if rdate = ? then rdate = low_date.
      if rdate1 = ? then rdate1 = today.
      if vendor1 = "" then vendor1 = hi_char.
      if part1 = "" then part1 = hi_char.
      if site1 = "" then site1 = hi_char.
      if pj1   = "" then pj1   = hi_char.
      if to_ps_nbr = ""  then to_ps_nbr = hi_char.

      if v_shipto1   = "" and v_shipto = "" then v_shipto1   = hi_char. /*xp001*/
	  if v_shipto1   = "" and v_shipto <> "" then v_shipto1   = v_shipto . /*xp001*/

      if v_shipfrom1   = "" and v_shipfrom = "" then v_shipfrom1   = hi_char. /*xp001*/
	  if v_shipfrom1   = "" and v_shipfrom <> "" then v_shipfrom1   = v_shipto . /*xp001*/
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
   {mfphead.i}

   oldcurr = "".
   loopb:
   do on error undo , leave:



		for each prh_hist
		   where prh_domain = global_domain
		   and ((prh_rcp_date >= rdate and prh_rcp_date <= rdate1
				or   (prh_rcp_date = ? and rdate = low_date))
		   and  (prh_vend >= vendor and prh_vend <= vendor1)
		   and  (prh_part >= part and prh_part <= part1)
		   and  (prh_site >= site and prh_site <= site1)
		   and  (prh_ps_nbr >= fr_ps_nbr and prh_ps_nbr <= to_ps_nbr)
		   and  can-find(first po_mstr where po_domain = prh_domain 
				and  po_nbr = prh_nbr 
				and po_ship >= v_shipto and po_ship <= v_shipto1)  /*xp001*/
		   and ((prh_type = "" and sel_inv = yes)
		   or   (prh_type = "S" and sel_sub = yes)
		   or   (prh_type <> "" and prh_type <> "S" and sel_mem = yes))
		   and (can-find (first pod_det
				   where pod_domain   = global_domain
				   and  (pod_nbr      = prh_nbr
				   and   pod_line     = prh_line
				   and   pod_project >= pj and pod_project <= pj1)))
		   and (base_rpt = ""
				or base_rpt = prh_curr))
		   and prh__chr01 >= v_shipfrom and prh__chr01 <= v_shipfrom1
			use-index prh_nbr no-lock break by prh_nbr by prh_line 
			with frame b down width 300 :

			v_from = prh__chr01 .

			find first po_mstr where po_domain = prh_domain and  po_nbr = prh_nbr no-lock no-error .
			v_shipping = if avail po_mstr then po_ship else "".

			find first pt_mstr where pt_domain = global_domain and pt_part = prh_part no-lock no-error .
			v_Desc1 = if avail pt_mstr then pt_desc1 else "".
			v_Desc2 = if avail pt_mstr then pt_desc2 else "" .
			


			setFrameLabels(frame b:handle).
			disp  prh_site v_shipping v_from prh_nbr 
				  prh_line prh_part v_Desc1 v_desc2 
				  prh_receiver prh_rcp_date 
				  prh_qty_ord prh_rcvd prh_um 
				  prh_pur_cost prh_curr_amt prh_curr  with frame b .


		end. /* For each prh_hist */
   end. /*loopb:*/

   {mfrtrail.i}
   hide message no-pause.
   {pxmsg.i &MSGNUM=9 &ERRORLEVEL=1}
end.

/*V8-*/
{wbrp04.i &frame-spec = a}
/*V8+*/
