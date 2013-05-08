#!/usr/bin/haserl
<?
	# This program is copyright © 2008-2010 Eric Bishop and is distributed under the terms of the GNU GPL
	# version 2.0 with a special clarification/exception that permits adapting the program to
	# configure proprietary "back end" software provided that all modifications to the web interface
	# itself remain covered by the GPL.
	# See http://gargoyle-router.com/faq.html#qfoss for more information
	eval $( gargoyle_session_validator -c "$COOKIE_hash" -e "$COOKIE_exp" -a "$HTTP_USER_AGENT" -i "$REMOTE_ADDR" -r "login.sh" -t $(uci get gargoyle.global.session_timeout) -b "$COOKIE_browser_time"  )
	gargoyle_header_footer -h -s "status" -p "webmon" -c "internal.css" -j "webmon.js table.js" -n webmon_gargoyle gargoyle
?>

<script>
<!--
<?
	webmon_enabled=$(ls /etc/rc.d/*webmon_gargoyle* 2>/dev/null)
	if [ -n "$webmon_enabled" ] ; then
		echo "var webmonEnabled=true;"
	else
		echo "var webmonEnabled=false;"
	fi

?>
//-->
</script>

<form>
	<fieldset>
		<legend class="sectionheader">网站监视器首选项</legend>
		<div>
			<input type='checkbox' id='webmon_enabled' onclick="setWebmonEnabled()" />
			<label id='webmon_enabled_label' for='webmon_enabled'>启用网站监视器</label>
		</div>
		<div class="indent">
			<div>
				<label class='leftcolumn' for='num_domains' id='num_domains_label'>访问地址保存数量:</label>
				<input type='text' class='rightcolumn' id='num_domains' onkeyup='proofreadNumericRange(this,1,9999)' size='6' maxlength='4' />
			</div>
			<div>
				<label class='leftcolumn' for='num_searches' id='num_searches_label'>搜索请求保存数量:</label>
				<input type='text' class='rightcolumn' id='num_searches' onkeyup='proofreadNumericRange(this,1,9999)' size='6' maxlength='4' />
			</div>
			<div>
				<select id="include_exclude" onchange="setIncludeExclude()">
					<option value="all">监视所有主机</option>
					<option value="include">仅监视下列主机</option>
					<option value="exclude">监视排除下列以外的主机</option>
				</select>
			</div>
			<div class='indent' id="add_ip_container">
				<div>
					<input type='text' id='add_ip' onkeyup='proofreadMultipleIps(this)' size='30' />
					<input type="button" class="default_button" id="add_ip_button" value="添加" onclick="addAddressesToTable(document, 'add_ip', 'ip_table_container', 'ip_table', false, 3, 1, 250)" />
					<br/>
					<em>指定一个IP或IP范围</em>
				</div>
				<div id="ip_table_container"></div>
			</div>
		</div>

		<div class="internal_divider"></div>

		<div id="bottom_button_container">
			<input type='button' value='保存设置' id="save_button" class="default_button" onclick='saveChanges()' />
			<input type='button' value='重设' id="reset_button" class="default_button" onclick='resetData()'/>
			<input type='button' value='清空历史记录' id="clear_history" class="default_button" onclick='clearHistory()'/>
		</div>
	</fieldset>
	<fieldset>
		<legend class="sectionheader">最近访问地址</legend>
		<div>
			<select id="domain_host_display" onchange="updateMonitorTable()">
				<option value="hostname">显示主机名</option>
				<option value="ip">显示主机IP</option>
			</select>
		</div>

		<div id="webmon_domain_table_container"></div>
	</fieldset>

	<fieldset>
		<legend class="sectionheader">最近搜索请求</legend>
		<div>
			<select id="search_host_display" onchange="updateMonitorTable()">
				<option value="hostname">显示主机名</option>
				<option value="ip">显示主机IP</option>
			</select>
		</div>

		<div id="webmon_search_table_container"></div>
	</fieldset>

	<fieldset id="download_web_usage_data" >
		<legend class="sectionheader">导出监视统计数据</legend>
		<div>
			<span style='text-decoration:underline'>数据使用逗号分隔:</span>
			<br/>
			<em>[最后访问时间],[本地 IP],[域名访问/搜索请求]</em>
			<br/>
		</div>
		<div>
			<center>
				<input type='button' id='download_domain_button' class='big_button' value='导出访问地址' onclick='window.location="webmon_domains.csv";' />
				&nbsp;&nbsp;
				<input type='button' id='download_search_button' class='big_button' value='导出搜索请求' onclick='window.location="webmon_searches.csv";' />
			</center>
		</div>
	</fieldset>
</form>

<!-- <br /><textarea style="margin-left:20px;" rows=30 cols=60 id='output'></textarea> -->

<script>
<!--
	resetData();
//-->
</script>

<?
	gargoyle_header_footer -f -s "status" -p "webmon"
?>
