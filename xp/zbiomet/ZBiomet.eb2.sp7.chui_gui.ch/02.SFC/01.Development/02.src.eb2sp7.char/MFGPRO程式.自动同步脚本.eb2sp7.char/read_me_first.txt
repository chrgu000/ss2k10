2009-02-24 Roger:

�߼�------------------------------:
1.�Զ������ű�(/mfgeb2/eb2/sfc_db/sfc-db-sync01-prod),
2.�ű���ʹ��(/mfgeb2/eb2/sfc_db/sfc-db-sync01-prod.p)���Զ�ͬ������
2.��ʽ��ʹ��(/mfgeb2/eb2/sfc_db/sfc-db-sync01-prod.input)��Ϊinput�ļ�,cimload��ʽ��¼mfgpro(mf.p),
3.��������(/mfgeb2/eb2/sfc_db/sfc-db-sync01-prod.output)

4.��ʽ��/���Կ�ֱ��Ӧ�ļ� **-prod / **-test



���÷�ʽ-------------------------:

�Զ�����SFCDBͬ��
1.��������:service crond start
2.����ų�:crontab -e 
3.��ʾ���ų�:crontab -l

����ո�ָ�,������

�� ʱ ��  ��  �� ִ�е���
15 17 *   *   *   /mfgeb2/eb2/sfc_db/sfc-db-sync01-prod
15 18 *   *   *   /mfgeb2/eb2/sfc_db/sfc-db-sync01-test