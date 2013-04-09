cd /d c:\ss\trunk\common\xxbdpro
echo /*V8:ConvertMode=Maintenance                                                 */> xxand.i
echo /*V8:ConvertMode=Maintenance                                                 */> xxqaddom.i
echo /*V8:ConvertMode=Maintenance                                                 */> xxusrwdom.i
echo /*V8:ConvertMode=Maintenance                                                 */> xxbdldom.i
echo /*V8:ConvertMode=Maintenance                                                 */> xxbdlddom.i
echo /*xxmfnsq.i xxbdld.p includ file for eb2                                     */> xxmfnsq.i
echo /*V8:ConvertMode=Maintenance                                                 */>> xxmfnsq.i
@echo.>>xxmfnsq.i
echo {mfnxtsq1.i bdl_mstr >>xxmfnsq.i
echo             "bdl_source = '' and bdl_id" >>xxmfnsq.i
echo             mf_sq04 >>xxmfnsq.i
echo             next_id} >>xxmfnsq.i