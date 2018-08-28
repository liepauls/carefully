module Carefully
  def self.included(base)
    base.instance_eval do
      def destroy_all
        return super unless Carefully.configuration.enabled?

        Carefully.confirm_destructive_action && super
      end

      def delete_all
        return super unless Carefully.configuration.enabled?

        Carefully.confirm_destructive_action && super
      end

      def delete(ids)
        return super unless Carefully.configuration.enabled?

        Carefully.confirm_destructive_action && super
      end

      def destroy(ids)
        return super unless Carefully.configuration.enabled?

        Carefully.confirm_destructive_action && super
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

  def self.confirm_destructive_action
    puts Carefully.configuration.confirmation_message
    print '> '

    if gets.chomp == Carefully.configuration.confirmation_text
      true
    else
      puts "\"#{caller_locations(1, 1)[0].label}\" aborted\n"
      false
    end
  end

  def destroy
    return super unless Carefully.configuration.enabled?
    return super if caller_locations(1, 10).map(&:label).include? 'destroy_all'

    Carefully.confirm_destructive_action && super
  end

  def delete
    return super unless Carefully.configuration.enabled?

    Carefully.confirm_destructive_action && super
  end

  private

  class Configuration
    attr_accessor :protected_environments, :confirmation_message, :confirmation_text

    def initialize
      self.protected_environments = [:production, :demo, :staging]
      self.confirmation_message   = 'You are performing destructive actions in a protected environment. Do you want to continue?'
      self.confirmation_text      = 'yes'
    end

    def set_enabled
      @enabled = protected_environment? && rails_console?
    end

    def enabled?
      !!@enabled
    end

    private

    def protected_environment?
      protected_environments.map(&:to_s).include?(Rails.env)
    end

    def rails_console?
      defined?(Rails::Console)
    end
  end
end
