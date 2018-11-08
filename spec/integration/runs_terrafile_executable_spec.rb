require_relative '../spec_helper'

module Terrafile
  RSpec.describe 'CLI runs terrafile executable', type: :aruba do
    context 'when no Terrafile is found' do
      let(:file)    { 'Bananafile' }
      let(:content) { 'Something else entirely' }
      let(:output)  { 'No Terrafile found' }

      before(:each) { write_file file, content }
      before(:each) { run('terrafile') }

      it 'prints out an error message' do
        expect(last_command_started).to have_output(/#{output}/)
      end

      it 'exits non-zero' do
        expect(last_command_started).not_to have_exit_status(0)
      end
    end
  end
end
