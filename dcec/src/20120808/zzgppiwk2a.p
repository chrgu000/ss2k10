/* GUI CONVERTED from gppiwk2a.p (converter v1.69) Thu Jun 27 09:45:22 1996 */
/* gppiwk2a.p - Update pricing workfile's discount amount across config.*/
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 8.5      LAST MODIFIED: 07/07/95   BY: afs *J05C*          */
/* REVISION: 8.5      LAST MODIFIED: 07/11/95   BY: DAH *J05G*          */
/* REVISION: 8.5      LAST MODIFIED: 09/11/95   BY: DAH *J07S*          */
/* REVISION: 8.5      LAST MODIFIED: 05/07/96   BY: DAH *J0LL*          */
/* REVISION: 8.5      LAST MODIFIED: 05/17/96   BY: DAH *J0N2*          */
/* REVISION: 8.5      LAST MODIFIED: 06/10/96   BY: DAH *J0RG*          */
/*!
   This routine is called by gppiwk02.p.  It calculates discounts based
   on the complete end item's best list price.  All discounts are applied
   across the entire configuration

   The field that is updated is wkpi_disc_amt, which is input to
   pih_disc_amt (maintained by gppiwk02.p).
*/

/*!
  *J0RG* No longer processing accrual price lists, accruals are
	 calculated in gppiwk02.p.
*/

	 {mfdeclre.i}

         define            variable calc_seq        like pih_disc_seq.
	 define            variable count_seq       as integer.
	 define            variable jk              as integer.
	 define            variable list_price      as decimal.
	 define            variable seq_factor      as decimal.
	 define            variable seq_disc        like pih_amt.
/*J07S*/ define            variable accum_disc_amt  as decimal.
/*J07S*/ define            variable comb_type       like pih_comb_type.

	 {pppiwkpi.i}  /* Shared workfile for Price Lists used */
	 {pppivar.i}   /* Shared variables for pricing logic */

	 find first pic_ctrl no-lock.

	 /* Calculate discount amounts for discount records.           */
	 /*                                                            */
	 /* Cascading discounts -                                      */
	 /* Discounts are applied in an ordered manner, based on the   */
	 /* discount sequence field in the price list.  The net effect */
	 /* is that subsequent discounts will result in smaller        */
	 /* discount amounts.  I.e. if two 20% discounts are applied   */
	 /* sequentially to a price of 100, the first will result in   */
	 /* a discount amount of 20, and the second in a discount of   */
	 /* 16.  If multiple discounts have the same sequence number,  */
	 /* they will divide the discount amount evenly.  If the two   */
	 /* 20% discounts in the previous example had the same         */
	 /* sequence number, each would have a discount amount of 18.  */
	 /* Note that manually applied discounts are automatically     */
	 /* assigned a priority of 999, which should put them last.    */
	 /*                                                            */
/*J07S*/ /* Process "base" type discounts first since this was required*/
/*J07S*/ /* in calculating "best" price in gppibx04.p.  If amt_type "9"*/
/*J07S*/ /* do not "factor" with other discounts, discount amount for  */
/*J07S*/ /* these have already been set in gppibx04.p due to their     */
/*J07S*/ /* being an "amount off" type of discount.                    */
         /*                                                            */
/*J0LL*/ /* When cascading discount records, exclude where wkpi_factor */
/*J0LL*/ /* equals 1.  The local variable seq_disc is calculated using */
/*J0LL*/ /* factors.  If seq_disc is 0, then a "divide by zero" problem*/
/*J0LL*/ /* occurs (in the form of wkpi_disc_amt being set to ?).      */
/*J0LL*/ /* Note: a factor of 1 represents a 0 discount (it's possible)*/

	 if pic_disc_comb = "1" then do:

	    list_price = best_list_price.
	    do preselect each wkpi_wkfl exclusive-lock
	       where lookup(wkpi_amt_type, "2,3,4,9") <> 0
/*J0LL*/         and wkpi_factor <> 1
/*J07S*/       by wkpi_comb_type by wkpi_disc_seq:

	       find first wkpi_wkfl no-error.

	       repeat while available wkpi_wkfl:

		  assign
/*J07S*/             comb_type  = wkpi_comb_type
		     calc_seq   = wkpi_disc_seq
		     count_seq  = 1
/*J07S*/	     seq_factor = if wkpi_amt_type <> "9" then wkpi_factor
/*J07S*/						  else 1.
/*J07S*/	     seq_disc   = if wkpi_amt_type <> "9" then 1 - wkpi_factor
/*J07S*/                                                  else 0.
		     .

		  find next wkpi_wkfl no-error.
		  repeat while available wkpi_wkfl
/*J07S*/                       and wkpi_comb_type = comb_type
			       and wkpi_disc_seq  = calc_seq:

		     assign
			count_seq  = count_seq + 1
/*J07S*/		seq_factor = if wkpi_amt_type <> "9"
/*J07S*/                             then seq_factor * wkpi_factor
/*J07S*/                             else seq_factor.
/*J07S*/		seq_disc   = if wkpi_amt_type <> "9"
/*J07S*/                             then seq_disc + (1 - wkpi_factor)
/*J07S*/                             else seq_disc.
			.

		     find next wkpi_wkfl no-error.

		  end.

		  do jk = 1 to count_seq:
		     find prev wkpi_wkfl no-error.
		  end.

		  do jk = 1 to count_seq:
/*J07S*/             wkpi_disc_amt = if wkpi_amt_type <> "9"
		                     then ((1 - wkpi_factor) / seq_disc )
		   	                 * (list_price -
				           (list_price * seq_factor) )
/*J07S*/                             else wkpi_disc_amt.
/*J0N2*/             if (wkpi_disc_amt + accum_disc_amt) > best_list_price then
/*J0N2*/                wkpi_disc_amt = best_list_price - accum_disc_amt.
/*J0N2*/             if wkpi_comb_type = "9" and list_price = 0 then
/*J0N2*/                wkpi_disc_amt = (1 - wkpi_factor) * best_list_price.
/*J07S*/             accum_disc_amt = accum_disc_amt + wkpi_disc_amt.
		     find next wkpi_wkfl no-error.
		  end.

/*J07S**	  list_price = list_price * seq_factor.**/
/*J07S*/          list_price = best_list_price - accum_disc_amt.

	       end.

	    end. /* Preselected sort on wkpi_wkfl (wkpi_amt_type = 2,3,4,9) */

/*J0RG**
**	    /* PROCESS ACCRUAL RECORDS */
**	    for each wkpi_wkfl exclusive-lock
**	       where wkpi_amt_type = "8":
** /*J05G**       wkpi_disc_amt = (1 - wkpi_factor) * best_list_price.**/
** /*J05G*/       wkpi_disc_amt = (1 - wkpi_factor) * best_net_price.
**	    end.
**J0RG*/

	 end.  /* Discount calculation for cascading discounts */

	 /* Cumulative Discounts */
	 else do:

	    for each wkpi_wkfl exclusive-lock
/*J0RG**       where lookup(wkpi_amt_type, "2,3,4,8,9") <> 0 */
/*J0RG*/       where lookup(wkpi_amt_type, "2,3,4,9") <> 0
/*J0N2*/       by wkpi_comb_type by wkpi_disc_seq:
/*J0RG** /*J05G*/ if wkpi_amt_type <> "8" then do: */
	          wkpi_disc_amt = (1 - wkpi_factor) * best_list_price.
/*J0N2*/          if wkpi_comb_type <> "9" then
/*J0N2*/             if (wkpi_disc_amt + accum_disc_amt) > best_list_price then
/*J0N2*/                wkpi_disc_amt = best_list_price - accum_disc_amt.
/*J0N2*/          accum_disc_amt = accum_disc_amt + wkpi_disc_amt.
/*J0RG**
** /*J0N2*/       end.
**
** /*J05G*/       else
** /*J05G*/          wkpi_disc_amt = (1 - wkpi_factor) * best_net_price.
**J0RG*/
	    end.

	 end.

