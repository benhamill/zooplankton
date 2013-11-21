# Zooplankton [![Build Status](https://travis-ci.org/benhamill/zooplankton.png)](https://travis-ci.org/benhamill/zooplankton) [![Code Climate](https://codeclimate.com/github/benhamill/zooplankton.png)](https://codeclimate.com/github/benhamill/zooplankton)

Zooplankton is a library for helping you turn Rails routes into
[URI Template strings](http://tools.ietf.org/html/rfc6570). It's useful for
helping yourself generate the `_links` part of
[HAL](http://stateless.co/hal_specification.html), for example.

## Installation

Add this line to your application's Gemfile:

    gem 'zooplankton'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zooplankton

## Usage

Given a route file like this:

```ruby
SomeApp::Application.routes.draw do
  root 'root#index'
  get '/post/:slug', to: 'posts#show', as: :post
  get '/post/:slug/comment/:comment_id', to: 'commendts#show', as: :comment
end
```

You can use it like this:

```ruby
> Zooplankton.path_template_for(:root)
# => '/'
> Zooplankton.path_template_for(:post)
# => '/post/{slug}'
> Zooplankton.path_template_for(:comment)
# => '/post/{slug}/comment/{comment_id}'
```

It also handles replacing some (or all) of the templated variables if you want
to prepopulate some of them ahead of time:

``` ruby
> Zooplankton.path_template_for(:comment, slug: 'the-best-post-ever')
# => '/post/the-best-post-ever/comment/{comment_id}'
```

And you can add some query parameters when you're generating the template, if
you need:

``` ruby
> Zooplankton.path_template_for(:comment, :q, slug: 'the-best-post-ever')
# => '/post/the-best-post-ever/comment/{comment_id}{?q}'
> Zooplankton.path_template_for(:comment, %i(foo bar), slug: 'the-best-post-ever')
# => '/post/the-best-post-ever/comment/{comment_id}{?foo,bar}'
> Zooplankton.path_template_for(:comment, %i(foo bar))
# => '/post/{slug}/comment/{comment_id}{?foo,bar}'
```

If you supply a query parameter for replacement, it'll denote a continuation:

``` ruby
> Zooplankton.path_template_for(:comment, %i(foo bar), slug: 'the-best-post-ever', bar: 'baz')
# => '/post/the-best-post-ever/comment/{comment_id}?bar=baz{&foo}'
```

It'll generate URLs, too, not just paths.

``` ruby
> Zooplankton.url_template_for(:root)
# => 'http://example.com/'
> Zooplankton.url_template_for(:post)
# => 'http://example.com/post/{slug}'
```

## Contributing

Help is gladly welcomed. If you have a feature you'd like to add, it's much more
likely to get in (or get in faster) the closer you stick to these steps:

1. Open an Issue to talk about it. We can discuss whether it's the right
   direction or maybe help track down a bug, etc.
1. Fork the project, and make a branch to work on your feature/fix. Master is
   where you'll want to start from.
1. Turn the Issue into a Pull Request. There are several ways to do this, but
   [hub](https://github.com/defunkt/hub) is probably the easiest.
1. Make sure your Pull Request includes tests.
1. Bonus points if your Pull Request updates `CHANGES.md` to include a summary
   of your changes and your name like the other entries. If the last entry is
   the last release, add a new `## Unreleased` heading.

If you don't know how to fix something, even just a Pull Request that includes a
failing test can be helpful. If in doubt, make an Issue to discuss.
