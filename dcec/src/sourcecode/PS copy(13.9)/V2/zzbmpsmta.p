/* bmpsmta.p - ADD / MODIFY PRODUCT STRUCTURE Cyclical Check (where-used)  */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.    */
/*F0PN*/ /*V8:ConvertMode=NoConvert                                        */
/* REVISION: 1.0       LAST EDIT: 03/13/86      MODIFIED BY: EMB           */
/* REVISION: 1.0       LAST EDIT: 09/18/86      MODIFIED BY: EMB           */
/* REVISION: 5.0       LAST EDIT: 09/26/89               BY: MLB *B316* */
/* REVISION: 7.3       LAST EDIT: 01/26/93      MODIFIED BY: emb *G950* */
/* REVISION: 7.3       LAST EDIT: 07/29/93      MODIFIED BY: emb *GD82* */
/* REVISION: 7.3       LAST EDIT: 02/14/94      MODIFIED BY: pxd * FM16* */

	 define shared variable ps_recno as recid.

	 define variable part like pt_part no-undo.
	 define variable part1 like pt_part no-undo.
	 define variable par like ps_par no-undo.
	 define variable level as integer initial 1 no-undo.
	 define variable maxlevel as integer initial 999 no-undo.
	 define variable record as recid extent 1000 no-undo.
	 define variable site like si_site no-undo.

/*FM16*/ define variable ckrecsz as integer initial 10000.
/*G950*/ define variable skip_par like mfc_logical no-undo.
/*G950*/ define variable ckrecs as character no-undo.

/*G950*/ define shared variable global_user_lang like cmt_lang.
/*G950*/ define shared variable global_user_lang_nbr like lng_nbr.
/*G950*/ define shared variable global_user_lang_dir like lng_dir.

/*G950*  {mfdeclre.i} */

/*FM16*/ find mfc_ctrl where mfc_field = "num_ckrecs" no-lock no-error.
/*FM16*/ if available mfc_ctrl then ckrecsz = mfc_integer.
	 find ps_mstr where recid(ps_mstr) = ps_recno no-lock no-error.
	 if available ps_mstr then do:

	    part1 = ps_comp.
	    part = ps_par.
	    par = ps_par.

	    hide message no-pause.
/*/*B316*/    {mfmsg.i 5004 1} /*  Checking for cyclic structures*/*/               /*marked by kevin,2003/12*/

	    if can-find(first ps_mstr where ps_par = part1 and ps_comp = part)
	    then do:
	       ps_recno = 0.
	       leave.
	    end.

	    find first ps_mstr use-index ps_comp where ps_comp = part
	    no-lock no-error.

	    if ps_recno <> 0 then repeat:
	       if not available ps_mstr then do:
		  for each ptp_det no-lock where ptp_bom_code = par:
		     if ptp_part = part1 then do:
			ps_recno = 0.
			leave.
		     end.

		     {gprun.i ""bmpsmta1.p""
		     "(ptp_part,ptp_site,part1,input-output ps_recno)"}
		     if ps_recno = 0 then leave.
		  end.

/*G950*/          if ps_recno = 0 then leave.

		  for each pt_mstr no-lock where pt_bom_code = par:
		     if pt_part = part1 then do:
			ps_recno = 0.
			leave.
		     end.

		     {gprun.i ""bmpsmta1.p""
		     "(pt_part,site,part1,input-output ps_recno)"}
		     if ps_recno = 0 then leave.
		  end.

/*G950*/          if ps_recno = 0 then leave.

		  repeat:
		     level = level - 1.
		     if level < 1 then leave.
		     find ps_mstr no-lock where recid(ps_mstr) = record[level]
		     no-error.
/*G950*/             do while available ps_mstr:
			part = ps_comp.
			find next ps_mstr no-lock use-index ps_comp
			   where ps_comp = part no-error.
/*G950*                 if available ps_mstr then leave. */
/*G950*/                if not available ps_mstr then leave.

/*G950*/                /* Added section */
			if can-do(ckrecs,string(recid(ps_mstr))) then next.
			leave.
		     end.
		     if available ps_mstr then leave.
/*G950*/             /* End of added section */
		  end.
	       end.
	       if level < 1 then leave.

	       if ps_par = part1 then ps_recno = 0.
	       if ps_recno = 0 then leave.

/*G950*/       /* Added section */
	       skip_par = no.
	       if can-do(ckrecs,string(recid(ps_mstr))) then skip_par = yes.
	       if skip_par = no
/*GD82*/       and level > 1
	       then do:
/*GD82*           if length(ckrecs) < 20000 */
/*GD82*           if length(ckrecs) < 10000 */
/*FM16*/          if length(ckrecs) < ckrecsz
		     then ckrecs = ckrecs + "," + string(recid(ps_mstr)).
	       end.
/*G950*/       /* End of added section */

	       record[level] = recid(ps_mstr).
	       if level < maxlevel
/*G950*/       and skip_par = no
	       then do:
		  par = ps_par.
		  level = level + 1.
		  find first ps_mstr no-lock use-index ps_comp
		  where ps_comp = par no-error.
	       end.
	       else do:
		  find next ps_mstr no-lock use-index ps_comp
		  where ps_comp = par no-error.
	       end.
	    end.
	 end.

	 hide message no-pause.
