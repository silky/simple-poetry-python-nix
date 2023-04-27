# About

A small Python-Poetry2Nix-Docker project.

It demonstrates

- Defining and running a simple Python app,
- Packaging it into a Docker image,
- Running it via Nix, or via the poetry-constructed binary,
- Running via Docker, providing the envars.


### Pre-reqs

- A `.env` file. You can symlink the example one:

```
ln -s .env-example .env
```


### Running

Via Nix:

```shell
> nix run .
```

or

via the Nix-shell binary created by poetry2nix

```shell
> nix develop
> some-app
```

or just as a simple Python module:

```shell
python -m some_app.main
```

or as a Docker image:

```shell
> docker load < $(nix build .#docker --print-out-paths)
...
Loaded image: some-app-image:abc
> docker run --env-file .env some-app-image:abc
```
