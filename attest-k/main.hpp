#include <ap_axi_sdata.h>
#include <ap_int.h>
#include <hls_stream.h>
#include <stdio.h>
// Monocypher version 4.0.1
//
// This file is dual-licensed.  Choose whichever licence you want from
// the two licences listed below.
//
// The first licence is a regular 2-clause BSD licence.  The second licence
// is the CC-0 from Creative Commons. It is intended to release Monocypher
// to the public domain.  The BSD licence serves as a fallback option.
//
// SPDX-License-Identifier: BSD-2-Clause OR CC0-1.0
//
// ------------------------------------------------------------------------
//
// Copyright (c) 2017-2019, Loup Vaillant
// All rights reserved.
//
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the
//    distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// ------------------------------------------------------------------------
//
// Written in 2017-2019 by Loup Vaillant
//
// To the extent possible under law, the author(s) have dedicated all copyright
// and related neighboring rights to this software to the public domain
// worldwide.  This software is distributed without any warranty.
//
// You should have received a copy of the CC0 Public Domain Dedication along
// with this software.  If not, see
// <https://creativecommons.org/publicdomain/zero/1.0/>

#ifndef MONOCYPHER_H
#define MONOCYPHER_H

#include <stddef.h>
#include <stdint.h>

#ifdef MONOCYPHER_CPP_NAMESPACE
namespace MONOCYPHER_CPP_NAMESPACE {
#elif defined(__cplusplus)
extern "C" {
#endif

// Incremental interface
typedef struct {
  // Do not rely on the size or contents of this type,
  // for they may change without notice.
  uint64_t hash[8];
  uint64_t input_offset[2];
  uint64_t input[16];
  size_t input_idx;
  size_t hash_size;
} crypto_blake2b_ctx;

void crypto_blake2b_init(crypto_blake2b_ctx *ctx, size_t hash_size);
void crypto_blake2b_keyed_init(crypto_blake2b_ctx *ctx, size_t hash_size,
                               const uint8_t *key, size_t key_size);
void crypto_blake2b_update(crypto_blake2b_ctx *ctx, const uint8_t *message,
                           size_t message_size);
void crypto_blake2b_final(crypto_blake2b_ctx *ctx, uint8_t *hash);

// Signatures
// ----------

// EdDSA with curve25519 + BLAKE2b
void crypto_eddsa_key_pair(uint8_t secret_key[64], uint8_t public_key[32],
                           uint8_t seed[32]);
void crypto_eddsa_sign(uint8_t signature[64], const uint8_t secret_key[64],
                       const uint8_t *message, size_t message_size);
int crypto_eddsa_check(const uint8_t signature[64],
                       const uint8_t public_key[32], const uint8_t *message,
                       size_t message_size);

#ifdef __cplusplus
}
#endif

#endif // MONOCYPHER_H

//
//  SHA-256 implementation, Mark 2
//
//  Copyright (c) 2010,2014 Literatecode, http://www.literatecode.com
//  Copyright (c) 2022 Ilia Levin (ilia@levin.sg)
//
//  Permission to use, copy, modify, and distribute this software for any
//  purpose with or without fee is hereby granted, provided that the above
//  copyright notice and this permission notice appear in all copies.
//
//  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
//  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
//  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
//  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
//  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
//  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
//  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
//

#ifndef SHA256_H_
#define SHA256_H_

#include <stddef.h>
#include <stdint.h>

#define SHA256_SIZE_BYTES (32)

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
  uint8_t buf[64];
  uint32_t hash[8];
  uint32_t bits[2];
  uint32_t len;
  uint32_t rfu__;
  uint32_t W[64];
} sha256_context;

void sha256_init(sha256_context *ctx);
void sha256_hash(sha256_context *ctx, const void *data, size_t len);
void sha256_done(sha256_context *ctx, uint8_t *hash);

void sha256(const void *data, size_t len, uint8_t *hash);

#ifdef __cplusplus
}
#endif

#endif

#define WIDTH 512
//(64 * 8)

#define AXI_DATA_BITS 512
#define PID_BITS 6
struct __attribute__((packed)) axisIntf {
  ap_uint<AXI_DATA_BITS> tdata;
  ap_uint<AXI_DATA_BITS / 8> tkeep;
  ap_uint<PID_BITS> tid;
  ap_uint<1> tlast;

  axisIntf() : tdata(0), tkeep(0), tid(0), tlast(0) {}
  axisIntf(ap_uint<AXI_DATA_BITS> tdata, ap_uint<AXI_DATA_BITS / 8> tkeep,
           ap_uint<PID_BITS> tid, ap_uint<1> tlast)
      : tdata(tdata), tkeep(tkeep), tid(tid), tlast(tlast) {}

  axisIntf &operator=(const axisIntf &other) {
    tdata = other.tdata;
    tkeep = other.tkeep;
    tid = other.tid;
    tlast = other.tlast;
    return *this;
  }
};
typedef axisIntf AXIS_DATA;

void caesar(hls::stream<AXIS_DATA> &input, hls::stream<AXIS_DATA> &output);
