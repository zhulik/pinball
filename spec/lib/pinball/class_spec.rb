require 'spec_helper.rb'
require 'pinball'

Pinball::Container.configure do
  define :baz, 0
  define :bar, 0
end

describe Class do
  let!(:foo) { Class.new }
  
  describe '::inject' do
    it 'responds to ::inject method' do
      expect(foo.respond_to?(:inject)).to be_true
    end

    it 'creates @dependencies array' do
      foo.inject :baz
      expect(foo.instance_variable_get('@dependencies')).to match_array([:baz])
    end

    it 'adds items to @dependencies array' do
      foo.inject :baz
      foo.inject :bar
      expect(foo.instance_variable_get('@dependencies')).to match_array([:baz, :bar])
    end

    it 'doesn\'t duplicate dependencies' do
      foo.inject :baz
      foo.inject :bar
      foo.inject :bar
      expect(foo.instance_variable_get('@dependencies')).to match_array([:baz, :bar])
    end
  end

  describe '::class_inject' do
    it 'defines new method' do
      foo.class_inject :baz
      expect(foo.respond_to?(:baz)).to be_true
    end

    it 'injects valid dependency' do
      Pinball::Container.define :baz, 0
      foo.class_inject :baz
      expect(foo.baz).to eq(0)
    end
  end
end