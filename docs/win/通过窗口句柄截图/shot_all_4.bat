@echo off

::bug ��Ҫbat�ö� ���ܽ�Ŀ�괰���ö��� ���ǵ�һ��ִ�оͱ���һ�����ڸ����� ���º����Ĵ���û���ö�
::  ���Ե��ε��� �� ����ķ�ʽ ͨ�����Լ� ������Ļ����

pushd %~dp0
:: 0:΢�� 1:���� 2:QQ 3:�Ա�
powershell %~dp0screenshot4.ps1 wx "��΢�ſ����߹��� Stable v1.06.2206090��"
timeout /T 3 /NOBREAK

powershell %~dp0screenshot4.ps1 dy "���������߹���ǰ�ù���ҳ"
timeout /T 3 /NOBREAK

powershell %~dp0screenshot4.ps1 qq "QQС���򿪷��߹���"
timeout /T 3 /NOBREAK

powershell %~dp0screenshot4.ps1 tb "�Ա������߹���" "mini_taobao"
timeout /T 3 /NOBREAK

popd