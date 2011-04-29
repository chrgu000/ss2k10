/* xxppptmt06.p */
/* REVISION: eb SP5 create 03/12/03 BY: *EAS022* Apple Tam*/

    /* DISPLAY TITLE */
    {mfdtitle.i "eb sp5"}

	 define variable part like pt_part.
	 define variable desc1 like pt_desc2.
	 define variable desc2 like pt_desc2.
	 define variable desc3 like pt_desc2.
	 define variable desc4 like pt_desc2.
	 define variable um like pt_um.
	 define variable vend_part as character format "x(40)".
	 define variable vend_cmmt1 as character format "x(40)".
	 define variable vend_cmmt2 as character format "x(40)".
         define variable del-yn like mfc_logical initial no.
	 define variable version1 as character format "x(3)".
	 define variable spec1 as character format "x(60)".
	 define variable spec2 as character format "x(60)".
	 define variable spec3 as character format "x(60)".
	 define variable vend_date as date.
   vend_date = today.

         /* DISPLAY SELECTION FORM */
         form
            part         colon 20 label "Item Number"
            desc1        colon 53 label "Description"
	    um           colon 20 label "UM"
	    version1     colon 43 label "PPS Version"
	    desc2        colon 53 no-label
	    vend_date    colon 20 label "Created Date"
	    desc3        colon 53 no-label
	    desc4        colon 53 no-label
	    spec1        colon 18 label "Specification"
	    spec2        colon 18 no-label
	    spec3        colon 18 no-label
         with frame a side-labels width 80.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

         form
            vend_part         colon 20 label "Supplier Item"
            vend_cmmt1        colon 20 label "Comments"
            vend_cmmt2        colon 20 no-label
         with frame a1 title color normal "Manufacturer"  side-labels width 80.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a1:handle).



    mainloop:
    repeat:  
        view frame a.
	view frame a1.
      vend_date = today.
      
       display part desc1 um version1 desc2 vend_date desc3 desc4 spec1 spec2 spec3 with frame a.
       update 
          part
        with frame a editing:
           {mfnp.i xxvend_det part xxvend_pt_part part xxvend_pt_part xxvend_pt_part}
             if recno <> ? then do:
		part = xxvend_pt_part.
		vend_part = xxvend_vd_part.
		vend_cmmt1 = xxvend_cmmt1.
		vend_cmmt2 = xxvend_cmmt2.
		version1 = xxvend_version.
		vend_date = xxvend_date.
		spec1 = xxvend_spec1.
		spec2 = xxvend_spec2.
		spec3 = xxvend_spec3.
		find pt_mstr where pt_part = xxvend_pt_part no-lock no-error.
		if available xxvend_det then do:
		um = pt_um.
		desc1 = pt_desc1.
		desc2 = pt_desc2.
		desc3 = pt__chr01.
		desc4 = pt__chr02.
		end.
		else do:
		um = "".
		desc1 = "".
		desc2 = "".
		desc3 = "".
		desc4 = "".
		vend_part = "".
		vend_cmmt1 = "".
		vend_cmmt2 = "".
		version1 = "".
		spec1 = "".
		spec2 = "".
		spec3 = "".
		vend_date = today.
		end.
	         display part desc1 um version1 desc2 vend_date desc3 desc4 spec1 spec2 spec3 with frame a.
		 display vend_part vend_cmmt1 vend_cmmt2 with frame a1.
	     end.
	end.

	find pt_mstr where pt_part = part no-lock no-error.
	if available pt_mstr then do:
		part = pt_part.
		um = pt_um.
		desc1 = pt_desc1.
		desc2 = pt_desc2.
		desc3 = pt__chr01.
		desc4 = pt__chr02.
	         display part desc1 um desc2 desc3 desc4 with frame a.
	    find first xxvend_det where xxvend_pt_part = pt_part no-lock no-error.
	    if available xxvend_det then do:
		part = xxvend_pt_part.
		vend_part = xxvend_vd_part.
		vend_cmmt1 = xxvend_cmmt1.
		vend_cmmt2 = xxvend_cmmt2.
		version1 = xxvend_version.
		vend_date = xxvend_date.
		spec1 = xxvend_spec1.
		spec2 = xxvend_spec2.
		spec3 = xxvend_spec3.
	    end.
	    else do:
		vend_part = "".
		vend_cmmt1 = "".
		vend_cmmt2 = "".
		version1 = "".
		spec1 = "".
		spec2 = "".
		spec3 = "".
		vend_date = today.
	    end.
	         display part desc1 um version1 desc2 vend_date desc3 desc4 spec1 spec2 spec3 with frame a.
		 display vend_part vend_cmmt1 vend_cmmt2 with frame a1.
	end.
	else do:
		um = "".
		desc1 = "".
		desc2 = "".
		desc3 = "".
		desc4 = "".
	         display part desc1 um desc2 desc3 desc4 with frame a.
             {mfmsg.i 16 3}
	     undo, retry.
	end.

     update
        version1
	vend_date
	spec1
	spec2
	spec3
	with frame a.


	    
	    ststatus = stline[2].
            status input ststatus.

	update
	  vend_part
	 go-on(F5 CTRL-D) with frame a1.
/*           {mfnp.i xxvend_det vend_part xxvend_vd_part vend_part xxvend_vd_part xxvend_part}*/
                find xxvend_det where xxvend_pt_part = part and xxvend_vd_part = vend_part no-error.
	        if available xxvend_det then do:
		   vend_cmmt1 = xxvend_cmmt1.
		   vend_cmmt2 = xxvend_cmmt2.
	        end.
		else do:
		   vend_cmmt1 = "".
		   vend_cmmt2 = "".
		end.
		display vend_cmmt1 vend_cmmt2 with frame a1.

	    if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
               del-yn = yes.
               {mfmsg01.i 11 1 del-yn}
               if del-yn then do:
	         find xxvend_det where xxvend_pt_part = part and xxvend_vd_part = vend_part no-error.
		 if available xxvend_det then do:
                  delete xxvend_det.
		 end.
                  clear frame a.
                  clear frame a1.
		part = "".
		um = "".
		desc1 = "".
		desc2 = "".
		desc3 = "".
		desc4 = "".
	         display part desc1 um desc2 desc3 desc4 with frame a.
               end.
	    end.
	       else do: /*f5*/

	          update
	             vend_cmmt1
	             vend_cmmt2
	          with frame a1.

                find xxvend_det where xxvend_pt_part = part and xxvend_vd_part = vend_part no-error.
	        if available xxvend_det then do:
		   xxvend_cmmt1   = vend_cmmt1.
		   xxvend_cmmt2   = vend_cmmt2.
		   xxvend_version = version1.
		   xxvend_date  = vend_date.
		   xxvend_spec1 = spec1.
		   xxvend_spec2 = spec2.
		   xxvend_spec3 = spec3.
	        end.
	        else do:
	         create xxvend_det.
	         assign
	           xxvend_pt_part = part
		   xxvend_vd_part = vend_part
		   xxvend_cmmt1   = vend_cmmt1
		   xxvend_cmmt2   = vend_cmmt2.
		   xxvend_version = version1.
		   xxvend_date  = vend_date.
		   xxvend_spec1 = spec1.
		   xxvend_spec2 = spec2.
		   xxvend_spec3 = spec3.
	        end.
              end. /*f5*/

    
    end. /*mainloop*/

            status input.
