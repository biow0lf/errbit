class ApplicationMailer < ActionMailer::Base
  layout 'mailer'
  default :from                      => Errbit::Config.email_from,
          'X-Errbit-Host'            => Errbit::Config.host,
          'X-Mailer'                 => 'Errbit',
          'X-Auto-Response-Suppress' => 'OOF, AutoReply',
          'Precedence'               => 'bulk',
          'Auto-Submitted'           => 'auto-generated'
end
