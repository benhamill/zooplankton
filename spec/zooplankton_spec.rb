require 'spec_helper'
require 'zooplankton'

module Plankton
  class Application < Rails::Application
  end
end

Plankton::Application.routes.draw do
  root 'root#index'
  get '/post/:slug', to: 'posts#show', as: :post
  get '/post/:slug/comment/:comment_id', to: 'commendts#show', as: :comment
end

describe Zooplankton do
  describe ".path_template_for" do
    context "for a route with no required params" do
      subject { Zooplankton.path_template_for(:root) }

      it "returns just the path" do
        expect(subject).to eq('/')
      end
    end

    context "for a route with one required param" do
      subject { Zooplankton.path_template_for(:post) }

      it "uses simple string expansion to describe the parameter" do
        expect(subject).to eq('/post/{slug}')
      end
    end

    context "for a route with more than one required param" do
      context "with no other arguments" do
        subject { Zooplankton.path_template_for(:comment) }

        it "uses simple string expansion to describe the parameters" do
          expect(subject).to eq('/post/{slug}/comment/{comment_id}')
        end
      end

      context "with one supplied parameter value" do
        subject { Zooplankton.path_template_for(:comment, slug: 'post-slug') }

        it "uses simple string expansion to describe the parameters" do
          expect(subject).to eq('/post/post-slug/comment/{comment_id}')
        end
      end
    end
  end
end
