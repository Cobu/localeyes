class Zips < Thor

  desc 'load [full path to zip_code file]', "Load geonames city, state, zip, lat. longs into mysql"
  def load(zip_code_file=nil)
    require './config/environment'
    raise "Can't find that zip code file '#{zip_code_file}'" unless File.exist? zip_code_file

    ZipCode.connection.execute "TRUNCATE `zip_codes`"
    st = ZipCode.connection.raw_connection.prepare "INSERT IGNORE INTO `zip_codes` (`zip_code`, `city`, `state`, `state_short`, `lat`, `lng`) VALUES (?, ?, ?, ?, ?, ?)"
    File.readlines(zip_code_file).each_with_index do |line|
      data = line.split("|")
      st.execute(*data)
    end
    st.close
  end
end