
[![Build Status](https://travis-ci.org/leandrojdl/mumuki-sqlite-runner.svg?branch=master)](https://travis-ci.org/leandrojdl/mumuki-sqlite-runner)
```
[![Code Climate](https://codeclimate.com/github/mumuki/mumuki-qsim-server/badges/gpa.svg)](https://codeclimate.com/github/mumuki/mumuki-qsim-server)
[![Test Coverage](https://codeclimate.com/github/mumuki/mumuki-qsim-server/badges/coverage.svg)](https://codeclimate.com/github/mumuki/mumuki-qsim-server)
```


# Mumuki Sqlite Runner

Motor de SQLite para integrarse a la [Plataforma Mumuki](https://mumuki.io/).

## Disclaimer

Este proyecto nace a partir del _Proyecto de Inserción Profesional_ el cual estoy desarrollando
para el cierre de la _Tecnicatura en Programación Informática_ en la _Universidad Nacional de Quilmes_.

Es por ello que tanto el proyecto como esta documentación se encuentran en constante construcción.

La información asociada al informe del _TIP_ puede encontrarse en la [Wiki](https://github.com/leandrojdl/mumuki-sqlite-runner/wiki).

El resto del README será utilizado como detalle de instalación y funcionamiento del _Runner_.

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
$ rspec spec/runner_spec.rb    # temporary until the project is complete
```
