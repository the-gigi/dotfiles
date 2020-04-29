# export AWS_PROFILE and print a message
function switch_profile {
  export AWS_PROFILE=$1
  echo "Switched to profile $1"
}

# Display all the profiles with index. Add (*) for the current profile
function show_profiles {
  for (( i = 1; i <= ${#profiles}; i++ )); do
    p=$profiles[$i]
    suffix=''
    if [[ $p == $AWS_PROFILE ]]; then
      suffix='(*)'
    fi
    echo "[$i] $profiles[$i] $suffix"
  done
}

# aws_profile shows and switches AWS profiles
#
# If you call it with one argument (a profile name) it will switch
# to that profile (if exists)
#
# In all other cases it will display the list of profiles and lets you
# choose a new profile by typing its index number.
#
# If there are less than 10 profiles it will switch to the new profile
# when you type its single digit number
#
# If there are 10 or more profiles you must press <enter> too
function aws_profile {
  profiles=($(cat ~/.aws/config | rg '^.profile ' | cut -f 2 -d ' ' | cut -f 1 -d ']'))
  if [[ $# == 1 ]]; then
    found=0
    for p in $profiles; do
      if [[ $p == $1 ]]; then
        found=1
        break
      fi
    done
    if [[ $found == 1 ]]; then
      switch_profile $1
      return
    fi
  fi

  show_profiles $profiles

  new_profile=""
  while [[ $new_profile == "" ]]; do
    echo "Choose a profile (1..${#profiles}):"
    if (( ${#profiles} < 10 )); then
      read -rs -k 1 answer
    else
      read -r answer
    fi
    new_profile=$profiles[(($answer))]
  done

  switch_profile $new_profile
}
