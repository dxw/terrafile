Given('a valid Terrafile exists') do
  content = <<~YML
    terraform-aws-cloudtrail:
      source: "git@github.com:deanwilson/terraform-aws-cloudtrail"
      version: "01ccc3a1816373dff0a0084377e24991dc0212bc"

    terraform-aws-s3-bucket:
      source: "git@github.com:Smartbrood/terraform-aws-s3-bucket.git"
      version: "v0.7"
  YML
  write_file 'Terrafile', content
end

When('I run the _terrafile_ command') do
  run_simple('terrafile', fail_on_error: false)
end

Then('I should see that a _modules_ directory will be created') do
  notice = "Creating Terraform modules directory at 'vendor/terraform_modules'"
  expect(last_command_started.output).to match(/#{notice}/)
end

Then('I should see that each module listed in the Terrafile is to be installed') do
  notice1 = 'Checking out 01ccc3a1816373dff0a0084377e24991dc0212bc from ' \
              'git@github.com:deanwilson/terraform-aws-cloudtrail'
  notice2 = 'Checking out v0.7 from ' \
              'git@github.com:Smartbrood/terraform-aws-s3-bucket.git'

  expect(last_command_started.output).to match(/#{notice1}/)
  expect(last_command_started.output).to match(/#{notice2}/)
end
