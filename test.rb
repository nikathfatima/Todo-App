def update
  task_complete = ["Foo","yoo","Jump as high as you can"] 
  
  file1 = File.read("app/assets/data.txt").lines
  file2 = File.open("app/assets/datax.txt", 'w+')  

  file1.each do |line|
    line = line.chomp
    file2.write(line)
    puts line
    if task_complete.include? line
      file2.write("=>COMPLETE\n")
    end
  end
  file2.close
end
