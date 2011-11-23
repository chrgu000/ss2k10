/* GUI CONVERTED from icxfer.p (converter v1.78) Thu Aug 31 22:24:04 2006 */
/* icxfer.p - LOCATION TRANSFER SUBROUTINE                                   */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* REVISION: 7.0      LAST MODIFIED: 09/11/91   BY: pma *F003*               */
/* REVISION: 7.0      LAST MODIFIED: 11/11/91   BY: WUG *D887*               */
/* REVISION: 7.0      LAST MODIFIED: 01/24/92   BY: pma *F003*               */
/* REVISION: 7.0      LAST MODIFIED: 01/28/92   BY: pma *F104*               */
/* REVISION: 7.0      LAST MODIFIED: 02/05/92   BY: pma *F167*               */
/* REVISION: 7.0      LAST MODIFIED: 02/10/92   BY: pma *F190*               */
/* REVISION: 7.0      LAST MODIFIED: 02/18/92   BY: pma *F085*               */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: pma *F359*               */
/* REVISION: 7.0      LAST MODIFIED: 06/12/92   BY: pma *F564*               */
/* REVISION: 7.0      LAST MODIFIED: 07/01/92   BY: pma *F701*               */
/* REVISION: 7.0      LAST MODIFIED: 07/09/92   BY: pma *F748*               */
/* Revision: 7.3      Last edit:     09/27/93   By: jcd *G247*               */
/* REVISION: 7.3      LAST MODIFIED: 02/25/93   BY: pma *G745*               */
/* REVISION: 7.3      LAST MODIFIED: 06/21/94   BY: jjs *GK33*               */
/* Oracle changes (share-locks)      09/11/94   BY: rwl *GM31*               */
/* REVISION: 7.3      LAST MODIFIED: 10/04/94   BY: pxd *FR90*               */
/*           7.3                     10/29/94   BY: bcm *GN73*               */
/* REVISION: 8.5      LAST MODIFIED: 01/09/95   BY: taf *J038*               */
/* REVISION: 8.5      LAST MODIFIED: 01/09/95   BY: pma *J040*               */
/* REVISION: 8.5      LAST MODIFIED: 04/23/95   BY: sxb *J04D*               */
/* REVISION: 8.5      LAST MODIFIED: 07/20/95   BY: taf *J053*               */
/*           7.3                     01/16/96   BY: ame *G1K4*               */
/* REVISION: 8.5      LAST MODIFIED: 09/23/96   BY: *G2FZ* Julie Milligan    */
/* REVISION: 8.5      LAST MODIFIED: 11/19/96   BY: *H0PF* Suresh Nayak      */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 03/26/97   BY: *J1M8* Sue Poland        */
/* REVISION: 8.6E     LAST MODIFIED: 03/20/98   BY: *J2F0* Niranjan R.       */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* REVISION: 8.6E     LAST MODIFIED: 06/29/98   BY: *L034* Markus Barone     */
/* REVISION: 8.6E     LAST MODIFIED: 07/15/98   BY: *L024* Bill Reckard      */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* PATTI GAULTNEY    */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *N002* Steve Nugent      */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* myb               */
/* REVISION: 9.1      LAST MODIFIED: 10/03/00   BY: *L14X* Rajesh Thomas     */
/* REVISION: 9.1      LAST MODIFIED: 09/22/00   BY: *N0WT* Mudit Mehta       */
/* REVISION: 9.1      LAST MODIFIED: 12/22/00   BY: *M0XH* Mugdha Tambe      */
/* Revision: 1.26     BY: Irine Fernandes DATE: 11/05/01  ECO: *M1N4*        */
/* Revision: 1.27     BY: Saurabh C.      DATE: 01/12/02  ECO: *M1T5*        */
/* Revision: 1.28     BY: K Paneesh       DATE: 03/12/02  ECO: *N1CP*        */
/* Revision: 1.29     BY: Ellen Borden    DATE: 06/07/01  ECO: *P00G*        */
/* Revision: 1.30     BY: Paul Donnelly   DATE: 12/13/01  ECO: *N16J*        */
/* Revision: 1.31     BY: Jeff Wootton    DATE: 05/14/02  ECO: *P03G*        */
/* Revision: 1.32     BY: Patrick Rowan   DATE: 05/24/02  ECO: *P018*        */
/* Revision: 1.33     BY: Patrick Rowan   DATE: 06/19/02  ECO: *P091*        */
/* Revision: 1.34     BY: Paul Donnelly   DATE: 08/27/02  ECO: *M20F*        */
/* Revision: 1.35     BY: Vandna Rohira   DATE: 03/10/03  ECO: *N26V*        */
/* Revision: 1.38     BY: Narathip W.     DATE: 04/19/03  ECO: *P0Q7*        */
/* Revision: 1.39     BY: Narathip W.     DATE: 05/09/03  ECO: *P0RN*        */
/* Revision: 1.41     BY: Paul Donnelly (SB)   DATE: 06/28/03    ECO: *Q00G* */
/* Revision: 1.42     BY: Dipesh Bector        DATE: 09/01/03    ECO: *P111* */
/* Revision: 1.44     BY: Shoma Salgaonkar     DATE: 09/26/03    ECO: *N2K8* */
/* Revision: 1.45     BY: Vinay Soman          DATE: 01/05/04    ECO: *P1FF* */
/* Revision: 1.46     BY: Shoma Salgaonkar     DATE: 08/25/04    ECO: *Q0CJ* */
/* Revision: 1.46.2.3 BY: Steve Nugent         DATE: 05/09/05    ECO: *P3KV* */
/* Revision: 1.46.2.4 BY: Masroor Alam         DATE: 03/06/06    ECO: *P4K4* */
/* Revision: 1.46.2.5 BY: Masroor Alam         DATE: 03/17/06    ECO: *P4LF* */
/* $Revision: 1.46.2.5 $       BY: Samit Patil          DATE: 08/24/06    ECO: *P536* */

/*-Revision end---------------------------------------------------------------*/
/* ss - 100520.1 by: jack */  /* 增加检料量*/
/* ss - 100630.1 by: jack */


/*V8:ConvertMode=Maintenance                                                 */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
 /* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* THIS PROGRAM IS SIMILAR TO icxfer1.p. CHANGES DONE IN THIS                */
/* PROGRAM MAY ALSO NEED TO BE DONE IN icxfer1.p                             */

/* IT IS A PRE-REQUISITE/ASSUMPTION THAT THE CALLING PROGRAM AFTER           */
/* COMPLETING ANY USER INTERACTIONS WILL SET THE APPROPRIATE VALUE           */
/* TO GLOBAL VARIABLE.                                                       */

{mfdeclre.i}
{cxcustom.i "ICXFER.P"}
{pxpgmmgr.i}

define new shared variable ref like glt_ref.
define shared variable transtype as character format "x(7)"
   initial "ISS-TR".

define input parameter lot like tr_lot.
define input parameter lotserial like sr_lotser no-undo.
define input parameter lotref_from like sr_ref no-undo.
define input parameter lotref_to like sr_ref no-undo.
define input parameter xfer_qty like sr_qty no-undo.
define input parameter nbr like tr_nbr  no-undo.
define input parameter so_job like tr_so_job no-undo.
define input parameter rmks like tr_rmks no-undo.
define input parameter project like trgl_dr_proj no-undo.
define input parameter eff_date as date.
define input parameter site_from like pt_site no-undo.
define input parameter loc_from like pt_loc no-undo.
define input parameter site_to like pt_site no-undo.
define input parameter loc_to like pt_loc no-undo.
define input parameter tempid like mfc_logical no-undo.
define input parameter i_shipnbr  like tr_ship_id      no-undo.
define input parameter i_shipdate like tr_ship_date    no-undo.
define input parameter i_invmov   like tr_ship_inv_mov no-undo.
define input parameter kbtransnbr like kbtr_trans_nbr  no-undo.
define input parameter p_srvendlot like tr_vend_lot    no-undo.

define output parameter glcost like sct_cst_tot.
define output parameter iss_trnbr like tr_trnbr no-undo.
define output parameter rct_trnbr like tr_trnbr no-undo.
define input-output parameter assay like tr_assay.
define input-output parameter grade like tr_grade.
define input-output parameter expire like tr_expire no-undo.

define variable lotser_from like sr_lotser no-undo.
define variable lotser_to like sr_lotser no-undo.
define variable trans-ok like mfc_logical.
define variable consigned_qty like sr_qty no-undo.
define variable dummy_qty like sr_qty no-undo.
define variable procid as character no-undo.

define variable trgl_recno as recid.
define          new shared variable from_entity like en_entity.
define          new shared variable to_entity like en_entity.
define          new shared variable from_cost like glxcst.
define          new shared variable to_cost like glxcst.
define          new shared variable intermediate_acct
   like trgl_dr_acct.
define          new shared variable intermediate_sub
   like trgl_dr_sub.
define          new shared variable intermediate_cc
   like trgl_dr_cc.
define          new shared variable xfer_acct like trgl_dr_acct.
define          new shared variable xfer_sub  like trgl_dr_sub.
define          new shared variable xfer_cc   like trgl_dr_cc.
define variable tempid_pass as integer.
define variable newmtl_tl as decimal.
define variable newlbr_tl as decimal.
define variable newbdn_tl as decimal.
define variable newovh_tl as decimal.
define variable newsub_tl as decimal.
define variable newmtl_ll as decimal.
define variable newlbr_ll as decimal.
define variable newbdn_ll as decimal.
define variable newovh_ll as decimal.
define variable newsub_ll as decimal.
define          new shared variable newcst as decimal.
define          new shared variable glx_mthd like cs_method.
define variable glx_set like cs_set.
define variable cur_mthd like cs_method.
define variable cur_set like cs_set.
define          new shared variable reavg_yn as logical.
define variable msgref like tr_msg.
define variable tmp_amt as decimal no-undo.
define variable gl_tmp_amt as decimal no-undo.
define variable mc-error-number like msg_nbr no-undo.
define variable h_wiplottrace_procs as handle no-undo.
define variable h_wiplottrace_funcs as handle no-undo.
{wlfnc.i}

define variable l_issRecid   as recid         no-undo.
define variable l_rctTrRecid as recid         no-undo.
define variable l_issTrRecid as recid         no-undo.
define variable l_issAssay   like tr_assay    no-undo.
define variable l_issGrade   like tr_grade    no-undo.
define variable l_issExpire  like tr_expire   no-undo.
define variable l_issQoh     like tr_qty_loc  no-undo.

/*ss-20100510.1 add*******************************************************/
define variable xx_nbr           like lad_nbr   no-undo.
define variable xx_line          like lad_line  no-undo.
define variable xx_part          like lad_part  no-undo.
define variable xx_site          like lad_site  no-undo.
define variable xx_loc           like lad_loc   no-undo.
define variable xx_lot           like lad_lot   no-undo.
define variable xx_ref           like lad_ref   no-undo.
define variable xx_qty           like lad_qty_all   no-undo.
define variable xx_qty2           like lad_qty_all   no-undo.
define variable xxld_qty           like lad_qty_all   no-undo.
define variable xxld_qty2           like lad_qty_all   no-undo.
/*ss-20100510.1 add*******************************************************/

/* CONSIGNMENT INVENTORY VARIABLES */
{pocnvars.i}
define variable issTrNbrString as character no-undo.
define variable xfer_without_ownership_change as logical no-undo.

{&ICXFER-P-TAG1}

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.
find first icc_ctrl  where icc_ctrl.icc_domain = global_domain no-lock.
find first clc_ctrl  where clc_ctrl.clc_domain = global_domain no-lock no-error.
if not available clc_ctrl
then do:
   {gprun.i ""gpclccrt.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

   find first clc_ctrl  where clc_ctrl.clc_domain = global_domain no-lock.
end.

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input ENABLE_SUPPLIER_CONSIGNMENT,
           input 11,
           input ADG,
           input SUPPLIER_CONSIGN_CTRL_TABLE,
           output using_supplier_consignment)"}
/*GUI*/ if global-beam-me-up then undo, leave.


find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
global_part no-lock no-error.
if not available pt_mstr
then
   return.
find pl_mstr  where pl_mstr.pl_domain = global_domain and  pl_prod_line =
pt_prod_line no-lock no-error.

assign
   from_cost = 0
   to_cost   = 0.

do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.

   if tempid
   then do:
      find sct_det where recid(sct_det) = recno no-error.
      tempid_pass = 1.
   end.
   else do:
      {gpsct06.i &part=global_part &site=site_from &type=""GL""}
      tempid_pass = 0.
   end.
end.
/*GUI*/ if global-beam-me-up then undo, leave.

if available sct_det
then
   from_cost = sct_cst_tot.

/*DETERMINE COSTING METHOD*/
{gprun.i ""csavg01.p"" "(input global_part,
                         input site_to,
                         output glx_set,
                         output glx_mthd,
                         output cur_set,
                         output cur_mthd)"
}
/*GUI*/ if global-beam-me-up then undo, leave.


/*UPDATE CURRENT COST & POST ANY GL DISCREPANCY*/
if (glx_mthd = "AVG"
or cur_mthd = "AVG"
or cur_mthd = "LAST")
and site_from <> site_to
then
   /* ADDED 8th INPUT PARAMETER AS RECEIVING */
   /* SITES CONSIGNMENT INVENTORY USAGE      */

   {gprun.i ""csavg02.p"" "(input global_part,
                            input site_to,
                            input ""ISS-TR"",
                            input kbtransnbr,
                            input recid(sct_det),
                            input nbr,
                            input xfer_qty,
                            input 0,
                            input 0,
                            input glx_set,
                            input glx_mthd,
                            input cur_set,
                            input cur_mthd,
                            output newmtl_tl,
                            output newlbr_tl,
                            output newbdn_tl,
                            output newovh_tl,
                            output newsub_tl,
                            output newmtl_ll,
                            output newlbr_ll,
                            output newbdn_ll,
                            output newovh_ll,
                            output newsub_ll,
                            output newcst,
                            output reavg_yn,
                            output msgref)"
   }
/*GUI*/ if global-beam-me-up then undo, leave.


if site_from = site_to
then
   reavg_yn = no.

{gprun.i ""icxfera.p"" "(input nbr,
                         input lot,
                         input site_from,
                         input site_to,
                         input tempid)"
}
/*GUI*/ if global-beam-me-up then undo, leave.


lotser_from = right-trim(substring(lotserial,1,18)).
if right-trim(substring(lotserial,40,1)) = "#"
then
   lotser_to = "".
else
if right-trim(substring(lotserial,19)) = ""
then
   lotser_to = lotser_from.
else
   lotser_to = right-trim(substring(lotserial,19,18)).

/*TRANSFER PROCESSING*/
do transaction:

   /*ISSUE --> TRANSFER CLEARING*/
   find pld_det  where pld_det.pld_domain = global_domain and  pld_prodline  =
   pt_prod_line
                  and pld_site      = site_from
                  and pld_loc       = loc_from
                  no-lock no-error.
   if not available pld_det
   then
      find pld_det
         where pld_det.pld_domain = global_domain
           and pld_prodline       = pt_prod_line
           and pld_site           = site_from
           and pld_loc            = ""
      no-lock no-error.
   if not available pld_det
   then
      find pld_det
         where pld_det.pld_domain = global_domain
           and pld_prodline       = pt_prod_line
           and pld_site           = ""
           and pld_loc            = ""
      no-lock no-error.

   /* IF THIS IS PROCESSING AN MO SHIPMENT, THEN FSEOIVTR.P
   CREATED A SPECIAL QAD_WKFL RECORD CONTAINING SOME
   EXTRA INFORMATION FOR ICXFER.P TO GET LOADED INTO THE
   NEW TR_HISTS BEING CREATED... */
   find qad_wkfl  where qad_wkfl.qad_domain = global_domain and  qad_key1 =
   mfguser
                   and qad_key2 = "SEO" + nbr
                   no-lock no-error.

   /* STORING INVENTORY ATTRIBUTES INTO LOCAL VARIABLES. SINCE       */
   /* ictrans.i DELETES ld_det WITH ZERO QOH AND TEMPORARY LOCATION  */

   /* WHEN LOCATION IS TEMPORARY AND +VE INVENTORY TRANSFER OCCURS  */
   /* ATTRIBUTES OF LOCATION WHERE INVENTORY IS REDUCING ARE STORED */
   /* IN LOCAL VARIABLES */


/*ss-20100510.1 add*******************************************************/

xx_qty = xfer_qty.
xx_qty2 = xfer_qty.
xxld_qty = 0.
xxld_qty2 = 0.
repeat:  
   xx_qty = xx_qty2.
   if xx_qty > 0 then do:   /* bbb */
            
       find first lad_det
                where lad_det.lad_domain = global_domain and  lad_dataset =
                "wod_det"
               and   lad_part = global_part and lad_site = site_from
               and   lad_loc = loc_from and lad_lot = lotser_from
               and   lad_ref = lotref_from
            no-error.
            /* IF SNGL LOT AND LAD EXISTS THEN ALLOCATE ALL TO EXISTING */
            /* LAD_DET */
            if available lad_det then do:
                	       assign  
                		 xx_nbr  = lad_nbr  
                		 xx_line = lad_line 
                		 xx_part = lad_part 
                		 xx_site = lad_site 
                		 xx_loc  = lad_loc  
                		 xx_lot  = lad_lot  
                		 xx_ref  = lad_ref.
                		 
                           /* ss -100520.1 -b 
                		 xx_qty = lad_qty_all.
                                 lad_qty_all = lad_qty_all - xx_qty2.
                         ss - 100520.1 -e */
                           /* ss - 100520.1 -b */
                           /* ss - 100630.1 -b
                           xx_qty = lad_qty_all + lad_qty_pick.
                                 lad_qty_all = lad_qty_all + lad_qty_pick - xx_qty2.
                                 ss - 100630.1 -e */
                           /* ss - 100630.1 -b */
                           xx_qty = lad_qty_all + lad_qty_pick.
                           IF lad_qty_all >=  xx_qty2  THEN
                               lad_qty_all = lad_qty_all - xx_qty2.
                           ELSE DO:
                              lad_qty_pick = lad_qty_pick - ( xx_qty2  - lad_qty_all ) .
                              lad_qty_all = 0 .
                            
                           END.
                           /* ss - 100630.1 -e */


                            /* ss - 100520.1 -e */
         
                           /* ss - 100630.1 -b
                		 if lad_qty_all <= 0  then do:
                         ss - 100630.1 -e */
                           /* ss - 100630.1 -b */
                             if lad_qty_all <= 0  AND lad_qty_pick <= 0  then do:
                           /* ss - 100630.1 -e */
                		    delete lad_det.
                	        end. /*if xx_qty <= xx_qty2 then do*/
            	    end.  /* availa lad_det */
            	    else do:
            	        xx_qty = 0.
            	    end.  /* not ava lad_det  */
/************************************************************************/
      
            if xx_qty > 0 then do:   /* bb */
            	       find first lad_det
                                     where lad_det.lad_domain = global_domain and  lad_dataset =
                                     "wod_det"
                                       and lad_nbr  = xx_nbr
            			   and lad_line = xx_line
            			   and lad_part = global_part
            			   and lad_site = site_to
            			   and lad_loc  = loc_to 
            			   and lad_lot  = lotser_to 
            			   and lad_ref  = lotref_to 
                                   no-error.	

                  if available lad_det then do:

	                  if xx_qty <= xx_qty2 then do:
                        
        		             lad_qty_all = lad_qty_all + xx_qty.
                          
                              xxld_qty = xx_qty.
        		             xx_qty2 = xx_qty2 - xx_qty.
		             end.
			         else do:
        		             lad_qty_all = lad_qty_all + xx_qty2.
        			         xxld_qty = xx_qty2.
        		             xx_qty2 = xx_qty2 - xx_qty.			     
		             end.
		        end.
		        else do:
                           create lad_det. lad_det.lad_domain = global_domain. 
               		   assign                                              
               		      lad_dataset = "wod_det"                          
               		      lad_nbr = xx_nbr                                
               		      lad_line = xx_line                        
               		      lad_site = site_to                              
               		      lad_loc = loc_to                                 
               		      lad_part = global_part                              
               		      lad_lot = lotser_to                                 
               		      lad_ref = lotref_to.
        			      if xx_qty <= xx_qty2 then do:
        			         lad_qty_all = xx_qty.  
        			         xxld_qty = xx_qty.
        				     xx_qty2 = xx_qty2 - xx_qty.
        			      end.
        			      else do:
        			         lad_qty_all = xx_qty2.
        			         xxld_qty = xx_qty2.
        				     xx_qty2 = 0.
        			      end.
			                                                       
               		   if recid(lad_det) = -1 then .                       
		       end.

/*			  find first ld_det where ld_domain = global_domain
			                      and ld_site = site_to
					      and ld_loc  = loc_to
					      and ld_part = global_part
					      and ld_lot  = lotser_to
					      and ld_ref  = lotref_to
					      no-error.
			        if available ld_det then do:
			        end. /*if available ld_det then do*/  
*/
               xxld_qty2 = xxld_qty2 + xxld_qty.
	           xxld_qty = 0.
                
               
	 end. /*if xx_qty > 0 then do:*/  /* bb */
    
/************************************************************************/
    end. /*if xfer_qty > 0 then do:*/  /* bbb */

    if xx_qty <= 0 then leave.
end. /*repeat*/
/*ss-20100510.1 end*******************************************************/

   if xfer_qty > 0
   then
      if can-find(first loc_mstr
                   where loc_mstr.loc_domain = global_domain and  loc_site =
                   site_from
                    and loc_loc  = loc_from
                    and loc_perm = no)
      then do:

         for first ld_det
            fields( ld_domain ld_site  ld_loc   ld_part ld_lot ld_ref ld_expire
                   ld_assay ld_grade ld_qty_oh )
             where ld_det.ld_domain = global_domain and  ld_site = site_from
              and ld_loc  = loc_from
              and ld_part = global_part
              and ld_lot  = lotser_from
              and ld_ref  = lotref_from
            no-lock:

            assign
               l_issAssay  = ld_assay
               l_issGrade  = ld_grade
               l_issExpire = ld_expire
               l_issQoh    = ld_qty_oh.

         end. /* FOR FIRST ld_det */

      end. /* IF CAN-FIND(loc_mstr...) */

   if from_entity <> to_entity then do:
       /*GET THE INTER-COMPANY ACCOUNT OF THE TO ENTITY */
       {glenacex.i &entity=to_entity
                   &type='"DR"'
                   &module='"IC"'
                   &acct=intermediate_acct
                   &sub=intermediate_sub
                   &cc=intermediate_cc }
   end.

/*ss-20100510.1   {ictrans.i   */
/*ss-20100510.1*/   {xxictrans.i
      &addrid=global_addr
      &bdnstd=0
      &cracct="
        if available pld_det then pld_inv_acct
        else pl_inv_acct"
      &crsub="
        if available pld_det then pld_inv_sub
        else pl_inv_sub"
      &crcc="
        if available pld_det then pld_inv_cc
        else pl_inv_cc"
      &crproj=project
      &curr=""""
      &dracct=intermediate_acct
      &drsub=intermediate_sub
      &drcc=intermediate_cc
      &drproj=project
      &effdate=eff_date
      &exrate=0
      &exrate2=0
      &exratetype=""""
      &exruseq=0
      &glamt="from_cost * xfer_qty"
      &kbtrans=kbtransnbr
      &lbrstd=0
      &line=0
      &location=loc_from
      &lotnumber=lot
      &lotref=lotref_from
      &lotserial=lotser_from
      &mtlstd=0
      &ordernbr=nbr
      &ovhstd=0
      &part=global_part
      &perfdate=?
      &price=from_cost
      &quantityreq=0
      &quantityshort=0
      &quantity="- xfer_qty"
      &quantity2="- xxld_qty2"
      &revision=""""
      &rmks=rmks
      &shiptype=""""
      &site=site_from
      &shipnbr=i_shipnbr
      &shipdate=i_shipdate
      &invmov=i_invmov
      &slspsn1=""""
      &slspsn2=""""
      &sojob=so_job
      &substd=0
      &transtype=""ISS-TR""
      &msg=trmsg
      &ref_site=site_to
      &tempid=tempid_pass
      }

   assign
      iss_trnbr    = tr_trnbr
      l_issRecid   = recid(ld_det)
      l_issTrRecid = recid(tr_hist)
      issTrNbrString = string(tr_trnbr)
      xfer_without_ownership_change = no
      .

   if p_srvendlot <> ""
   then
      tr_vend_lot  = p_srvendlot.


   /* STORING INVENTORY ATTRIBUTES AND QOH  OF ISSUE-LOCATION */
   if available ld_det
   then
      assign
         l_issAssay  = ld_assay
         l_issGrade  = ld_grade
         l_issExpire = ld_expire
         l_issQoh    = ld_qty_oh.

   /* TRANSFER CONSIGNMENT RECEIPT RECORDS */
   /* WHEN MOVING TO/FROM INSPECTION.      */
   if using_supplier_consignment
   then
      {gprunmo.i
         &program = "icxfercn.p"
         &module = "ACN"
         &param = """(input tr_trnbr,
                      input nbr,
                      input so_job,
                      input pt_part,
                      input pt_um,
                      input lotserial,
                      input lotref_from,
                      input lotref_to,
                      input xfer_qty,
                      input site_from,
                      input loc_from,
                      input site_to,
                      input loc_to,
                      input eff_date,
                      output xfer_without_ownership_change,
                      output consigned_qty)"""}

   if is_wiplottrace_enabled()
   then do:
      h_wiplottrace_procs = session:first-procedure.

      do while valid-handle(h_wiplottrace_procs)
           and index(h_wiplottrace_procs:filename, "wlpl") = 0:
         h_wiplottrace_procs = h_wiplottrace_procs:next-sibling.
      end.

      if valid-handle(h_wiplottrace_procs)
         and index(h_wiplottrace_procs:filename, "wlpl") > 0
      then
         run store_transaction_number
            in h_wiplottrace_procs(tr_trnbr).

   end. /* if is_wiplottrace_enabled() */

   /* LOAD MO-SPECIFIC FIELDS, IF NECESSARY */
   if available qad_wkfl
   then
      assign tr_prod_line = qad_charfld[1]
             tr_eng_code  = qad_charfld[2]
             tr_fcg_code  = qad_charfld[3]
             tr_fsm_type  = qad_charfld[4]
             tr_line      = integer(qad_decfld[1]).
      {&ICXFER-P-TAG2}
if lot = ""
then
      assign
         lot    = string(tr_trnbr modulo 1000000,"999999") + "*"
         tr_lot = lot.

   if transtype begins "ISS"
   then
      assign
         assay  = tr_assay
         grade  = tr_grade
         expire = tr_expire.
   else if transtype begins "RCT"
   then
      assign
         tr_assay  = assay
         tr_grade  = grade
         tr_expire = expire.

   /*TRANSFER CLEARING --> TRANSFER VARIANCE*/
   if (from_entity <> to_entity)
   or (from_cost <> to_cost)
   then do:
      if from_entity <> to_entity then do:
          /* GET THE INTERCOMPANY ACCOUNT OF THE FROM ENTITY */
          {glenacex.i &entity=from_entity
                       &type='"CR"'
                       &module='"IC"'
                       &acct=intermediate_acct
                       &sub=intermediate_sub
                       &cc=intermediate_cc }
      end.
      /*OTHERWISE, THE intermediate_acct HAS ALREADY BEEN SET TO THE*/
      /*INVENTORY TRANSFER CLEARING ACCOUNT BY icxfera.p */

      /* RECORD TRANSFER ADJUSTMENT COST TO TRGL_DET */
      create trgl_det. trgl_det.trgl_domain = global_domain.
      assign
         trgl_type     = "CST-TR"
         trgl_sequence = recid(trgl_det)
         trgl_recno    = recid(trgl_det)
         trgl_trnbr    = 100000000 + integer(trgl_recno)
         trgl_dr_acct  = xfer_acct
         trgl_dr_sub   = xfer_sub
         trgl_dr_cc    = xfer_cc
         trgl_dr_proj  = project
         trgl_cr_acct  = intermediate_acct
         trgl_cr_sub   = intermediate_sub
         trgl_cr_cc    = intermediate_cc
         trgl_cr_proj  = project
         tmp_amt       = (from_cost * xfer_qty).

      /* ROUND TRANSFERRED ADJ COST PER BASE CURRENCY ROUND METHOD */
      {gprunp.i "mcpl" "p" "mc-curr-rnd"
                "(input-output tmp_amt,
                  input        gl_rnd_mthd,
                  output       mc-error-number)" }
      if mc-error-number <> 0
      then
         run display-message (input mc-error-number,
                              input 2).

      trgl_gl_amt  = trgl_gl_amt + tmp_amt.

      /* RECORD TRANSFER ADJUSTMENT COST TO GLT_DET */
      /* CHANGED  GL-AMOUNT FROM (FROM_COST * XFER_QTY) TO TMP_AMT */

      {mficgl02.i
         &gl-amount=tmp_amt
         &tran-type=""CST-TR""
         &order-no=nbr
         &dr-acct=trgl_dr_acct
         &dr-sub=trgl_dr_sub
         &dr-cc=trgl_dr_cc
         &drproj=trgl_dr_proj
         &cr-acct=trgl_cr_acct
         &cr-sub=trgl_cr_sub
         &cr-cc=trgl_cr_cc
         &crproj=trgl_cr_proj
         &entity=to_entity
         &find="false"
         &same-ref="icc_gl_sum"
         }

   end.

   /*TRANSFER VARIANCE --> RECEIPT*/
   find pld_det  where pld_det.pld_domain = global_domain and  pld_prodline  =
   pt_prod_line
                  and pld_site      = site_to
                  and pld_loc       = loc_to
                  no-lock no-error.

   if not available pld_det
   then
      find pld_det
         where pld_det.pld_domain = global_domain
           and pld_prodline       = pt_prod_line
           and pld_site           = site_to
           and pld_loc            = ""
      no-lock no-error.
   if not available pld_det
   then
      find pld_det
         where pld_det.pld_domain = global_domain
           and pld_prodline       = pt_prod_line
           and pld_site           = ""
           and pld_loc            = ""
   no-lock no-error.

   /*CALCULATE NEW AVERAGE COST*/
   if glx_mthd = "AVG"
   and reavg_yn
   then do:

      if available in_mstr
         and (in_site <> site_to or
              in_part <> global_part)
      then

         /* FIND THE in_mstr RECORD FOR THE SECOND SITE SO THAT COST */
         /* RECORDS ARE CORRECTY CREATED                             */
         for first in_mstr
            fields( in_domain in_abc          in_avg_date      in_avg_int
            in_cnt_date
                    in_cur_set      in_cyc_int      in_gl_cost_site in_gl_set
                    in_iss_chg      in_iss_date     in_level        in_mrp
                    in_part         in_qty_avail    in_qty_nonet    in_qty_oh
                    in_rctpo_active in_rctpo_status in_rctwo_active
                    in_rctwo_status in_rec_date     in_site         in_sls_chg)
             where in_mstr.in_domain = global_domain and  in_part = global_part
            and   in_site = site_to
            no-lock:
         end. /* FOR FIRST in_mstr */

      {gpsct01.i &set=glx_set &part=global_part &site=site_to}

      /* ADDED 3rd INPUT PARAMETER AS RECEIVING */
      /* SITES CONSIGNMENT INVENTORY USAGE      */

      {gprun.i ""csavg03.p"" "(input recid(sct_det),
                               input xfer_qty,
                               input 0,
                               input newmtl_tl,
                               input newlbr_tl,
                               input newbdn_tl,
                               input newovh_tl,
                               input newsub_tl,
                               input newmtl_ll,
                               input newlbr_ll,
                               input newbdn_ll,
                               input newovh_ll,
                               input newsub_ll)"
      }
/*GUI*/ if global-beam-me-up then undo, leave.

   end.

   /* CALL GPICLT.P TO CREATE THE LOT MASTER RECORD */
   if (clc_lotlevel <> 0)
   and (lotser_to <> "")
   then
      /* MOVED CALL TO gpiclt.p TO INTERNAL PROCEDURE p-get-nbrln */
      /* SO AS TO AVOID ACTION SEGMENT ERROR.                     */
      run p-get-nbrln.

   /* STORING INVENTORY ATTRIBUTES INTO LOCAL VARIABLES. SINCE       */
   /* ictrans.i DELETES ld_det WITH ZERO QOH AND TEMPORARY LOCATION  */

   /* WHEN LOCATION IS TEMPORARY AND -VE INVENTORY TRANSFER OCCURS  */
   /* ATTRIBUTES OF LOCATION WHERE INVENTORY IS REDUCING ARE STORED */
   /* IN LOCAL VARIABLES */

   if xfer_qty < 0
   then
      if can-find(first loc_mstr
                   where loc_mstr.loc_domain = global_domain and  loc_site =
                   site_to
                    and loc_loc  = loc_to
                    and loc_perm = no)
      then do:

         for first ld_det
            fields( ld_domain ld_site  ld_loc   ld_part ld_lot ld_ref ld_expire
                   ld_assay ld_grade ld_qty_oh )
             where ld_det.ld_domain = global_domain and  ld_site = site_to
              and ld_loc  = loc_to
              and ld_part = global_part
              and ld_lot  = lotser_to
              and ld_ref  = lotref_to
            no-lock:

            assign
               l_issAssay  = ld_assay
               l_issGrade  = ld_grade
               l_issExpire = ld_expire
               l_issQoh    = ld_qty_oh.

         end. /* FOR FIRST ld_det */

      end. /* IF CAN-FIND(loc_mstr...) */
   if xfer_without_ownership_change then
      issTrNbrString = issTrNbrString + " " + string(consigned_qty).
   else
      issTrNbrString = "".

   if glx_mthd = "AVG"
      and reavg_yn
   then
      to_cost = sct_cst_tot.

/*ss-20100510.1   {ictrans.i   */
/*ss-20100510.1*/   {xxictrans.i
      &addrid=global_addr
      &bdnstd=0
      &cracct=xfer_acct
      &crsub=xfer_sub
      &crcc=xfer_cc
      &crproj=project
      &curr=""""
      &dracct="
        if available pld_det then pld_inv_acct
        else pl_inv_acct"
      &drsub="
        if available pld_det then pld_inv_sub
        else pl_inv_sub"
      &drcc="
        if available pld_det then pld_inv_cc
        else pl_inv_cc"
      &drproj=project
      &effdate=eff_date
      &exrate=0
      &exrate2=0
      &exratetype=""""
      &exruseq=0
      &glamt="to_cost * xfer_qty"
      &kbtrans=kbtransnbr
      &lbrstd=0
      &line=0
      &location=loc_to
      &lotnumber=lot
      &lotref=lotref_to
      &lotserial=lotser_to
      &mtlstd=0
      &ordernbr=nbr
      &ovhstd=0
      &part=global_part
      &perfdate=?
      &price=to_cost
      &quantityreq=0
      &quantityshort=0
      &quantity="xfer_qty"
      &quantity2="xxld_qty2"
      &revision=issTrNbrString
      &rmks=rmks
      &shiptype=""""
      &site=site_to
      &shipnbr=i_shipnbr
      &shipdate=i_shipdate
      &invmov=i_invmov
      &slspsn1=""""
      &slspsn2=""""
      &sojob=so_job
      &substd=0
      &transtype=""RCT-TR""
      &msg=trmsg
      &ref_site=site_from
      &tempid=tempid_pass
      }

   rct_trnbr   = tr_trnbr.

   if p_srvendlot <> ""
   then
      tr_vend_lot  = p_srvendlot.

   /* UPDATE SUPPLIER CONSIGNMENT QUANTITIES */
   if using_supplier_consignment and
      consigned_qty <> 0 then do:

      procid = "update".
      {gprunmo.i
         &program = "pocnin.p"
         &module = "ACN"
         &param = """(input procid,
                      input site_to,
                      input global_part,
                      input consigned_qty,
                      output dummy_qty)"""}

      {gprunmo.i
         &program = "pocnld.p"
         &module = "ACN"
         &param = """(input procid,
                      input site_to,
                      input global_part,
                      input loc_to,
                      input lotser_to,
                      input lotref_to,
                      input consigned_qty,
                      output dummy_qty)"""}
   end. /* IF USING_SUPPLIER_CONSIGNMENT */

   /* UPDATING ATTRIBUTES AT LOCATION WHERE INVENTORY INCREASES   */
   /*     WITH ATTRIBUTES FROM LOCATION WHERE INVENTORY DECREASES */
   /* IF INVENTORY DOES NOT EXIST AT THE TARGET LOCATION          */

   /* VALIDATION ROUTINE FOR CHECKING THE ATTRIBUTES AT LOCATIONS */
   /* IS PRESENT IN ICTRXR.P . THE LOGIC WRITTEN BELOW ASSUMES ,  */
   /* THIS VALIDATION  ROUTINE HAS BEEN CALLED BEFORE CALLING     */
   /* ICXFER.P FOR INVENTORY TRANSFER                             */

   updateInvAttributes:
   do:

      l_rctTrRecid = recid(tr_hist).

      /* IF TRANSFER QTY IS POSITIVE THEN CHECK THE QTY ON HAND AT  */
      /* RECEIPT-LOCATION . IF IT HAD NON-ZERO QTY ON HAND  THEN    */
      /* DO NOT UPDATE ATTRIBUTES OF THIS LOCATION */

      if  (xfer_qty >= 0)
      and (available ld_det )
      and (ld_qty_oh <> xfer_qty)
      then
         leave updateInvAttributes .

      /* IF TRANSFER QTY IS NEGATIVE THEN CHECK THE QTY ON HAND AT  */
      /* ISSUE -LOCATION . IF IT HAD NON-ZERO QTY ON HAND  THEN    */
      /* DO NOT UPDATE ATTRIBUTES OF THIS LOCATION */

      if  (xfer_qty <  0)
      and (l_issQoh <> - xfer_qty)
      then
         leave updateInvAttributes .

      /* IF ATTRIBUTES ALREADY MATCHING THEN NEED NOT GO AHEAD */
      if  (available ld_det       )
      and (ld_expire = l_issExpire )
      and (ld_assay  = l_issAssay  )
      and (ld_grade  = l_issGrade  )
      then
         leave updateInvAttributes .

      if xfer_qty < 0
      then do:

         /* IN CASE OF NEGATIVE TRANSFER , UPDATE THE ATTRIBUTES OF */
         /* LOCATION WHERE ISSUE TRANSACTION OCCURS( WHERE INVENTORY*/
         /* INCREASES ) WITH ATTRIBUTES OF LOCATION WHERE RECEIPT   */
         /* TRANSACTION OCCURS(INVENTORY DECREASES ).               */

         if available ld_det
         then
            assign
               l_issGrade  = ld_grade
               l_issAssay  = ld_assay
               l_issExpire = ld_expire.

         /* GET INVENTORY RECORD WHERE ISS-TRANSACTION OCCURRED */
         for first ld_det
            where recid(ld_det) = l_issRecid
         exclusive-lock:
         end. /* FOR FIRST LD_DET */

         /* GET TRANSACTION RECORD WHERE ISS-TRANSACTION OCCURRED */
         for first tr_hist
            where recid(tr_hist) = l_issTrRecid
         exclusive-lock:
         end. /* FOR FIRST TR_HIST */

      end. /* IF XFER_QTY < 0 THEN DO: */

      /* UPDATING INVENTORY ATTRIBUTES */
      if available ld_det
      then
         assign
            ld_grade  = l_issGrade
            ld_assay  = l_issAssay
            ld_expire = l_issExpire.

      /* UPDATE CORRSEPONDING TRANSACTION HISTORY FOR ATTRIBUTES */
      if available tr_hist
      then
         assign
            tr_grade  = l_issGrade
            tr_assay  = l_issAssay
            tr_expire = l_issExpire.

      /* UPDATING THE OUTPUT PARAMETERS ASSAY,GRADE,EXPIRE */
      assign
         grade  = l_issGrade
         assay  = l_issAssay
         expire = l_issExpire.

      /* RESTORING THE TRANSACTION HISTORY RECORD */
      if recid(tr_hist) <> l_rctTrRecid
      then
         for first tr_hist
            where recid(tr_hist) = l_rctTrRecid
         exclusive-lock:
         end. /* FOR FIRST TR_HIST */

   end. /* UPDATEINVATTRIBUTES */

   /* LOAD MO-SPECIFIC FIELDS, IF NECESSARY */
   if available qad_wkfl
   then
      assign
         tr_prod_line = qad_charfld[1]
         tr_eng_code  = qad_charfld[2]
         tr_fcg_code  = qad_charfld[3]
         tr_fsm_type  = qad_charfld[4]
         tr_line      = integer(qad_decfld[1]).
      {&ICXFER-P-TAG3}

   /* to_cost NOW ASSIGNED UPDATED TOTAL COST AT TO SITE. PREVIOUSLY */
   /* IT LED TO INCORRECT trgl_type ASSIGNMENT THOUGH WE HAD A       */
   /* RE-AVERAGING OF COSTS AT THE to_site.                          */

   if available sct_det
   then
      to_cost = sct_cst_tot.

   if glx_mthd = "AVG"
   and to_cost <> from_cost
   then do:
      trgl_type = "RCT-AVG".
      if msgref <> 0
      then
         tr_msg = msgref.
   end.

   /********************************************************************/
   /* The FOR EACH below makes sense but was very slow in ORACLE.      */
   /* Replaced it with a DO WHILE trgl_recno <> ? so that we don't     */
   /* Run into the Oracle IS/IS NOT NULL issue with missing values,    */
   /* And we don't want to access the DB anyway if it is missing.      */
   /* If trgl_recno is not missing then the DO WHILE is always TRUE,   */
   /* So we loop until the find next fails, then we leave the block.   */
   /********************************************************************/

   trueblk:
   do while trgl_recno <> ?:
      find next trgl_det
          where trgl_det.trgl_domain = global_domain and  trgl_trnbr >=
          100000000 + integer(trgl_recno)
           and trgl_trnbr <= 100000000 + integer(trgl_recno)
      exclusive-lock no-error.

      if not available(trgl_det)
      then
         leave trueblk.

      trgl_trnbr = tr_trnbr.
      find glt_det  where glt_det.glt_domain = global_domain and  glt_ref =
      trgl_gl_ref
                     and glt_rflag = false
                     and glt_line = trgl_dr_line
      exclusive-lock
      no-error.
      if available glt_det
      then
         glt_doc = string(tr_trnbr).

      find glt_det  where glt_det.glt_domain = global_domain and  glt_ref   =
      trgl_gl_ref
                     and glt_rflag = false
                     and glt_line  = trgl_cr_line
      exclusive-lock
      no-error.
      if available glt_det
      then
         glt_doc = string(tr_trnbr).
   end.

   if transtype begins "ISS"
   then
      assign
         tr_assay  = assay
         tr_grade  = grade
         tr_expire = expire.

   /* USING TRMSG AS A RETURN VARIABLE FOR PO AND WO RECEIPT */
   if tr_type = "RCT-TR"
   then
      trmsg = tr_trnbr.

end.
glcost = to_cost.

PROCEDURE p-get-nbrln:

   /* INTRODUCED LOGIC SO AS TO PASS CORRECT PARAMETERS */
   /* FOR CREATION OF LOT MASTER WHEN PROCESSING IS     */
   /* DONE VIA RTS RECEIPTS WHEN INV ISSUE = NO.        */

   if execname = "fsrtvrc.p"
   then do:
      for first rmd_det
         fields (rmd_domain rmd_iss  rmd_part rmd_line rmd_nbr
                 rmd_prefix rmd_type rmd_site rmd_loc)
         where rmd_domain = global_domain
         and   rmd_nbr    = nbr
         and   rmd_part   = global_part
         and   rmd_prefix = "V"
         and   rmd_type   = "I"
         and   rmd_iss    = no
      no-lock:
      end. /* FOR FIRST rmd_det */

   end. /* IF execname ... */

   /* REPLACED THIRD AND FOURTH INPUT PARAMETERS WITH */
   /* rmd_nbr AND rmd_line RESPECTIVELY IN CASE OF    */
   /* RTS RECEIPTS ELSE RETAIN EXISTING """" VALUES   */
   {gprun.i ""gpiclt.p"" "(input global_part,
                           input lotser_to,
                           input (if execname = 'fsrtvrc.p'
                                  then
                                     rmd_nbr
                                  else
                                     """"),
                           input (if execname = 'fsrtvrc.p'
                                  then
                                     string(rmd_line)
                                  else
                                     """"),
                           output trans-ok )" }
/*GUI*/ if global-beam-me-up then undo, leave.

   if not trans-ok
   then do:
      {pxmsg.i &MSGNUM=2740 &ERRORLEVEL=4}
      /* CURRENT TRANSACTION REJECTED - CONTINUE*/
      /* WITH NEXT TRANSACTION. */
      undo, leave.
   end. /* IF NOT TRANS-OK THEN DO: */
end. /*PROCEDURE p-get-nbrln */

PROCEDURE display-message:
/*-----------------------------------------------------------------------
   Purpose:      To display error message

   Parameters:   1. input i-msgnum - message number
                 2. input i-level - error level

   Note:         Procedure created to remove Error "Action Segment has exceeded
                 its limit of 63488 bytes".
-------------------------------------------------------------------------*/

   define input parameter i-msgnum as integer no-undo.
   define input parameter i-level  as integer no-undo.


   {pxmsg.i &MSGNUM     = i-msgnum
            &ERRORLEVEL = i-level}

END. /* PROCDURE display-message */
