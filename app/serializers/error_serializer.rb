class ErrorSerializer
  def self.serialize(errors, status = "400")
    case errors
    when ActiveRecord::Base
      serialize_model_errors(errors, status)
    when Array
      serialize_array_errors(errors, status)
    when String
      serialize_single_error(errors, status)
    when Hash
      serialize_hash_errors(errors, status)
    else
      serialize_unknown_error(errors, status)
    end
  end

  def self.render_error(errors, status_code = 400)
    {
      errors: serialize(errors, status_code.to_s)
    }
  end

  private

  def self.serialize_model_errors(model, status)
    model.errors.map do |error|
      {
        status: status,
        title: "Validation Error",
        detail: "#{error.attribute.to_s.humanize} #{error.message}",
        source: {
          pointer: "/data/attributes/#{error.attribute}"
        }
      }
    end
  end

  def self.serialize_array_errors(errors, status)
    errors.map do |error|
      if error.is_a?(Hash)
        {
          status: error[:status] || status,
          title: error[:title] || "Error",
          detail: error[:detail] || error[:message] || error.to_s,
          source: error[:source]
        }
      else
        {
          status: status,
          title: "Error",
          detail: error.to_s
        }
      end
    end
  end

  def self.serialize_single_error(error, status)
    [{
      status: status,
      title: "Error",
      detail: error
    }]
  end

  def self.serialize_hash_errors(errors, status)
    errors.map do |key, value|
      {
        status: status,
        title: "Validation Error",
        detail: value.is_a?(Array) ? value.join(", ") : value.to_s,
        source: {
          pointer: "/data/attributes/#{key}"
        }
      }
    end
  end

  def self.serialize_unknown_error(error, status)
    [ {
      status: status,
      title: "Error",
      detail: error.to_s
    } ]
  end
end
