require_relative '../spec_helper'

module Terrafile
  RSpec.describe Helper do
    describe '::run!' do
      it 'passes given cmd to Open3.capture3' do
        stdout = double
        stderr = double
        status = double(success?: true)
        allow(Open3).to receive(:capture3).and_return([stdout, stderr, status])

        Helper.run!('git clone foo')

        expect(Open3).to have_received(:capture3).with('git clone foo')
      end

      context 'when the system call return a zero exit status' do
        let(:zero_result) do
          stdout = "45bca5861c0c7e4defe0702e8f4d3e1f255fe96b\n"
          stderr = ''
          status = double(exitstatus: 1, success?: true)
          [stdout, stderr, status]
        end

        it 'returns true' do
          allow(Open3).to receive(:capture3).and_return(zero_result)

          expect(Helper.run!('git rev-parse HEAD')).to be true
        end
      end

      context 'when the system call returns a non-zero exit status' do
        let(:non_zero_result) do
          stdout = ''
          stderr = "fatal: repository 'bar' does not exist\n"
          status = double(exitstatus: 128, success?: false)
          [stdout, stderr, status]
        end

        it 'raises a helpful Terrafile::Error' do
          allow(Open3).to receive(:capture3).and_return(non_zero_result)
          msg = "'git clone bar' failed with exit code 128 " \
                  "(fatal: repository 'bar' does not exist)"

          expect { Helper.run!('git clone bar') }
            .to raise_error(Terrafile::Error, msg)
        end
      end

      context 'when the system call raises an ENOENT error' do
        it 'catches this and raises a helpful Terrafile::Error' do
          allow(Open3).to receive(:capture3).and_raise(Errno::ENOENT, 'rubbish')

          msg = "'rubbish' failed (No such file or directory - rubbish)"

          expect { Helper.run!('rubbish') }.to raise_error(Terrafile::Error, msg)
        end
      end
    end

    describe '::run_with_output(cmd)' do
      it 'passes given cmd to Open3.capture3' do
        stdout = double(chomp: '')
        stderr = double
        status = double(success?: true)
        allow(Open3).to receive(:capture3).and_return([stdout, stderr, status])

        Helper.run_with_output('git describe --tags')

        expect(Open3).to have_received(:capture3).with('git describe --tags')
      end

      context 'when the system call returns a zero exit status' do
        let(:zero_result) do
          stdout = "1.1.2\n"
          stderr = ''
          status = double(exitstatus: 1, success?: true)
          [stdout, stderr, status]
        end

        it 'returns the systems output to STDOUT' do
          allow(Open3).to receive(:capture3).and_return(zero_result)

          expect(Helper.run_with_output('git describe --tags')).to eq('1.1.2')
        end
      end

      context 'when the system call returns a non-zero exit status' do
        let(:non_zero_result) do
          stdout = ''
          stderr = "fatal: No names found, cannot describe anything.\n"
          status = double(exitstatus: 128, success?: false)
          [stdout, stderr, status]
        end

        it 'also returns STDOUT ignoring the exit code and STDERR' do
          allow(Open3).to receive(:capture3).and_return(non_zero_result)

          expect(Helper.run_with_output('git describe --tags')).to eq('')
        end
      end

      context 'when the system call raises an ENOENT error' do
        it 'catches this and raises a helpful Terrafile::Error' do
          allow(Open3).to receive(:capture3).and_raise(Errno::ENOENT, 'rubbish')

          msg = "'rubbish' failed (No such file or directory - rubbish)"

          expect { Helper.run_with_output('rubbish') }.to raise_error(Terrafile::Error, msg)
        end
      end
    end

    describe '::clone(source, destination)' do
      it 'checks out the given revision using run!' do
        allow(Helper).to receive(:run!)
        source = 'git@github.com:org1/repo1'
        destination = 'terraform-aws-name1'

        Helper.clone(source, destination)

        expect(Helper).to have_received(:run!)
          .with("git clone --depth 1 #{source} #{destination} &> /dev/null")
      end
    end

    describe '::repo_up_to_date?(version)' do
      before { allow(Helper).to receive(:run_with_output).and_return('') }

      it 'gets a list of any tags at the current revision' do
        Helper.repo_up_to_date?(double)

        expect(Helper).to have_received(:run_with_output)
          .with('git describe --tags')
      end

      it 'gets the SHA of the current revision' do
        Helper.repo_up_to_date?(double)

        expect(Helper).to have_received(:run_with_output)
          .with('git rev-parse HEAD')
      end

      describe 'determining if the repo is up to date' do
        it 'returns true if the given version matches a tag' do
          allow(Helper).to receive(:run_with_output)
            .with('git describe --tags').and_return('0.1.0')

          expect(Helper.repo_up_to_date?('0.1.0')).to be true
          expect(Helper.repo_up_to_date?('0.1.1')).to be false
        end

        it 'returns true if the given version matches the SHA' do
          allow(Helper).to receive(:run_with_output)
            .with('git rev-parse HEAD').and_return('abc123')

          expect(Helper.repo_up_to_date?('abc123')).to be true
          expect(Helper.repo_up_to_date?('bcd321')).to be false
        end

        it 'returns false if the given version matches neither a tag nor the SHA' do
          allow(Helper).to receive(:run_with_output)
            .with('git describe --tags').and_return('0.1.0')
          allow(Helper).to receive(:run_with_output)
            .with('git rev-parse HEAD').and_return('abc123')

          expect(Helper.repo_up_to_date?('bananas')).to be false
        end
      end
    end

    describe '::pull_repo' do
      it 'pulls the latest code without generating any output' do
        allow(Helper).to receive(:run!)

        Helper.pull_repo

        expect(Helper).to have_received(:run!).with('git pull &> /dev/null')
      end
    end
  end
end
