#!/bin/bash
#Script for bandwdith collection experiments

result_folder_name=results
eth_dst=a0:36:9f:45:ed:1c
sleep_time=10
mkdir ${result_folder_name}

sizes=(250
    500
    1000
    1492)

flows=(1
    2
    3)

bands=(1000
    3000
    5000
    7000
    9000
    10000)

runs=(1
    2
    3
    4
    5
    6
    7
    8
    9
    10)

for size in ${sizes[@]}; do
  pkt_folder=pkt-${size}B
  for num_of_flows in ${flows[@]}; do
    final_folder_name=${result_folder_name}/${pkt_folder}/${num_of_flows}chains
    mkdir -p ${final_folder_name}

    for band_val in ${bands[@]}; do
      for iter in ${runs[@]}; do
        out_fname=${band_val}Mbps_run${iter}.csv
        echo --- starting: ${out_fname}
        log_file=${final_folder_name}/${out_fname}.stdout.txt
        cmd="sudo timelimit -t 60 -s 2 ../build/MoonGen ./moongen_bench.lua -t 0 -r 0 -f ${band_val} -b 0 -e ${eth_dst} -n ${num_of_flows} -p ${size}"
        echo --- started: $cmd
        $cmd |& tee ${log_file}
        echo +++ completed: $cmd
        sleep 3
        echo === renaming hist-foreground.csv to ${final_folder_name}/${out_fname}
        mv hist-foreground.csv ${final_folder_name}/${out_fname}
        echo "=== rename done; sleep for ${sleep_time}s"
        sleep ${sleep_time}
      done
    done
  done
done

wait
