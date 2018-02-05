#

describe SknSettings, "Application Configuration" do

  it 'contains the test settings for the application' do
    expect(SknSettings.Packaging.pomVersion).to eq SknUtils::VERSION
    expect(SknSettings.Packaging.configName).to eq 'test.local'
    expect(SknSettings.Packaging.isTest).to be true
  end

  it 'contains the current RACK or RAILS environment values' do
    expect(SknSettings.env).to eq 'test'
    expect(SknSettings.env.test?).to be true
    expect(SknSettings.env.development?).to be false
  end

  it 'contains the application root path as a string' do
    expect(SknSettings.root).to eq Dir.pwd
    expect(SknSettings.root).to be_a(String)
  end

end