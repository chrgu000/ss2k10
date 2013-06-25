/* edirp01.p - INVENTORY STATUS REPORT                                         */
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
/*20110701*/

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}

define variable nbr like  so_nbr.
define variable nbr1 like so_nbr.


define variable addr like ad_addr.
define variable addr1 like ad_addr.
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
   Type           label "SO/PO"

with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
 setFrameLabels(frame a:handle). 

{wbrp01.i}
repeat:

   if nbr1 = hi_char then nbr1 = "".
   if addr1 = hi_char then addr1 = "".

   if c-application-mode <> 'web' then
      update nbr nbr1 addr addr1 type with frame a.

   {wbrp06.i &command = update &fields = "  nbr nbr1 addr addr1 type " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      if nbr1 = "" then nbr1 = hi_char.
      if addr1 = "" then addr1 = hi_char.

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
          where edi_nbr >= nbr    and edi_nbr <= nbr1 
	    and edi_addr >= addr  and edi_addr<= addr1
	    and ( edi_type = "ORD-SO" and type = yes OR  edi_type = "ORD-PO" and type = no )
	    and length(edi_userid) <> 20   :

   create edihist .
          edinbr   = edi_nbr.
          edigroup = substring ( edi_group ,1,16).
          editype  = edi_type.
   end.

   define variable wedigroup like edi_group.
   for each edihist , each edi_hist where edigroup = substring (edi_group,1,16)   by edi_group 
   with frame b width 400 no-attr-space:
      /* SET EXTERNAL LABELS */
     /* setFrameLabels(frame b:handle). */

     if wedigroup <> edigroup then down 1.
          wedigroup = edigroup.

      {mfrpchk.i}

      display
          edigroup         column-label "!批处理版本号"
	  edi_sourcedomain column-label "!域"
	  edi_action       column-label "!动作"
	  edi_type         column-label "!类型"
	  edi_addr         column-label "!地址"
          edi_nbr          column-label "!单号"
          edi_line         column-label "!项次"         
          edi_entity       column-label "!会计单位"
          edi_part         column-label "!料号"
          edi_qty_ord      column-label "!订单数量"
	  edi_price        column-label "!单价"
	  edi_curr         column-label "!币别"
	  edi_due_date     column-label "!到期日"
          if length(edi_userid) <> 20 then edi_userid else "EDI"  column-label "!用户"
          edi_Sucess       column-label "!已处理".

   
   end.




   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
