class SafeDeleteGenerator < Rails::Generators::Base
  source_root File.expand_path(File.dirname(__FILE__))

  def copy_initializer
    copy_file 'safe_delete.rb', 'config/initializers/safe_delete.rb'
  end
end
