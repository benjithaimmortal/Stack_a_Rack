require 'rack/mime'

# This is where we figure out available routes and point appropriate things at them
module Router

  def get(path)
    # Make a root directory at path...
    root = File.expand_path(File.dirname(__FILE__))
    root_path = root + "/public" + path
    
    # List some common routes...
    available  = { status: 200, header: {"Content-Type" => "text/html"},  body: File.open("#{root_path}")      }
    error      = { status: 404, header: {"Content-Type" => "text/html"},  body: File.open("public/404.html")   }
    index      = { status: 200, header: {"Content-Type" => "text/html"},  body: File.open("public/index.html") }
    redirect   = { status: 300, header: {"Content-Type" => "text/plain"}, body: ["You tried to access #{root_path} but 
                                                    it's not here. I wrote this message for you until I figure out how best to redirect you."] }

    # Sort by the URL path...
    if path == "/"
      route_return(index)
    elsif path == nil
      route_return(error)
    else
      File.exist?(root_path) ? route_return(available) : route_return(redirect)
    end
  end

  def route_return(reqs)
    # ...and return the correct file!
    reqs.values
  end

  # unless you're not using GET
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