#石像鬼路由固件 [Gargoyle-Router](http://gargoyle-router.com)

![gargoyle](https://secure.gravatar.com/avatar/bb56a0491ab33229aeca30b5c4bfc65a?s=420&d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-org-420.png)

Gargoyle（石像鬼）是一个为常用的小型路由器开发的固件，它比原厂固件提供更先进的服务质量和带宽监测工具。

基于GPL，提供完整的全套路由功能，强悍的流量监控，带宽管理和QoS功能。

---

##Gargoyle for HG255D
* 此repo是针对hg255d路由器的石像鬼路由固件源代码。
* 基于[ivyswen](https://github.com/ivyswen/gargoyle)源码。
* 基于[shenrui01](https://github.com/shenrui01/attitude_adjustment)源码。
* 集成官方各种[增强补丁](http://patchwork.openwrt.org/)。
* 集成上游Linux各种[增强补丁](http://patchwork.kernel.org/)。
* 欢迎各位fork及pull request。

---

##ChangeLog

---

###2013-5-16

1.更新gargoyle包到最新的git分支。

---

###2013-5-17

1.解决make menuconfig时有些包重复的问题。

2.修正石像鬼web界面model显示错误。

---

###2013-5-19

1.解决openssl-util缺乏libpthread库依赖错误。

2.默认使用dnscrypt-proxy。

3.修改路由器默认时区为Asia/Shanghai。

---

###2013-5-23

1.dev分支同步到石像鬼官方1.5.10版本。
2.dev分支完成shenrui01改进移植。
