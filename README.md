# Transformer

Transformer is a [Pandoc](https://pandoc.org) wrapper for generating HTML, PDF, EPUB, and DOCX files from [Markdown](https://daringfireball.net/projects/markdown/syntax) using user-supplied CSS and a few flags. 

Intentions are that this wrapper can be implemented on a server and called from a web interface so that those unfamiliar with command line interfaces can use Pandoc without learning or installing it.  This wrapper can also be used locally as a tool that simplifys common Pandoc use cases that might be performed repetitvely. 

## Use

```
$ bash transformer.sh -bdeps *.md example.css  
```

The command above will convert all Markdown files (*.md) into HTML (-b), DOCX (-d), EPUB (-e), and PDF (-p) files. Eventually the "-s" option will generate a standalone website from all files selected by *.md.  Included CSS files will be applied to the output filetypes that support CSS; HTML, EPUB, and PDF. Special CSS filenames are reserved for specific applications. "html.css", "epub.css", and "pdf.css" will each be applied to their respective output formats and only those output formats. This allows users to style each of those output files in unique ways. These format-specfic stylesheets will be applied prior to any other stylesheet.

`$ bash transformer.sh -h` will display and explain these options.

### Stylesheet Order of Application

1. **base.css**
    - Default. Applied to all output files. Contains [normalize.css](https://github.com/dhg/Skeleton/blob/master/css/normalize.css) and [skeleton.css](https://github.com/dhg/Skeleton/blob/master/css/skeleton.css)
2. **base_html.css**, **base_epub.css**, **base_epub.css**
    - Default. Applied accordingly. Contain attributes that apply only to their respective file types; margins, padding, etc. May be overridden by styles sypplied by users in "html.css", "epub.css", "pdf.css"
3. **html.css**, **epub.css**, **pdf.css**
    - Applied accordingly. Should contain attributes that apply only to those respective file types; margins, padding, etc. 
4. **[other].css**
    - Applied to all output files. Should contain attributes intended to be applied to all output files; colors, fonts, etc.

### Example Input File Structure

```
example_book/
│   chapter1.md
│   chapter2.md
│   chapter3.md
│   html.css
│   epub.css
│   pdf.css
│   general.css
│
└───images/
│   │   image1.jpg
│   │   image2.gif
│   │   image3.png
```
## Implementation

The functionality of this wrapper may be distilled to the following Pandoc calls. For detailed explanation of each of these consult [Pandoc's documentation](http://pandoc.org/MANUAL.html). Of these, little explanation is required except perhaps for PDF generation. 

### HTML

```
pandoc $md_file -o $output/${md_file%.md}.html -c $html_style --mathjax="../$mathjax" -s
```

### EPUB

```
pandoc $md_file -o $output/${md_file%.md}.epub --epub-stylesheet $epub_style -t epub3
```

### DOCX

```
pandoc $md_file -o $output/${md_file%.md}.docx
```

### PDF

```
pandoc $md_file -o $output/temp.html -c $pdf_style --mathjax="../$mathjax" -s
  if [ $OSTYPE == "linux-gnu" ]; then         # Frame buffer is necessary for running on Linux OSs ...I think. Definitely necessary on Ubuntu, but not OSX.
    xvfb-run -a wkhtmltopdf --quiet --javascript-delay 2000 --user-style-sheet ../../print.css --run-script 'var elements = document.querySelectorAll("html,body,h1,h2,h3,h4,h5,h6,p,li,ol,pre,b,i,code,q,s"); for(var i = 0; i < elements.length; i++) { elements[i].style.letterSpacing = "0px"; }' $output/temp.html $output/${md_file%md}pdf
  else
    wkhtmltopdf --quiet --javascript-delay 2000 --user-style-sheet ../../print.css --run-script 'var elements = document.querySelectorAll("html,body,h1,h2,h3,h4,h5,h6,p,li,ol,pre,b,i,code,q,s"); for(var i = 0; i < elements.length; i++) { elements[i].style.letterSpacing = "0px"; }' $output/temp.html $output/${md_file%md}pdf
  fi
  rm $output/temp.html
```
[wkhtmltopdf](https://wkhtmltopdf.org/) is being used to generate PDFs. Markdown files are first converted to HTML (temp.html) as an intermediary step prior to being passed to wkhtmltopdf. In this step Mathjax is used to render any equations prior to generating a PDF. Importantly, the wkhtmltopdf option "--javascript-delay 2000" provides MathJax 2000ms to render equations prior to generating a PDF of temp.html. Also worth mentioning is what appears to be a bug in wkhtmltopdf with regard to how it handles the letter-spacing CSS attribute. Any other value seems to be exaggerated when processed with wkhtmltopdf and generates unintended results. In order to porevent this from happening, "--run-script" is used to execute a tiny bit of Javascript to set letter-spacing to 0px for all elements that might contain a non-zero value. 

wkhtmltopdf requires a frame buffer when running on Ubuntu. For this, [xvfb](https://www.x.org/archive/X11R7.7/doc/man/man1/Xvfb.1.xhtml) is used. Becasue this is the only difference between using this wrapper on OSX, a check is performed to determine whether or not xvfb is necessary.

Finally, temp.html is deleted as it is only inteded to be use intermediarily. 

**As of Chrome 59 (released May 2017), [Chrome can be run headless](https://developers.google.com/web/updates/2017/04/headless-chrome). Using the "--print-to-pdf" option Chrome can now generate PDFs from the command line! I intend to replace wkhtmltopdf with Chrome for generating PDFs as I expect that it to be more reliable, better supported, and better in many other ways. For example, early tests of --print-to-pdf seem to indicate that Chrome waits until Javascript has finished executing before generating a PDF. wkhtmltopdf requires a static amount of time to be specified. In order to accomodate large documents this value must be large, but not too large so as to annoy users. Also, I expect Chrome to not have the same letter-spacing issuse as wkhtmltopdf has. Additionally, a Chrome will not require xvfb on Ubuntu eliminating that complication.**

## Output

All generated files will be written to "output/". Note that file types that reference images will, of course, require vaild paths to those images likely requiring "images/" and its contents to be moved into "output/".

### Example Ouput File Structure

```
example_book/
│   chapter1.md
│   chapter2.md
│   chapter3.md
│   html.css
│   epub.css
│   pdf.css
│   general.css
│
└───images/
│   │   image1.jpg
│   │   image2.gif
│   │   image3.png
│
└───output/
│   │   chapter1.html
│   │   chapter1.epub
│   │   chapter1.docx
│   │   chapter1.pdf
│   │   chapter2.html
│   │   chapter2.epub
│   │   chapter2.docx
│   │   chapter2.pdf
│   │   chapter3.html
│   │   chapter3.epub
│   │   chapter3.docx
│   │   chapter3.pdf
│   │   html.css
│   │   epub.css
│   │   pdf.css
│   │   general.css
```

## Dependencies

- [Pandoc](https://pandoc.org) `$ brew install pandoc` or `$ apt-get install pandoc`

**Soon to be replaced by [Chrome 59](https://developers.google.com/web/updates/2017/04/headless-chrome):**

- [wkhtmltopdf](https://wkhtmltopdf.org/) `$ brew install wkhtmltopdf` or `$ apt-get install wkhtmltopdf`

- [xvfb](https://www.x.org/archive/X11R7.7/doc/man/man1/Xvfb.1.xhtml) `$ apt-get install wvfb`
