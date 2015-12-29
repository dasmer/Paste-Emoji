task :default do
  Rake::Task["keys"].execute
  puts 'Installing Carthage Dependencies'
  system('carthage bootstrap --platform iOS')
end

task :keys do
  if (File.file?('./Paste/Key.swift'))
    puts "Using existing ./Paste/Key.swift"
  else
    puts "Creating ./Paste/Key.swift"
    FileUtils.cp('./Scripts/Resources/Key.swift', './Paste')
  end
end

task :update do
  puts 'Updating Carthage Dependencies'
  system('carthage update --platform iOS')
end
