require 'spec_helper'

describe BookController do
  describe "#index" do
  end

  describe "#create" do
    context "typeが指定されていない場合" do
      it "「result：-1、error_code：1」が返却されること" do
        post :create, attributes_for(:rails_book).delete(:type)
        result = JSON.parse(response.body)
        expect(result["result"]).to eq -1
        expect(result["error"]["error_code"]).to eq 1
      end
    end

    context "nameが指定されていない場合" do
      it "「result：-1、error_code：1」が返却されること" do
        post :create, attributes_for(:rails_book).delete(:name)
        result = JSON.parse(response.body)
        expect(result["result"]).to eq -1
        expect(result["error"]["error_code"]).to eq 1
      end
    end

    context "outlineが指定されていない場合" do
      it "「result：-1、error_code：1」が返却されること" do
        post :create, attributes_for(:rails_book).delete(:outline)
        result = JSON.parse(response.body)
        expect(result["result"]).to eq -1
        expect(result["error"]["error_code"]).to eq 1
      end
    end

    context "「type：2」が指定された場合" do
      it "「result：-1、error_code：2」が返却されること" do
        post :create, attributes_for(:rails_book, type: 2)
        result = JSON.parse(response.body)
        expect(result["result"]).to eq -1
        expect(result["error"]["error_code"]).to eq 2
      end
    end

    context "「type：-1」が指定された場合" do
      it "「result：-1、error_code：2」が返却されること" do
        post :create, attributes_for(:rails_book, type: -1)
        result = JSON.parse(response.body)
        expect(result["result"]).to eq -1
        expect(result["error"]["error_code"]).to eq 2
      end
    end

    context "「name」が31文字で指定された場合" do
      it "「result：-1、error_code：3」が返却されること" do
        post :create, attributes_for(:name_length_31)
        result = JSON.parse(response.body)
        expect(result["result"]).to eq -1
        expect(result["error"]["error_code"]).to eq 3
      end
    end

    context "「outline」が51文字で指定された場合" do
      it "「result：-1、error_code：4」が返却されること" do
        post :create, attributes_for(:outline_length_51)
        result = JSON.parse(response.body)
        expect(result["result"]).to eq -1
        expect(result["error"]["error_code"]).to eq 4
      end
    end

    context "本が未登録の場合" do
      it "bookが1件登録され、「result：0、is_created：true」が返却されること" do
        rails_book = build(:rails_book)
        expect{
          post :create, attributes_for(:rails_book)
        }.to change(Book, :count).by(1)

        result = JSON.parse(response.body)
        expect(result["result"]).to eq 0
        expect(result["is_created"]).to be_true
        expect(result["book"]["type"]).to eq rails_book.type
        expect(result["book"]["name"]).to eq rails_book.name
        expect(result["book"]["outline"]).to eq rails_book.outline
      end

      context "かつ、「name」が30文字で指定された場合" do
        it "bookが1件登録され、「result：0、is_created：true」が返却されること" do
          rails_book = build(:rails_book, name: "123456789012345678901234567890")
          expect{
            post :create, rails_book.attributes.select{|k,v| k =~ /type|name|outline/}
          }.to change(Book, :count).by(1)

          result = JSON.parse(response.body)
          expect(result["result"]).to eq 0
          expect(result["is_created"]).to be_true
          expect(result["book"]["type"]).to eq rails_book.type
          expect(result["book"]["name"]).to eq rails_book.name
          expect(result["book"]["outline"]).to eq rails_book.outline
        end
      end

      context "かつ、「outline」が50文字で指定された場合" do
        it "bookが1件登録され、「result：0、is_created：true」が返却されること" do
          rails_book = build(:rails_book, outline: "12345678901234567890123456789012345678901234567890")
          expect{
            post :create, rails_book.attributes.select{|k,v| k =~ /type|name|outline/}
          }.to change(Book, :count).by(1)

          result = JSON.parse(response.body)
          expect(result["result"]).to eq 0
          expect(result["is_created"]).to be_true
          expect(result["book"]["type"]).to eq rails_book.type
          expect(result["book"]["name"]).to eq rails_book.name
          expect(result["book"]["outline"]).to eq rails_book.outline
        end
      end
    end

    context "本が既に登録されている場合" do
      it "登録済みの本が更新され、「result：0、is_created：false」が返却されること" do
        ruby_book = create(:ruby_book)
        expect{
          post :create, ruby_book.attributes.select{|k,v| k =~ /id|type|name|outline/}
        }.to change(Book, :count).by(0)

        result = JSON.parse(response.body)
        expect(result["result"]).to eq 0
        expect(result["is_created"]).to be_false
        expect(result["book"]["id"]).to eq ruby_book.id
        expect(result["book"]["type"]).to eq ruby_book.type
        expect(result["book"]["name"]).to eq ruby_book.name
        expect(result["book"]["outline"]).to eq ruby_book.outline
      end

      context "かつ、「name」が30文字で指定された場合" do
        it "登録済みの本が更新され、「result：0、is_created：false」が返却されること" do
          ruby_book = create(:ruby_book, name: "123456789012345678901234567890")
          expect{
            post :create, ruby_book.attributes.select{|k,v| k =~ /id|type|name|outline/}
          }.to change(Book, :count).by(0)

          result = JSON.parse(response.body)
          expect(result["result"]).to eq 0
          expect(result["is_created"]).to be_false
          expect(result["book"]["id"]).to eq ruby_book.id
          expect(result["book"]["type"]).to eq ruby_book.type
          expect(result["book"]["name"]).to eq ruby_book.name
          expect(result["book"]["outline"]).to eq ruby_book.outline
        end
      end

      context "かつ、「outline」が50文字で指定された場合" do
        it "登録済みの本が更新され、「result：0、is_created：false」が返却されること" do
          ruby_book = create(:ruby_book, outline: "12345678901234567890123456789012345678901234567890")
          expect{
            post :create, ruby_book.attributes.select{|k,v| k =~ /id|type|name|outline/}
          }.to change(Book, :count).by(0)

          result = JSON.parse(response.body)
          expect(result["result"]).to eq 0
          expect(result["is_created"]).to be_false
          expect(result["book"]["id"]).to eq ruby_book.id
          expect(result["book"]["type"]).to eq ruby_book.type
          expect(result["book"]["name"]).to eq ruby_book.name
          expect(result["book"]["outline"]).to eq ruby_book.outline
        end
      end
    end
  end

  describe "#destroy" do
  end
end
