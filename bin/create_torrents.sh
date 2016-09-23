#!/bin/bash
#
# Creates a .torrent for every directory/file provided, writing all output files
# to a ./torrents directory under the current working directory.
#
# Make sure you have `mktorrent` installed and have the following
# environment variables set in your ~/.bash_profile prior to running:
#
#	export BITTORIOUS_BASE_URL=https://example.bittorious.com
#	export BITTORIOUS_AUTHENTICATION_TOKEN=DAE9081BED
#
# Author: Preston Lee <preston@asu.edu>
#

mkdir ./torrents > /dev/null 2>&1

for NAME in "$@"
do
    # echo "$NAME"
	rm ./torrents/$NAME.torrent > /dev/null 2>&1
	# Hard-coding piece size to 4MiB, 4x threads, no date, private
	mktorrent -l 22 -t 4 -d -p -c 'Created for BitTorious.' -a $BITTORIOUS_BASE_URL/announce -o ./torrents/$NAME.torrent $NAME
done

echo -ne "Done!"
exit 0
