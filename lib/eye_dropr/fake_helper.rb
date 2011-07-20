module EyeDropr
  module FakeHelper
    class << self
      def register(map)
        map.each_pair do |uri, file_stem|
          path = Rails.root + 'test' + 'fixtures' + 'fakeweb' + "#{file_stem}.fake"
          FakeWeb.register_uri(:get, uri, :body => IO.read(path))
        end
      end
    end
  end
end
