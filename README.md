
```
FIXME when 
[![Build Status](https://travis-ci.org/mumuki/mumuki-qsim-runner.svg?branch=master)](https://travis-ci.org/mumuki/mumuki-qsim-runner)
[![Code Climate](https://codeclimate.com/github/mumuki/mumuki-qsim-server/badges/gpa.svg)](https://codeclimate.com/github/mumuki/mumuki-qsim-server)
[![Test Coverage](https://codeclimate.com/github/mumuki/mumuki-qsim-server/badges/coverage.svg)](https://codeclimate.com/github/mumuki/mumuki-qsim-server)
```


# Runner

It performs equality tests on one or many records after the execution of a given Qsim program.

## Tests

Tests must be defined in a YAML-based string, following this structure.

~~~javascript
{ examples: [test1, test2] }
~~~

Each individual test consists of a name, preconditions, postconditions and output configuration.
Both preconditions and output are optional. If they are not specified, default values will be set.

* **Preconditions** are values we want our Qsim environment to start with.
* **Postconditions** are expectations on post-execution record values.
* **Output configurations** are used to specify which fields will be shown at the end of program. 

In the example given below the program sets `R0 = AAAA` and `0001 = BBBB`, and expects
that `R0` final value is `FFFF`. Records, flags, special records and memory addresses can be set.

~~~javascript
test1 = {
    name: 'R0 should remain unchanged',
    preconditions: {
        R0: 'AAAA',
        0001: 'BBBB'
    },
    postconditions: {
        equal: {
            R0: 'FFFF'
        }
    }
}
~~~

Besides from it's default value, output can be modified by tweaking some keys. 
Each key is tied to one category, and it determines whether the category is displayed or not. 

* **memory**: (*`false` by default*) Can be either a `range` or `false`
* **records**: (*`true` by default*) Can be either `true` or `false`
* **flags**: (*`false` by default*) Can be either `true` or `false`
* **special_records**: (*`false` by default*) Can be either `true` or `false`
 
As populating the screen with all of the memory records wouldn't be wise, an address start and end must be declared.
  
~~~javascript
range = { from: '0000', to: 'FFFF' }
~~~

Now, let's modify the previous example in order to display only flags, 
special records and memory from `AAAA` to `BBBB`

~~~javascript
test1_with_output = {
    name: 'R0 should remain unchanged',
    preconditions: {
        R0: 'AAAA',
        0001: 'BBBB'
    },
    postconditions: {
        equal: {
            R0: 'FFFF'
        }
    },
    output: {
        flags: true,
        records: false,
        special_records: true,
        memory: {
            from: 'AAAA',
            to: 'BBBB'
        }
    }
}
~~~

And finally in YAML format:

~~~yaml
examples:
  - name: 'R0 should remain unchanged'        
    postconditions:
      equal:
        R0: 'AAAA'
        '0001': 'BBBB' 
    postconditions:
      equal:
        R0: 'FFFF'
    output:
      flags: true
      records: false
      special_records: true
      memory:
        from: 'AAAA'
        to: 'BBBB'
~~~

Additional full examples can be found in the [integration suite](https://github.com/mumuki/mumuki-qsim-runner/blob/master/spec/integration_spec.rb) or [programs folder](https://github.com/mumuki/mumuki-qsim-runner/tree/master/spec/data)

# Install the server

## Clone the project

```
git clone https://github.com/mumuki/mumuki-qsim-server 
cd mumuki-qsim-server
```

## Install Ruby

```bash
rbenv install 2.3.1
rbenv rehash
gem install bundler
```

## Install Dependencies

```bash
bundle install
```

# Run the server

```bash
RACK_ENV=development bundle exec rackup -p 4567
```

## Testing

### Install docker

https://docs.docker.com/engine/installation/

#### Verify docker installation

```bash
$ sudo docker run hello-world
```

#### Allow docker run without root privileges

```bash
# Create the docker group
$ sudo groupadd docker

# Add your user to the docker group.
$ sudo usermod -aG docker $USER
```

Log out and log back in so that your group membership is re-evaluated.

```bash
# Verify that you can docker commands without sudo.
$ docker run hello-world
```

### Pull docker container

```bash
# FIXME: Temporary while the tests are those of qsim
$ docker pull mumuki/mumuki-qsim-worker
```

### Run tests

```bash
$ bundle exec rake 
```

### Generate docker container

```bash
$ cd mumuki-sql-runner/worker
$ docker build -t mumuki-sql .      # build container
$ docker run -it --rm mumuki-sql    # run container
```

If you need to destroy container, run:

```bash
$ docker rmi mumuki-sql
```

And then you can re-build it.
