class ClassRuby
  def bb (name)
    puts "The name you entered: #{name}" 
  end
  
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
end