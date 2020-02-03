##
# spec/lib/skn_utils/as_human_size_spec.rb
#


describe SknUtils::ConcurrentJobs, 'Run Multiple Jobs' do

  let(:commands) {
    [
        SknUtils::CommandJSONPost.call(full_url: "http://example.com/posts", payload: {one: 1}, headers: {'my-header'=> "header-value"}),
        SknUtils::CommandFORMPost.call(full_url: "http://example.com/posts", payload: {one: 1}),
        SknUtils::CommandJSONGet.call(full_url: "http://example.com/posts/1"),
        SknUtils::CommandJSONPut.call(full_url: "http://example.com/posts", payload: {one: 1}),
        SknUtils::CommandFORMDelete.call(full_url: "http://example.com/posts/1")
    ]
  }

  let(:test_proc) {
    ->(cmd) { SknSuccess.(cmd.uri.request_uri, "Ok") }
  }

  let(:inline_failure_proc) {
    ->(cmd) { SknFailure.(cmd.uri.request_uri, "Failure") }
  }

  let(:catastrophic_proc) {
    ->(cmd) { SomeUnkownThing.(cmd.uri.request_uri, "Catastrophic") }
  }

  context "HTTP Requests " do
    it "Job Commands will provide a valid http request object" do
      expect(commands.any?(&:request)).to be true
    end

    it "Performs Http Post Requests" do
      test_url = "http://jsonplaceholder.typicode.com/users"
      stub_request(:post, test_url).
          to_return(status: 200, body: "{\"message\":\"me\"}", headers: {})

      cmd = SknUtils::CommandJSONPost.call(full_url: test_url, payload: {"one" => 1})

      provider = SknUtils::ConcurrentJobs.call
      provider.register_job do
        SknUtils::JobWrapper.call(cmd, SknUtils::HttpProcessor)
      end
      result = provider.render_jobs

      expect(result).to be_a(SknUtils::Result)
      expect(result.success?).to be true
      expect(result.values.size).to eq(1)
      expect(result.values[0]).to be_a(SknSuccess)
      expect(result.values[0].value).to be_a(Hash)
      expect(result.values[0].value["message"]).to eq("me")
    end

    it "Performs Http Form Post Requests" do
      test_url = "http://jsonplaceholder.typicode.com/users"
      stub_request(:post, test_url).
          to_return(status: 200, body: "message=me", headers: {})

      cmd = SknUtils::CommandFORMPost.call(full_url: test_url, payload: {"one" => 1})

      provider = SknUtils::ConcurrentJobs.call
      provider.register_job do
        SknUtils::JobWrapper.call(cmd, SknUtils::HttpProcessor)
      end
      result = provider.render_jobs

      expect(result).to be_a(SknUtils::Result)
      expect(result.success?).to be true
      expect(result.values.size).to eq(1)
      expect(result.values[0]).to be_a(SknSuccess)
      expect(result.values[0].value).to be_a(String)
      expect(result.values[0].value).to eq("message=me")
    end

    it "Performs Http Get Requests" do
      test_url = "http://jsonplaceholder.typicode.com/users"
      stub_request(:get, test_url).
          to_return(status: 200, body: "{\"message\":\"me\"}", headers: {})

      cmd = SknUtils::CommandJSONGet.call(full_url: test_url)

      provider = SknUtils::ConcurrentJobs.call
      provider.register_job do
        SknUtils::JobWrapper.call(cmd, SknUtils::HttpProcessor)
      end
      result = provider.render_jobs

      expect(result).to be_a(SknUtils::Result)
      expect(result.success?).to be true
      expect(result.values.size).to eq(1)
      expect(result.values[0]).to be_a(SknSuccess)
      expect(result.values[0].value).to be_a(Hash)
      expect(result.values[0].value["message"]).to eq("me")
    end

    it "Performs Http Put Requests" do
      test_url = "http://jsonplaceholder.typicode.com/users"
      stub_request(:put, test_url).
          to_return(status: 200, body: "{\"message\":\"me\"}", headers: {})

      cmd = SknUtils::CommandJSONPut.call(full_url: test_url, payload: {"one" => 1})

      provider = SknUtils::ConcurrentJobs.call
      provider.register_job do
        SknUtils::JobWrapper.call(cmd, SknUtils::HttpProcessor)
      end
      result = provider.render_jobs

      expect(result).to be_a(SknUtils::Result)
      expect(result.success?).to be true
      expect(result.values.size).to eq(1)
      expect(result.values[0]).to be_a(SknSuccess)
      expect(result.values[0].value).to be_a(Hash)
      expect(result.values[0].value["message"]).to eq("me")
    end

    it "Performs Http Form Delete Requests" do
      test_url = "http://jsonplaceholder.typicode.com/users"
      stub_request(:delete, test_url).
          to_return(status: 200, body: "message=me", headers: {})

      cmd = SknUtils::CommandFORMDelete.call(full_url: test_url, payload: {"one" => 1})

      provider = SknUtils::ConcurrentJobs.call
      provider.register_job do
        SknUtils::JobWrapper.call(cmd, SknUtils::HttpProcessor)
      end
      result = provider.render_jobs

      expect(result).to be_a(SknUtils::Result)
      expect(result.success?).to be true
      expect(result.values.size).to eq(1)
      expect(result.values[0]).to be_a(SknSuccess)
      expect(result.values[0].value).to be_a(String)
      expect(result.values[0].value).to eq("message=me")
    end
  end

  context "Asynchronous" do
    it "Runs Jobs" do
      provider = SknUtils::ConcurrentJobs.call
      provider.register_jobs(commands, test_proc)
      result = provider.render_jobs

      expect(result).to be_a(SknUtils::Result)
      expect(result.success?).to be true
      expect(result.values.size).to eq(commands.size)
      expect(result.values[0]).to be_a(SknSuccess)
    end
    it "Runs Jobs and handles inline failures" do
      provider = SknUtils::ConcurrentJobs.call

      provider.register_job do
        SknUtils::JobWrapper.call(commands[0], test_proc)
      end
      provider.register_job do
        SknUtils::JobWrapper.call(commands[1], inline_failure_proc)
      end
      provider.register_job do
        SknUtils::JobWrapper.call(commands[2], inline_failure_proc)
      end
      provider.register_job do
        SknUtils::JobWrapper.call(commands[3], inline_failure_proc)
      end
      provider.register_job do
        SknUtils::JobWrapper.call(commands[4], test_proc)
      end

      result = provider.render_jobs

      expect(result).to be_a(SknUtils::Result)
      expect(result.success?).to be false
      expect(result.values.size).to eq(commands.size)
      expect(result.values[1]).to be_a(SknFailure)
      expect(result.values[1].message).to eq("Failure")
    end
    it "Runs Jobs and handles catastrophic failures" do
      provider = SknUtils::ConcurrentJobs.call
      provider.register_job do
        SknUtils::JobWrapper.call(command[0], test_proc)
      end
      provider.register_job do  # notice `command` vs `commands`
        SknUtils::JobWrapper.call(command[1], inline_failure_proc)
      end
      provider.register_job do
        SknUtils::JobWrapper.call(command[2], catastrophic_proc)
      end
      provider.register_job do
        SknUtils::JobWrapper.call(commands[3], catastrophic_proc)
      end
      provider.register_job do
        SknUtils::JobWrapper.call(commands[4], test_proc)
      end

      result = provider.render_jobs

      expect(result).to be_a(SknUtils::Result)
      expect(result.success?).to be false
      expect(result.values.size).to eq(commands.size)
      expect(result.values.last).to be_a(SknSuccess)
      expect(result.values[3].value).to eq("NameError")
      expect(result.values[2]).to be_a(SknFailure)
      expect(result.values[1]).to be_a(SknFailure)
      expect(result.values[0]).to be_a(SknFailure)
      expect(result.values[0].value).to eq("Unknown")
    end
  end

  context "Synchronous" do
    it "Runs Jobs" do
      provider = SknUtils::ConcurrentJobs.call(async: false)
      provider.register_jobs(commands, test_proc)
      result = provider.render_jobs

      expect(result).to be_a(SknUtils::Result)
      expect(result.success?).to be true
      expect(result.values.size).to eq(commands.size)
      expect(result.values[0]).to be_a(SknSuccess)
    end
    it "Runs Jobs and handles inline failures" do
      provider = SknUtils::ConcurrentJobs.call

      provider.register_job do
        SknUtils::JobWrapper.call(commands[0], test_proc)
      end
      provider.register_job do
        SknUtils::JobWrapper.call(commands[1], inline_failure_proc)
      end
      provider.register_job do
        SknUtils::JobWrapper.call(commands[2], inline_failure_proc)
      end
      provider.register_job do
        SknUtils::JobWrapper.call(commands[3], inline_failure_proc)
      end
      provider.register_job do
        SknUtils::JobWrapper.call(commands[4], test_proc)
      end

      result = provider.render_jobs

      expect(result).to be_a(SknUtils::Result)
      expect(result.success?).to be false
      expect(result.values.size).to eq(commands.size)
      expect(result.values[1]).to be_a(SknFailure)
      expect(result.values[1].message).to eq("Failure")
    end
    it "Runs Jobs and handles catastrophic failures" do
      provider = SknUtils::ConcurrentJobs.call
      provider.register_job do
        SknUtils::JobWrapper.call(commands[0], test_proc)
      end
      provider.register_job do
        SknUtils::JobWrapper.call(commands[1], inline_failure_proc)
      end
      provider.register_job do
        SknUtils::JobWrapper.call(commands[2], catastrophic_proc)
      end
      provider.register_job do
        SknUtils::JobWrapper.call(commands[3], catastrophic_proc)
      end
      provider.register_job do
        SknUtils::JobWrapper.call(commands[4], test_proc)
      end

      result = provider.render_jobs

      expect(result).to be_a(SknUtils::Result)
      expect(result.success?).to be false
      expect(result.values.size).to eq(commands.size)
      expect(result.values[3].value).to eq("NameError")
      expect(result.values[2]).to be_a(SknFailure)
      expect(result.values[1]).to be_a(SknFailure)
      expect(result.values[0]).to be_a(SknSuccess)
    end
  end

end
