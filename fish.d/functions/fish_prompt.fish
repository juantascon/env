function fish_prompt_echo
  set_color "$argv[1]"
  echo -ne "$argv[2]"
  set_color normal
end

function fish_prompt
  set -l prompt_status $status
  set -l prompt_cwd (string replace -r "$HOME" "~" $PWD)
  if test $USER = juan -a $hostname = "x1"
    fish_prompt_echo purple \$
  else
    fish_prompt_echo red $USER
    echo -ne "@"
    fish_prompt_echo red $hostname
  end
  echo -ne " "
  fish_prompt_echo cyan $prompt_cwd
  echo -ne " "
  if [ $prompt_status != 0 ]
    fish_prompt_echo red ➜
  else
    fish_prompt_echo green ➜
  end
  echo -ne " "
end
