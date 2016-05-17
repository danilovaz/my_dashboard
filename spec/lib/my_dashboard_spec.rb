require 'spec_helper'
require 'codeclimate-test-reporter'
require 'coveralls'
CodeClimate::TestReporter.start
Coveralls.wear!

describe MyDashboard do

  it { expect(MyDashboard).to respond_to :configuration }

  describe '.config' do

    it { expect(MyDashboard.config).to be_a(MyDashboard::Configuration) }

  end

  describe '.configure' do

    let(:configuration) { MyDashboard::Configuration.new }

    before do
      allow(MyDashboard).to receive(:config).and_return(:configuration)
    end

    context 'when block given' do

      it 'yields configuration' do
        expect(MyDashboard).to receive(:configure).and_yield(configuration)
        MyDashboard.configure {|config|}
      end

    end

    context 'when no block given' do

      it { expect(MyDashboard.configure).to be_nil }

    end

  end

  describe '.first_dashboard' do

    let(:dir)   { 'foo' }
    let(:dirs)  { [dir] }

    before do
      allow(Dir).to receive(:[]).and_return(dirs)
    end

    it { expect(MyDashboard.first_dashboard).to eq(dir) }

  end

end
