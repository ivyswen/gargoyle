#!/usr/bin/haserl
<?
	# This program is copyright ?2008-2010 Eric Bishop and is distributed under the terms of the GNU GPL 
	# version 2.0 with a special clarification/exception that permits adapting the program to
	# configure proprietary "back end" software provided that all modifications to the web interface
	# itself remain covered by the GPL.
	# See http://gargoyle-router.com/faq.html#qfoss for more information
	eval $( gargoyle_session_validator -c "$COOKIE_hash" -e "$COOKIE_exp" -a "$HTTP_USER_AGENT" -i "$REMOTE_ADDR" -r "login.sh" -t $(uci get gargoyle.global.session_timeout) -b "$COOKIE_browser_time"  )
	gargoyle_header_footer -h -s "status" -p "bandwidth" -c "internal.css" -j "table.js bandwidth.js" -n -i gargoyle qos_gargoyle
?>

<script>
<!--
<?
	echo 'var monitorNames = new Array();'
	mnames=$(cat /tmp/bw_backup/*.sh 2>/dev/null | egrep "bw_get" | sed 's/^.*\-i \"//g' | sed 's/\".*$//g')
	for m in $mnames ; do 
		echo "monitorNames.push(\"$m\");"
	done

	tz_hundred_hours=$(date "+%z" | sed 's/^+0//' | sed 's/^-0/-/g')
	tz_h=$(($tz_hundred_hours/100))
	tz_m=$(($tz_hundred_hours-($tz_h*100)))
	tz_minutes=$((($tz_h*60)+$tz_m))
	echo "var tzMinutes = $tz_minutes;";
?>
//-->
</script>

<form>
	<fieldset>
		<legend class="sectionheader">流量统计图显示选项</legend>
		<div>
			<label for='plot_time_frame' id='time_frame_label'>分时周期:</label>
			<select id="plot_time_frame" onchange="resetPlots()">
				<option value="1">15 分钟</option>
				<option value="2"> 6 小时</option>
				<option value="3">24 小时</option>
				<option value="4">30 天</option>
				<option value="5"> 1 年</option>
			</select>
		</div>

		<div id="control_column_container">
			<div id="plot1_control_column">
				<div><span  id="plot1_title">Plot 1</span></div>
				<div><select id="plot1_type" onchange="resetPlots()" ><option value="total">总流量</option></select></div>
				<div><select id="plot1_id" onchange="resetPlots()"></select></div>

			</div>
			<div id="plot2_control_column">
				<div><span   id="plot2_title">Plot 2</span></div>
				<div><select id="plot2_type" onchange="resetPlots()" ><option value="none">无</option></select></div>
				<div><select id="plot2_id" onchange="resetPlots()"></select></div>
			</div>
			<div id="plot3_control_column">
				<div><span   id="plot3_title">Plot 3</span></div>
				<div><select id="plot3_type" onchange="resetPlots()"><option value="none">无</option></select></div>
				<div><select id="plot3_id" onchange="resetPlots()"></select></div>
			</div>
		</div>

		<div>
			<input type="checkbox" id="use_high_res_15m" onclick="highResChanged()">&nbsp;
			<label id="use_high_res_15m_label" for="use_high_res_15m">保存所有主机15分钟高分辨率流量分时图</label>
			<br/>
			<em>不推荐 &lt; 32MB 内存的路由器开启</em>
		</div>

		<br/>仅显示连接到WAN接口的所有流量报告.  
		<br/>不显示本地主机之间的流量报告.
	</fieldset>

	<fieldset id="bandwidth_graphs">
		<legend class="sectionheader">流量统计图</legend>
		<span class="bandwidth_title_text"><strong>下载</strong> (<span onclick='expand("Download")' class="pseudo_link">放大</span>)</span>
		<span class="bandwidth_title_text"><strong>上传</strong> (<span onclick='expand("Upload")' class="pseudo_link">放大</span>)</span>
		<br/>
		<embed id="download_plot" style="margin-left:0px; margin-right:5px; float:left; width:240px; height:180px;" src="bandwidth.svg"  type='image/svg+xml' pluginspage='http://www.adobe.com/svg/viewer/install/' />
		<embed id="upload_plot" style="margin-left:0px; margin-right:5px; float:left; width:240px; height:180px;" src="bandwidth.svg"  type='image/svg+xml' pluginspage='http://www.adobe.com/svg/viewer/install/' />
		<br/>
		<span class="bandwidth_title_text"><strong>总量</strong> (<span onclick='expand("Total")' class="pseudo_link">放大</span>)</span>
		<br/>
		<embed id="total_plot" style="margin-left:0px; width:480px; height:360px;" src="bandwidth.svg"  type='image/svg+xml' pluginspage='http://www.adobe.com/svg/viewer/install/' />
	</fieldset>
	<fieldset id="total_bandwidth_use">
		<legend class="sectionheader">流量统计表</legend>
		<div>
			<label for='table_time_frame' class="narrowleftcolumn" id='table_time_frame_label'>分时周期:</label>
			<select id="table_time_frame" class="rightcolumn" onchange="resetPlots()">
				<option value="1">分钟</option>
				<option value="2">15分钟</option>
				<option value="3">小时</option>
				<option value="4">天</option>
				<option value="5">月</option>
			</select>
		</div>
		<div>
			<label for='table_type' class="narrowleftcolumn" id='total_type_label'>显示类型:</label>
			<select id="table_type" class="rightcolumn" onchange="resetPlots()">
				<option value="total">总流量</option>
			</select>
		</div>
		<div id="table_id_container" style="display:none" >
			<label for='table_id' class="narrowleftcolumn" id='total_id_label'>显示子类:</label>
			<select id="table_id" class="rightcolumn" onchange="resetPlots()"></select>
		</div>
		<div class="bottom_gap">
			<label for='table_units' class="narrowleftcolumn" id='table_units_label'>统计单位:</label>
			<select id="table_units" class="rightcolumn" onchange="resetPlots()">
				<option value="mixed">自动(混合)</option>
				<option value="KBytes">KBytes</option>
				<option value="MBytes">MBytes</option>
				<option value="GBytes">GBytes</option>
				<option value="TBytes">TBytes</option>
			</select>
		</div>

		<div id="bandwidth_table_container"></div>


	</fieldset>

	<fieldset id="download_bandwidth_data" >
		<legend class="sectionheader">导出流量统计数据</legend>
		<div>
			<span style='text-decoration:underline'>数据使用逗号分隔:</span>
			<br/>
			<em>[Direction],[Interval Length],[Intervals Saved],[IP],[Interval Start],[Interval End],[Bytes Used]</em>
			<br/>
		</div>
		<div>
			<center><input type='button' id='download_data_button' class='big_button' value='立即导出' onclick='window.location="bandwidth.csv";' /></center>
		</div>
	</fieldset>
</form>

<!-- <br /><textarea style="margin-left:20px;" rows=30 cols=60 id='output'></textarea> -->

<script>
<!--
	initializePlotsAndTable();
//-->
</script>

<?
	gargoyle_header_footer -f -s "status" -p "bandwidth"  
?>
