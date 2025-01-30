#include <iostream>
#include "main.hpp"



const int BYTE_WIDTH = sizeof(uint64_t);
#define NUM_OF_SAMPLES 3
const int MAX_WORDS = 1;

void serializeData(ap_uint<AXI_DATA_BITS>& tdata, uint8_t (&serializedData)[((WIDTH / BYTE_WIDTH) * MAX_WORDS)], int sample) {
    for (int i = 0; i < (WIDTH / BYTE_WIDTH); i++) {
        ap_uint<BYTE_WIDTH> byte = tdata(BYTE_WIDTH * (i + 1) - 1, BYTE_WIDTH * i);
        serializedData[i + sample*(WIDTH / BYTE_WIDTH)] = byte;
	std::cout << byte << " ";
    }
    std::cout << "\n";
}


int main() {
	int err = 0;
	hls::stream<AXIS_DATA  > inStream_t;
	hls::stream<AXIS_DATA  > outStream_t;
	AXIS_DATA   dataStream_t;
	AXIS_DATA   dataStream_t2;

	printf("START\n\n");
	for(int i=0;i<NUM_OF_SAMPLES;i++){
		dataStream_t.tdata = 5;
		dataStream_t.tkeep= 10;


		if(i<NUM_OF_SAMPLES-1){
			dataStream_t.tlast=0;
		} else {
			dataStream_t.tlast=1;
		}
		inStream_t.write(dataStream_t);
	}

	caesar(inStream_t, outStream_t);
	uint8_t in_data[(WIDTH / BYTE_WIDTH) * MAX_WORDS];
	auto idx = 0, cnt = 0;
	do {
		outStream_t.read(dataStream_t2);
		if (dataStream_t2.tlast) {
		//	std::cout << "last \n";
			cnt++;
		}
		// std::cout <<" data: "<<dataStream_t2.tdata<<" keep: "<<dataStream_t2.tkeep<<std::endl;
		serializeData(dataStream_t2.tdata, in_data, cnt);
		idx++;
	}while(!outStream_t.empty());

	std::cout << "\n>> \n";
	std::cout << "nb words=" << cnt << "\n";
#if 0
	for (auto i = 0ULL; i < (WIDTH / BYTE_WIDTH) * (cnt+1); i++) {
		std::cout << static_cast<int>(in_data[i]) << " ";
	}
#endif
	std::cout << "\n>> \n";
	std::cout<<"\nEND\n";
}
