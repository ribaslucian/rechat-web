class Message < ApplicationRecord
  # 1
  after_create_commit { broadcast_if_raw_message }
  before_save :translate_and_calc_sentimental
  
  belongs_to :interaction, optional: true
  
  belongs_to :origin_user, class_name: 'User', foreign_key: :origin_user_id, optional: true
  belongs_to :destiny_user, class_name: 'User', foreign_key: :destiny_user_id, optional: true
  belongs_to :previous_message, class_name: 'User', foreign_key: :previous_message_id, optional: true

  def broadcast_if_raw_message
    if self.interaction_id.nil?
      ChatBroadcastJob.perform_later self
    end
  end

  def translate_and_calc_sentimental
    if self.type_acronym_id == 2
      self.content_en = %x(python scripts/translate.py "#{self.content}")
      
      analyzer = Sentimental.new
      analyzer.load_defaults
      self.sentimental_category = analyzer.sentiment self.content
      self.sentimental_score = analyzer.score self.content
    end
  end
  
  def self.seed_test
      Message.create!({
          origin_user_id: 2,
          destiny_user_id: 1,
          content: "A nível organizacional, a revolução dos costumes promove a alavancagem do sistema de formação de quadros que corresponde às necessidades.",
          contact_id: 1
      })
    
      Message.create!({
          origin_user_id: 2,
          destiny_user_id: 1,
          content: "A nível organizacional, a revolução dos costumes promove a alavancagem",
          contact_id: 1
      })
    
      Message.create!({
          origin_user_id: 2,
          destiny_user_id: 1,
          content: "aff",
          contact_id: 1
      })
  end
end
