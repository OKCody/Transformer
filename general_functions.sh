# Return file type in $type
check_file(){
  type=$(file -b --mime-type $file)
}

# ensure generated file actually exists (-e) and is of non-zero size (-s)
test_file(){
  test_file=$1
  if [ -e $test_file ] && [ -s $test_file ]; then printf " ✓\n"; else printf " ✗\n"; fi
}
