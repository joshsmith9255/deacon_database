class Deacon < ActiveRecord::Base	
  # Callbacks
  before_save :reformat_phone
  
  # Use built-in rails support for password protection
  # has_secure_password
  #attr_accessible :password, :password_confirmation

  # Relationships
  has_many :assignments
  has_many :clients, :through => :assignments
  has_many :interventions, :through => :assignments
  
  # Validations
  validates_presence_of :first_name, :last_name, :phone, :role, :gender, :email
  validates :active, :inclusion => { :in => [true, false] }
  validates_format_of :phone, :with => /^\(?\d{3}\)?[-. ]?\d{3}[-.]?\d{4}$/, :message => "should be 10 digits (area code needed) and delimited with dashes only", :allow_blank => false
  validates_inclusion_of :role, :in => %w[Admin Deacon], :message => "is not an option"
  validates_inclusion_of :gender, :in => %w[Male Female], :message => "is not an option"
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))$/i, :message => "is not a valid format"
  
  # Scopes
  scope :active, where('active = ?', true)
  scope :inactive, where('active = ?', false)
  scope :regulars, where('role = ?', 'Deacon')
  scope :admins, where('role = ?', 'Admin')

  scope :male, where('gender = ?', 'Male')
  scope :female, where('gender = ?', 'Female')
  
  scope :alphabetical, order('last_name, first_name')

  # scope :assigned, where('current_assignment != ?', nil)
  # scope :unassigned, where('current_assignment = ?', nil) 
  
  # Other methods
  def name
    "#{last_name}, #{first_name}"
  end
  
  def proper_name
    "#{first_name} #{last_name}"
  end
  
  def current_assignment
    curr_assignment = self.assignments.select{|a| a.end_date.nil?}
    # alternative method for finding current assignment is to use scope 'current' in assignments:
    # curr_assignment = self.assignments.current    # will also return an array of current assignments
    return nil if curr_assignment.empty?
    curr_assignment.first   # return as a single object, not an array
  end

  # def assigned
  #   all_assigned_deacons = Deacon.select{|a| a.current_assignment != nil}
  #   all_active_employees = Employee.active.all.map{|e| e.id}
  #   all_assigned_deacons
  # end

  # def unassigned
  #   all_unassigned_deacons = Deacon.select{|a| a.current_assignment == nil}
  #   all_unassigned_deacons
  # end
  
  # Misc Constants
  ROLE_LIST = [['Deacon', 'Deacon'],['Administrator', 'Admin']]
  GENDER_LIST = [['Male', 'Male'],['Female', 'Female']]
  
  # Callback code  (NOT DRY!!!)
  # -----------------------------
   private
   def reformat_phone
     phone = self.phone.to_s  # change to string in case input as all numbers 
     phone.gsub!(/[^0-9]/,"") # strip all non-digits
     self.phone = phone       # reset self.phone to new string
   end
end