cookbook_path ["#{current_dir}/../site-cookbooks", "#{current_dir}/../cookbooks"]
# Amazon AWS
knife[:aws_access_key_id]     = ENV['EC2_ACCESS_KEY']
knife[:aws_secret_access_key] = ENV['EC2_SECRET_KEY']
