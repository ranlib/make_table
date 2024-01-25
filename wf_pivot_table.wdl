version 1.0

task task_pivot_table {
  input {
    File input_tsv
    String output_tsv
  }

  command <<<
    set -x
    python -c "
    import sys
    import pandas
    inpf = sys.argv[1]
    outf = sys.argv[2]
    d = pandas.read_csv(inpf, sep='\t')
    d['Variant_Interpretation'] = d['Variant'] + ' (' + d['Interpretation'] + ')'
    dp = d.pivot(index='Sample ID', columns='Drug', values='Variant_Interpretation')
    dp = dp.reset_index()
    dp = dp.rename(columns={'Sample ID': 'entity:Sample_id'})
    dp.to_csv(outf, sep='\t', index=False)
    " ~{input_tsv} ~{output_tsv} 
  >>>

  output {
    File output_table = output_tsv
  }
  
  runtime {
    docker: "dbest/variant_interpretation:v1.0.4"
  }
}

workflow wf_pivot_table {
  input {
    File input_tsv
    String output_tsv
  }
  
  call task_pivot_table {
    input:
    input_tsv = input_tsv,
    output_tsv = output_tsv
  }
  
  output {
    File output_table = task_pivot_table.output_table
  }
}
