class Button::Component < ApplicationComponent
  option :text
  option :as, default: -> { :link }  # :link or :button_to
  option :variant, default: -> { :primary }  # :primary, :danger, :ghost
  option :href, optional: true
  option :method, optional: true

  private

  def button_classes
    [
      "px-4 py-2 text-sm font-medium rounded-md transition-colors inline-flex items-center justify-center",
      variant_classes
    ].join(" ")
  end

  def variant_classes
    case variant
    when :primary
      "bg-blue-600 hover:bg-blue-700 text-white"
    when :danger
      "bg-red-600 hover:bg-red-700 text-white"
    when :ghost
      "text-gray-700 hover:text-gray-900 hover:bg-gray-100"
    end
  end
end
