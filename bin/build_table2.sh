#!/usr/bin/bash
# I use a version that is 0.0001.YYMMDD which is nice for sorting.
VERS=0.001.170907;  #Always good to version your edits.  Usually, start with 0.001.
LICENSE='The MIT License (MIT)
Copyright (c) 2017 David W. Craig
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.'; #MIT License
echo "Build_Table.sh $VERS"
# This part is a section that I cut and paste a lot, which creates a command line help and instructions

#########################
# Command Line Options
#########################

URL="http://ftp.ensembl.org/pub/release-75/gtf/homo_sapiens";
# Define a function called usage that we will call when things go wrong
usage() { echo "Usage: $0 -f Homo_sapiens.GRCh37.75.gtf.gz [-l]" 1>&2; exit 1; }
# Don't obsess about symantics, this is just to get used things and also emphasize that we often copy/paste
# Lets loop through the options. This is a standard loop, but just accept it for now
while getopts ":f:l" o; do
#  A case is an if/then with several conditions
    case "${o}" in
        f)
            f=${OPTARG}
            ;;
        l)
            echo $LICENSE;exit 1;
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))
# A candition to check if variable exists
if [ -z "${f}" ]; then
    usage
fi

### END of COMMAND LINE OPTIONS

# Lets check if the file exists, and then go get it if it doesn't exist
# Lets first ccreate the uncompressed expected filename when the ".gz" is gone
GTF=$(echo $f | sed 's/.gz$//');
# If neither gz nor the uncompressed gtf exists, go and get it
if [ ! -f $f ] && [ ! -f $GTF ]; then
    echo "Retreiving f = $URL/${f}"
    $(wget $URL/${f});
fi
# If we need to unzip it, lets doe it
if [ ! -f $GTF ]; then
   echo "Unzipping";
   $(gunzip $f);
   echo "file $f is unzipped as and should be ${GTF}"
fi
(awk '$3 ~ /gene/ { print $2,$1,$4,$5}' Homo_sapiens.GRCh37.75.gtf | sed 's/ /,/g' | sed -e '1ifeature,chr,start,end'> gene_dist_head.csv)
exit 0;
