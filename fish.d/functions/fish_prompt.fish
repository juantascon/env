function fish_prompt
  set -l prompt_status $status

  set -l prompt_cwd (string replace -r "$HOME" "~" $PWD)

  set -l prompt_color_cwd cyan
  set -l prompt_color_hostname yellow
  set -l prompt_color_user cyan
  set -l prompt_color_arrow green

  if test $USER = "root"; set prompt_color_user red; end
  if test $hostname != "x1"; set prompt_color_hostname red; end
  if test $prompt_status != 0; set prompt_color_arrow red; end

  printf '%s%s@%s%s %s%s %s➜%s ' (set_color $prompt_color_user) (echo $USER) (set_color $prompt_color_hostname) (echo $hostname) (set_color $prompt_color_cwd) (echo $prompt_cwd) (set_color $prompt_color_arrow) (set_color normal)
end
