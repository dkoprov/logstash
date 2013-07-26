require "logstash/namespace"
require "logstash/outputs/base"

# This output lets you store logs in sphinx.
#
# You can learn more about sphinx at <http://http://sphinxsearch.com>
#
# ## Operational Notes
#
# You need to copy the sphinx.conf (wget https://raw.github.com/dkoprov/rt_sphinx/master/sphinx.conf )
# to the $PWD of the logstash process
#
# Your firewalls will need to permit port 9327 in *both* directions (from
# logstash to sphinx, and sphinx to logstash)

class LogStash::Outputs::Sphinx < LogStash::Outputs::Base

  config_name "sphinx"
  milestone 1

  def register
    require "rt_sphinx"
    RtSphinx::Manager.start
  end # def register

  def receive(event)
    return unless output?(event)
    RtSphinx::Query.new.insert(event.timestamp, event['message'], event.to_json)
  end # def receive

  def teardown
    RtSphinx::Manager.stop
  end # def teardown
end # class LogStash::Outputs::Sphinx
