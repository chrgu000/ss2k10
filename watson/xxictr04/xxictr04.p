/* ictrrp04.p - TRANSACTION AUDIT TRAIL AVERAGE COST                          */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.14 $                                                          */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 7.0      LAST MODIFIED: 03/06/92   BY: pma *F085**/
/* REVISION: 7.2      LAST MODIFIED: 10/25/95   BY: jym *F0VQ**/
/* REVISION: 8.6      LAST MODIFIED: 10/24/97   BY: bvm *K15Z**/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer   */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 08/17/00   BY: *N0K2* Phil DeRogatis     */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.12  BY: Jean Miller DATE: 04/06/02 ECO: *P056* */
/* $Revision: 1.14 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00G* */
/*SS - 101213.1 By Ken */
/*SS - 101221.1 BY KEN*/
/*SS - 120618.1 BY KEN*/
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*
{mfdtitle.i "2+ "}
*/
/*
{mfdtitle.i "101221.1"}
*/
{mfdtitle.i "120618.1"}

define variable part like pt_part.
define variable part1 like pt_part.
define variable site like tr_site.
define variable site1 like tr_site.
define variable nbr like tr_nbr.
define variable nbr1 like tr_nbr.
define variable trdate like tr_date.
define variable trdate1 like tr_date.
define variable efdate like tr_effdate.
define variable efdate1 like tr_date.
define variable glref  like trgl_gl_ref.
define variable glref1 like trgl_gl_ref.
define variable gltnbr like glt_ref format "x(18)".
define variable gltamt like glt_amt.
define variable i as integer.
define variable glt_yn like mfc_logical.
define variable beg_cost like tr_price.
define variable end_cost like tr_price.
define variable beg_inv  like glt_amt label "Inventory Value".
define variable end_inv  like glt_amt.
define variable end_qty  like tr_begin_qoh label "Quantity".
define variable msg-desc like msg_desc no-undo.
/*SS - 101213.1 B*/
DEFINE VARIABLE variance AS DECIMAL LABEL "Variance(+/-)".
DEFINE VARIABLE v_beg_cost like tr_price.
/*SS - 101213.1 E*/

/*SS - 120618.1 B*/
trdate = today - 1.
trdate1 = today - 1.
/*SS - 120618.1 E*/
 
form
   part           colon 20
   part1          label "To" colon 49 skip
   site           colon 20
   site1          label "To" colon 49 skip
   nbr            colon 20
   nbr1           label "To" colon 49 skip
   efdate         colon 20
   efdate1        label "To" colon 49 skip
   trdate         colon 20
   trdate1        label "To" colon 49 skip
   glref          colon 20
   glref1         label "To" colon 49 skip 
   /*SS - 101213.1 B*/
   variance       COLON 20  
   /*SS - 101213.1 E*/
    SKIP (1)
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).



{wbrp01.i}

repeat:

   if part1 = hi_char then part1 = "".
   if site1 = hi_char then site1 = "".
   if trdate = low_date then trdate = ?.
   if trdate1 = hi_date then trdate1 = ?.
   if efdate = low_date then efdate = ?.
   if efdate1 = hi_date then efdate1 = ?.
   if glref1 = hi_char then glref1 = "".

   if c-application-mode <> 'web' then
   update part part1 site site1 nbr nbr1 efdate efdate1
      trdate trdate1 glref glref1 variance with frame a.

   {wbrp06.i &command = update &fields = " part part1 site site1 nbr nbr1
        efdate efdate1 trdate trdate1 glref glref1 variance" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i part    }
      {mfquoter.i part1   }
      {mfquoter.i site    }
      {mfquoter.i site1   }
      {mfquoter.i nbr     }
      {mfquoter.i nbr1    }
      {mfquoter.i efdate  }
      {mfquoter.i efdate1 }
      {mfquoter.i trdate  }
      {mfquoter.i trdate1 }
      {mfquoter.i glref   }
      {mfquoter.i glref1  }
      {mfquoter.i variance  }

      if part1 = "" then part1 = hi_char.
      if site1 = "" then site1 = hi_char.
      if trdate = ? then trdate = low_date.
      if trdate1 = ? then trdate1 = hi_date.
      if efdate = ? then efdate = low_date.
      if efdate1 = ? then efdate1 = hi_date.
      if glref1 = "" then glref1 = hi_char.

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

   form header
      skip(1)
   with frame a1 page-top width 132.

   view frame a1.

   assign
      gltamt = 0
      gltnbr = ""
      i = 0
      glt_yn = no.

   for each trgl_det no-lock
       where trgl_det.trgl_domain = global_domain and (  (trgl_type =
       "RCT-AVG") ),
       each tr_hist no-lock
       where tr_hist.tr_domain = global_domain and (  (tr_trnbr = trgl_trnbr)
        and (tr_part >= part and tr_part <= part1)
        and (tr_effdate >= efdate and tr_effdate <= efdate1)
        and (tr_date >= trdate and tr_date <= trdate1)
        and ((tr_nbr >= nbr) and (tr_nbr <= nbr1 or nbr1 = ""))
        and (tr_site >= site and tr_site <= site1)
        and (tr_site >= site and tr_site <= site1)
   ) break by tr_part by tr_site by trgl_trnbr
   with frame b width 132 no-box:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      if first-of(tr_part) and not first(tr_part) then do:
         if page-size - line-counter < 8 then page.
         else put skip(1) fill("=", 130) format "x(130)" skip(1).
      end.

      i = i + 1.

      if trgl_gl_ref >= glref and trgl_gl_ref <= glref1 then
         glt_yn = yes.

      if i = 1 then
         gltnbr = trgl_gl_ref.
      else if i = 2 then
         gltnbr = gltnbr + "+".

      gltamt = gltamt + trgl_gl_amt.

      if last-of(trgl_trnbr) and glt_yn then do with frame b:

         find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
         tr_part no-lock no-error.

         if available pt_mstr then do:

            if page-size - line-counter < 4 then page.

            assign
               end_cost = tr_mtl_std + tr_lbr_std + tr_bdn_std +
                          tr_ovh_std + tr_sub_std
               end_qty  = tr_begin_qoh + tr_qty_loc
               end_inv  = end_cost * end_qty
               beg_inv  = end_inv - gltamt
               beg_cost = beg_inv / tr_begin_qoh.

            if beg_cost = ? then
               beg_cost = 0.


            IF  (END_cost - beg_cost) / beg_cost * 100 <= - 1 * variance OR (END_cost - beg_cost) / beg_cost * 100 >= variance THEN DO:      

                v_beg_cost = beg_cost.

                display
                   pt_part
                   tr_site
                   tr_type
                   tr_trnbr
                   gltnbr
                   /*SS - 101221.1 B*/
                   tr_price COLUMN-LABEL "Change!Unit Cost"
                   /*SS - 101221.1 E*/

                   /*SS - 101213.1 B */
                   /*
                   trgl_cr_acct
                   getTermLabel("BEGIN",5) + " :" @ tr_addr no-label
                   tr_begin_qoh @ end_qty
                   beg_cost
                   beg_inv
                   */              
                   v_beg_cost  COLUMN-LABEL "Begin!Unit Cost"
                   end_cost  COLUMN-LABEL "End!Unit Cost"
                   (END_cost - beg_cost) COLUMN-LABEL "Difference!Unit Cost"
                   (END_cost - beg_cost) / beg_cost * 100 COLUMN-LABEL "Variance %"
                    /*SS - 101213.1 E */
                    .
            END.
            /*SS - 101213.1 B */
            /*
            down.

            display
               getTermLabel("CHANGE",6) + ":" @ tr_addr
               tr_qty_loc @ end_qty
               tr_price @ beg_cost
               gltamt @ beg_inv.

            down.

            display
               getTermLabel("END",3) + "   :" @ tr_addr
               end_qty
               end_cost @ beg_cost
               end_inv @ beg_inv.

            if tr_msg > 0 then do:
               {pxmsg.i &MSGNUM=tr_msg &ERRORLEVEL=1 &MSGBUFFER=msg-desc}
               put msg-desc to 129.
            end.

            put skip(1).
            */

            assign
               gltamt = 0
               gltnbr = ""
               i = 0
               glt_yn = no.
         end.

      end.

      {mfrpchk.i}

   end. /*for each*/

   /* REPORT TRAILER */
   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
