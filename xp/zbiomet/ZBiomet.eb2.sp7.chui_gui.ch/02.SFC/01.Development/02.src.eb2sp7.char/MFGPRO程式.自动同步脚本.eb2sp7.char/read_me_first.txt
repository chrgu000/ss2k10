2009-02-24 Roger:

逻辑------------------------------:
1.自动启动脚本(/mfgeb2/eb2/sfc_db/sfc-db-sync01-prod),
2.脚本中使用(/mfgeb2/eb2/sfc_db/sfc-db-sync01-prod.p)做自动同步动作
2.程式中使用(/mfgeb2/eb2/sfc_db/sfc-db-sync01-prod.input)作为input文件,cimload方式登录mfgpro(mf.p),
3.输出结果在(/mfgeb2/eb2/sfc_db/sfc-db-sync01-prod.output)

4.正式库/测试库分别对应文件 **-prod / **-test



设置方式-------------------------:

自动运行SFCDB同步
1.启动服务:service crond start
2.添加排程:crontab -e 
3.显示旧排程:crontab -l

各项空格分隔,如下例

分 时 日  月  周 执行档案
15 17 *   *   *   /mfgeb2/eb2/sfc_db/sfc-db-sync01-prod
15 18 *   *   *   /mfgeb2/eb2/sfc_db/sfc-db-sync01-test