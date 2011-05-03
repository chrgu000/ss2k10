/* ss - 090812.1 by: jack */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/******************************************************************************/
/*
{mfdtitle.i "2+ "}
*/
{mfdtitle.i "090812.1 "}

{cxcustom.i "XXAPVORP.P"}
{apconsdf.i}

/* ********** Begin Translatable Strings Definitions ********* */



/*DEFINE WORKFILE FOR CURRENCY TOTALS*/
{gpacctp.i "new"}
define  variable vend     like ap_vend.
define  variable vend1    like ap_vend.
define  variable effdate  like ap_effdate.
define  variable effdate1 like ap_effdate.
define  variable entity      like ap_entity.
define  variable entity1     like ap_entity.
define  variable acc     like ac_code.

define temp-table tt
field tt_ref like vo_ref
field tt_order like pvo_order
field tt_receiver like  pvo_internal_ref
field tt_invoice like vo_invoice
field tt_effdate like ap_effdate
field tt_amt like vod_amt
field tt_base_amt like vod_base_amt
field tt_acct like ac_code 
field tt_line like vod_ln
field tt_entity like ap_entity.

{&APVORP-P-TAG1}
{txcurvar.i "new"}

{etvar.i &new = "new"}

form
  
   
   entity         colon 15
   entity1        label {t001.i} colon 49 skip
   vend           colon 15
   vend1          label {t001.i} colon 49 skip
   effdate        colon 15
   effdate1       label {t001.i} colon 49 skip
   acc        colon 15
  
   
   skip
with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

/* ASSUMED START UP SESSION IS FOR BASE CURRENCY */

repeat:

   

   if entity1 = hi_char then entity1 = "".
   if vend1 = hi_char then vend1 = "".
   if effdate = low_date then effdate = ?.
   if effdate1 = hi_date then effdate1 = ?.
   
  

   if c-application-mode <> 'web' then
   update
      entity entity1 vend vend1 effdate effdate1 acc 
   with frame a.
   {&APVORP-P-TAG4}
   {wbrp06.i &command = update
      &fields = "  entity entity1 vend vend1  effdate effdate1 acc "
      &frm = "a"}

   {&APVORP-P-TAG9}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      {&APVORP-P-TAG5}
      bcdparm = "".
      {mfquoter.i entity     }
      {mfquoter.i entity1    }
      {mfquoter.i vend       }
      {mfquoter.i vend1      }
      {mfquoter.i effdate    }
      {mfquoter.i effdate1   }
      {mfquoter.i acc  }
      
     

      if entity1 = "" then entity1 = hi_char.
      if vend1 = "" then vend1 = hi_char.
      if effdate = ? then effdate = low_date.
      if effdate1 = ? then effdate1 = hi_date.
      
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
  
  /* {mfphead.i} */
  for each tt :
  delete tt .
  end .
  PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname,1,LENGTH(execname) - 2) SKIP.
  PUT UNFORMATTED "#def :end" SKIP.
  put "凭证 ; 账户 ; 金额 ; 本币金额 ; 采购单 ; 收货单 ; 发票 ; 生效日期" skip .
   for each ap_mstr where 
       (ap_vend >= vend)
      and (ap_vend <= vend1)
      and (ap_effdate >= effdate)
      and (ap_effdate <= effdate1)
      and (ap_entity >= entity)
      and (ap_entity <= entity1)
      and (ap_type = "VO")
       no-lock,
      each vo_mstr where vo_ref = ap_ref no-lock,
      each vod_det where vod_ref = vo_ref and vod_acct = acc and vod_amt <> 0 no-lock,
      each vd_mstr where vd_addr = ap_vend no-lock :
       
       for each vph_hist where vph_ref = ap_ref no-lock
               use-index vph_ref,
          each pvo_mstr no-lock where
               pvo_lc_charge   = "" and
               pvo_internal_ref_type = {&TYPE_POReceiver} and
               pvo_id = vph_pvo_id :
	  create tt .
	  assign 
	     tt_entity = ap_entity
	     tt_line = vod_ln
	     tt_acct = acc
	     tt_amt = vod_amt
	     tt_base_amt = vod_base_amt
	     tt_ref = vo_ref
	     tt_order = pvo_order
	     tt_receiver =  pvo_internal_ref
	     tt_invoice = vo_invoice
	     tt_effdate = ap_effdate .
        end .
      /*   put  vo_ref ";" vod_acct ";" vod_amt ";" vod_base_amt ";" pvo_order ";" pvo_internal_ref ";"  vo_invoice ";" ap_effdate skip .
       */
   
   end .
    
   
    for each tt no-lock where tt_acct = acc and tt_amt <> 0  break by tt_entity by tt_ref by tt_line :
      if first-of(tt_line) then 
       put  tt_ref ";" acc ";" tt_amt ";" tt_base_amt ";" tt_order ";" tt_receiver ";"  tt_invoice ";" tt_effdate skip .
      	
    end .
   {mfreset.i}

  
end. /* REPEAT */

{wbrp04.i &frame-spec = a}
