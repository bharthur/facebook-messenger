module Facebook
  module Messenger
    module Incoming
      # The Postback class represents an incoming Facebook Messenger postback.
      class Postback
        include Facebook::Messenger::Incoming::Common

        def payload
          @messaging['postback']['payload']
        end

        def referral
          return if @messaging['postback']['referral'].nil?
          @referral ||= Referral::Referral.new(
            @messaging['postback']['referral']
          )
        end
        
        def scoped_sender_info
          @scoped_sender_info ||= Unirest.get("https://graph.facebook.com/v2.9/#{sender['id']}", parameters: {
            access_token: access_token
          }).body
        end
        
        def scoped_sender_name
          @scoped_sender_name ||= "#{scoped_sender_info['first_name']} #{scoped_sender_info['last_name']}"
        end
        
      end
    end
  end
end
