class Screenshot
  PATH_TO_EXECUTABLE = "/usr/local/bin/wkhtmltoimage"

  attr_accessor :options

  def initialize(options={})
    options.assert_valid_keys :vurl
    self.options = options
  end

  def snap!
    Rails.logger.debug "Taking screenshot by executing #{command}"
    system(command)
  end

  def command
    "#{PATH_TO_EXECUTABLE} #{command_options} #{vurl.url} #{output_file_path}"
  end

  def output_file_path
    "#{RAILS_ROOT}/public#{output_file_url}"
  end

  def output_file_url
    "/screenshots/#{vurl.slug}.png"
  end

  def command_options
    "-f png --quality 70 --crop-w 1024 --crop-h 768"
  end

  def method_missing(method, *args)
    if options.has_key?(method)
      options[method]
    else
      super(method, *args)
    end
  end
end
