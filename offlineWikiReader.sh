clear

BOLD="\x1B[1m"
PLAIN="\x1B[0m"
INVERTED="\x1B[7m"

echo "####################################################"
echo "# Welcome to a very simple ${BOLD}offline Wiki Reader${PLAIN}!    #"
echo "#                              by Michael Hoereth  #"
echo "# Requirements:                                    #"
echo "#   * compressed wiki pages multistream download   #"
echo "#   * uncompressed wiki pages multistream index    #"
echo "#   * bash tools in order of usage:                #"
echo "#       * dd for extracting a binary file segment  #"
echo "#       * bzip2recover for recovering files        #"
echo "#       * bunzip2 for decompressing                #"
echo "#       * cat for concatenating files              #"
echo "#       * xmllint for extracting xml content       #"
echo "#       * pandoc for converting text files         #"
echo "####################################################"

if [ -z "${WIKI_DOWNLOADS}" ]
then   
   echo "WIKI_DOWNLOADS environment var must be set to a folder containing files like those:"
   echo "[lang]wiki-latest-pages-articles-multistream-index.txt (decompressed)"
   echo "[lang]wiki-latest-pages-articles-multistream.xml.bz2 (compressed)"
   echo "You can get such files from https://dumps.wikimedia.org"
   exit;
else
   echo "WIKI_DOWNLOADS environment is set to: ${BOLD}${WIKI_DOWNLOADS}${PLAIN}"
fi
read -p "Which Wiki? [en]? " LANG
LANG=${LANG:-en}
read -p "Page title (regular expression, :title$ for exact match)? " PATTERN
echo "Search results: (${INVERTED}Byte Offset${PLAIN} : ${INVERTED}Page ID${PLAIN} : ${INVERTED}Page Title${PLAIN})"
grep "${PATTERN}" -i ${WIKI_DOWNLOADS}/${LANG}wiki-latest-pages-articles-multistream-index.txt
read -p "Byte Offset? " OFFSET
read -p "Page ID? " ARTICLEID
dd skip=${OFFSET} count=1000000 if=${WIKI_DOWNLOADS}/${LANG}wiki-latest-pages-articles-multistream.xml.bz2 of=temp.bz2 bs=1 \
&& bzip2recover temp.bz2 \
&& rm temp.bz2 \
&& bunzip2 rec*temp.bz2 \
&& cat rec*temp > temp.xml \
&& rm rec*temp \
&& echo "<pages>" | cat - temp.xml > pages.xml \
&& rm temp.xml \
&& echo "</pages>" >> pages.xml \
&& xmllint --xpath "//id[text()='${ARTICLEID}']/.." pages.xml --recover > page.xml && echo "${BOLD}page.xml${PLAIN} with full page content has been extracted." \
&& rm pages.xml \
&& TITLE=$(xmllint --xpath "//title/text()" page.xml) \
&& echo "Page Title: ${INVERTED}${TITLE}${PLAIN}" \
&& xmllint --xpath "//text/text()" "page.xml" > text.md && echo "${BOLD}text.md${PLAIN} with page text has been extracted." \
&& pandoc text.md -o text.html && echo "${BOLD}text.html${PLAIN} has been created from text.md." \
&& echo "You can now open your preferred file with the app of your choice."
