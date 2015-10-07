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

  describe '::define_singleton' do
    context 'with class without mandatory initializer params' do
      it 'adds new container item' do
        Pinball::Container.define_singleton :baz, String
        expect(Pinball::Container.instance.items[:baz].value).to be_an_instance_of(String)
      end
    end

    context 'with class with mandatory initialize params' do
      it 'raises exception' do
        WithMandatory = Class.new do
          def initialize(param)
          end
        end

        expect{Pinball::Container.define_singleton :baz, WithMandatory}.to raise_error(Pinball::WrongArity)
      end
    end
  end

  describe '::undefine' do
    context 'with usual dependency' do
      it 'removes container item' do
        Pinball::Container.define :baz, 0
        Pinball::Container.undefine :baz
        expect(Pinball::Container.instance.items[:baz]).to be_nil
      end
    end

    context 'with singleton dependency' do
      it 'removes container item' do
        Pinball::Container.define_singleton :baz, String
        Pinball::Container.undefine :baz
        expect(Pinball::Container.instance.items[:baz]).to be_nil
      end
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
      expect(foo.new.respond_to?(:baz)).to be_truthy
      expect(foo.new.respond_to?(:bar)).to be_truthy
      expect(foo.new.respond_to?(:spam)).to be_truthy
    end

    it 'injects valid dependencies' do
      expect(foo.new.baz).to eq(0)
      expect(foo.new.bar).to be_an_instance_of(Hash)
      expect(foo.new.spam).to be_an_instance_of(Array)
    end
  end
end