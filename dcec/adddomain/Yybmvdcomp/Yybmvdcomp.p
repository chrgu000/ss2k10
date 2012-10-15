/* bmpscpm.p - MANUFACTURING/SERVICE BILL OF MATERIAL COPY SUBPROGRAM         */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.20 $                                                            */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 8.5         CREATED: 05/07/97      BY: *J1RB* Sue Poland         */
/* REVISION: 8.5         CREATED: 08/07/97      BY: *J1QF* Russ Witt          */
/* REVISION: 8.5      LAST MODIFIED: 01/29/98   BY: *J2CW* Santhosh Nair      */
/* REVISION: 9.0      LAST MODIFIED: 11/20/98   BY: *J352* Sandesh Mahagaokar */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* Revision: 1.19     BY: Nikita Joshi          DATE: 03/06/02  ECO: *N1BZ*   */
/* $Revision: 1.20 $       BY: Nikita Joshi          DATE: 04/11/02  ECO: *N1GD*   */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
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
/* REVISION: 8.5         MODIFIED: 10/21/03      BY: Kevin             */
/* REVISION: 8.5         MODIFIED: 12/23/03      BY: Kevin             */
/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 09/06/12  ECO: *SS-20120906.1*   */

/*Note:(Kevin,12/23/2003)***********************************************
Add a new function to verify the all components of non-phantom
for BOM copy between different site(Now,only "DCEC-C" to "DCEC-B").
The name of the new program is: zzbmpscpmv.p
***********************************************************************/

   def new shared var bom-type like bom_fsm_type.                  /*kevin*/
{mfdtitle.i "120906.1"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */


   /*tfq define input parameter bom-type like bom_fsm_type.*/
/************tfq added begin******************************/
         def new shared var site1 like si_site.             /*kevin*/
         def new shared var site2 like si_site.             /*kevin*/
        def new shared var sel-yn as logic initial "No".                    /*kevin*/
         define new shared variable part1          like ps_par label "源结构".
         define new shared variable part2          like ps_par label "目标结构".
         define new shared variable dest_desc      like pt_desc1
                                        label "目的地描述".
         define new shared variable desc1          like pt_desc1 no-undo.
         define new shared variable desc3          like pt_desc1 no-undo.
         define new shared variable um1            like pt_um label "UM".
         define new shared variable um2            like pt_um label "UM".

/*************tfq added end*******************************/
define new shared variable comp like ps_comp.
define new shared variable ps_recno as recid.
 
   def var sidesc1 like si_desc.                       /*kevin*/
   def var sidesc2 like si_desc.                       /*kevin*/
   
define variable yn             like mfc_logical no-undo.
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

define variable msgnbr         as   integer    no-undo.

define variable l_ptstatus     like isd_status no-undo.


{fsconst.i}    /* SSM CONSTANTS */
/*tfq define  buffer usrw_wkfl for ps_mstr.*/


/*tfq 2005/07/28 define new shared buffer usrw_wkfl for ps_mstr. */
/***********tfq adde begin 2005/07/28***************************/
    define new shared variable errmsg as integer .

    DEFINE VARIABLE eff_date LIKE ps_start INITIAL TODAY .
    define NEW shared workfile pkdet no-undo
        field pkpart like ps_comp
        field pkop as integer
                          format ">>>>>9"
        field pkstart like pk_start
        field pkend like pk_end
        field pkqty like pk_qty
        field pkbombatch like bom_batch
        field pkltoff like ps_lt_off. 
       
  define new shared variable transtype as character format "x(4)".
/*************tfq added end 2005/07/28**************************/

define buffer bommstr for bom_mstr.

def var usrw_wkfl_recno as recid format "->>>>>>9".              /*kevin*/
      define variable first_sw_call as logical initial true.      /*kevin*/
      def var framename as char format "x(40)".           /*kevin*/  
      def var msg-nbr as inte.                           /*kevin*/
      def new shared var msg_file as char format "x(40)".    /*kevin,12/23/2003*/
      def new shared var pass_yn as logic.                   /*kevin,12/23/2003*/

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
form
RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
   site1        colon 30  sidesc1 no-label at 52                     /*kevin*/
   part1          colon 30
   desc1          no-label at 52
   um1            colon 30        
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

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
/*GUI*/ if global-beam-me-up then undo, leave.
mainloop :
repeat:

find first xxbomc_ctrl where  /* *SS-20120906.1*   */ xxbomc_ctrl.xxbomc_domain = global_domain no-lock no-error.                /*kevin,11/06/2003*/
            if not available xxbomc_ctrl then do:
                message "错误:BOM控制文件还未生成,请首先维护BOM控制文件!" view-as alert-box error.
                leave.
            end.
   clear frame a no-pause.
    
   do on error undo, retry with frame a:
        site1 = "" .
        part1 = "" .
      display site1 part1 with frame a .
             set site1 part1
             with frame a editing:
      
    
        /*added by kevin,10/23/2003*/
               if frame-field = "site1" then do:
                  {mfnp.i si_mstr site1 "si_mstr.si_domain = global_domain and  si_site" site1 si_site si_site}
                  if recno <> ? then do:
                      disp si_site @ site1 si_desc @ sidesc1 with frame a.
                  end.
                  recno = ?.
               end. /*frame-field = "site1"*/
          /*tfq*/ else if frame-field = "part1"        
                 
	     then do:
           
	/* FIND NEXT/PREVIOUS RECORD - ALL BOM_MSTR'S ARE
            VALID FOR "SOURCE" */

	{mfnp.i bom_mstr part1 "bom_mstr.bom_domain = global_domain and bom_parent" part1
               bom_parent bom_parent}


	if recno <> ?
            then do:

 
	  assign
                  
	    part1 = bom_parent
                  
	    desc1 = bom_desc
                  
	    um1   = bom_batch_um.

               
	  if bom-type <> fsm_c
               then do:

	  find pt_mstr where /* *SS-20120906.1*   */ pt_mstr.pt_domain = global_domain 
               and  pt_part = bom_parent
                  no-lock no-error.


	  if available pt_mstr then
                  do:
 
	     part1 = pt_part.
	      if bom_desc = ""  then
                        desc1 = pt_desc1.
 
	   end.
               
	end.   /* if bom-type <> fsm_c */

              
	display
                  
	   part1
                  
	   desc1
                  
	   um1
               with frame a.


	end.    /* if recno <> ? */
            

         
	end.   /* if frame-field = "part1" */         
         
	else do:

	status input.
	
            readkey.
	
            apply lastkey.

	end.
      
	end.  /* editing */

/**************************************tfq added begin************************/

            /*added by kevin,10/23/2003 for verify site1*/
                 find si_mstr no-lock where  /* *SS-20120906.1*   */ si_mstr.si_domain = global_domain and  si_site = site1 no-error.
                 if not available si_mstr or (si_db <> global_db) then do:
                     if not available si_mstr then msg-nbr = 708.
                     else msg-nbr = 5421.
                    /*tfq  {mfmsg.i msg-nbr 3}*/
                    /*tfq*/ {pxmsg.i
               &MSGNUM=msg-nbr
               &ERRORLEVEL=3
                           }
                     next-prompt site1.
                     undo, retry.
                 end.
            
            if available si_mstr then disp si_site @ site1 si_desc @ sidesc1 with frame a.
                    
                {gprun.i ""gpsiver.p""
                "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/           /*tfq  {mfmsg.i 725 3}*/     /* USER DOES NOT HAVE */
/*J034*/            /*tfq*/ {pxmsg.i
               &MSGNUM=725
               &ERRORLEVEL=3
                           }
                    /* ACCESS TO THIS SITE*/
                     next-prompt site1.
/*J034*/             undo,retry.
/*J034*/          end.

              
/********************tfq added end*******************************************/
 

      find bom_mstr no-lock where  /* *SS-20120906.1*   */ bom_mstr.bom_domain = global_domain and bom_parent = part1 no-error.
      
     if available bom_mstr then
      
        assign
 
         part1            = bom_parent
         
          um1              = bom_batch_um

	  desc1            = bom_desc

	  from_batch_qty   = bom_batch

	  from_batch_um    = bom_batch_um

	  formula_yn       = bom_formula.

      
	  /* SOURCE AND DESTINATION BOM CODES MAY BE NEITHER
      FORMULA-CONTROLLED NOR JOINT/CO/BY-PRODUCTS. */

	  if formula_yn
      then do:
 
	  {pxmsg.i &MSGNUM=263 &ERRORLEVEL=3} /* FORMULA CONTROLLED */

	  undo, retry.
      end.
 
	  find first ps_mstr no-lock where  /* *SS-20120906.1*   */ ps_mstr.ps_domain = global_domain and   ps_par = part1
         and  ps_ps_code = "J" no-error.
 
	  if available ps_mstr
      then do:
         
	  /* JOINT PRODUCT STRUCTURE MAY NOT BE COPIED */
	  
         {pxmsg.i &MSGNUM=6515 &ERRORLEVEL=3}
         
	     undo, retry.
      
	  end.

      
	  if not can-find (first ps_mstr where /* *SS-20120906.1*   */ ps_mstr.ps_domain = global_domain and ps_par = part1)
      then do:

	  /* NO BILL OF MATERIAL EXISTS */
         
	  {pxmsg.i &MSGNUM=100 &ERRORLEVEL=3 &MSGARG1="""("" + part1 + "")"""}
      
	  undo, retry.
      
	  end.
	  
/*********************tfq added begin****************************************/
/*added by kevin, 11/12/2003*/
               if can-find (first ps_mstr where /* *SS-20120906.1*   */ ps_mstr.ps_domain = global_domain and ps_par = part1 and ps__chr01 <> input site1) 
               then do:
                     message "地点: " + input site1 + " 与产品结构: " + input part1 + " 不匹配" 
                             view-as alert-box error.
                     next-prompt site1 with frame a.
                     undo,retry.
               end.     
               
/*****************tfq added end**********************************************/
      
/* FOR MANUFACTURING BOM'S, DEFAULT THESE VALUES FROM PT_MSTR
      (IF AVAILABLE).  FOR SERVICE BOM'S, USE ONLY BOM_MSTR. */
 
     if bom-type <> fsm_c
      then do:

         find pt_mstr where  /* *SS-20120906.1*   */ pt_mstr.pt_domain = global_domain and  pt_part = part1 no-lock no-error.

         if available pt_mstr
         then do:
 
           if desc1 = ""
            then
               desc1 = pt_desc1.

            if from_batch_um = ""
            then
               from_batch_um = pt_um.
 
           if pt_pm_code = "C"
            then
               config_yn = yes.
           
         end.     /* if available pt_mstr then do */
   
      end.     /* if bom-type <> fsm_c */
     
     else
         dest_desc = bom_desc.

 
     if from_batch_qty = 0
         then from_batch_qty = 1.
 
     display
         part1
         desc1
         um1
      with frame a.
 
 end.  /*do on error with frame a*/

/********************tfq added begin******************************/
/*added by kevin, 10/22/2003 - for copy ps by selection*/
    
           
         sw_block:
         do transaction: /*on endkey undo, leave:*/
         /*GUI*/ if global-beam-me-up then undo, leave.
         transtype = "BM" . 
        eff_date = today .
        {gprun.i ""yybmpkiqa.p"" "(input part1,
                               INPUT site1,
                               INPUT eff_date)"}
            if errmsg <> 0 then do:
            {mfmsg.i errmsg 3}
            pause .
            undo mainloop , retry mainloop .
            end.
            for each pkdet no-lock :
            find xxptmp_mstr where  /* *SS-20120906.1*   */ xxptmp_mstr.xxptmp_domain = global_domain and xxptmp_par = part1 and xxptmp_comp = pkpart
            and xxptmp_site = site1 no-error .
            if available xxptmp_mstr then
            do:
              FIND FIRST AD_MSTR  WHERE  /* *SS-20120906.1*   */ AD_MSTR.ad_domain = global_domain and  ad_addr = xxptmp_vend and ad_coc_reg <> "" no-lock no-error .
                 if available ad_mstr then assign xxptmp_rmk  = "*失效*" +  xxptmp_rmk 
                                                  xxptmp_qty_per = pkqty.
                                       else do:
                                       FIND FIRST AD_MSTR  WHERE /* *SS-20120906.1*   */ AD_MSTR.ad_domain = global_domain and ad_addr = xxptmp_vend and ad_coc_reg = "" no-lock no-error .
                                            if available ad_mstr then do:
                                            xxptmp_rmk = REPLACE(xxptmp_rmk,"*失效*","") .
                                            xxptmp_qty_per = pkqty.
                                            end.
                                       end.           
             end.       
            end.
            for each xxptmp_mstr  where /* *SS-20120906.1*   */ xxptmp_mstr.xxptmp_domain = global_domain and xxptmp_par = part1 and xxptmp_site = site1:
            find first pkdet where pkpart =  xxptmp_comp  no-lock no-error .
            if not available pkdet then
            do:
              delete xxptmp_mstr .
             end.       
            end.

  end.    /*do transaction*/   
/*end added by kevin*/

/************tfq added end*************************************/
                                    /*kevin*/  
 /**************tfq added begin**********************************/
 /*added by kevin, 10/23/2003*/

           
          {mfselprt.i "printer" 132}
           /*IS ALL INFORMATION CORRECT */
          for each pkdet no-lock : 
          find first xxptmp_mstr where /* *SS-20120906.1*   */ xxptmp_mstr.xxptmp_domain = global_domain and xxptmp_par = part1 and xxptmp_site = site1 and xxptmp_comp = pkpart  no-lock no-error .
          if available xxptmp_mstr 
          then display pkpart label "BOM 子零件" xxptmp_comp xxptmp_qty_per xxptmp_vend xxptmp_cust xxptmp_rmk with width 132 stream-io .
          else display pkpart label "BOM 子零件" ""@ xxptmp_comp pkqty @ xxptmp_qty_per  "" @ xxptmp_vend ""@ xxptmp_cust "供应商零件不存在"@ xxptmp_rmk with width 132 stream-io .
          end.
          put skip 
          "同步结束"  skip .
              {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/ 
  
        
/*end added by kevin, 10/23/2003*/

 
 /**********tfq added end**************************************/   
      
 
end.   /* repeat */
/*GUI*/ if global-beam-me-up then undo, leave.
