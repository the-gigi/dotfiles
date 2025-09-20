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
function aws_profile() {
    profiles=($(rg -oP '(?<=\[profile ).*(?=\])' ~/.aws/config))
    if [[ $# -eq 1 ]]; then
        if [[ " ${profiles[@]} " =~ " $1 " ]]; then
            switch_profile "$1"
            return
        fi
    fi

    show_profiles "${profiles[@]}"
    new_profile=""
    while [[ -z $new_profile ]]; do
        echo "Choose a profile (1..${#profiles[@]}):"
		if (( ${#profiles} < 10 ))
		then
				read -sk 1 answer
		else
				read answer
		fi
    if ! [[ $answer =~ ^[0-9]+$ ]]; then
      continue
    fi
		new_profile=$profiles[(($answer))]
    done
    switch_profile "$new_profile"
}

# AWS role component for powerlevel10k prompt
# Shows current AWS assumed role with appropriate colors
function prompt_aws_role() {
  # Check if we have AWS SSO role information
  if [[ -z "$AWS_SSO_ROLE_NAME" || -z "$AWS_SSO_ACCOUNT_ID" ]]; then
    return
  fi

  # Create display name based on account and role
  local account_name role_display

  case "$AWS_SSO_ACCOUNT_ID" in
    706218807402)
      account_name="sandbox"
      ;;
    699*)
      account_name="prod"
      ;;
    *)
      account_name="aws"
      ;;
  esac

  # Display format: "account role"
  local display_text="${account_name} ${AWS_SSO_ROLE_NAME}"

  # Use p10k segment API
  p10k segment -i '☁️' -f 208 -t "$display_text"
}
