version 1.0

task task_make_table {
  input {
    File table
  }

  command <<<
    set -x
    tail -n +2 ~{table} | head -1 | awk '{print $1}' > SAMPLEID
    tail -n +2 ~{table} | grep INH | awk '{print $3}' > INH
    tail -n +2 ~{table} | grep EMB | awk '{print $3}' > EMB
  >>>

  output {
    String SAMPLEID = read_string("SAMPLEID")
    String EMB = read_string("EMB")
    String INH = read_string("INH")
  }
  
  runtime {
    docker: "ubuntu:22.04"
  }
}

workflow wf_make_table {
  input {
    File table
  }
  
  call task_make_table {
    input:
    table = table
  }
  
  output {
    String INH = task_make_table.INH
    String EMB = task_make_table.EMB
    String SAMPLEID = task_make_table.SAMPLEID
  }

}
