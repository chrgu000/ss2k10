/*yybtbk.p   Basic Data Backup Procedure */
/* Revision: 1.0           BY: Leo Zhou                 DATE: 11/08/07        */

/* ad_mstr      */
/* bom_mstr     */
/* in_mstr      */
/* opm_mstr     */
/* ptp_det      */
/* pt_mstr      */
/* rps_mstr     */
/* wc_mstr      */
/* xxptmp_mstr  */

/*Initialization*/
for each xxad2_mstr :  delete xxad2_mstr.    end.
for each xxbom2_mstr:  delete xxbom2_mstr.   end.
for each xxin2_mstr :  delete xxin2_mstr.    end.
for each xxopm2_mstr:  delete xxopm2_mstr.   end.
for each xxptp2_det :  delete xxptp2_det.    end.
for each xxpt2_mstr :  delete xxpt2_mstr.    end.
for each xxrps2_mstr:  delete xxrps2_mstr.   end.
for each xxwc2_mstr :  delete xxwc2_mstr.    end.
for each xxpp2_mstr :  delete xxpp2_mstr.    end.

/*Backup*/
for each ad_mstr :
       create xxad2_mstr.
       assign xxad2_addr  = ad_addr
              xxad2_name  = ad_name
	      xxad2_line1 = ad_line1
	      xxad2_line2 = ad_line2
	      xxad2_city  = ad_city
	      xxad2_state = ad_state
	      xxad2_zip   = ad_zip
	      xxad2_type  = ad_type
	      xxad2_attn  = ad_attn
	      xxad2_phone = ad_phone.
end.

for each bom_mstr:  
       create xxbom2_mstr.   
       assign xxbom2_parent = bom_parent
	      xxbom2_chr01  = bom__chr01.
end.

for each in_mstr :  
       create xxin2_mstr.
       assign xxin2_part   = in_part
              xxin2_site   = in_site
	      xxin2_user1  = in_user1
	      xxin2_qadc01 = in__qadc01.
end.

for each opm_mstr:  
       create xxopm2_mstr.
       assign xxopm2_std_op = opm_std_op
              xxopm2_desc   = opm_desc
	      xxopm2_wkctr  = opm_wkctr
	      xxopm2_chr01  = opm__chr01.
end.

for each ptp_det :  
       create xxptp2_det.
       assign xxptp2_part  = ptp_part
              xxptp2_site  = ptp_site
	      xxptp2_bom_code = ptp_bom_code
	      xxptp2_routing  = ptp_routing
	      xxptp2_ord_mult = ptp_ord_mult
	      xxptp2_phantom  = ptp_phantom.
end.

for each pt_mstr :  
       create xxpt2_mstr.
       assign xxpt2_part  = pt_part
              xxpt2_desc1 = pt_desc1
	      xxpt2_desc2 = pt_desc2
	      xxpt2_group = pt_group
	      xxpt2_part_type  = pt_part_type
	      xxpt2_status  = pt_status
	      xxpt2_phantom = pt_phantom
	      xxpt2_article = pt_article
	      xxpt2_prod_line = pt_prod_line.
end.

for each rps_mstr:  
       create xxrps2_mstr.
       assign xxrps2_part = rps_part
              xxrps2_site = rps_site
	      xxrps2_line = rps_line
	      xxrps2_due_date = rps_due_date
	      xxrps2_rel_date = rps_rel_date
	      xxrps2_qty_req  = rps_qty_req
	      xxrps2_qty_comp = rps_qty_comp.
end.

for each wc_mstr :  
       create xxwc2_mstr.
       assign xxwc2_wkctr = wc_wkctr
              xxwc2_mch   = wc_mch
	      xxwc2_desc  = wc_desc
	      xxwc2_dept  = wc_dept
	      xxwc2_chr01 = wc__chr01.
end.

for each xxptmp_mstr :  
    create xxpp2_mstr.
    assign xxpp2_par   = xxptmp_par
           xxpp2_comp  = xxptmp_comp
	   xxpp2_site  = xxptmp_site
	   xxpp2_cust  = xxptmp_cust
	   xxpp2_vend  = xxptmp_vend
	   xxpp2_qty_per = xxptmp_qty_per
	   xxpp2_rmks    = xxptmp_rmks.
end.

