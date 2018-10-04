#!/bin/bash -x
############################################
#    AWS S3 Analysis tool
############################################
#
#  title           :aws_s3.sh
#  description     :AWS s3 analysis tool
#  author		 :msantos
#  date            :20180919
#  version         :0.1
#  usage		 :bash mkscript.sh
#  notes           :Prerequissites: Install AWS Cli and configure your credentials.
#  bash_version    :
#
#==============================================================================
# Variables
NAME='' #NAME of Bucket
C_DATE='' # Date of creation
NFILES='' # Number of files
TSIZE='' # Total size of the bucket
NUM=1
# List the buckets
aws s3 ls > liste.txt

while IFS=' ' read -r line || [[ -n "$line" ]]; do
    #read NAME
    NAME=$(echo $line | cut -d ' ' -f3)
    #read  CDATE
    C_DATE=$(echo $line | cut -d ' ' -f1)
    # Comand aws for totalsize and number of files
    aws s3 ls s3://$NAME --recursive --human-readable --summarize > size.txt
    tail -2 size.txt > size_tail.txt
    #read Size
    l1=`tail -1 size_tail.txt`
    TSIZE=$(echo $l1 | cut -d ':' -f2)
    #read Number files
    l2=`head -1 size_tail.txt`
    NFILES=$(echo $l2 | cut -d ':' -f2)

  # RETURN INFORMATION
  echo "# -- BUCKET number " $NUM " ----- #"
  echo "Bucket name: " $NAME
  echo "Creation date: " $C_DATE
  echo "Number of files: " $NFILES
  echo "Total size of files: " $TSIZE
  echo "  "
  # Number of buckets
  NUM=$(($NUM +1))

 done < liste.txt
 rm liste.txt size.txt size_tail.txt
 exit