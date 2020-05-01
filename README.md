# Confined: how to fit Go into a container

This is just an example project that makes good use (IMHO) of multi-stage
Docker build to bake dependencies into a temporary stage image.

The multi-stage magic of Docker makes that temporary stage image cached
and so can be re-used near instantaneously while go.mod or go.sum don't
change.
If they change, you pay the download of the modules once, and then
use the cached deps stage everytime you rebuild.

Therefore, you only run the build on the go test/go get if it's not a 
version of code that wasn't cached already (eg. you add some `println`
for debugging then remove them again: this version was already cached
so no real rebuilding necessary)

# Caveats

## Not free

Docker build is not free, and if your Docker build context is quite heavy
(and not using .dockerignore enough), the `build` stage COPY can make
the build via Docker very slow compared to a `go build`.
For me, as long as it takes less than 5-10 sec, I'm still OK.

## No hot-reload

I haven't investigated that part yet, and I don't know if it's possible
at all. After all, using a container to freeze some software binary in
a specific version doesn't really go well with "let's update the content
of that container on the fly".
And then, you lose the interesting factor of "build once, deploy everywhere."

I'm open to suggestions for this case.
