/* xslndefine.i 根据通用代码的程式名(或procedure,如loadmenu) ,查找对应的指令代码  */  
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*
指令变更要依次修改的文件:
*/ 

v_line_prev[1]  =  "" .
v_line_prev[2]  =  "" .
v_line_prev[3]  =  "" .
v_line_prev[4]  =  "" .
v_line_prev[5]  =  "" .
v_line_prev[6]  =  "" .
v_line_prev[7]  =  "" .
v_line_prev[8]  =  "" .
v_line_prev[9]  =  "" .
v_line_prev[10] =  "" .
v_line_prev[11] =  "" .
v_line_prev[12] =  "" .
v_line_prev[13] =  "" .
v_line_prev[14] =  "" .
v_line_prev[15] =  "" .
v_line_prev[16] =  "" .
v_line_prev[17] =  "" .
v_line_prev[18] =  "" .
v_line_prev[19] =  "" .
v_line_prev[20] =  "" .
v_line_prev[21] =  "" .
v_line_prev[22] =  "" .
v_line_prev[23] =  "" .
v_line_prev[24] =  "" .
v_line_prev[25] =  "" .
v_line_prev[26] =  "" .
v_line_prev[27] =  "" .
v_line_prev[28] =  "" .
v_line_prev[29] =  "" .
v_line_prev[30] =  "" .


for each xcode_mstr where xcode_fldname = v_fldname and xcode_cmmt <> "" no-lock :
    if index(xcode_cmmt, "@") <> 0 and trim(entry(2,xcode_cmmt,"@")) <> "" then do:
         /*准备时间*/    if trim(entry(2,xcode_cmmt,"@")) = "xstimesetup.p"    then v_line_prev[1]  = xcode_value .
         /*运行时间*/    if trim(entry(2,xcode_cmmt,"@")) = "xstimerun.p"      then v_line_prev[2]  = xcode_value .
                                                                              
         /*合格反馈*/    if trim(entry(2,xcode_cmmt,"@")) = "xsfbfinish.p"     then v_line_prev[3]  = xcode_value .
         /*报废反馈*/    if trim(entry(2,xcode_cmmt,"@")) = "xsfbscrap.p"      then v_line_prev[4]  = xcode_value .
         /*返工反馈*/    if trim(entry(2,xcode_cmmt,"@")) = "xsfbrework.p"     then v_line_prev[5]  = xcode_value .
         /*返工标签*/    if trim(entry(2,xcode_cmmt,"@")) = "xsfbreworklb.p"   then v_line_prev[6]  = xcode_value .
                                                                              
         /*切换工单*/    if trim(entry(2,xcode_cmmt,"@")) = "xschgwolot.p"     then v_line_prev[7]  = xcode_value .
         /*位置转移*/    if trim(entry(2,xcode_cmmt,"@")) = "xschgplace.p"     then v_line_prev[8]  = xcode_value .
                                                                              
         /*取消工序*/    if trim(entry(2,xcode_cmmt,"@")) = "xsopcancel.p"     then v_line_prev[9]  = xcode_value .
         /*新增工序*/    if trim(entry(2,xcode_cmmt,"@")) = "xsopnew.p"        then v_line_prev[10] = xcode_value .
                                                                              
         /*WIP报表 */    if trim(entry(2,xcode_cmmt,"@")) = "xsrpwip001.p"     then v_line_prev[11] = xcode_value .
         /*交易报表*/    if trim(entry(2,xcode_cmmt,"@")) = "xsrpfb001.p"      then v_line_prev[12] = xcode_value .
                                                                              
         /*切换机器*/    if trim(entry(2,xcode_cmmt,"@")) = "xschgmachine.p"   then v_line_prev[13] = xcode_value .
         /*刷新屏幕*/    if trim(entry(2,xcode_cmmt,"@")) = "xsreflash.p"      then v_line_prev[14] = xcode_value .
                                                                              
         /*结束反馈*/    if trim(entry(2,xcode_cmmt,"@")) = "xsquit.p"         then v_line_prev[15] = xcode_value .
         /*更新(月)*/    if trim(entry(2,xcode_cmmt,"@")) = "xsupdatem.p"      then v_line_prev[16] = xcode_value .
         /*更新(日)*/    if trim(entry(2,xcode_cmmt,"@")) = "xsupdated.p"      then v_line_prev[17] = xcode_value .
         
         /*停机时间*/    if trim(entry(2,xcode_cmmt,"@")) = "xstimedown.p"     then v_line_prev[18] = xcode_value .
         /*机器维修*/    if trim(entry(2,xcode_cmmt,"@")) = "xsfixmachine.p"   then v_line_prev[19] = xcode_value .
         /*开会时间*/    if trim(entry(2,xcode_cmmt,"@")) = "xstimemeeting.p"  then v_line_prev[20] = xcode_value .
         /*吃饭时间*/    if trim(entry(2,xcode_cmmt,"@")) = "xstimedinner.p"   then v_line_prev[21] = xcode_value .
         /*时间调整*/    if trim(entry(2,xcode_cmmt,"@")) = "xstimechg.p"      then v_line_prev[22] = xcode_value .
         /*正常停机*/    if trim(entry(2,xcode_cmmt,"@")) = "xstimedown01.p"   then v_line_prev[23] = xcode_value .
         /*其他停机*/    if trim(entry(2,xcode_cmmt,"@")) = "xstimedown02.p"   then v_line_prev[24] = xcode_value .

/*tommy-关闭指令*/       if trim(entry(2,xcode_cmmt,"@")) = "xstimecls.p"      then v_line_prev[25] = xcode_value .
     /*强制取消工序*/    if trim(entry(2,xcode_cmmt,"@")) = "xsopcancel02.p"   then v_line_prev[26] = xcode_value .
         /*恢复生产*/    if trim(entry(2,xcode_cmmt,"@")) = "xstimedinner02.p" then v_line_prev[27] = xcode_value .
         /*时间盘点*/    if trim(entry(2,xcode_cmmt,"@")) = "xstimecount.p"    then v_line_prev[28] = xcode_value .



                         /*预留指令*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[29] = xcode_value .

         /*权限设置*/    if trim(entry(2,xcode_cmmt,"@")) = "loadmenu"         then v_line_prev[30] = xcode_value .
    end.
end. /*for each xcode_mstr*/


