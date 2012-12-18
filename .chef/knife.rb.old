require 'librarian/chef/integration/knife'
current_dir = File.dirname(__FILE__)

# Amazon AWS
knife[:aws_access_key_id]     = ENV['EC2_ACCESS_KEY']
knife[:aws_secret_access_key] = ENV['EC2_SECRET_KEY']

log_level                :info
log_location             STDOUT
node_name                "nybblr"
# client_key               "#{current_dir}/nybblr.pem"
# validation_client_name   "validator"
# validation_key           "#{current_dir}/validator.pem"
# chef_server_url          "https://api.opscode.com/organizations/nybblr"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            [ Librarian::Chef.install_path, "#{current_dir}/../cookbooks-overrides" ]
