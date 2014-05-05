class FindPhantom
  def self.executable_path
            @executable_path ||= (
              path = PhantomJS.path
              puts "My path is : #{path}" # Log the path
              path or raise Error::WebDriverError, MISSING_TEXT
              Platform.assert_executable path
  
              path
            )
          end
end