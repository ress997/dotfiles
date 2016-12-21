PROMPT=""
PROMPT2=""
PROMPT_CHAR="❯"

__arukas::prompt::hostname ()
{
	echo "%{${fg[cyan]}%}%m%{$reset_color%}"
}

__arukas::prompt::username ()
{
	echo "%{${fg[yellow]}%}%n%{$reset_color%}"
}

__arukas::prompt::status ()
{
    echo "%(0?.$ON_COLOR.$ERR_COLOR)$PROMPT_CHAR%{$reset_color%}"
}

__arukas::prompt::path ()
{
	local path_color="%{[38;5;244m%}%}"
	local rsc="%{$reset_color%}"
	local sep="$rsc/$path_color"
	local _path_="$(__arukas::misc::pathshorten "${PWD/$HOME/~}")"
	echo "$path_color$_path_$rsc"
}
