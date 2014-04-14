/* ckbmpkrpa.p - KITTING LIST REPORT                                */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert bmpkrpa.p (converter v1.00) Wed Sep 17 11:06:08 1997 */
/* web tag in bmpkrpa.p (converter v1.00) Mon Jul 14 17:24:35 1997 */
/*F0PN*/ /*K10Y*/ /*V8#ConvertMode=WebReport                             */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.0       LAST MODIFIED: 05/12/86      BY: EMB             */
/* REVISION: 1.0       LAST MODIFIED: 08/29/86      BY: EMB *12 *       */
/* REVISION: 1.0       LAST MODIFIED: 01/29/87      BY: EMB *A19*       */
/* REVISION: 2.1       LAST MODIFIED: 09/02/87      BY: WUG *A94*       */
/* REVISION: 4.0       LAST MODIFIED: 02/24/88      BY: WUG *A175*      */
/* REVISION: 4.0       LAST MODIFIED: 04/06/88      BY: FLM *A193*      */
/* REVISION: 4.0       LAST MODIFIED: 07/11/88      BY: flm *A318*      */
/* REVISION: 4.0       LAST MODIFIED: 08/03/88      BY: flm *A375*      */
/* REVISION: 4.0       LAST MODIFIED: 11/04/88      BY: flm *A520*      */
/* REVISION: 4.0       LAST MODIFIED: 11/15/88      BY: emb *A535*      */
/* REVISION: 4.0       LAST MODIFIED: 02/21/89      BY: emb *A654*      */
/* REVISION: 5.0       LAST MODIFIED: 06/23/89      BY: MLB *B159*      */
/* REVISION: 6.0       LAST MODIFIED: 07/11/90      BY: WUG *D051*      */
/* REVISION: 6.0       LAST MODIFIED: 10/31/90      BY: emb *D145*      */
/* REVISION: 6.0       LAST MODIFIED: 02/26/91      BY: emb *D376*      */
/* REVISION: 6.0       LAST MODIFIED: 08/02/91      BY: bjb *D811*      */
/* REVISION: 7.2       LAST MODIFIED: 10/26/92      BY: emb *G234*      */
/* REVISION: 7.2       LAST MODIFIED: 11/04/92      BY: pma *G265*      */
/* REVISION: 7.4       LAST MODIFIED: 09/01/93      BY: dzs *H100*      */
/* REVISION: 7.4       LAST MODIFIED: 12/20/93      BY: ais *GH69*      */
/* REVISION: 7.2       LAST MODIFIED: 03/18/94      BY: ais *FM19*      */
/* REVISION: 7.2       LAST MODIFIED: 03/23/94      BY: qzl *FM31*      */
/* REVISION: 7.4       LAST MODIFIED: 04/18/94      BY: ais *H357*      */
/* REVISION: 7.4       LAST MODIFIED: 10/18/94      BY: jzs *GN61*      */
/* REVISION: 7.4       LAST MODIFIED: 02/03/95      by: srk *H09T       */
/* REVISION: 7.2       LAST MODIFIED: 02/09/95      BY: qzl *F0HQ*      */
/* REVISION: 8.5       LAST MODIFIED: 05/18/94      BY: dzs *J020*      */
/* REVISION: 7.4       LAST MODIFIED: 12/20/95      BY: bcm *G1H5*      */
/* REVISION: 7.4       LAST MODIFIED: 01/22/96      BY: jym *G1JF*      */
/* REVISION: 8.6       LAST MODIFIED: 09/27/97      BY: mzv *K0J *      */
/* REVISION: 8.6       LAST MODIFIED: 10/15/97      BY: ays *K10Y*      */
/* REVISION: 7.4       LAST MODIFIED: 02/04/98      BY: jpm *H1JC*      */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan    */
/* REVISION: 9.0       LAST MODIFIED: 10/16/98      BY: *J32L* Felcy D'Souza */
/* REVISION: 9.0       LAST MODIFIED: 03/13/99      BY: *M0BD* Alfred Tan    */
/*
/*GN61*/ {mfdtitle.i "f+ "}
*/
/*G265*/ {mfdeclre.i}
/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE bmpkrpa_p_1 "As of Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpkrpa_p_2 "Op"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpkrpa_p_3 "(BOM)"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpkrpa_p_4 "(PARENT)"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpkrpa_p_5 " BOM = "
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpkrpa_p_6 "Quantity"
/* MaxLen: Comment: */
/* michael liu */
			define input parameter vsm			like pt_site.
			define input parameter line		like ln_line.
			define input parameter parent		like pt_part.
			define input parameter part 		like pt_part.
			define input parameter qty  		like ld_qty_oh.
			define input parameter op3	 		like ps_op.
			define input parameter op4  		like ps_op.
			define input parameter op5			like ps_op.
			define input parameter op6			like ps_op.
			define input parameter duplicate as logical.
/* ********** End Translatable Strings Definitions ********* */


         define new shared workfile pkdet no-undo
/*G1H5*     field pkpart like pk_part */
/*G1H5*/    field pkpart like ps_comp
/*H100*/    field pkop as integer
/*G1H5*/       format ">>>>>9"
            field pkstart like pk_start
            field pkend like pk_end
            field pkqty like pk_qty
/*F0HQ*/    field pkbombatch like bom_batch
            field pkltoff like ps_lt_off.

/*michael add section*/
/*mic*/ define shared temp-table tblpp
  				field pp_vsm		like pt_site label "W/C"
				field pp_line		like ln_line label "W/C"
				field pp_parent	like pt_part
				field pp_part  	like pt_part
  				field pp_desc1		like pt_desc1
				field pp_desc2		like pt_desc2
  				field pp_promo 	like pt_promo label "Category"
  				field pp_qty 		like pk_qty label "Request Qty"
  				field pp_qty_main like ld_qty_oh label "Main Stk"
				field pp_qty_line like ld_qty_oh label "Line Stk"
				field pp_qty_rcv  like ld_qty_oh label "RCV Stk"
				field pp_qty_iss	like ld_qty_oh label "Issue Qty"
				field pp_qty_per 	like ps_qty_per
				field pp_op  		like ps_op
				field pp_iss_pol	like pt_iss_pol
				field pp_um 		like pt_um
  				index pp_op is primary pp_op pp_promo pp_part pp_parent
				index pp_part pp_part pp_vsm pp_line pp_parent
				index pp_line pp_line pp_parent pp_part.

			define new shared variable comp like ps_comp.
/*GH69*/ define shared variable eff_date as date label {&bmpkrpa_p_1}.
         define variable level as integer no-undo.
/*G234*/ define shared variable site like in_site no-undo.
/*G234*/ define new shared variable parent_bom like pt_bom_code.
/*G265*/ define variable ord_qty like qty column-label "Request QTY" no-undo.
/*G265*/ define shared variable transtype as character format "x(4)".
/*H100*/ define shared variable op  like ro_op format ">>>>>>" no-undo.
/*H100*/ define shared variable op1 like ro_op format ">>>>>>" no-undo.
/*G1H5*/ define variable item-code as character no-undo.
/*G1H5*/ define variable bom-code  as character no-undo.
/*G1H5*/ define variable is-item   as logical   no-undo.

/*FM19*/ define new shared variable phantom like mfc_logical initial yes.
         define buffer ptmstr for pt_mstr.

/*J32L*/ define variable um like bom_batch_um no-undo.
			define variable wkctr like ro_wkctr.
/*J32L*/ define variable batchdesc1 like pt_desc2 no-undo.
/*J32L*/ define variable batchdesc2 like pt_desc2 no-undo.
/*J32L*/ define variable aval as logical no-undo.
/*mich*/	define variable lowlevel as logical no-undo.
/*J32L*/ define variable batchqty like pt_batch no-undo.
/*H100*/ {gpxpld01.i "new shared"}

/*G1H5*/    /* FIND FIRST MATCHING RECORDS */
/*G1H5*/    find first pt_mstr where pt_part = part 
/*G1H5*/    no-lock no-error.

/*G1H5*/    find first bom_mstr where bom_parent = part 
/*G1H5*/    no-lock no-error.

/*G1H5*/    itemloop:
/*g1H5*/    do:

/*G1H5*/       /* DETERMINE WHETHER WE WANT TO EXPLODE THE ITEM OR THE BOM */
/*G1H5*/       if available pt_mstr and available bom_mstr then do:
/*G1H5*/          if pt_part <= bom_parent then do:
/*G1H5*/             is-item = yes.
/*G1H5*/             item-code = pt_part.
/*G1H5*/          end.
/*G1H5*/          else do:
/*G1H5*/             is-item = no.
/*G1H5*/             item-code = bom_parent.
/*G1H5*/          end.
/*G1H5*/       end.
/*G1H5*/       else if available pt_mstr then do:
/*G1H5*/          is-item = yes.
/*G1H5*/          item-code = pt_part.
/*G1H5*/       end.
/*G1H5*/       else if available bom_mstr then do:
/*G1H5*/          is-item = no.
/*G1H5*/          item-code = bom_parent.
/*G1H5*/       end.
/*G1H5*/       /* IF NO MORE ITEMS OR BOMS ARE AVAILABLE THEN WE ARE DONE. */
/*G1H5*/       else leave itemloop.

/*G1H5*/       if is-item then do:
/*G1H5*/           if pt_bom_code > "" then
/*G1H5*/             find bom_mstr where bom_parent = pt_bom_code
/*G1H5*/             no-lock no-error.
/*G1H5*/          else
/*G1H5*/             find bom_mstr where bom_parent = pt_part
/*G1H5*/             no-lock no-error.
/*G1H5*/       end.

/*G1H5*/       /* EXPLODE ALL PRODUCT STRUCTURES FOR ITEMS.  ONLY EXPLODE  *
                * PRODUCT STRUCTURES FOR BOMS IF NO PRODUCT LINE SELECTION *
                * CRITERIA HAS BEEN ENTERED.                               */
/*michael*/		if available bom_mstr then
/*G1H5*/       bomblock:
/*G1H5*/       do:

/*G265*/          comp = bom_parent.

/*G234*/          /* Added section */
/*G1H5*/          if is-item then do:
                     find ptp_det where ptp_part = pt_part
                                    and ptp_site = site
                     no-lock no-error.
                     if available ptp_det then do:
/*J020*/                if index("1234",ptp_joint_type) > 0 then next.
                        if ptp_bom_code > "" then comp = ptp_bom_code.
                     end.
                     else do:
/*J020*/                if index("1234",pt_joint_type) > 0 then next.
                        if pt_bom_code > "" then comp = pt_bom_code.
                        if pt_site <> site then do:
                           find in_mstr where in_part = pt_part
                                          and in_site = site
                           no-lock no-error.
/*G1H5*/                   if not available in_mstr then leave bomblock.
/*G1H5*                    if not available in_mstr then next.          */
                        end.
                     end.
/*G265*/          end.
                  parent_bom = comp.
/*G234*/          /* End of added section*/

                  /* explode part by standard picklist logic */
/*H100*           {gprun.i ""woworla2.p""}                   */
/*H357* /*H100*/  {gprun.i ""woworla.p""}                    */
/*H357*/          {gprun.i ""woworla2.p""}

/*G234*/          /* Added section */
                  find first pkdet where (eff_date = ? or (eff_date <> ?
                                    and (pkstart = ? or pkstart <= eff_date)
/*H100*/                            and (pkend = ? or eff_date <= pkend)))
/*G1H5*/          and ((pkop >= op and (pkop <= op1 or op1 = 0)) or
							  (pkop >= op3 and pkop <= op4) or
							  (pkop >= op5 and pkop <= op6 ) )
/*G1H5*/          no-error.
/*G1H5*/          if not available pkdet then leave bomblock.
/*G234*/          /* End of added section */

/*G234*/          /* Added section */

                  ord_qty = qty.

/* GET DESCRIPTION,UM,BATCH QTY */
          if ((transtype = "FM" )  or
              (transtype = "BM" and not is-item)) then do:
                     {gprun.i ""fmrodesc.p"" "(input parent_bom,
                                               output batchdesc1,
                                               output batchdesc2,
                                               output batchqty,
                                               output um,
                                               output aval)"}
                  end. /* IF transtype = FM */

          if is-item then do:
                     assign batchdesc1 = pt_desc1
                batchdesc2 = pt_desc2.

                     if transtype = "BM" then
            um = pt_um.
          end. /* IF is_item */
			/* michael liu
          if ord_qty = 0 then ord_qty = 1.
			michael Liu */
          for each pkdet where ( eff_date = ? or (eff_date <> ?
                   and (pkstart = ? or pkstart <= eff_date)
                   and (pkend = ? or eff_date <= pkend)))
                   and ((pkop >= op and (pkop <= op1 or op1 = 0)) or
								(pkop >= op3 and pkop <= op4) or
								(pkop >= op5 and pkop <= op6))
						 and pkqty <> 0:
					lowlevel = no.	
					find first ro_det where ro_routing = pkpart  
									and ( eff_date >= ro_start or ro_start = ? ) 
									and ( eff_date <= ro_end or ro_end = ? )
									and ( ro_op >= op3 and ro_op <= op4 )
									no-lock no-error.
				   find first bom_mstr where bom_parent = pkpart 
									no-lock no-error.
					/*
					find first ps_mstr where ps_par = pkpart and ps_qty_per <> 0 
									and ( eff_date >= ps_start or ro_start = ? ) 
									and ( eff_date <= ps_end or ro_end = ? )
									no-lock no-error.
					if available ro_det and available ps_mstr then
					*/
					if available ro_det and available bom_mstr then
					do:
               	lowlevel = yes.
						{gprun.i ""ckbmpkrp5a.p"" 
								 "(input vsm,
									input line, 
									input parent,
									input pkpart,
                           input pkqty * ord_qty / pkbombatch, 
									input op3, 
									input op4, 
									input op5, 
									input op6,
									input duplicate)"}
						
					end.
					find first ro_det where ro_routing = pkpart  
									and ( eff_date >= ro_start or ro_start = ? ) 
									and ( eff_date <= ro_end or ro_end = ? )
									and ( ro_op >= op5 and ro_op <= op6 )
									no-lock no-error.
				   find first bom_mstr where bom_parent = pkpart 
									no-lock no-error.
					/*
					find first ps_mstr where ps_par = pkpart and ps_qty_per <> 0 
									and ( eff_date >= ps_start or ro_start = ? ) 
									and ( eff_date <= ps_end or ro_end = ? )
									no-lock no-error.
					if available ro_det and available ps_mstr then
					*/
					if available ro_det and available bom_mstr then
					do:
               	lowlevel = yes.
						{gprun.i ""ckbmpkrp5a.p"" 
								 "(input vsm,
									input line, 
									input parent,
									input pkpart,
                           input pkqty * ord_qty / pkbombatch, 
									input op3, 
									input op4, 
									input op5, 
									input op6,
									input duplicate)"}
					end.
					/*
					else
					*/
					if duplicate or not lowlevel 
					then
					do:
						find first ro_det where ro_routing = part  
									and ro_op = pkop 
									and ( eff_date >= ro_start or ro_start = ? ) 
									and ( eff_date <= ro_end or ro_end = ? )
									no-lock no-error.
						if available ro_det then wkctr = ro_wkctr.
						else wkctr = line. 
						/*
						wkctr = line.
						*/
						find ptmstr where ptmstr.pt_part = pkpart no-lock no-error.
						find tblpp where pp_part = pkpart and
											  /*
											  pp_vsm	 = vsm and
											  pp_line = wkctr and
											  */
											  pp_vsm	 	= wkctr and
											  pp_line 	= line and
											  pp_parent	= parent and
											  pp_op   	= pkop no-lock no-error.
						if not available tblpp then
						do:
							create tblpp.
							assign
								pp_parent 	= parent
								pp_part 		= pkpart
								/*
								pp_vsm  = vsm
								pp_line = wkctr
								*/
								pp_vsm  		= wkctr
								pp_line 		= line
								pp_op	  		= pkop.
							if available ptmstr then 
								assign
									pp_desc1 	= ptmstr.pt_desc1
									pp_desc2 	= ptmstr.pt_desc2
									pp_um			= ptmstr.pt_um
									pp_iss_pol	= ptmstr.pt_iss_pol
									pp_promo 	= ptmstr.pt_promo.
						end.
						assign
							pp_qty_per = pp_qty_per + pkqty / pkbombatch
							pp_qty = pp_qty + pkqty * ord_qty / pkbombatch.
					end. /* else if available ro_det and available ps_mstr */
				end. /* for each pkdet */	
         end.  /*bomblock: do: */
      end. /* itemloop: do: */

