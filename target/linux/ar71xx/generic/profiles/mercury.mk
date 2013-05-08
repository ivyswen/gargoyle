#
# Copyright (C) 2009 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# routers from Mercury (a sub-company of TP-LINK)


define Profile/MCMW4530R
	NAME:=Mercury MW4530R
	PACKAGES:=kmod-usb2 kmod-ledtrig-usbdev
endef

define Profile/MCMW4530R/Description
	Package set optimized for the Mercury MW4530R.
endef
$(eval $(call Profile,MCMW4530R))

