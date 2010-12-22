#--------------------------------
projects        = ['rubythere','fake']
@github_username = 'keavy'
@local_username  = 'keavy'
#--------------------------------

def exe(cmd); puts cmd; system(cmd); end
def hr; " ----------------------------- "; end
def heading(text); puts "\n" + hr + text + hr + "\n\n"; end
def mention(text); puts "\n" + text + "\n"; end
def problem(text); puts "\n***\n" + text + "\n***\n"; end

def setup_database
  if File.exist?('config/database.yml')
    system "rake db:setup"
  elsif File.exist?('config/database_example.yml')
    system "cp config/database_example.yml config/database.yml"
    system "rake db:setup"
  else
    problem "no database.yml file for #{p}; couldn't setup db"
  end
end

def install_gems
  if File.exist?('Gemfile')
    system "bundle install"
  end
end

def existing_project(project)
  if File.directory?("/Users/#{@local_username}/Projects/#{project}")
    problem "#{project} already exists, skipping"
    return true
  end
end

heading("Cloning projects from github")
projects.each do |p|
  next if existing_project(p)

  if system "git clone git@github.com:/#{@github_username}/#{p}.git ~/Projects/#{p} > /dev/null 2> /dev/null"
    mention("- #{p}")
    system "p #{p}"

    install_gems

    setup_database

    system "cd .."
  end
end