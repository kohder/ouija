Ouija
=====

Ouija is a RubyGem that makes configuration clean and simple.  Separate
concerns are in separate config files (yaml, currently).  Configuration
is kept DRY by allowing you to declare the bulk of the settings as common
(hopefully) and then let's you override where necessary by environment and
hostname.  At runtime, Ouija collapses the configuration into one graph based
on the current context -- hostname and environment (both of which can be
overridden).

Installation
------------

    gem install ouija

Overriding
----------

Ouija collapses config settings at runtime based on current hostname and
environment.  Tree structure is merged and values are overridden.  Values
that are arrays are also overridden, not merged. See usage example below.

Override precedence:

`hosts` entries override

`environments` entries which override

`default` entries

Usage example
-------------

Config file `PROJECT_ROOT/config/ouija/foo.yml`

    default:
      output_dir: /usr/local/foo/results
      logging:
        log_dir: /var/log/foo
      output_queues:
        - 'NormalQueue'
    environments:
      production:
        logging:
          level: ERROR
        output_queues:
          - 'NormalQueue'
          - 'SamplingQueue'
      staging:
        logging:
          level: INFO
      development:
        logging:
          level: DEBUG
        output_queues:
          - 'DevQueue'
    hosts:
      My-MacBook-Pro.local:
        output_dir: ./results
        logging:
          log_dir: ./log

Driver script `PROJECT_ROOT/script/foo`

    #!/usr/bin/env ruby
    require 'rubygems'
    require 'bundler/setup'
    Bundler.require
    require 'ouija'
    Ouija.setup
    planchette = Ouija.session('foo')
    puts planchette.to_hash.inspect

Results on host with name `My-MacBook-Pro.local`

    $ script/foo
    {"output_dir"=>"./results", "logging"=>{"log_dir"=>"./log", "level"=>"DEBUG"}, "output_queues"=>["DevQueue"]}
    $ OUIJA_ENV=staging script/foo
    {"output_dir"=>"./results", "logging"=>{"log_dir"=>"./log", "level"=>"INFO"}, "output_queues"=>["NormalQueue"]}
    $ OUIJA_ENV=production script/foo
    {"output_dir"=>"./results", "logging"=>{"log_dir"=>"./log", "level"=>"ERROR"}, "output_queues"=>["NormalQueue", "SamplingQueue"]}

Legal stuff
-----------

Copyright (c) 2012, Rob Lewis ([kohder](http://github.com/kohder))

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
