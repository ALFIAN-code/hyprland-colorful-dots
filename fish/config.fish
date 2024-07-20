if status is-interactive
    # Commands to run in interactive sessions can go here
end

export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable

function fish_prompt -d "Write out the prompt" 
    printf '
%s%s %s%s%s\n> ' (set_color cyan)(hostname) (fish_git_prompt)\
    (set_color red) (prompt_pwd) (set_color yellow)
end

set fish_greeting 
