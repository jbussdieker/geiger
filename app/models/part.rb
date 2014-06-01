class Part
  def initialize(params = {})
    @params = params
  end

  def root
    @params[:root]
  end

  def type
    @params[:type]
  end

  def filename
    File.join(root, [type, "http"].join("."))
  end

  def message
    begin
      @message ||= File.read(filename)
    rescue Exception => e
      ""
    end
  end
  
  def header
    parts.first
  end

  def body
    parts.last
  end

  private

  def parts
    @parts ||= message.split("\r\n\r\n")
  end
end
