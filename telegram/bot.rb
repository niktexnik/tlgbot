require File.expand_path('../config/environment', __dir__)

require 'telegram/bot'

token = '1805801654:AAFzamsFKtlOqXB5KkFHuBa-ekxnSdaLxa0'

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    if !User.exists?(telegram_id: message.from.id)
      user = User.create(telegram_id: message.from.id, firstname: message.from.first_name, lastname: message.from.last_name, query: message.text)
    else
      user = User.find_by(telegram_id: message.from.id)
    end
    case message.text
    when '/add'
      print 'OK'
    else
      find = Product.where('name ILIKE ?', '%' + message.text + '%')
      if find.empty?
        bot.api.send_message(chat_id: message.from.id, text: 'Прости, я пока что не могу найти этот товар=(((((')
      else
        bot.api.send_photo(chat_id: message.chat.id, photo: Faraday::UploadIO.new("./public#{find.last.image_url}", 'image/jpeg'))
      end
    end
  end
end
