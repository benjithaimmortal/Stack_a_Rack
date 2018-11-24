This middleware is kind of sort of a copy of Rack::Static. It parses the path in an HTTP GET request, matches it with the /public directory's files, and serves the response in traditional Rack [response, header, body] form.

There are a few different directions I'm going next with this:
1. Separate response, header, and body into independent variables, to DRY out the code and make it more flexible
2. Address the MIME type of each file