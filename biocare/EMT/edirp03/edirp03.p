/* edirp03.p - INVENTORY STATUS REPORT                                         */
/* REVISION: 8.6      LAST MODIFIED: 10/07/97   BY: mzv *K0MB*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer   */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.12  BY: Jean Miller DATE: 04/06/02 ECO: *P056* */
/* $Revision: 1.14 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00G* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*20110712*/

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}

define variable nbr like  so_nbr.
define variable nbr1 like so_nbr.

define variable domain  like  so_domain.
define variable domain1 like  so_domain.

define variable due_date  like  sod_due_date.
define variable due_date1 like  sod_due_date.

define variable addr like ad_addr.
define variable addr1 like ad_addr.
define variable ediTransQty like tr_qty_loc.
define variable lastTransDate like tr_effdate.

define variable Type as logical label "SO/PO" format "SO/PO" .
type = yes.

DEFINE TEMP-TABLE edihist
   FIELD edinbr   like edi_nbr
   FIELD edigroup like edi_group
   FIELD editype  like edi_type.




form
   nbr           colon 25
   nbr1          label "To"
   addr           colon 25
   addr1          label "To"
   domain          colon 25
   domain1        label "To"
   due_date       colon 25
   due_date1      label "To"


   Type           label "SO/PO"

with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
 setFrameLabels(frame a:handle). 

{wbrp01.i}
repeat:

   if nbr1 = hi_char then nbr1 = "".
   if addr1 = hi_char then addr1 = "".
   if domain1 = hi_char then domain1 = "".
   if due_date  = low_date then due_date  = ?.
   if due_date1 = hi_date  then due_date1 = ?.


   if c-application-mode <> 'web' then
      update nbr nbr1 addr addr1 domain domain1 due_date due_date1 type with frame a.

   {wbrp06.i &command = update &fields = "  nbr nbr1 addr addr1 domain domain1 due_date due_Date1 type " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      if nbr1 = "" then nbr1 = hi_char.
      if addr1 = "" then addr1 = hi_char.
      if domain1 = "" then domain1 = hi_char.
      if due_date  = ? then due_date  = low_date.
      if due_date1 = ? then due_date1 = hi_date.


   end.
   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
   {mfphead.i}
   for each edihist : delete edihist. end.

   for each edi_hist no-lock
          where edi_nbr >= nbr    and edi_nbr  <= nbr1 
	    and edi_addr >= addr  and edi_addr <= addr1
	    and ( edi_type = "ORD-SO" and type = yes OR  edi_type = "ORD-PO" and type = no )
	    and length(edi_userid) <> 20 break by edi_nbr by substring (edi_group ,1 , 16 )  :
      if last-of(edi_nbr) then do:
         create edihist .
          edinbr   = edi_nbr.
          edigroup = substring ( edi_group ,1,16).
          editype  = edi_type.
      end.

   end.
   define variable wedigroup like edi_group.
   for each edihist , each edi_hist where edigroup = substring (edi_group,1,16) 
                                      and edi_due_date >= due_date and edi_due_date <= due_date1  
				      and edi_sourcedomain >= domain and edi_sourcedomain <= domain1 by edi_group 
   with frame b width 400 no-attr-space:
      /* SET EXTERNAL LABELS */
     /* setFrameLabels(frame b:handle). */

     if wedigroup <> edigroup then down 1.
          wedigroup = edigroup.

      {mfrpchk.i}

      ediTransQty = 0.
      lastTransDate = ? .
      for each tr_hist where ( tr_nbr = edi_nbr  and tr_part = edi_part and tr_line = edi_line ) and 
                             ( (edi_type = "ORD-SO" AND tr_type = "ISS-SO" ) OR ( edi_type = "ORD-PO" and tr_type = "RCT-PO"  ) ) use-index tr_nbr :

          ediTransQty = ediTransQty + tr_qty_loc.
	  lastTransDate = tr_effdate.
      end.

      display
/*        edigroup         column-label "!批处理号"     */
	  edi_sourcedomain column-label "!域"
	  edi_type         column-label "!类型"
	  edi_addr         column-label "!地址"
          edi_nbr          column-label "!单号"
          edi_line         column-label "!项次"         
          edi_part         column-label "!料号"
  	  edi_due_date     column-label "!到期日"
          edi_qty_ord      column-label "!订单数量"
	  if edi_type = "ORD-SO" then - ediTransQty  else ediTransQty    column-label "!交易数量"
          edi_qty_ord -  ( if edi_type = "ORD-SO" then - ediTransQty  else ediTransQty )  column-label "!短缺数量" 
  	  edi_price        column-label "!价格"
          edi_qty_ord * edi_price      column-label "!订单金额"
          ( if edi_type = "ORD-SO" then - ediTransQty  else ediTransQty ) * edi_price   column-label "!交易金额"
          ( edi_qty_ord -  ( if edi_type = "ORD-SO" then - ediTransQty  else ediTransQty ) ) * edi_price  column-label "!短缺金额" 
          lastTransDate    column-label "!交易日期".



   end.



   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
