require File.expand_path('../config/environment', __dir__)

require 'telegram/bot'

token = '1805801654:AAFzamsFKtlOqXB5KkFHuBa-ekxnSdaLxa0'

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    #Определяем есть ли пользователь в базе
    if !User.exists?(telegram_id: message.from.id)
      user = User.create(telegram_id: message.from.id, firstname: message.from.first_name, lastname: message.from.last_name, query: message.text)
    else
      user = User.find_by(telegram_id: message.from.id)
    end
    c = Product.last
    case user.action
    when 'add'
      Product.create(name: message.text)
      user.action = 'add category'
      user.save
      bot.api.send_message(chat_id: message.from.id, text: 'А теперь пришли название категории')
    when 'add category'
      c.category = message.text
      c.save
      user.action = 'add image'
      user.save
      bot.api.send_message(chat_id: message.from.id, text: 'А теперь скрин')
    when 'add image'
      # c.image = message.document.file_id
      c.image = message.photo
      c.save
      user.action = nil
      user.save
      bot.api.send_message(chat_id: message.from.id, text: 'Заебумба, какой ты молодец...')
    when 'delete'
      product = Product.where('name ILIKE ?', '%' + message.text + '%')
      if product.empty?
        bot.api.send_message(chat_id: message.from.id, text: 'Товар не существует')
      else
      product.last.destroy
      user.action = nil
      user.save
      bot.api.send_message(chat_id: message.from.id, text: 'Заебумба, удалено...')
      end
    end

    case message.text
    when '/add'
      user.action = 'add'
      user.save
      bot.api.send_message(chat_id: message.from.id, text: 'Введи название товара')
    when '/edit'
      user.action = 'edit'
      user.save
      bot.api.send_message(chat_id: message.from.id, text: 'Введи название товара, который хочешь отредактировать')
    when '/delete'
      user.action = 'delete'
      user.save
      bot.api.send_message(chat_id: message.from.id, text: 'Введи название товара, который хочешь удалить')
    else
      product = Product.where('name ILIKE ?', '%' + message.text + '%')
      if product.empty?
        bot.api.send_message(chat_id: message.from.id, text: 'Прости, я пока что не могу найти этот товар=(((((')
      else
        bot.api.send_photo(chat_id: message.chat.id, photo: Faraday::UploadIO.new("./public#{product.last.image_url}", 'image/jpeg'))
      end
    end
  end
end
