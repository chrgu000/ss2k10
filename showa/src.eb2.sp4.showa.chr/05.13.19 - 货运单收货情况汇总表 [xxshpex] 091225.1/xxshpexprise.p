/* Revision: eb2sp4	BY: Lambert Xiang  DATE: 12/14/09  ECO: *SS - 20091214.1* */
 
   

define input parameter vend1 like vd_addr.
define input parameter vend2 like vd_addr.
define input parameter date1 like pod_due_date.
define input parameter date2 like pod_due_date.


define var tmpi  as int .
define var i as int.
define var xxss  as char.
define var logs  as char no-undo.
define var lines as char.

{mfdeclre.i}

define temp-table xxreason
  field xxreas   like code_value
  field xxdesc   like code_cmmt
  field xxnum as int 
  index xxreas is primary unique
    xxreas
  index xxnum is unique
    xxnum.
  

define temp-table xxvendexprise 
  field vend like vd_addr
  field vendall as int init 0
  field exprise as int extent 30  
index xxvend is primary unique
  vend.

define temp-table xxshpid
  field shpabsid like abs_id
  field shpid like abs_id
  field shpfrom    like abs_shipfrom
  field shppladate like abs_shp_date
  field shpeffdate like abs_eff_date
index xxid is primary unique
  shpabsid.

/* init var temp-table */
	empty temp-table xxreason.
	empty temp-table xxvendexprise.
	empty temp-table xxshpid.
  tmpi = 0 . 
  logs = "".
  xxss = "".
  if date1 = ? then date1 = low_date.
  if date2 = ? then date2 = hi_date.
  if vend2 = "" then vend2 = hi_char.

levelone:
do transaction :
  /* find reason from code_mstr */
  for each code_mstr no-lock where code_fldname = "scmrcrkms" :
  	find first xxreason no-lock where xxreas = code_value no-error.
  	if not avail xxreason then do:
  		create xxreason.
  		assign 
  		  xxreas = code_value
  		  xxdesc = code_cmmt
  		  .
  		tmpi = tmpi + 1.
      xxnum = tmpi.
  	end.
  end.
  
  /* find shp from abs_mstr */
  for each abs_mstr where abs_shipfrom >= vend1 and abs_shipfrom <= vend2
  	and abs_shp_date >= date1 and abs_shp_date <= date2
  	and abs_type = "r" and substring(abs_status,2,1) = "Y" and abs_id begins "s" :
    find first xxshpid no-lock where shpabsid = abs_id no-error.
    if not avail xxshpid then do:
    	create xxshpid.
    	assign 
    	  shpabsid = abs_id
    	  shpid = substring(abs_id,2,length(abs_id) - 1)
    	  shpfrom = abs_shipfrom
    	  shppladate = abs_shp_date
    	  shpeffdate = abs_eff_date
    	  .
    end.
  end.
  
  /* find exprise from usrw_wkfl */
  for each xxshpid :
  	find first xxvendexprise where vend = shpfrom no-error.
  	if not avail xxvendexprise then do:
  		create xxvendexprise.
  		assign 
  		  vend = shpfrom.
  	end.
  	vendall = vendall + 1.
  	xxss = "scmrcrkms" + shpabsid.
  	for each usrw_wkfl no-lock where usrw_key1 = xxss:
  		find first xxreason where xxreas = usrw_key2 no-error.
  		if not avail xxreason then do:
  			create xxreason.
  			assign 
  			  xxreas = usrw_key2
  			  xxdesc = usrw_key2.
  			tmpi = tmpi + 1.
  			xxnum = tmpi.
  		end.
  		if xxnum <= 30 and xxnum > 0 then do:
  		  exprise[xxnum] = exprise[xxnum] + 1.
  		end.
  		else do:
  			logs = logs + "错误：找到的原因数量超过30种".
  			undo ,leave levelone.
  		end.
  	end.
  end.
  
  /* out put to vend exprise */

  lines = "供应商" + ";" + "收货次数".
  for each xxreason break by xxnum :
  	lines = lines + ";" + xxdesc.
  end.
  put unformat lines skip.
  for each xxvendexprise:
  	lines = vend + ";" + string(vendall).
  	do i = 1 to tmpi :
  		lines = lines + ";" + string(exprise[i]).
  	end.
  	put unformat lines skip.
  end.
  
end.
