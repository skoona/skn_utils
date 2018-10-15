#

describe SknSettings, "Application Configuration" do

  let(:short_list) do
    ["./spec/factories/settings/test.yml", "./spec/factories/settings/test.local.yml", "./spec/factories/settings.yml"]
  end

  it 'contains the test settings for the application' do
    expect(described_class.Packaging.pomVersion).to eq SknUtils::VERSION
    expect(described_class.Packaging.configName).to eq 'development'
    expect(described_class.Packaging.isTest).to be true
  end

  it 'contains the current RACK or RAILS environment values' do
    expect(described_class.env).to eq 'test'
    expect(described_class.env.test?).to be true
    expect(described_class.env.development?).to be false
  end

  it 'contains the application root path as a string' do
    expect(described_class.root).to eq Dir.pwd
    expect(described_class.root).to be_a(String)
  end


  it "#load_config_basename!(conf=@default_mode) load correct environments. " do
    %w(development).each do |env_mode|
      expect(described_class.load_config_basename!(env_mode).Packaging.configName).to eq env_mode
    end
  end

  it "#reload! reloads the current list of files. " do
    expect( described_class.reload!().env.test? ).to be true
    expect( described_class.reload!().env.test? ).to be true
  end

  it "#config_path!(fpath) set the configfuration root path properly. " do
    described_class.config_path!('./spec/factories/')
    expect( described_class.instance_variable_get(:@base_path) ).to eq('./spec/factories/')

    subject.config_path!('./spec/factories')
    expect( described_class.instance_variable_get(:@base_path) ).to eq('./spec/factories/')
  end

  it "#load_and_set_settings(ordered_list_of_files) " do
    expect( described_class.load_and_set_settings(short_list).env.test? ).to be true
  end

  # Config.setting_files("/path/to/config_root", "your_project_environment")
  it "#setting_files(config_root, env_name) returns a file array. " do
    expect(described_class.settings_files('spec/factories', 'test')).to be_a(Array)
  end

  it "#add_source!(file_path_or_hash) adds provided file to end of list. " do
    expect(described_class.add_source!({Packaging: {configName: 'The Doctor'}}).Packaging.configName ).to eq('The Doctor')
  end

  it "#prepend_source!(prepend_fpath) adds provided value to front of list. " do
    expect(described_class.prepend_source!({Packaging: {configName: 'The Doctor'}}).Packaging.configName ).to eq('test.local')
  end


end