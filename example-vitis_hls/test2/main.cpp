#include "main.hpp"

#include <iostream>


#include <ap_int.h>

void merge_byte(ap_uint<512>& data, int byteIndex, ap_uint<8> modifiedByte) {
    const int byteWidth = 8;  // Width of each byte

    // Clear the bits of the target byte
    ap_uint<512> clearMask = ~(ap_uint<512>(0xFF) << (byteIndex * byteWidth));
    data &= clearMask;

    // Set the modified byte into the target byte
    ap_uint<512> modifiedByteShifted = (static_cast<ap_uint<512>>(modifiedByte) << (byteIndex * byteWidth));
#if 0
    std::cout << modifiedByte << " idx:" << byteIndex << "\n";
    for (int i  = 0; i < 64; i++) {
        ap_uint<8> byte = modifiedByteShifted(byteWidth* (i + 1) - 1, byteWidth * i);
        std::cout << byte << " ";
    }
    std::cout << "\n";
#endif
    data |= modifiedByteShifted;
#if 0
    for (int i = 0; i < 64; i++) {
        ap_uint<8> byte = data(byteWidth* (i + 1) - 1, byteWidth * i);
        std::cout << byte << " ";
    }
    std::cout << "\n";
#endif

}


#define BUFFER_SIZE 4
void caesar(hls::stream<AXIS_DATA>& input, hls::stream<AXIS_DATA >& output)
{

#pragma HLS INTERFACE ap_ctrl_none port=return // removes handshake
#pragma HLS interface axis register port = input
#pragma HLS interface axis register port = output
#pragma HLS AGGREGATE variable=input bit
#pragma HLS AGGREGATE variable=output bit
	AXIS_DATA currWord;
	AXIS_DATA buffer[BUFFER_SIZE];
#pragma HLS ARRAY_PARTITION dim=1 type=complete variable=buffer

	int k =0;
	do{
		const int byteWidth = 8;  // Width of each byte
		input.read(currWord);

		buffer[k] = currWord;

		for (int idx = 0; idx < 64; idx++) { 
			int byteIndex = idx;
			// Extract the byte from the ap_uint<512>
			ap_uint<byteWidth> byte = (buffer[k].tdata >> (byteIndex * byteWidth)) & 0xFF;
			// std::cout << byte << "\n";

			// Add the constant value to the byte
			byte += 5;
			// std::cout << byte << "\n";
			merge_byte(buffer[k].tdata, byteIndex, byte);
#if 0
			// Merge the modified byte back into the ap_uint<512>
			buffer[k].tdata &= ~(ap_uint<512>(0xFF) << (byteIndex * byteWidth));
			buffer[k].tdata |= (byte << (byteIndex * byteWidth));
#endif

			// Extract the byte from the ap_uint<512>
			ap_uint<byteWidth> byte2 = (buffer[k].tdata >> (idx * byteWidth)) & 0xFF;

			// Convert the byte to an integer and print it
			// std::cout << "Byte " << idx << ": " << static_cast<unsigned int>(byte2) << std::endl;
		}


		// buffer[k].tdata = buffer[k].tdata + 3;

		k++;
		if (currWord.tlast == 1) {  // last

			for (int j=0; j < k; j++) {
				output.write(buffer[j]);
			//	std::cout << "j1=" << j << " " <<  buffer[j].tdata << " \n";
			}
			k=0; // do not allow for the next if statement
		}

		if (k == BUFFER_SIZE) {
			for (int j=0; j < k; j++) {
				output.write(buffer[j]);
			//	std::cout << "j2=" << j << " " <<  buffer[j].tdata << " \n";
			}
			k=0;
		}
	} while (!input.empty());
}


#if 0
void caesar(hls::stream<AXIS_DATA>& input, hls::stream<AXIS_DATA >& output)
{

#pragma HLS INTERFACE ap_ctrl_none port=return // removes handshake
#pragma HLS interface axis register port = input
#pragma HLS interface axis register port = output
#pragma HLS AGGREGATE variable=input bit
#pragma HLS AGGREGATE variable=output bit
	AXIS_DATA currWord;
	hls::stream<AXIS_DATA> copy;
	int cnt = 0;
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
#endif
