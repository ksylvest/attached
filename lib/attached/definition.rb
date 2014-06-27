module Attached
  module Definition
    def attachment(*args)
      options = args.extract_options!
      args.each do |name|
        column("#{name}_identifier", :string, options)
        column("#{name}_extension", :string, options)
        column("#{name}_size", :integer, options)
      end
    end
  end
end
