/* GUI CONVERTED from bmpscpm.p (converter v1.69) Tue Sep  9 10:20:11 1997 */
/* zzbmpscpm1.p - MANUFACTURING/SERVICE BILL OF MATERIAL COPY SUBPROGRAM         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 8.5         CREATED: 05/07/97      BY: *J1RB* Sue Poland         */
/* REVISION: 8.5         CREATED: 08/07/97      BY: *J1QF* Russ Witt          */
/*!
    This routine is called by BMPSCP.P to copy "normal" BOM structures.  It
    is also called by FSPSCP.P to copy service BOM structures.

    Variations in performance of these two processes should be kept to a
    minimum.  Currently, the main difference may be found in the handling
    of the Destination Description field - as manufacturing BOMs generally
    expect the existence of pt_mstr, and service BOMs never expect pt_mstr,
    default logic for this field varies.

    The input value for bom-type identifies the type of structure being
    copied to.  It will be blank when manufacturing BOMs are being copied,
    and will contain "FSM" when service BOMs are being copied.  In either
    case, the Source BOM used for the copy may be of either type.
*/
/* REVISION: 8.5         MODIFIED: 10/23/03      BY: Kevin             */
/*For copy the bom between the different sites*/
/*copy from zzbmpscpm1.p*/

         {mfdeclre.i}

         /*define input parameter bom-type like bom_fsm_type.*/         /*kevin*/
        def shared var bom-type like bom_fsm_type.              /*kevin*/

         def shared var site1 like si_site.             /*kevin*/
         def shared var site2 like si_site.             /*kevin*/
        def shared var sel-yn as logic initial "No".                    /*kevin*/
         define new shared variable comp like ps_comp.
         define new shared variable ps_recno as recid.

         define shared variable part1          like ps_par label "源结构".
         define shared variable part2          like ps_par label "目标结构".
         define shared variable dest_desc      like pt_desc1
                                        label "目的地描述".
         define shared variable desc1          like pt_desc1 no-undo.
         define shared variable desc3          like pt_desc1 no-undo.
         define shared variable um1            like pt_um label "UM".
         define shared variable um2            like pt_um label "UM".
         define variable yn             like mfc_logical.
         define variable unknown_char   as character initial ?.
         define variable found_any      like mfc_logical.
         define variable to_batch_qty   like pt_batch.
         define variable from_batch_qty like pt_batch.
         define variable to_batch_um    like pt_um.
         define variable from_batch_um  like pt_um.
         define variable conv           like ps_um_conv.
         define variable um             like pt_um.
         define variable copy_conv      like um_conv.
         define variable formula_yn     like bom_formula.
         define variable config_yn      like mfc_logical.
         define variable qtyper_b       like ps_qty_per_b.
         define variable msgnbr         as   integer no-undo.

         {fsconst.i}    /* SSM CONSTANTS */

         define shared buffer ps_from for ps_mstr.
         define buffer bommstr for bom_mstr.

         def var ps_from_recno as recid format "->>>>>>9".              /*kevin*/
        define variable first_sw_call as logical initial true.      /*kevin*/
        def var framename as char format "x(40)".           /*kevin*/  
	 define variable parent like ps_comp.                /*kevin*/
	 define variable level as integer.               /*kevin*/
	 define variable record as integer extent 100.     /*kevin*/
       def var topart like bom_parent extent 100.   /*kevin*/  
        def workfile xxwk                                   /*kevin*/
             field site1 like si_site
             field site2 like si_site
             field par1 like ps_par
             field par2 like ps_par
             field yn as logic init no.             /*a flag indicate whether the bom have existed*/
	 define variable compdesc like pt_desc1.
	 define variable compum like pt_um.
	 define variable phantom like mfc_logical format "Y" label "虚".
	 define variable iss_pol like pt_iss_pol format "/no".
	 define variable lvl as character format "x(7)" label "层次".
	          
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
part1          colon 30
            desc1          no-label at 52
            um1            colon 30
            part2          colon 30
            desc3          no-label at 52
            um2            colon 30
            dest_desc      colon 30
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/*added by kevin, 11/07/2003*/
	       
    find first code_mstr where code_fldname = "cust-control-file" and
                               code_value = "auto-bomcode-generate" no-lock no-error.
    if not available code_mstr or code_cmmt = "" then do:
        message "错误:物料清单代码的后缀控制文件不存在、或后缀为空,请重新输入!" view-as alert-box error.
        undo,retry.
    end.
/*end added by kevin, 11/07/2003*/    
    
/*added by kevin, 11/07/2003 to expand the ps_from*/
	    for each xxwk:
	         delete xxwk.
	    end.
	    
	    assign parent = part1
	           level = 1.
	    
	    find first ps_from use-index ps_parcomp where ps_from.ps_par = parent
	       no-lock no-error.
	    repeat with frame heading:

	       /*DETAIL FORM */
	       FORM /*GUI*/ 
		  lvl
		  ps_mstr.ps_comp
		  compdesc
		  ps_mstr.ps_qty_per
		  compum
		  phantom
		  ps_mstr.ps_ps_code
		  iss_pol
	       with STREAM-IO /*GUI*/  frame heading width 80
	       no-attr-space.

	       if not available ps_from then do:
		  repeat:
		     level = level - 1.
		     if level < 1 then leave.
		     find ps_from where recid(ps_from) = record[level]
		     no-lock no-error.
		     parent = ps_from.ps_par.
		     find next ps_from use-index ps_parcomp where ps_from.ps_par = parent
		     no-lock no-error.
		     if available ps_from then leave.
		  end.
	       end.
	       if level < 1 then leave.
              
              if level = 1 and (sel-yn and ps_from.ps__chr02 = "") then do:
		      find next ps_from use-index ps_parcomp where ps_from.ps_par = parent
		      no-lock no-error.
              end.
              else do:      
                   record[level] = recid(ps_from).

                   /*create ps_mstr for the destination site*/
                   if level = 1 then do:  
                     if not can-find (bom_mstr where bom_parent = part2
                        and bom_fsm_type = bom-type) then do:

                        create bom_mstr.
                        assign  bom_parent = part2
                                bom_userid = global_userid
                                bom_mod_date = today
                                bom_batch = to_batch_qty
                                bom_batch_um = to_batch_um
                                bom_desc = desc3
                                bom_fsm_type = bom-type
                                bom_formula = formula_yn.
                      
                       if recid(bom_mstr) = -1 then .
                       find bommstr where bommstr.bom_parent = part1
                       no-lock no-error.
                       if available bommstr then
                           assign bom_mstr.bom_user1   =  bommstr.bom_user1
                                  bom_mstr.bom_user2   =  bommstr.bom_user2
                                  /*bom_mstr.bom__chr01  =  bommstr.bom__chr01*/     /*marked by kevin*/
                                  bom_mstr.bom__chr01  = site2                       /*kevin*/
                                  /*bom_mstr.bom__chr02  =  bommstr.bom__chr02*/    /*marked by kevin*/
                             bom_mstr.bom__chr02 = part1               /*kevin*/     
                                  bom_mstr.bom__chr03  =  bommstr.bom__chr03
                                  bom_mstr.bom__chr04  =  bommstr.bom__chr04
                                  bom_mstr.bom__chr05  =  bommstr.bom__chr05
                                  bom_mstr.bom__dec01  =  bommstr.bom__dec01
                                  bom_mstr.bom__dec02  =  bommstr.bom__dec02
                                  bom_mstr.bom__dte01  =  bommstr.bom__dte01
                                  bom_mstr.bom__dte02  =  bommstr.bom__dte02
                                  bom_mstr.bom__log01  =  bommstr.bom__log01.

                    end.
                    else do:
                       find bom_mstr exclusive-lock where bom_mstr.bom_parent = part2.
                       assign bom_mstr.bom_desc = desc3.
                    end.
                   end. /*if level = 1*/
                   else do:
                       find ptp_det where ptp_site = site1 and ptp_part = parent no-lock no-error.
                       if available ptp_det and ptp_phantom = yes then do:
                       find pt_mstr where pt_part = ptp_part no-lock no-error.
                       find bom_mstr where bom_mstr.bom_parent = ps_from.ps_par + trim(code_cmmt)
                       and bom_mstr.bom_fsm_type = bom-type no-error.
                       if not available bom_mstr then do:
                          create bom_mstr.
                          assign bom_mstr.bom_parent = ps_from.ps_par + trim(code_cmmt)
                                 bom_mstr.bom_userid = global_userid
                                 bom_mstr.bom_mod_date = today
                                 bom_mstr.bom_fsm_type = bom-type
                                 bom_mstr.bom_desc = pt_desc2                               /*added by kevin*/
                                 bom_mstr.bom__chr01 = site2
                                 bom_mstr.bom__chr02 = ps_from.ps_par.
                          find pt_mstr where pt_part = ps_from.ps_par no-lock no-error.
                          if available pt_mstr then do:
                            assign bom_mstr.bom_batch_um = pt_um.
                          end.       
                       end.
                    end.           
                   end. /*else do,level > 1*/
              
                   find first xxwk where xxwk.par2 = bom_mstr.bom_parent no-lock no-error.
                   if not available xxwk then do:
                      create xxwk.
                      assign xxwk.site1 = site1
                             xxwk.site2 = site2
                             xxwk.par1 = ps_from.ps_par
                             xxwk.par2 = bom_mstr.bom_parent.
                      find first ps_mstr where ps_mstr.ps_par = bom_mstr.bom_parent no-error.                   
                      if available ps_mstr then do:
                            assign xxwk.yn = yes.
                      end.
                      else do:
                           assign xxwk.yn = no.
                      end.
                   end.
                  
                                     
                   if xxwk.yn = no then do:
                        create ps_mstr.
                        assign
                             ps_mstr.ps_par = xxwk.par2
                             /*ps_mstr.ps_comp = ps_from.ps_comp*/               /*marked by kevin*/
                             ps_mstr.ps_ref = ps_from.ps_ref
                             ps_mstr.ps_scrp_pct = ps_from.ps_scrp_pct
                             ps_mstr.ps_ps_code = ps_from.ps_ps_code
                             ps_mstr.ps_lt_off = ps_from.ps_lt_off
                             ps_mstr.ps_start = ps_from.ps_start
                             ps_mstr.ps_end = ps_from.ps_end
                             ps_mstr.ps_rmks = ps_from.ps_rmks
                             ps_mstr.ps_op = ps_from.ps_op
                             ps_mstr.ps_item_no = ps_from.ps_item_no
                             ps_mstr.ps_mandatory = ps_from.ps_mandatory
                             ps_mstr.ps_exclusive = ps_from.ps_exclusive
                             ps_mstr.ps_process = ps_from.ps_process
                             ps_mstr.ps_qty_type = ps_from.ps_qty_type
                             ps_mstr.ps_fcst_pct = ps_from.ps_fcst_pct
                             ps_mstr.ps_default = ps_from.ps_default
                             ps_mstr.ps_group = ps_from.ps_group
                             ps_mstr.ps_critical = ps_from.ps_critical
                             ps_mstr.ps_user1 = ps_from.ps_user1
                             ps_mstr.ps_user2 = ps_from.ps_user2.

                       find ptp_det where ptp_site = site1 and ptp_part = ps_from.ps_comp no-lock no-error.
                       if available ptp_det and ptp_phantom = yes then do:
                            assign ps_mstr.ps_comp = ps_from.ps_comp + trim(code_cmmt).
                       end.
                       else assign ps_mstr.ps_comp = ps_from.ps_comp.
                       
                        /* STORE MODIFY DATE AND USERID */
                        ps_mstr.ps_mod_date = today.
                        ps_mstr.ps_userid = global_userid.
                        ps_mstr.ps_qty_per_b = ps_from.ps_qty_per_b.
                        ps_mstr.ps_qty_per = ps_from.ps_qty_per.
                        
                        ps_mstr.ps__chr01 = site2.           /*kevin,11/06/2003 for site control*/
                     
                      /*display copied bom*/   
		       assign um = ""
		              compdesc = ""
		              iss_pol = no
		             phantom = no.

		       find pt_mstr where pt_part = ps_mstr.ps_comp no-lock no-error.
		       if available pt_mstr then do:
		           assign compum = pt_um
			         compdesc = pt_desc1
		                  iss_pol = pt_iss_pol
		                  phantom = pt_phantom.
		       end.
		       else do:
		           find bom_mstr no-lock where bom_mstr.bom_parent = ps_mstr.ps_comp no-error.
		          if available bom_mstr then
		               assign compum = bom_mstr.bom_batch_um
			       compdesc = bom_mstr.bom_desc.
		      end.                        
		      
		      lvl = ".......".
		      lvl = substring(lvl,1,min(level - 1,6)) + string(level).
		      if length(lvl) > 7
		         then lvl = substring(lvl,length(lvl) - 6,7).                      
                      

		     display lvl ps_mstr.ps_comp compdesc ps_mstr.ps_qty_per
		             compum phantom ps_mstr.ps_ps_code iss_pol
		             with frame heading STREAM-IO /*GUI*/ .
		                         
                        ps_recno = recid(ps_mstr).

                       /* CYCLIC PRODUCT STRUCTURE CHECK */
                       /* {gprun.i ""bmpsmta.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

                        if ps_recno = 0 then do:
                           {mfmsg02.i 206 2 ps_mstr.ps_comp}
                           /* "CYCLIC PRODUCT STRUCTURE - "
                            + part2 + " - " + ps_mstr.ps_comp + " NOT ADDED */
                            pause 5.
                           undo, next.
                        end.*/                                              /*marked by kevin*/
                           
                        for each in_mstr exclusive-lock where
                                 in_part = ps_mstr.ps_comp:
                            if available in_mstr then
                                  assign in_level = 99999
                                  in_mrp = true.
                       end.                        

                       pause 0 no-message.                 
                      {inmrp.i &part=xxwk.par2 &site=unknown_char}                      

                   end. /*if xxwk.yn = no*/
                                      
                   /*end create ps_mstr*/
                   
                   find ptp_det where ptp_site = site1 and ptp_part = ps_from.ps_comp no-lock no-error.
                   if xxwk.yn or not available ptp_det or (available ptp_det and ptp_phantom = no) then do:
                         find next ps_from use-index ps_parcomp where ps_from.ps_par = parent
		         no-lock no-error.
                   end.           
                   else do:   
		     parent = ps_from.ps_comp.
		     level = level + 1.
		     find first ps_from use-index ps_parcomp where ps_from.ps_par = parent
		     no-lock no-error.
		   end.
		      
		end. /*else do,not (level = 1 and (sel-yn and ps_from.ps__chr02 = ""))*/
		     
	    end. /*repeat for ps_from expand*/
/*end added by kevin, 11/07/2003*/
