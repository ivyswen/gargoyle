/*
 * Copyright (c) 2011 Eric Bishop and Cezary Jackiewicz <cezary@eko.one.pl>  
 * and is distributed under the terms of the GNU GPL 
 * version 2.0 with a special clarification/exception that permits adapting the program to 
 * configure proprietary "back end" software provided that all modifications to the web interface
 * itself remain covered by the GPL. 
 * See http://gargoyle-router.com/faq.html#qfoss for more information
 *
 */function createUseButton(){var e=createInput("button");return e.value="Select",e.className="default_button",e.onclick=useTheme,e}function resetData(){var e=["Theme","",""],t=new Array,n=uciOriginal.get("gargoyle","global","theme"),r="";for(idx=0;idx<themes.length;idx++)r=themes[idx]==n?"*":"",t.push([themes[idx],r,createUseButton()]);var i=createTable(e,t,"themes_table",!1,!1),s=document.getElementById("themes_table_container");s.firstChild!=null&&s.removeChild(s.firstChild),s.appendChild(i)}function useTheme(e,t){var e=this.parentNode.parentNode,n=e.firstChild.firstChild.data,r=[];r.push('uci set gargoyle.global.theme="'+n+'"'),r.push("uci commit"),r.push("sleep 1"),commands=r.join("\n");var i=getParameterDefinition("commands",commands)+"&"+getParameterDefinition("hash",document.cookie.replace(/^.*hash=/,"").replace(/[\t ;]+.*$/,""));setControlsEnabled(!1,!0,"Please wait...");var s=function(e){e.readyState==4&&(setControlsEnabled(!0),location.reload(!0))};runAjax("POST","utility/run_commands.sh",i,s)};