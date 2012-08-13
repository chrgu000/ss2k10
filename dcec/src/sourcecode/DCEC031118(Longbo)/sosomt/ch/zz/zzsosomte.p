/* GUI CONVERTED from sosomte.p (converter v1.69) Sat Mar 30 01:23:40 1996 */
/* sosomte.p - SALES ORDER FEATURES & OPTIONS INPUT                           */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.       */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                         */
/* REVISION: 6.0      LAST MODIFIED: 04/06/90   BY: ftb *D002**/
/* REVISION: 6.0      LAST MODIFIED: 07/06/90   BY: EMB *D040**/
/* REVISION: 6.0      LAST MODIFIED: 11/15/90   BY: emb *D220**/
/* REVISION: 6.0      LAST MODIFIED: 01/15/91   BY: afs *D308**/
/* REVISION: 6.0      LAST MODIFIED: 03/04/91   BY: afs *D396**/
/* REVISION: 6.0      LAST MODIFIED: 04/16/91   BY: afs *D533**/
/* REVISION: 6.0      LAST MODIFIED: 05/28/91   BY: emb *D663**/
/* REVISION: 7.0      LAST MODIFIED: 10/30/91   BY: pma *F003**/
/* REVISION: 7.0      LAST MODIFIED: 04/09/92   BY: emb *F369**/
/* REVISION: 7.0      LAST MODIFIED: 04/13/92   BY: dld *F382**/
/* REVISION: 7.3      LAST MODIFIED: 11/20/92   BY: tjs *G191**/
/* REVISION: 7.3      LAST MODIFIED: 12/08/92   BY: tjs *G391**/
/* REVISION: 7.3      LAST MODIFIED: 06/15/93   BY: tjs *G830**/
/* REVISION: 7.3      LAST MODIFIED: 04/17/93   BY: afs *G970**/
/* REVISION: 7.3      LAST MODIFIED: 07/21/93   BY: tjs *GA64**/
/* REVISION: 7.3      LAST MODIFIED: 07/28/93   BY: tjs *GD80**/
/* REVISION: 7.3      LAST MODIFIED: 08/09/93   BY: tjs *GD99**/
/* REVISION: 7.4      LAST MODIFIED: 10/14/93   BY: cdt *H086**/
/* REVISION: 7.4      LAST MODIFIED: 12/28/93   BY: afs *GI19**/
/* REVISION: 7.4      LAST MODIFIED: 05/06/94   BY: WUG *GJ74**/
/* REVISION: 7.3      LAST MODIFIED: 05/17/94   BY: WUG *GJ87**/
/* REVISION: 7.3      LAST MODIFIED: 06/09/94   BY: WUG *GK20**/
/* REVISION: 7.4      LAST MODIFIED: 07/05/94   BY: tjs *FN95**/
/* REVISION: 7.3      LAST MODIFIED: 06/22/94   BY: WUG *GK60**/
/* REVISION: 8.5      LAST MODIFIED: 11/14/03   BY: *LB01* Long Bo         */

/*GK60*****---> N O T I C E <---*********************************

YOU SHOULD NOT BE MAKING CHANGES TO THIS PROGRAM.  THE PROGRAMS:

  sosomte.p sosomtf.p sosomtg.p sosomth.p sosomtj.p sosomtm.p 
  sosomtn.p

ARE BEING PHASED OUT AND ARE BEING REPLACED BY:

  sosomtf1.p sosomtf2.p sosomtf3.p sosomtf4.p

THESE NEW PROGRAMS ARE IN EFFECT FOR ALL NEW SALES ORDERS CREATED
UPON  INSTALLATION  OF  THIS  PATCH.  HOWEVER, THE PROGRAMS BEING
PHASED OUT WILL COEXIST WITH THE NEW PROGRAMS UNTIL SUCH TIME  AS
ALL  USERS  OF  MFG/PRO  ARE  UP ON THIS SOFTWARE AND "OLD" STYLE
CONFIGURED SALES ORDERS HAVE CYCLED THRU.

**GK60**********************************************************/


/*H086*/ /* Redefined all local variables as new shared for sosomtm.p */

{mfdeclre.i} /*GUI moved to top.*/
define new shared variable comp like ps_comp.
define new shared variable eff_date as date.
define new shared variable use_qty like sob_qty_req.
define new shared variable line as integer initial 9.

define new shared variable sw_constant as character.
define new shared variable sw_new as character.
define new shared variable sw_input as character.
define new shared variable sw_save as character.

{fefile.i  &new="new"}  /* define workfile for features */
define new shared variable ferecno as recid.
/*GA64*  define buffer del_feature for feature. */
define new shared variable temp_part like fe_part.
define new shared variable save_part like fe_part.
/*G191*/ define new shared variable save_loc like pt_loc.
/*G191*/ define new shared variable save_pm_code like pt_pm_code.
/*GA64*  define new shared variable rec as recid extent 100. */
/*GA64*/ define new shared variable rec as recid extent 100.

/*GA64*  define new shared variable ref like ps_ref. */
/*GA64*  define new shared variable par like ps_par. */
/*GA64*/ define new shared variable ref like ps_ref.
/*GA64*/ define new shared variable par like ps_par.
/*GA64*/ define new shared variable phantom_ref like ps_ref no-undo.
/*GA64*/ define new shared variable save_ref like ps_ref.
define new shared variable required as character format "x(9)".
define new shared variable i as integer.
define shared variable sod_recno as recid.
define shared variable so_recno as recid.

define new shared variable open_ref as decimal label "¿É¹©»õ" format ">>>>>9".
define new shared variable new_part like mfc_logical.

define new shared variable open_qty like mrp_qty.

define new shared variable level as integer initial 1.
define new shared variable maxlevel as integer initial 99.
define new shared variable qty as decimal initial 1 no-undo.
define new shared variable save_qty as decimal extent 100 no-undo.
/*GA64*/ define new shared variable record as integer extent 100 no-undo.
/*GA64*/ define new shared variable save_temp like sob_part extent 100 no-undo.
/*GA64*/ define new shared variable effstart as date no-undo.
/*GA64*/ define new shared variable effend as date no-undo.
/*GA64*/ define new shared variable eff_start as date extent 100 no-undo.
/*GA64*/ define new shared variable eff_end as date extent 100 no-undo.
define new shared variable soex_rate like so_ex_rate.
/*G830*/ define new shared variable due_date like sod_due_date.
/*GA64*/ define new shared variable fixed_date like sod_due_date.
/*GA64*/ define new shared variable mfg_lead like pt_mfg_lead.
/*GD80*/ define new shared variable pm_code like pt_pm_code.
/*G830*/ {mfdatev.i}
/*H086*/ define shared variable new_line       like mfc_logical.
/*H086*/ define shared variable lineffdate     like so_due_date.
/*H086*/ define shared variable match_pt_um    like mfc_logical.
/*GJ87*/ define        variable old_style      like mfc_logical.
/*GJ87*/ define        variable pspar          as char.
/*GJ87*/ define        variable psref          as char.
/*FN95*/ define        variable x3             as character format "x(3)".

/* DECLARE SHARED VARIABLES */
/*GUI moved mfdeclre/mfdtitle.*/

ststatus = stline[3].
status default ststatus.

find sod_det where recid(sod_det) = sod_recno no-lock no-error.
find so_mstr where recid(so_mstr) = so_recno no-lock no-error.

/*GJ87*/ find first sob_det where sob_nbr = sod_nbr
/*GJ87*/ and sob_line = sod_line
/*GJ87*/ and length(sob_feature) <= 13
/*GJ87*/ no-lock no-error.
/*GJ87*/ old_style = available sob_det.

comp = sod_part.
use_qty = sod_qty_ord * sod_um_conv.
temp_part = comp.
soex_rate = so_ex_rate.

new_part = yes.
for each sob_det no-lock where sob_nbr = sod_nbr and sob_line = sod_line:
/*F369*
   if substring(sob_feature,13) = comp then new_part = no. */

/*GA64*  if sob_parent = comp then new_part = no. */
/*GJ74 ADD TRIM TO FOLLOWING*/
/*GA64*/ if trim(substring(sob_feature,14,18)) = comp then new_part = no.

  /* PLACE EXISTING SOB_DETs IN WORKFILE                */
  /* SUCCESSIVE FINDS SO RECORD WILL BE IN SORTED ORDER */
/*GJ74 ADD TRIM TO FOLLOWING*/
   find last feature where fe_feature = trim(substring(sob_feature,1,12))
/*GA64*/               and fe_ps_par  = trim(substring(sob_feature,14,18))
/*GA64*/               and fe_ps_ref  = trim(substring(sob_feature,32,12))
/*F369*                and fe_parent  = substring(sob_feature,13) */
/*F369*/               and fe_parent  = sob_parent
		       and fe_part    = sob_part
		     no-error.
   if not available feature then do:

      find last feature where fe_feature = substring(sob_feature,1,12)
/*F369*                   and fe_parent = substring(sob_feature,13) */
/*F369*/                  and fe_parent = sob_parent
			  and fe_part < sob_part no-error.

      if not available feature then
       find last feature where fe_feature = substring(sob_feature,1,12)
/*F369*                   and fe_parent < substring(sob_feature,13) */
/*F369*/                  and fe_parent < sob_parent
			 no-error.

      if not available feature then
/*G191*  find last feature where fe_feature < sob_feature no-error. */
/*G191*/ find last feature where fe_feature < substring(sob_feature,1,12)
/*G191*/ no-error.

      create feature.
/*GJ74 ADD TRIM TO FOLLOWING*/
      assign
	 fe_feature = trim(substring(sob_feature,1,12))
/*F369*  fe_parent = substring(sob_feature,13) */
/*F369*/ fe_parent = sob_parent
/*G191*/ fe_ps_code = trim(substring(sob_feature,13,1))
/*GA64*/ fe_ps_par  = trim(substring(sob_feature,14,18))
/*GA64*/ fe_ps_ref  = trim(substring(sob_feature,32,12))
	 fe_part = sob_part
	 fe_man = no
/*GK20*/ fe_ps_op = int(substr(sob_serial,1,4))
	 fe_def = no
	 fe_price = sob_price.
	 fe_list_pr = sob_tot_std.
	 if fe_list_pr <> fe_price
	    then fe_disc_pct = (1 - (fe_price / fe_list_pr)) * 100.
/*G830*/    else fe_disc_pct = 0.
/*FN95*/ /* begin added block */
	 /* Scrap Percentage - no sob field, use qad_wkfl */
	 x3 = string(sob_line).
	 find qad_wkfl where qad_key1 = "sob_det"
	 and qad_key2 = string(sob_nbr,"x(8)") + string(x3,"x(3)") +
	 string(sob_feature,"x(43)") + sob_part
	 no-error.
	 if available qad_wkfl then fe_scrp_pct = qad_decfld[1].
/*FN95*/ /* end of added block */

      find first pt_mstr where pt_part = fe_part no-lock no-error.
      if available pt_mstr then do:

/*GA64*  {gpsct05.i &part=pt_part &site=sod_site &cost=sct_cst_tot} */
	 fe_um = pt_um.
/*GA64*  fe_std_cost = glxcst. */
	 fe_desc1 = pt_desc1.
	 fe_prod_line = pt_prod_line.
      end.
   end.
   fe_select = sob_qty_req.

end.  /* Each sob_det */

find first ps_mstr use-index ps_parref where ps_par = comp no-lock no-error.
repeat:

   if not available ps_mstr then do:
      /* END OF CHAIN OR NO STRUCTURE, GO BACK UP A LEVEL */
      repeat:
	 level = level - 1.
	 if level < 1 then leave.
	 find ps_mstr where recid(ps_mstr) = rec[level] no-lock no-error.
	 comp = ps_par.
	 qty = save_qty[level].
/*GA64*/ temp_part = save_temp[level].
/*GA64*/ if level = 1 then effstart = ?.
/*GA64*/              else effstart = eff_start[level - 1].
/*GA64*/ if level = 1 then effend = ?.
/*GA64*/              else effend = eff_end[level - 1].
	 find next ps_mstr use-index ps_parref where ps_par = comp
	 no-lock no-error.
	 if available ps_mstr then leave.
      end.
   end.

   if level < 1 then leave.
/*GA64*/ find pt_mstr where pt_part = ps_comp no-lock no-error.

   if (sod_sob_rev = ? or ((ps_start <= sod_sob_rev or ps_start = ?)
			   and (ps_end >= sod_sob_rev or ps_end = ?))) then do:
/*GA64*  find first pt_mstr where pt_part = ps_comp no-lock no-error.*/
/*G191*  if ps_ps_code = "X" then do: */
/*G191*/ if ps_ps_code = "X" or not available pt_mstr then do:

	    /* PHANTOM MANDATORY DEFAULT, SAVE PS & GO A LEVEL DOWN */
	    rec[level] = recid(ps_mstr).
	    save_qty[level] = qty.
/*GA64*/    save_temp[level] = temp_part.
/*GA64*/    if level = 1 then phantom_ref = ps_ref.

/*GA64*/    eff_start[level] = max(effstart,ps_start).
/*GA64*/    if effstart = ? then eff_start[level] = ps_start.
/*GA64*/    if ps_start = ? then eff_start[level] = effstart.
/*GA64*/    eff_end[level] = min(effend,ps_end).
/*GA64*/    if effend = ? then eff_end[level] = ps_end.
/*GA64*/    if ps_end = ? then eff_end[level] = effend.

	    if level < maxlevel or maxlevel = 0 then do:
	       comp = ps_comp.
	       qty = qty * ps_qty_per * (100 / (100 - ps_scrp_pct)).

/*GA64*/       effstart = max(eff_start[level],ps_start).
/*GA64*/       if eff_start[level] = ? then effstart = ps_start.
/*GA64*/       if ps_start = ? then effstart = eff_start[level].
/*GA64*/       effend = min(eff_end[level],ps_end).
/*GA64*/       if eff_end[level] = ? then effend = ps_end.
/*GA64*/       if ps_end = ? then effend = eff_end[level].

	       level = level + 1.
	       find first ps_mstr use-index ps_parref where ps_par = comp
	       no-lock no-error.
	   end.
	   else do:
	       find next ps_mstr use-index ps_parref where ps_par = comp
	       no-lock no-error.
	   end.
      end.  /* end of added phantom part logic */
      else do:

	 if (ps_ps_code = "" or ps_ps_code = "O")
	  and (sod_sob_rev = ? or ((ps_start <= sod_sob_rev or ps_start = ?)
				   and (ps_end >= sod_sob_rev or ps_end = ?)))
	 then do:

/*GA64*/    /* Blow down prod sturcture code on phantoms */
/*GA64*/    if level = 1 then save_ref = ps_ref.
/*GA64*/                 else save_ref = phantom_ref.

	    /*GJ87 CHANGE REFS TO PS_PAR, PS_REF TO PSPAR, PSREF IN FOLLOWING*/
	    if old_style then do:
	       pspar = "".
	       psref = "".
	    end.
	    else do:
	       pspar = ps_par.
	       psref = ps_ref.
	    end.

	    /* SUCCESSIVE FINDS SO RECORD WILL BE IN SORTED ORDER */
/*GA64*     find last  feature where fe_feature = string(ps_ref,"x(12)") */
/*GI19**    find first feature where fe_feature = save_ref **/
/*GI19*/    find last  feature where fe_feature = save_ref
				 and fe_parent  = temp_part
/*GA64*/                         and fe_ps_par  = pspar
/*GA64*/                         and fe_ps_ref  = psref
				 and fe_part    = ps_comp no-error.

	    if not available feature then do:

/*GA64*        find last  feature where fe_feature = string(ps_ref,"x(12)") */
/*GI19**       find first feature where fe_feature = save_ref **/
/*GI19*/       find last  feature where fe_feature = save_ref
				    and fe_parent  = temp_part
/*GA64*/                            and fe_ps_par  = pspar
/*GA64*/                            and fe_ps_ref  = psref
				    and fe_part    < ps_comp no-error.

/*GA64*/       if not available feature then
/*GI19**       find first feature where fe_feature = save_ref **/
/*GI19*/       find last  feature where fe_feature = save_ref
/*GA64*/                            and fe_ps_par  = pspar
/*GA64*/                            and fe_ps_ref  = psref
/*GA64*/                            and fe_parent  = temp_part no-error.

/*GA64*/       if not available feature then
/*GI19**       find first feature where fe_feature = save_ref **/
/*GI19*/       find last  feature where fe_feature = save_ref
/*GA64*/                            and fe_ps_par  = pspar
/*GA64*/                            and fe_ps_ref  = psref
/*GA64*/                            and fe_parent  < temp_part no-error.

	       if not available feature then
/*GA64*        find last feature where fe_feature = string(ps_ref,"x(12)") */
/*GI19**       find first feature where fe_feature = save_ref **/
/*GI19*/       find last  feature where fe_feature = save_ref
				    and fe_parent  < temp_part no-error.

	       if not available feature then
/*GA64*        find last feature where fe_feature < string(ps_ref,"x(12)") */
/*GI19**       find first feature where fe_feature = save_ref **/
/*GI19*/       find last  feature where fe_feature < save_ref
	       no-error.

	       create feature.
	       assign
/*GA64*         fe_feature  = string(ps_ref,"x(12)") */
/*GA64*/        fe_feature  = save_ref
		fe_parent   = temp_part
		fe_part     = ps_comp
/*GK20*/        fe_ps_op    = ps_op
		fe_ps_code  = ps_ps_code
/*GA64*/        fe_ps_par   = pspar
/*GA64*/        fe_ps_ref   = psref
		fe_qty      = use_qty * ps_qty_per * qty.
/*FN95*/        fe_scrp_pct = ps_scrp_pct.

/*GA64*/       if ps_ps_code = "O" then fe_ps_code = ps_ps_code.

	       if new_part = yes then do:
		  if ps_default = yes and ps_mandatory = no
		   then fe_select = ?.

		  if ps_ps_code = "" or
		   (ps_default = yes and ps_mandatory = yes)
		   then fe_select = fe_qty.
	       end.

	       /* Get the part description and default price */
	       find first pt_mstr where pt_part = fe_part no-lock no-error.
	       if available pt_mstr then do:
/*G391*           {gpsct05.i &part=sod_part &site=sod_site &cost=sct_cst_tot}*/
/*G391*           if so_ex_rate = 1.0 then fe_list_pr = pt_price.            */
/*GA64*           {gpsct05.i &part=fe_part &site=sod_site &cost=sct_cst_tot} */
/*H086*/          /* fe_list_pr = pt_price * so_ex_rate. */
/*H086*/          fe_list_pr = pt_price * so_ex_rate * sod_um_conv.
/*GA64*           fe_std_cost = glxcst. */
		  fe_desc1     = pt_desc1.
		  fe_prod_line = pt_prod_line.
/*H086*/          fe_um = pt_um.
	       end.
	       fe_price = fe_list_pr.
/*G191*/       if fe_ps_code = "" then do:
/*G191*/          fe_price = 0. /* Parent already priced w/ std comps */
/*G191*/          fe_list_pr = 0.
/*G191*/       end.
	    end.
	    else fe_qty = fe_qty + use_qty * ps_qty_per * qty.

	    fe_man = ps_mandatory.
	    fe_def = ps_default.
/*G830*/    fe_lt_off = ps_lt_off.
/*G830*/    if fe_list_pr <> fe_price then
/*G830*/    fe_disc_pct = (1 - (fe_price / fe_list_pr)) * 100.
/*G830*/    else fe_disc_pct = 0.

	 end.
	 find next ps_mstr use-index ps_parref
	 where ps_par = comp no-lock no-error.
      end.
   end.
   else find next ps_mstr use-index ps_parref
   where ps_par = comp no-lock no-error.
end.

/*H086*/ /* MOVED FRAME FOPTION MANIPULATION OUT TO sosomtm.p */
/*LB01*//*H086*/ {gprun.i ""zzsosomtm.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

