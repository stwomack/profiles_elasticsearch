#Custom configuration params

class profiles_elasticsearch::params() {
  $es_heap_size      = '4g'
  $version_number    = '1.7.3'
  $repo_version      = '1.7'
  $instance_name     = "es-${::environment}"
  $cluster_name      = "logging-${::environment}"
  $pip_dependencies  = ['elasticsearch-curator']
  $data_path         = '/elkdata'
  $master_hosts      = ['master01.example.com', 'master02.example.com', 'master03.example.com']
  $user              = 'elasticsearch'
  $group             = 'elasticsearch'
  $days_to_keep_data = 12
  $node_data         = true
  $node_master       = true
  $node_name         = $::hostname
  $java_install      = true
  $java_package      = 'java-1.8.0-openjdk.x86_64'
}
