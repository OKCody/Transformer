# Path to directory containing "functions/", "MathJax/", and "stylesheets/"
location="/Users/ . . . / . . . /transformer"

source $location/functions/config.sh                 # Contains paths to dependent files
source $location/functions/general_functions.sh      # Contains operational functions
source $location/functions/css_functions.sh          # Contains CSS-specific functions
source $location/functions/conversion_functions.sh   # Contains Pandoc and Pandoc-related functions

html=false;  # Initialize output format switches
docx=false;
epub=false;
 pdf=false;
site=false;

function usage () {
  cat << EOF
  script_name=$0
Usage: ideal_textbook_creator [-b] [-p] [-e] [-d] [-s] [Markdown files]

    -b generates HTML document (body only)
    -d generates DOCX document
    -e generates EPUB document
    -p generates PDF  document
    -s generates stand-alone website

    -h displays this help information

EOF
  exit 0
}

# Create directory in which to store resultant files
create_output_dir

# Select output format switches and generate css for each selected
while getopts ":bdeps" opt; do
  case $opt in
  b ) html=true
      cat $base $base_html $example > $output/html.css
      html_style="$output/html.css"
      ;;
  d ) docx=true;;
  e ) epub=true
      cat $base $base_epub $example > $output/epub.css
      epub_style="$output/epub.css"
      ;;
  p ) pdf=true
      cat $base $base_pdf $example > $output/pdf.css
      pdf_style="$output/pdf.css"
      ;;
  s ) site=true;;
  \? ) usage;;
  esac
done
shift "$((OPTIND-1))" # perhaps not necessary
OPTIND=1              # perhaps not necessary

md_file=""    # empty list for appending markdown files
css_file=""   # empty list for appending stylesheet files
errors=0      # count number of errors encountered

# Accept .md/.MD and .css/.CSS file paths as arguments, separate into respective
# lists of files. Throw errors accordingly.
for file in $@; do
  type=$(file -b --mime-type $file)
  if [ "${type:0:4}" != "text" ]; then
    printf "ERROR: $file is empty or not of type 'text'.\n"
    errors+=1
  else
    if [ "${file: -3}" == ".md" ] || [ "${file: -3}" == ".MD" ]; then
      markdown_files+=" ${file:0:-3}.md"
    else
      if [ "${file: -4}" == ".css" ] || [ "${file: -4}" == ".CSS" ]; then
        stylesheet_files+=" ${file:0:-4}.css"
      else
        printf "ERROR: $file is not a supported file type.\n"
        printf "       Only '.md/.MD' and '.css/.CSS' files are supported.\n"
        printf "       File names should not contain spaces.\n"
        errors+=1
      fi
    fi
  fi
done

# If no errors exist, proceed
if [ $errors -gt 0 ]; then    # BASH has a weird way of performing ">"
  echo "Errors exist. Use '-h' for help."
else

  # Lists files to be operated on
  echo ""
  echo " MD: "$markdown_files
  echo "CSS: "$stylesheet_files
  echo ""

  # Prepare format-specific stylesheets, make_*() are in css_functions.sh
  for css_file in $stylesheet_files; do
    make_html_css
    make_pdf_css
    make_epub_css
  done

  # Perform Markdown conversions, to_*() are in conversion_functions.sh
  for md_file in $markdown_files; do
    out_file=${md_file##*/}
    printf "$md_file\n"
    if [ $html ]; then
      printf "  --> ${out_file%md}html"
      to_html & spinner
      test_file "${out_file%md}html"
    fi
    if [ $pdf ]; then
      printf "  --> ${out_file%md}pdf"
      to_pdf & spinner
      test_file "${out_file%md}pdf"
    fi
    if [ $epub ]; then
      printf "  --> ${out_file%md}epub"
      to_epub & spinner
      test_file "${out_file%md}epub"
    fi
    if [ $docx ]; then
      printf "  --> ${out_file%md}docx"
      to_docx & spinner
      test_file "${out_file%md}docx"
    fi
  done
fi
