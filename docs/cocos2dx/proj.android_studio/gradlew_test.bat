@echo off

set "JAVA_HOME=C:\Program Files\Android\Android Studio\jbr"
::ʵ�ʲ���Ҫ Ϊ��java�汾һ�� ��ͬ������
set "path=C:\Program Files\Android\Android Studio\jbr\bin;%path%"

where java
call gradlew tasks

pause

