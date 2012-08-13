/* GUI CONVERTED from gppiwkad.p (converter v1.69) Mon Apr  8 13:12:49 1996 */
/* gppiwkad.p - CREATE PRICE WORKFILE RECORD                            */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 8.5      LAST MODIFIED: 03/03/95   BY: afs *J042*          */
/* REVISION: 8.5      LAST MODIFIED: 08/09/95   BY: DAH *J063*          */
/* REVISION: 8.5      LAST MODIFIED: 09/12/95   BY: DAH *J07S*          */
/* REVISION: 8.5      LAST MODIFIED: 04/04/96   BY: DAH *J0H5*          */

/* Create an entry in the pricing workfile based on passed in information.
   (If an existing entry for the same source type exists, it will be
   deleted).


   INPUTS:

      pricing um
      component identifiers (parent, feature and option) (blank for parent)
      source type
	 1 - manual override
	 2 - min price override
	 3 - max price override
	 4 - item master list price
	 5 - terms interest
	 6 - fixed price (?)
	 7 - memo item list price
      amount type
	 1 - list price
	 2 - discount
	 4 - net price
      price
	 list price if amount type is 1; otherwise net price
      discount
	 if price is passed in for discount type list, discount in calculated.
      global application indicator


   OUTPUT:

      The newest addition to the price list workfile.

   A TYPICAL CALL:

      {gprun.i ""gppiwkad.p"" "(sod_um,
				sob_parent,
				sob_feature,
				sob_option,
				""1"",
				""3"",
				price,
				disc,
				false
				)" }


*/
	 {mfdeclre.i}

	 define input        parameter price_um         like pt_um.
	 define input        parameter price_par        like pih_parent.
	 define input        parameter price_feat       like pih_feature.
	 define input        parameter price_opt        like pih_option.
	 define input        parameter price_source     like pih_source.
	 define input        parameter price_amt_type   like pih_amt_type.
	 define input        parameter price_price      as decimal.
	 define input        parameter price_disc       as decimal.
	 define input        parameter price_confg_disc like pih_confg_disc.

	 {pppivar.i}   /* Shared variables for pricing */
	 {pppiwkpi.i}  /* Shared workfile for Price Lists used */

	 define            variable srch_type      like pi_srch_type.
	 define            variable test_amt       like pih_amt.
	 define            variable test_disc      as decimal.
	 define            variable test_factor    as decimal.
	 define            variable test_price     like price_price.
/*J063*/ define            variable test_list      like pi_list.	
/*J07S*/ define            variable test_comb_type like pi_comb_type.


	 /* List Price */
	 if price_amt_type = "1" then do:
	    assign
	       best_list_price = price_price
	       srch_type       = 1
	       test_disc       = 0
	       test_factor     = 0
	       test_price      = price_price
	       test_amt        = test_price .
	 end.

	 /* Discounts */
	 else do:

	    srch_type = 2.

	    /* Calculate disc or price, factor */
	    if price_price <> 0 then assign
	       test_disc  = 1 - ( price_price / best_list_price )
	       test_price = price_price .
	    else assign
	       test_disc  = price_disc / 100.
	       test_price = best_list_price * test_disc.
	    test_factor = 1 - test_disc.
	    test_amt = test_disc * 100.
/*J07S*/    test_comb_type = "9". /*Price calculation is by comb_type and
				    disc_seq.  This insures that "manual"
				    discounts process last.              */

	 end.

	 /* Find old record                                      */
	 /* For list types, we want to make sure that we replace */
	 /* the old record regardless of type; for discount      */
	 /* records, we have to have a matching source.          */
	 find first wkpi_wkfl where wkpi_parent     = price_par
				and wkpi_feature    = price_feat
				and wkpi_option     = price_opt
/*J0H5**			and wkpi_confg_disc = price_confg_disc */
				and (price_amt_type = "1"
				     or wkpi_source = price_source)
				and wkpi_amt_type   = price_amt_type
			      exclusive-lock no-error.

/*J063*/ /* If list price is overridden (overrides do not have "lists"),
	    retain original list for new price list history record.     */

/*J063*/ if available wkpi_wkfl then do:
/*J063*/    if price_amt_type = "1" then
/*J063*/       test_list = wkpi_list.
	    delete wkpi_wkfl.
/*J063*/ end.

	 /* Create price list record */
	 create wkpi_wkfl.
	 assign
/*J063*/    wkpi_list        = test_list
	    wkpi_amt         = test_amt
	    wkpi_amt_type    = price_amt_type
/*J07S*/    wkpi_comb_type   = test_comb_type
	    wkpi_confg_disc  = price_confg_disc
	    wkpi_disc_seq    = 999
	    wkpi_factor      = test_factor
	    wkpi_feature     = price_feat
	    wkpi_option      = price_opt
	    wkpi_parent      = price_par
	    wkpi_srch_type   = srch_type
	    wkpi_source      = price_source
	    wkpi_um          = price_um
	    .
