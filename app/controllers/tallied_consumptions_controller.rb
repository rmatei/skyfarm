class TalliedConsumptionsController < ApplicationController
  active_scaffold :tallied_consumptions do |config|
    # Limited column display for usability
    config.columns = [:user, :tallied_item, :number, :cost, :billing_period, :created_at]    

    # Latest first
    config.list.sorting = { :created_at => :desc }

    # Don't allow any changes to DB, just reading
    config.actions = [:list, :show, :search]
  end
  
  # page where you enter how many check marks each person has.
  # this is done once a month by the alcohol person (Joseles).
  # will create a rake task to remind that person.
  def enter_tallied_consumption
    @users = User.all
    @tallied_items = TalliedItem.all
    @counter = 0
  end
  
  def save_tallied_consumption
    redirect_to root_url unless params['tallied_consumptions']
    params['tallied_consumptions'].each do |form_field|
      tallied_consumption = TalliedConsumption.new
      tallied_consumption.number = form_field.last["number"].to_i
      tallied_consumption.user_id = form_field.last["user_id"].to_i
      tallied_consumption.tallied_item_id = form_field.last["tallied_item_id"].to_i
      tallied_consumption.save!
    end
    redirect_to tallied_consumptions_path
  end
  
end
