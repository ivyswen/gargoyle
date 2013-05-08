#!/usr/bin/haserl
<?
	# This program is copyright 漏 2008-2011 Eric Bishop and is distributed under the terms of the GNU GPL 
	# version 2.0 with a special clarification/exception that permits adapting the program to
	# configure proprietary "back end" software provided that all modifications to the web interface
	# itself remain covered by the GPL.
	# See http://gargoyle-router.com/faq.html#qfoss for more information
	eval $( gargoyle_session_validator -c "$COOKIE_hash" -e "$COOKIE_exp" -a "$HTTP_USER_AGENT" -i "$REMOTE_ADDR" -r "login.sh" -t $(uci get gargoyle.global.session_timeout) -b "$COOKIE_browser_time"  )
	gargoyle_header_footer -h -s "system" -p "usb_storage" -c "internal.css" -j "table.js usb_storage.js" gargoyle network firewall nfsd samba vsftpd share_users

?>

<script>
<!--
<?
	echo "var driveSizes = [];"

	echo "var storageDrives = [];"
	awk '{ print "storageDrives.push([\""$1"\",\""$2"\",\""$3"\",\""$4"\", \""$5"\"]);" }' /tmp/mounted_usb_storage.tab 2>/dev/null

	echo "var physicalDrives = [];"

	#note that drivesWithNoMounts, refers to drives 
	# with no mounts on the OS, not lack of network mounts
	echo "var drivesWithNoMounts = [];"

	#ugly one-liner
	#unmounted_drives=$( drives=$(cat /tmp/drives_found.txt | grep "dev" | sed 's/[0-9]:.*$//g' | uniq) ; for d in $drives ; do mounted=$(cat /proc/mounts | awk '$1 ~ /dev/ { print $1 }' | uniq |  grep "$d") ; if [ -z "$mounted" ] ; then echo "$d" ; fi  ; done )

	drives="$(awk  -F':' '$1 ~ /^\/dev\// { sub(/[0-9]+$/, "", $1); arr[$1]; } END { for (x in arr) { print x; } }' /tmp/drives_found.txt)"
	for d in ${drives}; do
		if awk -v devpath="^${d}[0-9]+" '$1 ~ devpath { is_mounted = "yes"} END { if (is_mounted == "yes") { exit 1; } }' /proc/mounts; then
			size=$(( 1024 * $(fdisk -s "$d") ))
			echo "drivesWithNoMounts.push( [ \"$d\", \"$size\" ] );"
		fi
	done
?>
//-->
</script>

<fieldset id="no_disks" style="display:none;">
	<legend class="sectionheader">USB存储</legend>
	<em><span class="nocolumn">未检测到USB磁盘</span></em>
</fieldset>

<fieldset id="shared_disks">
	<legend class="sectionheader">共享磁盘</legend>

	<div id='ftp_wan_access_container' >
		<span class="nocolumn">
			<input class="aligned_check" type='checkbox' id='ftp_wan_access' onclick='updateWanFtpVisibility()' />&nbsp;
			<label class="aligned_check_label" id='ftp_wan_access_label' for='ftp_wan_access'>允许从外网访问FTP</label>
		</span>
	</div>

	<div id='ftp_pasv_container' class="indent" >
		<span class="nocolumn">
			<input class="aligned_check" type='checkbox' id='ftp_wan_pasv' onclick='updateWanFtpVisibility()' />&nbsp;
			<label class="aligned_check_label" id='ftp_wan_access_label' for='ftp_wan_pasv'>允许从外网访问的FTP端口</label>&nbsp;
			<input type="text" size='7' maxLength='5' onkeyup='proofreadPort(this)' id='pasv_min_port'>&nbsp;-&nbsp;<input type="text" size='7' maxLength='5' onkeyup='proofreadPort(this)'  id='pasv_max_port'>
		</span>
	</div>

	<div id="ftp_wan_spacer" style="height:15px;"></div>

	<div id="cifs_workgroup_container" style="margin-bottom:20px;" >
		<label id="cifs_workgroup_label" class="leftcolumn" for="cifs_workgroup">CIFS 工作组:</label>
		<input id="cifs_workgroup" class="rightcolumn" type="text" size='30'/>
	</div>

	<div id="user_container">
		<label id="cifs_user_label" class="leftcolumn">CIFS / FTP 用户:</label>
		<span class="rightcolumnonly" id="user_container">
			<label id="user_label" for="new_user" style="float:left;width:120px;">新用户:</label>
			<input id="new_user" type="text" />
		</span>
	</div>
	<div class="rightcolumnonly" id="user_pass_container">
		<label id="user_pass_label" for="user_pass" style="float:left;width:120px;">密码:</label>
		<input id="user_pass" type="password" />
	</div>
	<div class="rightcolumnonly" id="user_pass_confirm_container">
		<label id="user_pass_confirm_label" for="user_pass_confirm" style="float:left;width:120px;">确认密码:</label>
		<input id="user_pass_confirm" type="password" />
	</div>
	<div class="rightcolumnonly" id="user_pass_container">
		<input id="add_user" type="button"  class="default_button" value="添加用户" onclick="addUser()" style="margin-left:0px;" />
	</div>

	<div class="rightcolumnonly" style="margin-bottom:20px;" id="user_table_container">
	</div>

	<div id="sharing_add_heading_container">
		<span class="nocolumn" style="text-decoration:underline;">添加共享磁盘/目录:</span>
	</div>
	<div id="sharing_add_controls_container" class="indent">
		<? cat templates/usb_storage_template ?>
		<div>
			<input type="button" id="add_share_button" class="default_button" value="添加共享磁盘" onclick="addNewShare()" />
		</div>
	</div>
	<div class="internal_divider"></div>
	<div id="sharing_current_heading_container">
		<span class="nocolumn" style="text-decoration:underline;">当前共享磁盘:</span>
	</div>
	<div id="sharing_mount_table_container">
	</div>

	<div class="internal_divider"></div>

	<input type='button' value='保存设置' id="save_button" class="bottom_button" onclick='saveChanges()' />
	<input type='button' value='重设' id="reset_button" class="bottom_button" onclick='resetData()'/>
</fieldset>

<fieldset id="disk_unmount">
	<legend class="sectionheader">卸载</legend>
	<div>
		<span class="leftcolumn"  style="margin-bottom:60px;margin-left:0px;"><input type='button' value="卸载所有USB磁盘" id="unmount_usb_button" class="default_button" onclick="unmountAllUsb()"></span>
		<span class="rightcolumn"><em>拔出USB磁盘之前应该先卸载磁盘.<br> USB磁盘将在路由器重启后自动安装.</em></span>
	</div>
</fieldset>

<fieldset id="disk_format">
	<legend class="sectionheader">格式化磁盘</legend>

	<div id="no_unmounted_drives">
		<em><span class="nocolumn"><p>未检测到磁盘.</p><p>您必须先卸载,再尝试格式化磁盘.</p></span></em>
	</div>

	<div id="format_warning">
		<em><span class="nocolumn">警告: 格式化磁盘将永久清除磁盘内的所有内容.<p>磁盘将被格式化为EXT4文件系统<br/>EXT4格式可能无法在Windows/Mac系统上读取</p></span></em>
	</div>

	<div id="format_disk_select_container">
		<label id="format_disk_select_label" class="leftcolumn">待格式化磁盘:</label>
		<select class="rightcolumn" id="format_disk_select" ></select>
		<br/>
		<span id="format_warning" class="right_column_only"></span>
	</div>
	<div id="swap_percent_container">
		<label class="leftcolumn" id="swap_percent_label" for="swap_percent" >交换容量:</label>
		<span  class="rightcolumn"><input id="swap_percent" type="text" onkeyup="updateFormatPercentages(this.id)" /></span>%&nbsp;&nbsp;<em><span id="swap_size"></span></em>
	</div>
	<div id="storage_percent_container">
		<label class="leftcolumn" id="storage_percent_label" for="storage_percent" >存储容量:</label>
		<span  class="rightcolumn"><input id="storage_percent" type="text" onkeyup="updateFormatPercentages(this.id)" /></span>%&nbsp;&nbsp;<em><span id="storage_size"></span></em>
	</div>
	<div id="usb_format_button_container">
		<span class="leftcolumn" style="margin-left:0px;" ><input type="button" value="立即格式化" id="usb_format_button" class="default_button" onclick="formatDiskRequested()" /></span>
	</div>
</fieldset>

<!-- <br /><textarea style="margin-left:20px;" rows=30 cols=60 id='output'></textarea> -->

<script>
<!--
	resetData();
//-->
</script>

<?
	gargoyle_header_footer -f -s "system" -p "usb_storage"
?>
