require 'spec_helper'

describe Screenshot do
  let(:vurl) { Fabricate(:vurl) }
  let(:screenshot) { Screenshot.new(:vurl => vurl) }
  describe "#new" do
    it "takes a hash of options" do
      lambda { Screenshot.new({}) }.should_not raise_error
    end
    it "doesn't accept arbitrary keys" do
      lambda { Screenshot.new :key => 'some value' }.should raise_error ArgumentError
    end
    it "accepts a url option" do
      lambda { Screenshot.new :vurl => vurl }.should_not raise_error
    end
  end

  describe "#snap!" do
    it "executes the command" do
      screenshot.should_receive(:system).with(screenshot.command)
      screenshot.snap!
    end
  end

  describe "#command" do
    it "begins with the path to the executable" do
      screenshot.command.should match(%r{#{Screenshot::PATH_TO_EXECUTABLE}})
    end
    it "includes the url as the second to last argument" do
      screenshot.command.split[-2].should == vurl.url
    end
    it "includes the output file as the last argument" do
      screenshot.command.split[-1].should == screenshot.output_file_path
    end
    it "outputs png" do
      screenshot.command.should include("-f png")
    end
    it "crops to 1024x768" do
      screenshot.command.should include("--crop-w 1024")
      screenshot.command.should include("--crop-h 768")
    end
    it "sets the quality" do
      screenshot.command.should include("--quality 70")
    end
    it "allows time for javascript to execute" do
      screenshot.command.should include("--javascript-delay 1000")
    end
  end

  describe "#output_file_path" do
    it "returns the slug plus .png" do
      screenshot.output_file_path.should == "#{RAILS_ROOT}/public/screenshots/#{vurl.slug}.png"
    end
  end

  describe "output_file_url" do
    it "returns the path relative to /public" do
      screenshot.output_file_url.should == "/screenshots/#{vurl.slug}.png"
    end
  end

  describe "method_missing madness" do
    it "returns values in the options hash when present" do
      screenshot.vurl.should == vurl
    end
  end
end
