# Transformer
Transformer is a Pandoc wrapper for generating HTML, PDF, EPUB, and DOCX files from markdown using user-supplied CSS and a few flags.

## Usage

```
$ bash transformer.sh -bdeps *.md example.css  
```

The command above will convert all Markdown files (*.md) into HTML (-b), DOCX (-d), EPUB (-e), and PDF (-p) files. Eventually the "-s" option will generate a standalone website from all files selected by *.md.  Included CSS files will be applied to the output filetypes that support CSS; HTML, EPUB, and PDF. Special CSS filenames are reserved for specific applications. "html.css", "epub.css", and "pdf.css" will each be applied to their respective output formats and only those output formats. This allows users to style each of those output files in unique ways. These format-specfic stylesheets will be applied prior to any other stylesheet.

### Stylesheet Order of Application

1. **base.css**
    - Default. Applied to all output files. Contains [normalize.css](https://github.com/dhg/Skeleton/blob/master/css/normalize.css) and [skeleton.css](https://github.com/dhg/Skeleton/blob/master/css/skeleton.css)
2. **base_html.css**, **base_epub.css**, **base_epub.css**
    - Default. Applied accordingly. Contain attributes that apply only to their respective file types; margins, padding, etc. May be overridden by styles sypplied by users in "html.css", "epub.css", "pdf.css"
3. **html.css**, **epub.css**, **pdf.css**
    - Applied accordingly. Should contain attributes that apply only to those respective file types; margins, padding, etc. 
4. **[other].css**
    - Applied to all output files. Should contain attributes intended to be applied to all output files; colors, fonts, etc.

### Example File Structure

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

### HTML

### EPUB

### DOCX

### PDF
