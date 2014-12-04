module Attached

  class Job
    @queue = :attached

    def self.perform(klass, id, method)
      object = klass.constantize.find(id)

      attachment = object.send(name)
      attachment.reprocess!
      attachment.status = 'active'

      object.save
    end

    def self.enqueue(attachment)
      klass = attachment.instance.class.name
      id = attachment.instance.id
      method = attachment.name
      attachment.status = 'processing'

      self.perform(klass, id, method)
    end

  end

end