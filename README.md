# Diary
Simple diary system. Unlike a blog, this system is suitable for writing everyday life, events, thoughts and other miscellaneous contents.

This system is actually used by me. If you are interested in, please visit [Noraworld Diary](https://diary.noraworld.jp).

## Version
This system works successfully under the following environments.

* Ruby on Rails 4.2.6
* Ruby 2.0.0p353

In terms of the RubyGems dependencies, see [Gemfile](https://github.com/noraworld/diary.noraworld.jp/blob/master/Gemfile).

## Environment Variables
The environment variables are under the control of `.env` file. Create `.env` file under Rails application directory and append the environment variables below to `.env` file.

```Ruby
HOST_NAME='your site URL'
UNICORN_SOCKET='unicorn socket file path'
UNICORN_PID='unicorn pid file path'
RAILS_ENVIRONMENT='development or production'
```

### Hostname
`HOST_NAME` is your site URL like `diary.noraworld.jp`. You can use local IP address like `192.168.33.10` or provisional host name using `/etc/hosts` file for development environment.

### Unicorn Socket
`UNICORN_SOCKET` is socket file path of Unicorn for production environment. Basically, this file is located `RAILS_ROOT/tmp/unicorn.sock`, so the path is like `/home/USERNAME/diary/tmp/unicorn.sock`.

**NOTICE:** You should install Unicorn before using it. If you only use in development environment, this environment is unnecessary.

### Unicorn PID
`UNICORN_PID` is same as `UNICORN_SOCKET`. The path is like `/home/USERNAME/diary/tmp/unicorn.pid`.

### Rails Environment
`RAILS_ENVIRONMENT` is `development` or `production`. You can select either with your environment.

## License
All codes of this repository are available under the MIT license. See the [LICENSE](https://github.com/noraworld/diary.noraworld.jp/blob/master/LICENSE) for more information.
