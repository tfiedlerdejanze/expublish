# Getting started

1\. Create a new `RELEASE.md` containing the new changelog entry:

```bash
$ echo "- changelog entry one\n- changelog entry two" > RELEASE.md
```

2\. Run one of `mix expublish.(major|minor|patch)`:

```bash
$ mix expublish.minor
```

3\. That's it!

## Note on hex authentication

Regardless of publishing to [hex.pm](https://hex.pm/) or a self-hosted hex repository, the shell environment where
`mix expublish` is being executed must authenticate for the publishing step to succeed.

While publishing to hex.pm usually requires a valid `HEX_API_TOKEN` to be defined in the current environment, self-hosted repositories can use a range of various authentication methods.
Check the hex documentation on [publishing](https://hex.pm/docs/publish) and [self-hosting](https://hex.pm/docs/self_hosting) to find out more.

