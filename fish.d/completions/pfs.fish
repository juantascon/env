set -l cmds get find select

complete -f -c pfs -n "not __fish_seen_subcommand_from $cmds" -a get
complete -f -c pfs -n "not __fish_seen_subcommand_from $cmds" -a find
complete -f -c pfs -n "not __fish_seen_subcommand_from $cmds" -a select

complete -f -c pfs -n "__fish_seen_subcommand_from get; and test (__fish_number_of_cmd_args_wo_opts) = 2" -a "(pfs find)"
