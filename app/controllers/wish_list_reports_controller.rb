class WishListReportsController < ApplicationController

	def index
		if params[:start_date].present?
			@start_date = params[:start_date]
		else
			@start_date = Time.now.to_date.strftime('%m/%d/%Y')
		end
		if params[:end_date].present?
			@end_date = params[:end_date]
		else
			@end_date = Time.now.to_date.strftime('%m/%d/%Y')
		end

		@shop = params[:shop]

		array = @start_date.split('/')
		array[0], array[1] = array[1], array[0]
		temp_start_date = array.join('/')	

		array = @end_date.split('/')
		array[0], array[1] = array[1], array[0]
		tmp_end_date = array.join('/')	

		start_date = Chronic.parse(temp_start_date, :endian_precedence => :little)
		end_date = Chronic.parse(tmp_end_date, :endian_precedence => :little)

		# @wish_lists = UserWishList.where(:wish_list_date => start_date.to_date.beginning_of_day..end_date.to_date.end_of_day).order("id DESC")
		@wish_lists = UserWishList.where(:shop_domain => params[:shop], :wish_list_date => start_date.to_date.beginning_of_day..end_date.to_date.end_of_day).order("id DESC")
	end

	def excel_report
		time = Time.now
		if params[:start_date].present?
			@start_date = params[:start_date]
		else
			@start_date = Time.now.to_date.strftime('%m/%d/%Y')
		end
		if params[:end_date].present?
			@end_date = params[:end_date]
		else
			@end_date = Time.now.to_date.strftime('%m/%d/%Y')
		end

		@shop = params[:shop]

		array = @start_date.split('/')
		array[0], array[1] = array[1], array[0]
		temp_start_date = array.join('/')	

		array = @end_date.split('/')
		array[0], array[1] = array[1], array[0]
		tmp_end_date = array.join('/')	

		start_date = Chronic.parse(temp_start_date, :endian_precedence => :little)
		end_date = Chronic.parse(tmp_end_date, :endian_precedence => :little)

		# @wish_lists = UserWishList.where(:wish_list_date => start_date.to_date.beginning_of_day..end_date.to_date.end_of_day).order("id DESC")
		@wish_lists = UserWishList.where(:shop_domain => params[:shop], :wish_list_date => start_date.to_date.beginning_of_day..end_date.to_date.end_of_day).order("id DESC")
		xlsx = Axlsx::Package.new

		color_array = []
		xlsx.workbook.add_worksheet(:name => "Wish List Report") do |sheet|

			sheet.add_row
			Array.new(100).each_index do |index|
		  	sheet.rows[0].add_cell("")
		  	sheet.column_info[index].width = 30
		  end

			blue_and_white_format = sheet.styles.add_style(:bg_color => "00456e", :fg_color=> "ffffff", :sz => 8,  :border=> {:style => :thin, :color => "000000"}, :alignment => { :horizontal => :center, :vertical => :center}, b: true)
			line_item_format = sheet.styles.add_style(:num_fmt => 3, :bg_color => "ffffff", :fg_color=> "641E16", :sz => 8,  :border=> {:style => :thin, :color => "000000"}, :alignment => { :horizontal => :center, :vertical => :center}, b: true)
	  	category_format = sheet.styles.add_style(:num_fmt => 3, :bg_color => "ffffff", :fg_color=> "154360", :sz => 8,  :border=> {:style => :thin, :color => "000000"}, :alignment => { :horizontal => :center, :vertical => :center}, b: true)

			color_array = [blue_and_white_format, blue_and_white_format, blue_and_white_format, blue_and_white_format, blue_and_white_format, blue_and_white_format, blue_and_white_format, blue_and_white_format]
		  sheet.add_row ["Sr #", "Product Title", "Product SKU", "Barcode", "Customer Email", "Customer Name", "Customer Phone", "Customer City", "Date"], :style => color_array
		  row_count = 1

		  @wish_lists.each do |wish_list|
		  	color_data_array = []
		  	if row_count.even?
		  		color_data_array = [line_item_format, line_item_format, line_item_format, line_item_format, line_item_format, line_item_format, line_item_format, line_item_format]
		  	else
		  		color_data_array = [category_format, category_format, category_format, category_format, category_format, category_format, category_format, category_format]
		  	end
		  	sheet.add_row [row_count, wish_list.product_title, wish_list.product_sku, wish_list.barcode, wish_list.customer_email, wish_list.customer_name, wish_list.customer_phone, wish_list.customer_city, wish_list.wish_list_date.strftime("%d-%m-%Y")], :style => color_data_array
		  	row_count = row_count + 1
		  end
		  
		end

		excel_start_date = start_date.to_date.strftime('%m-%d-%Y')
		excel_end_date = end_date.to_date.strftime('%m-%d-%Y')

		file_name = "/excel/wish_list-#{excel_start_date}-#{excel_end_date}-#{time.to_i}.xlsx"
		report_file_name = "wish_list-#{excel_start_date}-#{excel_end_date}-#{time.to_i}.xlsx"
		xlsx.serialize "#{Rails.public_path}#{file_name}"
		s3_file_name = "#{Rails.public_path}#{file_name}"

    s3 = Aws::S3::Resource.new(
      credentials: Aws::Credentials.new(Rails.application.secrets.aws_access_key, Rails.application.secrets.aws_secret_key),
      region: 'us-east-1'
    )

    obj = s3.bucket(Rails.application.secrets.aws_bucket).object("wish_list_report/#{report_file_name}")
    obj.upload_file(s3_file_name, acl:'public-read')
    obj.public_url

    url_path = obj.public_url

    delete_excel_reports

    redirect_to(url_path)

	end

	private

  def delete_excel_reports
    files = Dir.glob(File.join("#{Rails.public_path}/excel", '**', '*')).select { |file| File.file?(file) }
    if files.count > 0
      files.each do |aFile|
        File.delete(aFile)
      end
    end
  end

end
