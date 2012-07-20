require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  # Test relationships
  should have_many(:assignments)
  should have_many(:deacons).through(:assignments)
  should have_many(:interventions).through(:assignments)

  # Test basic validations
  should validate_presence_of(:last_name)
  should validate_presence_of(:first_name)
  should validate_presence_of(:gender)
  should validate_presence_of(:address)
  should validate_presence_of(:city)
  should validate_presence_of(:state)
  should validate_presence_of(:zip)
  should validate_presence_of(:phone)
  should validate_presence_of(:active)

  # Identity-based tests
      # tests for gender
      should allow_value("male").for(:gender)
      should allow_value("female").for(:gender)

      should_not allow_value(nil).for(:gender)
      should_not allow_value(1).for(:gender)
      should_not allow_value("seahorse").for(:gender)
      should_not allow_value("I believe gender is a societal construct.").for(:gender)

      # tests for ethnicity
      should allow_value("Asian").for(:ethnicity)
      should allow_value("Black").for(:ethnicity)
      should allow_value("Hispanic").for(:ethnicity)
      should allow_value("Latino").for(:ethnicity)
      should allow_value("Native American").for(:ethnicity)
      should allow_value("White").for(:ethnicity)

      should_not allow_value(nil).for(:ethnicity)
      should_not allow_value(1).for(:ethnicity)
      should_not allow_value(true).for(:ethnicity)
      should_not allow_value(0.5).for(:ethnicity)

      # tests for marital status
      should allow_value("single").for(:marital_status)
      should allow_value("married").for(:marital_status)
      should allow_value("separated").for(:marital_status)
      should allow_value("divorced").for(:marital_status)

      should_not allow_value("White").for(:marital_status)
      should_not allow_value(nil).for(:marital_status)
      should_not allow_value(1).for(:marital_status)
      should_not allow_value(true).for(:marital_status)
      should_not allow_value("I believe marriage is a societal construct.").for(:marital_status)

  # Contact-based Tests
      # tests for address
      should allow_value("101 North Dithridge Street").for(:address)
      should allow_value("5000 Forbes Avenue").for(:address)

      should_not allow_value(true).for(:address)
      should_not allow_value(101).for(:address)
      should_not allow_value(nil).for(:address)

      # tests for zip
      should allow_value("15213").for(:zip)

      should_not allow_value("bad").for(:zip)
      should_not allow_value("1512").for(:zip)
      should_not allow_value("152134").for(:zip)
      should_not allow_value("15213-0983").for(:zip)

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

      should_not allow_value(150).for(:gov_assistance)
      should_not allow_value("Yes").for(:gov_assistance)

      # tests for is_employed
      should allow_value(true).for(:is_employed)
      should allow_value(false).for(:is_employed)

      should_not allow_value(30000).for(:is_employed)
      should_not allow_value("UPMC").for(:is_employed)

      # tests for is_veteran
      should allow_value(true).for(:is_veteran)
      should allow_value(false).for(:is_veteran)

      should_not allow_value(nil).for(:is_veteran)
      should_not allow_value("Marines").for(:is_veteran)
  
  # Establish context
  # Testing other methods with a context
  context "Creating seven clients" do
    setup do 
      @dan = FactoryGirl.create(:client)
      @barnik = FactoryGirl.create(:client, :last_name => "Saha", :first_name => "Barnik", :active => false, :ethnicity => "Indian" )
      @ryan = FactoryGirl.create(:client, :last_name => "Black", :first_name => "Ryan", :phone => "412-867-5309", :ethnicity => "White", :gov_assistance => true )
      @joe = FactoryGirl.create(:client, :last_name => "Oak", :first_name => "Joseph", :ethnicity => "Asian", :is_employed => false )
      @madeleine = FactoryGirl.create(:client, :last_name => "Clute", :first_name => "Madeleine", :gender => "female", :ethnicity => "White" )
      @jonathan = FactoryGirl.create(:client, :last_name => "Carreon", :first_name => "Jonathan", :is_veteran => true )
      @meg = FactoryGirl.create(:client, :last_name => "Smith", :first_name => "Megan", :ethnicity => "White", :gender => "female", :is_employed => false)
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
    end
  
    # test one of each factory
    should "show that all factories are properly created" do
      assert_equal "Tabrizi", @dan.last_name
      assert @ryan.active
      assert @joe.active
      assert_equal "Madeleine", @madeleine.first_name
      assert @jonathan.active
      assert @meg.active
      deny @barnik.active
    end
    
    # test the callback is working 'reformat_phone'
    should "shows that Ryan's phone is stripped of non-digits" do
      assert_equal "4128675309", @ryan.phone
    end
    
    # test the scope 'alphabetical'
    should "shows that there are seven clients in in alphabetical order" do
      assert_equal ["Black", "Carreon", "Clute", "Oak", "Saha", "Smith", "Tabrizi"], Client.alphabetical.map{|s| s.last_name}
    end
    
    # test the scope 'active'
    should "shows that there are six active clients" do
      assert_equal 2, Client.active.size
      assert_equal ["Black", "Carreon", "Clute", "Oak", "Smith", "Tabrizi"], Client.active.alphabetical.map{|s| s.last_name}
    end
    
    # test the scope 'inactive'
    should "shows that there is one inactive client" do
      assert_equal 1, Client.inactive.size
      assert_equal ["Saha"], Client.inactive.alphabetical.map{|s| s.last_name}
    end
    
    # test the scope 'receiving_gov_assistance'
    should "shows that there is one client receiving government assistance"
      assert_equal 1, Client.receiving_gov_assistance.size
      assert_equal ["Black"], Client.receiving_gov_assistance.alphabetical.map{|s| s.last_name}
    end

    # test the scope 'not_receiving_gov_assistance'
    should "shows that there are six clients not receiving government assistance"
      assert_equal 6, Client.not_receiving_gov_assistance.size
      assert_equal ["Carreon", "Clute", "Oak", "Saha", "Smith", "Tabrizi"], Client.not_receiving_gov_assistance.alphabetical.map{|s| s.last_name}
    end

    # test the scope 'male'
    should "shows that there are five male clients"
      assert_equal 6, Client.male.size
      assert_equal ["Black", "Carreon", "Oak", "Saha", "Tabrizi"], Client.male.alphabetical.map{|s| s.last_name}
    end

    # test the scope 'female'
    should "shows that there are two female clients"
      assert_equal 2, Client.female.size
      assert_equal ["Clute", "Smith"], Client.female.alphabetical.map{|s| s.last_name}
    end

    # test the scope 'employed'
    should "shows that there are five employed clients"
      assert_equal 5, Client.employed.size
      assert_equal ["Black", "Carreon", "Clute", "Saha", "Tabrizi"], Client.employed.alphabetical.map{|s| s.last_name}
    end

    # test the scope 'unemployed'
    should "shows that there are two unemployed clients"
      assert_equal 2, Client.unemployed.size
      assert_equal ["Oak", "Smith"], Client.unemployed.alphabetical.map{|s| s.last_name}
    end

    # test the scope 'veteran'
    should "shows that there is one employed clients"
      assert_equal 1, Client.veteran.size
      assert_equal ["Carreon"], Client.veteran.alphabetical.map{|s| s.last_name}
    end

    # test the method 'name' #DONE
    should "shows name as last, first name" do
      assert_equal "Tabrizi, Dan", @dan.name
    end   
  
    # test the method 'proper_name' #DONE
    should "shows proper name as first and last name" do
      assert_equal "Dan Tabrizi", @dan.proper_name
    end 

  end
end
