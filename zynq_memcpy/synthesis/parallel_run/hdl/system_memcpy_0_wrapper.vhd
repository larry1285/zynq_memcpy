-------------------------------------------------------------------------------
-- system_memcpy_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library memcpy_v1_00_a;
use memcpy_v1_00_a.all;

entity system_memcpy_0_wrapper is
  port (
    DBG_DATA : out std_logic_vector(31 downto 0);
    S_AXI_ACLK : in std_logic;
    S_AXI_ARESETN : in std_logic;
    S_AXI_AWADDR : in std_logic_vector(31 downto 0);
    S_AXI_AWVALID : in std_logic;
    S_AXI_WDATA : in std_logic_vector(31 downto 0);
    S_AXI_WSTRB : in std_logic_vector(3 downto 0);
    S_AXI_WVALID : in std_logic;
    S_AXI_BREADY : in std_logic;
    S_AXI_ARADDR : in std_logic_vector(31 downto 0);
    S_AXI_ARVALID : in std_logic;
    S_AXI_RREADY : in std_logic;
    S_AXI_ARREADY : out std_logic;
    S_AXI_RDATA : out std_logic_vector(31 downto 0);
    S_AXI_RRESP : out std_logic_vector(1 downto 0);
    S_AXI_RVALID : out std_logic;
    S_AXI_WREADY : out std_logic;
    S_AXI_BRESP : out std_logic_vector(1 downto 0);
    S_AXI_BVALID : out std_logic;
    S_AXI_AWREADY : out std_logic;
    m_axi_aclk : in std_logic;
    m_axi_aresetn : in std_logic;
    md_error : out std_logic;
    m_axi_arready : in std_logic;
    m_axi_arvalid : out std_logic;
    m_axi_araddr : out std_logic_vector(31 downto 0);
    m_axi_arlen : out std_logic_vector(7 downto 0);
    m_axi_arsize : out std_logic_vector(2 downto 0);
    m_axi_arburst : out std_logic_vector(1 downto 0);
    m_axi_arprot : out std_logic_vector(2 downto 0);
    m_axi_arcache : out std_logic_vector(3 downto 0);
    m_axi_rready : out std_logic;
    m_axi_rvalid : in std_logic;
    m_axi_rdata : in std_logic_vector(31 downto 0);
    m_axi_rresp : in std_logic_vector(1 downto 0);
    m_axi_rlast : in std_logic;
    m_axi_awready : in std_logic;
    m_axi_awvalid : out std_logic;
    m_axi_awaddr : out std_logic_vector(31 downto 0);
    m_axi_awlen : out std_logic_vector(7 downto 0);
    m_axi_awsize : out std_logic_vector(2 downto 0);
    m_axi_awburst : out std_logic_vector(1 downto 0);
    m_axi_awprot : out std_logic_vector(2 downto 0);
    m_axi_awcache : out std_logic_vector(3 downto 0);
    m_axi_wready : in std_logic;
    m_axi_wvalid : out std_logic;
    m_axi_wdata : out std_logic_vector(31 downto 0);
    m_axi_wstrb : out std_logic_vector(3 downto 0);
    m_axi_wlast : out std_logic;
    m_axi_bready : out std_logic;
    m_axi_bvalid : in std_logic;
    m_axi_bresp : in std_logic_vector(1 downto 0)
  );
end system_memcpy_0_wrapper;

architecture STRUCTURE of system_memcpy_0_wrapper is

  component memcpy is
    generic (
      C_S_AXI_DATA_WIDTH : INTEGER;
      C_S_AXI_ADDR_WIDTH : INTEGER;
      C_S_AXI_MIN_SIZE : std_logic_vector;
      C_USE_WSTRB : INTEGER;
      C_DPHASE_TIMEOUT : INTEGER;
      C_BASEADDR : std_logic_vector;
      C_HIGHADDR : std_logic_vector;
      C_FAMILY : STRING;
      C_NUM_REG : INTEGER;
      C_NUM_MEM : INTEGER;
      C_SLV_AWIDTH : INTEGER;
      C_SLV_DWIDTH : INTEGER;
      C_M_AXI_ADDR_WIDTH : INTEGER;
      C_M_AXI_DATA_WIDTH : INTEGER;
      C_MAX_BURST_LEN : INTEGER;
      C_NATIVE_DATA_WIDTH : INTEGER;
      C_LENGTH_WIDTH : INTEGER;
      C_ADDR_PIPE_DEPTH : INTEGER
    );
    port (
      DBG_DATA : out std_logic_vector(31 downto 0);
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector((C_S_AXI_ADDR_WIDTH-1) downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_WDATA : in std_logic_vector((C_S_AXI_DATA_WIDTH-1) downto 0);
      S_AXI_WSTRB : in std_logic_vector(((C_S_AXI_DATA_WIDTH/8)-1) downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector((C_S_AXI_ADDR_WIDTH-1) downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_RREADY : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector((C_S_AXI_DATA_WIDTH-1) downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_AWREADY : out std_logic;
      m_axi_aclk : in std_logic;
      m_axi_aresetn : in std_logic;
      md_error : out std_logic;
      m_axi_arready : in std_logic;
      m_axi_arvalid : out std_logic;
      m_axi_araddr : out std_logic_vector((C_M_AXI_ADDR_WIDTH-1) downto 0);
      m_axi_arlen : out std_logic_vector(7 downto 0);
      m_axi_arsize : out std_logic_vector(2 downto 0);
      m_axi_arburst : out std_logic_vector(1 downto 0);
      m_axi_arprot : out std_logic_vector(2 downto 0);
      m_axi_arcache : out std_logic_vector(3 downto 0);
      m_axi_rready : out std_logic;
      m_axi_rvalid : in std_logic;
      m_axi_rdata : in std_logic_vector((C_M_AXI_DATA_WIDTH-1) downto 0);
      m_axi_rresp : in std_logic_vector(1 downto 0);
      m_axi_rlast : in std_logic;
      m_axi_awready : in std_logic;
      m_axi_awvalid : out std_logic;
      m_axi_awaddr : out std_logic_vector((C_M_AXI_ADDR_WIDTH-1) downto 0);
      m_axi_awlen : out std_logic_vector(7 downto 0);
      m_axi_awsize : out std_logic_vector(2 downto 0);
      m_axi_awburst : out std_logic_vector(1 downto 0);
      m_axi_awprot : out std_logic_vector(2 downto 0);
      m_axi_awcache : out std_logic_vector(3 downto 0);
      m_axi_wready : in std_logic;
      m_axi_wvalid : out std_logic;
      m_axi_wdata : out std_logic_vector((C_M_AXI_DATA_WIDTH-1) downto 0);
      m_axi_wstrb : out std_logic_vector(((C_M_AXI_DATA_WIDTH/8)-1) downto 0);
      m_axi_wlast : out std_logic;
      m_axi_bready : out std_logic;
      m_axi_bvalid : in std_logic;
      m_axi_bresp : in std_logic_vector(1 downto 0)
    );
  end component;

begin

  memcpy_0 : memcpy
    generic map (
      C_S_AXI_DATA_WIDTH => 32,
      C_S_AXI_ADDR_WIDTH => 32,
      C_S_AXI_MIN_SIZE => X"000001ff",
      C_USE_WSTRB => 1,
      C_DPHASE_TIMEOUT => 8,
      C_BASEADDR => X"6a000000",
      C_HIGHADDR => X"6a00ffff",
      C_FAMILY => "zynq",
      C_NUM_REG => 4,
      C_NUM_MEM => 1,
      C_SLV_AWIDTH => 32,
      C_SLV_DWIDTH => 32,
      C_M_AXI_ADDR_WIDTH => 32,
      C_M_AXI_DATA_WIDTH => 32,
      C_MAX_BURST_LEN => 64,
      C_NATIVE_DATA_WIDTH => 32,
      C_LENGTH_WIDTH => 12,
      C_ADDR_PIPE_DEPTH => 1
    )
    port map (
      DBG_DATA => DBG_DATA,
      S_AXI_ACLK => S_AXI_ACLK,
      S_AXI_ARESETN => S_AXI_ARESETN,
      S_AXI_AWADDR => S_AXI_AWADDR,
      S_AXI_AWVALID => S_AXI_AWVALID,
      S_AXI_WDATA => S_AXI_WDATA,
      S_AXI_WSTRB => S_AXI_WSTRB,
      S_AXI_WVALID => S_AXI_WVALID,
      S_AXI_BREADY => S_AXI_BREADY,
      S_AXI_ARADDR => S_AXI_ARADDR,
      S_AXI_ARVALID => S_AXI_ARVALID,
      S_AXI_RREADY => S_AXI_RREADY,
      S_AXI_ARREADY => S_AXI_ARREADY,
      S_AXI_RDATA => S_AXI_RDATA,
      S_AXI_RRESP => S_AXI_RRESP,
      S_AXI_RVALID => S_AXI_RVALID,
      S_AXI_WREADY => S_AXI_WREADY,
      S_AXI_BRESP => S_AXI_BRESP,
      S_AXI_BVALID => S_AXI_BVALID,
      S_AXI_AWREADY => S_AXI_AWREADY,
      m_axi_aclk => m_axi_aclk,
      m_axi_aresetn => m_axi_aresetn,
      md_error => md_error,
      m_axi_arready => m_axi_arready,
      m_axi_arvalid => m_axi_arvalid,
      m_axi_araddr => m_axi_araddr,
      m_axi_arlen => m_axi_arlen,
      m_axi_arsize => m_axi_arsize,
      m_axi_arburst => m_axi_arburst,
      m_axi_arprot => m_axi_arprot,
      m_axi_arcache => m_axi_arcache,
      m_axi_rready => m_axi_rready,
      m_axi_rvalid => m_axi_rvalid,
      m_axi_rdata => m_axi_rdata,
      m_axi_rresp => m_axi_rresp,
      m_axi_rlast => m_axi_rlast,
      m_axi_awready => m_axi_awready,
      m_axi_awvalid => m_axi_awvalid,
      m_axi_awaddr => m_axi_awaddr,
      m_axi_awlen => m_axi_awlen,
      m_axi_awsize => m_axi_awsize,
      m_axi_awburst => m_axi_awburst,
      m_axi_awprot => m_axi_awprot,
      m_axi_awcache => m_axi_awcache,
      m_axi_wready => m_axi_wready,
      m_axi_wvalid => m_axi_wvalid,
      m_axi_wdata => m_axi_wdata,
      m_axi_wstrb => m_axi_wstrb,
      m_axi_wlast => m_axi_wlast,
      m_axi_bready => m_axi_bready,
      m_axi_bvalid => m_axi_bvalid,
      m_axi_bresp => m_axi_bresp
    );

end architecture STRUCTURE;

