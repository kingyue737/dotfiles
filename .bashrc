# WSL X forwarding DISPLAY
# export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0 # use VcXsrv
# export DISPLAY=:0 # use WSLg

# export OPENMC_CROSS_SECTIONS="/home/yuejin/Cloud/nuclear_data_libraries/endfb71_hdf5/cross_sections.xml"
# export OPENMC_CHAIN_FILE="/home/yuejin/Cloud/depletion_chains/chain_casl_pwr.xml"