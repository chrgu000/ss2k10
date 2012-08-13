/* GUI CONVERTED from gppiwk01.p (converter v1.69) Wed May  8 18:24:56 1996 */
/* gppiwk01.p - CREATE PRICING WORKFILE FROM pih_hist                   */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 8.5      LAST MODIFIED: 02/22/95   BY: afs *J042**/
/* REVISION: 8.5      LAST MODIFIED: 07/11/95   BY: DAH *J05C**/
/* REVISION: 8.5      LAST MODIFIED: 09/11/95   BY: DAH *J07S**/
/* REVISION: 8.5      LAST MODIFIED: 05/07/96   BY: DAH *J0LL**/

/* This routine creates wkpi_wkfl records for a sales order line from
   existing entries for manual price overrides in Pricing History (pih_hist).
   (Only manual overrides are needed because all other records will
   be regenerated as price is recalculated).

   This routine does not affect the pih_hist records.


   INPUTS:

   Price List workfile
   doc type (1 = so
	     2 = qo
	     3 = po
	     4 = fsm thingie)
   order number

   OUTPUT:

   No returned variables.
   wkpi_wkfl records are created.

   A TYPICAL CALL:

      {gprun.i ""gppiwk01.p"" "(1,
				so_nbr,
				so_line,
				)" }


*/
	 {mfdeclre.i}

	 define input        parameter doc_type        like pih_doc_type.
	 define input        parameter ord_nbr         like pih_nbr.
	 define input        parameter line_nbr        like pih_line.

	 {pppiwkpi.i}  /* Shared workfile for Price Lists used */

	 define            variable list_price         like sod_list_pr.


	 /* Make sure workfile is empty */
	 /* (This probably isn't necessary, but at least null loops are fast) */
	 for each wkpi_wkfl EXCLUSIVE-LOCK:
	    delete wkpi_wkfl.
	 end.

/*J0LL*/ /* Delete manual discount from pih_hist if it is due to the coverage */
/*J0LL*/ /* discount for a RMA issue line.  If applicable, it will be recal-  */
/*J0LL*/ /* culated within the calling procedure.                             */
/*J0LL*/ /* NOTE: sod__qadd01 contains the coverage discount percent.         */

/*J0LL*/ if doc_type = 1 then do:
/*J0LL*/    find first pih_hist where pih_doc_type = doc_type and
/*J0LL*/   			      pih_nbr      = ord_nbr  and
/*J0LL*/			      pih_line     = line_nbr and
/*J0LL*/			      pih_parent   = ""       and
/*J0LL*/			      pih_feature  = ""       and
/*J0LL*/			      pih_option   = ""       and
/*J0LL*/			      pih_amt_type = "2"      and
/*J0LL*/		              pih_source   = "1"
/*J0LL*/                        no-error.
/*J0LL*/    if available pih_hist then do:
/*J0LL*/       find sod_det where sod_nbr = ord_nbr and sod_line = line_nbr
/*J0LL*/                    no-lock no-error.
/*J0LL*/       if sod_fsm_type = "RMA-ISS" and pih_amt = sod__qadd01 then
/*J0LL*/          delete pih_hist.
/*J0LL*/    end.
/*J0LL*/ end.

	 /* Create workfile from pih_hist */
	 for each pih_hist where pih_doc_type = doc_type
			     and pih_nbr      = ord_nbr
			     and pih_line     = line_nbr
			     and pih_source   = "1"      /* Manual Overrides */
			   no-lock:

	    create wkpi_wkfl.
	    assign
	       wkpi_amt         = pih_amt
	       wkpi_amt_type    = pih_amt_type
	       wkpi_break_cat   = pih_break_cat
	       wkpi_comb_type   = pih_comb_type
	       wkpi_confg_disc  = pih_confg_disc
	       wkpi_disc_seq    = pih_disc_seq
	       wkpi_feature     = pih_feature
	       wkpi_list        = pih_list
	       wkpi_list_id     = pih_list_id
	       wkpi_min_net     = pih_min_net
	       wkpi_option      = pih_option
	       wkpi_qty         = pih_qty
	       wkpi_parent      = pih_parent
	       wkpi_pid_qty     = pih_pid_qty
	       wkpi_qty_type    = pih_qty_type
	       wkpi_source      = pih_source
	       wkpi_um          = pih_um
	       .

	    /* Manual List Override */
	    if pih_amt_type = "1" then do:
	       wkpi_srch_type = 1.
	       wkpi_factor    = 0.
	    end.
	    /* Discount Override */
	    else do:
	       wkpi_srch_type = 2.

	       /* Calculate discount factor */
/* >>> Maybe this should be stored in pih_hist? */
/* >>> Or it could be passed in.                */

/*J07S*********Calculate wkpi_factor from pih_amt, does not require
**             search for list price from sales order or sales order bill,
**             results in restoring factor to its original value
**
**	       if list_price = 0 then do:
**		  if doc_type = 1 then do:
** /*J05C*/          if pih_option = "" then do:
**		        find sod_det where sod_nbr  = ord_nbr
**				       and sod_line = line_nbr
**				     no-lock no-error.
**                       if available sod_det then
**		           list_price = sod_list_pr.
**                   end.
**		     else do:
**			find sob_det where sob_nbr     = ord_nbr
**				       and sob_line    = line_nbr
**				       and sob_parent  = pih_parent
**				       and sob_feature = pih_feature
**				       and sob_part    = pih_option
**                                   no-lock no-error.
**                      if available sob_det then
**			   list_price = sob_tot_std.
**                   end.
**		  end.
**		  else if doc_type = 2 then do:
**		     if pih_option = "" then do:
**		        find qod_det where qod_nbr  = ord_nbr
**				       and qod_line = line_nbr
**				     no-lock no-error.
**                      if available qod_det then
**		           list_price = qod_list_pr.
**                   end.
**		     else do:
**			find sob_det where sob_nbr     = "qod_det" + ord_nbr
**				       and sob_line    = line_nbr
**				       and sob_parent  = pih_parent
**				       and sob_feature = pih_feature
**				       and sob_part    = pih_option
**                                   no-lock no-error.
**                      if available sob_det then
**			   list_price = sob_tot_std.
**                   end.
**		  end.
**		  /* 3 = PO line */
**		  /* 4 = FSM Contract */
**	       end.
** /*J05C*/    if list_price <> 0 then
**	          wkpi_factor = (list_price - pih_disc_amt) / list_price.
**             else
**		  wkpi_factor = 1.
**J07S*/
/*J07S*/       wkpi_factor = 1 - (pih_amt / 100).

	    end.

	 end.
