# go-vips

libvips builder image for golang. building this in a docker image takes so long that it's worth it to stick it into its own image.

```
docker pull amelia/go-vips
```

```
FROM amelia/go-vips:latest as builder
...
```
