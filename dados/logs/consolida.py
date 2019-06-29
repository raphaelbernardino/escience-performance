#!/usr/bin/python3
import os

def consolida(files, pos_index, pos_value, delimiter=' ', date=False):
    d_values = dict()
    
    for file in files:
        print ('file', file)
        with open(file, 'r') as f:
            content = [line.rstrip().split(delimiter) for line in f]
            
            # remove headers; [running process id] and [header itself]
            del content[0]
            del content[0]
            
            #print('[P0]', content)
            for row in content:
                idx = int(row[pos_index])
                #print ('idx', idx)
                if not date:
                    val = float(row[pos_value])
                else:
                    date_value = str(row[pos_value])
                    while len(date_value) < 8:
                        date_value = '00:' + date_value
                    h, m, s = date_value.split(':')
                    val = int(h) * 3600 + int(m) * 60 + int(s) * 1
                
                if idx in d_values:
                    d_values[idx].append(val)
                else:
                    d_values[idx] = [val]
            #print('[P1]', d_values)
    
    for k in d_values.keys():
        idx_vsize = len(d_values[k])
        #print('[P2]', idx_vsize)
        d_values[k] = sum(d_values[k]) / idx_vsize
        #print('[P3]', d_values[k])
    
    return d_values
    
def agrega(d1, d2):
    for (k, v) in d2.items():
        if k in d1:
            d1[k].append(d2[k])
        else:
            d1[k] = [d2[k]]
            
def lista_arquivos(root_dir, files_extension):
    for directory, subdirectory, files in os.walk(root_dir):
        for file in files:
            if file.endswith(files_extension):
                #print(os.path.join(directory, file))
                yield str(os.path.join(directory, file))
                
def nice_print(headers, data):
    full_table = ','.join(headers) + '\n'
    
    for (k, v) in data.items():
        syscr, syscw, br, bw, mem, cpu, cpu_time, etimes = v
        table = '%d, ' % k
        table += '%d, ' % syscr
        table += '%d, ' % syscw
        table += '%d, ' % br
        table += '%d, ' % bw
        table += '%1.4f, ' % mem
        table += '%1.2f, ' % cpu
        table += '%d, ' % cpu_time
        table += '%d' % etimes
        print(table)
        full_table += table + '\n'
        
    return full_table

if __name__ == "__main__":
    arquivos = []
    for arquivo in lista_arquivos('.', '.txt'):
        arquivos.append(arquivo)
    
    ## execution time, syscr, syscw, read_bytes, write_bytes, resident memory, %cpu, cpu total time, elapsed time, number of threads, process id, arguments
    headers = 'execution time, syscr, syscw, read_bytes, write_bytes, resident memory, %cpu, cpu total time, elapsed time'.split(',')
    
    syscr = consolida(arquivos, 0, 1)
    syscw = consolida(arquivos, 0, 2)
    br = consolida(arquivos, 0, 3)
    bw = consolida(arquivos, 0, 4)
    mem = consolida(arquivos, 0, 5)
    cpu = consolida(arquivos, 0, 6)
    cpu_time = consolida(arquivos, 0, 7, date=True)
    elapsed_time = consolida(arquivos, 0, 8, date=True)
    #threads = consolida(arquivos, 0, 9)
    
    d_dados = dict()
    agrega(d_dados, syscr)
    agrega(d_dados, syscw)
    agrega(d_dados, br)
    agrega(d_dados, bw)
    agrega(d_dados, mem)
    agrega(d_dados, cpu)
    agrega(d_dados, cpu_time)
    agrega(d_dados, elapsed_time)
    #agrega(d_dados, threads)
    print(d_dados)
    
    table = nice_print(headers, d_dados)
    with open('consolidado.log', 'w') as f:
        f.write(table)

