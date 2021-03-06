require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  
  # Test relationships
  should have_many(:assignments)
  should have_many(:deacons).through(:assignments)
  #should have_many(:interventions).through(:assignments)
  
  # Test basic validations
  should validate_presence_of(:last_name)
  should validate_presence_of(:first_name)
  should validate_presence_of(:gender)
  should validate_presence_of(:address)
  should validate_presence_of(:city)
  should validate_presence_of(:state)
  should validate_presence_of(:zip)
  should validate_presence_of(:phone)
  #should validate_presence_of(:active)
  
  # Identity-based tests
      # tests for gender
      should allow_value("Male").for(:gender)
      should allow_value("Female").for(:gender)
  
      should_not allow_value(nil).for(:gender)
      should_not allow_value(1).for(:gender)
      should_not allow_value("seahorse").for(:gender)
      should_not allow_value("I believe gender is a societal construct.").for(:gender)
  
      # tests for ethnicity
      should allow_value("Asian").for(:ethnicity)
      should allow_value("Black").for(:ethnicity)
      should allow_value("Hispanic").for(:ethnicity)
      should allow_value("Native_American").for(:ethnicity)
      should allow_value("White").for(:ethnicity)

      
      should_not allow_value(nil).for(:ethnicity)
      should_not allow_value(1).for(:ethnicity)
      should_not allow_value(true).for(:ethnicity)
      should_not allow_value(0.5).for(:ethnicity)
  
      # tests for marital status
      should allow_value("Single").for(:marital_status)
      should allow_value("Married").for(:marital_status)
      should allow_value("Separated").for(:marital_status)
      should allow_value("Divorced").for(:marital_status)
      should allow_value("Other").for(:marital_status)
  
      should_not allow_value("White").for(:marital_status)
      should_not allow_value(nil).for(:marital_status)
      should_not allow_value(1).for(:marital_status)
      should_not allow_value(true).for(:marital_status)
      should_not allow_value("I believe marriage is a societal construct.").for(:marital_status)
  
  # Contact-based Tests
      # tests for address
      should allow_value("101 North Dithridge Street").for(:address)
      should allow_value("5000 Forbes Avenue").for(:address)
  
      # should_not allow_value(true).for(:address)
      # should_not allow_value(101).for(:address)
      # should_not allow_value(nil).for(:address)
  
      # # tests for zip
      should allow_value("15213").for(:zip)
  
      # should_not allow_value("bad").for(:zip)
      # should_not allow_value("1512").for(:zip)
      # should_not allow_value("152134").for(:zip)
      # should_not allow_value("15213-0983").for(:zip)
  
      # tests for state
      should allow_value("OH").for(:state)
      should allow_value("PA").for(:state)
      should allow_value("WV").for(:state)
      should_not allow_value("bad").for(:state)
      should_not allow_value("NY").for(:state)
      should_not allow_value(10).for(:state)
      should_not allow_value("CA").for(:state)
  
      # tests for phone
      should allow_value("4122683259").for(:phone)
      should allow_value("412-268-3259").for(:phone)
      should allow_value("412.268.3259").for(:phone)
      should allow_value("(412) 268-3259").for(:phone)
      should_not allow_value("2683259").for(:phone)
      should_not allow_value("14122683259").for(:phone)
      should_not allow_value("4122683259x224").for(:phone)
      should_not allow_value("800-EAT-FOOD").for(:phone)
      should_not allow_value("412/268/3259").for(:phone)
      should_not allow_value("412-2683-259").for(:phone)
      
      # Assistance-based tests
          # tests for gov_assistance
          should allow_value(true).for(:gov_assistance)
          should allow_value(false).for(:gov_assistance)
      
          # should_not allow_value(150).for(:gov_assistance)
          # should_not allow_value("Yes").for(:gov_assistance)
      
          # tests for is_employed
          should allow_value(true).for(:is_employed)
          should allow_value(false).for(:is_employed)
      
          # should_not allow_value(30000).for(:is_employed)
          # should_not allow_value("UPMC").for(:is_employed)
      
          # tests for is_veteran
          should allow_value(true).for(:is_veteran)
          should allow_value(false).for(:is_veteran)
      
          # should_not allow_value(nil).for(:is_veteran)
          # should_not allow_value("Marines").for(:is_veteran)
  
  # Establish context
  # Testing other methods with a context
  context "Creating seven clients, one deacon, and three assignments" do
    setup do 
          @dan = FactoryGirl.create(:client)
          @barnik = FactoryGirl.create(:client, :last_name => "Saha", :first_name => "Barnik", :active => false, :ethnicity => "Indian" )
          @ryan = FactoryGirl.create(:client, :last_name => "Black", :first_name => "Ryan", :phone => "412-867-5309", :ethnicity => "White", :gov_assistance => true )
          @joe = FactoryGirl.create(:client, :last_name => "Oak", :first_name => "Joseph", :ethnicity => "Asian", :is_employed => false )
          @madeleine = FactoryGirl.create(:client, :last_name => "Clute", :first_name => "Madeleine", :gender => "Female", :ethnicity => "White", :marital_status => "Married" )
          @jonathan = FactoryGirl.create(:client, :last_name => "Carreon", :first_name => "Jonathan", :is_veteran => true )
          @meg = FactoryGirl.create(:client, :last_name => "Smith", :first_name => "Megan", :ethnicity => "White", :gender => "Female", :is_employed => false)

          @carl = FactoryGirl.create(:deacon)
          @steph = FactoryGirl.create(:deacon, :first_name => "Steph", :last_name => "Seybert", :email => "sseybert@gmail.com", :gender => "Female", :phone => "412-268-2323")

          @dan_assignment = FactoryGirl.create(:assignment, :client => @dan, :deacon => @carl)
          @ryan_assignment = FactoryGirl.create(:assignment, :client => @ryan, :deacon => @carl, :end_date => nil)
          @madeleine_assignment = FactoryGirl.create(:assignment, :client => @madeleine, :deacon => @steph, :end_date => nil)
        end
        
        # and provide a teardown method as well
    
        teardown do
          @dan.destroy
          @barnik.destroy
          @ryan.destroy
          @joe.destroy
          @madeleine.destroy
          @jonathan.destroy
          @meg.destroy

          @carl.destroy
          @steph.destroy

          @dan_assignment.destroy
          @ryan_assignment.destroy
          @madeleine_assignment.destroy
        end
    
      
        # test one of each factory
        should "show that all factories are properly created" do
          assert_equal "Tabrizi", @dan.last_name
          assert @ryan.active
          assert @joe.active
          assert_equal "Madeleine", @madeleine.first_name
          assert @jonathan.active
          assert @meg.active
          assert_equal false, @barnik.active
        end
        
        # test the callback is working 'reformat_phone'
        should "shows that Ryan's phone is stripped of non-digits" do
          assert_equal "4128675309", @ryan.phone
        end
        
        # test the scope 'alphabetical'
        should "shows that there are seven clients in alphabetical order" do
          assert_equal ["Black", "Carreon", "Clute", "Oak", "Saha", "Smith", "Tabrizi"], Client.alphabetical.map{|s| s.last_name}
        end
        
        # test the scope 'active'
        should "shows that there are six active clients" do
          assert_equal 6, Client.active.size
          assert_equal ["Black", "Carreon", "Clute", "Oak", "Smith", "Tabrizi"], Client.active.alphabetical.map{|s| s.last_name}
        end
        
        # test the scope 'inactive'
        should "shows that there is one inactive client" do
          assert_equal 1, Client.inactive.size
          assert_equal ["Saha"], Client.inactive.alphabetical.map{|s| s.last_name}
        end
        
        # test the scope 'receiving_gov_assistance'
        should "shows that there is one client receiving government assistance" do
          assert_equal 1, Client.receiving_gov_assistance.size
          assert_equal ["Black"], Client.receiving_gov_assistance.alphabetical.map{|s| s.last_name}
        end
    
        # test the scope 'not_receiving_gov_assistance'
        should "shows that there are six clients not receiving government assistance" do
          assert_equal 6, Client.not_receiving_gov_assistance.size
          assert_equal ["Carreon", "Clute", "Oak", "Saha", "Smith", "Tabrizi"], Client.not_receiving_gov_assistance.alphabetical.map{|s| s.last_name}
        end
    
        # test the scope 'male'
        should "shows that there are five male clients" do
          assert_equal 5, Client.male.size
          assert_equal ["Black", "Carreon", "Oak", "Saha", "Tabrizi"], Client.male.alphabetical.map{|s| s.last_name}
        end
    
        # test the scope 'female'
        should "shows that there are two female clients" do
          assert_equal 2, Client.female.size
          assert_equal ["Clute", "Smith"], Client.female.alphabetical.map{|s| s.last_name}
        end
    
        # test the scope 'employed'
        should "shows that there are five employed clients" do
          assert_equal 5, Client.employed.size
          assert_equal ["Black", "Carreon", "Clute", "Saha", "Tabrizi"], Client.employed.alphabetical.map{|s| s.last_name}
        end
    
        # test the scope 'unemployed'
        should "shows that there are two unemployed clients" do
          assert_equal 2, Client.unemployed.size
          assert_equal ["Oak", "Smith"], Client.unemployed.alphabetical.map{|s| s.last_name}
        end
    
        # test the scope 'veteran'
        should "shows that there is one veteran clients" do
          assert_equal 1, Client.veteran.size
          assert_equal ["Carreon"], Client.veteran.alphabetical.map{|s| s.last_name}
        end

        # test the scope 'unmarried'
        should "shows six unmarried clients" do
          assert_equal ["Black", "Carreon", "Oak", "Saha", "Smith", "Tabrizi"], Client.unmarried.alphabetical.map{|s| s.last_name}
        end

        # test the scope 'married'
        should "shows one married client" do
          assert_equal ["Clute"], Client.married.alphabetical.map{|s| s.last_name}
        end

        # test the scope 'is_white'
        should "shows three white clients" do
          assert_equal ["Black", "Clute", "Smith"], Client.is_white.alphabetical.map{|s| s.last_name}
        end

        # test the scope 'is_minority'
        should "shows four minority clients" do
          assert_equal [ "Carreon", "Oak", "Saha", "Tabrizi"], Client.is_minority.alphabetical.map{|s| s.last_name}
        end 
    
        # test the method 'name'
        should "shows name as last, first name" do
          assert_equal "Tabrizi, Dan", @dan.name
        end   
      
        # test the method 'proper_name'
        should "shows proper name as first and last name" do
          assert_equal "Dan Tabrizi", @dan.proper_name
        end

        # Special Assignment Method Testing

        # test the method 'current_assignment'
        should "shows clients' current assignments" do
          assert_equal "Glazer", @ryan.current_assignment.deacon.last_name
          assert_equal "Seybert", @madeleine.current_assignment.deacon.last_name
          assert_equal nil, @dan.current_assignment
        end

        # test the method 'assigned'
        should "shows two assigned clients" do
          assert_equal ["Black", "Clute"], Client.assigned.map{|s| s.last_name}
        end

        # test the method 'unassigned'
        should "shows five unassigned clients" do
          assert_equal [ "Carreon", "Oak", "Saha", "Smith", "Tabrizi"], Client.unassigned.map{|s| s.last_name}
          assert_equal [ "Carreon", "Oak", "Smith", "Tabrizi"], Client.active.unassigned.map{|s| s.last_name}
        end
    
  end
  
end
