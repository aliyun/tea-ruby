# frozen_string_literal: true

require 'net/http'

# The Tea module
module Tea
  VERSION = '0.0.2'

  module_function

  def allow_retry(_retry_policy, retry_times, _now)
    # TODO
    return false if retry_times > 2

    true
  end

  # The Model class
  class Model
    def to_hash
      hash = {}
      names = self.class.name_mapping
      names.each do |key, value|
        hash[value] = instance_variable_get('@' + key)
      end
      hash
    end

    # new Model from hash
    def initialize(hash = nil)
      return if hash.nil?

      names = self.class.name_mapping
      types = self.class.type_mapping

      names.each do |key, value|
        type = types[key]
        if type.instance_of? Hash
          # array
          if type['type'].instance_of? String
            if type['type'] == 'array'
              instance_variable_set('@' + key, hash[value].map do |item|
                type['itemType'].new(item)
              end)
            end
          else
            instance_variable_set('@' + key, type.new(hash[value]))
          end
        elsif type.instance_of? Class
          instance_variable_set('@' + key, type.new(hash[value]))
        else
          instance_variable_set('@' + key, hash[value])
        end
      end
    end
  end

  # The RetryError class
  class RetryError < StandardError
    def initialize(request, response); end
  end

  def retryable?(err)
    err.instance_of?(RetryError)
  end

  def unable_retry_error(request)
    # TODO
  end

  def get_backoff_time(_policy, _times)
    0
  end

  # The UnableRetryError class
  class UnableRetryError < StandardError
    def initialize(request); end
  end

  # The Error class
  class Error < StandardError
    def initialize(err)
      super(err['message'])
    end
  end

  def to_uri(req)
    type = req['protocol'] == 'https' ? URI::HTTPS : URI::HTTP
    uri = type.build(
      host: req['headers']['host'],
      path: req['pathname'],
      query: URI.encode_www_form(req['query']),
      fragment: ''
    )
    uri.port = req['port'] if req['port']
    uri
  end

  def do_request(request, runtime = nil)
    uri = to_uri(request)
    case request['method'].downcase || 'get'
    when 'get'
      return Net::HTTP.get_response(uri)
    else
      puts 'default'
    end
  end
end
