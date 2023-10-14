#!/bin/bash

bail()
{
  ERRMSG="FAILED: $1"
  >&2 echo "${ERRMSG}"
  xmessage "${ERRMSG}" &
  exit 1
}

set -e

# Extreme Mod 3.4.0.0 requires Java 21
BBTJAVAVERS=21
DEBIAN_FRONTEND="noninteractive"
BBTINSTSCR="/tmp/BiglyBT_Installer.sh"

if [ "${BBTGUIINSTALL}" == "1" ]; then
  OPENJDKPKG="openjdk-${BBTJAVAVERS}-jre"
  unset BBTQUIET
else
  OPENJDKPKG="openjdk-${BBTJAVAVERS}-jre-headless"
  BBTQUIET="-q"
fi

# Add Java PPA (thanks to V3semir)
apt-get update
apt-get install -y software-properties-common
add-apt-repository -y ppa:openjdk-r/ppa

# Install Java
apt-get update
apt-get install -y --no-install-recommends ${OPENJDKPKG} webkit2gtk-driver libjna-java unzip \
    fonts-arphic-ukai fonts-arphic-uming fonts-ipafont-mincho fonts-ipafont-gothic fonts-unfonts-core
if grep -q '^assistive_technologies' /etc/java-${BBTJAVAVERS}-openjdk/accessibility.properties; then
  sed -e 's/^assistive_technologies/#assistive_technologies/' -i /etc/java-${BBTJAVAVERS}-openjdk/accessibility.properties
fi

# Download BiglyBT (if not provided locally)
if [ -x /app/BiglyBT_Installer.sh ]; then
  echo "Installing /app/BiglyBT_Installer.sh ..."
  cp -v /app/BiglyBT_Installer.sh ${BBTINSTSCR}
else
  wget https://files.biglybt.com/installer/BiglyBT_Installer.sh -O ${BBTINSTSCR}
  chmod +x ${BBTINSTSCR}
fi

# Install BiglyBT
chown ${SUDO_UID}:${SUDO_GID} /opt
sudo -u ${SUDO_USER} app_java_home="/usr/lib/jvm/java-${BBTJAVAVERS}-openjdk-amd64/" ${BBTINSTSCR} ${BBTQUIET} -dir /opt/biglybt
rm ${BBTINSTSCR}
sudo -u ${SUDO_USER} /app/scripts/install_extreme_mod.sh || bail "FAILED: /app/scripts/install_extreme_mod.sh"
