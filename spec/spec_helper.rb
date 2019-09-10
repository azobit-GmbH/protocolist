require 'protocolist'
require "active_record"
Bundler.require(:default)

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

ActiveRecord::Schema.define do
  create_table :activities, force: true do |t|
    t.integer :actor_id      
    t.string :actor_type    
    t.integer :target_id     
    t.string :target_type   
    t.string :activity_type
    t.text :data           
    t.string :tracked_type
  end

  create_table :users, force: true do |t|
    t.string :name
  end

  create_table :firestarters, force: true do |t|
    t.string :name
  end

  create_table :simple_firestarters, force: true do |t|
    t.string :name
  end

  create_table :conditional_firestarters, force: true do |t|
    t.string :name
  end

  create_table :complex_firestarters, force: true do |t|
    t.string :name
  end
end

class Activity < ActiveRecord::Base
  belongs_to :target, polymorphic: true
  belongs_to :actor,  polymorphic: true

  serialize :data

  def activity_type
    read_attribute(:activity_type).to_sym
  end
end

class User < ActiveRecord::Base
end

class Firestarter < ActiveRecord::Base
  include Protocolist::ModelAdditions

  def delete
    fire :delete, target: false
  end

  def myself
    fire :myself
  end

  def love_letter_for_mary(target, data)
    fire :love_letter, target: target, data: data
  end
end

class SimpleFirestarter < ActiveRecord::Base
  include Protocolist::ModelAdditions
  fires :create
end

class ConditionalFirestarter < ActiveRecord::Base
  include Protocolist::ModelAdditions

  fires :i_will_be_saved, on: :create, if: :return_true_please
  fires :and_i_won_t,     on: :create, if: :return_false_please

  def return_false_please
    false
  end

  def return_true_please
    true
  end
end

class ComplexFirestarter < ActiveRecord::Base
  include Protocolist::ModelAdditions

  fires :yohoho, on: [:create, :destroy], target: false, data: :hi

  def hi
    'Hi!'
  end
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run(focus: true)
  config.run_all_when_everything_filtered = true
end
