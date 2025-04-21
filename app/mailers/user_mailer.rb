class UserMailer < ApplicationMailer

  default from: "simply@alchemative.net"

  def send_report(user_email, mail_subject, body_text, file_path, cc_email, bcc_email)
    
    puts "User Email: => #{user_email}"
    puts "CC Email: => #{cc_email}"
    puts "BCC Email: => #{bcc_email}"
    puts "User Subject: =>  #{mail_subject}"
    puts "User Body: => #{body_text}"
    puts "User PDF: => #{file_path}"

    @body_text = body_text
    @file_path = file_path
    
    mail to: user_email, subject: mail_subject, :cc => cc_email, :bcc => bcc_email
    
  end

  def user_wishlist(user_email, mail_subject, wish_list, cc_email, bcc_email)
    puts "User Email: => #{user_email}"
    puts "CC Email: => #{cc_email}"
    puts "BCC Email: => #{bcc_email}"
    puts "User Subject: =>  #{mail_subject}"
    puts "Product Image: =>  #{wish_list.product_image}"

    @wish_list = wish_list
    
    mail to: user_email, subject: mail_subject, :cc => cc_email, :bcc => bcc_email
  end

  def restock_wishlist(user_email, mail_subject, wish_list, cc_email, bcc_email)
    puts "User Email: => #{user_email}"
    puts "CC Email: => #{cc_email}"
    puts "BCC Email: => #{bcc_email}"
    puts "User Subject: =>  #{mail_subject}"
    puts "Product Image: =>  #{wish_list.product_image}"

    @wish_list = wish_list
    
    mail to: user_email, subject: mail_subject, :cc => cc_email, :bcc => bcc_email
  end

end
