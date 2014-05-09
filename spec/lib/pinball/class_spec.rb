require 'spec_helper.rb'
require 'pinball'

class Foo

end

describe Class do
  before do
    Foo.instance_variable_set('@dependencies', nil)
  end

  describe '::inject' do
    it 'responds to ::inject method' do
      expect(Foo.respond_to?(:inject)).to be_true
    end

    it 'creates @dependencies array' do
      Foo.inject :spam
      expect(Foo.instance_variable_get('@dependencies')).to match_array([:spam])
    end

    it 'adds items to @dependencies array' do
      Foo.inject :spam
      Foo.inject :egg
      expect(Foo.instance_variable_get('@dependencies')).to match_array([:spam, :egg])
    end

    it 'doesn\'t duplicate dependencies' do
      Foo.inject :spam
      Foo.inject :egg
      Foo.inject :egg
      expect(Foo.instance_variable_get('@dependencies')).to match_array([:spam, :egg])
    end
  end

  describe '::class_inject' do
    it 'defines new method' do
      Foo.class_inject :span
      expect(Foo.respond_to?(:span)).to be_true
    end
  end
end