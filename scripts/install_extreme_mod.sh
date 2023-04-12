#!/bin/bash

set -e

patch_java_runtime()
{
  echo "--patch-module=java.base=ghostfucker_utils.jar" >>$1
  echo "--add-exports=java.base/sun.net.www.protocol=ALL-UNNAMED" >>$1
  echo "--add-exports=java.base/sun.net.www.protocol.http=ALL-UNNAMED" >>$1
  echo "--add-exports=java.base/sun.net.www.protocol.https=ALL-UNNAMED" >>$1
  echo "--add-opens=java.base/java.net=ALL-UNNAMED" >>$1
  echo "-Dorg.glassfish.jaxb.runtime.v2.bytecode.ClassTailor.noOptimize=true" >>$1
  echo >>$1
}

# Install Extreme Mod
cd /opt/biglybt
unzip -o /app/ExtremeMod-3.3.0.0.zip

# Adjust JavaVM runtime @ ${HOME}/.biglybt/java.vmoptions
patch_java_runtime "${HOME}/.biglybt/java.vmoptions"

# Adjust JavaVM runtime @ /opt/biglybt/java.vmoptions
patch_java_runtime "/opt/biglybt/java.vmoptions"

# Install extra plugins
cd plugins
( mkdir xmwebui; cd xmwebui; unzip /app/plugins/xmwebui_1.0.9.zip )
( mkdir aznettor; cd aznettor; unzip /app/plugins/aznettor-linux_1.2.8.zip )
( mkdir azneti2phelper; cd azneti2phelper; unzip /app/plugins/azneti2phelper-linux_2.0.0.2.2.zip )
