require "ecr/macros"
module BoboBot
  # Lunch  Response
  module Commands
    class Dinner < BaseCommand
      def initialize
        @command = "dinner"
        time = (Time.utc_now + 9.hours).to_s("%Y%m%d") # Tokyo time
        @lunch_response = ::LunchApi.get_data(time)
        @Flr9 = @lunch_response.data.select { |d| d.cafeteriaId == "9F" && d.mealTime == 2 }
        @Flr22 = @lunch_response.data.select { |d| d.cafeteriaId == "22F" && d.mealTime == 2 }
        @CurrentFloorLunch = @Flr9
        @CurrentFloorName = "9F"
      end

      def json
        {
          color: "blue",
          message: html,
          notify: false,
          message_format: "html"
        }.to_json
      end

      def html
        io = MemoryIO.new
        @CurrentFloorLunch = @Flr9
        @CurrentFloorName = "9F"        
        ECR.embed "src/bobo_bot/commands/lunch.ecr", io
        @CurrentFloorLunch = @Flr22
        @CurrentFloorName = "22F"
        ECR.embed "src/bobo_bot/commands/lunch.ecr", io
        io.to_s
      end
    end
  end
end
