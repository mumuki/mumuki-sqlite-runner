
[![Build Status](https://travis-ci.org/leandrojdl/mumuki-sqlite-runner.svg?branch=master)](https://travis-ci.org/leandrojdl/mumuki-sqlite-runner)
[![Code Climate](https://codeclimate.com/github/leandrojdl/mumuki-sqlite-runner/badges/gpa.svg)](https://codeclimate.com/github/leandrojdl/mumuki-sqlite-runner)
[![Test Coverage](https://codeclimate.com/github/leandrojdl/mumuki-sqlite-runner/badges/coverage.svg)](https://codeclimate.com/github/leandrojdl/mumuki-sqlite-runner/coverage)


# Mumuki Sqlite Runner

Motor de SQLite para integrarse a la [Plataforma Mumuki](https://mumuki.io/).

## Disclaimer

> Este proyecto nace a partir del _Proyecto de Inserción Profesional_, el cual estoy desarrollando
> para el cierre de la Tecnicatura en Programación Informática en la Universidad Nacional de Quilmes.
>
> Es por ello que tanto el proyecto como esta documentación se encuentran en constante construcción.
>
> La información asociada al informe del _TIP_ puede encontrarse en la
> [Wiki](https://github.com/leandrojdl/mumuki-sqlite-runner/wiki).
>
> El resto del README será utilizado como detalle de instalación y funcionamiento del _Runner_.

## Install

#### Clone the Project

```bash
$ git clone https://github.com/leandrojdl/mumuki-sqlite-runner
$ cd mumuki-sqlite-runner
```

#### Install Ruby Environment

[Install rbenv](https://github.com/rbenv/rbenv#installation)

```bash
# install ruby
$ rbenv install 2.3.1
$ rbenv rehash

# install bundle gem
$ gem install bundler

# install project dependencies
$ bundle install
```

### Install Docker Environment

[Install Docker](https://docs.docker.com/engine/installation/)

Verify docker installation

```bash
$ sudo docker run hello-world
```

Allow docker run without root privileges

```bash
# Create the docker group
$ sudo groupadd docker

# Add your user to the docker group.
$ sudo usermod -aG docker [your-user]
```

Log out and log back in SO that your group membership is re-evaluated.

Then Verify that you can run docker commands without sudo.

```bash
$ docker run hello-world
```

Pull docker container

```bash
$ docker pull leandrojdl/mumuki-sqlite-worker
```

#### Run Tests

```bash
$ bundle exec rspec
```


#### Run the Server

```bash
$ bundle exec rackup -p 4567
```

If you need to verify that runner is running, open your web browser
and go to [http://localhost:4567/info](http://localhost:4567/info).
You should see a JSON response like this (but more extensive):

```json
{
  "name": "sqlite",
  "version": "0.1",
  "language": {
    "name": "sqlite",
    "version": "v0.2.2"
  },
  "url": "http://localhost:4567/info"
}
```
