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
      expect(foo.dependencies).to match_array([:baz, :bar])
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

  describe '::dependencies' do
    it 'returns list of dependencies' do
      foo.inject :baz
      foo.inject :bar
      expect(foo.dependencies).to match_array([:baz, :bar])
    end
  end

  describe '#override_dependency' do
    let!(:foo_instance) { foo.inject :baz ; foo.new }

    subject { foo_instance.override_dependency(:baz, 1) }

    it 'adds overridden dependency' do
      subject
      expect(foo_instance.overridden_dependencies[:baz]).not_to be_nil
    end

    it 'resolves overridden dependency' do
      subject
      expect(foo_instance.baz).to eq(1)
    end

    it 'returns self' do
      expect(subject).to eq(foo_instance)
    end
  end

  context 'for subclass' do
    let!(:foo) { Class.new { inject :baz ; inject :bar} }
    let!(:fooo) { Class.new(foo) }

    let!(:foo_instance) { foo.new }
    let!(:fooo_instance) { fooo.new }

    describe '::dependencies' do
      it 'returns ancestor\'s dependencies' do
        expect(fooo.dependencies).to eq(foo.dependencies)
      end
    end

    describe 'injection in subclass' do
      it 'returns dependency' do
        expect(fooo_instance.baz).to eq(foo_instance.baz)
        expect(fooo_instance.bar).to eq(foo_instance.bar)
      end
    end
  end
end