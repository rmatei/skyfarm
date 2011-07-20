class InfoController < ApplicationController
  
  def index
    @skip_nav = true
  end
  
  def throw_error
    raise "this is an error"
  end
  
end
