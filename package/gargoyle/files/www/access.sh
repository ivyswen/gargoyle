#!/usr/bin/haserl
<?
	# This program is copyright ?2008 Eric Bishop and is distributed under the terms of the GNU GPL 
	# version 2.0 with a special clarification/exception that permits adapting the program to
	# configure proprietary "back end" software provided that all modifications to the web interface
	# itself remain covered by the GPL.
	# See http://gargoyle-router.com/faq.html#qfoss for more information
	eval $( gargoyle_session_validator -c "$COOKIE_hash" -e "$COOKIE_exp" -a "$HTTP_USER_AGENT" -i "$REMOTE_ADDR" -r "login.sh" -t $(uci get gargoyle.global.session_timeout) -b "$COOKIE_browser_time"  )
	gargoyle_header_footer -h -s "system" -p "access" -c "internal.css" -j "access.js" -i httpd_gargoyle dropbear gargoyle firewall network wireless 
?>

<form>
	<fieldset>
		<legend class='sectionheader'>Web 访问</legend>

		<div>
			<label class='leftcolumn' id='local_web_protocol_label' for='local_web_protocol'>本地Web管理协议:</label>
			<select class='rightcolumn' id='local_web_protocol' onchange='updateVisibility()'>
				<option value='https'>HTTPS</option>
				<option value='http'>HTTP</option>
				<option value='both'>HTTP & HTTPS</option>
			</select>
		</div>

		<div class='indent'>
			<div id='local_http_port_container'>
				<label class='leftcolumn' for='local_http_port' id='local_http_port_label'>本地HTTP端口:</label>
				<input type='text' class='rightcolumn' id='local_http_port'  size='7' maxlength='5' onkeyup='proofreadNumericRange(this,1,65535)'/>
			</div>
			<div id='local_https_port_container'>
				<label class='leftcolumn' for='local_https_port' id='local_https_port_label'>本地HTTPS端口:</label>
				<input type='text' class='rightcolumn' id='local_https_port'  size='7' maxlength='5' onkeyup='proofreadNumericRange(this,1,65535)'/>
			</div>
		</div>
		<div id='remote_web_protocol_container'>
			<label class='leftcolumn' id='remote_web_protocol_label' for='remote_web_protocol'>远程Web管理协议:</label>
			<select class='rightcolumn' id='remote_web_protocol' onchange='updateVisibility()'>
				<option value='disabled'>Disabled</option>
				<option value='https'>HTTPS</option>
				<option value='http'>HTTP</option>
				<option value='both'>HTTP & HTTPS</option>
			</select>
		</div>
		<div class='indent' id='remote_web_ports_container'>
			<div id='remote_http_port_container'>
				<label class='leftcolumn' for='remote_http_port' id='remote_http_port_label'>远程HTTP端口:</label>
				<input type='text' class='rightcolumn' id='remote_http_port'  size='7' maxlength='5' onkeyup='proofreadNumericRange(this,1,65535)'/>
			</div>
			<div id='remote_https_port_container'>
				<label class='leftcolumn' for='remote_https_port' id='remote_https_port_label'>远程HTTPS端口:</label>
				<input type='text' class='rightcolumn' id='remote_https_port'  size='7' maxlength='5' onkeyup='proofreadNumericRange(this,1,65535)'/>
			</div>
		</div>
		<div id='session_length_container'>
			<label class='leftcolumn' id='session_length_label' for='session_length'>远程登录会话长度:</label>
			<select class='rightcolumn' id='session_length' >
				<option value='15'>15 分钟</option>
				<option value='30'>30 分钟</option>
				<option value='60'>1 小时</option>
				<option value='120'>2 小时</option>
				<option value='240'>4 小时</option>
				<option value='720'>12 小时</option>
				<option value='1440'>24 小时</option>
			</select>
		</div>

		<div class="nocolumn">
			<input type='checkbox' id='disable_web_password' />
			<label id='disable_web_password_label' for='disable_web_password'>禁用密码保护的Web界面</label> <em>(不推荐!)</em>
		</div>

	</fieldset>

	<fieldset>
		<legend class='sectionheader'>SSH 访问</legend>

		<div>
			<label class='leftcolumn' for='local_ssh_port' id='local_ssh_port_label'>本地SSH端口:</label>
			<input type='text' class='rightcolumn' id='local_ssh_port'  size='7' maxlength='5' onkeyup='proofreadNumericRange(this,1,65535)'/>
		</div>

		<div class='nocolumn' id='remote_ssh_enabled_container'>
			<input type='checkbox' id='remote_ssh_enabled' onclick="updateVisibility()" />
			<label id='remote_ssh_enabled_label' for='remote_ssh_enabled'>启用远程SSH访问</label>
		</div>
		<div class='indent' id='remote_ssh_port_container'>
			<label class='leftcolumn' for='remote_ssh_port' id='remote_ssh_port_label'>远程SSH端口:</label>
			<input type='text' class='rightcolumn' id='remote_ssh_port'  size='7' maxlength='5' onkeyup='proofreadNumericRange(this,1,65535)'/>
		</div>
		<div class='indent' id='remote_ssh_attempts_container'>
			<label class='leftcolumn' for='remote_ssh_attempts' id='remote_ssh_attempts_label'>最大远程登录尝试:</label>
			<select class='rightcolumn' id='remote_ssh_attempts'>
				<option value="1">每5分钟尝试1次</option>
				<option value="3">每5分钟尝试3次</option>
				<option value="5">每5分钟尝试5次</option>
				<option value="10">每5分钟尝试10次</option>
				<option value="15">每5分钟尝试15次</option>
				<option value="unlimited">不限制尝试次数</option>
			</select>
		</div>
	</fieldset>

	<fieldset>
		<legend class="sectionheader">更改管理员密码</legend>
		<div>
			<label class='leftcolumn' for='password1' id='password1_label'>新密码:</label>
			<input type='password' class='rightcolumn' id='password1'  size='25' />
		</div>
		<div>
			<label class='leftcolumn' for='password2' id='password2_label'>确认密码:</label>
			<input type='password' class='rightcolumn' id='password2'  size='25' />
		</div>

	</fieldset>

	<div id="bottom_button_container">
		<input type='button' value='保存设置' id="save_button" class="bottom_button" onclick='saveChanges()' />
		<input type='button' value='重设' id="reset_button" class="bottom_button" onclick='resetData()'/>
	</div>

	<span id="update_container" >Please wait while new settings are applied. . .</span>
</form>

<!-- <br /><textarea style="margin-left:20px;" rows=30 cols=60 id='output'></textarea> -->

<script>
<!--
	resetData();
//-->
</script>
<?
	gargoyle_header_footer -f -s "system" -p "access"
?>
