#!/bin/bash
#
# Demonstrates how to invoke the sps_bill command line to extract
# all billing data for a set of files
#
# Example Usage:
#
#   scan_all_bills.sh my_bills/*.pdf > my_bill_data.csv
#
scriptPath=${0%/*}/

v_files=${1:-help}

if [ "${v_files}" == "help" ]
then
  echo "usage: scan_all_bills.sh ./path/to_pdf_files*.pdf"
  exit
fi

${scriptPath}../bin/sps_bill --data=all $*
