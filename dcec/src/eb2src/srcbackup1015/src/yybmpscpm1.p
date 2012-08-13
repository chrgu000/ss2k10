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
/*For copy the bom in the same site*/
/*copy from zzbmpscpm.p*/
/* REVISION: 8.5         MODIFIED: 10/21/03      BY: Kevin             */
/* REVISION: 8.5         MODIFIED: 12/23/03      BY: Kevin             */
/*Note:(Kevin,12/23/2003)***********************************************
Add a new function to verify the all components of non-phantom
for BOM copy between different site(Now,only "DCEC-C" to "DCEC-B").
The name of the new program is: zzbmpscpmv.p
***********************************************************************/
   
{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
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
         define variable l_ptstatus     like isd_status no-undo.
         
/**********tfq deleted begin***********************************
def shared var bom-type like bom_fsm_type.                  /*kevin*/
/*tfq define input parameter bom-type like bom_fsm_type.*/

define new shared variable comp like ps_comp.
define new shared variable ps_recno as recid.
 def shared var site1 like si_site.             /*kevin*/
  def shared var site2 like si_site.             /*kevin*/
   def var sidesc1 like si_desc.                       /*kevin*/
   def var sidesc2 like si_desc.                       /*kevin*/
   def new shared var sel-yn as logic initial "No".                    /*kevin*/
define variable part1          like ps_par label "Source Structure" no-undo.
define variable part2          like ps_par label "Destination Structure" no-undo.
define variable dest_desc      like pt_desc1
                               label "Destination Description" no-undo.
define variable desc1          like pt_desc1 no-undo.
define variable desc3          like pt_desc1 no-undo.
define variable um1            like pt_um label "UM" no-undo.
define variable um2            like pt_um label "UM" no-undo.
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

******************************tfq deleted end******************/
{fsconst.i}    /* SSM CONSTANTS */

define shared buffer ps_from for ps_mstr.
define buffer bommstr for bom_mstr.
        def var ps_from_recno as recid format "->>>>>>9".              /*kevin*/
        define variable first_sw_call as logical initial true.      /*kevin*/
        def var framename as char format "x(40)".           /*kevin*/  

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
form
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

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
/**********tfq added begin*************************/
/*added by kevin,10/14/2003*/
form
 SKIP(.1)  /*GUI*/
   ps_from.ps__chr02 format "x(2)" label "选择"
   /*ps_from.ps_par*/
   ps_from.ps_comp
  ps_from.ps_ref
  ps_from.ps_start
  ps_from.ps_qty_per
  ps_from.ps_op
   skip(.1)
   with frame c center /*column 5*/ row 12 overlay
   width 80 title framename THREE-D stream-io /*GUI*/.
/****************tfq added end*******************/
/************tfq deleted begin****************
/*marked by kevin,10/23/2003
repeat:
/*GUI*/ if global-beam-me-up then undo, leave.
find first xxbomc_ctrl no-lock no-error.                /*kevin,11/06/2003*/
            if not available xxbomc_ctrl then do:
                message "错误:BOM控制文件还未生成,请首先维护BOM控制文件!" view-as alert-box error.
                leave.
            end.
   clear frame a no-pause.
   clear frame b no-pause.                 /*kevin*/
   clear frame c no-pause.                       /*kevin*/
   /**********tfq ***added begin ***************/   
   /*added by kevin, 11/07/2003 for clear the ps__chr02*/
          for each ps_from where ps_from.ps__chr02 = "*":
             assign ps_from.ps__chr02 = "".
          end.
/*end added by kevin,11/07/2003*/
   /*******tfq added end**************************/ 
   /****tfq deleted begin*************************     
   display
      part1
      part2
   with frame a.
 *****************tfq delete end*******************/  
   do on error undo, retry with frame a:

      dest_desc = "".
     assign sel-yn = no.                        /*kevin*/
       assign msg_file = "c:\bomcperror.txt".      /*kevin,12/23/2003*/
       /*********tfq added begin*****************/
        set site1 part1
                  site2 part2
              with frame a editing:
       /******tfq added end********************/
     /*************tfq delete begin***********
      set
         part1
         part2
         with frame a
      editing:
    **********tfq delete end****************/
        /*added by kevin,10/23/2003*/
               if frame-field = "site1" then do:
                  {mfnp.i si_mstr site1 si_site site1 si_site si_site}
                  if recno <> ? then do:
                      disp si_site @ site1 si_desc @ sidesc1 with frame a.
                  end.
                  recno = ?.
               end. /*frame-field = "site1"*/
          /*tfq*/ else if frame-field = "part1"        
        /*tfq if frame-field = "part1"  */
         then do:
            /* FIND NEXT/PREVIOUS RECORD - ALL BOM_MSTR'S ARE
            VALID FOR "SOURCE" */
            {mfnp.i bom_mstr part1 bom_parent part1
               bom_parent bom_parent}

            if recno <> ?
            then do:

               assign
                  part1 = bom_parent
                  desc1 = bom_desc
                  um1   = bom_batch_um.

               if bom-type <> fsm_c
               then do:
                  find pt_mstr where pt_part = bom_parent
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
            recno = ?.

         end.   /* if frame-field = "part1" */
        /**********tfq added begin*********************/
        else if frame-field = "site2" then do:
                  {mfnp.i si_mstr site2 si_site site2 si_site si_site}
                  if recno <> ? then do:
                      disp si_site @ site2 si_desc @ sidesc2 with frame a.
                  end.    
                  recno = ?.
               end. /*if frame-field = "site2"*/
               
        /*************tfq added end*********************/
         else if frame-field = "part2"
         then do:

            /* FIND NEXT/PREVIOUS RECORD - BOMS TO DISPLAY DEPEND
               IN THE INPUT BOM-TYPE PARAMETER */
            {mfnp05.i bom_mstr bom_fsm_type "bom_fsm_type = bom-type "
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
                  find pt_mstr no-lock where pt_part = bom_parent
                  no-error.
                  if available pt_mstr
                  then do:
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
/**************************************tfq added begin************************/

            /*added by kevin,10/23/2003 for verify site1*/
                 find si_mstr no-lock where si_site = site1 no-error.
                 if not available si_mstr or (si_db <> global_db) then do:
                     if not available si_mstr then msg-nbr = 708.
                     else msg-nbr = 5421.
                   /*TFQ  {mfmsg.i msg-nbr 3} */
               /*TFQ*/    {pxmsg.i
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
/*J034*/           /*tfq  {mfmsg.i 725 3}  */   /* USER DOES NOT HAVE */
/*J034*/            /*TFQ*/    {pxmsg.i
               &MSGNUM=725
               &ERRORLEVEL=3
                           }
                    /* ACCESS TO THIS SITE*/
                     next-prompt site1.
/*J034*/             undo,retry.
/*J034*/          end.

                /*added by kevin,10/23/2003 for verify site2*/
                 find si_mstr no-lock where si_site = site2 no-error.
                 if not available si_mstr or (si_db <> global_db) then do:
                     if not available si_mstr then msg-nbr = 708.
                     else msg-nbr = 5421.
                     /*tfq{mfmsg.i msg-nbr 3} */
                     /*TFQ*/    {pxmsg.i
               &MSGNUM=msg-nbr
               &ERRORLEVEL=3
                           }

                     next-prompt site2.
                     undo, retry.
                 end.
            
            if available si_mstr then disp si_site @ site2 si_desc @ sidesc2 with frame a.
                    
                {gprun.i ""gpsiver.p""
                "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/         /*tfq    {mfmsg.i 725 3} */
    /*TFQ*/    {pxmsg.i
               &MSGNUM=725
               &ERRORLEVEL=3
                           }
                            /* USER DOES NOT HAVE */
/*J034*/                                /* ACCESS TO THIS SITE*/
                     next-prompt site2.
/*J034*/             undo,retry.
/*J034*/          end.
/********************tfq added end*******************************************/
      if part2 = ""
      then do:
         {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}     /* BLANK NOT ALLOWED */
         next-prompt part2 with frame a.
         undo,retry .
      end.

      if bom-type = fsm_c and
         can-find(pt_mstr where pt_part = part2)
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

      find bom_mstr no-lock where bom_parent = part1 no-error.
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
      find first ps_mstr no-lock where  ps_par = part1
         and  ps_ps_code = "J" no-error.
      if available ps_mstr
      then do:
         /* JOINT PRODUCT STRUCTURE MAY NOT BE COPIED */
         {pxmsg.i &MSGNUM=6515 &ERRORLEVEL=3}
         undo, retry.
      end.

      if not can-find (first ps_mstr where ps_par = part1)
      then do:
         /* NO BILL OF MATERIAL EXISTS */
         {pxmsg.i &MSGNUM=100 &ERRORLEVEL=3 &MSGARG1="""("" + part1 + "")"""}
         undo, retry.
      end.
/*********************tfq added begin****************************************/
/*added by kevin, 11/12/2003*/
               if can-find (first ps_mstr where ps_par = part1 and ps__chr01 <> input site1) then do:
                     message "地点: " + input site1 + " 与产品结构: " + input part1 + " 不匹配" 
                             view-as alert-box error.
                     next-prompt site1 with frame a.
                     undo,retry.
               end.     
/*end added by kevin, 11/12/2003*/
/*****************tfq added end**********************************************/
      /* FOR MANUFACTURING BOM'S, DEFAULT THESE VALUES FROM PT_MSTR
      (IF AVAILABLE).  FOR SERVICE BOM'S, USE ONLY BOM_MSTR. */
      if bom-type <> fsm_c
      then do:
         find pt_mstr where pt_part = part1 no-lock no-error.
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

      find bom_mstr no-lock where bom_parent = part2 no-error.
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
            part2        = bom_parent
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
         find pt_mstr where pt_part = part2 no-lock no-error.
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
         where  ps_par = part2
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
      if can-find (first ps_mstr where ps_par = part2)
      then do:
         /* PART NUMBER HAS EXISTING BILL OF MATERIAL */
         {pxmsg.i &MSGNUM=200 &ERRORLEVEL=2 &MSGARG1="""("" + part2 + "")"""}
         input clear.
         yn = no.
      end.
  end marked by kevin, 11/12/2003*/    
*********************tfq deleted end************/
/***********tfq added begin**********************************/
/*added by kevin, 11/12/2003*/
               if can-find (first ps_mstr where ps_par = part2) then do:
                /*tfq  {mfmsg02.i 200 3 """("" + part2 + "")""" } */
                /*TFQ*/    {pxmsg.i
               &MSGNUM=200
               &ERRORLEVEL=3
               &MSGARG1=  """("" + part2 + "")"""
                         }
                  
                  next-prompt part2 with frame a.
                  undo,retry.
               end.                
/*end added by kevin, 11/12/2003*/               

/*added by kevin, 11/07/2003 for the copy between the different sites*/          
             if site1 <> site2 then do:
                 if xxbomc_part_site <> site1 or xxbomc_code_site <> site2 then do:
                     message "错误:根据BOM控制文件,此两地点间的复制将不被允许!" view-as alert-box error.
                     undo,retry.
                 end.
             end.
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
    if sel-yn then do:     
         yn = no.
           
         sw_block:
         do transaction: /*on endkey undo, leave:*/
              message "请按 'enter' or 'space', 键去选择第一层子零件.".         
              framename = "第一层子零件选择".      
         /* INCLUDE SCROLLING WINDOW TO ALLOW THE USER TO SCROLL      */
               /* THROUGH (AND SELECT FROM) EXISTING PAYMENTS APPLICATIONS  */
               {swselect.i
                  &detfile      = ps_from
                 &detkey = "where"
                 &searchkey = "ps_from.ps_par = part1 and (ps_from.ps_end = ? or ps_from.ps_end >= today)"
                  &scroll-field = ps_from.ps__chr02
                  &framename    = "c"
                  &framesize    = 10
                  &sel_on       = ""*""
                  &sel_off      = """"
                  &display1   = ps_from.ps__chr02
                  &display2     = ps_from.ps_comp
                  &display4     = ps_from.ps_ref
                  &display4     = ps_from.ps_start
                  &display5     = ps_from.ps_qty_per
                  &display6     = ps_from.ps_op
                  &display7     = """"
                  &display8     = """"
                  &display9     = """"
                  &exitlabel    = sw_block
                  &exit-flag    = first_sw_call 
                  &record-id    = ps_from_recno
                   }
           if keyfunction(lastkey) = "end-error"
            or lastkey = keycode("F4")
            or keyfunction(lastkey) = "."
            or lastkey = keycode("CTRL-E") then do:
               undo sw_block, leave.
            end.        
            else do:
             yn = no.
            /*tfq {mfmsg01.i 12 1 yn} */
          /*tfq*/   {pxmsg.i
               &MSGNUM=12
               &ERRORLEVEL=1
               &CONFIRM=yn
            }/* IS ALL INFORMATION CORRECT */
             if yn = no then do:
                undo sw_block, leave.
             end.
          end.
        end. /*sw_block*/
              
       hide message no-pause.
       
       if yn = no then undo,retry.   
    end. /*if sel-yn*/
/*end added by kevin*/

/************tfq added end*************************************/
   /*IS ALL INFORMATION CORRECT */
   if not sel-yn then do:                      /*kevin*/
   {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=yn}
   if yn = no
      then undo, retry.
       end.                                        /*kevin*/  
 /**************tfq added begin**********************************/
 /*added by kevin, 10/23/2003*/

           /*Kevin,12/23/2003 to verify the all components, whether 
           there are planning data in the 'to' site */
           if site1 <> site2 then do:
              pass_yn = yes.
              {gprun.i ""zzbmpscpmv.p""}
              if not pass_yn then do:
                    message "错误: 存在子零件在地点 " + site2 " 无计划数据,请察看出错提示文件!" 
                            view-as alert-box error.
                    undo,retry.
              end. 
           end.

          {mfselprt.i "printer" 132}
          
          if site1 = site2 then 
                {gprun.i ""zzbmpscpm1.p""}            /*For copy in the same site*/
          else do:              
              {gprun.i ""zzbmpscpm2.p""}           /*For copy between the two different site*/
          end.    
          
          {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
        
/*end added by kevin, 10/23/2003*/
 
 /**********tfq added end**************************************/        
     end marked by kevin,10/23/2003*/
   ************tfq deleted end******************/
   found_any = no.

   /*MESSAGE part1 "heeeee".
   PAUSE.*/
   for each ps_from where ps_par = part1
      and (ps_from.ps_end = ?
           or ps_from.ps_end >= today)
     /*and ps_from.ps__chr02 <> ""  */     /*kevin*/ 
       and ps_from.ps__chr01 <> ""   /*judy liu*/
   no-lock with frame b:
    /*MESSAGE ps_par part1 "haaa".
    PAUSE.*/
      if not can-find (bom_mstr where bom_parent = part2
         and bom_fsm_type = bom-type)
      then do:

         create bom_mstr.
         assign
            bom_parent   = part2
            bom_userid   = global_userid
            bom_mod_date = today
            bom_batch    = to_batch_qty
            bom_batch_um = to_batch_um
            bom_desc     = desc3
            bom_fsm_type = bom-type
            bom_formula  = formula_yn.

         if recid(bom_mstr) = -1
         then .
         find bommstr where bommstr.bom_parent = part1
         no-lock no-error.
         if available bommstr
         then
            assign
               bom_mstr.bom_user1   =  bommstr.bom_user1
               bom_mstr.bom_user2   =  bommstr.bom_user2
               bom_mstr.bom__chr01  =  bommstr.bom__chr01
               bom_mstr.bom__chr02  =  bommstr.bom__chr02
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
         find bom_mstr exclusive-lock
            where bom_mstr.bom_parent = part2.
         bom_mstr.bom_desc = desc3.
      end.

      pause 0 no-message.
      find ps_mstr where ps_mstr.ps_par = part2
         and ps_mstr.ps_comp = ps_from.ps_comp
         and ps_mstr.ps_ref = ps_from.ps_ref
         and ps_mstr.ps_start = ps_from.ps_start
         and ps_mstr.ps_end = ps_from.ps_end
         no-error.

      if not available ps_mstr
      then do:
         overlap-check:
         do:
            check1:
            do:
               for each ps_mstr no-lock where ps_mstr.ps_par = part2
                  and ps_mstr.ps_comp = ps_from.ps_comp
                  and ps_mstr.ps_ref = ps_from.ps_ref
                  and (  (ps_mstr.ps_end   = ? and ps_from.ps_end   = ?)
                   or (ps_mstr.ps_start = ? and ps_from.ps_start = ?)
                   or (ps_mstr.ps_start = ? and ps_mstr.ps_end   = ?)
                   or (ps_from.ps_start = ? and ps_from.ps_end   = ?)
                   or ((ps_from.ps_start >= ps_mstr.ps_start
                   or ps_mstr.ps_start = ?)
                  and ps_from.ps_start <= ps_mstr.ps_end)
                   or (ps_from.ps_start <= ps_mstr.ps_end
                   and ps_from.ps_end >= ps_mstr.ps_start)
                     ):
                  leave check1.
               end.    /* for each ps_mstr */
               leave overlap-check.
            end.  /* check1 do */
            /* DATE RANGES MAY NOT OVERLAP */
            {pxmsg.i &MSGNUM=122 &ERRORLEVEL=4}
            /* COMPONENT # NOT COPIED */
            {pxmsg.i &MSGNUM=1774 &ERRORLEVEL=1 &MSGARG1=ps_mstr.ps_comp}
            undo, next.
         end.    /* overlap-check */

         do:
            find first pt_mstr
                where pt_part = part2
            no-lock no-error.
            if available pt_mstr
            then do:
               assign
                  l_ptstatus                = pt_status
                  substring(l_ptstatus,9,1) = "#".
               for first isd_det
                  fields(isd_status isd_tr_type)
                  where   isd_status  = l_ptstatus
                    and   isd_tr_type = "ADD-PS"
               no-lock:
               end. /* FOR FIRST isd_det */
               if available isd_det
               then do:
                  /* RESTRICTED PROCEDURE FOR ITEM STATUS CODE */
                  /*V8!
                  {pxmsg.i &MSGNUM=358 &ERRORLEVEL=4} */
                  /*V8-*/
                  {pxmsg.i &MSGNUM=358 &ERRORLEVEL=4 &PAUSEAFTER=5}
                  /*V8+*/
                  undo, next.
               end. /* IF AVAILABLE isd_det */
            end. /* IF AVAILABLE pt_mstr */
         end. /* DO */

         create ps_mstr.
         assign
            ps_mstr.ps_par       = part2
            ps_mstr.ps_comp      = ps_from.ps_comp
            ps_mstr.ps_ref       = ps_from.ps_ref
            ps_mstr.ps_scrp_pct  = ps_from.ps_scrp_pct
            ps_mstr.ps_ps_code   = ps_from.ps_ps_code
            ps_mstr.ps_lt_off    = ps_from.ps_lt_off
            ps_mstr.ps_start     = ps_from.ps_start
            ps_mstr.ps_end       = ps_from.ps_end
            ps_mstr.ps_rmks      = ps_from.ps_rmks
            ps_mstr.ps_op        = ps_from.ps_op
            ps_mstr.ps_item_no   = ps_from.ps_item_no
            ps_mstr.ps_mandatory = ps_from.ps_mandatory
            ps_mstr.ps_exclusive = ps_from.ps_exclusive
            ps_mstr.ps_process   = ps_from.ps_process
            ps_mstr.ps_qty_type  = ps_from.ps_qty_type
            ps_mstr.ps_fcst_pct  = ps_from.ps_fcst_pct
            ps_mstr.ps_default   = ps_from.ps_default
            ps_mstr.ps_group     = ps_from.ps_group
            ps_mstr.ps_critical  = ps_from.ps_critical
            ps_mstr.ps_user1     = ps_from.ps_user1
            ps_mstr.ps_user2     = ps_from.ps_user2.

         ps_recno = recid(ps_mstr).

         /* CYCLIC PRODUCT STRUCTURE CHECK */
        /*tfq {gprun.i ""bmpsmta.p""} */ 
          {gprun.i ""yybmpsmta.p""}   /*tfq*/
         if ps_recno = 0
         then do:
            /* "CYCLIC PRODUCT STRUCTURE - "
               + part2 + " - " + ps_mstr.ps_comp + " NOT ADDED */
            {pxmsg.i &MSGNUM=206 &ERRORLEVEL=2 &MSGARG1=ps_mstr.ps_comp}
            pause 5.
            undo, next.
         end.

         for each in_mstr exclusive-lock where
            in_part = ps_mstr.ps_comp:
            if available in_mstr
            then
               assign
                  in_level = 99999
                  in_mrp   = true.
         end.

      end.   /* if not available ps_mstr */

      find pt_mstr
         where pt_part = ps_mstr.ps_comp no-lock no-error.
      find bommstr no-lock
         where bommstr.bom_parent = ps_mstr.ps_comp no-error.

      if available pt_mstr then
         um = pt_um.
      else
      if available bommstr then
         um = bommstr.bom_batch_um.

      conv = 1.
      if um <> to_batch_um
         and ps_mstr.ps_qty_type = "P"
      then do:
         {gprun.i ""gpumcnv.p""
            "(um, to_batch_um, ps_mstr.ps_comp, output conv)"}
         if conv = ?
         then do:
            /* COMPONENT UM IS DIFFERENT THAN PARENT UM */
            {pxmsg.i &MSGNUM=4600 &ERRORLEVEL=4
                     &MSGARG1="""("" + ps_mstr.ps_comp + "")"""}
            {pxmsg.i &MSGNUM=33 &ERRORLEVEL=4}  /* NO UOM CONVERSION EXISTS */
            pause 5.
            undo, next.
         end.
      end.    /* if um <> to_batch_um and... */

      if config_yn
         and ps_from.ps_qty_per_b = 0
         and ps_from.ps_qty_type = ""
      then
         qtyper_b = ps_from.ps_qty_per.
      else
         qtyper_b = ps_from.ps_qty_per_b.

      assign
         ps_mstr.ps_qty_per_b = ps_mstr.ps_qty_per_b
                              + ((qtyper_b * copy_conv
                              * if ps_mstr.ps_qty_type = ""
                                then
                                   1
                                else
                                   to_batch_qty)
                              / if ps_from.ps_qty_type = ""
                                then 1 else from_batch_qty)

         ps_mstr.ps_qty_per = ps_mstr.ps_qty_per +
                              ps_from.ps_qty_per.

      if ps_mstr.ps_qty_type = "P" then
         ps_mstr.ps_batch_pct = (ps_mstr.ps_qty_per_b * conv)
                              / (.01 * to_batch_qty).

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).
      display
         ps_mstr.ps_comp
         ps_mstr.ps_ref
         ps_mstr.ps_qty_per
         ps_mstr.ps_ps_code
         ps_mstr.ps_start
         ps_mstr.ps_end
      with frame b width 80 no-attr-space
        stream-io.                                 /*kevin*/

      found_any = yes.

      /* STORE MODIFY DATE AND USERID */
      assign
         ps_mstr.ps_mod_date = today
         ps_mstr.ps_userid   = global_userid.
 ps_mstr.ps__chr01 = ps_from.ps__chr01.           /*kevin,11/06/2003 for site control*/
          /*MESSAGE "wuuuuuuuu" ps_mstr.ps__chr01.
          PAUSE.*/
   end.     /* for each ps_mstr */
/*GUI*/ if global-beam-me-up then undo, leave.


   {pxmsg.i &MSGNUM=7 &ERRORLEVEL=1}

   if found_any
   then do:
      {inmrp.i &part=part2 &site=unknown_char}
   end.
   /*marked by kevin,10/23/2003

end.   /* repeat */
/*GUI*/ if global-beam-me-up then undo, leave.
end marked by kevin,10/23/2003, and copy code to program zzbmpscpm1.p*/
