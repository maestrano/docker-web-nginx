# docker-web-nginx
Docker image packed with git, s3 and nginx.

## Examples
Launch a static html app from a public github repository (must contains a index.html in the root of the folder)
```
docker run -P -d -e GIT_URL=https://github.com/alachaum/sample_app_rails_4 -e GIT_BRANCH=master maestrano/web-nginx
```

Launch a static app from a private github repository
```
docker run -P -d -e GIT_URL=https://MY_GITHUB_OAUTH_TOKEN@github.com/alachaum/sample_app_rails_4 -e GIT_BRANCH=master maestrano/web-nginx
```

Launch a static app from a private S3 bucket
```
docker run -P -d -e S3_URI=s3://cdn-prd-maestrano/pkg/sample/sample_app_rails.tar.gz \
  -e S3_ACCESS_KEY_ID=MY_AWS_KEY \
  -e S3_SECRET_ACCESS_KEY=MY_AWS_SECRET \
  maestrano/web-nginx
```

Launch a static app from a public S3 bucket
Note: it is preferable to specify the region of your bucket when no authentication is used
```
docker run -P -d -e S3_URI=s3://cdn-prd-maestrano/pkg/sample/sample_app_rails.tar.gz \
  -e S3_REGION=ap-southeast-1
  maestrano/web-nginx
```

Launch a rails app from a local folder
```
docker run -P -d -v /some/local/app:/app maestrano/web-nginx
```

## Nginx configuration
You can customise the default nginx configuration for your app to accomodate any kind of requirements for serving your static assets and SPAs.
Just drop a `nginx.conf` file in the root of your folder and it will automatically be picked up by web-nginx.

The default nginx configuration file is [available here](1.6/app.conf).
