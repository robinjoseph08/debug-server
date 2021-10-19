# debug-server

A basic debugging server used when testing deployments

## Development

### Start Server

```sh
make
```

### Build

This builds a Docker image with the commit hash as the tag, and if the working
tree is dirty, it will add `dirty` and a timestamp in the tag as well, so that
it's unique.

```sh
make deploy
```

### Deploy

Deploying means building a new Docker image (as explained above) and pushing it
up to Docker Hub. Obviously, you need the right credentials to push it.

```sh
make deploy
```

## Usage

The server listens on the port that's passed in through the `PORT` environment
variable. If there is no `PORT` environment variable, it will default to `9876`.

### Endpoints

#### `GET /`

This is a basic endpoint that just returns the following response:

```json
{
  "hello": "world"
}
```

You can use it as a health check or just to verify that the container was
successfully started and can be reached.

#### `GET /env`

This will return all the environment variables that the web process currently
has access to. This can be used to verify that environment variables are being
passed through correctly. This is particularly useful when testing secret
management, and you want to make sure that your applications can get access to
encrypted secrets.

**Note:** This can unintentionally leak sensitive information if it has access
to sensitive environment variables. It doesn't log the data anywhere, but if
there's anything in between you and the container that could be logging it, that
would be bad. It's also sending this data over the wire, so if you're not using
HTTPS, it can be sniffed. This server is only meant for debugging and testing
purposes, so you shouldn't give it access to anything that's actually sensitive.
You have been warned.
