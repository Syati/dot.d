function fzf_aws_ecs_exec() {
  zparseopts -D -E -A opthash -- -profile:

  local profile="${opthash[--profile]}"
  local query="$*"
  local tmpfile
  tmpfile=$(mktemp)

  for cluster in $(aws --profile "$profile" ecs list-clusters --no-paginate \
    | jq -r '.clusterArns[]? | split("/")[-1]'); do
    for service in $(aws --profile "$profile" ecs list-services --no-paginate --cluster "$cluster" \
      | jq -r '.serviceArns[]? | split("/")[-1]'); do
      for task in $(aws --profile "$profile" ecs list-tasks --no-paginate --cluster "$cluster" --service-name "$service" \
        | jq -r '.taskArns[]? | split("/")[-1]'); do
        for container in $(aws --profile "$profile" ecs describe-tasks --no-paginate --cluster "$cluster" --tasks "$task" \
          | jq -r '.tasks[].containers[].name'); do
          printf "%s/%s/%s/%s\n" "$cluster" "$service" "$task" "$container" >> "$tmpfile"
        done
      done
    done
  done

  local selected_line
  selected_line=$(sort "$tmpfile" | fzf --query "$query" \
    --preview "aws --profile $profile ecs describe-tasks --cluster {1} --tasks {3} | jq '.tasks[0].lastStatus'" \
    --delimiter '/' --with-nth 1,2,3,4)

  rm -f "$tmpfile"
  [[ -z "$selected_line" ]] && return 0

  local -a selected
  selected=("${(@s:/:)selected_line}")

  print -z "aws --profile ${profile} ecs execute-command --cluster ${selected[1]} --task ${selected[3]} --container ${selected[4]} --interactive --command '/bin/bash'"
}


alias aee=fzf_aws_ecs_exec
