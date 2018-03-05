# Pivotoolz

Ever forget to deliver a story while waiting for your continuous
deployment build to go green and deployment to finish? Never let
another story slip through the cracks into production again with
Pivotoolz! Ever wish stories would deliver themselves on successful
deployment? This gem is for you!

Pivotoolz is a set of tools to automate your development process when
using Pivotal Tracker for managing your backlog. Save yourself time
and increase your productivity. Use the tools individually or compose
them together to automate anything related to pivotal tracker stories.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pivotoolz'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pivotoolz

## Usage

Pivotoolz is a collection of tiny programs that can be used individually
or composed together for more powerful features. The manner of usage of
each is described below:

### `deliver-deployed-stories`

Deliver all stories that have been deployed to the given
environment since the previous and last deployment.

Example:
`bundle exec deliver-deployed-stories ENVIRONMENT`

Where `ENVIRONMENT` is the environment you consider to be where stories
can be accepted/rejected.

Example:
Let's say we have an `acceptance` environment where we deploy our app to
test out stories. As long as we label our deployed git SHAs with tags
(using `tag-it`), we can automatically deliver any finished stories
that went out in the last deployment by simply running the command:

`bundle exec deliver-deployed-stories acceptance`

### `deliver-story`

Deliver a given story provided in JSON format. The minimum JSON attributes
required are `id` and `current_state`

Typically used with output from `get-story-info-from-id` piped in.

Example:
`bundle exec get-story-info-from-id STORY_ID | bundle exec deliver-story`
  OR
`bundle exec deliver-story '{"id": 123, "current_state": "finished"}'`

If `current_state` is not `finished`, the story will not be delivered.

### `stories-deployed`

Returns a list of all stories deployed to a given environment.

Output is of the form:

STORY_TITLE:
LINK_TO_STORY

STORY_TITLE:
LINK_TO_STORY

Example:
```
bundle exec stories-deployed production
# Output:

Update README:
https://www.pivotaltracker.com/story/show/123

Update dependencies
https://www.pivotaltracker.com/story/show/456

```

Use with `post-slack-message` to post a message in a slack deployment channel
with the list of stories that just got deployed.

### `post-slack-message`

Post a message to a slack channel. You will need to [setup
a webhook integration](https://api.slack.com/incoming-webhooks) on slack first.
Once you have done so, copy your Webhook URL into
an environment variable `SLACK_WEBHOOK_URL`.
If the `SLACK_WEBHOOK_URL` has been defined correctly, you will
be able to post a message in slack to any channel as follows:
`bundle exec post-slack-message CHANNEL "MESSAGE_TEXT"`
Where CHANNEL is of the form "#channel" or "@user".

You can also pipe a message to the `post-slack-message` program. For
example:
`{ echo Stories deployed to production:; bundle exec stories-deployed production; } | bundle exec post-slack-message '#production-deploys'`

### `story-ids-deployed`

Returns a newline delimited list of all story ids deployed
to the given environment.

Example:
```
bundle exec story-ids-deployed production

# Output:
123
456

```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sufyanadam/pivotoolz. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Pivotoolz project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sufyanadam/pivotoolz/blob/master/CODE_OF_CONDUCT.md).
