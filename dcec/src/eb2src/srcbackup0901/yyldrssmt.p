/* zzldrssmt.p 		CREATE BY LONG BO								*/
/* 日程单导入子程序，功能类似.5.5.3.3								*/


         {mfdeclre.i}      /*GA75*/

		define input parameter ponbr like po_nbr.
		define input parameter poline like pod_line.
		define input parameter schqty like schd_upd_qty.
		define input parameter schdate as date.

		define variable schtype as integer initial 4.
		define variable prior_cum_qty like schd_upd_qty.
/*GI51*/ define new shared workfile work_schd like schd_det.

		find first poc_ctrl no-lock.
		
		
		do transaction:

			find pod_det where pod_nbr = ponbr and pod_line = poline exclusive.
			find po_mstr where po_nbr = pod_nbr no-lock.
			
			find first sch_mstr where sch_type = 4
					      and sch_nbr = ponbr 
					      and sch_line = poline
					      and sch_rlse_id = pod_curr_rlse_id[1] exclusive-lock.

            /*GI51 REMEMBER CURRENT F/P INDICATORS*/
            for each schd_det exclusive-lock
            where schd_type = sch_type
            and schd_nbr = sch_nbr
            and schd_line = sch_line
            and schd_rlse_id = sch_rlse_id:
               schd__chr02 = schd_fc_qual.
            end.
            /*GI51 END SECTION*/

            /* DO DETAIL MAINTENANCE */
	        {yyldrssmtb.i}  /*judy 05/08/23*/

            for each work_schd
/*J034*/    exclusive-lock:
               delete work_schd.
            end.

            for each schd_det exclusive-lock
            where schd_type = sch_type
            and schd_nbr = sch_nbr
            and schd_line = sch_line
            and schd_rlse_id = sch_rlse_id
            and schd__chr02 = "p" and schd_fc_qual = "f":
               do for work_schd:
                  create work_schd.

                  assign
                         work_schd.schd_discr_qty = schd_det.schd_discr_qty
                         work_schd.schd_date = schd_det.schd_date
                         work_schd.schd__chr01 = schd_det.schd__chr01.
               end.
            end.

            {gprun.i ""rssupb.p"" "(input today + 100000)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            /* UPDATE MRP */

            {gprun.i ""rsmrw.p"" "(input pod_nbr, input pod_line, input yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end.
/*GUI*/ if global-beam-me-up then undo, leave.

