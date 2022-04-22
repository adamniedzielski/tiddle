# Contributing

1. Fork the repo.
2. Run the tests:

  ```
  BUNDLE_GEMFILE=gemfiles/<PICK YOUR FAVOURITE>.gemfile rake
  ```
3. Introduce your change. If it's a new feature then write a test for it as well.
4. Make sure that tests are passing.
5. Push to your fork and submit a pull request.

#### Docker for development

Alternatively you can use Docker for the development setup. This requires Docker
and Docker Compose installed.

```
make build
make bundle
```

And in order to run the tests and linter checks:

```
make test
```

After you're done, cleanup leftover containers:

```
make cleanup
```
