/* xxinvld.p - �չ���Ʊ���룬������ʾ����                                    */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 24YP LAST MODIFIED: 04/24/12 BY: zy expand xrc length to 120    */
/* REVISION END                                                              */

define {1} shared variable flhload as character format "x(70)".
define {1} shared temp-table tmpinv
       fields tiv_vend like vd_addr
       fields tiv_ivnbr as character
       fields tiv_tax as character
       fields tiv_ctrnbr as character
       fields tiv_line like pod_line
       fields tiv_draw like pt_draw
       fields tiv_tray as character
       fields tiv_qty as decimal
       fields tiv_type as character
       fields tiv_chk  as character format "x(20)".
