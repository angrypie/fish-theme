
# fish theme: edan

function fish_prompt
  set fish_greeting
  # Terminate with a nice prompt char
  echo -n -s '> ' $normal
end

# Switch environment to "local" for edan.
function edan-set-local
  set -U EDAN_HOST_TYPE "local"
end

# Switch environment to "remote" for edan.
function edan-set-remote
  set -U EDAN_HOST_TYPE 'remote'
end
# Display the compressed current working path on the right
# If the previous command returned any kind of error code, display that too
# Display the following bits on the left:
# * User & host (hidden by default, execute `edan-remote`to show, `edan-local` to hide)
# * Virtualenv name (if applicable, see https://github.com/adambrenecki/virtualfish)
# * Current directory name
# * Git branch and dirty state (if inside a git repo)

function _git_branch_name
  echo (command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty 2> /dev/null)
end

function _user_host
  if [ (id -u) = "0" ];
    echo -n (set_color -o red)
  else
    echo -n (set_color -o blue)
  end
  echo -n (hostname|cut -d . -f 1)ˇ$USER (set color normal)
end

function fish_right_prompt
  set -l last_status $status
  set -l cyan (set_color -o cyan)
  set -l yellow (set_color -o yellow)
  set -l red (set_color -o red)
  set -l blue (set_color -o blue)
  set -l green (set_color -o green)
  set -l normal (set_color normal)

  set -l cwd $cyan(basename (prompt_pwd))

  # output the prompt, left to right

  # Add a newline before prompts
  echo -e ""

  # Display [venvname] if in a virtualenv
  if set -q VIRTUAL_ENV
    echo -n -s (set_color -b cyan black) '[' (basename "$VIRTUAL_ENV") ']' $normal ' '
  end

  # Display [user & host] when on remote host
  if [ "$EDAN_HOST_TYPE" = "remote" ]
    _user_host; echo -n ': '
  end

  echo -n -s $cyan (prompt_pwd)

  # Show git branch and dirty state
  if [ (_git_branch_name) ]
    set -l git_branch '(' (_git_branch_name) ')'

    if [ (_is_git_dirty) ]
      set git_info $red $git_branch "×"
    else
      set git_info $green $git_branch
    end
    echo -n -s $git_info $normal
  end



  if test $last_status -ne 0
    set_color red
    printf ' %d' $last_status
    set_color normal
  end
end
