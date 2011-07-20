Skyfarm::Application.config.middleware.use ExceptionNotifier,
  :email_prefix => "[ERROR] ",
  :sender_address => '"Skyfarm Errors" <bot@skyfarmsf.com>',
  :exception_recipients => ['rmatei@gmail.com']