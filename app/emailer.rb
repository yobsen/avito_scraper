require 'mail'
Mail.defaults do
  delivery_method :smtp,
                  address: 'smtp.yandex.ru',
                  tls: true,
                  port: 465,
                  user_name: Settings.emailer.from,
                  password: Settings.emailer.password,
                  authentication: 'plain',
                  enable_starttls_auto: true
end

class Emailer
  def self.find_last_report
    Dir.glob('reports/*').max_by { |f| File.mtime(f) }
  end

  def self.call
    report = find_last_report

    Mail.deliver do
      from     Settings.emailer.from
      to       Settings.emailer.to
      subject  'Avito Scraper'
      body report
      add_file report
    end
  end
end
