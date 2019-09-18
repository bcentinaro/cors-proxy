# CorsProxy

A simple proxy server that enables CORS requests for Front End Devs. Thrown together quickly to help my wife with a test project. 

## Usage

Start the container with `docker run -p 3000:80 -it bcentinaro/cors-proxy:latest`

It will translate Get, Post, Put, and Delete requests, Options requests are intercepted and return the broadest access control headers possible.

### Post Example 

```
curl -X POST \
  http://localhost:3000/https://postman-echo.com/post \
  -H 'Accept: */*' \
  -H 'Accept-Encoding: gzip, deflate' \
  -H 'Content-Type: application/json' \
  -d '{ 
"test": "true"
}'
```
