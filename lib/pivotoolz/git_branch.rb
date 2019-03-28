require 'json'

class GitBranch
  def generate(story_id, *append)
    if !story_id
      puts "#{GitBranch.usage_message}"
      exit
    end

    story = get_pivotal_story(story_id)

    author      = set_author
    category    = set_category(story['story_type'])
    description = set_description(story['name'])
    pivotal_id  = story['id']
    append      = set_append_values(append)

    create_branch("#{author}/#{category}/#{description}-#{pivotal_id}#{append}")
  end

  private

  def create_branch(branch_name)
    `git checkout -b #{branch_name}`
    if $?.exitstatus == 128
      puts 'Checking out existing branch...'
      `git checkout #{branch_name}`
    end
  end

  def get_pivotal_story(pivotal_id)
    unless ENV['PIVOTAL_TRACKER_API_TOKEN']
      puts "!: You need to set the 'PIVOTAL_TRACKER_API_TOKEN' environment variable"
      exit
    end

    story = JSON.parse(`get-story-info-from-id #{pivotal_id.tr('#', '')}`)
  end

  def set_author
    author_name = get_author_initials || get_author_name || get_whoami || 'unknown'
    clean_text(author_name)
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
    clean_text(description)
  end

  def set_append_values(appendings)
    return '' if appendings.empty?
    clean_appendings = appendings.map{|appending| clean_text(appending) }
    "-#{clean_appendings.join('-')}"
  end

  def clean_text(string_value)
    string_value.tr!(':_,/.&!@#$%^*()[]\'`<>"', '') # remove unwanted punctuation
    string_value.tr!('-', ' ') # replace dashes with space
    string_value.downcase! # convert to lowercase
    string_value.gsub!(/ +/,'-') # collapse spacing and replace spaces with dashes
    string_value[0 .. 35].gsub(/-$/, '') # limit to 45 chars
  end

  def self.usage_message
    "Usage : pv-git-branch '<pivotal_story_id>' '[<appended_branchname_values>...]'"
  end
end
