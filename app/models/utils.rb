class Utils
  # Returns the hash digest of the given string.
    def self.digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # Returns a random token.
    def self.new_token(n = nil)
      n ? SecureRandom.urlsafe_base64(n) : SecureRandom.urlsafe_base64
    end

    # # Returns an alphanumeric token with values a-z A-Z and 0-9
    def self.new_alphanumeric_token(start_with = nil, n = 10)
      token = start_with ? start_with + new_token(n) : new_token(n)
      i = SecureRandom.random_number(allowedChars.size)
      token.gsub!(/[-_]/, allowedChars[i])
      return token
    end

    # Returns the string used to split/join strings accross the app #
    def self.split_string
      ' | '
    end

    def self.args_for_mysql(args)
      if args.at(',') == ','
        args = args.split(',')
        args.each do |arg|
          arg.strip!
        end
        args=args.join('|')
        operator = 'REGEXP'
      else
        args = '%'+args.strip+'%'
        operator = 'LIKE'
      end

      return {args: args, operator: operator}
    end

    private
      def self.allowedChars
        # do not use l nor I because they are pretty the same with Roboto Font
        %w[a b c d e f g h i j k m n o p q r s t u v w x y z
          A B C D E F G H J K L M N O P Q R S T U V W X Y Z
          0 1 2 3 4 5 6 7 8 9]
      end
end
