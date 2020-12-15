#!/bin/sh

opkg() {
	if [[ $(echo $@ | grep -o -E '( install | upgrade )') ]]; then
		command opkg --force-checksum --force-overwrite $@
		grep -q "nas" /usr/lib/lua/luci/controller/*.lua &&
			sed -i 's/local page/local page\nentry({"admin", "nas"}, firstchild(), _("NAS") , 45).dependent = false/' /usr/lib/lua/luci/controller/turboacc.lua
		rm -Rf /tmp/luci-*
		/etc/init.d/ucitrack reload
	elif [[ $(echo $@ | grep -o 'remove') ]]; then
		command opkg $@
		grep -q "nas" /usr/lib/lua/luci/controller/*.lua ||
			sed -i '/_("NAS")/d' /usr/lib/lua/luci/controller/turboacc.lua
		rm -Rf /tmp/luci-*
	else
		command opkg $@
	fi
	rm -f /var/lock/opkg.lock
}
