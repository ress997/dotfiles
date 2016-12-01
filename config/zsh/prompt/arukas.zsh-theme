for f in "${${(%):-%N}:A:h}"/**/*.(|z)sh(N-.)
do
    source "$f"
done
unset f

PROMPT+='%{${fg[cyan]}%}%m%{${reset_color}%}'
PROMPT+=' :: '
PROMPT+='%{${fg[yellow]}%}%n%{${reset_color}%}'
PROMPT+=' :: '
PROMPT+='$(__arukas::prompt::path)'
PROMPT+="
"
PROMPT+='$(__arukas::prompt::user)'
PROMPT+='$(__arukas::prompt::job)'
PROMPT+='$(__arukas::prompt::status)'
PROMPT+=' '

PROMPT2+='$(__arukas::prompt::user)'
PROMPT2+='$(__arukas::prompt::job)'
PROMPT2+='$(__arukas::prompt::status)'
PROMPT2+=' '

SPROMPT="%{${fg[red]}%}Did you mean?: %R -> %r [nyae]? %{${reset_color}%}"

# vim:ft=zsh:
