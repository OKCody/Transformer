source general_functions.sh
source css_functions.sh
source conversion_functions.sh

html="false";
docx="false";
epub="false";
 pdf="false";
site="false";

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

while getopts ":bdeps" opt; do
  case $opt in
  b ) html="true";;
  d ) docx="true";;
  e ) epub="true";;
  p ) pdf="true";;
  s ) site="true";;
  \? ) usage;;
  esac
done
shift "$((OPTIND-1))" #perhaps not necessary
OPTIND=1              #perhaps not necessary

markdown=$@ #space-separated list of Markdown filenames to operate on

for css_file in *.css; do
  make_html_css
  make_pdf_css
  make_epub_css
done

html_style="combo_html.css"
pdf_style="combo_pdf.css"
epub_style="combo_epub.css"

for md_file in $markdown; do
  # Only operate on text files with ".md" extension
  check_file
  if [ "$type" != "text/plain" ] || [ "${md_file: -3}" != ".md" ]; then
    printf "ERROR: $md_file not of type 'text/plain' or lacks '.md' extension\n"
  else
    # Perform conversions
    echo $md_file
    if [ $html == "true" ]; then
      printf "  --> ${md_file%md}html"
      to_html
      test_file "${md_file%md}html"
    fi
    if [ $pdf == "true" ]; then
      printf "  --> ${md_file%md}pdf"
      to_pdf
      test_file "${md_file%md}pdf"
    fi
    if [ $epub == "true" ]; then
      printf "  --> ${md_file%md}epub"
      to_epub
      test_file "${md_file%md}epub"
    fi
    if [ $docx == "true" ]; then
      printf "  --> ${md_file%md}docx"
      to_docx
      test_file "${md_file%md}docx"
    fi
  fi
done
