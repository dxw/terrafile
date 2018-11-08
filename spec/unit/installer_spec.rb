require_relative '../spec_helper'

module Terrafile
  RSpec.describe Installer do
    describe '#call' do
      before { allow(Kernel).to receive(:puts) }
      before { allow(Kernel).to receive(:exit) }

      describe 'loading the Terrafile' do
        before { allow(YAML).to receive(:safe_load) }

        context 'when the expected Terrafile is found' do
          before do
            allow(File).to receive(:exist?)
              .with(Installer::TERRAFILE_PATH).and_return(true)
          end

          it 'loads the file safely' do
            Installer.new.call
            expect(YAML).to have_received(:safe_load).with(Installer::TERRAFILE_PATH)
          end
        end

        context 'when the expected Terrafile is not found' do
          before do
            allow(File).to receive(:exist?)
              .with(Installer::TERRAFILE_PATH).and_return(false)
          end

          it 'tells us that the file is missing' do
            Installer.new.call
            expect(Kernel).to have_received(:puts).with(/Terrafile does not exist/)
          end

          it 'does not attempt to load the file' do
            Installer.new.call
            expect(YAML).not_to have_received(:safe_load)
          end
        end
      end

      describe 'creating the modules directory' do
        before { allow(FileUtils).to receive(:makedirs) }

        context 'when the directory already exists' do
          before do
            allow(Dir).to receive(:exist?)
              .with(Installer::MODULES_PATH).and_return(true)
          end

          it 'does not attempt to make the directory' do
            Installer.new.call
            expect(FileUtils).not_to have_received(:makedirs)
          end
        end

        context 'when the directory does NOT exist' do
          before do
            allow(Dir).to receive(:exist?)
              .with(Installer::MODULES_PATH).and_return(false)
          end

          it 'notifies us of its intention to make the directory' do
            Installer.new.call
            expect(Kernel).to have_received(:puts).with(/Creating .+ modules directory/)
          end

          it 'makes the directory' do
            Installer.new.call
            expect(FileUtils).to have_received(:makedirs).with(Installer::MODULES_PATH)
          end
        end
      end
    end
  end
end
