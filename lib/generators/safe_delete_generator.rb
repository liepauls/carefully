class CarefullyGenerator < Rails::Generators::Base
  source_root File.expand_path(File.dirname(__FILE__))

  def copy_initializer
    copy_file 'carefully.rb', 'config/initializers/carefully.rb'
  end
end
