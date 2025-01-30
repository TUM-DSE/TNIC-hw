#include "sha256.hpp"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>  // for overloaded memcpy() function

#include<iostream>

void sha256(hls::stream<AXIS_DATA>& input,
			hls::stream<AXIS_DATA >& output) {
	   // output: hash digest of input data

// Interface definitions
#pragma HLS INTERFACE ap_ctrl_none port=return // removes handshake
#pragma HLS interface axis register port = input
#pragma HLS interface axis register port = output
#pragma HLS AGGREGATE variable=input bit
#pragma HLS AGGREGATE variable=output bit

	// We work on buffers of up to 64 bytes - hard-coded into SHA256 algorithm

	// TODO
	// change it later to the number of bits that are tkeep
	AXIS_DATA currWord;
	AXIS_DATA z;
	z.tdata =0;
	do {
		input.read(currWord);
		if(currWord.tlast != 1) {
			z.tdata += currWord.tdata;
		}
	}while(currWord.tlast != 1);



	AXIS_DATA outWord;
	outWord.tlast=1;
	outWord.tkeep = currWord.tkeep;
	outWord.tid = currWord.tid;
	outWord.tdata = z.tdata;
	output.write(outWord);

}

void sha256_verify(hls::stream<AXIS_DATA>& input,
		hls::stream<ap_uint<1> >& output) {
	   // output: hash digest of input data

// Interface definitions
#pragma HLS INTERFACE ap_ctrl_none port=return // removes handshake
#pragma HLS interface axis register port = input
#pragma HLS interface axis register port = output
#pragma HLS AGGREGATE variable=input bit
#pragma HLS AGGREGATE variable=output bit


	AXIS_DATA currWord;
	AXIS_DATA z;
	z.tdata =0;
	do {
		input.read(currWord);
		if(currWord.tlast != 1) {
			z.tdata += currWord.tdata;
		}
	}while(currWord.tlast != 1);
	ap_uint<1> result = 0;
	if (currWord.tdata != z.tdata) {
		result = 1;
	}
	output.write(result);

}
