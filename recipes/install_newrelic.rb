if node.solr.newrelic.api_key.to_s.empty?
  log('no solr api_key set, skipping installation of newrelic.jar') { level :info }
else
  log('solr api_key set, installation of newrelic.jar') { level :info }

  directory File.dirname(node.solr.newrelic.jar) do
    owner node.solr.jetty_user
    mode 0755
  end

  remote_file node.solr.newrelic.jar do
    source 'http://download.newrelic.com/newrelic/java-agent/newrelic-agent/3.28.0/newrelic-agent-3.28.0.jar'
    mode '0744'
    not_if { File.file?(node.solr.newrelic.jar) }
  end

  log("node.solr.newrelic -> #{node.solr.newrelic.inspect}") { level :info }

  template ::File.join(::File.dirname(node.solr.newrelic.jar), 'newrelic.yml') do
    source 'newrelic.yml.erb'
    owner node.solr.jetty_user
    mode 0644
    variables(newrelic: node.solr.newrelic)
  end
end
