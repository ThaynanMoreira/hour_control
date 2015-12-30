module ActionView
  # = Action View Form Tag Helpers
  module Helpers
    # Provides a number of methods for creating form tags that doesn't rely on an Active Record object assigned to the template like
    # FormHelper does. Instead, you provide the names and values manually.
    #
    # NOTE: The HTML options <tt>disabled</tt>, <tt>readonly</tt>, and <tt>multiple</tt> can all be treated as booleans. So specifying
    # <tt>:disabled => true</tt> will give <tt>disabled="disabled"</tt>.
    module FormTagHelper

      def date_field_tag(name, value = nil, options = {})
        text_field_tag(name, value, options.stringify_keys.update("type" => "date"))
      end

      def time_field_tag(name, value = nil, options = {})
        text_field_tag(name, value, options.stringify_keys.update("type" => "time"))
      end
    end

    module FormHelper
      def time_field(object_name, method, options = {})
        InstanceTag.new(object_name, method, self, options.delete(:object)).to_input_field_tag("time", options)
      end
    end


    class FormBuilder
      # The methods which wrap a form helper call.
      class_attribute :field_helpers
      self.field_helpers = FormHelper.instance_method_names - %w(form_for convert_to_model)

      attr_accessor :object_name, :object, :options

      attr_reader :multipart, :parent_builder
      alias :multipart? :multipart

      def multipart=(multipart)
        @multipart = multipart
        parent_builder.multipart = multipart if parent_builder
      end

      def self._to_partial_path
        @_to_partial_path ||= name.demodulize.underscore.sub!(/_builder$/, '')
      end

      def to_partial_path
        self.class._to_partial_path
      end

      def to_model
        self
      end

      def initialize(object_name, object, template, options, proc)
        @nested_child_index = {}
        @object_name, @object, @template, @options, @proc = object_name, object, template, options, proc
        @parent_builder = options[:parent_builder]
        @default_options = @options ? @options.slice(:index, :namespace) : {}
        if @object_name.to_s.match(/\[\]$/)
          if object ||= @template.instance_variable_get("@#{Regexp.last_match.pre_match}") and object.respond_to?(:to_param)
            @auto_index = object.to_param
          else
            raise ArgumentError, "object[] naming but object param and @object var don't exist or don't respond to to_param: #{object.inspect}"
          end
        end
        @multipart = nil
      end

      (field_helpers - %w(label check_box radio_button fields_for hidden_field file_field)).each do |selector|
        class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
          def #{selector}(method, options = {})  # def text_field(method, options = {})
            @template.send(                      #   @template.send(
              #{selector.inspect},               #     "text_field",
              @object_name,                      #     @object_name,
              method,                            #     method,
              objectify_options(options))        #     objectify_options(options))
          end                                    # end
        RUBY_EVAL
      end

      def fields_for(record_name, record_object = nil, fields_options = {}, &block)
        fields_options, record_object = record_object, nil if record_object.is_a?(Hash) && record_object.extractable_options?
        fields_options[:builder] ||= options[:builder]
        fields_options[:parent_builder] = self
        fields_options[:namespace] = fields_options[:parent_builder].options[:namespace]

        case record_name
          when String, Symbol
            if nested_attributes_association?(record_name)
              return fields_for_with_nested_attributes(record_name, record_object, fields_options, block)
            end
          else
            record_object = record_name.is_a?(Array) ? record_name.last : record_name
            record_name   = ActiveModel::Naming.param_key(record_object)
        end

        index = if options.has_key?(:index)
                  "[#{options[:index]}]"
                elsif defined?(@auto_index)
                  self.object_name = @object_name.to_s.sub(/\[\]$/,"")
                  "[#{@auto_index}]"
                end
        record_name = "#{object_name}#{index}[#{record_name}]"

        @template.fields_for(record_name, record_object, fields_options, &block)
      end

      def label(method, text = nil, options = {}, &block)
        @template.label(@object_name, method, text, objectify_options(options), &block)
      end

      def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
        @template.check_box(@object_name, method, objectify_options(options), checked_value, unchecked_value)
      end

      def radio_button(method, tag_value, options = {})
        @template.radio_button(@object_name, method, tag_value, objectify_options(options))
      end

      def hidden_field(method, options = {})
        @emitted_hidden_id = true if method == :id
        @template.hidden_field(@object_name, method, objectify_options(options))
      end

      def file_field(method, options = {})
        self.multipart = true
        @template.file_field(@object_name, method, objectify_options(options))
      end

      # Add the submit button for the given form. When no value is given, it checks
      # if the object is a new resource or not to create the proper label:
      #
      #   <%= form_for @post do |f| %>
      #     <%= f.submit %>
      #   <% end %>
      #
      # In the example above, if @post is a new record, it will use "Create Post" as
      # submit button label, otherwise, it uses "Update Post".
      #
      # Those labels can be customized using I18n, under the helpers.submit key and accept
      # the %{model} as translation interpolation:
      #
      #   en:
      #     helpers:
      #       submit:
      #         create: "Create a %{model}"
      #         update: "Confirm changes to %{model}"
      #
      # It also searches for a key specific for the given object:
      #
      #   en:
      #     helpers:
      #       submit:
      #         post:
      #           create: "Add %{model}"
      #
      def submit(value=nil, options={})
        value, options = nil, value if value.is_a?(Hash)
        value ||= submit_default_value
        @template.submit_tag(value, options)
      end

      # Add the submit button for the given form. When no value is given, it checks
      # if the object is a new resource or not to create the proper label:
      #
      #   <%= form_for @post do |f| %>
      #     <%= f.button %>
      #   <% end %>
      #
      # In the example above, if @post is a new record, it will use "Create Post" as
      # submit button label, otherwise, it uses "Update Post".
      #
      # Those labels can be customized using I18n, under the helpers.submit key and accept
      # the %{model} as translation interpolation:
      #
      #   en:
      #     helpers:
      #       button:
      #         create: "Create a %{model}"
      #         update: "Confirm changes to %{model}"
      #
      # It also searches for a key specific for the given object:
      #
      #   en:
      #     helpers:
      #       button:
      #         post:
      #           create: "Add %{model}"
      #
      def button(value=nil, options={})
        value, options = nil, value if value.is_a?(Hash)
        value ||= submit_default_value
        @template.button_tag(value, options)
      end

      def emitted_hidden_id?
        @emitted_hidden_id ||= nil
      end

      private
      def objectify_options(options)
        @default_options.merge(options.merge(:object => @object))
      end

      def submit_default_value
        object = convert_to_model(@object)
        key    = object ? (object.persisted? ? :update : :create) : :submit

        model = if object.class.respond_to?(:model_name)
                  object.class.model_name.human
                else
                  @object_name.to_s.humanize
                end

        defaults = []
        defaults << :"helpers.submit.#{object_name}.#{key}"
        defaults << :"helpers.submit.#{key}"
        defaults << "#{key.to_s.humanize} #{model}"

        I18n.t(defaults.shift, :model => model, :default => defaults)
      end

      def nested_attributes_association?(association_name)
        @object.respond_to?("#{association_name}_attributes=")
      end

      def fields_for_with_nested_attributes(association_name, association, options, block)
        name = "#{object_name}[#{association_name}_attributes]"
        association = convert_to_model(association)

        if association.respond_to?(:persisted?)
          association = [association] if @object.send(association_name).is_a?(Array)
        elsif !association.respond_to?(:to_ary)
          association = @object.send(association_name)
        end

        if association.respond_to?(:to_ary)
          explicit_child_index = options[:child_index]
          output = ActiveSupport::SafeBuffer.new
          association.each do |child|
            output << fields_for_nested_model("#{name}[#{explicit_child_index || nested_child_index(name)}]", child, options, block)
          end
          output
        elsif association
          fields_for_nested_model(name, association, options, block)
        end
      end

      def fields_for_nested_model(name, object, options, block)
        object = convert_to_model(object)

        parent_include_id = self.options.fetch(:include_id, true)
        include_id = options.fetch(:include_id, parent_include_id)
        options[:hidden_field_id] = object.persisted? && include_id
        @template.fields_for(name, object, options, &block)
      end

      def nested_child_index(name)
        @nested_child_index[name] ||= -1
        @nested_child_index[name] += 1
      end

      def convert_to_model(object)
        object.respond_to?(:to_model) ? object.to_model : object
      end
    end

  end

end
