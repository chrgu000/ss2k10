/*By: Neil Gao 08/09/08 ECO: *SS 20080908* */

{mfdeclre.i}

define input parameter iptnbr like sod_nbr.
define input parameter iptline like sod_Line.
define input parameter iptcust like so_cust.
define var yn as logical.
define var yn1 as logical.

find first sod_det where sod_domain = global_domain and sod_nbr = iptnbr and sod_line = iptline no-lock no-error.	

setpack:
do on error undo, retry on endkey undo, leave setpack:
   	form
      sod_det.sod__chr01            colon 10 label "机型"
      sod_det.sod__chr02            colon 10 label "VIN规则"
      /*sod_det.sod__chr07            no-label format "x(4)"*/
      sod_det.sod__chr08            no-label format "x(2)"
      sod_det.sod__chr09            label "号段" format "x(6)"
      sod_det.sod__chr03            colon 10 label "指定表" format "x(1)"
   	with frame set_pack overlay side-labels centered row 16 width 66.
   

		display sod_det.sod__chr01
						sod_det.sod__chr02 
						sod_det.sod__chr03
						/*sod_det.sod__chr07*/
						sod_det.sod__chr08
						sod_det.sod__chr09
   	with frame set_pack.

		if sod_det.sod__chr01 = "" then disp substring(sod_det.sod_part,1,4) @ sod_det.sod__chr01 with frame set_pack.
		find first xxsovd_det where xxsovd_domain = global_domain and xxsovd_nbr = sod_nbr and xxsovd_line = sod_line	no-lock no-error.
		if avail xxsovd_det then yn1 = no.
		else yn1 = yes.
		
		set	sod_det.sod__chr01
				sod_det.sod__chr02
				/*sod_det.sod__chr07*/
				sod_det.sod__chr08
				sod_det.sod__chr09 when yn1
				sod_det.sod__chr03
		with frame set_pack.

/*
		if sod__chr02 <> "" then do:
			find first nr_mstr where nr_domain = global_domain and nr_seqid = sod_det.sod__chr02 no-lock no-error.
    	if not avail nr_mstr then do:
    		message sod_det.sod__chr02 "规则不存在".
    		next-prompt sod_det.sod__chr02.
      	undo ,retry.
			end.
		end.*/
		/*检查vin是否存在*/
/*SS 20090306 - B*/
/*
		if sod__chr02 <> "" then do:
			find first xxsovd_det where xxsovd_domain = global_domain and xxsovd_id = sod__chr02 /*+ sod__chr07*/ + sod__chr08 + string(sod__chr09,"x(6)") no-lock no-error.
			if avail xxsovd_det then do:
				message "VIN已经存在,请重新输入".
				undo,retry.
			end.
		end.
*/
/*SS 20090306 - E*/

/*SS 20090306 - B*/
		if sod__chr09 <> "" and yn1 then do:
			find first xxslc_mstr where xxslc_domain = global_domain
					and xxslc_QianBaWei = sod__chr02 and xxslc_ShiShiYi = sod__chr08 no-error.
			if not avail xxslc_mstr then do:
				create 	xxslc_mstr.
				assign 	xxslc_domain    = global_domain
								xxslc_QianBaWei = sod__chr02
								xxslc_ShiShiYi  = sod__chr08 
								xxslc_last_number = 9 .
			end.
			if int(sod__chr09) + int(sod_qty_ord) > xxslc_last_number then do:
				xxslc_last_number = int(sod__chr09) + int(sod_qty_ord) - 1 .
			end.
			{gprun.i ""xxbomsot02.p"" "(input sod__chr02,input sod__chr08,input int(sod__chr09),input sod_nbr,input sod_line,
																						input sod_part,input sod_qty_ord,output yn)"}
			if not yn then do:
				message "VIN码产生错误".
				undo setpack,retry setpack.
			end.
		end.
/*SS 20090306 - E*/

		if sod__chr03 <> "" then do:
			/*
			find first pt_mstr where pt_domain = global_domain and pt_part = sod_det.sod_part no-lock no-error.
			if avail pt_mstr then 
			find first xxvbom_mstr where xxvbom_domain = global_domain and xxvbom_cust = iptcust and  xxvbom_parent = sod_det.sod_part
	 		and xxvbom_nbr = sod_det.sod__chr03 no-lock no-error.
	 		if not avail xxvbom_mstr and pt_group <> "" then 
			find first xxvbom_mstr where xxvbom_domain = global_domain and  xxvbom_cust = iptcust and  xxvbom_parent = pt_group
	 		and xxvbom_nbr = sod_det.sod__chr03 no-lock no-error.
	 		if not avail xxvbom_mstr  and sod_det.sod__chr03 <> "" then	do:
	    	message sod_det.sod__chr03 "指定件表不存在".
	    	next-prompt sod_det.sod__chr03.
	    	undo ,retry.
	 		end.
	 		*/
	 	end.
		
		find first xxsob_det where xxsob_domain = global_domain and xxsob_nbr = sod_det.sod_nbr
			and xxsob_line = sod_det.sod_line no-lock no-error.
		if not avail xxsob_det then 
    	{gprun.i ""xxscbom.p"" "(INPUT sod_det.sod_part, input sod_det.sod_site, 
    												 input sod_det.sod_nbr ,input sod_det.sod_line,
    												 input sod_det.sod__chr03,input iptcust)"}
 		
			hide frame set_pack no-pause.
/*
			/* 指定件修改 */
			{gprun.i ""xxdysobmt.p"" "(input sod_det.sod_nbr , input sod_det.sod_line )"}
*/ 			
/*SS 20080915 - B*/
			/* 生成评审记录 */
			find first xxcff_mstr where xxcff_key1 = "check" and 	xxcff_key_nbr = sod_det.sod_nbr
			and xxcff_key_line = sod_det.sod_line no-lock no-error.
			if not avail xxcff_mstr then do:
				{gprun.i ""xxsosomtlbx01a.p"" "(input sod_det.sod_nbr , input sod_det.sod_line )"}
/* SS 090918.1 - B */
/*
				if sod__chr03 = "" then do:
					find first xxcff_mstr where xxcff_key1 = "check" and 	xxcff_key_nbr = sod_det.sod_nbr
					and xxcff_key_line = sod_det.sod_line no-error.
					if avail xxcff_mstr and xxcff_nbr = "10" then do:
						xxcff_nbr = "20".
						find first xxcffw_mstr where xxcffw_key1 = "check" and xxcffw_key_nbr = xxcff_key_nbr
	 						and xxcffw_key_line = xxcff_key_line and xxcffw_nbr = xxcff_nbr no-error.
	 					if avail xxcffw_mstr then xxcffw_check = yes.
	 				end.
				end.
*/
/* SS 090918.1 - E */
			end.
/*SS 20080915 - E*/
end. /* setpack: */
hide frame set_pack no-pause.
 