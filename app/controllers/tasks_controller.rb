class TasksController < ApplicationController


  def new 
    if session[:access] == false
      redirect_to "/logout"
      return
    end
  end

  def create
    if session[:access] == false
      redirect_to "/logout"
      return
    end
    Rails.logger.info ">>>#{params[:title]}<<<<<"
    Rails.logger.info ">>>#{session[:user]}<<<<<"
    File.open("app/assets/"+session[:user]+".txt", 'a+') {|p| p.write(params[:title]+"\n")}
    redirect_to({:action => 'new'}, {:notice => "Task added Successfully!"})
  end

  def list
    if session[:access] == false
      redirect_to "/logout"
      return
    end
    @tasks = File.read("app/assets/"+session[:user]+".txt").lines
  end

  def update
    task_complete = params[:tasks]
    file1 = File.read("app/assets/"+session[:user]+".txt").lines
    file2 = File.open("app/assets/"+session[:user]+".txt", 'w+')  
    file1.each do |line|
      line = line.chomp
      line = line.split(/=>/).first
      if task_complete.include? line
        Rails.logger.info"so#{task_complete}ssssssss"
        file2.write(line)
        file2.write("=>COMPLETE\n")
      else
        file2.write(line+"\n")
      end

    end
    redirect_to '/list'
    file2.close
  end

  def logout
    session[:access] = false 
    session[:user] = ""
    flash[:notice] = ""
    redirect_to '/home'
    return
  end

  def home
    f = File.read("app/authenticity.txt").lines
    f.each do |line|
      line = line.chomp
      @user = line.split(/!/).first
      @pass = line.split(/!/).second
      if @user==(params[:user]) && @pass==(params[:pass])
        session[:user] = params[:user]
        Rails.logger.info"+++++#{session[:user]}++++++"
        session[:access] = true
        redirect_to({:action => 'new'})
        return
      elsif  session[:access] == false && session[:user] != ""
        flash[:notice] = "Incorrect password and username*"
      end
    end
  end
 
  def store
    fr = File.open("app/authenticity.txt","a+")
    fr.write(params[:user]+"!"+params[:pass]+"\n")
    fr.close
    f =  File.new("app/assets/"+params[:user]+".txt","w+")
    f.close 
    redirect_to '/home'
  end

  def signup

  end
end
