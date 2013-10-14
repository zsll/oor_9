class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :omniauth_providers => [:facebook]
  #:database_authenticatable, :registerable,
  #:recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :provider, :uid, :first_name, :last_name, :email, :image, :oauth_token, :gender, :oauth_expires_at # facebook 
  # attr_accessible :title, :body
  
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    #category_id = UserCategory.find(:first, :conditions => ["name = ?", "Individual"])

    #puts auth.inspect
=begin
#<OmniAuth::AuthHash credentials=#<Hashie::Mash expires=true expires_at=1349564408 token="AAADonWqD06YBAOp4sZAuPFWZBZAm1Oc9mYkWw8ovkSZCT3aBdBDvH6gPZAheZBQbFZCR8nR2Q432HZAbnZAGV86tV4mS1WWu6c6qHu11Mcw1nzwZDZD"> 
extra=#<Hashie::Mash raw_info=#<Hashie::Mash education=[#<Hashie::Mash school=#<Hashie::Mash id="23680344606" name="Arizona State University"> type="College">, #<Hashie::Mash school=#<Hashie::Mash id="114923318519339" name="University of Science and Technology of China"> type="College">] email="tristan.liu@live.cn" first_name="Yangzi" gender="male" id="1602621290" last_name="Liu" link="http://www.facebook.com/yangzi.liu.9" locale="en_US" name="Yangzi Liu" timezone=-7 updated_time="2012-08-06T02:31:00+0000" username="yangzi.liu.9" verified=true work=[#<Hashie::Mash employer=#<Hashie::Mash id="23680344606" name="Arizona State University">>]>> 
info=#<OmniAuth::AuthHash::InfoHash email="tristan.liu@live.cn" first_name="Yangzi" image="http://graph.facebook.com/1602621290/picture?type=square" last_name="Liu" name="Yangzi Liu" nickname="yangzi.liu.9" urls=#<Hashie::Mash Facebook="http://www.facebook.com/yangzi.liu.9"> verified=true> provider="facebook" uid="1602621290"
=end
    unless user
      user = User.create(
      #name:auth.extra.raw_info.name,
      first_name:auth.extra.raw_info.first_name,
      last_name:auth.extra.raw_info.last_name,
      #category_id:category_id,
      provider:auth.provider,
      uid:auth.uid,
      email:auth.uid + auth.info.email,
      image:auth.info.image.sub!("type=square", "width=200&height=200"), #get a larger profile picture for profile page, turns out not square
      oauth_token:auth.credentials.token,
      gender:auth.extra.raw_info.gender,
      #refresh_token:auth.credentials.refresh_token
      oauth_expires_at:Time.at(auth.credentials.expires_at) )
    else
      #the token expires in 90 days, won't be updated during every login
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.image = auth.info.image.sub!("type=square", "width=200&height=200") #incase the user edited profile
      user.save
    end
    user
  end
  
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
