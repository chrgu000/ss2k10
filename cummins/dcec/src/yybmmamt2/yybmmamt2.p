/*xxbmmamt2.p for bom code maintenance,by kevin,2003/10*/
/****************************************************************
For 'M' type item, automatically generate the bom code against it,
and users can modify the comments of bom code, and users can delete
the bom code against the 'M' type item
*****************************************************************/
/** ss 120815.1 zy - add domain                                          */
         /* DISPLAY TITLE */

/*GI32*/ {mfdtitle.i "120815.1"}

def var site like si_site.
def var part like pt_part.
def var desc1 like pt_desc1.
def var desc2 like pt_desc2.
def var um like bom_batch_um.
def var bomcode like bom_parent.
def var cmmts like bom_desc.
def var msg-nbr as inte.
def var conf-yn as logic.
def var del-yn as logic.
def var lines as inte.
def var new_yn as logic.

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A


 Form
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1 SKIP(.1)  /*GUI*/
 part colon 33 desc1 no-label
               desc2 no-label colon 49 skip(1)
 bomcode colon 33
 site colon 33 si_desc no-label
 bom_batch_um colon 33
 bom_desc colon 33
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

setFrameLabels(frame a:handle).
mainloop:
repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

    find first xxbomc_ctrl where xxbomc_domain = global_domain no-lock no-error.
    if not available xxbomc_ctrl then do:
        message "错误:BOM控制文件还未生成,请首先维护BOM控制文件!" view-as alert-box error.
        leave mainloop.
    end.

    site = "".
    part = "".
    bomcode = "".
    um = "".
    desc1 = "".
    new_yn = no.

   clear frame a.

    update part with frame a editing:
        if frame-field = "part" then do:
            {mfnp.i pt_mstr part " pt_mstr.pt_domain = global_domain and pt_part " part pt_part pt_part}
            if recno <> ? then do:
                disp pt_part @ part pt_desc1 @ desc1 pt_desc2 @ desc2 with frame a.
            end.
        end.
        else do:
            readkey.
          apply lastkey.
       end.
    end.

   find pt_mstr where pt_domain = global_domain and pt_part = part no-lock no-error.
   if not available pt_mstr then do:
        /*tfq {mfmsg.i 16 3}*/
  /*tfq*/      {pxmsg.i
               &MSGNUM=16
               &ERRORLEVEL=3
                           }
        undo,retry.
   end.

   find first ptp_det where ptp_domain = global_domain and ptp_part = part no-lock no-error.
   if not available ptp_det then do:
        message "零件无地点-计划数据,请重新输入" view-as alert-box error.
        undo,retry.
   end.

   if ptp_pm_code <> "m" then do:
       conf-yn = no.
       message "该零件的'采/制'类型为: '" + ptp_pm_code "',是否继续"
              view-as alert-box question button yes-no update conf-yn.
        if conf-yn <> yes then undo,retry.
   end.

    /*******************search the suffix for the bom code which users want to execute**********/
    find first code_mstr where code_domain = global_domain and code_fldname = "cust-control-file" and
                               code_value = "auto-bomcode-generate" no-lock no-error.
    if not available code_mstr or code_cmmt = "" then do:
        message "错误:物料清单代码的后缀控制文件不存在、或后缀为空,请重新输入!" view-as alert-box error.
        undo,retry.
    end.

    bomcode = part + trim(code_cmmt).

    if length(bomcode) > 18 then do:
       message "物料单代码 " + bomcode + " 长度超过了18位" view-as alert-box error.
       undo,retry.
    end.

    um = pt_um.
    cmmts = pt_desc2.           /*kevin, for chinese description*/


    find bom_mstr exclusive-lock where bom_domain = global_domain and bom_parent = bomcode no-error.
    if not available bom_mstr then do:
         /*tfq {mfmsg.i 1 1} */
         {pxmsg.i
               &MSGNUM=1
               &ERRORLEVEL=1
                        }
         create bom_mstr. bom_domain = global_domain.
         assign bom_parent = caps(bomcode)
                bom_batch_um = um
                bom_formula = pt_formula
                bom_desc = cmmts.
         new_yn = yes.
    end.

		if substring(bomcode , length(bomcode) - 1,length(trim(code_cmmt))) = trim(code_cmmt) then do:
    	  assign bom__chr02 = substring(bomcode , 1 , length(bomcode) - length(trim(code_cmmt))).
    end.
    else do:
        assign bom__chr02 = bomcode.
	  end.

    disp bom__chr01 when not new_yn @ site xxbomc_code_site when new_yn @ site
        bom_parent @ bomcode bom_batch_um bom_desc with frame a.

            ststatus = stline[2].
            status input ststatus.
            del-yn = no.


            do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

                 set site with frame a.

                 find si_mstr no-lock where si_domain = global_domain and
                 	    si_site = site no-error.
                 if not available si_mstr or (si_db <> global_db) then do:
                     if not available si_mstr then msg-nbr = 708.
                     else msg-nbr = 5421.
                     /*tfq {mfmsg.i msg-nbr 3}*/
                      {pxmsg.i
               &MSGNUM=msg-nbr
               &ERRORLEVEL=3
                          }
                     undo, retry.
                 end.

                {gprun.i ""gpsiver.p""
                "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/             {mfmsg.i 725 3}    /* USER DOES NOT HAVE */
/*J034*/               {pxmsg.i
               &MSGNUM=725
               &ERRORLEVEL=3
                          }                  /* ACCESS TO THIS SITE*/
/*J034*/             undo,retry.
/*J034*/          end.

               if site <> xxbomc_code_site then do:                /*kevin,11/06/2003*/
                  message "错误:输入的地点与BOM控制文件中指定的地点不一致,请重新输入!" view-as alert-box error.
                  undo,retry.
               end.

    find first ptp_det where ptp_domain = global_domain and
    				   ptp_part = part and ptp_site <> site no-lock no-error.
    if not available ptp_det then do:
         message "不允许对零件: '" + part + "' 生成地点: '" + site + "' 的产品结构代码" view-as alert-box error.
         undo,retry.
    end.


                 set bom_batch_um bom_desc go-on ("F5" "CTRL-D") with frame a.

       	         assign
	                 bom__chr01 = site
	                 bom_userid = global_userid
	                 bom_mod_date = today.

	       /* DELETE */
	       if lastkey = keycode("F5")
	       or lastkey = keycode("CTRL-D")
	       then do:

/*G309*/    /*PATCH G309 OVERRIDES PATCH F671.  IT WAS DEEMED BETTER TO      */
	    /*TOTALLY PROHIBIT THE DELETION OF BOM CODES THAT ARE USED IN    */
	    /*STRUCTURES RATHER THAN AUTOMATICALLY DELETE THE STRUCTURE.     */
/*G309*/    /*WHATEVER METHOD IS USED MUST BE THE SAME IN FMMAMT.P AS WELL   */

/*G309*/            if can-find (first ps_mstr where ps_domain = global_domain
																	 and ps_par = bom_parent)
/*FS62*  /*G309*/    or can-find (first ps_mstr where ps_domain = global_domain and ps_comp = bom_parent)  */
/*F0SL*/            or (can-find (first ps_mstr where ps_domain = global_domain and ps_comp = bom_parent)
/*F0SL*/                and not can-find(pt_mstr where pt_domain = global_domain and pt_part = bom_parent))
/*G309*/            then do:
/*G309*/             /*tfq   {mfmsg.i 226 3} */
                     {pxmsg.i
               &MSGNUM=226
               &ERRORLEVEL=3
                        }
/*Delete not allowed, product structure exists*/
/*G309*/                undo mainloop, retry.
/*G309*/            end.

	           del-yn = yes.
	         /*tfq  {mfmsg01.i 11 1 del-yn} */
	          {pxmsg.i
               &MSGNUM=11
               &ERRORLEVEL=1
               &CONFIRM=del-yn
            }
	           if del-yn = no then undo, retry.

	           delete bom_mstr.
	           del-yn = no.
/*F671*/            if lines > 0 then do:
/*F671*/               /*tfq {mfmsg02.i 24 1 lines}*/
                    {pxmsg.i
               &MSGNUM=24
               &ERRORLEVEL=1
               &MSGARG1=lines
            }
/*F671*/            end.
/*F671*/            else do:
	                /*tfq {mfmsg.i 22 1}*/
	                {pxmsg.i
               &MSGNUM=22
               &ERRORLEVEL=1
                           }
/*F671*/            end.

	       end.    /* if lastkey ... */

            end. /*do on error undo,retry*/

end. /*repeat*/
