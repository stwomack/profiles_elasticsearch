#Custom Puppet Module Scaffold

class profiles_elasticsearch::data (
  $version_number    = $::profiles_elasticsearch::params::version_number,
  $pip_dependencies  = $::profiles_elasticsearch::params::pip_dependencies,
  $instance_name     = $::profiles_elasticsearch::params::instance_name,
  $cluster_name      = $::profiles_elasticsearch::params::cluster_name,
  $user              = $::profiles_elasticsearch::params::user,
  $group             = $::profiles_elasticsearch::params::group,
  $days_to_keep_data = $::profiles_elasticsearch::params::days_to_keep_data,
  $node_name         = $::profiles_elasticsearch::params::node_name,
  $master_hosts      = $::profiles_elasticsearch::params::master_hosts,
  $data_path         = $::profiles_elasticsearch::params::data_path,
) inherits ::profiles_elasticsearch::params {

  class { 'profiles_elasticsearch':
    version_number    => $version_number,
    pip_dependencies  => $pip_dependencies,
    instance_name     => $instance_name,
    cluster_name      => "logging-${::environment}",
    user              => $user,
    group             => $group,
    days_to_keep_data => $days_to_keep_data,
    node_master       => false,
    node_name         => "${::hostname}_data",
    node_data         => true,
    master_hosts      => $master_hosts,
    data_path         => $data_path,
  }
}
