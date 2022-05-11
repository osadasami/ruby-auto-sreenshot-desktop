require 'fileutils'

command = ARGV[0].to_sym
time = ARGV[1].to_i || 5

commands = [
  :rec,
  :vid,
  :ts,
  :build
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
end

def remove_screenshots
  FileUtils.rm_f(Dir.glob('screenshots/*'))
end

def draw_timestamp_all
  screens_path = Dir['screenshots/*.jpg']

  screens_path.each_with_index do |screen, i|
    puts "[#{i+1}/#{screens_path.size}]"

    draw_timestamp(screen)
  end
end

def draw_timestamp(path)
  text = File.basename(path, '.*')
  `
  convert "#{path}" \
          -font courier \
          -pointsize 28 \
          -gravity SouthEast \
          -fill black -draw "text 10,10 '#{text}'" \
          -fill white -draw "text 12,12 '#{text}'" \
          "screenshots/#{text}.jpg"
  `
end

def build
  draw_timestamp_all
  create_video
  remove_screenshots
end

auto_screenshot(time) if command == :rec
draw_timestamp_all if command == :ts
create_video if command == :vid
build if command == :build
