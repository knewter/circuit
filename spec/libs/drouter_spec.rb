require 'spec_helper'
require 'circuit'

describe Circuit do
  context 'object' do
    subject { -> { Circuit } }
    it { should_not raise_error }
  end

  it { should respond_to(:load_hosts!) }

  context 'load!' do
    subject {
      ->(){
        Circuit.load_hosts! "spec/internal/config/circuit_hosts.yml"
      }
    }

    it { should_not raise_error }
  end

end
