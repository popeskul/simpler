require_relative 'view'

module Simpler
  class Controller
    TYPES = { html: 'text/html', plain: 'text/plain' }.freeze

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_headers
      send(action)
      write_response

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_headers(type = :html)
      headers['Content-Type'] = TYPES.fetch(type, :html)
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params
      @request.env['simpler.params']
    end

    def render(template)
      set_headers(:plain) if template.keys.first == :plain
      @request.env['simpler.template'] = template
    end

    def headers
      @response.header
    end

    def status(status)
      @response.status = status
    end

  end
end
