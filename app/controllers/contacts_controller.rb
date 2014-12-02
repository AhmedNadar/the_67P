class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.valid?
      @contact.update_spreadsheet
      UserMailer.contact_email(@contact).deliver
      flash[:notice] = "Message sent from #{@contact.name}."
      redirect_to root_path
    else
      render :new
    end
  end

  private
  def contact_params
    params.require(:contact).permit(:name, :email, :content)
  end
end
