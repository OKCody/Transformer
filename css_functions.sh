make_html_css(){
  if [ ${file,,} == "html.css" ]; then
    mv html.css custom_html.css
    cat base.css base_html.css custom_html.css > combo_html.css
    html_style="html.css"
  else
    cat base.css base_html.css > combo_html.css
    html_style="html.css"
  fi
}

make_pdf_css(){
  if [ ${file,,} == "pdf.css" ]; then
    mv pdf.css custom_pdf.css
    cat base.css base_pdf.css custom_pdf.css > combo_pdf.css
    pdf_style="pdf.css"
  else
    cat base.css base_pdf.css > combo_pdf.css
    pdf_style="pdf.css"
  fi
}

make_epub_css(){
  if [ ${file,,} == "epub.css" ]; then
    mv epub.css custom_epub.css
    cat base.css base_epub.css custom_epub.css > combo_epub.css
    epub_style="epub.css"
  else
    cat base.css base_epub.css > combo_epub.css
    epub_style="epub.css"
  fi
}
