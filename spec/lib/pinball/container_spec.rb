require 'spec_helper.rb'
require 'pinball'

describe Pinball::Container do
  before do
    Pinball::Container.clear
  end

  describe '::configure' do
    it 'allows to add new container item' do
      Pinball::Container.configure do
        define :baz, 0
      end
      expect(Pinball::Container.instance.items[:baz]).to be_an_instance_of(Pinball::ContainerItem)
    end
  end

  describe '::lookup' do
    it 'returns container_item' do
      Pinball::Container.configure do
        define :baz, 0
      end
      expect(Pinball::Container.lookup(:baz)).to be_an_instance_of(Pinball::ContainerItem)
    end
  end

  describe '::clear' do
    it 'clears all container items' do
      Pinball::Container.configure do
        define :baz, 0
      end
      Pinball::Container.clear
      expect(Pinball::Container.lookup(:baz)).to be_nil
    end
  end

  describe '::define' do
    it 'adds new container item' do
      Pinball::Container.define :baz, 0
      expect(Pinball::Container.instance.items[:baz]).to be_an_instance_of(Pinball::ContainerItem)
    end
  end

  describe '::undefine' do
    it 'removes container item' do
      Pinball::Container.define :baz, 0
      Pinball::Container.undefine :baz
      expect(Pinball::Container.instance.items[:baz]).to be_nil
    end
  end

  describe '#define' do
    it 'adds new container item' do
      Pinball::Container.instance.define :baz, 0
      expect(Pinball::Container.instance.items[:baz]).to be_an_instance_of(Pinball::ContainerItem)
    end
  end

  describe '#undefine' do
    it 'removes container item' do
      Pinball::Container.instance.define :baz, 0
      Pinball::Container.instance.undefine :baz
      expect(Pinball::Container.instance.items[:baz]).to be_nil
    end
  end

  describe '#inject' do
    let!(:foo) { Class.new{ inject :baz, :bar, :spam } }

    before do
      Pinball::Container.configure do
        define :baz, 0
        define :bar, Hash
        define :spam do
          Array.new
        end
      end
    end

    it 'automatically injects dependencies to class' do
      expect(foo.new.respond_to?(:baz)).to be_true
      expect(foo.new.respond_to?(:bar)).to be_true
      expect(foo.new.respond_to?(:spam)).to be_true
    end

    it 'injects valid dependencies' do
      expect(foo.new.baz).to eq(0)
      expect(foo.new.bar).to be_an_instance_of(Hash)
      expect(foo.new.spam).to be_an_instance_of(Array)
    end
  end
end