#!/bin/bash
#
# Publishes a set of .torrent files to the given feed ID using the name
# of the .torrent file as the display name for the torrent. Arguments:
#
# 	__FILE__ <feed_id> <.torrent>*
#
# Example:
#
# 	__FILE__ dead-1234-beef-5678-cafe first.torrent second.torrent third.torrent
#
# Make sure you have the following set prior to running:
#
#	export BITTORIOUS_BASE_URL=https://example.bittorious.com
#	export BITTORIOUS_AUTHENTICATION_TOKEN=DAE9081BED
#
# Author: Preston Lee <preston@asu.edu>
#

FEED_ID=$1
shift
for FILE in "$@"
do
	NAME=`basename $FILE .torrent`
	curl $BITTORIOUS_BASE_URL/feeds/$FEED_ID/torrents.json \
		-X POST \
		-F "authentication_token=$BITTORIOUS_AUTHENTICATION_TOKEN" \
		-F "torrent[name]=$NAME" \
		-F "torrent[file]=@$FILE"
	echo ''
done

echo -ne "Done!"
exit 0
