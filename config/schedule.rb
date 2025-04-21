

set :output, "#{path}/log/cron_log.log"

every :day, :at => '7:00am' do
  runner "UserWishList.store_wish_list_reports", :environment => :production
end

# every :day, :at => '7:10am' do
#   runner "UserWishList.home_store_wish_list_reports", :environment => :production
# end

# every :day, :at => '8:00am' do
#   runner "UserWishList.pk_restock_email", :environment => :production
# end

# every :day, :at => '9:00am' do
#   runner "UserWishList.home_restock_email", :environment => :production
# end
