class Assignment < ActiveRecord::Base
  # Callbacks
  before_create :end_previous_assignment
  
  # Relationships
  belongs_to :deacon
  belongs_to :client
  # has_many :interventions # implement with interventions
  
  # Validations
  validates_date :start_date, :on_or_before => lambda { Date.current }, :on_or_before_message => "cannot be in the future"
  validates_date :end_date, :after => :start_date, :on_or_before => lambda { Date.current }, :allow_blank => true
  validate :deacon_is_active_in_system
  validate :client_is_active_in_system
  
  # Scopes
  scope :current, where('end_date IS NULL')
  scope :past, where('end_date IS NOT NULL')
  scope :by_client, joins(:client).order('last_name', 'first_name')
  scope :by_deacon, joins(:deacon).order('last_name, first_name')
  scope :chronological, order('start_date DESC, end_date DESC')
  scope :for_client, lambda {|client_id| where("client_id = ?", client_id) }
  scope :for_deacon, lambda {|deacon_id| where("deacon_id = ?", deacon_id) }

  # Private methods for callbacks and custom validations
  private  
  
  def end_previous_assignment
    current_assignment = Deacon.find(self.deacon_id).current_assignment
    if current_assignment.nil?
      return true 
    else
      current_assignment.update_attribute(:end_date, self.start_date.to_date)
    end
  end
  
  def deacon_is_active_in_system
    all_active_deacons = Deacon.active.all.map{|e| e.id}
    unless all_active_deacons.include?(self.deacon_id)
      errors.add(:deacon_id, "is not an active deacon at ACAC")
    end
  end
  
  def client_is_active_in_system
    all_active_clients = Client.active.all.map{|s| s.id}
    unless all_active_clients.include?(self.client_id)
      errors.add(:client_id, "is not an active client at ACAC")
    end
  end
end