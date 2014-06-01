class Message
  PART_TYPES = [ :incoming_request, :outgoing_request, :incoming_response, :outgoing_response ]

  def initialize(params = {})
    @params = params
  end

  def root
    @params[:root]
  end

  def timestamp
    File.stat(File.join(root, "incoming_request.http")).ctime

    rescue Exception
    Time.now
  end

  def name
    File.basename(root)
  end

  def to_param
    name.gsub(".", "_")
  end

  def comment
    read_metadata["comment"]
  end

  def update_attributes(params)
    File.open(File.join(root, ".geiger.json"), "w") do |f|
      f.write(params.to_json)
    end
  end

  PART_TYPES.each do |part_type|
    define_method(part_type) do
      Part.new(@params.merge(:type => part_type))
    end
  end

  def self.all
    [].tap do |list|
      Dir[File.join(MESSAGE_PATH, "*")].each do |message|
        if File.directory? message
          list << new(:root => message)
        end
      end
    end
  end

  def self.find(id)
    id.gsub!("_", ".")
    new(:root => File.join(MESSAGE_PATH, id))
  end

  private

  def write_metadata(params)
    File.open(File.join(root, ".geiger.json"), "w") do |f|
      f.write(params.to_json)
    end

    rescue Exception
  end

  def read_metadata
    data = File.read(File.join(root, ".geiger.json"))
    JSON.parse(data)

    rescue Exception
    {}
  end
end
