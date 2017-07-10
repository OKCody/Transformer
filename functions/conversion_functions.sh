to_html(){
  pandoc $md_file -o $output/${out_file%.md}.html -c $html_style --mathjax="../$mathjax" -s
}

# Contains reference to ../../print.css which does not yet exist in this implementation :(
to_pdf(){
  pandoc $md_file -o $output/temp.html -c $pdf_style --mathjax="../$mathjax" -s
  if [ $OSTYPE == "linux-gnu" ]; then         # Frame buffer is necessary for running on Linux OSs ...I think. Definitely necessary on Ubuntu, but not OSX.
    xvfb-run -a wkhtmltopdf --quiet --javascript-delay 2000 --user-style-sheet ../../print.css --run-script 'var elements = document.querySelectorAll("html,body,h1,h2,h3,h4,h5,h6,p,li,ol,pre,b,i,code,q,s"); for(var i = 0; i < elements.length; i++) { elements[i].style.letterSpacing = "0px"; }' $output/temp.html $output/${out_file%md}pdf
  else
    wkhtmltopdf --quiet --javascript-delay 2000 --user-style-sheet ../../print.css --run-script 'var elements = document.querySelectorAll("html,body,h1,h2,h3,h4,h5,h6,p,li,ol,pre,b,i,code,q,s"); for(var i = 0; i < elements.length; i++) { elements[i].style.letterSpacing = "0px"; }' $output/temp.html $output/${out_file%md}pdf
  fi
  rm $output/temp.html
}

to_epub(){
    pandoc $md_file -o $output/${out_file%.md}.epub --epub-stylesheet $epub_style -t epub3
}

to_docx(){
    pandoc $md_file -o $output/${out_file%.md}.docx
}
