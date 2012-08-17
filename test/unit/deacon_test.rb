
require 'test_helper'
 
class DeaconTest < ActiveSupport::TestCase
	# Test relationships
	should have_many(:assignments)
	should have_many(:clients).through(:assignments)
	# should have_many(:interventions).through(:assignments)
  
	# Test basic validations
	should validate_presence_of(:last_name)
	should validate_presence_of(:first_name)
	should validate_presence_of(:email)
	should validate_presence_of(:gender)
	should validate_presence_of(:role)
	#should validate_presence_of(:active)
  
	# tests for email
	should allow_value("fred@fred.com").for(:email)
	should allow_value("fred@andrew.cmu.edu").for(:email)
	should allow_value("my_fred@fred.org").for(:email)
	should allow_value("fred123@fred.gov").for(:email)
	should allow_value("my.fred@fred.net").for(:email)

	should_not allow_value(nil).for(:email)
	should_not allow_value("fred").for(:email)
	should_not allow_value("fred@fred,com").for(:email)
	should_not allow_value("fred@fred.uk").for(:email)
	should_not allow_value("my fred@fred.com").for(:email)
	should_not allow_value("fred@fred.con").for(:email)

	# tests for phone
	should allow_value("4122683259").for(:phone)
	should allow_value("412-268-3259").for(:phone)
	should allow_value("412.268.3259").for(:phone)
	should allow_value("(412) 268-3259").for(:phone)

	should_not allow_value(nil).for(:phone)
	should_not allow_value("2683259").for(:phone)
	should_not allow_value("14122683259").for(:phone)
	should_not allow_value("4122683259x224").for(:phone)
	should_not allow_value("800-EAT-FOOD").for(:phone)
	should_not allow_value("412/268/3259").for(:phone)
	should_not allow_value("412-2683-259").for(:phone)

	# tests for gender
	should allow_value("Male").for(:gender)
	should allow_value("Female").for(:gender)

	should_not allow_value(nil).for(:gender)
	should_not allow_value(1).for(:gender)
	should_not allow_value("seahorse").for(:gender)
	should_not allow_value("I believe gender is a societal construct.").for(:gender)

	# tests for role
	should allow_value("Admin").for(:role)
	should allow_value("Deacon").for(:role)

	should_not allow_value("boss").for(:role)
	should_not allow_value("employee").for(:role)
	should_not allow_value(10).for(:role)
	should_not allow_value("vp").for(:role)
	should_not allow_value(nil).for(:role)

	# tests for active
	should allow_value(true).for(:active)
	should allow_value(false).for(:active)

	should_not allow_value(nil).for(:active)
	# should_not allow_value("yes").for(:active)
	# should_not allow_value(1).for(:active)

# 	# SHOULD I TEST FOR LAST_NAME, FIRST_NAME, PASSWORD, OR PASSWORD HASH?
  
  context "Creating a deacon and a administrator" do
	# create the objects I want with factories
	setup do 
	  @dan = FactoryGirl.create(:client)
	  @carl = FactoryGirl.create(:deacon)
	  @steph = FactoryGirl.create(:deacon, :first_name => "Steph", :last_name => "Seybert", :email => "sseybert@gmail.com", :gender => "Female", :phone => "412-268-2323")
	  @derek = FactoryGirl.create(:deacon, :first_name => "Derek", :last_name => "Lessard", :active => false, :email => "dlessard@hotmail.com")
	  @gesue = FactoryGirl.create(:deacon, :first_name => "Gesue", :last_name => "Staltari", :email => "gstaltari@duq.edu", :role => "Admin")
	  @assign_carl = FactoryGirl.create(:assignment, :deacon => @carl, :client => @dan)
	  @assign_steph = FactoryGirl.create(:assignment, :deacon => @steph, :client => @dan, :end_date => nil)
	end

	# and provide a teardown method as well
  	teardown do
  	  @dan.destroy
      @carl.destroy
      @steph.destroy
      @derek.destroy
      @gesue.destroy
      @assign_carl.destroy
      @assign_steph.destroy
    end

	# now run the tests:
	# test deacons must have unique email #DONE
	should "force deacons to have unique email" do
	  email_taken = FactoryGirl.build(:deacon, :first_name => "Chuck", :last_name => "Glazer", :email => "cglazer@andrew.cmu.edu")
	  assert_equal false, email_taken.valid?
	end

	# test the scope 'active' #DONE
	should "shows that there are three active deacons" do
	  assert_equal 3, Deacon.active.size
	  assert_equal ["Glazer", "Seybert", "Staltari"], Deacon.active.alphabetical.map{|e| e.last_name}
	end
	
	# test the scope 'inactive' #DONE
	should "shows that there is one inactive deacon" do
	  assert_equal 1, Deacon.inactive.size
	  assert_equal ["Lessard"], Deacon.inactive.alphabetical.map{|e| e.last_name}
	end

    # test the scope 'alphabetical'
    should "shows that there are four deacons in alphabetical order" do
      assert_equal ["Glazer", "Lessard", "Seybert", "Staltari"], Deacon.alphabetical.map{|s| s.last_name}
    end
	
	# test the scope 'regulars' #DONE
	should "shows that there are 3 normal deacons: Carl, Steph, and Derek" do
	  assert_equal 3, Deacon.regulars.size
	  assert_equal ["Glazer","Lessard","Seybert"], Deacon.regulars.alphabetical.map{|e| e.last_name}
	end

	# test the scope 'admins' #DONE
	should "shows that there is one admin: Gesue" do
	  assert_equal 1, Deacon.admins.size
	  assert_equal ["Staltari"], Deacon.admins.alphabetical.map{|e| e.last_name}
	end
	
	# test the method 'name' #DONE
	should "shows name as last, first name" do
	  assert_equal "Staltari, Gesue", @gesue.name
	end   
	
	# test the method 'proper_name' #DONE
	should "shows proper name as first and last name" do
	  assert_equal "Gesue Staltari", @gesue.proper_name
	end 
	
	# test the method 'current_assignment' #DONE
	should "shows deacon's current assignment if it exists" do
	  assert_equal "Tabrizi", @steph.current_assignment.client.last_name
	  assert_nil @derek.current_assignment
	end

	# test the scope 'male'
    should "shows that there are three male deacons" do
      assert_equal 3, Deacon.male.size
      assert_equal ["Glazer", "Lessard", "Staltari"], Deacon.male.alphabetical.map{|s| s.last_name}
    end

    # test the scope 'female'
    should "shows that there is one female deacon" do
      assert_equal 1, Deacon.female.size
      assert_equal ["Seybert"], Deacon.female.alphabetical.map{|s| s.last_name}
    end

	# test the callback is working 'reformat_phone' #DONE
	should "shows that Steph's phone is stripped of non-digits" do
	  assert_equal "4122682323", @steph.phone
	end

    # test the method 'assigned'
    should "shows one assigned deacon" do
      assert_equal ["Seybert"], Deacon.assigned.map{|s| s.last_name}
    end

    # test the method 'unassigned'
    should "shows two unassigned deacons" do
      assert_equal [ "Glazer", "Lessard", "Staltari"], Deacon.unassigned.map{|s| s.last_name}
      assert_equal [ "Glazer", "Staltari"], Deacon.active.unassigned.map{|s| s.last_name}
    end

  end
end