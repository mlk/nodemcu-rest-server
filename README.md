# nodemcu-rest-server
A basic Web server designed arround building basic REST resources.

To use this create an array called HttpRequests with the index as the resource name and the value as an object. The object should provide a method for each HTTP method supported. 

The resource name will be matched it you hit /resourcename, /resourcename/ or /resourcename/<number>

Each returns a `response` object with the following members.

`status` The HTTP status to return.
`content` A Lua object which will be converted to JSON before being returned. 
`headers` An array of headers, index as the header name, value as the header value.


NOTE: As this requires the code and mapping to be in memory I do *NOT* recomemend using it for anything other than very very small web services. 
