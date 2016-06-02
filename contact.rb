require 'csv'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  attr_accessor :name, :email, :id

  # Creates a new contact object
  # @param id [Fixnum] the unique id of the cantact
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(id, name, email)
    @id = id
    @name = name
    @email = email
  end

  # Provides functionality for managing contacts in the csv file.
  class << self

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all

      # CSV.foreach do |row|
      #   id = row[0].strip
      #   name = row[1].strip
      #   email = row[2].strip
      #   @contacts_array << Contact.new(id, name, email)
      # end
      # return @contacts_array

      read_contacts_file.map do |row|
        Contact.new(row[0].to_i,row[1],row[2])
      end
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    def create(name, email)
      contacts = all
      next_id = contacts.reduce(0) do |id, contact|
        id = contact.id + 1 if contact.id >= id
        id
      end
      write_contacts_file do |csv_object|
        csv_object << [next_id, name, email]
      end
    end

    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      all.detect do |contact|
        contact.id == id
      end
    end

    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)
      all.select do |contact|
        contact.name.downcase.include?(term) || contact.email.downcase.include?(term)
      end
    end

    private
    def read_contacts_file
      CSV.read("contacts.csv")
    end

    def write_contacts_file()

      CSV.open("contacts.csv",'a+') do |csv_object|
        yield csv_object
      end

    end
  end

end
