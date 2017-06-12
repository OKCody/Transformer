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
Usage: ideal_textbook_creator [-b] [-p] [-e] [-d] [-s]

    -b generates HTML document (body only)
    -d generates DOCX document
    -e generates EPUB document
    -p generates PDF  document
    -s generates stand-alone website

    -h displays this information

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
  \? ) usage ;;
  esac
done

for file in *.css
do
  make_html_css
  make_pdf_css
  make_epub_css
done

html_style="combo_html.css"
pdf_style="combo_pdf.css"
epub_style="combo_epub.css"

for file in *.md
do
  echo $file
  if [ $html == "true" ]; then
    printf "  --> ${file%md}html"
    to_html
    test_file "${file%md}html"
  fi
  if [ $pdf == "true" ]; then
    printf "  --> ${file%md}pdf"
    to_pdf
    test_file "${file%md}pdf"
  fi
  if [ $epub == "true" ]; then
    printf "  --> ${file%md}epub"
    to_epub
    test_file "${file%md}epub"
  fi
  if [ $docx == "true" ]; then
    printf "  --> ${file%md}docx"
    #to_docx
    test_file "${file%md}docx"
  fi
done
