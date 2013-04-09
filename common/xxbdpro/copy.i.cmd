set src="c:\ss\trunk\common"
copy %src%\bbi\xxand.i %src%\xxbdpro\
copy %src%\bbi\xxqaddom.i %src%\xxbdpro\
copy %src%\bbi\xxusrwdom.i %src%\xxbdpro\
copy %src%\bbi\xxbdldom.i %src%\xxbdpro\
copy %src%\bbi\xxbdlddom.i %src%\xxbdpro\
echo /*xxmfnsq.i xxbdld.p includ file for eb21                                    */> xxmfnsq.i
echo /*V8:ConvertMode=Maintenance                                                 */>> xxmfnsq.i
@echo.>>xxmfnsq.i
echo {mfnxtsq1.i " {xxbdldom.i} {xxand.i} bdl_source = '' and">>xxmfnsq.i
echo                 bdl_mstr>>xxmfnsq.i
echo                 bdl_id>>xxmfnsq.i
echo                 mf_sq04>>xxmfnsq.i
echo                 next_id}>>xxmfnsq.i