# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# Purpose:
# JobStatusNotificationSample.rb demonstrates how to create a notification handler for an
# Amazon Elastic Transcoder job using the AWS SDK for Ruby.


# snippet-start:[elastictranscoder.ruby.create_job_status_notification.import]
require 'aws-sdk-elastictranscoder'
require 'openssl'
require_relative 'SqsQueueNotificationWorker'

# This is the ID of the Elastic Transcoder pipeline that was created when
# setting up your AWS environment:
# https://w.amazon.com/index.php/User:Ramsdenj/Samples/Environment_Setup/Create_Elastic_Transcoder_Pipeline#Create_the_Pipeline
pipeline_id = 'Enter your pipeline id here.'

# This is the URL of the SQS queue that was created when setting up your
# AWS environment.
# https://w.amazon.com/index.php/User:Ramsdenj/Samples/Environment_Setup/Create_SQS_Queue#Create_an_SQS_Queue
sqs_queue_url = 'Enter your queue url here.'

# This is the name of the input key that you would like to transcode.
input_key = 'Enter your input key here.'

# This will generate a 480p 16:9 mp4 output.
preset_id = '1351620000001-000020'

# All outputs will have this prefix prepended to their output key.
output_key_prefix = 'elastic-transcoder-samples/output/'

# Replace us-west-2 with the AWS Region you're using for Elastic Transcoder.
region = 'us-west-2'

def create_elastic_transcoder_job(region, pipeline_id, input_key, preset_id, output_key_prefix)
  # Create the client for Elastic Transcoder.
  transcoder_client = Aws::ElasticTranscoder::Client.new(region: region)

  # Setup the job input using the provided input key.
  input = { key: input_key }

  # Setup the job input using the provided input key.
  output = {
    key: OpenSSL::Digest::SHA256.new(input_key.encode('UTF-8')),
    preset_id: preset_id
  }

  # Create a job on the specified pipeline and return the job ID.
  transcoder_client.create_job(
    pipeline_id: pipeline_id,
    input: input,
    output_key_prefix: output_key_prefix,
    outputs: [output]
  )[:job][:id]
end

job_id = create_elastic_transcoder_job(region, pipeline_id, input_key, preset_id, output_key_prefix)
puts 'Waiting for job to complete: ' + job_id

# Create SQS notification worker which polls for notifications.  Register a
# handler which will stop the worker when the job we just created completes.
notification_worker = SqsQueueNotificationWorker.new(region, sqs_queue_url)
completion_handler = lambda { |notification| notification_worker.stop if (notification['jobId'] == job_id && ['COMPLETED', 'ERROR'].include?(notification['state'])) }
notification_worker.add_handler(completion_handler)
notification_worker.start
# snippet-end:[elastictranscoder.ruby.create_job_status_notification.import]
