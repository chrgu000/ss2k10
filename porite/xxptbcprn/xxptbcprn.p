
{mfdtitle.i "20110617.1 " }
{wbrp01.i}
DEFINE var part        like pt_part. 
DEFINE var mydate        like tr_date. 
DEFINE var mylog        as  logic . 
DEFINE var mylog1        as  logic . 
DEFINE var mycustpart    like cp_cust_part. 
DEFINE var myqty		     like wo_qty_ord. 
DEFINE var myweight		     like wo_qty_ord. 


form
  mydate      label "日期"     	colon 15   
  part      label "公司图号"  	colon 15   
  myqty		    label "数量"     	colon 55
  mycustpart  label "客户图号"  	colon 15
  myweight  label "每箱重量"   colon 55
  mylog  label "自动去尾数"  colon 15
  mylog1  label "全部打印"  colon 15
with frame a   side-labels width 80 attr-space.   
setFrameLabels(frame a:handle).     


{gplabel.i}
mydate = today.
mylog = yes.
mylog1 = yes.
repeat:
	mycustpart = "".
	myqty = 0.
	disp  mycustpart myqty with frame a.
  if c-application-mode <> "WEB" then do:
    update
        mydate      
        part
     with frame a.
    find first cp_mstr no-lock where cp_domain = global_domain and cp_part = part no-error.
    if avail cp_mstr then 
      mycustpart = cp_cust_part .
    else mycustpart = "".
    find first pt_mstr no-lock where pt_domain = global_domain and pt_part = part no-error.
    if avail pt_mstr then do:
      myqty = pt_ord_mult .
      myweight = pt_ship_wt.
    end.
    else do:
      message "物料不存在" .
      undo , retry.
    end.
    
    update
        myqty      
        mycustpart
	myweight
	mylog
	mylog1
     with frame a.
   end.
  {wbrp06.i &command = update &fields = " mydate       
                                          part       
                                          myqty        
                                          mycustpart   
					  mylog
					  mylog1
                                          " 
      &frm = "a"}
  if (c-application-mode <> "WEB") or
  (c-application-mode = "WEB" and
  (c-web-request begins "DATA")) then do:

     {mfquoter.i mydate        }
     {mfquoter.i part        }
     {mfquoter.i myqty         }
     {mfquoter.i mycustpart    }
     {mfquoter.i mylog    }
     {mfquoter.i mylog1    }
     
  end.
  
  hide frame a.
  
  { gprun.i ""xxptbcprn1.p""  "(
    input mydate           ,
    input part           ,
    input myqty 		       ,
    input myweight      ,
    input mycustpart  	   ,
    input mylog ,
    input mylog1
    )"}         
end. /* swloop1 */
{wbrp04.i &frame-spec = a}
