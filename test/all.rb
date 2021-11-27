# frozen_string_literal: true

require 'zeitwerk'
loader = Zeitwerk::Loader.new
loader.push_dir('./lib')
loader.setup # ready!

shared_examples 'stage' do |stage|
  valid = Dir.glob(File.join(__dir__, "../tmp/examples/stage_#{stage}/valid/**/*.c"))
  invalid = Dir.glob(File.join(__dir__, "../tmp/examples/stage_#{stage}/invalid/**/*.c"))

  context 'lexes' do
    (valid + invalid).each do |filepath|
      it filepath do
        Cmd.lex! filepath
      end
    end
  end

  context 'parses' do
    valid.each do |filepath|
      it filepath do
        Cmd.parse! filepath
      end
    end

    invalid.each do |filepath|
      it filepath do
        expect { Cmd.parse! filepath }.to raise_error(ParseError)
      end
    end
  end

  context 'compiles' do
    valid.each do |filepath|
      it filepath do
        Cmd.compile! filepath
      end
    end

    invalid.each do |filepath|
      it filepath do
        expect { Cmd.compile! filepath }.to raise_error(ParseError)
      end
    end
  end
end

describe 'compiler' do
  it_behaves_like 'stage', 1
  it_behaves_like 'stage', 2
end
