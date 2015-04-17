local function getWifiParameter ( paramName )
	return io.popen(
		"wicd-cli --wireless -d | grep -P '".. paramName .."\:\s(.*?)' | sed 's/^" .. paramName .. "\:\s//g'"
	):read()

local function getNetworks ()
	local scanned = {}
	scanned.ids = io.popen('wicd-cli --wireless -l | grep -Po "^[0-9]*"'):read():split('\n')
	scanned.ssids = table_slice(io.popen('wicd-cli --wireless -l | grep -P "([^\s]+)$"'):read():split('\n'), 2)
	local networks = {}
	for k,v in pairs(scanned.ids) do
		networks[k] = {
			id = v,
			ssid = scanned[k]
		}
	end
	return networks
end

local function isWiredConnected ()
	return not not io.popen('wicd-cli --wired -d'):read() -- Cast to boolean xD
end

local function getWifiInfo ()
	local network = {}
	network.ssid = getWifiParameter('Essid')
	network.ip = getWifiParameter('IP')
	network.quality = getWifiParameter('Quality')
	if not network.ip then
		return false
	end
	return network
end

local function generateConnectionsMenu ()
	local networks = getNetworks()
	local connections = {
		{ (isWiredConnected() ? '*' : '') .. "Wired" }
	}
end

local function connectNetwork ( networkId )
	os.execute('wicd-cli --wireless --connect -n ' .. networkId)
	local networks = getNetworks()
	return networks[networkId].ssid == getWifiInfo().ssid
end

local function generateMenu ()
	local wifiMenu = {
		{ "Turn proxy "..{"off", "on"}[~getProxyStatus()+1], toggleProxy },
		{ "Connections", {
			generateConnectionsMenu()
		} }
	}
	local networks = getNetworks()
	local connected = getWifiInfo()
end


--wicd-cli --wireless -d | grep -P -i "essid|quality" | cut -d " " -f 2 | awk '!/0$/{printf "%s ",$0}/0$/'
local awful = require("awful")
local theme = require("theme")
local beautiful = require("beautiful")
beautiful.init(theme)

awful.tooltip = require("awful.tooltip")
local proxy = io.popen("sudo cat /etc/privoxy/config | grep 'forward / 192.168.254.60:3128'"):read()
if not proxy or proxy == '' then
	proxy = "Off"
else
	proxy = "On"
end
function updateWifi()
	local status = io.popen("wicd-cli --wireless -d | grep -P -i \"essid|quality\" | cut -d \" \" -f 2 | awk '!/0$/{printf \"%s \",$0}/0$/'"):read()
	if status then
		wifi:set_image(awful.util.getdir("config").."/icons/wireless-on.png")
		return true;
	else
		wifi:set_image(awful.util.getdir("config").."/icons/wireless-off.png")
		return false
	end
end

wifi_timer = timer({timeout = 30})
wifi_timer:connect_signal("timeout", updateWifi)
wifi_timer:start()


function wifiStat()
	local status = io.popen("wicd-cli --wireless -d | grep -P -i \"essid|quality\" | cut -d \" \" -f 2 | awk '!/0$/{printf \"%s \",$0}/0$/'"):read()
	if status then
		return "\n Connected["..status.."%".."] \n".." Proxy: "..proxy.."\n";
	else
		return "Not connected"
	end
end

function toggleProxy()
	if updateWifi() then
		if proxy == "Off" then
			os.execute("sudo su -c 'echo \"forward / 192.168.254.60:3128\" >> /etc/privoxy/config'")
			proxy = "On"
		else
			os.execute("sudo su -c 'sed -i \"$ d\" /etc/privoxy/config'")
			proxy = "Off"
		end
	else
		proxy = "Off"
	end
end

wifi_t = awful.tooltip({
	objects = { wifi },
	timer_function = wifiStat,
})

wifi:buttons(awful.util.table.join(
	awful.button({ }, 1, toggleProxy),
	awful.button({ }, 3, function() awful.util.spawn('urxvt -e wicd-curses') end)
))

updateWifi()
