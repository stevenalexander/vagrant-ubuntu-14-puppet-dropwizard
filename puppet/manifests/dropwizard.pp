include dropwizard_service

class { "java":
    package => "openjdk-7-jre",
    before  => Class['dropwizard_service'],
}