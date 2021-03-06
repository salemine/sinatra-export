require File.expand_path('../test_helper', __FILE__)

class SinatraExportBuildTest < UnitTest
  include Rack::Test::Methods

  class App < UnitTest::App
    get '/' do
      "homepage"
    end
    get '/contact' do
      "contact"
    end
    get '/data.json' do
      "{test: 'ok'}"
    end
  end

  def test_build
    # Temporary public folder
    public_folder = App.public_folder
    FileUtils.rm_rf public_folder
    FileUtils.mkdir public_folder

    builder = Sinatra::Export.new(App)
    builder.build!

    assert File.read(File.join(public_folder, 'index.html')).include?('homepage')
    assert File.read(File.join(public_folder, 'contact/index.html')).include?('contact')
    assert File.read(File.join(App.root, 'public/data.json')).include?("{test: 'ok'}")
  end

end