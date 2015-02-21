local f, s, o
local uci = luci.model.uci.cursor()
local site = require 'gluon.site_config'
local fs = require "nixio.fs"

local sites = {}

uci:set_confdir('/lib/gluon/site-select')

uci:foreach('siteselect', 'site',
function(s)
	table.insert(sites, s['.name'])
end
)

--set the heading, button and stuff
f = SimpleForm("site-select", "Community-Einstellungen auswählen")
f.reset = false

f.template = "admin/expertmode"
f.submit = "Speichern"

-- text, which describes what the package does to the user
s = f:section(SimpleSection, nil, [[
Hier hast du die Möglichkeit die Community, mit der sich dein
Knoten verbindet, auszuwählen. Bitte denke daran, dass dein Router
sich dann nur mit dem Netz der ausgewählten Community verbindet.
]])

o = s:option(ListValue, "community", "Community")
o:value(site.site_code, site.site_name)

for index, site in ipairs(sites) do
	o:value(site, uci:get('siteselect', site, 'sitename'))
end

function f.handle(self, state, data)
	if state == FORM_VALID then

		uci:set_confdir('/etc/config/')
		local secret = uci:get('fastd', 'mesh_vpn', 'secret')

		uci:set_confdir('/lib/gluon/site-select')
		uci:set('siteselect', site.site_code, "secret", secret)
		uci:save('siteselect')
		uci:commit('siteselect')

		fs.copy(uci:get('siteselect', data.community , 'path'), '/lib/gluon/site.conf')
		os.execute('sh "/lib/gluon/site-select/upgrade-script"')

		uci:set_confdir('/lib/gluon/site-select')
		local secret2 = uci:get('siteselect', site.site_code, 'secret')
		
		uci:set_confdir('/etc/config/')
		uci:set('fastd', 'mesh_vpn', "secret", secret2)

		uci:save('fastd')
		uci:commit('fastd')


	end
end

return f