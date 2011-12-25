module Attached
  
  class Job
    
    @queue = :attached
    
    def self.perform(klass, id, method)
      object = eval(klass).find(id)
      attachment = object.send(name)
      attachment.reprocess!
      attachment.status = 'active'
    end
    
    def self.enqueue(attachment)
      klass = attachment.instance.class.name
      id = attachment.instance.id
      method = attachment.name
      attachment.status = 'processing'
    end
    
  end
  
end