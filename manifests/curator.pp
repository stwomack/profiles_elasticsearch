# Curator is a tool used to remove data from elastic search after x number of days

class profiles_elasticsearch::curator(
  $pip_dependencies   = $::profiles_elasticsearch::params::pip_dependencies,
  $user               = $::profiles_elasticsearch::params::user,
  $days_to_keep_data  = $::profiles_elasticsearch::params::days_to_keep_data
) {
  include python

  each($pip_dependencies) | $name | {
    python::pip { $name :
      pkgname => $name,
      require => Class['python']
    }
  }

  cron { 'curator':
    command => "curator delete indices --older-than ${days_to_keep_data} --time-unit days --timestring %Y.%m.%d >> /var/log/curator.log",
    user    => $user,
    hour    => 2,
    minute  => 0
  }
}
