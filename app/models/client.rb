class Client < ActiveRecord::Base
  # Callbacks
  before_save :reformat_phone

  # Relationships
  has_many :assignments
  has_many :deacons, :through => :assignments
  has_many :interventions, :through => :assignments

  # Validations
  validates_presence_of :first_name, :last_name, :gender, :address, :city, :state, :zip, :phone, :ethnicity
  validates :active, :inclusion => { :in => [true, false] }
  validates_inclusion_of :gender, :in => %w[Male Female], :message => "is not an option"
  validates_inclusion_of :marital_status, :in => %w[Single Married Separated Divorced Other], :message => "is not an option"
  validates_inclusion_of :state, :in => %w[PA OH WV], :message => "is not an option"
  validates_format_of :zip, :with => /^\d{5}$/, :message => "should be five digits long"
  validates_format_of :phone, :with => /^\(?\d{3}\)?[-. ]?\d{3}[-.]?\d{4}$/, :message => "should be 10 digits (area code needed) and delimited with dashes only"

  # Scopes
  scope :active, where('active = ?', true)
  scope :inactive, where('active = ?', false)
  scope :alphabetical, order('last_name, first_name')

  scope :receiving_gov_assistance, where('gov_assistance = ?', true)
  scope :not_receiving_gov_assistance, where('gov_assistance = ?', false)

  scope :male, where('gender = ?', 'male')
  scope :female, where('gender = ?', 'female')

  scope :by_marital_status, lambda { |status| where("marital_status = ?", status) }
  scope :by_ethnicity, lambda { |race| where("ethnicity = ?", race) }

  scope :employed, where('is_employed = ?', true)
  scope :unemployed, where('is_employed = ?', false)

  scope :veteran, where('is_veteran = ?', true)

  scope :assigned, where('current_assignment != ?', nil)
  scope :unassigned, where('current_assignment = ?', nil) 

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

  # Misc Constants
  GENDER_LIST = [['Male', 'Male'],['Female', 'Female']]
  STATES_LIST = [['Ohio', 'OH'],['Pennsylvania', 'PA'],['West Virginia', 'WV']]
  MARITAL_LIST = [['Single', 'Single'],['Married', 'Married'],['Separated', 'Separated'],['Divorced', 'Divorced'],['Other', 'Other']]

  # Callback code
  # -----------------------------
  private
  # We need to strip non-digits before saving to db
  def reformat_phone
    phone = self.phone.to_s  # change to string in case input as all numbers 
    phone.gsub!(/[^0-9]/,"") # strip all non-digits
    self.phone = phone       # reset self.phone to new string
  end
  
end