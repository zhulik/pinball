## Pinball [![Build Status](https://travis-ci.org/zhulik/pinball.svg?branch=master)](https://travis-ci.org/zhulik/pinball) [![Coverage Status](https://img.shields.io/coveralls/zhulik/pinball.svg)](https://coveralls.io/r/zhulik/pinball?branch=master) [![Code Climate](https://codeclimate.com/github/zhulik/pinball.png)](https://codeclimate.com/github/zhulik/pinball)

### Simple IOC Container and DI tool for ruby.

Pinball is a library for using dependency injection within ruby
applications. It provides a clear IOC Container that manages
dependencies between your classes.

# Features

* Stores objects, classes(as factories) and blocks
* Can inject dependencies to classes and instances
* Simple DSL for configuring the container
* Stored block will be call in dependent class instance
* You can describe any context-dependent code in blocks

## Usage

### Class injection

Consider a `Service` class that has a dependency on a `Repository`. We would
like this dependency to be available to the service when it is created.

First we create a container object and declare the dependencies.

```ruby
require 'pinball'

Pinball::Container.configure do
  define :repository, Repository
end
```

Then we declare the `repository` dependency in the Service class by
using the `inject` declaration.

```ruby
class Service
  inject :repository
end
```

Now we can instantiate Service object and `repository` method will
be already accessible in it's constructor! In this case *repository*
method will return the instance of Repository
**Notice:** each call of `repository` will create new instance of `Repository`

### Object injection

Also you can inject any already existed object

```ruby
require 'pinball'

Pinball::Container.configure do
  define :string, 'any pre-defined string'
end
```

In this case `string` method will return 'any pre-defined string'

### Block injection

The most powerful feature of pinball is block injection.
For example, you have `FirstService` class, that dependent on
`SecondService` class, but for instantiating `SecondService` you need
to pass `@current_user` from `FirstService` to it's constructor:

```ruby
class FirstService
  inject :second_service

  def initialize(current_user)
    @current_user = current_user
  end
end

class SecondService
  def initialize(current_user)
    @current_user = current_user
  end
end
```

Simple defining of `SecondService` dependency will not work here.
So we can define dependency with a block:

```ruby
Pinball::Container.configure do
  define :second_service do
    SecondService.new(@current_user)
  end
end
```

This block will be executed it `FirstService` instance context and
`@current_user` will be accessible
**Notice:** each call of `second_service` will call this block over and over again

