/* xslndefine.i ����ͨ�ô���ĳ�ʽ��(��procedure,��loadmenu) ,���Ҷ�Ӧ��ָ�����  */  
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*
ָ����Ҫ�����޸ĵ��ļ�:
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
v_line_prev[28] =  "" .    /*�Ժ�ĳ�ѭ���ķ�ʽ��ֵ*/
v_line_prev[29] =  "" .
v_line_prev[30] =  "" .
v_line_prev[31] =  "" .
v_line_prev[32] =  "" .
v_line_prev[33] =  "" .
v_line_prev[34] =  "" .
v_line_prev[35] =  "" .
v_line_prev[36] =  "" .
v_line_prev[37] =  "" .
v_line_prev[38] =  "" .
v_line_prev[39] =  "" .
v_line_prev[40] =  "" .
v_line_prev[41] =  "" .
v_line_prev[42] =  "" .
v_line_prev[43] =  "" .
v_line_prev[44] =  "" .
v_line_prev[45] =  "" .
v_line_prev[46] =  "" .
v_line_prev[47] =  "" .
v_line_prev[48] =  "" .
v_line_prev[49] =  "" .
v_line_prev[50] =  "" .
v_line_prev[51] =  "" .
v_line_prev[52] =  "" .
v_line_prev[53] =  "" .
v_line_prev[54] =  "" .
v_line_prev[55] =  "" .
v_line_prev[56] =  "" .
v_line_prev[57] =  "" .
v_line_prev[58] =  "" .
v_line_prev[59] =  "" .
v_line_prev[60] =  "" .    


for each xcode_mstr where xcode_fldname = v_fldname and xcode_cmmt <> "" no-lock :
    if index(xcode_cmmt, "@") <> 0 and trim(entry(2,xcode_cmmt,"@")) <> "" then do:
         /*׼��ʱ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xstimesetup.p"    then v_line_prev[1]  = xcode_value .
         /*����ʱ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xstimerun.p"      then v_line_prev[2]  = xcode_value .
                                                                              
         /*�ϸ���*/    if trim(entry(2,xcode_cmmt,"@")) = "xsfbfinish.p"     then v_line_prev[3]  = xcode_value .
         /*���Ϸ���*/    if trim(entry(2,xcode_cmmt,"@")) = "xsfbscrap.p"      then v_line_prev[4]  = xcode_value .
         /*��������*/    if trim(entry(2,xcode_cmmt,"@")) = "xsfbrework.p"     then v_line_prev[5]  = xcode_value .
         /*������ǩ*/    if trim(entry(2,xcode_cmmt,"@")) = "xsfbreworklb.p"   then v_line_prev[6]  = xcode_value .
                                                                              
         /*�л�����*/    if trim(entry(2,xcode_cmmt,"@")) = "xschgwolot.p"     then v_line_prev[7]  = xcode_value .
         /*λ��ת��*/    if trim(entry(2,xcode_cmmt,"@")) = "xschgplace.p"     then v_line_prev[8]  = xcode_value .
                                                                              
         /*ȡ������*/    if trim(entry(2,xcode_cmmt,"@")) = "xsopcancel.p"     then v_line_prev[9]  = xcode_value .
         /*��������*/    if trim(entry(2,xcode_cmmt,"@")) = "xsopnew.p"        then v_line_prev[10] = xcode_value .
                                                                              
         /*WIP���� */    if trim(entry(2,xcode_cmmt,"@")) = "xsrpwip001.p"     then v_line_prev[11] = xcode_value .
         /*���ױ���*/    if trim(entry(2,xcode_cmmt,"@")) = "xsrpfb001.p"      then v_line_prev[12] = xcode_value .
                                                                              
         /*�л�����*/    if trim(entry(2,xcode_cmmt,"@")) = "xschgmachine.p"   then v_line_prev[13] = xcode_value .
         /*ˢ����Ļ*/    if trim(entry(2,xcode_cmmt,"@")) = "xsreflash.p"      then v_line_prev[14] = xcode_value .
                                                                              
         /*��������*/    if trim(entry(2,xcode_cmmt,"@")) = "xsquit.p"         then v_line_prev[15] = xcode_value .
         /*����(��)*/    /*if trim(entry(2,xcode_cmmt,"@")) = "xsupdatem.p"      then v_line_prev[16] = xcode_value .*/
         /*����(��)*/    /*if trim(entry(2,xcode_cmmt,"@")) = "xsupdated.p"      then v_line_prev[17] = xcode_value .*/
         
         /*ͣ��ʱ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xstimedown.p"     then v_line_prev[18] = xcode_value .
         /*����ά��*/    if trim(entry(2,xcode_cmmt,"@")) = "xsfixmachine.p"   then v_line_prev[19] = xcode_value .
         /*����ʱ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xstimemeeting.p"  then v_line_prev[20] = xcode_value .
         /*�Է�ʱ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xstimedinner.p"   then v_line_prev[21] = xcode_value .
         /*ʱ�����*/    if trim(entry(2,xcode_cmmt,"@")) = "xstimechg.p"      then v_line_prev[22] = xcode_value .
         /*����ͣ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xstimedown01.p"   then v_line_prev[23] = xcode_value .
         /*����ͣ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xstimedown02.p"   then v_line_prev[24] = xcode_value .

/*tommy-�ر�ָ��*/       if trim(entry(2,xcode_cmmt,"@")) = "xstimecls.p"      then v_line_prev[25] = xcode_value .
     /*ǿ��ȡ������*/    if trim(entry(2,xcode_cmmt,"@")) = "xsopcancel02.p"   then v_line_prev[26] = xcode_value .
         /*�ָ�����*/    if trim(entry(2,xcode_cmmt,"@")) = "xstimedinner02.p" then v_line_prev[27] = xcode_value .
         /*��ֹ����*/    if trim(entry(2,xcode_cmmt,"@")) = "xsopcancel03.p"   then v_line_prev[28] = xcode_value .
         /*������*/    if trim(entry(2,xcode_cmmt,"@")) = "xsfbfinish01.p"   then v_line_prev[29] = xcode_value .
         /*������*/    /*if trim(entry(2,xcode_cmmt,"@")) = "xsfbfinish02.p"   then v_line_prev[29] = xcode_value .*/

         /*Ȩ������*/    if trim(entry(2,xcode_cmmt,"@")) = "loadmenu"         then v_line_prev[30] = xcode_value .





                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[31] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[32] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[33] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[34] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[35] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[36] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[37] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[38] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[39] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[40] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[41] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[42] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[43] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[44] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[45] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[46] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[47] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[48] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[49] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[50] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[51] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[52] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[53] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[54] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[55] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[56] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[57] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[58] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[59] = xcode_value .
                         /*Ԥ��ָ��*/    if trim(entry(2,xcode_cmmt,"@")) = "xs            .p" then v_line_prev[60] = xcode_value .                         

    end.
end. /*for each xcode_mstr*/


