/* GUI CONVERTED from gppibx04.p (converter v1.71) Sat Feb  5 01:03:20 2000 */
/* gppibx04.p - The very, very best in Pricing subroutines              */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*V8:ConvertMode=Maintenance                                            */
/*M02W*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 8.5      LAST MODIFIED: 02/02/95   BY: afs *J042*          */
/* REVISION: 8.5      LAST MODIFIED: 09/11/95   BY: DAH *J07S*          */
/* REVISION: 8.5      LAST MODIFIED: 05/20/96   BY: DAH *J0N2*          */
/* REVISION: 8.5      LAST MODIFIED: 06/10/96   BY: DAH *J0RG*          */
/* REVISION: 8.5      LAST MODIFIED: 07/19/96   BY: DAH *J0ZW*          */
/* REVISION: 8.5      LAST MODIFIED: 09/25/97   BY: *J21L* Nirav Parikh */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 06/03/98   BY: *J2JJ* Niranjan R.  */
/* REVISION: 9.0      LAST MODIFIED: 12/22/98   BY: *M02W* Luke Pokic   */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan   */
/* REVISION: 9.0      LAST MODIFIED: 04/16/99   BY: *J3DD* Niranjan R.  */
/* REVISION: 9.0      LAST MODIFIED: 01/28/00   BY: *M0JB* Santosh Rao  */

/*!

   This routine winnows through the list of applicable price lists
   and figures out what the price should actually be.

   INPUTS:

   price_par   - Identifies component in configuration (blank for parent)
   price_feat  -
   price_opt   -
   global_flag - indicates whether to consider global price lists
         workfile of prices
   round_fact  - rounding factor (from pic_ctrl)

   OUTPUT:

   net price
   a smaller workfile

*/

     {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE gppibx04_p_1 "基本/非合并"
/* MaxLen: Comment: */

&SCOPED-DEFINE gppibx04_p_2 "基本 / 合并"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


     define input  parameter price_par       like pih_parent.
     define input  parameter price_feat      like pih_feature.
     define input  parameter price_opt       like pih_option.
     define input  parameter global_disc     like pi_confg_disc.
     define input  parameter round_fact      like pic_so_rfact.

     {pppiwkpi.i}  /* Workfile for Price Lists that might apply */
     {pppivar.i}   /* Shared variables for pricing logic */

     define            variable base_factor      as decimal.
     define            variable base_found       as logical.
     define            variable base_comb        as decimal.
     define            variable base_noncomb     as decimal.
     define            variable comb_factor      as decimal.
     define            variable comb_found       as logical.
     define            variable exc_factor       as decimal.
     define            variable exc_found        as logical.
     define            variable list_amt         as decimal.
     define            variable man_factor       as decimal.
     define            variable minmaxerr        as logical.
     define            variable non_comb_factor  as decimal.
     define            variable non_comb_found   as logical.
     define            variable win_price        as integer.
/*J07S*/ define            variable base_comb_net    as decimal.
/*J07S*/ define            variable base_noncomb_net as decimal.
/*J07S*/ define            variable exc_net          as decimal.
/*J07S*/ define            variable base_net         as decimal.
/*J07S*/ define            variable base_amt_off     as decimal.
/*J07S*/ define            variable comb_amt_off     as decimal.
/*J07S*/ define            variable noncomb_amt_off  as decimal.
/*J0RG*/ define            variable accr_base_factor as decimal.
/*J0RG*/ define            variable accr_base_found  as logical.
/*J0RG*/ define            variable accr_base_comb   as decimal.
/*J0RG*/ define            variable accr_base_noncomb as decimal.
/*J0RG*/ define            variable accr_comb_factor as decimal.
/*J0RG*/ define            variable accr_comb_found  as logical.
/*J0RG*/ define            variable accr_exc_factor  as decimal.
/*J0RG*/ define            variable accr_exc_found   as logical.
/*J0RG*/ define            variable accr_non_comb_factor as decimal.
/*J0RG*/ define            variable accr_non_comb_found as logical.
/*J0RG*/ define            variable accr_win_price   as integer.

     find first pic_ctrl no-lock.

     /* Go through price lists that apply and get factors    */
     /* for list price and the four combinable types.        */
     assign list_amt             = best_list_price
        base_factor          = 1
        comb_factor          = 1
        non_comb_factor      = 1
        exc_factor           = 1
        man_factor           = 1
/*J0RG*/        accr_base_factor     = 1
/*J0RG*/        accr_comb_factor     = 1
/*J0RG*/        accr_non_comb_factor = 1
/*J0RG*/        accr_exc_factor      = 1
        .

/*J0N2*/ /* When shared variable found_100_disc is yes, it indicates */
/*J0N2*/ /* that system discounts equal 100%.  Its becomes important */
/*J0N2*/ /* when repricing a sales order/quote line that has a manual*/
/*J0N2*/ /* discount which reduced the discount.  By use of this flag*/
/*J0N2*/ /* it can be determined how to apply any adjustments to the */
/*J0N2*/ /* manual discount when applying multiple discounts are done*/
/*J0N2*/ /* using the cascading method.  Thus, when system discounts */
/*J0N2*/ /* equal 100% (regardless of the line item discount amount) */
/*J0N2*/ /* any manual discount will be applied additively regardless*/
/*J0N2*/ /* of which method of multiple discounts is active.         */

/*J0N2*/ found_100_disc = no.

     /* Set net to list if no discount records found */
     /* (If global, ignore option information;       */
     /* if not global, option info must match).      */
/*J0RG**
**   if global_disc then
**      find first wkpi_wkfl where lookup(wkpi_amt_type, "2,3,4,9") <> 0
**                 and wkpi_confg_disc
**               no-lock no-error.
**   else
**      find first wkpi_wkfl where lookup(wkpi_amt_type, "2,3,4,9") <> 0
**                 and wkpi_parent     = price_par
**                 and wkpi_feature    = price_feat
**                 and wkpi_option     = price_opt
**                 and wkpi_confg_disc = false
**               no-lock no-error.
**
**   if not available wkpi_wkfl then do:
**
**      best_net_price = best_list_price.
**
**   end.
**
**   else do:
**J0RG*/
        /* Determine the best set of discount price lists to use */
        /* (Search for all globals or matching comps)            */
/*J0RG**    for each wkpi_wkfl where lookup(wkpi_amt_type, "2,3,4,9") <> 0 */
/*J0RG*/    for each wkpi_wkfl where lookup(wkpi_amt_type, "2,3,4,8,9") <> 0
                 and ((global_disc and wkpi_confg_disc)
                      or (    wkpi_parent     = price_par
                      and wkpi_feature    = price_feat
                      and wkpi_option     = price_opt
                      and not wkpi_confg_disc
                      and not global_disc)
                      or (wkpi_source = "1"
                      and wkpi_parent  = ""
                      and wkpi_feature = ""
                      and wkpi_option  = "")
                     )
                   no-lock:
           if wkpi_source = "1" then do:
          man_factor = wkpi_factor.
           end.
/*J0RG**       else if wkpi_comb_type = "1" then assign */ /* base */
/*J0RG*/       else if wkpi_comb_type = "1" and wkpi_amt_type <> "8" then
/*J2JJ*/          if best_list_price = 0 and
/*J2JJ*/             (wkpi_amt_type = "3" or wkpi_amt_type = "4") then
/*J2JJ*/             assign
/*J2JJ*/                base_found  = true
/*J2JJ*/                base_factor = if wkpi_amt_type = "3" then
/*J2JJ*/                  wkpi_disc_amt * (1 + wkpi_amt / 100) else
/*J2JJ*/                  wkpi_amt.
/*J2JJ*/          else
/*J0RG*/            assign
                       base_found  = true
/*J07S*/               base_factor = if wkpi_amt_type <> "9" then wkpi_factor
/*J07S*/                                                else base_factor
/*J07S*/               base_amt_off = if wkpi_amt_type = "9" then wkpi_amt
/*J07S*/                                                else base_amt_off.
/*J0RG*/       else if wkpi_comb_type = "1" then
/*J0RG*/          assign
/*J0RG*/          accr_base_found  = true
/*J0RG*/          accr_base_factor = wkpi_factor.
/*J0RG**       else if wkpi_comb_type = "2" then do: */   /* combinable */
/*J0RG*/       else if wkpi_comb_type = "2" and wkpi_amt_type <> "8" then do:
          comb_found  = true.
/*J07S*/          if wkpi_amt_type = "9" then
/*J07S*/             comb_amt_off  = comb_amt_off + wkpi_amt.
/*J07S*/          else
             if pic_disc_comb = "2" then  /* cumulative */
                comb_factor = comb_factor + wkpi_factor - 1.
             else                         /* cascading */
                comb_factor = comb_factor * wkpi_factor.
           end.
/*J0RG*/       else if wkpi_comb_type = "2" then
/*J0RG*/          assign
/*J0RG*/          accr_comb_found  = true
/*J0RG*/          accr_comb_factor = accr_comb_factor + wkpi_factor - 1.
/*J0RG**       else if wkpi_comb_type = "3" then assign */ /* non-combinable */
/*J0RG*/       else if wkpi_comb_type = "3" and wkpi_amt_type <> "8" then
/*J0RG*/          assign
          non_comb_found  = true
/*J07S*/      non_comb_factor = if wkpi_amt_type <> "9" then wkpi_factor
/*J07S*/                                                   else non_comb_factor
/*J07S*/          noncomb_amt_off = if wkpi_amt_type = "9" then wkpi_amt
/*J07S*/                                                  else noncomb_amt_off.
/*J0RG*/       else if wkpi_comb_type = "3" then
/*J0RG*/          assign
/*J0RG*/          accr_non_comb_found  = true
/*J0RG*/          accr_non_comb_factor = wkpi_factor.
/*J0RG**       else if wkpi_comb_type = "4" then assign */ /* exclusive */
/*J0RG*/       else if wkpi_comb_type = "4" and wkpi_amt_type <> "8" then
/*J2JJ*/          if best_list_price = 0 and
/*J2JJ*/             (wkpi_amt_type = "3" or wkpi_amt_type = "4") then
/*J2JJ*/             assign
/*J2JJ*/                exc_found  = true
/*J2JJ*/                exc_factor = if wkpi_amt_type = "3" then
/*J2JJ*/                 wkpi_disc_amt * (1 + wkpi_amt / 100) else
/*J2JJ*/                 wkpi_amt.
/*J2JJ*/          else
/*J0RG*/            assign
                       exc_found  = true
                       exc_factor = wkpi_factor.
/*J0RG*/       else if wkpi_comb_type = "4" then
/*J0RG*/          assign
/*J0RG*/          accr_exc_found  = true
/*J0RG*/          accr_exc_factor = wkpi_factor.

        end.

        /* Determine best discount combination, which is best of:  */
        /*    base + total combinables;                            */
        /*    base + non-combinable;                               */
        /*    exclusive.                                           */
        /* (Types which were not found are disqualified.)          */
        /* (Hardly seems fair, but who's going to complain.)       */

        if pic_disc_comb = "2" then assign
           base_comb    = base_factor + comb_factor - 1
           base_noncomb = base_factor + non_comb_factor - 1 .
        else assign
           base_comb    = base_factor * comb_factor
           base_noncomb = base_factor * non_comb_factor .

/*J0RG*/    accr_base_comb    = accr_base_factor + accr_comb_factor - 1.
/*J0RG*/    accr_base_noncomb = accr_base_factor + accr_non_comb_factor - 1.

        /* YO!! This code is retained as a diagnostic for curious users */
        /* that want to see how the final price is arrived at.          */
        /* Users are not allowed to enter price lists named "factor".   */
        /* (This feature is probably not documented.  If you are        */
        /* reading this code, take this opportunity to demonstrate      */
        /* and show off in front of your friends or users.)             */
        if manual_list = "FACTOR" then display /* Do not translate */
           base_factor colon 30 format ">>>,>>9.99<,<<<"
           comb_factor colon 30 format ">>>,>>9.99<,<<<"
           non_comb_factor  colon 30 format ">>>,>>9.99<,<<<"
           exc_factor  colon 30 format ">>>,>>9.99<,<<<"
           base_comb label {&gppibx04_p_2} colon 30 format ">>>,>>9.99<,<<<"
           base_noncomb label {&gppibx04_p_1} colon 30 format ">>>,>>9.99<,<<<"
           with frame howto side-labels width 80.

/*J2JJ*/ if best_list_price = 0 then
/*J2JJ*/    assign
/*J2JJ*/       base_comb_net    = base_comb       - base_amt_off
/*J2JJ*/                                          - comb_amt_off
/*J2JJ*/       base_noncomb_net = base_noncomb    - base_amt_off
/*J2JJ*/                                          - noncomb_amt_off
/*J2JJ*/       exc_net          =  exc_factor
/*J2JJ*/       base_net         =  base_factor    - base_amt_off .
/*J2JJ*/ else
/*J07S*/    assign
/*J07S*/       base_comb_net    = best_list_price * base_comb
/*J07S*/                                          - base_amt_off
/*J07S*/                                          - comb_amt_off
/*J07S*/
/*J07S*/       base_noncomb_net = best_list_price * base_noncomb
/*J07S*/                                          - base_amt_off
/*J07S*/                                          - noncomb_amt_off
/*J07S*/
/*J07S*/       exc_net          = best_list_price * exc_factor
/*J07S*/
/*J07S*/       base_net         = best_list_price * base_factor
/*J07S*/                                          - base_amt_off
/*J07S*/       .

        if comb_found
/*J07S**       and (not non_comb_found or base_comb < base_noncomb)
*******        and (not exc_found      or base_comb < exc_factor) **/
/*J07S*/       and (not non_comb_found or base_comb_net < base_noncomb_net)
/*J07S*/       and (not exc_found      or base_comb_net < exc_net)
           then assign
           win_price      = 2
           .
        else if non_comb_found
/*J07S**       and (not exc_found or base_noncomb < exc_factor) **/
/*J07S*/       and (not exc_found or base_noncomb_net < exc_net)
           then assign
           win_price      = 3
           .
        else if exc_found
/*J07S**       and (exc_factor < base_factor) **/
/*J21L** /*J07S*/       and (exc_net < base_net) */
/*J21L*/   and (not base_found or exc_net < base_net)
           then assign
           win_price      = 4
           .
        else if base_found then assign
           win_price      = 1
           .

/*J0RG*/    if accr_comb_found
/*J0RG*/       and (not accr_non_comb_found or
/*J0RG*/            accr_base_comb < accr_base_noncomb)
/*J0RG*/       and (not accr_exc_found or
/*J0RG*/        accr_base_comb < accr_exc_factor)
/*J0RG*/       then assign
/*J0RG*/       accr_win_price      = 2
/*J0RG*/       .
/*J0RG*/    else if accr_non_comb_found
/*J0RG*/       and (not accr_exc_found or
/*J0RG*/                accr_base_noncomb < accr_exc_factor)
/*J0RG*/       then assign
/*J0RG*/       accr_win_price      = 3
/*J0RG*/       .
/*J0RG*/    else if accr_exc_found
/*M0JB** /*J0RG*/   and ( accr_exc_factor < accr_base_factor)  */
/*M0JB*/            and (not accr_base_found or
/*M0JB*/                 accr_exc_factor < accr_base_factor)
/*J0RG*/       then assign
/*J0RG*/       accr_win_price      = 4
/*J0RG*/       .
/*J0RG*/    else if accr_base_found then assign
/*J0RG*/       accr_win_price      = 1
/*J0RG*/       .

        /* Go through the file again, deleting the losers */
/*J0RG**    for each wkpi_wkfl where lookup(wkpi_amt_type, "2,3,4,9") <> 0 */
/*J0RG*/    for each wkpi_wkfl where lookup(wkpi_amt_type, "2,3,4,8,9") <> 0
                 and ((global_disc and wkpi_confg_disc)
                      or (    wkpi_parent     = price_par
                      and wkpi_feature    = price_feat
                      and wkpi_option     = price_opt
                      and not wkpi_confg_disc
                      and not global_disc)
                     )
           exclusive-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


           if wkpi_source = "0" then do:
/*J0RG**      if      wkpi_comb_type = "1" and win_price =  4 then */
/*J0RG*/          if      wkpi_comb_type = "1" and ((wkpi_amt_type <> "8" and
/*J0RG*/                                             win_price = 4)        or
/*J0RG*/                                            (wkpi_amt_type  = "8" and
/*J0RG*/                                             accr_win_price = 4)) then
/*J0ZW*/          do:
/*J0ZW*/             /*create wkpi2_wkfl*/
/*J0ZW*/             {gppibx05.i &list=wkpi_list
                 &amttype=wkpi_amt_type
                 &combtype=wkpi_comb_type
                 &breakcat=wkpi_break_cat
                 &pidqty=wkpi_pid_qty
                 &qtytype=wkpi_qty_type
                 &amt=wkpi_amt
                 &promo=""""
                     }
             delete wkpi_wkfl.
/*J0ZW*/          end.
/*J0RG**      else if wkpi_comb_type = "2" and win_price <> 2 then */
/*J0RG*/          else if wkpi_comb_type = "2" and ((wkpi_amt_type <> "8" and
/*J0RG*/                                             win_price <> 2)       or
/*J0RG*/                                            (wkpi_amt_type  = "8" and
/*J0RG*/                                             accr_win_price <> 2)) then
/*J0ZW*/          do:
/*J0ZW*/             /*create wkpi2_wkfl*/
/*J0ZW*/             {gppibx05.i &list=wkpi_list
                 &amttype=wkpi_amt_type
                 &combtype=wkpi_comb_type
                 &breakcat=wkpi_break_cat
                 &pidqty=wkpi_pid_qty
                 &qtytype=wkpi_qty_type
                 &amt=wkpi_amt
                 &promo=""""
                     }
             delete wkpi_wkfl.
/*J0ZW*/          end.
/*J0RG**      else if wkpi_comb_type = "3" and win_price <> 3 then */
/*J0RG*/          else if wkpi_comb_type = "3" and ((wkpi_amt_type <> "8" and
/*J0RG*/                                             win_price <> 3)       or
/*J0RG*/                                            (wkpi_amt_type  = "8" and
/*J0RG*/                                             accr_win_price <> 3)) then
/*J0ZW*/          do:
/*J0ZW*/             /*create wkpi2_wkfl*/
/*J0ZW*/             {gppibx05.i &list=wkpi_list
                 &amttype=wkpi_amt_type
                 &combtype=wkpi_comb_type
                 &breakcat=wkpi_break_cat
                 &pidqty=wkpi_pid_qty
                 &qtytype=wkpi_qty_type
                 &amt=wkpi_amt
                 &promo=""""
                     }
             delete wkpi_wkfl.
/*J0ZW*/          end.
/*J0RG**      else if wkpi_comb_type = "4" and win_price <> 4 then */
/*J0RG*/          else if wkpi_comb_type = "4" and ((wkpi_amt_type <> "8" and
/*J0RG*/                                             win_price <> 4)       or
/*J0RG*/                                            (wkpi_amt_type  = "8" and
/*J0RG*/                                             accr_win_price <> 4)) then
/*J0ZW*/          do:
/*J0ZW*/             /*create wkpi2_wkfl*/
/*J0ZW*/             {gppibx05.i &list=wkpi_list
                 &amttype=wkpi_amt_type
                 &combtype=wkpi_comb_type
                 &breakcat=wkpi_break_cat
                 &pidqty=wkpi_pid_qty
                 &qtytype=wkpi_qty_type
                 &amt=wkpi_amt
                 &promo=""""
                     }
             delete wkpi_wkfl.
/*J0ZW*/          end.
           end.

        end.
/*GUI*/ if global-beam-me-up then undo, leave.


        best_net_price = best_list_price.
        /* Go back through the winning prices and calculate the     */
        /* net price using a method based on the discount amt type. */
        /* This avoids rounding problems that might be caused by    */
        /* recalculating with the factor.                           */
        /*                                                          */
/*J07S*/    /* Process "base" discount first, if any, then process by   */
/*J07S*/    /* sequence number and if more than 1 discount at the same  */
/*J07S*/    /* sequence, process any "amount off" (pih_amt_type =  "9") */
/*J07S*/    /* type discounts last within sequence.                     */
            /*                                                          */
/*J0N2*/    /* Test for a negative net price (not something we want to  */
/*J0N2*/    /* end up with).  If net price goes negative, then set it to*/
/*J0N2*/    /* zero.  Only if discount is "manual" (wkpi_comb_type =    */
/*J0N2*/    /* "9") can we apply it against the current value of the net*/
/*J0N2*/    /* price, since it was calculated based on the existing     */
/*J0N2*/    /* system discounts (i.e. system discounts = 100% and user  */
/*J0N2*/    /* wants to override it to some value less than 100%).  Note*/
/*J0N2*/    /* when this condition occurs the manual discount is applied*/
/*J0N2*/    /* additively, regardless of pricing control file setting.  */

        for each wkpi_wkfl where lookup(wkpi_amt_type, "2,3,4,9") <> 0
                 and ((global_disc and wkpi_confg_disc)
                      or (    wkpi_parent     = price_par
                      and wkpi_feature    = price_feat
                      and wkpi_option     = price_opt
                      and not wkpi_confg_disc
                      and not global_disc)
                      or (wkpi_source = "1"
                      and wkpi_parent  = ""
                      and wkpi_feature = ""
                      and wkpi_option  = "")
                     )
           exclusive-lock
/*J07S*/       by wkpi_comb_type by wkpi_disc_seq by wkpi_amt_type:

           if wkpi_amt_type = "2" then do:           /* disc % */
/*J0N2*/          if best_net_price > 0 then do:
             if pic_disc_comb = "1" then /* cascading */
                best_net_price = best_net_price * (1 - wkpi_amt / 100).
/*J0N2*/         else do:                    /* additive */
                best_net_price = best_net_price
               - (best_list_price * (wkpi_amt / 100) ).
/*J0N2*/                if best_net_price < 0 then
/*J0N2*/                   best_net_price = 0.
/*J0N2*/             end.
/*J0N2*/          end.
/*J0N2*/          else
/*J0N2*/             if wkpi_comb_type = "9" and wkpi_amt < 0 then
/*J0N2*/                best_net_price = - (best_list_price *
/*J0N2*/                                   (wkpi_amt / 100)).
           end.
/*J3DD**   else if wkpi_amt_type = "3" then assign */  /* mark up */
/*J3DD*/   else if wkpi_amt_type = "3" then
/*J3DD*/           if best_list_price = 0 then
/*J3DD*/              assign
/*J3DD*/                 best_net_price = wkpi_disc_amt * (1 + wkpi_amt / 100)
/*J3DD*/                 best_list_price = best_net_price .
                   /* wkpi_disc_amt temporarily holds the cost */
/*J3DD*/           else
/*J3DD*/              assign
                         best_net_price = wkpi_disc_amt * (1 + wkpi_amt / 100)
                         wkpi_disc_amt = 0 .
                else if wkpi_amt_type = "4" then          /* net price */
/*J3DD*/                if best_list_price = 0 then
/*J3DD*/                   assign
/*J3DD*/                      best_net_price = wkpi_amt
/*J3DD*/                      best_list_price = best_net_price .
/*J3DD*/                else
                              best_net_price = wkpi_amt.

           else if wkpi_amt_type = "9" then assign   /* disc amt */
/*J0N2**      best_net_price = best_net_price - wkpi_amt */
/*J0N2*/          best_net_price = if best_net_price - wkpi_amt >= 0 then
/*J0N2*/                              best_net_price - wkpi_amt
/*J0N2*/                           else
/*J0N2*/                              0
          wkpi_disc_amt = wkpi_amt.

/*J0N2*/       if best_net_price = 0 then
/*J0N2*/          found_100_disc = yes.
        end.

/*J2JJ*/ if best_net_price < 0 and best_list_price = 0 then do:
/*J2JJ*/    /* NET PRICE # CANNOT BE USED, NET PRICE SET TO 0 */
/*J2JJ*/    {mfmsg03.i 2610 2 "best_net_price" """" """"}
/*J2JJ*/    best_net_price = 0.
/*J2JJ*/ end. /* IF BEST_NET_PRICE < 0 AND BEST_LIST_PRICE = 0 */

/*J0RG** end.  /* Best discount calculations */ */
