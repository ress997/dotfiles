for f in "${${(%):-%N}:A:h}"/**/*.(|z)sh(N-.)
do
    source "$f"
done
unset f

PROMPT+='$(__arukas::prompt::username)'
PROMPT+='$(__arukas::misc::space)'
PROMPT+='$(__arukas::prompt::hostname)'
PROMPT+='$(__arukas::misc::space)'
PROMPT+='$(__arukas::prompt::path)'
PROMPT+="
"
PROMPT+='$(__arukas::prompt::status)'
PROMPT+=' '

PROMPT2+='$(__arukas::prompt::status)'
PROMPT2+=' '

SPROMPT="${ERR_COLOR}Did you mean?: %R -> %r [nyae]? %{$reset_color%}"

# vim:ft=zsh:
