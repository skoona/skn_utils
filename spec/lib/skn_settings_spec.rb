#

describe SknUtils::Configuration, "SknSettings Application Configuration Module" do

  let(:test_list) do
    [
      "./spec/factories/settings.yml",
      "./spec/factories/settings/test.yml",
      "./spec/factories/settings/test.local.yml"
    ]
  end

  before :each do
    @service = described_class.new.load_and_set_settings(test_list)
  end

  it 'contains the test settings for the application' do
    expect(@service.Packaging.pomVersion).to eq SknUtils::VERSION
    expect(@service.Packaging.configName).to eq 'test.local'
    expect(@service.Packaging.isTest).to be true
  end

  it 'contains the current RACK or RAILS environment values' do
    expect(@service.env).to eq 'test'
    expect(@service.env.test?).to be true
    expect(@service.env.development?).to be false
  end

  it 'contains the application root path as a string' do
    expect(@service.root).to eq Dir.pwd
    expect(@service.root).to be_a(String)
  end

  it "#load_config_basename!(conf=@default_mode) load correct environments. " do
    %w(development production).each do |env_mode|
      expect(@service.config_path!('./spec/factories/').load_config_basename!(env_mode).Packaging.configName).to eq env_mode
    end
  end

  it "#reload! reloads the current list of files. " do
    expect( @service.reload!().env.test? ).to be true
    expect( @service.reload!().env.test? ).to be true
  end

  it "#config_path!(fpath) set the configfuration root path properly. " do
    @service.config_path!('./spec/factories/')
    expect( @service.instance_variable_get(:@_base_path) ).to eq('./spec/factories/')

    @service.config_path!('./spec/factories')
    expect( @service.instance_variable_get(:@_base_path) ).to eq('./spec/factories/')
  end

  it "#load_and_set_settings(ordered_list_of_files) " do
    expect( @service.load_and_set_settings(test_list).env.test? ).to be true
  end

  # Config.setting_files("/path/to/config_root", "your_project_environment")
  it "#setting_files(config_root, env_name) returns a file array. " do
    expect(@service.setting_files('./spec/factories/', 'test')).to be_a(Array)
  end

  it "#add_source!(file_path_or_hash) adds provided file to end of list. " do
    expect(@service.add_source!({Packaging: {configName: 'The Doctor'}}).reload!.Packaging.configName ).to eq('The Doctor')
  end

  it "#prepend_source!(prepend_fpath) adds provided value to front of list. " do
    expect(@service.prepend_source!({Packaging: {configName: 'The Doctor'}}).reload!.Packaging.configName ).to eq('test.local')
  end


end