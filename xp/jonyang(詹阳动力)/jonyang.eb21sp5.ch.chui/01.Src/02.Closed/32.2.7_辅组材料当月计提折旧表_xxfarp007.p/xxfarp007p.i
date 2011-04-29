/*xxfarp007p.i 多次调用,输出报表数据,列数固定*/
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100526.1  By: Roger Xiao */
/* SS - 110318.1  By: Roger Xiao */  /* begins {&sub01}  begins {&sub03}  */


v_put = 0 .
v_amt = 0 .
for each temp1 where {&where} break by t1_ctr :
    if first-of(t1_ctr) then do:
        v_put = 0 .
        v_amt = 0 .
        find first cc_mstr where cc_domain = global_domain and cc_ctr = t1_ctr no-lock no-error .
        v_name = if avail cc_mstr then cc_desc else t1_ctr .
    end.

    /*******各列赋值-begin*****/
    v_amt = v_amt + t1_amt .
    if t1_sub begins {&sub01} then v_put[01] = v_put[01] + t1_amt. 
    if t1_sub begins {&sub03} then v_put[03] = v_put[03] + t1_amt.

    if t1_sub = {&sub02} then v_put[02] = v_put[02] + t1_amt. 
    if t1_sub = {&sub04} then v_put[04] = v_put[04] + t1_amt.
    if t1_sub = {&sub05} then v_put[05] = v_put[05] + t1_amt.
    if t1_sub = {&sub06} then v_put[06] = v_put[06] + t1_amt.
    if t1_sub = {&sub07} then v_put[07] = v_put[07] + t1_amt.
    if t1_sub = {&sub08} then v_put[08] = v_put[08] + t1_amt.
    if t1_sub = {&sub09} then v_put[09] = v_put[09] + t1_amt.
    if t1_sub = {&sub10} then v_put[10] = v_put[10] + t1_amt.
    if t1_sub = {&sub11} then v_put[11] = v_put[11] + t1_amt.
    if t1_sub = {&sub12} then v_put[12] = v_put[12] + t1_amt.
    if t1_sub = {&sub13} then v_put[13] = v_put[13] + t1_amt.

    /*******各列赋值-end*****/
    												


    if last-of(t1_ctr) then do:
        export  delimiter ";"
                t1_ctr  
                v_amt
                v_put[01]
                v_put[02]  /*留空*/
                v_put[03]
                v_put[04]  /*留空*/
                v_put[05]  /*留空*/
                v_put[06]  /*留空*/
                v_put[07]  /*留空*/
                v_put[08]  /*留空*/
                v_put[09]  /*留空*/
                v_put[10]  /*留空*/
                v_put[11]  /*留空*/
                v_put[12]  /*留空*/
                v_put[13]  /*留空*/
                l-yrper
                .
    end.
end. /*for each temp1*/

