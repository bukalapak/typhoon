# frozen_string_literal: true

class FileValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.attached?
    record.errors.add(attribute, :file, options) unless File.extname(value.filename.to_s).include? options[:ext]
  end
end
