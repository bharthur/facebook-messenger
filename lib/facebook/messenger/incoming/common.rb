module Facebook
  module Messenger
    module Incoming
      # Common attributes for all incoming data from Facebook.
      module Common
        attr_reader :messaging

        def initialize(messaging)
          @messaging = messaging
        end

        def sender
          @messaging['sender']
        end
        
        def scoped_sender_info
          @scoped_sender_info ||= Unirest.get("https://graph.facebook.com/v2.9/#{sender['id']}", parameters: {
            access_token: access_token,
            fields: "first_name,last_name,profile_pic,locale,timezone,gender,last_ad_referral"
          }).body
        end
        
        def scoped_sender_name
          @scoped_sender_name ||= "#{scoped_sender_info['first_name']} #{scoped_sender_info['last_name']}"
        end
        
        def ad_id
          @ad_id ||= scoped_sender_info.dig("last_ad_referral", "ad_id")
        end

        def recipient
          @messaging['recipient']
        end

        def sent_at
          Time.at(@messaging['timestamp'] / 1000)
        end

        def typing_on
          payload = {
            recipient: sender,
            sender_action: 'typing_on'
          }

          Facebook::Messenger::Bot.deliver(payload, access_token: access_token)
        end

        def typing_off
          payload = {
            recipient: sender,
            sender_action: 'typing_off'
          }

          Facebook::Messenger::Bot.deliver(payload, access_token: access_token)
        end

        def mark_seen
          payload = {
            recipient: sender,
            sender_action: 'mark_seen'
          }

          Facebook::Messenger::Bot.deliver(payload, access_token: access_token)
        end

        def reply(message)
          payload = {
            recipient: sender,
            message: message
          }

          Facebook::Messenger::Bot.deliver(payload, access_token: access_token)
        end

        def access_token
          Facebook::Messenger.config.provider.access_token_for(recipient)
        end
      end
    end
  end
end
