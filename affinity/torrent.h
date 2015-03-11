#ifndef TORRENT
#define TORRENT

class Torrent {
	
	float percent_per_client;
	int pieces;
	
	public:

	Torrent (int num_pieces, float percent);
	// virtual ~Torrent ();
	
	bool * pieces_for_client_affinity(int client);

	private:

};

#endif
