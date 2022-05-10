require 'fileutils'

command = ARGV[0].to_sym
time = ARGV[1].to_i || 5

commands = [
  :rec,
  :vid
]

return unless commands.include?(command)

puts "command: #{command}, time: #{time}"

def screenshot
  filename = Time.now.to_s
  `screencapture -t jpg -x "./screenshots/#{filename}.jpg"`
end

def auto_screenshot(time)
  loop do
    screenshot
    sleep time
  end
end

def create_video
  filename = Time.now.to_s
  `ffmpeg -framerate 2 -pattern_type glob -i "screenshots/*.jpg" -c:v libx264 -r 30 -pix_fmt yuv420p videos/"#{filename}.mp4"`
  FileUtils.rm_f(Dir.glob('screenshots/*'))
end

auto_screenshot(time) if command == :rec
create_video if command == :vid

