#
# Copyright (C) 2011-2013 Entware
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=dnscrypt-proxy
PKG_VERSION:=1.3.0
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://download.dnscrypt.org/dnscrypt-proxy/
PKG_MD5SUM:=34ac17be24f64446599420e159cf794a

PKG_INSTALL:=1
PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/package.mk

define Package/dnscrypt-proxy/Default
	SECTION:=net
	CATEGORY:=Network
	SUBMENU:=IP Addresses and Names
	TITLE:=A tool for securing communications between a client and a DNS resolver
	URL:=http://www.opendns.com/technology/dnscrypt
	MAINTAINER:=Entware team, wl500g-repo.googlecode.com
endef

define Package/dnscrypt-proxy
	$(call Package/dnscrypt-proxy/Default)
endef

define Package/dnscrypt-proxy-hostip
	$(call Package/dnscrypt-proxy/Default)
	TITLE+= (a resolver before dnscrypt-proxy start)
endef

define Package/dnscrypt-proxy/description
 dnscrypt-proxy is a slight variation on DNSCurve.
 DNSCurve improves the confidentiality and integrity of DNS requests using
 high-speed high-security elliptic-curve cryptography. Best of all, DNSCurve
 has very low overhead and adds virtually no latency to queries.
endef

define Package/dnscrypt-proxy-hostip/description
 A tool for resolving a name before dnscrypt-proxy. It should help fighting
 the chicken-and-egg issue seen on routers, where dnscrypt-proxy requires
 a working NTP server, but the NTP server requires a working resolver.
endef

CONFIGURE_ARGS += \
	--disable-ssp

TARGET_CFLAGS += \
	-std=gnu99 \
	-fPIC

define Package/dnscrypt-proxy/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/dnscrypt-proxy $(1)/usr/sbin
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/dnscrypt-proxy.init $(1)/etc/init.d/dnscrypt-proxy
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/dnscrypt-proxy.config $(1)/etc/config/dnscrypt-proxy
endef

define Package/dnscrypt-proxy-hostip/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/hostip $(1)/usr/sbin/dnscrypt-proxy-hostip
endef

$(eval $(call BuildPackage,dnscrypt-proxy))
$(eval $(call BuildPackage,dnscrypt-proxy-hostip))
