# Please replace USERNAME appropriately

require 'librarian/chef/integration/knife'

current_dir = File.dirname(__FILE__)

log_level                :info
log_location             STDOUT
node_name                "USERNAME"
client_key               "#{current_dir}/USERNAME.pem"
validation_client_name   "fga-validator"
validation_key           "#{current_dir}/fga-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/fga"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            [ Librarian::Chef.install_path, "#{current_dir}/../cookbooks-overrides" ]

cookbook_copyright       'FLOSolutions'
cookbook_email           'patrick.c.connolly@gmail.com'
cookbook_license         'apachev2'
