module FixtureBuilder
  # Saves the markup to a fixture file using the given name
  def save_fixture(markup, name)
    fixture_path = Rails.root.join 'spec/javascripts/fixtures'
    Dir.mkdir(fixture_path) unless File.exists?(fixture_path)

    fixture_file = File.join(fixture_path, "#{name}.fixture.html.erb")
    File.open(fixture_file, 'w') do |file|
      file.puts(markup)
    end
  end

  # From the controller spec response body, extracts html identified
  # by the css selector.
  def html_for(selector)
    doc = Nokogiri::HTML(response.body)

    remove_third_party_scripts(doc)
    doc.css(selector).first.to_s
  end

  # Remove scripts such as Google Analytics to avoid running them
  # when we load into the dom during js specs.
  def remove_third_party_scripts(doc)
    scripts = doc.at('#third-party-scripts')
    scripts.remove if scripts
  end
end