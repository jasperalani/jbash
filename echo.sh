#!/bin/bash

echo() {
    # Check if any custom flags are present
    local has_custom_flag=0
    for arg in "$@"; do
        case "$arg" in
            -c|-s|-n|-nl|-S|--success|-f|--failure|help)
                has_custom_flag=1
                break
                ;;
        esac
    done

    if [[ $has_custom_flag -eq 0 ]]; then
        # Fall back to builtin echo
        builtin echo "$@"
        return
    fi

    # --- Enhanced jecho logic below ---
    local text=""
    local color=""
    local style=""
    local newline=1
    local emoji=""
    local -A colors=(
        [black]=30 [red]=31 [green]=32 [yellow]=33 [blue]=34
        [magenta]=35 [cyan]=36 [white]=37 [gray]=90
        [bright_red]=91 [bright_green]=92 [bright_yellow]=93
        [bright_blue]=94 [bright_magenta]=95 [bright_cyan]=96 [bright_white]=97
        [orange]=38\;5\;208 [pink]=38\;5\;205 [teal]=38\;5\;30 [purple]=38\;5\;93
    )
    local -A styles=(
        [bold]=1 [italic]=3 [strikethrough]=9
    )

    if [[ "$1" == "help" ]]; then
        builtin echo "Usage: echo \"message\" -c color -s style [options]"
        builtin echo ""
        builtin echo "Colors:"
        for key in "${!colors[@]}"; do builtin echo "  $key"; done | sort
        builtin echo ""
        builtin echo "Styles:"
        for key in "${!styles[@]}"; do builtin echo "  $key"; done | sort
        builtin echo ""
        builtin echo "Options:"
        builtin echo "  -c <color>        Set text color"
        builtin echo "  -s <style>        Set text style (bold, italic, strikethrough)"
        builtin echo "  -n                Do not print newline (same line)"
        builtin echo "  -nl               Force newline"
        builtin echo "  -S | --success    Append ✔️"
        builtin echo "  -f | --failure    Append ❌"
        builtin echo "  help              Show this message"
        return
    fi

    text="$1"
    shift
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -c)
                shift
                color="${colors[$1]}"
                if [[ -z "$color" ]]; then
                    builtin echo "Unknown color: $1"
                    return 1
                fi
                ;;
            -s)
                shift
                style="${styles[$1]}"
                if [[ -z "$style" ]]; then
                    builtin echo "Unknown style: $1"
                    return 1
                fi
                ;;
            -n)
                newline=0
                ;;
            -nl)
                newline=2
                ;;
            -S|--success)
                emoji=" ✔️"
                ;;
            -f|--failure)
                emoji=" ❌"
                ;;
            *)
                builtin echo "Unknown option: $1"
                return 1
                ;;
        esac
        shift
    done

    local esc_seq="\e["
    [[ -n "$style" ]] && esc_seq+="${style};"
    [[ -n "$color" ]] && esc_seq+="${color};"
    esc_seq="${esc_seq%;}m"

    if [[ "$newline" -eq 0 ]]; then
        printf "${esc_seq}%s%s\e[0m" "$text" "$emoji"
    else
        printf "${esc_seq}%s%s\e[0m" "$text" "$emoji"
        [[ "$newline" -eq 2 ]] && printf "\n"
        [[ "$newline" -eq 1 ]] && builtin echo
    fi
}
