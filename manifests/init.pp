#Custom Puppet Module Scaffold

class profiles_elasticsearch (
  $es_heap_size      = $::profiles_elasticsearch::params::es_heap_size,
  $version_number    = $::profiles_elasticsearch::params::version_number,
  $repo_version      = $::profiles_elasticsearch::params::repo_version,
  $pip_dependencies  = $::profiles_elasticsearch::params::pip_dependencies,
  $instance_name     = $::profiles_elasticsearch::params::instance_name,
  $cluster_name      = $::profiles_elasticsearch::params::cluster_name,
  $user              = $::profiles_elasticsearch::params::user,
  $group             = $::profiles_elasticsearch::params::group,
  $days_to_keep_data = $::profiles_elasticsearch::params::days_to_keep_data,
  $node_master       = $::profiles_elasticsearch::params::node_master,
  $node_name         = $::profiles_elasticsearch::params::node_name,
  $node_data         = $::profiles_elasticsearch::params::node_data,
  $master_hosts      = $::profiles_elasticsearch::params::master_hosts,
  $data_path         = $::profiles_elasticsearch::params::data_path,
  $java_install      = $::profiles_elasticsearch::params::java_install,
  $java_package      = $::profiles_elasticsearch::params::java_package,
) inherits ::profiles_elasticsearch::params {

  $config_hash = {
    'ES_USER'  => $user,
    'ES_GROUP' => $group,
    'ES_HEAP_SIZE' => $es_heap_size,
  }

  class { 'elasticsearch':
    autoupgrade  => true,
    manage_repo  => true,
    repo_version => $repo_version,
    package_url  => "https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-${version_number}.noarch.rpm",
    java_install => $java_install,
    java_package => $java_package,
    config  => {
      'cluster.name'                 => $cluster_name,
      'threadpool.search.queue_size' => '10000',
    },
    init_defaults => $config_hash,
  }

  elasticsearch::instance { $instance_name:
    config => {
      'node.name'                                                                     => $node_name,
      'node.master'                                                                   => $node_master,
      'node.data'                                                                     => $node_data,
      'discovery.zen.ping.multicast.enabled'                                          => false,
      'discovery.zen.minimum_master_nodes'                                            => (size($master_hosts)/2) + 1,
      'discovery.zen.ping.unicast.hosts'                                              => $master_hosts,
      'action.destructive_requires_name'                                              => true,
      'bootstrap.mlockall'                                                            => true,
      'watcher.actions.email.service.account.work.profile'                            => 'cf_admins',
      'watcher.actions.email.service.account.work.email_defaults.from'                => 'people@example.com',
      'watcher.actions.email.service.account.work.smtp.auth'                          => 'false',
      'watcher.actions.email.service.account.work.smtp.starttls.enable'               => 'false',
      'watcher.actions.email.service.account.work.smtp.host'                          => 'mailhost.example.com',
      'watcher.actions.email.service.account.work.smtp.port'                          => '25',

    },
#    https://www.elastic.co/guide/en/watcher/current/watch-cluster-status.html
    datadir => ["${data_path}/${instance_name}"],
    before  => Class['profiles_elasticsearch::curator']
  }

  elasticsearch::plugin{'elasticsearch/license/latest':
    ensure     => 'present',
    instances  => $instance_name,
  }

  elasticsearch::plugin{'elasticsearch/watcher/latest':
    ensure     => 'present',
    instances  => $instance_name,
  }

  elasticsearch::plugin{'elasticsearch/marvel/latest':
    ensure     => 'present',
    instances  => $instance_name,
  }

  elasticsearch::plugin{'elasticsearch/shield/latest':
    ensure     => 'absent',
    instances  => $instance_name,
  }

  class { 'profiles_elasticsearch::curator':
    pip_dependencies  => $pip_dependencies,
    user              => $user,
    days_to_keep_data => $days_to_keep_data,
  }
}
