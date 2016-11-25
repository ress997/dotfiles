showoptions() {
	set -o | sed -e 's/^no\(.*\)on$/\1  off/' -e 's/^no\(.*\)off$/\1  on/'
}

# available
available() {
	local x candidates
	candidates="$1:"
	while [ -n "$candidates" ]; do
		x=${candidates%%:*}
		candidates=${candidates#*:}
		if type "$x" >/dev/null 2>&1; then
			echo "$x"
			return 0
		else
			continue
		fi
	done
	return 1
}
