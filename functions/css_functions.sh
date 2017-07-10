make_default_css(){
  cat $base $base_html $example > $output/html.css
  html_style="$output/html.css"
  echo $html_style
  cat $base $base_pdf $example > $output/pdf.css
  pdf_style="$output/pdf.css"
  echo $pdf_style
  cat $base $base_epub $example > $output/epub.css
  epub_style="$output/epub.css"
  echo $epub_style
}

make_html_css(){
  if [ ${css_file,,} == "html.css" ]; then
    mv html.css custom_html.css
    cat $base $base_html custom_html.css > $output/html.css
    html_style="$output/html.css"
    echo "Applying custom html.css"
  else
    cat $base $base_html $css_file > $output/html.css
    html_style="$output/html.css"
  fi
}

make_pdf_css(){
  if [ ${css_file,,} == "pdf.css" ]; then
    mv pdf.css custom_pdf.css
    cat $base $base_pdf custom_pdf.css > $output/pdf.css
    pdf_style="$output/pdf.css"
    echo "Applying custom pdf.css"
  else
    cat $base $base_pdf $css_file > $output/pdf.css
    html_style="$output/pdf.css"
  fi
}

make_epub_css(){
  if [ ${css_file,,} == "epub.css" ]; then
    mv epub.css custom_epub.css
    cat $base $base_epub custom_epub.css > $output/epub.css
    epub_style="$output/epub.css"
    echo "Applying custom epub.css"
  else
    cat $base $base_epub $css_file > $output/epub.css
    html_style="$output/epub.css"
  fi
}
