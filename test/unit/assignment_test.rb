=begin
require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  # Test relationships
   should belong_to(:deacon)
   should belong_to(:client)
   # should have_many(:interventions) # implement after interventions created

   # Test basic validations
   # for start date
   should allow_value(7.weeks.ago.to_date).for(:start_date)
   should allow_value(2.years.ago.to_date).for(:start_date)
   should_not allow_value(1.week.from_now.to_date).for(:start_date)
   should_not allow_value("bad").for(:start_date)
   should_not allow_value(nil).for(:start_date)
   
   # Need to do the rest with a context
   context "Creating four deacons and four clients with three assignments" do
     # create the objects I want with factories
     setup do 
       @dan = FactoryGirl.create(:client)
       @barnik = FactoryGirl.create(:client, :last_name => "Saha", :first_name => "Barnik" )
       @ryan = FactoryGirl.create(:client, :last_name => "Black", :first_name => "Ryan" )
       @nico = FactoryGirl.create(:client, :last_name => "Zevallos", :first_name => "Nico", :active => false)
       @carl = FactoryGirl.create(:deacon)
       @steph = FactoryGirl.create(:deacon, :first_name => "Steph", :last_name => "Seybert", :email => "sseybert@gmail.com", :gender => "female", :phone => "412-268-2323")
       @derek = FactoryGirl.create(:deacon, :first_name => "Derek", :last_name => "Lessard", :active => false, :email => "dlessard@hotmail.com")
       @gesue = FactoryGirl.create(:deacon, :first_name => "Gesue", :last_name => "Staltari", :email => "gstaltari@duq.edu", :role => "admin")
       @assign_carl = FactoryGirl.create(:assignment, :deacon => @carl, :client => @dan)
       @assign_steph = FactoryGirl.create(:assignment, :deacon => @steph, :client => @ryan, :start_date => 14.months.ago.to_date, :end_date => nil)
       @assign_carl_2 = FactoryGirl.create(:assignment, :deacon => @carl, :client => @barnik, :start_date => 2.years.ago.to_date, :end_date => 6.months.ago.to_date)
     end

     # and provide a teardown method as well
     teardown do
       @dan.destroy
       @barnik.destroy
       @ryan.destroy
       @nico.destroy
       @carl.destroy
       @steph.destroy
       @derek.destroy
       @gesue.destroy
       @assign_carl.destroy
       @assign_steph.destroy
       @assign_carl_2.destroy
     end
     
     should "have a scope 'for_client' that works" do
       assert_equal 1, Assignment.for_client(@dan.id).size
       assert_equal 1, Assignment.for_client(@ryan.id).size
     end
     
     should "have a scope 'for_deacon' that works" do
       assert_equal 2, Assignment.for_deacon(@carl.id).size
       assert_equal 1, Assignment.for_deacon(@steph.id).size
       assert_equal 0, Assignment.for_deacon(@gesue.id).size
     end
     
     should "have all the assignments listed alphabetically by client name" do
       assert_equal ["Black", "Saha", "Tabrizi"], Assignment.by_client.map{|a| a.client.last_name}
     end
     
     should "have all the assignments listed chronologically by start date" do
       assert_equal ["Carl", "Steph", "Carl"], Assignment.chronological.map{|a| a.deacon.first_name}
     end
     
     should "have all the assignments listed alphabetically by deacon name" do
       assert_equal ["Glazer", "Glazer", "Seybert"], Assignment.by_deacon.map{|a| a.deacon.last_name}
     end
     
     should "have a scope to find all current assignments for a client or deacon" do
       assert_equal 1, Assignment.current.for_client(@dan.id).size
       assert_equal 1, Assignment.current.for_client(@ryan.id).size
       assert_equal 1, Assignment.current.for_deacon(@steph.id).size
       assert_equal 2, Assignment.current.for_deacon(@carl.id).size
       assert_equal 0, Assignment.current.for_deacon(@gesue.id).size
     end
     
     should "have a scope to find all past assignments for a client or deacon" do
       assert_equal 1, Assignment.past.for_client(@dan.id).size
       assert_equal 1, Assignment.past.for_client(@barnik.id).size
       assert_equal 0, Assignment.past.for_client(@ryan.id).size
       assert_equal 2, Assignment.past.for_deacon(@carl.id).size
       assert_equal 0, Assignment.past.for_deacon(@gesue.id).size
     end
     
     should "allow for a end date in the past (or today) but after the start date" do
       @assign_gesue = FactoryGirl.build(:assignment, :deacon => @gesue, :client => @ryan, :start_date => 3.months.ago.to_date, :end_date => 1.month.ago.to_date)
       assert @assign_alex.valid?
       @assign_gesue_2 = FactoryGirl.build(:assignment, :deacon => @gesue, :client => @ryan, :start_date => 3.weeks.ago.to_date, :end_date => Time.now.to_date)
       assert @assign_gesue_2.valid?
     end
     
     should "not allow for a end date in the future or before the start date" do
       @assign_carl_3 = FactoryGirl.build(:assignment, :deacon => @carl, :client => @ryan, :start_date => 2.weeks.ago.to_date, :end_date => 3.weeks.ago.to_date)
       deny @assign_carl_2.valid?
       @assign_steph_2 = FactoryGirl.build(:assignment, :deacon => @steph, :client => @ryan, :start_date => 2.weeks.ago.to_date, :end_date => 3.weeks.from_now.to_date)
       deny @assign_steph_2.valid?
     end
     
     should "identify a non-active client as part of an invalid assignment" do
       inactive_client = FactoryGirl.build(:assignment, :client => @nico, :deacon => @carl, :start_date => 1.day.ago.to_date, :end_date => nil)
       deny inactive_client.valid?
     end
     
     should "identify a non-active deacon as part of an invalid assignment" do
       @fred = FactoryGirl.build(:deacon, :first_name => "Fred", :active => false)
       inactive_deacon = FactoryGirl.build(:assignment, :client => @dan, :deacon => @fred, :start_date => 1.day.ago.to_date, :end_date => nil)
       deny inactive_deacon.valid?
     end
     
     should "end the current assignment if it exists before adding a new assignment for an deacon" do
       @new_assign_steph = FactoryGirl.create(:assignment, :deacon => @steph, :client => @barnik, :start_date => 1.day.ago.to_date, :end_date => nil )
       assert_equal 1.day.ago.to_date, @steph.assignments.first.end_date
       @new_assign_steph.destroy
     end
     
   end
end
=end
