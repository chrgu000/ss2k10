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
/*Note:(Kevin,12/23/2003)***********************************************
Add a new function to verify the all components of non-phantom
for BOM copy between different site(Now,only "DCEC-C" to "DCEC-B").
The name of the new program is: zzbmpscpmv.p
***********************************************************************/
   def shared var bom-type like bom_fsm_type.                  /*kevin*/
{mfdeclre.i}
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
/*judy*/
DEF VAR xxpart1 LIKE pt_part.
DEF VAR xxpart2 LIKE pt_part.
/*judy*/

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
/*   site1        colon 30  sidesc1 no-label at 52                     kevin*/
   part1          colon 30
   desc1          no-label at 52
   um1            colon 30
/*   site2        colon 30  sidesc2 no-label at 52                     kevin*/   
   part2          colon 30
   desc3          no-label at 52
   um2            colon 30
   dest_desc      colon 30
   skip(1) sel-yn colon 30 label "选择性复制"       /*kevin*/
            msg_file colon 30 label "出错信息文件"
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

/**********tfq added begin*************************/
/*added by kevin,10/14/2003*/
form
 SKIP(.1)  /*GUI*/
 
   usrw_key6 label "select"  format "x(2)" 
   usrw_charfld[1] label "part" format "x(16)" 
   usrw_decfld[1]  label "qty_per"
   usrw_charfld[2] label "vend"  format "x(8)"
   usrw_charfld[3] label "cust" format "x(8)" 
   usrw_charfld[4] label "cmmt" format "x(8)" 
   usrw_charfld[5] label "ac" format "x(1)"
   skip(.1)
   with frame c center /*column 5*/ row 8 overlay
   width 80 title framename SCROLLable THREE-D stream-io /*GUI*/.
/****************tfq added end*******************/
mainloop :
repeat:
/*GUI*/ if global-beam-me-up then undo, leave.
find first xxbomc_ctrl no-lock where xxbomc_domain = global_domain no-error.                /*kevin,11/06/2003*/
            if not available xxbomc_ctrl then do:
                message "错误:BOM控制文件还未生成,请首先维护BOM控制文件!" view-as alert-box error.
                leave.
            end.
   clear frame a no-pause.
   clear frame b no-pause.                 /*kevin*/
   clear frame c no-pause.                       /*kevin*/
  
  
   do on error undo, retry with frame a:

      dest_desc = "".
     assign sel-yn = no.                        /*kevin*/
       assign msg_file = "c:\bmvdcperror.txt".      /*kevin,12/23/2003*/
       /*********tfq added begin*****************/
        set part1 VALIDATE(CAN-FIND(FIRST pt_mstr WHERE pt_domain = global_domain and pt_part = INPUT part1), "零件号不存在")  /*judy*/
            part2 VALIDATE (CAN-FIND(FIRST pt_mstr WHERE pt_domain = global_domain and pt_part = INPUT part2), "零件号不存在")
              with frame a editing:
       /******tfq added end********************/
    
    /*    /*added by kevin,10/23/2003*/                                                  */
    /*           if frame-field = "site1" then do:                                       */
    /*              {mfnp.i si_mstr site1 " si_domain = global_domain and si_site "      */
    /*              				site1 si_site si_site}                                       */
    /*              if recno <> ? then do:                                               */
    /*                  disp si_site @ site1 si_desc @ sidesc1 with frame a.             */
    /*              end.                                                                 */
    /*              recno = ?.                                                           */
    /*           end. /*frame-field = "site1"*/                                          */
    /*      /*tfq*/ else if frame-field = "part1"                                        */
        if frame-field = "part1"   
         then do:
            /* FIND NEXT/PREVIOUS RECORD - ALL BOM_MSTR'S ARE
            VALID FOR "SOURCE" */
            /*{mfnp.i bom_mstr part1 " bom_domain = global_domain and bom_parent " part1
               bom_parent bom_parent}judy*/
              {mfnp.i pt_mstr part1 " pt_domain = global_domain and pt_part "
              			  part1 pt_part pt_part}


            if recno <> ?
            then do:

               assign
/*judy*/        	 site1 = pt_site
                   part1 = pt_part
                   desc1 = pt_desc2
                   um1 = pt_um.
                  /*part1 = bom_parent
                  desc1 = bom_desc
                  um1   = bom_batch_um. 

               if bom-type <> fsm_c
               then do:
                  find pt_mstr where pt_domain = global_domain and pt_part = bom_parent
                  no-lock no-error.

                  if available pt_mstr then
                  do:
                     part1 = pt_part.

                     if bom_desc = ""  then
                        desc1 = pt_desc1.
                  end.
               end.   /* if bom-type <> fsm_c */*/
/*judy*/

               display
                  part1
                  desc1
                  um1
               with frame a.

            end.    /* if recno <> ? */
            recno = ?.

         end.   /* if frame-field = "part1" */
/**********tfq added begin********************* 
 *    else if frame-field = "site2" then do:
 *              {mfnp.i si_mstr site2 " si_domain = global_domain and si_site "
 *              			  site2 si_site si_site}
 *              if recno <> ? then do:
 *                  disp si_site @ site2 si_desc @ sidesc2 with frame a.
 *              end.    
 *              recno = ?.
 *           end. /*if frame-field = "site2"*/
 *           
 *   *************tfq added end*********************/
         else if frame-field = "part2"
         then do:

            /* FIND NEXT/PREVIOUS RECORD - BOMS TO DISPLAY DEPEND
               IN THE INPUT BOM-TYPE PARAMETER */
           {mfnp05.i bom_mstr bom_fsm_type " bom_mstr.bom_domain =
                       global_domain and bom_fsm_type  = bom-type "
                          bom_parent "input part2"}
            if recno <> ?
            then do:

               assign
                  part2 = bom_parent
                  desc3 = bom_desc
                  um2   = bom_batch_um.

               if bom_desc <> "" then
                  dest_desc = bom_desc.
               else
                  dest_desc = "".

               if bom-type <> fsm_c
               then do:
                  find pt_mstr no-lock where pt_domain = global_domain and pt_part = bom_parent
                  no-error.
                  if available pt_mstr
                  then do:
                  	 site2 = pt_site.
                     part2 = pt_part.
                     if bom_desc = "" then
                        desc3 = pt_desc2.                          /*added by kevin*/
                    /*tfq    desc3     = pt_desc1. */
                     if dest_desc  = "" then
                        dest_desc = pt_desc1.
                  end.    /* if available pt_mstr */
               end.    /* if bom-type <> fsm_c */

               display
                  part2
                  desc3
                  um2
                  dest_desc
                  sel-yn                   /*kevin*/
                  msg_file                /*kevin,12/23/2003*/
               with frame a.

            end.    /* if recno <> ? */

            else
               um2 = um1.

         end.    /* if frame-field = "part2" */
         else do:
            status input.
            readkey.
            apply lastkey.
         end.
      end.  /* editing */
/**************************************tfq added begin************************

            /*added by kevin,10/23/2003 for verify site1*/
                 find si_mstr no-lock where si_domain = global_domain and si_site = site1 no-error.
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
            
        /*    if available si_mstr then disp si_site @ site1 si_desc @ sidesc1 with frame a. */
                    
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
/*J034*/             undo,retry.
/*J034*/          end.

                /*added by kevin,10/23/2003 for verify site2*/
                 find si_mstr no-lock where si_domain = global_domain and si_site = site2 no-error.
                 if not available si_mstr or (si_db <> global_db) then do:
                     if not available si_mstr then msg-nbr = 708.
                     else msg-nbr = 5421.
                   /*tfq  {mfmsg.i msg-nbr 3}*/
                   /*tfq*/ {pxmsg.i
               &MSGNUM=msg-nbr
               &ERRORLEVEL=3
                           }

                     undo, retry.
                 end.
            
   /*        if available si_mstr then disp si_site @ site2 si_desc @ sidesc2 with frame a. */
                    
                {gprun.i ""gpsiver.p""
                "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/          /*tfq   {mfmsg.i 725 3} */   /* USER DOES NOT HAVE */
/*J034*/        /*tfq*/ {pxmsg.i
               &MSGNUM=725
               &ERRORLEVEL=3
                           }
                        /* ACCESS TO THIS SITE*/
                     next-prompt site2.
/*J034*/             undo,retry.
/*J034*/          end.
********************tfq added end*******************************************/
      if part2 = ""
      then do:
         {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}     /* BLANK NOT ALLOWED */
         next-prompt part2 with frame a.
         undo,retry .
      end.

    /*judy*/
               FIND FIRST ptp_det WHERE ptp_domain = global_domain and ptp_part = part2 AND ptp_site = site2 NO-LOCK NO-ERROR.
               IF AVAIL ptp_det AND ptp_bom_code <> "" THEN xxpart2 = ptp_bom_code.
               ELSE xxpart2 = part2.
    /*judy*/
        
        find first ps_mstr where ps_domain = global_domain and ps_par = /*part2*/ xxpart2 and ps__chr01 = site2 no-lock no-error .
        if  not available ps_mstr then
        do:
        message "地点: " + site2 + " 与产品结构: " + input part2 + " 不匹配" 
                             view-as alert-box error.
        next-prompt part2 with frame a.
         undo, retry.
        end.
      if bom-type = fsm_c and
         can-find(pt_mstr where pt_domain = global_domain and pt_part = part2)
      then do:
         /* SSM STRUCTURE CODE CANNOT EXIST IN ITEM MASTER */
         {pxmsg.i &MSGNUM=7494 &ERRORLEVEL=3}
         next-prompt part2 with frame a.
         undo, retry.
      end.

      assign
         desc1          = ""
         desc3          = ""
         from_batch_qty = 0
         from_batch_um  = ""
         to_batch_qty   = 1
         to_batch_um    = ""
         config_yn      = no
         formula_yn     = no
         um1            = ""
         um2            = "".


 /*judy*/ 
      FIND FIRST ptp_det WHERE ptp_domain = global_domain and ptp_site = site1 AND ptp_part = part1 NO-LOCK NO-ERROR.
      IF AVAIL ptp_det AND  ptp_bom_code <> "" THEN  xxpart1 = ptp_bom_code.
      ELSE xxpart1 = part1.
                      
/*judy*/

      find bom_mstr no-lock where bom_domain = global_domain and bom_parent = /*part1 judy*/  xxpart1 no-error.
      if available bom_mstr then
      assign
         /* judy part1*/ xxpart1    = bom_parent
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
      find first ps_mstr no-lock where ps_domain = global_domain and ps_par = /*part1judy*/  xxpart1
         and  ps_ps_code = "J" no-error.
      if available ps_mstr
      then do:
         /* JOINT PRODUCT STRUCTURE MAY NOT BE COPIED */
         {pxmsg.i &MSGNUM=6515 &ERRORLEVEL=3}
         undo, retry.
      end.

      if not can-find (first ps_mstr where ps_domain = global_domain and ps_par = /*part1 judy*/ xxpart1)
      then do:
         /* NO BILL OF MATERIAL EXISTS */
         {pxmsg.i &MSGNUM=100 &ERRORLEVEL=3 &MSGARG1="""("" + part1 + "")"""}
         undo, retry.
      end.
/*********************tfq added begin****************************************/
/*added by kevin, 11/12/2003*/
               if can-find (first ps_mstr where ps_domain = global_domain and ps_par = /*part1 judy*/ xxpart1 and ps__chr01 <> site1) then do:
                     message "地点: " + site1 + " 与产品结构: " + input part1 + " 不匹配" 
                             view-as alert-box error.
                    /* next-prompt site1 with frame a. */
                     undo,retry.
               end.

                       
               if can-find (first ps_mstr where ps_domain = global_domain and ps_par = /*part2 judy*/ xxpart2 and ps__chr01 <> site2) then do:
                     message "地点: " + site2 + " 与产品结构: " + input part2 + " 不匹配" 
                             view-as alert-box error.
                   /*  next-prompt site2 with frame a. */
                     undo,retry.
               end.     
/*end added by kevin, 11/12/2003*/
/*****************tfq added end**********************************************/
      /* FOR MANUFACTURING BOM'S, DEFAULT THESE VALUES FROM PT_MSTR
      (IF AVAILABLE).  FOR SERVICE BOM'S, USE ONLY BOM_MSTR. */
      if bom-type <> fsm_c
      then do:
         find pt_mstr where pt_domain = global_domain and pt_part = part1 no-lock no-error.
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
            /************tfq added begin********************/
            if pt_pm_code = "f" and site1 <> site2 then do:
                     message "'F'类型的零件不允许跨地点复制" view-as alert-box error.
                     undo,retry.
                  end.
            /*************tfq added end*********************/   
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

      find bom_mstr no-lock where bom_domain = global_domain and bom_parent = /*part2 judy*/ xxpart2 no-error.
      if available bom_mstr
      then do:

         /* PREVENT USER FROM COPYING INTO THE WRONG BOM TYPE */
         if bom_fsm_type <> bom-type
         then do:
            if bom_fsm_type = fsm_c then    /* FROM FSPSCP.P */
               msgnbr = 7492. /* CONTROLLED BY SERVICE/SUPPORT MODULE */
            else
               msgnbr = 7493.             /* ELSE, BMPSCP.P */
            /* THIS IS NOT AN SSM PRODUCT STRUCTURE CODE */
            {pxmsg.i &MSGNUM=msgnbr &ERRORLEVEL=3}
            next-prompt part2 with frame a.
            undo, retry .
         end.

         assign
            /*part2 judy*/ xxpart2    = bom_parent
            desc3        = bom_desc
            um2          = bom_batch_um
            formula_yn   = bom_formula
            to_batch_qty = bom_batch
            to_batch_um  = bom_batch_um.

         /* FOR SERVICE BOM'S, THERE'S NO REASON TO LEAVE DEST_DESC
         (AND HENCE BOM_DESC FOR THE NEW BOM CODE) BLANK.  FOR
         MANUFACTURING BOM'S, IF BOM_DESC IS BLANK, DEFAULT
         DESCRIPTION IS PULLED FROM THE ASSOCIATED ITEM. */
         if bom_desc <> "" then
            dest_desc = bom_desc.
         else
         if bom-type <> fsm_c then
            dest_desc = "".

      end.    /* if available bom_mstr */

      if formula_yn
      then do:
         {pxmsg.i &MSGNUM=263 &ERRORLEVEL=3} /* FORMULA CONTROLLED */
         next-prompt part2 with frame a.
         undo, retry.
      end.

      if bom-type <> fsm_c
      then do:
         find pt_mstr where pt_domain = global_domain and pt_part = part2 no-lock no-error.
         if available pt_mstr then do:

            if desc3 = "" then
               desc3 = pt_desc2.                             /*added by kevin*/
               /* desc3 = pt_desc1.     marked by tfq*/
            if to_batch_um = "" then
               to_batch_um = pt_um.
            if dest_desc  = "" then
               dest_desc = pt_desc1.

            /* ACCESS UM FROM pt_mstr IF bom_mstr IS NOT AVAILABLE */
            if not available bom_mstr
            then
               um2 = pt_um.

         end.     /* if available pt_mstr */
      end.     /* if bom-type <> fsm_c */

      if not available bom_mstr and
         not available pt_mstr
      then
         assign
            to_batch_qty = from_batch_qty
            to_batch_um  = from_batch_um
            um2          = to_batch_um.

      if to_batch_qty = 0 then
         to_batch_qty = 1.

      display
         part2
         desc3
         um2
         dest_desc
          sel-yn                  /*kevin*/
          msg_file                  /*kevin,12/23/2003*/
      with frame a.

      hide frame b.

      find first ps_mstr no-lock
         where ps_domain = global_domain and ps_par = /*part2 judy*/ xxpart2
         and  ps_ps_code = "J" no-error.
      if available ps_mstr
      then do:
         /* JOINT PRODUCT STRUCTURE MAY NOT BE COPIED */
         {pxmsg.i &MSGNUM=6515 &ERRORLEVEL=3}
         next-prompt part2 with frame a.
         undo, retry.
      end.

      copy_conv = 1.
      if from_batch_um <> to_batch_um
      then do:
         {gprun.i ""gpumcnv.p""
            "(to_batch_um, from_batch_um, part1, output copy_conv)"}
         if copy_conv = ?
         then do:
            /* NO UNIT OF MEASURE CONVERSION EXISTS */
            {pxmsg.i &MSGNUM=33 &ERRORLEVEL=4}
            undo, retry.
         end.
      end.    /* if from_bacth_um <> to_batch_um */
/**********tfq deleted begin**************
/*marked by kevin, 11/12/2003
      yn = yes.
      if can-find (first ps_mstr where ps_domain = global_domain and ps_par = part2)
      then do:
         /* PART NUMBER HAS EXISTING BILL OF MATERIAL */
         {pxmsg.i &MSGNUM=200 &ERRORLEVEL=2 &MSGARG1="""("" + part2 + "")"""}
         input clear.
         yn = no.
      end.
  end marked by kevin, 11/12/2003*/    
*********************tfq deleted end************/
/***********tfq added begin**********************************/

/*added by kevin, 11/12/2003
               if can-find (first ps_mstr where ps_domain = global_domain and ps_par = part2) then do:
                /*tfq  {mfmsg02.i 200 3 """("" + part2 + "")""" }    */
                /*tfq*/ {pxmsg.i
               &MSGNUM=200
               &ERRORLEVEL=3
               &MSGARG1="""("" + part2 + "")"""
                           }
                       
                  next-prompt part2 with frame a.
                  undo,retry.
               end.                
end added by kevin, 11/12/2003*/               

/*added by kevin, 11/07/2003 for the copy between the different sites*/ 
/*******************************tfq deleted************         
             if site1 <> site2 then do:
                 if xxbomc_part_site <> site1 or xxbomc_code_site <> site2 then do:
                     message "错误:根据BOM控制文件,此两地点间的复制将不被允许!" view-as alert-box error.
                     undo,retry.
                 end.
                
             end.
  ************tfq deleted end***********************/ 
/*edn added by kevin, 11/07/2003*/
/*************tfq added end**********************************/
      set
         dest_desc
         sel-yn                                       /*kevin*/ 
          msg_file                  /*kevin,12/23/2003*/ 
      with frame a.
/*************tfq added begin******************************/
/*added by kevin,12/23/2003*/
               if msg_file = "" then do:
                    message "出错提示文件不允许为空" view-as alert-box error.
                    undo,retry.
               end.
               /*end added by kevin,12/23/2003*/
/************tfq added end********************************/
      /* AS ABOVE, MANUFACTURING AND SERVICE BOMS HAVE DIFFERENT
      HANDLING FOR BOM_DESC */
      if bom-type <> fsm_c
      then do:

         /* IF THE DEST_DESC DEFAULTS TO ITEM DESC, AND THE USER DOES NOT
         MODIFY IT, THEN DEST_DESC SHOULD NOT BE POPULATED    */
         if ((available bom_mstr
            and bom_desc = "")
            or (not available bom_mstr))
            and dest_desc not entered
         then
            desc3 = "".
         else
            desc3 = dest_desc.
      end.     /* if bom-type <> fsm_c */
      else
         desc3 = dest_desc.

   end.    
   /*GUI*/ if global-beam-me-up then undo, leave.
   /* do on error with frame a */
/********************tfq added begin******************************/
/*added by kevin, 10/22/2003 - for copy ps by selection*/
    
          eff_date = today .
         sw_block:
         do transaction: /*on endkey undo, leave:*/
         transtype = "BM" . 
        
        /*{gprun.i ""yybmpkiqa.p"" "(input part2, judy*/
          {gprun.i ""yybmpkiqa.p"" "(input xxpart2,
                                input site2,
                               INPUT eff_date)"}
             /* FOR EACH pkdet:
                  DISP pkdet.
              END.*/
            if errmsg <> 0 then do:
            {mfmsg.i errmsg 3}
            pause .
            undo mainloop , retry mainloop .
            end.
            for each usrw_wkfl where usrw_domain = global_domain and usrw_key1 = "bmvdcp" and usrw_key3 = mfguser :
            delete usrw_wkfl .
            end.
            define variable i as integer .
            i = 0 .
            for each pkdet :
            i = i + 1 .
            
/*judy*/    FIND FIRST usrw_wkfl WHERE usrw_domain = global_domain and usrw_key1 = "bmvdcp"AND usrw_key3 = mfguser
                    AND usrw_charfld[1] = pkpart NO-ERROR.
            IF NOT AVAIL usrw_wkfl THEN DO:
                create usrw_wkfl .
                                 
                assign 
                        usrw_key1 = "bmvdcp"
                        usrw_key2 = "Z-" + string(i,"999") + mfguser 
                        usrw_key3 = mfguser 
                        usrw_charfld[1] = pkpart
                        usrw_decfld[1] = pkqty .

            END.
            ELSE  usrw_decfld[1] = usrw_decfld[1] + pkqty .
            
            /*create usrw_wkfl .
                 
            assign 
                    usrw_key1 = "bmvdcp"
                    usrw_key2 = "Z-" + string(i,"999") + mfguser 
                    usrw_key3 = mfguser 
                    usrw_charfld[1] = pkpart
                    usrw_decfld[1] = pkqty .*/
/*judy*/
                    
            find xxptmp_mstr where xxptmp_domain = global_domain and xxptmp_par = part1 and xxptmp_comp = usrw_charfld[1] no-lock no-error .
            if available xxptmp_mstr then
                    do:
                    usrw_charfld[2] = xxptmp_vend .
                    usrw_charfld[3] = xxptmp_cust .
                    usrw_charfld[4] = xxptmp_rmk .
                    usrw_key2 = "A-" + string(i,"999") + mfguser .
                    usrw_key6 = "*"  .
                    FIND FIRST AD_MSTR  WHERE ad_domain = global_domain and ad_addr = xxptmp_vend and ad_coc_reg = "" no-lock no-error .
                    if available ad_mstr then usrw_charfld[5]  = "y" .
                                         else usrw_charfld[5] = "N" .
                    end.       
            end.  /*for each pkdet*/
            
        if sel-yn then do:  
        /***********tfq deleted begin********
        for each  usrw_wkfl where usrw_domain = global_domain and usrw_key1 = "bmvdcp" and usrw_key3 = mfguser no-lock:
                 display usrw_key6 no-label format "x(2)" 
                    usrw_charfld[1] no-label  FORMAT "X(16)" 
                    usrw_charfld[2] no-label FORMAT "X(8)"
                    usrw_charfld[3] no-label FORMAT "X(8)" 
                    usrw_charfld[4]  no-label  FORMAT "X(8)"
                    usrw_charfld[5] no-label  FORMAT "X(1)"  .
                    end.
   ***********tfq deleted end***************/
         yn = no.
              message "请按 'enter' or 'space', 键去选择子零件.".         
              framename = "子零件选择".  
                  
         /* INCLUDE SCROLLING WINDOW TO ALLOW THE USER TO SCROLL      */
               /* THROUGH (AND SELECT FROM) EXISTING PAYMENTS APPLICATIONS  */
               define variable xxserchkey as character .
               xxserchkey = "bmvdcp" .
               {swselect.i
                  &detfile      = usrw_wkfl
                  &detkey = "where"
                  &searchkey = " usrw_domain = global_domain and usrw_key1 = xxserchkey and usrw_key3 = mfguser  "
                  &scroll-field = usrw_wkfl.usrw_key6
                  &framename    = "c"
                  &framesize    = 10
                  &sel_on       = ""*""
                  &sel_off      = """"
                  &display1   =   usrw_wkfl.usrw_key6
                  &display2     = usrw_wkfl.usrw_charfld[2]
                  &display3     = usrw_wkfl.usrw_charfld[1]
                  &display4     = usrw_wkfl.usrw_charfld[3]
                  &display5     = usrw_wkfl.usrw_charfld[4]
                  &display6     = usrw_wkfl.usrw_charfld[5]
                  &display7     = """"
                  &display8     = """"
                  &display9     = """"
                  &exitlabel    = sw_block
                  &exit-flag    = first_sw_call 
                  &record-id    = usrw_wkfl_recno
                   }
           if keyfunction(lastkey) = "end-error"
            or lastkey = keycode("F4")
            or keyfunction(lastkey) = "."
            or lastkey = keycode("CTRL-E") then do:
               undo sw_block, leave.
            end.        
            else do:
             yn = no.
               {pxmsg.i
               &MSGNUM=12
               &ERRORLEVEL=1
               &CONFIRM=yn
            } /* IS ALL INFORMATION CORRECT */
             if yn = no then do:
                undo sw_block, leave.
             end.
          end.
        end. /*sw_block*/
        /**********      
       hide message no-pause.
       
       if yn = no then undo,retry. 
       *************/  
    end. /*if sel-yn*/

/*end added by kevin*/

/************tfq added end*************************************/
                                    /*kevin*/  
 /**************tfq added begin**********************************/
 /*added by kevin, 10/23/2003*/

           
          {mfselprt.i "printer" 132}
           /*IS ALL INFORMATION CORRECT */
           put "part" format "x(17)"  "qty_per" format "x(13)" "vendor" format "x(9)" "customer" format "x(9)" "comment" format "x(8)" skip
                "目标子零件" format "x(17)"   "单位用量" format "x(13)" "源供应商" format "x(9)"  "客户" format "x(9)"  "备注" format "x(8)" skip 
               "---------------- ------------ -------- -------- --------------------" skip .
           for each  usrw_wkfl where usrw_domain = global_domain and usrw_key1 = "bmvdcp" and usrw_key6  = "*" and usrw_key3 = mfguser no-lock:
            display usrw_charfld[1] no-label  FORMAT "X(16)" 
                    STRING(usrw_decfld[1],"->>>>>9.99<<<")  FORMAT "X(12)"
                    usrw_charfld[2] no-label FORMAT "X(8)"
                    usrw_charfld[3] no-label FORMAT "X(8)" 
                    usrw_charfld[4]  no-label  FORMAT "X(8)".
                    end.
              {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/ 
   /*   if not sel-yn then do:    */                   /*kevin*/
   {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=yn}
   if yn = no
      then undo MAINLOOP, retry MAINLOOP.
     /*  end.       */
         for each  usrw_wkfl where usrw_domain = global_domain and usrw_key1 = "bmvdcp" and usrw_key6  = "*" and usrw_key3 = mfguser: 
         find first xxptmp_mstr where xxptmp_domain = global_domain and xxptmp_par = part2 and xxptmp_site = site2 
         and xxptmp_comp = usrw_charfld[1] no-error .
         if not available xxptmp_mstr then 
         create xxptmp_mstr .
         assign xxptmp_par = part2 
                xxptmp_comp = usrw_charfld[1]
                xxptmp_vend = usrw_charfld[2]
                xxptmp_cust = usrw_charfld[3]
                xxptmp_rmks = usrw_charfld[4]
                xxptmp_qty_per = usrw_decfld[1] 
                xxptmp_site = site2 . 
             delete usrw_wkfl .   
          end.
 
        
/*end added by kevin, 10/23/2003*/

 
 /**********tfq added end**************************************/   
      
 
end.   /* repeat */
/*GUI*/ if global-beam-me-up then undo, leave.
