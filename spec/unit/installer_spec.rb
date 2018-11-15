require_relative '../spec_helper'

module Terrafile
  RSpec.describe Installer do
    let(:yml) { '' }

    before { allow(Kernel).to    receive(:puts)                 }
    before { allow(YAML).to      receive(:safe_load)            }
    before { allow(File).to      receive(:read).and_return(yml) }
    before { allow(FileUtils).to receive(:makedirs)             }

    describe 'initialisation' do
      before { allow(Kernel).to receive(:exit) }

      context 'when the expected Terrafile is found' do
        before do
          allow(File).to receive(:exist?)
            .with(TERRAFILE_PATH).and_return(true)
        end

        it 'reads the file from the conventional location' do
          Installer.new
          expect(File).to have_received(:read).with(TERRAFILE_PATH)
        end

        it 'loads the read yml safely' do
          Installer.new
          expect(YAML).to have_received(:safe_load).with(yml)
        end
      end

      context 'when the expected Terrafile is not found' do
        before do
          allow(Helper).to receive(:file_exists?)
            .with(TERRAFILE_PATH).and_return(false)
        end

        it 'tells us that the file is missing' do
          Installer.new
          expect(Kernel).to have_received(:puts).with(/Terrafile does not exist/)
        end

        it 'does not attempt to read the file' do
          Installer.new
          expect(File).not_to have_received(:read)
        end

        it 'does not attempt to load the yml' do
          Installer.new
          expect(YAML).not_to have_received(:safe_load)
        end
      end
    end

    describe '#call' do
      before do
        allow(Helper).to receive(:file_exists?).with(TERRAFILE_PATH).and_return(true)
        allow(Dir).to receive(:chdir).and_yield
      end

      describe 'creating the modules directory' do
        before { allow(FileUtils).to receive(:makedirs) }
        before { allow(YAML).to receive(:safe_load).and_return([]) }

        context 'when the directory already exists' do
          before do
            allow(Helper).to receive(:dir_exists?)
              .with(Terrafile::MODULES_PATH).and_return(true)
          end

          it 'does not attempt to make the directory' do
            Installer.new.call
            expect(FileUtils).not_to have_received(:makedirs)
          end
        end

        context 'when the directory does NOT exist' do
          before do
            allow(Helper).to receive(:dir_exists?)
              .with(Terrafile::MODULES_PATH).and_return(false)
          end

          it 'notifies us of its intention to make the directory' do
            Installer.new.call
            expect(Kernel).to have_received(:puts).with(/Creating .+ modules directory/)
          end

          it 'makes the directory' do
            Installer.new.call
            expect(FileUtils).to have_received(:makedirs).with(Terrafile::MODULES_PATH)
          end
        end
      end

      describe 'fetching the listed modules' do
        let(:dependencies) do
          [
            instance_double(
              Dependency,
              name:     'terraform-aws-name1',
              source:   'git@github.com:org1/repo1',
              version:  '0.8.0',
              fetch:    true,
              checkout: true
            ),
            instance_double(
              Dependency,
              name:     'terraform-aws-name2',
              source:   'git@github.com:org2/repo2',
              version:  '004e5791',
              fetch:    true,
              checkout: true
            ),
          ]
        end

        before do
          allow(Dependency).to receive(:build_from_terrafile).and_return(dependencies)
        end
        before { allow(Dir).to receive(:chdir).and_yield }
        before { allow(Helper).to receive(:fetch) }
        before { allow(Helper).to receive(:checkout) }

        it 'notifies its intention to checkout the dependency' do
          msg1 = 'Checking out 0.8.0 from git@github.com:org1/repo1'
          msg2 = 'Checking out 004e5791 from git@github.com:org2/repo2'

          Installer.new.call

          expect(Kernel).to have_received(:puts).with(/#{msg1}/)
          expect(Kernel).to have_received(:puts).with(/#{msg2}/)
        end

        it 'changes to the module installation directory' do
          Installer.new.call
          expect(Dir).to have_received(:chdir).with(Terrafile::MODULES_PATH)
        end

        describe 'for each dependency' do
          it 'fetches the latest version of the dependency\'s code' do
            Installer.new.call

            expect(dependencies.first).to have_received(:fetch)
            expect(dependencies.last).to  have_received(:fetch)
          end

          it 'checks out the latest version of the dependency\'s code' do
            Installer.new.call

            expect(dependencies.first).to have_received(:checkout)
            expect(dependencies.last).to  have_received(:checkout)
          end
        end
      end
    end
  end
end
