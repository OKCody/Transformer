to_html(){
  pandoc $md_file -o ${md_file%.md}.html -c $html_style --mathjax -s;
}

to_pdf(){
  pandoc $md_file -o temp.html -c $pdf_style --mathjax -s;
  if [ $OSTYPE == "linux-gnu" ]; then         # Frame buffer is necessary for running on Linux OSs ...I think. Definitely necessary on Ubuntu, but not OSX.
    xvfb-run -a wkhtmltopdf --quiet --javascript-delay 2000 --user-style-sheet ../../print.css --run-script 'var elements = document.querySelectorAll("html,body,h1,h2,h3,h4,h5,h6,p,li,ol,pre,b,i,code,q,s"); for(var i = 0; i < elements.length; i++) { elements[i].style.letterSpacing = "0px"; }' temp.html ${md_file%md}pdf
  else
    wkhtmltopdf --quiet --javascript-delay 1000 --user-style-sheet ../../print.css --run-script 'var elements = document.querySelectorAll("html,body,h1,h2,h3,h4,h5,h6,p,li,ol,pre,b,i,code,q,s"); for(var i = 0; i < elements.length; i++) { elements[i].style.letterSpacing = "0px"; }' temp.html ${md_file%md}pdf
  fi
  rm temp.html
}

to_epub(){
    pandoc $md_file -o ${md_file%.md}.epub --epub-stylesheet $epub_style;
}

to_docx(){
    pandoc $md_file -o ${md_file%.md}.docx;
}
