module Facebook
  module Messenger
    module Incoming
      # The Message class represents an incoming Facebook Messenger message.
      class Message
        include Facebook::Messenger::Incoming::Common

        def id
          @messaging['message']['mid']
        end

        def seq
          @messaging['message']['seq']
        end

        def text
          @messaging['message']['text']
        end

        def echo?
          @messaging['message']['is_echo']
        end

        def attachments
          @messaging['message']['attachments']
        end

        def app_id
          @messaging['message']['app_id']
        end

        def quick_reply
          return unless @messaging['message']['quick_reply']

          @messaging['message']['quick_reply']['payload']
        end

        def message_object
          @message_object ||= Unirest.get("https://graph.facebook.com/v2.6/m_#{id}", parameters: {
            access_token: access_token,
            fields: "to,from"
          }).body
        end

        def sender_info
          @sender_info ||= Unirest.get("https://graph.facebook.com/v2.6/#{message_object['from']['id']}", parameters: {
            access_token: access_token,
            fields: "first_name,last_name,locale,timezone,gender"
          }).body
        end

        def recipient_info
          @recipient_info ||= message_object.dig('to', 'data', '0') || {}
        end

      end
    end
  end
end
