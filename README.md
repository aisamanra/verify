# Verify

**WARNING**: `verify` is still in the experimental phase. **Do not
use this yet!**

The `verify` script is a small script that intends to make the
common and commonly-derided pattern of installing software with
`curl | sh` more secure. The `verify` script is a very small
interface on top of OpenBSD's [signify] tool for code-signing
that fits in the middle of pipelines, letting you transform
the insecure pipeline

~~~.sh
$ curl some-package | sh
~~~

to the more secure

~~~.sh
$ curl some-package.verified | verify | sh
~~~

## Running the Example

Make sure that OpenBSD's `signify` is somewhere in your `$PATH`.
Create a directory `$HOME/.trusted` and copy the public key
`example/sample-key.pub` to that directory. Afterwards, you'll
be able to download the sample script and execute its (trivial)
command:

~~~.sh
$ curl https://github.com/aisamanra/verify/raw/master/example/sample-payload.tar | verify | sh
If you can read this, then it has been verified.
~~~

If you delete that trusted key, then running the same command
will result in an error.
