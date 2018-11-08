require_relative '../spec_helper'

module Terrafile
  RSpec.describe 'CLI runs terrafile executable', type: :aruba do
    context 'when no Terrafile is found' do
      let(:file)    { 'Bananafile' }
      let(:content) { 'Something else entirely' }
      let(:output)  { 'Terrafile does not exist' }

      before(:each) { write_file file, content }
      before(:each) { run('terrafile') }

      it 'prints out an error message' do
        expect(last_command_started).to have_output(/#{output}/)
      end

      it 'exits non-zero' do
        expect(last_command_started).not_to have_exit_status(0)
      end
    end

    context 'when a Terrafile IS found' do
      let(:file)    { 'Terrafile' }
      let(:content) { '' }
      let(:notice)  { 'Creating Terraform modules directory' }

      before(:each) { write_file file, content }
      before(:each) { run('terrafile') }

      context 'and the modules directory does not yet exist' do
        it 'prints out its intention to create that directory' do
          expect(last_command_started).to have_output(/#{notice}/)
        end
      end
    end
  end
end
