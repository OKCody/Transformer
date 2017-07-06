# Create output directory in the directory from where this script was executed
create_output_dir(){
  output="$output/output"
  mkdir -p $output        # make directory only if it does not already exist
}

# Return file type in $type
check_file(){
  type=$(file -b --mime-type $file)
}

# ensure generated file actually exists (-e) and is of non-zero size (-s)
test_file(){
  test_file=$1
  if [ -e $output/$test_file ] && [ -s $output/$test_file ]; then printf " ✓\n"; else printf " ✗\n"; fi
}
