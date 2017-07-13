#

describe SknSettings, "Application Configuration" do

  it 'contains the test settings for the application' do
    expect(SknSettings.Packaging.pomVersion).to eq SknUtils::VERSION
    expect(SknSettings.Packaging.configName).to eq 'test.local'
    expect(SknSettings.Packaging.isTest).to be true
  end
end