# bash completion for hardline
_hardline() {
	local cur opts
	cur="${COMP_WORDS[COMP_CWORD]}"
	opts="--json --quiet --no-color -h --help -V --version"
	mapfile -t COMPREPLY < <(compgen -W "${opts}" -- "${cur}")
}
complete -F _hardline hardline
