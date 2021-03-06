namespace :attached do

  desc "Process a given 'model' and 'attachment'"
  task :process, [:model, :attachment] => :environment do |t, args|

    model = args[:model] or raise "must specify model"
    attachment = args[:attachment] or raise "must specify attachment"

    klass = model.camelize.constantize or raise "invalid model '#{model}'"

    klass.all.each do |instance|
      instance.send(attachment).reprocess!
      instance.send(attachment).save
    end

  end

end
