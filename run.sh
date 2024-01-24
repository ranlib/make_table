#!/bin/bash

#miniwdl run --debug --dir test_make_table --cfg ../miniwdl_production.cfg -i wf_make_table.json wf_make_table.wdl 
java -jar ~/Software/cromwell-86.jar run wf_make_table.wdl -i wf_make_table.json

exit 0

