$clonedir = "/repositories"
$reponame = "mihini-repo"
$execdir = "/mihini"


file { $clonedir:
  ensure => directory,
  before => Exec['clone']
}

package { 'cmake':
  ensure => present,
  before => Exec['build']
}
    
package { 'build-essential':
  ensure => present,
  before => Exec['build']
}

package { 'libreadline-dev':
  ensure => present,
  before => Exec['build']
}

package { 'git':
  ensure => present,
  before => Exec['clone']
}

exec {'clone':
  command => "git clone git://git.eclipse.org/gitroot/mihini/org.eclipse.mihini.git $reponame",
  cwd     => "$clonedir",
  creates => "$clonedir/$reponame",
  path    => ["/usr/bin", "/usr/sbin"]
}

exec {'build':
  command => "$clonedir/$reponame/bin/build.sh",
  creates => "$clonedir/$reponame/build.default",
  cwd     => "$clonedir/$reponame",
  require => Exec['clone']
}

exec {'lua':
  command => "make lua",
  cwd     => "$clonedir/$reponame/build.default",
  creates => "$clonedir/$reponame/build.default/runtime/bin/lua",
  path    => ["/usr/bin", "/usr/sbin"],
  require => Exec['build']
}

file {$execdir:
  source => "$clonedir/$reponame/build.default/runtime/",
  recurse => true,
  ensure => directory,
  require => Exec['lua']
}

file {'/etc/init.d/mihini':
  ensure => file,
  content => "#! /bin/sh
# /etc/init.d/mihini
#


case \"\$1\" in
  start)
    sudo $execdir/bin/appmon_daemon -a $execdir/start.sh -w $execdir -u root -g root -n 5 2>&1 | logger -t Mihini &
    ;;
  stop)
    killall agent
    killall appmon_daemon
    ;;
  *)
    echo \"Usage: /etc/init.d/mihini {start|stop}\"
    exit 1
    ;;
esac

exit 0",
  mode   => 0755,
  require => File[$execdir] 
}

exec {'daemon':
  command => "update-rc.d mihini defaults",
  require => File['/etc/init.d/mihini'],
  path    => ["/usr/bin", "/usr/sbin"]
}