#!/bin/bash
ps_plotname="./plots/plot-ps-comp.gpl"
mem_plotname="./plots/plot-mem-comp.gpl"
cpu_plotname="./plots/plot-cpu-comp.gpl"

io_plotname="./plots/plot-io-comp.gpl"
syscr_plotname="./plots/plot-syscr-comp.gpl"
syscw_plotname="./plots/plot-syscw-comp.gpl"
br_plotname="./plots/plot-br-comp.gpl"
bw_plotname="./plots/plot-bw-comp.gpl"

fix_values()
{
    logfile=$1
    tempfile=$(date +%s)
    
    # sort file and save as temporary
    cat "$logfile" | grep -v "exec" | sort -k1 -n > "$tempfile"
    
    # deletes temp file and overwrites initial file
    mv "$tempfile" "$logfile"
}

plota_ps()
{
    gnuplot -e "tname='$5'; pure_log='$1'; comb_log='$2'; semb_log='$3'; smt_log='$4'" "$ps_plotname" > "$6/$5.ps.pdf"
}

plota_mem()
{
    gnuplot -e "tname='$5'; pure_log='$1'; comb_log='$2'; semb_log='$3'; smt_log='$4'" "$mem_plotname" > "$6/$5.ps.pdf"
}

plota_cpu()
{
    gnuplot -e "tname='$5'; pure_log='$1'; comb_log='$2'; semb_log='$3'; smt_log='$4'" "$cpu_plotname" > "$6/$5.ps.pdf"
}

plota_io()
{
    gnuplot -e "tname='$5'; pure_log='$1'; comb_log='$2'; semb_log='$3'; smt_log='$4'" "$io_plotname" > "$6/$5.io.pdf"
}

plota_syscr()
{
    gnuplot -e "tname='$5'; pure_log='$1'; comb_log='$2'; semb_log='$3'; smt_log='$4'" "$syscr_plotname" > "$6/$5.io.pdf"
}

plota_syscw()
{
    gnuplot -e "tname='$5'; pure_log='$1'; comb_log='$2'; semb_log='$3'; smt_log='$4'" "$syscw_plotname" > "$6/$5.io.pdf"
}

plota_br()
{
    gnuplot -e "tname='$5'; pure_log='$1'; comb_log='$2'; semb_log='$3'; smt_log='$4'" "$br_plotname" > "$6/$5.io.pdf"
}

plota_bw()
{
    gnuplot -e "tname='$5'; pure_log='$1'; comb_log='$2'; semb_log='$3'; smt_log='$4'" "$bw_plotname" > "$6/$5.io.pdf"
}

plot_all()
{
    if [[ $# < 5 ]]; then
        echo "[?] are you using all logs? make sure you have all 5 logs."
        exit
    fi
    
    suffix="$1"
    log_pure="$2"
    log_comb="$3"
    log_semb="$4"
    log_smt="$5"
    
    # create directory for saving all outputs
    name_dir=$(echo "graficos/$suffix" | sed 's/ /_/g')
    mkdir -p "$name_dir"
    
    # fix inputs
    fix_values $log_pure
    fix_values $log_comb
    fix_values $log_semb
    fix_values $log_smt

    # plot using PS
    plota_ps  $log_pure $log_comb $log_semb $log_smt "Uso de recursos (PS) entre ferramentas - $suffix" "$name_dir"
    plota_mem $log_pure $log_comb $log_semb $log_smt "Uso de memória entre ferramentas - $suffix" "$name_dir"
    plota_cpu $log_pure $log_comb $log_semb $log_smt "Uso de CPU entre ferramentas - $suffix" "$name_dir"

    # plot using IO
    plota_io  $log_pure $log_comb $log_semb $log_smt "Uso de recursos (IO) entre ferramentas - $suffix" "$name_dir"
    plota_syscr  $log_pure $log_comb $log_semb $log_smt "Qtd. de system calls (read) entre ferramentas - $suffix" "$name_dir"
    plota_syscw  $log_pure $log_comb $log_semb $log_smt "Qtd. de system calls (write) entre ferramentas - $suffix" "$name_dir"
    plota_br  $log_pure $log_comb $log_semb $log_smt "Qtd. de bytes lidos entre ferramentas - $suffix" "$name_dir"
    plota_bw  $log_pure $log_comb $log_semb $log_smt "Qtd. de bytes escritos entre ferramentas - $suffix" "$name_dir"
}

plot_all    "Tmod2" \
            "./dados-test/test_py-pure_consolidado.log" \
            "./dados-test/test_py-comb_consolidado.log" \
            "./dados-test/test_py-semb_consolidado.log" \
            "./dados-test/test_py-normalps_consolidado.log"


plot_all    "Pollard Rho" \
            "./dados-rho/rho_py-pure_consolidado.log" \
            "./dados-rho/rho_py-comb_consolidado.log" \
            "./dados-rho/rho_py-semb_consolidado.log" \
            "./dados-rho/rho_py-normalps_consolidado.log"


plot_all    "GAN (2 epochs)" \
            "./dados-gan/gan_py-2epochs-pure_consolidado.log" \
            "./dados-gan/gan_py-2epochs-comb_consolidado.log" \
            "./dados-gan/gan_py-2epochs-semb_consolidado.log" \
            "./dados-gan/gan_py-2epochs-normalps_consolidado.log"

