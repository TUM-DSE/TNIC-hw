#include "main.hpp"

#include <iostream>

void caesar(hls::stream<AXIS_DATA>& input, hls::stream<AXIS_DATA >& output)
{

#pragma HLS INTERFACE ap_ctrl_none port=return // removes handshake
#pragma HLS interface axis register port = input
#pragma HLS interface axis register port = output
#pragma HLS AGGREGATE variable=input bit
#pragma HLS AGGREGATE variable=output bit
	AXIS_DATA currWord;
	hls::stream<AXIS_DATA> copy;
	static int cnt = 0;
	do{
		input.read(currWord);

		ap_uint<AXI_DATA_BITS> out = 0;
		//   for (int i=0;i<WIDTH/8;++i) {
#pragma HLS PIPELINE
		out = currWord.tdata;
#define BYTE_WIDTH 8
		for (int i = 0; i < WIDTH/8; ++i) {
			currWord.tdata(BYTE_WIDTH * (i + 1) - 1, BYTE_WIDTH * i) = (i+1);
		}
			if (currWord.tlast) {
				cnt++;
				std::cout << cnt << " last word\n";
			}
		// }
		//   currWord.tdata = out;
		copy.write(currWord);
		currWord.tlast = 0;
		currWord.tdata = out;
		output.write(currWord);
	} while (!input.empty());

	while (!copy.empty()) {
		copy.read(currWord);


		output.write(currWord);
	}
}
