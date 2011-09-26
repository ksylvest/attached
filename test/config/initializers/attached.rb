environment = ENV['ATTACHED']

Attached::Attachment.options[:medium] = environment.intern if environment
Attached::Attachment.options[:credentials] = "#{Rails.root}/config/#{environment}.yml" if environment