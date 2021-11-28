# frozen_string_literal: true

require 'zeitwerk'
require 'English'
require 'fileutils'

ROOT = File.expand_path(File.join(__dir__, '../'))

loader = Zeitwerk::Loader.new
loader.push_dir(File.join(ROOT, 'lib'))
loader.setup # ready!

shared_examples 'stage' do |stage|
  valid = Dir.glob(File.join(ROOT, "tmp/examples/stage_#{stage}/valid/**/*.c"))
  invalid = Dir.glob(File.join(ROOT, "tmp/examples/stage_#{stage}/invalid/**/*.c"))

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
        asm = Cmd.compile!(filepath)
        asm_path = File.join(ROOT, 'tmp/out.s')
        File.write(asm_path, asm)

        actual_bin_path = File.join(ROOT, 'tmp/bin')
        expected_bin_path = File.join(ROOT, 'tmp/exected_bin')

        system('gcc', '-w', filepath, '-o', expected_bin_path)
        system(expected_bin_path)

        expected_status = $CHILD_STATUS.exitstatus

        system('gcc', asm_path, '-o', actual_bin_path)
        system(actual_bin_path)

        actual_status = $CHILD_STATUS.exitstatus

        FileUtils.rm asm_path
        FileUtils.rm actual_bin_path
        FileUtils.rm expected_bin_path

        expect(expected_status).to eq(actual_status)
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
