function fish_prompt
    set -l last_status $status

    # Отключаем стандартный venv prompt
    set -g VIRTUAL_ENV_DISABLE_PROMPT 1
    # Цвета
    set -l color_frame (set_color brblack)
    set -l color_text (set_color white)
    set -l color_path (set_color cyan)
    set -l color_git (set_color magenta)
    set -l color_venv (set_color yellow)
    set -l color_success (set_color green)
    set -l color_error (set_color red)
    set -l color_normal (set_color normal)

    # Получение информации
    set -l user (whoami)
    set -l path (prompt_pwd)

    # Git информация
    set -l git_branch ""
    set -l git_branch_text (git branch --show-current 2>/dev/null)
    if test -n "$git_branch_text"
        set git_branch "$color_git  $git_branch_text$color_normal"
    end

    # Python venv информация (если активна)
    set -l venv_name ""
    if set -q VIRTUAL_ENV
        set venv_name (basename "$VIRTUAL_ENV")
        set venv_name "$color_venv ($venv_name)$color_normal"
    end

    # Статус
    set -l status_char ""
    if test $last_status -eq 0
        set status_char "$color_success ✔$color_normal"
    else
        set status_char "$color_error ✘$color_normal"
    end

    # Верхняя рамка
    echo -n -s \
        $color_frame "╭─" $color_normal \
        $color_success $user $color_normal \
        $color_text "@" $color_normal \
        $color_path aaa $color_normal \
        $color_text ":" $color_normal \
        $color_path $path $color_normal \
        $venv_name \
        $git_branch \
        $status_char \
        \n

    # Нижняя рамка с приглашением
    echo -n -s \
        $color_frame "╰─" $color_normal \
        $color_success λ $color_normal " "
end
