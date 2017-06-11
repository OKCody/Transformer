source functions.sh

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

  b ) echo "generating HTML..."; html="true";;
  d ) echo "generating DOCX..."; docx="true";;
  e ) echo "generating EPUB..."; epub="true";;
  p ) echo "generating  PDF...";  pdf="true";;
  s ) echo "generating Site..."; site="true";;
  \? ) usage ;;
  esac
done

html_style="example_html.css"
pdf_style="example_pdf.css"
epub_style="example_epub.css"

for file in *.css
do
  if [ ${file,,} == "html.css" ]; then
    html_style="html.css"
  else
    cat base.css example_html.css > html.css
    html_style="html.css"
  fi
  if [ ${file,,} == "pdf.css" ]; then
    pdf_style="pdf.css"
  fi
  if [ ${file,,} == "epub.css" ]; then
    epub_style="pdf.css"
  fi
done

for file in *.md
do
  if [ $html == "true" ]; then
    to_html
    echo $file "--> ${file%md}html"
  fi
  if [ $pdf == "true" ]; then
    to_pdf
    echo $file "--> ${file%md}pdf"
  fi
  if [ $epub == "true" ]; then
    to_epub
    echo $file "--> ${file%md}epub"
  fi
  if [ $docx == "true" ]; then
    to_docx
    echo $file "--> ${file%md}docx"
  fi
done
