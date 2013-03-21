/* 得到金税代码*/
{mfdeclre.i}

  define input parameter cust as char.

  define output parameter gtcode as char.


  find first ad_mstr no-lock where ad_domain = global_domain and ad__chr01 = cust no-error.

  gtcode = if available ad_mstr then ad_addr else "".

