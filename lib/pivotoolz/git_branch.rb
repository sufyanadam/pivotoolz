require 'json'

class GitBranch
  def generate(story_id)
    if !story_id
      puts "#{GitBranch.usage_message}"
      exit
    end

    story = get_pivotal_story(story_id)

    author      = set_author
    category    = set_category(story['story_type'])
    description = set_description(story['name'])
    pivotal_id  = story['id']

    "#{author}/#{category}/#{description}-#{pivotal_id}"
  end

  private

  def get_pivotal_story(pivotal_id)
    unless ENV['PIVOTAL_TRACKER_API_TOKEN']
      puts "!: You need to set the 'PIVOTAL_TRACKER_API_TOKEN' environment variable"
      exit
    end

    story = JSON.parse(`get-story-info-from-id #{pivotal_id.tr('#', '')}`)
  end

  def set_author
    author_name = get_author_initials || get_author_name || get_whoami || 'unknown'
    author_name.downcase!
    author_name.tr!('.@!#$%^\&*()', '')
    author_name.tr(' ', '+')
  end

  def get_author_initials
    initials = `git config user.initials`.strip
    initials unless initials.empty?
  end

  def get_author_name
    name = `git config user.name`.strip
    name unless name.empty?
  end

  def get_whoami
    you = `whoami`.strip
    you unless you.empty?
  end

  def set_category(category)
    category + 's'
  end

  def set_description(description)
    description.tr!(':_,/.&!@#$%^*()[]\'`<>"', '') # remove unwanted punctuation
    description.tr!('-', ' ') # replace dashes with space
    description.downcase! # convert to lowercase
    description.gsub!(/ +/,'-') # collapse spacing and replace spaces with dashes
    description[0 .. 45].gsub(/-$/, '')
  end

  def self.usage_message
    "Usage : pv-git-branch '[pivotal_story_id]'"
  end
end
