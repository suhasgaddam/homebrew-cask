# frozen_string_literal: true

cask "fender-device-manager" do
  version "1.1,10132"
  sha256 "44d5dabb231da9b95ca926f2e6fd5d65651e0d1fd3aa7d1491361291742d8b2e"

  url "https://www.fmicassets.com/Damroot/Original/#{version.csv.second}/Fender-Device-Manager_v#{version.csv.first.dots_to_underscores}.dmg",
      verified: "fmicassets.com/Damroot/Original/"
  name "Fender Device Manager"
  desc "Firmware update utility for Fender Mustang amplifiers and devices"
  homepage "https://support.fender.com/hc/en-us/articles/45453482607899-Fender-Mustang-Micro-Plus-Firmware-Update-Instructions"

  livecheck do
    url "https://support.fender.com/api/v2/help_center/en-us/articles/45453482607899.json"
    regex(%r{/Damroot/Original/(\d+)/Fender[._-]Device[._-]Manager_v?(\d+(?:[._-]\d+)+)\.dmg}i)
    strategy :json do |json, regex|
      match = json.dig("article", "body")&.match(regex)
      next if match.blank?

      "#{match[2].tr("_", ".")},#{match[1]}"
    end
  end

  depends_on macos: :monterey

  app "Device Manager.app", target: "Fender Device Manager.app"

  zap trash: [
    "~/Library/Application Support/Fender Device Manager",
    "~/Library/Caches/com.fender.devicemanager",
    "~/Library/Preferences/com.fender.devicemanager.plist",
    "~/Library/Saved Application State/com.fender.devicemanager.savedState",
  ]
end
