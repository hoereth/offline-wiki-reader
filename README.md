# Offline Wiki Reader #

A shell script for searching Wikipedia index files and extracting single page content straight from the related compressed Wikipedia XML dumps. The key feature is that it operates on the compressed content. Wikipedia offers "byte index" files along every XML dump to make this possible.

This is a very low level approach, but it definitely enables you to occasionally lookup articles in your own local encylopedia.

# Getting started #

Make sure you have all required commands installed before running the script:
  * dd
  * bzip2recover
  * bunzip2
  * cat
  * xmllint
  * pandoc

Download a Wikipedia multistream dump + its index file in any number of languages. One pair of files would need to look like this:

  * [lang]wiki-latest-pages-articles-multistream-index.txt (decompressed)
  * [lang]wiki-latest-pages-articles-multistream.xml.bz2 (compressed)

You can store those files anywhere on your local system, you just need to set an environment variable WIKI_DOWNLOADS to the containing folder, before you run the [offlineWikiReader.sh](offlineWikiReader.sh) script.
