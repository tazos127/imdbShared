require 'test/unit'
require 'selenium-webdriver'
require "Time"


class WebDriverTest < Test::Unit::TestCase

  # This method navigates to IMDB searches for specific actor and validate if he acted in a movie.
  # if he did - it prints all data about the movie (Movie title, his characters name and so on...)

  def test_IMDB_searchForActorAndValidateIfHeActedInSpecificMovie_IfHeHisFoundPrintDataAboutTheMovie

    # Define test variable
    puts "Enter the Actor name: "
    actor = gets.chomp() #I can get data directly from users I/O using gets.chomp command instead of doing it hardcoded
    puts "Enter the Movie name: "
    movieToSearchFor = gets.chomp().downcase #I can get data directly from users I/O using gets.chomp command instead of doing it hardcoded

    # Define Selenium Driver and Navigate to IMDB
    driver = InitWebDriverAndNavigate('http://imdb.com')

    # Search for our actor and submit
    SearchForActorAndSubmit(actor, driver)

    # Select first choice
    SelectActorFromListOfResults(driver)

    # Get all data on selected actor (Movies, roles and so on...)
    moviesFound = driver.find_elements(:xpath, "//div[contains(@class, 'filmo-row')]")

    # Loop over each element found - if it contains the movie we are searching it will print all data for it.
    result = ValidateActorActedInSpecificMovie(movieToSearchFor, moviesFound , actor)

    # Close Driver when test is over
    driver.quit
    
    #write to file 
    newLogFile(result)
  end

  def SelectActorFromListOfResults(driver)
    # Todo: Add validation that actor selected is the real actor - if no exists stop test
    driver.find_element(:xpath, '//*[@id="main"]/div/div[2]/table/tbody/tr[1]/td[2]/a').click()
  end

  def InitWebDriverAndNavigate(url)
    driver = Selenium::WebDriver.for :firefox
    driver.navigate.to(url)
    driver
  end

  def ValidateActorActedInSpecificMovie(movieToSearchFor, moviesFound , actor)
    # Todo: add validation if not exists and print only relavent data and stop test...
    moviesFound.each { |movie|
      if movie.text.downcase.include? movieToSearchFor
        theYear = devideData(movie.text , 1)
        theMovie = devideData(movie.text , 2)
        theCharactar = devideData(movie.text , 3)
        return  "in the movie: #{theMovie}  #{actor} played: #{theCharactar} "      
      end
    }
  end

  def SearchForActorAndSubmit(actor, driver)
    element = driver.find_element(:id, 'navbar-query')
    element.send_keys(actor)
    element.submit
  end
 
  # separates the movie / year and character 
  def devideData(textMovieAcotr , index)
      result = ""
      counter = 0
      for i in  0..textMovieAcotr.length()-1
        if textMovieAcotr[i].eql?("\n")
            counter = counter+1     
            if counter== index
              break       
            end  
        else
            if counter==index-1
              result += textMovieAcotr[i]  
            end   
        end     
      end   
      return "#{result}"
   end
   
   #open new file 'a+': writing on existing file , if not exist create one 
   def newLogFile(theResult)
     currentTime = Time.now.strftime("%Y-%m-%d").to_s     # format by date only 
     fileName = 'testResult'  +currentTime + '.txt'
     f = File.open(fileName , 'a+')
     f.puts "IMDB search test result for  " + Time.now.to_s + theResult + "."
     f.close
   end 
  
end