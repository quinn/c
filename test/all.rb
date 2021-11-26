# frozen_string_literal: true

require 'zeitwerk'
loader = Zeitwerk::Loader.new
loader.push_dir('./lib')
loader.setup # ready!

valid = Dir.glob(File.join(__dir__, '../tmp/examples/stage_1/valid/**/*.c'))
invalid = Dir.glob(File.join(__dir__, '../tmp/examples/stage_1/invalid/**/*.c'))

context 'compiler' do
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
end
