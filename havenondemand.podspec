Pod::Spec.new do |s|
  s.name             = "havenondemand"
  s.version          = "1.0.6"
  s.summary          = "Easily make requests to Haven OnDemand's APIs using Swift"
  s.description      = <<-DESC
                       This library allows you to quickly and easily make requests to Haven OnDemand using Swift.
                       DESC
  s.homepage         = "https://github.com/HPE-Haven-OnDemand/havenondemand-ios-swift"
  s.license          = { :type => 'MIT',
                         :file => "LICENSE"}
  s.authors          = { "Paco Vu" => "paco.vu@gmail.com"}
  s.source           = { :git => "https://github.com/HPE-Haven-OnDemand/havenondemand-ios-swift.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/HavenOnDemand'

  s.platform         = :ios, '9.3'
  s.requires_arc     = true

  s.source_files     = "HODClient/lib/*"

end
