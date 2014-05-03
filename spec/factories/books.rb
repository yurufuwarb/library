# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :book do
    type "0"

    factory :rails_book do
      name "RailsによるアジャイルWebアプリケーション開発"
      outline "RailsでWebアプリ開発が学べる本"
    end

    factory :ruby_book do
      name "たのしいRuby"
      outline "たのしくRubyが学べる本"
    end

    factory :name_length_31 do
      name "1234567890123456789012345678901"
      outline "本の概要"
    end

    factory :outline_length_51 do
      name "本の名前"
      outline "123456789012345678901234567890123456789012345678901"
    end
  end
end
