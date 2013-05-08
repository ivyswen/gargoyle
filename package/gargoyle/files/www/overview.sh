#!/usr/bin/haserl
<?
	# This program is copyright © 2008-2011 Eric Bishop and is distributed under the terms of the GNU GPL
	# version 2.0 with a special clarification/exception that permits adapting the program to
	# configure proprietary "back end" software provided that all modifications to the web interface
	# itself remain covered by the GPL.
	# See http://gargoyle-router.com/faq.html#qfoss for more information

	eval $( gargoyle_session_validator -c "$COOKIE_hash" -e "$COOKIE_exp" -a "$HTTP_USER_AGENT" -i "$REMOTE_ADDR" -r "login.sh" -t $(uci get gargoyle.global.session_timeout) -b "$COOKIE_browser_time"  )
	gargoyle_header_footer -h -s "status" -p "overview" -c "internal.css" -j "overview.js table.js" -i network wireless qos_gargoyle system
?>

<script>
<!--
<?

	uptime=$(cat /proc/uptime)
	echo "uptime = \"$uptime\";"

	if [ -h /etc/rc.d/S50qos_gargoyle ] ; then
		echo "var qosEnabled = true;"
	else
		echo "var qosEnabled = false;"
	fi

	gargoyle_version=$(cat data/gargoyle_version.txt)
	echo "var gargoyleVersion=\"$gargoyle_version\""

	dateformat=$(uci get gargoyle.global.dateformat 2>/dev/null)
	if [ "$dateformat" == "iso" ]; then
		current_time=$(date "+%Y/%m/%d %H:%M %Z")
	elif [ "$dateformat" == "iso8601" ]; then
		current_time=$(date "+%Y-%m-%d %H:%M %Z")
	elif [ "$dateformat" == "australia" ]; then
		current_time=$(date "+%d/%m/%y %H:%M %Z")
	elif [ "$dateformat" == "russia" ]; then
		current_time=$(date "+%d.%m.%Y %H:%M %Z")
	elif [ "$dateformat" == "argentina" ]; then
		current_time=$(date "+%d/%m/%Y %H:%M %Z")
	else
		current_time=$(date "+%D %H:%M %Z")
	fi
	timezone_is_utc=$(uci get system.@system[0].timezone | grep "^UTC" | sed 's/UTC//g')
	if [ -n "$timezone_is_utc" ] ; then
		current_time=$(echo $current_time | sed "s/UTC/UTC-$timezone_is_utc/g" | sed 's/\-\-/+/g')
	fi
	echo "var currentTime = \"$current_time\";"

	total_mem="$(sed -e '/^MemTotal: /!d; s#MemTotal: *##; s# kB##g' /proc/meminfo)"
	buffers_mem="$(sed -e '/^Buffers: /!d; s#Buffers: *##; s# kB##g' /proc/meminfo)"
	cached_mem="$(sed -e '/^Cached: /!d; s#Cached: *##; s# kB##g' /proc/meminfo)"
	free_mem="$(sed -e '/^MemFree: /!d; s#MemFree: *##; s# kB##g' /proc/meminfo)"
	free_mem="$(( ${free_mem} + ${buffers_mem} + ${cached_mem} ))"
	echo "var totalMemory=parseInt($total_mem);"
	echo "var freeMemory=parseInt($free_mem);"

	total_swap="$(sed -e '/^SwapTotal: /!d; s#SwapTotal: *##; s# kB##g' /proc/meminfo)"
	cached_swap="$(sed -e '/^SwapCached: /!d; s#SwapCached: *##; s# kB##g' /proc/meminfo)"
	free_swap="$(sed -e '/^SwapFree: /!d; s#SwapFree: *##; s# kB##g' /proc/meminfo)"
	free_swap="$(( ${free_swap} + ${cached_swap} ))"
	echo "var totalSwap=parseInt($total_swap);"
	echo "var freeSwap=parseInt($free_swap);"

	load_avg="$(awk '{print $1 " / " $2 " / " $3}' /proc/loadavg)"
	echo "var loadAvg=\"$load_avg\";"

	curconn="$(wc -l < /proc/net/nf_conntrack)"
	maxconn=$(cat /proc/sys/net/netfilter/nf_conntrack_max 2>/dev/null)
	if [ -z "$maxconn" ] ; then
		maxconn="4096"
	fi
	echo "var curConn=\"$curconn\";"
	echo "var maxConn=\"$maxconn\";"

	if [ -e /tmp/sysinfo/model ]; then
		echo "var model=\""$(cat /tmp/sysinfo/model)"\";"
	else
		echo "var model=\"Unknown\";"
	fi

	lan_ip=$(/sbin/uci get network.lan.ipaddr 2>/dev/null)
	if [ -n "$lan_ip" ] ; then
		echo "var wanDns=\""$(sed -e '/nameserver/!d; s#nameserver ##g' /tmp/resolv.conf.auto | sort | uniq | grep -v "$lan_ip" )"\";"
	else
		echo "var wanDns=\""$(sed -e '/nameserver/!d; s#nameserver ##g' /tmp/resolv.conf.auto | sort | uniq )"\";"
	fi

	echo "var ports = new Array();"
	/usr/lib/gargoyle/switchinfo.sh

	echo "var wifi_status = new Array();"
	iwconfig 2>&1 | grep -v 'wireless' | sed '/^$/d' | awk -F'\n' '{print "wifi_status.push(\""$0"\");" }'
?>
//-->
</script>

<fieldset>
	<legend class="sectionheader">状态</legend>

	<div id="device_container">
		<div>
			<span class='leftcolumn'>设备名称:</span><span id="device_name" class='rightcolumn'></span>
		</div>
		<div>
			<span class='leftcolumn'>石像鬼版本:</span><span id="gargoyle_version" class='rightcolumn'></span>
		</div>
		<div>
			<span class='leftcolumn'>型号:</span><span id="device_model" class='rightcolumn'></span>
		</div>
		<div>
			<span class='leftcolumn'>设备配置:</span><span id="device_config" class='rightcolumn'></span>
		</div>
		<div>
			<span class='leftcolumn'>内存使用率:</span><span id="memory" class='rightcolumn'></span>
		</div>
		<div id="swap_container">
			<span class='leftcolumn'>交换内存使用率:</span><span id="swap" class='rightcolumn'></span>
		</div>

		<div>
			<span class='leftcolumn'>连接数:</span><span id="connections" class='rightcolumn'></span>
		</div>
		<div>
 			<span class='leftcolumn'>CPU平均负载:</span><span id="load_avg" class='rightcolumn'></span><span>&nbsp;&nbsp;(1/5/15 分钟)</span>
		</div>
		<div class="internal_divider"></div>
	</div>

	<div id="time_container">
		<div>
			<span class='leftcolumn'>运行时间:</span><span id="uptime" class='rightcolumn'></span>
		</div>
		<div>
			<span class='leftcolumn'>当前日期 &amp; 时间:</span><span id="current_time" class='rightcolumn'></span>
		</div>
		<div class="internal_divider"></div>
	</div>

	<div id="bridge_container">
		<div>
			<span class='leftcolumn'>网桥 IP地址:</span><span id="bridge_ip" class='rightcolumn'></span>
		</div>
		<div>
			<span class='leftcolumn'>网桥 子网掩码:</span><span id="bridge_mask" class='rightcolumn'></span>
		</div>
		<div>
			<span class='leftcolumn'>网桥 MAC地址:</span><span id="bridge_mac" class='rightcolumn'></span>
		</div>
		<div>
			<span class='leftcolumn'>LAN 网关IP:</span><span id="bridge_gateway" class='rightcolumn'></span>
		</div>
		<div>
			<span class='leftcolumn'>网桥 连接方式:</span><span id="bridge_mode" class='rightcolumn'></span>
		</div>
		<div>
			<span class='leftcolumn'>网桥 SSID:</span><span id="bridge_ssid" class='rightcolumn'></span>
		</div>
		<div class="internal_divider"></div>
	</div>

	<div id="lan_container">
		<div>
			<span class='leftcolumn'>LAN IP地址:</span><span id="lan_ip" class='rightcolumn'></span>
		</div>
		<div>
			<span class='leftcolumn'>LAN 子网掩码:</span><span id="lan_mask" class='rightcolumn'></span>
		</div>
		<div>
			<span class='leftcolumn'>LAN MAC地址:</span><span id="lan_mac" class='rightcolumn'></span>
		</div>
		<div>
			<span class="rightcolumnonly"><div id="ports_table_container"></div></span>
		</div>
		<div class="internal_divider"></div>
	</div>

	<div id="wan_container">
		<div>
			<span class='leftcolumn'>WAN IP地址:</span><span id="wan_ip" class='rightcolumn'></span>
		</div>
		<div>
			<span class='leftcolumn'>WAN 子网掩码:</span><span id="wan_mask" class='rightcolumn'></span>
		</div>
		<div>
			<span class='leftcolumn'>WAN MAC地址:</span><span id="wan_mac" class='rightcolumn'></span>
		</div>
		<div>
			<span class='leftcolumn'>WAN 网关IP:</span><span id="wan_gateway" class='rightcolumn'></span>
		</div>
		<div id="wan_dns_container">
			<span class='leftcolumn'>WAN DNS服务器:</span><span id="wan_dns" class='rightcolumn'></span>
		</div>
		<div id="wan_3g_container">
			<span class='leftcolumn'>信号强度:</span><span id="wan_3g" class='rightcolumn'>
<?
	if [ -e /tmp/strength.txt ]; then
		awk -F[,\ ] '/^\+CSQ:/ {if ($2>31) {C=0} else {C=$2}} END {if (C==0) {printf "(no data)"} else {printf "%d%%, %ddBm\n", C*100/31, C*2-113}}' /tmp/strength.txt
	fi
?>
			</span>
		</div>
		<div class="internal_divider"></div>
	</div>

	<div id="wifi_container">
		<div>
			<span class='leftcolumn'>无线 模式:</span><span id="wireless_mode" class='rightcolumn'></span>
		</div>
		<div id="wireless_mac_div">
			<span class='leftcolumn'>无线 MAC地址:</span><span id="wireless_mac" class='rightcolumn'></span>
		</div>
		<div id="wireless_apssid_div">
			<span class='leftcolumn' id="wireless_apssid_label">接入点 SSID:</span><span id="wireless_apssid" class='rightcolumn'></span>
		</div>
		<div id="wireless_apssid_5ghz_div">
			<span class='leftcolumn' id="wireless_apssid_5ghz_label">5GHz 接入点 SSID:</span><span id="wireless_apssid_5ghz" class='rightcolumn'></span>
		</div>
		<div id="wireless_otherssid_div">
			<span class='leftcolumn' id="wireless_otherssid_label">SSID 客户端加入:</span><span id="wireless_otherssid" class='rightcolumn'></span>
		</div>
		<div class="internal_divider"></div>
	</div>

	<div id="services_container">
		<div>
			<span class='leftcolumn'>QoS 上传:</span><span id="qos_upload" class='rightcolumn'></span>
		</div>
		<div>
			<span class='leftcolumn'>QoS 下载:</span><span id="qos_download" class='rightcolumn'></span>
		</div>
	</div>

</fieldset>

<script>
<!--
	resetData();
//-->
</script>

<?
	gargoyle_header_footer -f -s "status" -p "overview"
?>
