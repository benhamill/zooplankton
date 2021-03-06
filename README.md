# Zooplankton

[![Build Status](https://travis-ci.org/benhamill/zooplankton.png)](https://travis-ci.org/benhamill/zooplankton)
[![Code Climate](https://codeclimate.com/github/benhamill/zooplankton.png)](https://codeclimate.com/github/benhamill/zooplankton)

[Zooplankton](http://en.wikipedia.org/wiki/Zooplankton) are the kind of
plankton that are animals (as opposed to phytoplankton, which are plants).

Zooplankton is a library for helping you turn Rails routes into [URI Template
strings](#uri-templates-lolwut). It's useful for helping yourself generate the
`_links` part of [HAL](http://stateless.co/hal_specification.html), for example.

## Usage

Given a route file like this:

```ruby
SomeApp::Application.routes.draw do
  root 'root#index'
  get '/posts/:slug', to: 'posts#show', as: :post
  get '/posts/:slug/comments', to: 'comments#index', as: :comments
  get '/posts/:slug/comments/:comment_id', to: 'commendts#show', as: :comment
end
```

Without Zooplankton, you might end up generating a URI template for a route by
abusing Rails's url helpers like this:

```ruby
CGI.unescape post_path(slug: "{slug}")
# => '/posts/{slug}'
CGI.unescape comment_path(slug: "{slug}", comment_id: "{comment_id}")
# => '/posts/{slug}/comments/{comment_id}'
```

If you needed to include query parameters in your template, you'd have an even
harder time. Something like:

```ruby
CGI.unescape "#{comments_path(slug: "{slug}")}{?page,page_size}"
# => '/posts/{slug}/comments{?page,page_size}'
```

With Zooplankton, you can use it like this:

```ruby
> Zooplankton.path_template_for(:root)
# => '/'
> Zooplankton.path_template_for(:post)
# => '/posts/{slug}'
> Zooplankton.path_template_for(:comment)
# => '/posts/{slug}/comments/{comment_id}'
```

It also handles replacing some (or all, though you might decide to use a Rails
url helper at that point) of the templated variables if you want to prepopulate
some of them ahead of time:

``` ruby
> Zooplankton.path_template_for(:comment, slug: 'the-best-post-ever')
# => '/posts/the-best-post-ever/comments/{comment_id}'
```

And you can add some query parameters when you're generating the template, if
you need:

``` ruby
> Zooplankton.path_template_for(:comments, :page, slug: 'the-best-post-ever')
# => '/posts/the-best-post-ever/comments{?page}'
> Zooplankton.path_template_for(:comments, %i(page page_size), slug: 'the-best-post-ever')
# => '/posts/the-best-post-ever/comments{?page,page_size}'
> Zooplankton.path_template_for(:comments, %i(page page_size))
# => '/posts/{slug}/comments{?page,page_size}'
```

If you supply a query parameter for replacement, it'll denote a continuation:

``` ruby
> Zooplankton.path_template_for(:comments, %i(page page_size), slug: 'the-best-post-ever', page: 1)
# => '/posts/the-best-post-ever/comments?page=1{&page_size}'
```

It'll generate URLs, too, not just paths.

``` ruby
> Zooplankton.url_template_for(:root)
# => 'http://example.com/'
> Zooplankton.url_template_for(:post)
# => 'http://example.com/posts/{slug}'
```

## URI Templates LOLWUT

[URI Templates](http://tools.ietf.org/html/rfc6570) are a notation for teaching
machines how to build URIs. They're basically rules for string interpolation.
Zooplankton supports a small subset of all the notations, outlined here.

### Simple String Expansion

[RFC direct link](http://tools.ietf.org/html/rfc6570#section-3.2.2)

This is the simplest part of URI Templates and is what Zooplankton uses for
parameters that are part of the path of a URI. Basically, given a template like
`"foo{var}baz"` and assuming you have a value of `'bar'` for `var`, you'd end up
with `"foobarbaz"`.

### Form-Style Query Expansion

[RFC direct link](http://tools.ietf.org/html/rfc6570#section-3.2.8)

This expansion is for telling a computer to build a query string. Something like
`"name{?first,last}" with values like in the hash `{first: 'ben', last:
'hamill'}` would expand to `"name?first=ben&last=hamill"`. Zooplankton will use
this when it's appropriate for building query strings.

### Form-Style Query Continuation

[RFC direct link](http://tools.ietf.org/html/rfc6570#section-3.2.9)

This expansion is for telling a computer to finish off a query string that
you've already started. Basically, it's like a query expansion, but instructs
the computer to use a starting `&`, rather than a `?`. So `"name{&first,last}"`
with values like `{first: 'ben', last: 'hamill'}` would end up as
`"name&first=ben&last=hamill"`, but the greatest usefulness is for something
like `"name?middle=dale{?first,last}"` which would end up as
`"name?middle=dale&first=ben&last=hamill"`. Zooplankton will use this when it's
appropriate for building query strings.

## Testing

```
rake spec
```

This library uses the [Appraisal](https://github.com/thoughtbot/appraisal) gem to test against multiple versions of Rails. You can run them individually with

```
appraisal rails4 rake spec
appraisal rails5 rake spec
```

Look in `./Appraisals` for available Rails versions.

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
