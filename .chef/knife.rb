require 'librarian/chef/integration/knife'
current_dir = File.dirname(__FILE__)

# Amazon AWS
knife[:aws_access_key_id]     = ENV['EC2_ACCESS_KEY']
knife[:aws_secret_access_key] = ENV['EC2_SECRET_KEY']
knife[:region]                = ENV['EC2_REGION']
knife[:chef_mode]             = "solo"
knife[:ssh_user]              = "ubuntu"
knife[:groups]                = "default"
knife[:identity_file]         = ENV['EC2_PRIVATE_KEY']
# knife[:aws_ssh_key_id]        = ENV['EC2_KEYPAIR']
knife[:aws_ssh_key_id]        = "ec2-keypair"

log_level                :info
log_location             STDOUT
node_name                "nybblr"
client_key               "/dev/null"
validation_client_name   "validator"
validation_key           "/dev/null"
chef_server_url          "https://api.opscode.com/organizations/nybblr"
cache_type               'BasicFile'
cache_options :path =>   "#{current_dir}/checksums"
cookbook_path            [ Librarian::Chef.install_path, "#{current_dir}/../cookbooks-overrides" ]
