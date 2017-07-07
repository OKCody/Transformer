# Create output directory in the directory from where this script was executed
create_output_dir(){
  output="$output/output"
  echo $ouput
  mkdir -p $output        # make directory only if it does not already exist
}

# ensure generated file actually exists (-e) and is of non-zero size (-s)
test_file(){
  test_file=$1
  if [ -e $output/$test_file ] && [ -s $output/$test_file ]; then printf " ✓\n"; else printf " ✗\n"; fi
}

# Because conversions can take a bit, let user know work is being done.
# StackOverflow: https://stackoverflow.com/questions/12498304/using-bash-to-display-a-progress-working-indicator#answer-20369590
spinner()
{
    local pid=$!
    local delay=0.25
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf "  %c   " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}
