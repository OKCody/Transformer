to_html(){
  pandoc $file -o ${file%.md}.html -c $html_style --mathjax -s;
}

to_pdf(){
  pandoc $file -o temp.html -c $pdf_style --mathjax -s;
  if [ $OSTYPE == "linux-gnu" ];
  then
    xvfb-run -a wkhtmltopdf --quiet --javascript-delay 1000 --user-style-sheet ../../print.css --run-script 'var elements = document.querySelectorAll("html,body,h1,h2,h3,h4,h5,h6,p,li,ol,pre,b,i,code,q,s"); for(var i = 0; i < elements.length; i++) { elements[i].style.letterSpacing = "0px"; }' temp.html ${file%md}pdf
  else
    wkhtmltopdf --quiet --javascript-delay 1000 --user-style-sheet ../../print.css --run-script 'var elements = document.querySelectorAll("html,body,h1,h2,h3,h4,h5,h6,p,li,ol,pre,b,i,code,q,s"); for(var i = 0; i < elements.length; i++) { elements[i].style.letterSpacing = "0px"; }' temp.html ${file%md}pdf
  fi
  rm temp.html
}

to_epub(){
    pandoc $file -o ${file%.md}.epub --epub-stylesheet $epub_style;
}

to_docx(){
    pandoc $file -o ${file%.md}.docx;
}

# ensure generated file actuall exists (-e) and is of non-zero size (-s)
test_file(){
  test_file=$1
  if [ -e $test_file ] && [ -s $test_file ]; then printf " ✓\n"; else printf " ✗\n"; fi
}
