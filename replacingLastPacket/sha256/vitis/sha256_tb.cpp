#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "sha256.hpp"
#include "sha256_impl.hpp"



int main(void) {
	SHA256_CTX ctx;                   // used to generate software hashes for validation

	hls::stream<AXIS_DATA  > inStream_t;
	hls::stream<AXIS_DATA  > outStream_t;

	printf("START\n\n");
	AXIS_DATA dataStream_t;


	  dataStream_t.tdata = "0x42414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141";
	  dataStream_t.tkeep=-1;
		dataStream_t.tlast=0;
		  inStream_t.write(dataStream_t);dataStream_t.tdata = "0x41414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141";

			dataStream_t.tlast=1;
		  inStream_t.write(dataStream_t);
		  std::cout<<"INPUT: data!"<<dataStream_t.tdata<<std::endl;

	sha256(inStream_t,outStream_t);

	do {
		outStream_t.read(dataStream_t);
		std::cout<<" data: "<<std::hex<<dataStream_t.tdata<<" keep: "<<dataStream_t.tkeep<<" tlast: "<<dataStream_t.tlast<<std::endl;
	}while(!outStream_t.empty());
	std::cout<<"\nEND\n";

	return 0;
}
