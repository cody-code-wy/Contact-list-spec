require_relative 'spec_helper'

describe Contact do

  before :each do
    @array = ["1","Name","Email@at.ca"]
    @contact = Contact.new(1,"Name","Email@at.ca")
  end

  describe '#initialize' do

    it "has and knows its id, name, and email" do

      expect(@contact.id).to be(1)

      expect(@contact.name).to eq("Name")

      expect(@contact.email).to eq("Email@at.ca")

    end

  end

  describe '::all' do

    it "should list all contacts" do

      expect(Contact).to receive(:read_contacts_file) { [@array] }

      contact = Contact.all

      expect(contact.count).to be(1)

      contact = contact.first

      expect(contact.id).to be(@contact.id)

      expect(contact.name).to eq(@contact.name)

      expect(contact.email).to eq(@contact.email)
    end

  end

  describe '::create' do

    it "Should write new contact to file" do

      @output = []

      expect(Contact).to receive(:write_contacts_file).and_yield(@output).and_return(nil)

      expect(Contact).to receive(:read_contacts_file) { [@array] }

      Contact.create("New","Contact@ourlist.com")

      expect(@output[0][0]).to be(2)
      expect(@output[0][1]).to eq("New")
      expect(@output[0][2]).to eq("Contact@ourlist.com")

    end

  end

  describe '::find' do

    it "Should return contact with matching id" do

      expect(Contact).to receive(:read_contacts_file) { [@array,[2,"Not this one","no@gmail.com"]] }
      contact = Contact.find(1)

      expect(contact.id).to be(1)
      expect(contact.name).to eq("Name")
      expect(contact.email).to eq("Email@at.ca")

    end

    it "Should return nil with no matching ids" do

      expect(Contact).to receive(:read_contacts_file) { [@array] }

      expect(Contact.find(40)).to be(nil)

    end

  end

  describe '::search' do

    it 'should find contact with matching name' do

      expect(Contact).to receive(:read_contacts_file) { [@array] }

      contacts = Contact.search("name")

      expect(contacts.count).to be(1)

      expect(contacts[0].name).to eq("Name")

    end

    it 'should find contact with matching email' do

      expect(Contact).to receive(:read_contacts_file) { [@array] }

      contacts = Contact.search("email@at.ca")

      expect(contacts.count).to be(1)

      expect(contacts[0].email).to eq("Email@at.ca")

    end

    it 'should find contact with partial matching name' do

      expect(Contact).to receive(:read_contacts_file) { [@array] }

      contacts = Contact.search("na")

      expect(contacts.count).to be(1)

      expect(contacts[0].name).to eq("Name")

    end

    it 'should find contact with partial matching email' do

      expect(Contact).to receive(:read_contacts_file) { [@array] }

      contacts = Contact.search("email")

      expect(contacts.count).to be(1)

      expect(contacts[0].email).to eq("Email@at.ca")

    end

    it 'should return nil when no contact matches' do

      expect(Contact).to receive(:read_contacts_file) { [@array] }

      contacts = Contact.search("NOBODY SHOULD MATCH THIS!!!!")

      expect(contacts.count).to be(0)

    end

    describe 'multiple matching' do

      before :each do
        @contacts = [
          [1,"Monica Mow","moo@cow.com"],
          [2,"Monica Mow","not@moo.cow"],
          [3,"Monica pop","test@example.com"],
          [4,"Sanpell Chair","schair@example.com"],
          [5,"NONONONO","nononono@nononono.ca"],
          [6,"Jen Dan","djen@gmail.com"],
          [7,"June Farak","fjune@jens.ca"]
        ]
      end

      it 'should return all matching names' do

        expect(Contact).to receive(:read_contacts_file) { @contacts }

        contacts = Contact.search("monica mow")

        expect(contacts.count).to be(2)

      end

      it 'should return all partial matching name' do

        expect(Contact).to receive(:read_contacts_file) { @contacts }

        contacts = Contact.search("monica")

        expect(contacts.count).to be(3)

      end

      it 'should return all partial matching emails' do

        expect(Contact).to receive(:read_contacts_file) { @contacts }

        contacts = Contact.search("example.com")

        expect(contacts.count).to be(2)

      end

      it 'should return only one exact email' do

        expect(Contact).to receive(:read_contacts_file) { @contacts }

        contacts = Contact.search("test@example.com")

        expect(contacts.count).to be(1)

      end

      it 'should return partial matches from email and name' do

        expect(Contact).to receive(:read_contacts_file) { @contacts }

        contacts = Contact.search("jen")

        expect(contacts.count).to be(2)

      end

    end

  end

end
