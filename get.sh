#!/bin/sh -e

set -x

urls="https://www.itu.int/wftp3/Public/t/testsignal/SpeImage/T087v1_0/T87_test-1-2-3-4-5-6.zip https://www.itu.int/wftp3/Public/t/testsignal/SpeImage/T087v1_0/T87_test-7-8.zip https://www.itu.int/wftp3/Public/t/testsignal/SpeImage/T087v1_0/T87_test-9-10.zip https://www.itu.int/wftp3/Public/t/testsignal/SpeImage/T087v1_0/T87_test-11-12.zip"

for url in $urls; do
  wget -c $url
done

# T87_test-1-2-3-4-5-6.zip
# T87_test-7-8.zip
# T87_test-9-10.zip
# T87_test-11-12.zip

for zip in *.zip; do
  unzip -f -d t87 $zip
done
