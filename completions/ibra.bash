# ==============================================================================
# BASH COMPLETION FOR IBRA CLI
# Author: Ibra Ramdan <ibradecode@gmail.com>
# ==============================================================================

_ibra_completions() {
    local cur prev subcommands
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    subcommands="run fast explore sonnet init status dns benchmark arsitektur refactor dockerize keamanan tinjau doctor clean backup notify update mcp stats menu version help"

    if [ "$COMP_CWORD" -eq 1 ]; then
        COMPREPLY=( $(compgen -W "${subcommands}" -- "$cur") )
        return 0
    fi

    case "$prev" in
        init)
            local templates="api worker bot"
            COMPREPLY=( $(compgen -W "${templates}" -- "$cur") )
            return 0
            ;;
        *)
            ;;
    esac
}

complete -F _ibra_completions ibra
