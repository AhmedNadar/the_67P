class Contact < ActiveRecord::Base
  has_no_table
  column :name, :string
  column :email, :string
  column :content, :string
  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :content
  validates_format_of :email,
                      :with => /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i
  validates_length_of :content, :maximum => 500

  def update_spreadsheet
    # create a connection with google drive
    # The follwing line donsn't work. Writing explicit credentials will do the trick.
    # Not safe but it works,
    connection = GoogleDrive.login(ENV["GMAIL_USERNAME"], ENV["GMAIL_PASSWORD"])
    ss = connection.spreadsheet_by_title('The-67-P')
    if ss.nil? # check of spread sheet exisit if not, creat one below
      ss = connection.create_spreadsheet('The-67-P')
    end
    ws = ss.worksheets[0] # use only one spread sheet to save our data in it
    last_row = 1 + ws.num_rows
    ws[last_row, 1] = Time.new
    ws[last_row, 2] = self.name
    ws[last_row, 3] = self.email
    ws[last_row, 4] = self.content
    ws.save
  end

end