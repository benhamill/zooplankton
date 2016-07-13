require 'spec_helper'
require 'zooplankton'

module Plankton
  class Application < Rails::Application
  end
end

Plankton::Application.routes.tap do |routes|
  routes.default_url_options[:host] = 'http://example.com'
  routes.draw do
    root 'root#index'
    get '/post/:slug', to: 'posts#show', as: :post
    get '/post/:slug/comment/:comment_id', to: 'commendts#show', as: :comment
  end
end

describe Zooplankton do
  describe ".path_template_for" do
    context "for a route with no required params" do
      subject { Zooplankton.path_template_for(:root) }

      it "returns just the path" do
        expect(subject).to eq('/')
      end

      context "with one query parameter" do
        subject { Zooplankton.path_template_for(:root, :q) }

        it "templateizes the query param" do
          expect(subject).to eq('/{?q}')
        end
      end

      context "with some query parameters" do
        subject { Zooplankton.path_template_for(:root, %i(q f)) }

        it "templateizes the query params" do
          expect(subject).to eq('/{?q,f}')
        end
      end

      context "with all query parameters" do
        subject { Zooplankton.path_template_for(:root, %w(s q aa), "s" => "foo", "q" => "bar", "aa" => "hello", "ignore" => "me") }

        it "templateizes all query params with the right separators" do
          expect(subject).to eq('/?s=foo&q=bar&aa=hello')
        end
      end
    end

    context "for a route with one required param" do
      subject { Zooplankton.path_template_for(:post) }

      it "uses simple string expansion to describe the parameter" do
        expect(subject).to eq('/post/{slug}')
      end

      context "with one query parameter" do
        subject { Zooplankton.path_template_for(:post, :q) }

        it "templateizes the query param" do
          expect(subject).to eq('/post/{slug}{?q}')
        end
      end

      context "with some query parameters" do
        subject { Zooplankton.path_template_for(:post, %i(q f)) }

        it "templateizes the query params" do
          expect(subject).to eq('/post/{slug}{?q,f}')
        end
      end
    end

    context "for a route with more than one required param" do
      context "with no other arguments" do
        subject { Zooplankton.path_template_for(:comment) }

        it "uses simple string expansion to describe the parameters" do
          expect(subject).to eq('/post/{slug}/comment/{comment_id}')
        end

        context "with one query parameter" do
          subject { Zooplankton.path_template_for(:comment, :q) }

          it "templateizes the query param" do
            expect(subject).to eq('/post/{slug}/comment/{comment_id}{?q}')
          end
        end

        context "with some query parameters" do
          subject { Zooplankton.path_template_for(:comment, %i(q f)) }

          it "templateizes the query params" do
            expect(subject).to eq('/post/{slug}/comment/{comment_id}{?q,f}')
          end
        end
      end

      context "with one supplied parameter value" do
        subject { Zooplankton.path_template_for(:comment, slug: 'post-slug') }

        it "uses simple string expansion to describe the parameters" do
          expect(subject).to eq('/post/post-slug/comment/{comment_id}')
        end

        context "with one query parameter" do
          subject { Zooplankton.path_template_for(:comment, :q, slug: 'post-slug') }

          it "templateizes the query param" do
            expect(subject).to eq('/post/post-slug/comment/{comment_id}{?q}')
          end
        end

        context "with some query parameters" do
          subject { Zooplankton.path_template_for(:comment, %i(q f), slug: 'post-slug') }

          it "templateizes the query params" do
            expect(subject).to eq('/post/post-slug/comment/{comment_id}{?q,f}')
          end
        end

        context "with some query parameters that are supplied" do
          subject { Zooplankton.path_template_for(:comment, %i(q f), slug: 'post-slug', q: 'find me') }

          it "templateizes the query params" do
            expect(subject).to eq('/post/post-slug/comment/{comment_id}?q=find me{&f}')
          end
        end
      end
    end
  end

  describe ".url_template_for" do
    context "for a route with no required params" do
      subject { Zooplankton.url_template_for(:root) }

      it "returns just the url" do
        expect(subject).to eq('http://example.com/')
      end
    end

    context "for a route with one required param" do
      subject { Zooplankton.url_template_for(:post) }

      it "uses simple string expansion to describe the parameter" do
        expect(subject).to eq('http://example.com/post/{slug}')
      end
    end

    context "for a route with more than one required param" do
      context "with no other arguments" do
        subject { Zooplankton.url_template_for(:comment) }

        it "uses simple string expansion to describe the parameters" do
          expect(subject).to eq('http://example.com/post/{slug}/comment/{comment_id}')
        end
      end

      context "with one supplied parameter value" do
        subject { Zooplankton.url_template_for(:comment, slug: 'post-slug') }

        it "uses simple string expansion to describe the parameters" do
          expect(subject).to eq('http://example.com/post/post-slug/comment/{comment_id}')
        end
      end
    end
  end
end
