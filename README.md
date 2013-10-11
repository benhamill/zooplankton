# Zooplankton

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
> Zooplankton.path_template_for(:comment, slug: 'the-best-post-ever')
# => '/post/the-best-post-ever/comment/{comment_id}'
> Zooplankton.url_template_for(:root)
# => 'http://example.com/'
> Zooplankton.url_template_for(:post)
# => 'http://example.com/post/{slug}'
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
