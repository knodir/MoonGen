from scapy.layers.inet import Ether, IP, UDP
from scapy.all import scapy
import sys

out_fname = 'filename.pcap'

ether = Ether(src='A0:36:9F:45:D7:74', dst='a0:36:9f:45:ed:1c')
ip = IP(src="192.168.0.1", dst="10.0.0.2")
udp = UDP(sport=50,dport=10) 
packet = ether/ip/udp
# MoonGen gives 'unsupported link layer type' error message if we do not
# explicitly set the linktype. We need to set to 'EN10MB (Ethernet)'.
# See more values at http://www.tcpdump.org/linktypes.html
scapy.all.wrpcap(out_fname, packet, linktype=1)

print('wrote to {} file'.format(out_fname))
