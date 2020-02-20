function fish_prompt_echo
  set_color "$argv[1]"
  echo -ne "$argv[2]"
  set_color normal
end

function fish_prompt
  set -l prompt_status $status

  set -l prompt_cwd (string replace -r "$HOME" "~" $PWD)

  set -l prompt_color_cwd cyan
  set -l prompt_color_hostname yellow
  set -l prompt_color_user purple
  set -l prompt_color_arrow green

  if test $USER = "root"; set prompt_color_user red; end
  if test $hostname != "x1"; set prompt_color_hostname red; end
  if test $prompt_status != 0; set prompt_color_arrow red; end

  fish_prompt_echo $prompt_color_user $USER
  echo -ne "@"
  fish_prompt_echo $prompt_color_hostname $hostname
  echo -ne " "
  fish_prompt_echo $prompt_color_cwd $prompt_cwd
  echo -ne " "
  fish_prompt_echo $prompt_color_arrow ➜
  echo -ne " "
end
