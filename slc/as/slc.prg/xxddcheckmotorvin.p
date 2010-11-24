/* Creation: eB21SP3 Chui Last Modified: 20080107 By: Davild Xu *ss-20071228.1*/
/*自动下线程序*/
{mfdtitle.i "SS"}
/* xxbcup.p 调用
{gprun.i ""xxddcheckmotorvin.p""
	"(input motorvin,
	output cimError)"}
	*/
DEFINE input  parameter motorvin like xxsovd_id .
DEFINE output parameter cimError as logi .
pause 0 .
cimError = no .
find first xxvind_det where xxvind_domain = global_domain 
		and xxvind_motor_id = motorvin no-error.
if avail xxvind_det then do :
	assign cimError = yes .
end.