//
// BASE RDMA operations
//

// Tie-off
always_comb axi_ctrl.tie_off_s();

`define AXISR_ASSIGNS(s, m)              \
	assign m.tdata      = s.tdata + 1234;     	\
	assign m.tkeep      = s.tkeep;     	\
	assign m.tlast      = s.tlast;     	\
	assign m.tvalid     = s.tvalid;    	\
	assign s.tready     = m.tready;		\
	assign m.tid  		= s.tid; 	
// UL

`ifdef EN_RDMA_0

`META_ASSIGN(rdma_0_rd_req, bpss_rd_req)
`META_ASSIGN(rdma_0_wr_req, bpss_wr_req)

`ifndef EN_MEM
`AXISR_ASSIGN(axis_rdma_0_sink, axis_rdma_0_sink2)
//`AXISR_ASSIGNS(axis_rdma_0_sink, axis_host_src)
`AXISR_ASSIGN(axis_host_sink, axis_host_sink2)
//`AXISR_ASSIGNS(axis_host_sink, axis_rdma_0_src)
`else
`AXISR_ASSIGN(axis_rdma_0_sink, axis_card_src)
`AXISR_ASSIGN(axis_card_sink, axis_rdma_0_src)
`endif

`else
`ifdef EN_RDMA_1

`META_ASSIGN(rdma_1_rd_req, bpss_rd_req)
`META_ASSIGN(rdma_1_wr_req, bpss_wr_req)

`ifndef EN_MEM
`AXISR_ASSIGN(axis_rdma_1_sink, axis_host_src)
`AXISR_ASSIGN(axis_host_sink, axis_rdma_1_src)
`else
`AXISR_ASSIGN(axis_rdma_1_sink, axis_card_src)
`AXISR_ASSIGN(axis_card_sink, axis_rdma_1_src)
`endif

`endif
`endif
