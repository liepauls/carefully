module Carefully
  def self.included(base)
    base.instance_eval do
      def delete_all
        return super if Carefully.configuration.disabled?

        Carefully.confirm_destructive_action(:delete_all) && super
      end

      def delete(ids)
        return super if Carefully.configuration.disabled?

        Carefully.confirm_destructive_action(:delete) && super
      end
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new

    yield configuration if block_given?

    configuration.set_enabled
  end

  def self.allow_all
    begin
      Carefully.configuration.instance_variable_set :@enabled, false
      yield
    ensure
      Carefully.configuration.set_enabled
    end
  end

  def self.confirm_destructive_action(method_name)
    puts Carefully.configuration.confirmation_message
    print '> '

    return true if gets.chomp == Carefully.configuration.confirmation_text

    puts "\"#{method_name}\" aborted!"
    false
  end

  def delete
    return super if Carefully.configuration.disabled?

    Carefully.confirm_destructive_action(:delete) && super
  end

  def destroy
    return super if Carefully.configuration.disabled?

    Carefully.confirm_destructive_action(:destroy) && super
  end

  private

  class Configuration
    attr_accessor :protected_environments, :confirmation_message, :confirmation_text

    def initialize
      self.protected_environments = [:production, :demo, :staging]
      self.confirmation_message   = "You are performing destructive actions in #{Rails.env} environment. Do you want to continue?"
      self.confirmation_text      = 'yes'
    end

    def set_enabled
      @enabled = protected_environment? && rails_console?
    end

    def enabled?
      !!@enabled
    end

    def disabled?
      !@enabled
    end

    private

    def protected_environment?
      protected_environments.map(&:to_s).include?(Rails.env)
    end

    def rails_console?
      defined?(Rails::Console)
      true
    end
  end
end
