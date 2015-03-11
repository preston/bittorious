#include "torrent.h"

#include <math.h>


Torrent::Torrent (int num_pieces, float percent) {
	pieces = num_pieces;
	percent_per_client = percent;
}

bool * Torrent::pieces_for_client_affinity(int affinity) {
	bool * affinities = new bool[pieces];
	int start = affinity % pieces;
	int stop = ceil(start + (percent_per_client * pieces));
	for(int i = 0; i < this->pieces; ++i)
	{
		affinities[i] = 
			(i >= start && i <= stop)
			||
			(pieces <= stop && i <= stop - pieces);
	}
	return affinities;
}
