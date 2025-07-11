module UsersHelper
  def avatar_for(user, size: 100)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=identicon"
    image_tag(
      gravatar_url,
      alt: user.username,
      class: "rounded-circle mb-3",
      size: "#{size}x#{size}"
    )
  end
end
