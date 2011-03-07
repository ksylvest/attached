case ENV['ATTACHED']
when "aws"
  Attached::Attachment.options[:medium] = :aws
  Attached::Attachment.options[:credentials] = "#{Rails.root}/config/aws.yml"
when "google"
  Attached::Attachment.options[:medium] = :google
  Attached::Attachment.options[:credentials] = "#{Rails.root}/config/google.yml"
when "rackspace"
  Attached::Attachment.options[:medium] = :rackspace
  Attached::Attachment.options[:credentials] = "#{Rails.root}/config/rackspace.yml"
end