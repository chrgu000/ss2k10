/* last modified by: hou       2006.02.20                        *H01* */

{mfdtitle.i}                                                        
def var plnbr       /*like xgpl_nbr*/ as CHAR LABEL "生产线".
def var file_path   as char format "x(40)" label "下线产品接口目录".
def var file_name   as char format "x(12)" label "下线产品接口文件名".
def var error_path  as char format "x(40)" label "出错文件目录".
def var backup_path as char format "x(40)" label "文件备份目录".
def var site        like si_site label "地点".
def var loc         like xgpl_loc label "仓库库位".
def var loc2        like xgpl_loc_lnr label "线边库位".
def var loc1        like loc_loc label "隔离库位".
DEF VAR l_slash     AS CHAR.
DEF VAR yn          AS LOGICAL FORMAT "Y/N" INIT YES.
DEF VAR printer1    AS CHAR LABEL "包装打印机" FORMAT "x(50)".

form plnbr          colon 20 xgpl_desc label "描述" format "x(40)"
     file_path      colon 20
     file_name      colon 20
     error_path     colon 20
     backup_path    colon 20
     site           colon 20
     loc2           colon 20
     loc            colon 20
     loc1           colon 20
     printer1         COLON 20
     with frame a side-label width 80.

if opsys = "unix" then assign l_slash = "/".
else if opsys = "msdos" or opsys = "win32" then assign l_slash = "~\".
else if opsys = "vms"   then l_slash = "]". 

FUNCTION slashok RETURNS CHARACTER (xdir AS CHARACTER):
    IF LOOKUP(SUBSTRING(xdir,LENGTH(xdir),1),"/,\,[.") = 0
    THEN RETURN ( xdir + l_slash)  .
    ELSE RETURN xdir .
END FUNCTION .

FUNCTION dirok RETURNS LOGICAL (xdir AS CHARACTER) :    
    DEFINE VARIABLE l_output_ok LIKE mfc_logical NO-UNDO .
    IF xdir = "" THEN RETURN NO .
    ELSE DO:
        xdir = slashok(xdir) .
        {gprun.i ""xgmfoutexi.p"" "(xdir + ""TMP"",output l_output_ok)"}
        RETURN l_output_ok .
    END.
END FUNCTION .

repeat:
   set plnbr VALIDATE(plnbr <> "","请输入生产线!") with frame a editing.
      {mfnp.i xgpl_ctrl plnbr xgpl_lnr plnbr xgpl_lnr xgpl_lnr}
      if recno <> ? then do:
         plnbr = xgpl_lnr.
         disp plnbr xgpl_desc 
              xgpl_prd_dir      @ FILE_path 
              xgpl_fis_file     @ FILE_name 
              xgpl_err_dir      @ ERROR_path 
              xgpl_bak_dir      @ backup_path 
              xgpl_site         @ site 
              xgpl_loc_lnr      @ loc2
              xgpl_loc          @ loc 
              xgpl_loc1         @ loc1 
              xgpl_chr2         @ printer1
              with frame a .
      end.
      status input.

/*H01* 
      readkey. 
      apply lastkey. 
*H01*/

   end.
      find xgpl_ctrl where xgpl_lnr = plnbr no-error. 
      if avail xgpl_ctrl then do:
         message "修改生产线记录...". 
         file_path      = xgpl_prd_dir.
         file_name      = xgpl_fis_file.
         error_path     = xgpl_err_dir.
         backup_path    = xgpl_bak_dir.
         site           = xgpl_site.
         loc2           = xgpl_loc_lnr.
         loc            = xgpl_loc.
         loc1           = xgpl_loc1.
         printer1       = xgpl_chr2.
      end.
      else do:
       
         MESSAGE "增加生产线记录?" VIEW-AS ALERT-BOX  BUTTONS YES-NO SET yn AUTO-RETURN.

         if not yn then undo,retry.
         create xgpl_ctrl.
         assign xgpl_lnr = plnbr.
      end. 
    update xgpl_desc with frame a.
    update file_path   VALIDATE(dirok(file_path),  
                        "生产线产品接口目录 " + INPUT FILE_path + " 不存在!")
           file_name   /*VALIDATE(FILE_name <> "","文件名不能为空!") */
           error_path  VALIDATE(dirok(error_path), 
                        "出错文件目录 " + INPUT error_path + " 不存在!")     
           backup_path VALIDATE(dirok(backup_path),
                        "文件备份目录 " + INPUT backup_path + " 不存在!")     
           site        VALIDATE(CAN-FIND(si_mstr WHERE si_site = site 
                        NO-LOCK),"输入的地点不存在!")  
           GO-ON(ctrl-d "F5") WITH FRAME a.
   IF LASTKEY = KEYCODE("Ctrl-D") OR LASTKEY= KEYCODE("F5") THEN DO:
  
      MESSAGE "请确认删除" VIEW-AS ALERT-BOX  BUTTONS YES-NO SET yn AUTO-RETURN.
      IF yn then do:
          delete xgpl_ctrl.
          message "删除完成!".
          next.
      end.
   END.
   

   loop1:
   DO ON ERROR UNDO,RETRY:
   
   UPDATE
           loc2        VALIDATE(CAN-FIND(loc_mstr WHERE loc_site = input site 
                        AND loc_loc = loc2 NO-LOCK),"输入的库位不存在!")   
           loc         VALIDATE(CAN-FIND(loc_mstr WHERE loc_site = input site 
                        AND loc_loc = loc NO-LOCK),"输入的库位不存在!")   
           loc1        VALIDATE(CAN-FIND(loc_mstr WHERE loc_site = input site 
                        AND loc_loc = loc1 NO-LOCK),"输入的库位不存在!")  
           go-on(Ctrl-D "F5")
           with frame a.
   IF loc2 = loc OR loc2 = loc OR loc = loc1 THEN DO WITH FRAME a:
      MESSAGE "库位相同，请选择不同库位!!!".
      UNDO loop1,RETRY.  
   END.
   END.

   UPDATE printer1 WITH FRAME a.

   IF LASTKEY = KEYCODE("Ctrl-D") OR LASTKEY= KEYCODE("F5") THEN DO:
      MESSAGE "请确认删除" VIEW-AS ALERT-BOX  BUTTONS YES-NO SET yn AUTO-RETURN.
      
      IF yn then do:
          delete xgpl_ctrl.
          message "删除完成!".
          next.
      end.
   END.

   ASSIGN xgpl_prd_dir      = FILE_path
          xgpl_fis_file     = FILE_name
          xgpl_err_dir      = ERROR_path
          xgpl_bak_dir      = backup_path
          xgpl_site         = site
          xgpl_loc_lnr      = loc2
          xgpl_loc          = loc
          xgpl_loc1         = loc1.
          xgpl_chr2         = printer1.
   IF NEW(xgpl_ctrl) THEN MESSAGE "生产线 " + plnbr " 新增完成!".
   ELSE MESSAGE "生产线 " + plnbr " 修改完成!".
end.                             
