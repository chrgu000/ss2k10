/* xxglrp001a.p - xxglrp001.p的子程式,由一个gltr_ref的行找其他行的acct         */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100810.1  By: Roger Xiao */ 
/*-Revision end---------------------------------------------------------------*/


{mfdeclre.i}
{gplabel.i}


define input  parameter i-ref like gltr_ref  no-undo.
define input  parameter i-ln  like gltr_line no-undo .
define output parameter o-acc as char       no-undo.

define shared temp-table temp1 
    field t1_line    like gltr_line 
    field t1_acct    as char format "x(24)"
    field t1_addr    like gltr_addr
    field t1_batch   like gltr_batch    
    field t1_doc_typ like gltr_doc_typ  
    field t1_doc     like gltr_doc 
    field t1_amt     like gltr_amt
    field t1_curramt like gltr_curramt
    field t1_flag    as logical 
    .

empty temp-table temp1 .

o-acc = "" .
for each gltr_hist
    use-index gltr_ref
    where gltr_domain = global_domain  
    and gltr_ref = i-ref 
    and gltr_line <> i-ln 
no-lock:
    if o-acc = "" then o-acc = gltr_acc + "-" + gltr_sub + "-" + gltr_ctr .
    else               o-acc = gltr_acc + "-" + gltr_sub + "-" + gltr_ctr + "," + o-acc .

    find first temp1
        where t1_line = gltr_line
        and   t1_acct = gltr_acc + "-" + gltr_sub + "-" + gltr_ctr 
    no-error.
    if not avail temp1 then do:
        create temp1 .
        assign t1_acct    = gltr_acc + "-" + gltr_sub + "-" + gltr_ctr 
               t1_line    = gltr_line
               t1_addr    = gltr_addr 
               t1_batch   = gltr_batch   
               t1_doc_typ = gltr_doc_typ  
               t1_doc     = gltr_doc      
               t1_amt     = gltr_amt    
               t1_curramt = gltr_curramt 
               t1_flag    = (  (gltr_amt >= 0 and gltr_correction = no)
                            or (gltr_amt < 0  and gltr_correction = yes))
               .
    end.
end.
