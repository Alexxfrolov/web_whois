# Getwhois
Web application for whois data

## Setup

Prepare development mode:

Copy `.env.sample` to `env.development` and set url for redis (used to cache data).
Set `USE_CACHE=false` if you need to disable caching.

How to run the development console:

```
% bundle exec hanami console
```

How to run the development server:

```
% bundle exec hanami server
```

How to run tests:

```
% bundle exec rake
```
## Setup production
All required variables are in `.env.sapmple`.

When using heroku:
- add redis in `Add-ons`
- in `Settings` open `Config Vars` and set variables from sample
