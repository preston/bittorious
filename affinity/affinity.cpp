/**
 * Copyright © 2015 Preston Lee. All rights reserved.
 *
 * This "piece affinity" reference implementation provides the algorithm
 * used by the BitTorious Volunteer application. Please consult this code
 * when developing applications intended to be compatible with the BitTorious Portal.
 *
 * Portal: https://github.com/preston/bittorious
 * Live Demonstration: https://try.bittorious.com
 */


#include <iostream>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "torrent.h"
// The number of possible affinities depends on the number of 
 
 
using namespace std;

static const char * opt_def = "t:p:c:";

void print_matrix(const int pieces, const int clients, bool ** matrix) {
	for(size_t c = 0; c < clients; ++c)
	{
		cout << "Client #" << c << " [";
		for(size_t p = 0; p < pieces; ++p)
		{
			cout << matrix[c][p];
			if(p < pieces - 1) {
				cout << ", ";
			}
		}
		cout << ']' << endl;
	}
}
void run(const int pieces, const float percent_per_client, const int clients) {
	cout << "Simulating:" << "\n\tPieces: " << pieces << "\n\tPercent Per Client: " << percent_per_client << "\n\tClients: " << clients << "\n\n";
	
	Torrent * t1 = new Torrent(pieces, percent_per_client);
	
	// For simplicity we make the client number the affinity number.
	bool ** matrix = new bool *[clients];
	for(size_t c = 0; c < clients; ++c)
	{
		matrix[c] = t1->pieces_for_client_affinity(c);
	}
	print_matrix(pieces, clients, matrix);
	delete[] matrix;
	cout << "Done!\n";
}


void print_help(const char * name) {
	cout << "\n\nClient affinity algorithm demonstration.\nCopyright © 2013 Preston Lee. All rights reserved." << endl;
	cout << 
	cout << "\nUsage:\n\n\t" << name << " -t <total_torrent_pieces> -p <percent_per_client>\n\n";
	cout << "Examples:\n\t";
	cout << name << " -t 42 -p 0.25 -c 7 # Small torrent. \n\t";
	cout << name << " -t 1000 -p 0.40 -c 7 # Medium-size torrent with small number of clients.\n\t";
	cout << name << " -t 1 -p 0.10 -c 7 # Edge case with only one piece.\n\n";
}

int main (int argc, char  *argv[])
{
	int code = EXIT_SUCCESS;
	int pieces = 0;
	int clients = 0;
	float percent_per_client = 0.0;
	
	extern char *optarg;
	extern int optind, optopt;
  
	int c;
	int errflg;
	while ((c = getopt(argc, argv, opt_def)) != -1) {
	    switch (c) {
	    case 't':
				pieces = atoi(optarg);
	      break;
	    case 'p':
				percent_per_client = atof(optarg);
				break;
			case 'c':
				clients = atoi(optarg);
				break;
	    case '?':
	                fprintf(stderr, "Unrecognised option: -%c\n", optopt);
	        errflg++;
	    }
	}
	if(pieces <= 0) {
		fprintf(stderr, "Total torrent pieces be at least 1: -%c\n", optopt);
		errflg++;
		code = EXIT_FAILURE;					
	}
	if(percent_per_client <= 0.0 || percent_per_client > 1.0) {
		fprintf(stderr, "Percent must be between 0.0 (exclusive) and 1.0 (inclusive): -%c\n", optopt);
		errflg++;
		code = EXIT_FAILURE;
	}
	if(clients <= 0) {
		fprintf(stderr, "Number of clients must be at least 1: -%c\n", optopt);
		errflg++;
		code = EXIT_FAILURE;
	}
	
	if (errflg) {
		print_help(argv[0]);
	} else {
		run(pieces, percent_per_client, clients);
	}
	// std::cout << PIECES << ' ' << COMPLETION_PERCENT << ' ' << PIECES_PER_CLIENT << endl;
		

	return code;
}

