# frozen_string_literal: true

module Services
  # used to fill ip by dns name
  class FillIp
    def call(data)
      nameservers =
        Array(data.dig(:whois_record, :nameservers)).map do |item|
          item.merge(ipv4: item[:ipv4] || get_ipv4(item[:name])).compact
        end

      data[:whois_record][:nameservers] = nameservers
      data
    end

    private



    def get_ipv4(name)
      IPSocket.getaddress(name)
      rescue SocketError
    end
  end
end
