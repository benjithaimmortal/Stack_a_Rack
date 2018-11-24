require 'rack/mime'

# This is where we figure out available routes and point appropriate things at them
module Router

  def get(path)
    # Make a root directory at path...
    root = File.expand_path(File.dirname(__FILE__))
    root_path = root + "/public" + path

    # List out some common routes...
    route_index      = [200, {"Content-Type" => "text/html"}, File.open("public/index.html")]
    route_404        = [404, {"Content-Type" => "text/html"}, File.open("public/404.html")]
    route_redirect   = [300, {"Content-Type" => "text/html"}, ["You tried to access #{root_path} but it's not here. I wrote this message for you until I figure out how best to redirect you."]]

    # Sort by the URL path... and return the correct file!
    if path == "/"
      route_index
    elsif path == nil
      route_404
    else
      available_route  = [200, {"Content-Type" => "text/html"}, File.open("#{root_path}")]
      File.exist?(root_path) ? available_route : route_redirect
    end
  end
    
  def method_not_allowed(method)
    [405, {}, ["Method not allowed: #{method}"]]
  end
end


class Application

  include Router

  # This is the middleware application calling rack and taking the (env) HTTP request...
  def call(env)
    route(env['REQUEST_METHOD'], env['PATH_INFO'])
  end

  # ... and this is a method that routes the HTTP method, then matches the URL path to the directory path
  def route(method, path)
    if method == "GET"
      get(path)
    else
      method_not_allowed(method)
    end
  end
end



run Application.new